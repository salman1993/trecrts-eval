module.exports = function(io){
  const util = require('util');
  var express = require('express')
  var router = express.Router();

  var registrationIds = []; // containts partids of all participants
  var loaded = false;
  var regIdx = 0;
  const RATE_LIMIT = 10; // max num of tweets per topic per client
  const ASSESSMENTS_PULL_LIMIT = 1; // max num of times client can pull assessments per 10 minutes
  const MAX_ASS = 3;
  const MAX_CLIENTS = 3;
  function genID(){
    var chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    var ID = '';
    for(var i=0; i < 12; i++)
      ID += chars.charAt(Math.floor(Math.random()*chars.length));
    return ID;
  }

  function validate(db,table,col, id,cb){
    db.query('select * from '+table+' where '+col+' = ?;',[id],cb);
  }

  function validate_group(db,groupid,cb){
    validate(db,'groups','groupid',groupid,cb);
  }

  function validate_client(db,clientid,cb){
    validate(db,'clients','clientid',clientid,cb);
  }

  function validate_participant(db,partid,cb){
    validate(db,'participants','partid',partid,cb);
  }
  function validate_client_or_participant(db,uniqid,cb){
    validate_client(db,uniqid,function(errors,results){
      if(errors || results.length === 0){
        validate_participant(db,uniqid,cb);
      }else{
        cb(errors,results);
      }
    });
  }
  function isValidTweet(str){
    return str.match('[0-9]=') !== null
  }

  var rel2id = {"notrel": 0, "rel": 1, "dup": 2}

  function generate_judgement_link(topid, tweetid, partid) {
    var hostname = "localhost:10101";
    // var hostname = "http://scspc654.cs.uwaterloo.ca";
    var link = util.format('%s/judge/%s/%s/%s', hostname, topid, tweetid, partid);
    return link;
  }

  // store judgements in the DB
<<<<<<< HEAD
  router.post('/judge/:topid/:tweetid/:rel/:partid', function(req,res){
    var topid = req.params.topid;
    var tweetid = req.params.tweetid;
    var rel = req.params.rel;
    var partid = req.params.partid;

    var devicetype = req.device.type.toLowerCase();
    // console.log("devicetype - ", devicetype);
=======
  router.post('/judge', function(req,res){
    var topid = req.body.topid;
    var tweetid = req.body.tweetid;
    var rel = req.body.rel;
    var partid = req.body.partid;    
    var useragent = req.body.useragent;
    var timetaken = req.body.timetaken;
    
    // console.log("topid - ", topid);
    // console.log("tweetid - ", tweetid);
    // console.log("partid - ", partid);
    // console.log("rel - ", rel);    
    // console.log("useragent - ", useragent);
    // console.log("timetaken - ", timetaken);
>>>>>>> 47bb42985634020c7a9b234443452e133d6c839a

    var db = req.db;
    // validate partid
    db.query('select * from participants where partid = ?;',partid,function(errors0,results0){
      if(errors0 || results0.length === 0) {
        res.status(500).json({'message':'Invalid participant: ' + partid});
        return;
      }

      // validate topid for this partid
      db.query('select * from topic_assignments where topid = ? and partid = ?;',[topid, partid],function(errors1,results1){
        if(errors1 || results1.length === 0) {
          res.status(500).json({'message':'Unable to identify participant: ' + partid + ' for topic: ' + topid});
          return;
        }

        // insert judgement into DB
        db.query('insert judgements (assessor,topid,tweetid,rel,useragent,timetaken) values (?,?,?,?,?,?) ON DUPLICATE KEY UPDATE rel=?, submitted=NOW()',
                                        [partid,topid,tweetid,rel,useragent,timetaken,rel],function(errors,results){
          if(errors){
            console.log(errors)
            console.log("Unable to log: ",topid," ",tweetid," ",rel," ",useragent," ",timetaken);
            res.status(500).json({message : 'Unable to insert/update relevance assessment'})
          }
            
          // console.log("Logged: ",topid," ",tweetid," ",rel," ",useragent," ",timetaken);
          res.status(200).json({message : 'Success! Stored/Updated the relevance judgement.'})            
        });
      });
    });
  });

  // assessor app will get back the tweets/topics to judge next
  router.get('/judge/:partid',function(req,res){
    var partid = req.params.partid;
    var db = req.db;

    // validate partid 
    db.query('select * from participants where partid = ?;',partid,function(errors0,results0){
      if(errors0 || results0.length === 0) {
        res.status(500).json({'message':'Invalid participant: ' + partid});
        return;
      }

      var join_query = `
              SELECT requests.topid, topics.title, topics.description, topics.narrative, requests.tweetid 
              FROM requests INNER JOIN topics ON topics.topid = requests.topid 
              WHERE requests.topid in 
                (SELECT topid FROM topic_assignments WHERE partid = ?) 
                AND tweetid not in 
                (SELECT tweetid FROM judgements WHERE assessor = ? AND judgements.topid = requests.topid) ORDER BY submitted DESC LIMIT 20;
            `
      db.query(join_query, [partid, partid], function(errors1,results1){
        if(errors1){
            console.log(errors1)
            console.log("Unable to get tweets to judge for partid: ",partid);
            res.status(500).json({message : 'Unable to get tweets to judge for partid'})
        }

        res.status(200).json(results1);
      });
    });
  });


  // clients get back live assessments for the tweets posted for this topic
  router.post('/assessments/:topid/:clientid',function(req,res){
    var topid = req.params.topid;
    var tweetid = req.params.tweetid;
    var clientid = req.params.clientid;
    var db = req.db;
    // validate client (client exists) with clientid
    validate_client(db,clientid,function(errors,results){
      if(errors || results.length === 0){
        res.status(500).json({'message':'Could not validate client: ' + clientid})
        return;
      }
      // check topic exists with topicid
      db.query('select topid from topics where topid = ?;',topid,function(terr,tres){
        if(terr || tres.length === 0){
          res.status(500).json({'message':'Invalid topic identifier: ' + topid});
          return;
        }

        // check that this client did not check for live assessments too many times - RATE LIMIT - 1 per 10 minutes
        db.query('select count(*) as cnt from assessments_pulled where clientid = ? and topid = ? and submitted between DATE_SUB(NOW(),INTERVAL 10 MINUTE) and NOW();', [clientid, topid], function(errors0,results0){
          if(errors0 || results0.length === 0){
            res.status(500).json({'message':'Could not process live assessments for topid, clientid: ' + topid + ' and ' + clientid});
            return;
          }else if(results0[0].cnt >= ASSESSMENTS_PULL_LIMIT){
            res.status(429).json({'message':'Rate limit exceeded (1 per 10 minutes) for pulling live assessments for topid, clientid: ' + topid + ' and ' + clientid});
            return;
          }

          var join_query = `
            SELECT DISTINCT judgements.topid, judgements.tweetid, judgements.rel, judgements.submitted
            FROM judgements INNER JOIN requests
                ON judgements.topid=requests.topid AND judgements.tweetid = requests.tweetid
            WHERE requests.clientid = ? and requests.topid = ?;
          `
          db.query(join_query, [clientid, topid], function(errors2,results2){
            if(errors2){
              res.status(500).json({'message':'Could not process request (join) for client, topic: ' + clientid + ', ' + topid});
              return;
            }

            // gotta check last pulled before insert this entry to assessments_pulled
            db.query('SELECT MAX(submitted) as last FROM assessments_pulled WHERE clientid=? AND topid=?;', [clientid, topid], function(errors3,results3){
              if(errors3){
                res.status(500).json({'message':'Could not process request (last submitted) for client, topic: ' + clientid + ', ' + topid});
                return;
              }
              // final_results: list of relevance judgements & last_submitted time
              var final_results = { judgements: results2, last_pulled: results3[0].last }

              // insert into assessments_pulled table the topicid, clientid
              db.query('insert assessments_pulled (clientid, topid) values (?,?);',[clientid, topid], function(errors1,results1){
                if(errors1 || results1.length === 0){
                  res.status(500).json({'message':'Could not process request (insert assessments_pulled) for topid, clientid: ' + topid + ' and ' + clientid});
                  return;
                }
                res.json(final_results); //send back the live assessments
              });

            });
          });
        });
      });
    });
  });


  // teams use this endpoint to post tweets for topics
  router.post('/tweet/:topid/:tweetid/:clientid',function(req,res){
    var topid = req.params.topid;
    var tweetid = req.params.tweetid;
    var clientid = req.params.clientid;
    var db = req.db;
    // validate client (client exists) with clientid
    validate_client(db,clientid,function(errors,results){
      if(errors || results.length === 0){
        res.status(500).json({'message':'Could not validate client: ' + clientid})
        return;
      }
      // check topic exists with topicid
      db.query('select topid from topics where topid = ?;',topid,function(terr,tres){
        if(terr || tres.length === 0){
          res.status(500).json({'message':'Invalid topic identifier: ' + topid});
          return;
        }
        // check that this client did not post too many tweets (count) for this topicid
        db.query('select count(*) as cnt from requests where clientid = ? and topid = ? and submitted between DATE_SUB(NOW(),INTERVAL 1 DAY) and NOW();', [clientid, topid], function(errors0,results0){
          if(errors0 || results0.length === 0){
            res.status(500).json({'message':'Could not process request for topid: ' + topid + ' and ' + tweetid});
            return;
          }else if(results0[0].cnt >= RATE_LIMIT){
            res.status(429).json({'message':'Rate limit exceeded for topid: ' + topid});
            return;
          }
          // insert into requests table the topicid, tweetid, clientid
          db.query('insert requests (topid,tweetid,clientid) values (?,?,?);',[topid,tweetid,clientid], function(errors1,results1){
            if(errors1 || results1.length === 0){
              res.status(500).json({'message':'Could not process request for topid: ' + topid + ' and ' + tweetid});
              return;
            }
<<<<<<< HEAD
            // get the count from the seens table for this topicid and tweetid
            db.query('select count(*) as cnt from seen where topid = ? and tweetid = ?;',[topid,tweetid],function(errors4,results4){
              if(errors4){
                console.log("Something bad happened: " + errors4);
                res.status(500).json({'message':'could not process request for topid: ' + topid + ' and ' + tweetid});
                return;
              }
              // If we have seen the tweet before, do nothing
              if(results4[0].cnt === 0){
                // Otherwise send it out to be judged and then insert it
                // get the topic title
                db.query('select title from topics where topid = ?;',topid,function(errors2,results2){
                  if(errors2 || results2.length === 0){
                    console.log('Something went horribly wrong');
                    res.status(500).json({'message':'could not process request for topid: ' + topid + ' and ' + tweetid});
                    return;
                  }
                  var title = results2[0].title
                  // select participants who were assigned to judged this topic
                  db.query('select partid from topic_assignments where topid = ?;',topid,function(errors3,results3){
                    if(errors3){
                      console.log('Something went horribly wrong')
                      res.status(500).json({'message':'could not process request for topid: ' + topid + ' and ' + tweetid});
                      return;
                    }

                    /// PROBLEM: Loading the IDs is not synchronous!
                    if(!loaded){
                      loaded = true;
                      // select all participants from the DB and add to registrationIds
                      db.query('select partid,email,twitterhandle from participants;',function(parerror,parresults){
                        console.log("take all participants from the DB and add to registrationIds");
                        for (var i = 0; i < parresults.length; i++) {
                          var part = parresults[i]
                          console.log("participants twitterhandle: " + part.twitterhandle)
                          registrationIds.push({'partid':part.partid,'twitterhandle':part.twitterhandle,'email':part.email});
                        }
                        // MAKE IT SYNCHRONOUS!
                        console.log(results3)
                        if (results3.length !== 0){
                          var ids = []
                          for(var idx = 0; idx < results3.length; idx++){
                            ids.push(results3[idx].partid)
                          }
                          // send tweet for judgement to the participants in ids
                          console.log("calling send_tweet....")
                          // send_tweet(db, {"tweetid":tweetid,"topid":topid,"topic":title},ids);
                        }
                        // mark this tweet as seen so that it is not judged again
                        db.query('insert into seen (topid, tweetid) values (?,?);',[topid,tweetid],function(errors5,results5){
                          console.log(errors5)
                        });

                      });
                      console.log("in loaded: " + registrationIds)
                    }
                    else {
                      // results3 contains participants who were assigned to judged this topic
                      console.log(results3)
                      if (results3.length !== 0){
                        var ids = []
                        for(var idx = 0; idx < results3.length; idx++){
                          ids.push(results3[idx].partid)
                        }
                        // send tweet for judgement to the participants in ids
                        console.log("calling send_tweet....")
                        // send_tweet(db, {"tweetid":tweetid,"topid":topid,"topic":title},ids);
                      }
                      // mark this tweet as seen so that it is not judged again
                      db.query('insert into seen (topid, tweetid) values (?,?);',[topid,tweetid],function(errors5,results5){
                        console.log(errors5)
                      });

                    }
                  });
                });
              }
            });
=======

>>>>>>> 47bb42985634020c7a9b234443452e133d6c839a
            res.status(204).send();
          });
        });
      });
    });
  });


  // register client and return clientid given they have registered a group
  router.post('/register/system/', function(req,res){
    var groupid = req.body.groupid;
    var alias = req.body.alias;
    var db = req.db;
    var clientid = genID();
    validate_group(db,groupid,function(errors,results){
      if(errors || results.length === 0){
        res.status(500).json({'message':'Unable to register a client for group: ' + groupid});
        return;
      }
      if (alias === undefined){
        alias = "NULL"
      }
      db.query('select count(*) as cnt from clients where groupid = ?;',[groupid],function(gerrors,gresults){
        if (gresults[0].cnt < MAX_CLIENTS){
          db.query('insert clients (groupid,clientid,ip,alias) values (?,?,?,?);',[groupid,clientid,req.ip,alias], function(errors1,results1){
            if(errors1){
              res.status(500).json({'message':'Unable to register system.'});
              return;
            }
            // No longer used with a unified table
            // db.query('create table requests_'+clientid+' like requests_template;'); // Assume this works for now
            // db.query('create table requests_digest_'+clientid+' like requests_template;'); // Assume this works for now
           res.json({'clientid':clientid});
          });
        }else{
          res.status(429).json({'message':'Too many client ids for group: ' + groupid});
        }
      });
    });
  });


  // get all requests from this client
  router.get('/log/:clientid',function(req,res){
    var clientid = req.params.clientid;
    var db = req.db;
    validate_client(db,clientid,function(errors,results){
      if(errors || results.length === 0){
        res.status(500).json({'message':'Unable to validate clientid:' + clientid});
        return;
      }
      db.query('select * from requests where clientid = ?;',clientid,function(errors1,results1){
        if(errors1){
          res.status(500).json({'message':'Unable to retrieve log for: ' + clientid});
          return;
        }
        res.status(200).json(results1);
      });
    });
  });

  // get topics with clientid
  router.get('/topics/:uniqid', function(req,res){
    var uniqid = req.params.uniqid;
    var db = req.db;
    validate_client_or_participant(db,uniqid,function(errors,results){
      if(errors || results.length === 0){
        res.status(500).json({'message':'Unable to validate ID: ' + uniqid});
        return;
      }
      db.query('select topid, title, description, narrative from topics;',function(errors1,results1){
        if(errors1){
          res.status(500).json({'message':'Unable to retrieve topics for client: ' + uniqid});
        }else{
          res.json(results1);
        }
      });
    });
  });


  return router;
}
