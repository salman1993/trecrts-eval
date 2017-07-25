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
  function send_tweet_socket(tweet,socket){
    socket.emit('tweet',tweet);
  }
  function find_user(partid){
    for (var idx = 0; idx < registrationIds.length; idx++){
      if(registrationIds[idx].partid === partid)
        return idx;
    }
    return -1;
  }

  function send_tweet_dm(db, tweet, partid, twitterhandle) {
    // console.log("hello")
    var text = "https://twitter.com/432142134/status/" + tweet["tweetid"] // used random user id
    text += "\nTopic: " + tweet["topid"] + " - " + tweet["topic"]
    // text += "\n\nRelevant: " + generate_judgement_link(tweet["topid"], tweet["tweetid"], rel2id['rel'], partid)
    // text += "\n\nNot Relevant: " + generate_judgement_link(tweet["topid"], tweet["tweetid"], rel2id['notrel'], partid)
    // text += "\n\nDuplicate: " + generate_judgement_link(tweet["topid"], tweet["tweetid"], rel2id['dup'], partid)
    text += "\n\nJudge: " + generate_judgement_link(tweet["topid"], tweet["tweetid"], partid)

    // post the DM with TwitterClient
  }



  // tweet: {"tweetid":tweetid, "topid":topid, "topic":title}
  // interestIDs are partids of participants who are assigned to this topic (topicid)
  function send_tweet(db, tweet, interestIDs){
    for (var i = 0; i < interestIDs.length; i++){
      var id = interestIDs[i]
      // console.log("id : " + id)
      // console.log("registrationIds: " + registrationIds)

      var idx = find_user(id);
      // console.log("idx: " + idx)
      if (idx === -1)
        continue;
      var currPart = registrationIds[idx];
      // console.log("currPart: " + currPart)
      //registrationIds.push({'partid':part.partid,'twitterhandle':part.twitterhandle,'email':part.email});
      // console.log("part email: " + currPart['email'])

      // send_tweet_dm(db, tweet, currPart['partid'], currPart['twitterhandle']);
    }
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
  router.post('/judge/:topid/:tweetid/:rel/:partid', function(req,res){
    var topid = req.params.topid;
    var tweetid = req.params.tweetid;
    var rel = req.params.rel;
    var partid = req.params.partid;
    
    var devicetype = req.device.type.toLowerCase(); 
    // console.log("devicetype - ", devicetype);

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
        db.query('insert judgements (assessor,topid,tweetid,rel,devicetype) values (?,?,?,?,?) ON DUPLICATE KEY UPDATE rel=?, submitted=NOW()',
                                        [partid,topid,tweetid,rel,devicetype,rel],function(errors,results){
          if(errors){
            console.log(errors)
            console.log("Unable to log: ",topid," ",tweetid," ",rel," ",devicetype);
            res.status(500).json({message : 'Unable to insert/update relevance assessment'})
          }
            
          console.log("Logged: ",topid," ",tweetid," ",rel," ",devicetype);
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
                (SELECT tweetid FROM judgements WHERE assessor = ? AND judgements.topid = requests.topid) ORDER BY submitted LIMIT 10;
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

  router.get('/validate/part/:partid',function(req,res){
    var partid = req.params.partid;
    var db = req.db;
    validate_participant(db,partid,function(errors0,results0){
      if (errors0 || results0.length === 0){
        res.status(500).json({'message': 'Unable to validate client: ' + clientid})
        return;
      }else{
        res.status(204).send()
      }
    });
  });

  router.post('/register/mobile/',function(req,res){
    var db = req.db;
    var regid = req.body.regid;
    var partid = req.body.partid;
    var device = req.body.device;
    // At least one reg id required
    db.query('select * from participants where partid = ?;',partid,function(errors0,results0){
      if(errors0 || results0.length === 0){
        res.status(500).json({'message':'Unable to identify participant: ' + partid});
        return;
      }
      var idx = find_user(partid)
      if ( idx === -1 ){
        if (device === "iOS")
          registrationIds.push({'partid':partid,'type':'apn','conn':regid});
        else
          registrationIds.push({'partid':partid,'type':'gcm','conn':regid});
        db.query('update participants set deviceid = ? where partid = ?;',[regid,partid],function(errors1,results1){
          if(errors1){
            console.log('Unable to update device for partid: ', partid, regid);
          }
       });
      }else{
         registrationIds[idx].conn = regid;
         registrationIds[idx].type = device
         db.query('update participants set deviceid = ?, platform = ? where partid = ?;',[regid,partid,device],function(errors1,results1){
           if(errors1){
             console.log('Unable to update device for partid: ', partid, regid);
           }
         });
      }
      res.status(204).send();
      // Definitely need to do something better here
      /*
      if(tweet_queue.length > 0){
        for(var i = 0; i < tweet_queue.length; i++){
          send_tweet(tweet_queue[i]);
        }
        tweet_queue = [];
      }
      */
    });
  });

// NOT USED FOR RTS 2016
/*  router.post('/tweets/:topid/:clientid',function(req,res){
    var topid = req.params.topid;
    var clientid  = req.params.clientid;
    var tweets = req.body.tweets;
    var db = req.db;
    validate_client(db,clientid,function(errors,results){
      if (errors || results.length === 0){
        res.status(500).json({'message': 'Unable to validate client: ' + clientid})
        return;
      }
      stmt = ""
      for (var i = 0; i < tweets.length; i++){
        if (! isValidTweet(tweets[i])){
          res.status(404).json({'message': 'Invalid tweetid: ' + tweets[i]});
        }
        if (i !== 0){
          stmt += ',(\'' + tweets[i] + '\',\'' + topid + '\')';
        } else {
          stmt += '(\'' + tweets[i] + '\',\'' + topid + '\')';
        }
      }
      db.query('insert into requests_digest_' + clientid + ' (docid,topid) values ' + [stmt],function(errors0,results0){
        if (errors)
          res.status(500).json({'message': 'Unable to insert tweets for end of day digest'});
        res.status(204).send()
      });
    });
  });*/

  // TODO: Need to enforce topid is valid
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

            res.status(200).json({'message':'Success: tweet posted'});
          });
        });
      });
    });
  });


// NOT USED IN RTS 2016
/*  router.get('/judge/:topid/:tweetid/:clientid', function(req,res){
    var clientid = req.params.clientid;
    var topid = req.params.topid;
    var tweetid = req.params.tweetid;
    var db = req.db;
    validate_client(db,clientid,function(errors,results){
      if(errors || results.length === 0){
        res.status(500).json({'message':'Could not validate client: ' + clientid})
        return;
      }
      db.query('select rel from judgements where tweetid = ? and topid = ?;'[tweetid],function(errors1,results1){
        if(errors1){
          res.status(500).json({'message':'Error retrieving judgement for : '+ tweetid + ' on ' + topid});
        }else if (results1.length ===0){
          res.status(500).json({'message':'No judgement for : '+ tweetid + ' on ' + topid});
        }
        res.json({'tweetid':tweetid,'topid':topid,'rel':results[0].rel});
      });
    });
  });*/

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

  router.get('/topics/available/:uniqid/:topid', function(req,res){
    var db = req.db;
    var uniqid = req.params.uniqid;
    var topid = req.params.topid;
    validate_client_or_participant(db,uniqid,function(errors0,results0){
      if(errors0 || results0.length === 0){
        res.status(500).json({'message':'Unable to validate ID:' + uniqid});
        return;
      }
      db.query('select count(*) as cnt from topic_assignments where topid = ?;',topid,function(errors1,results1){
        if(errors1 || results1.length === 0){
          res.status(500).json({'message':'Error in determining topic availability.'});
          return;
        }else if(results1[0].cnt >= MAX_ASS){
          res.status(404).json({'message':'Sufficient assessors'});
          return;
        }
        res.status(204).send();
      });
    });
  });
  router.post('/topics/interest/:partid',function(req,res){
    var partid = req.params.partid;
    var topids = req.body;
    var db = req.db;
    validate_participant(db,partid,function(errors0,results0){
      if(errors0 || results0.length === 0){
        res.status(500).json({'message':'Unable to validate participant:'+partid});
        return
      }
      stmt = ""
      for (var i = 0; i < topids.length; i++){
        if (i !== 0){
          stmt += ',(\'' + topids[i] + '\',\'' + partid + '\')';
        } else {
          stmt += '(\'' + topids[i] + '\',\'' + partid + '\')';
        }
      }
      db.query('insert ignore into topic_assignments (topid,partid) values ' + [stmt],function(errors1,results1){
        if (errors1)
          res.status(500).json({'message': 'Unable to insert topics for partid:' + partid});
        res.status(204).send()
      });
    });
  });
  router.get('/topics/interest/:partid',function(req,res){
    var partid = req.params.partid;
    var db = req.db;
    validate_participant(db,partid,function(errors0,results0){
      if(errors0 || results0.length === 0){
        res.status(500).json({'message':'Unable to validate participant:'+partid});
        return
      }
      db.query('select topid from topic_assignments where partid = ?;',partid,function(errors1,results1){
        if(errors1){
          res.status(500).json({'message':'Unable to fetch assigned topics for: ' + partid})
          return;
        }
        res.json(results)
      });
    });
  });
  router.post('/topics/suggest/:uniqid',function(req,res){
    var db = req.db;
    var uniqid = req.params.uniqid;
    validate_client_or_participant(db,uniqid,function(errors0,results0){
      if(errors0 || results0.length === 0){
        res.status(500).json({'message':'Unable to validate: ' + uniqid})
        return;
      }
      db.query('insert into candidate_topics (title,description) values (?,?);',[req.body.title,req.body.desc],function(errors1,results1){
        if (errors1)
          res.status(500).json({'message': 'Unable to insert topic suggestions for:' + uniqid});
        res.status(204).send()
      });
    });
  });

  router.delete('/unregister/mobile/:partid',function(req,res){
    var partid = req.params.partid
    var idx = find_user(partid)
    if (idx > -1) registrationIds.splice(idx,1)
    res.status(204).send();
  });

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

  // TODO: Figure out way to incorporate socket based connections without requiring an actual id

  io.on('connection', function(socket){
    socket.on('register',function(){
      console.log("Registered")
      registrationIds.push({'partid':socket,'type':'socket','conn':socket});
    });
    socket.on('judge',function(msg){
      console.log('Judged: ', msg.topid, msg.tweetid,msg.rel);
    });
    socket.once('disconnect',function(){
      console.log("Disconnect");
      var idx = find_user(socket);
      if (idx > -1) registrationIds.splice(idx,1);
    });
  });
  return router;
}
