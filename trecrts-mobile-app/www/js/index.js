/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
 var hostname = ""
 var GCM_SERVER = ""

 var twttr = (function(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0],
    t = window.twttr || {};
    if (d.getElementById(id)) return t;
    js = d.createElement(s);
    js.id = id;
    js.src = "https://platform.twitter.com/widgets.js";
    fjs.parentNode.insertBefore(js, fjs);
    t._e = [];
    t.ready = function(f) {
        t._e.push(f);
    };
    return t;
}(document, "script", "twitter-wjs"));

 var regid = "";
 var paused = false
 var seenTweets = {}
 var tweetQueue = []
 var app = {
    // Application Constructor
    initialize: function() {
        this.bindEvents();
    },

    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);


    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicitly call 'app.receivedEvent(...);'
    onDeviceReady: function() {
        app.receivedEvent('deviceready');
        $(window).on('beforeunload',function(evt){
            console.log("I am unloading")
            $.ajax({
                type: "DELETE",
                url: hostname + "/unregister/mobile/"+regid
            });    
        })
        document.addEventListener('pause',app.pauseApp,false)
        document.addEventListener('reisgn',app.pauseApp,false) // iOS specific event similar to pause
        document.addEventListener('resume',app.resumeApp,false) 
    },
    pauseApp : function(){
        paused = true
        console.log("pausing app")
    },
    resumeApp : function(){
        console.log("unpausing app")
        paused = false
        // Load queue of tweets
        tweetQueue.forEach(function(tweetInfo){
            app.addTweet(tweetInfo.tweetid,tweetInfo.topic,tweetInfo.topid)
        });
        tweetQueue = []
    },
    removeTweet : function(topid,tweetid,rel){
        try{
            $("#div"+tweetid).remove();

            $.ajax({
                type: "POST",
                url: hostname + "/judge/"+topid+"/"+tweetid+"/"+rel
            });
        }catch(err){alert('RM: ' + err.message);}
    },
    addTweet : function (tweetid,topic,topid){
        var tdiv = $('<div>',{
            id:'div'+tweetid,
            class:'tweet-div'
        });
        $("#tweets").append(tdiv);
        twttr.widgets.createTweet(tweetid,document.getElementById('div'+tweetid),{})
        .then(function(){
            var tspan = $('<span />',{
                class:"topic-span",
                text: "Topic: " + topic 
            });
            $("#div"+tweetid).append(tspan).append("<br/>");//"Topic: " + topic + "<br />");
            var relb = $('<span/>',{
                id:'rel'+tweetid,
                class: "judge rel glyphicon glyphicon-plus",
                click: function(){
                    app.removeTweet(topid,tweetid,"2")    
                }
            });
            var nrelb = $('<span/>',{
                id:'rel'+tweetid,
                class: "judge nrel glyphicon glyphicon-minus",
                click:function(){
                    app.removeTweet(topid,tweetid,"-1")
                }
            });
            var repb = $('<span/>',{
                id:'rel'+tweetid,
                class: "judge rep glyphicon glyphicon-repeat",
                click:function(){
                    app.removeTweet(topid,tweetid,"1")
                }
            });
            $("#div"+tweetid).append(relb); 
            $("#div"+tweetid).append(nrelb);
            $("#div"+tweetid).append(repb) 
        });
    },
    // Update DOM on a Received Event
    receivedEvent: function(id) {
        var push = PushNotification.init({
            android : { senderID : GCM_SERVER},
            ios : {
                "sound" : true,
                "vibration" : true,
                "badge" : true
            }
        });
        push.on('registration',function (data){

            if ( data.registrationId.length > 0 )
            {
                regid = data.registrationId
                var oldRegId = localStorage.getItem('registrationId');
                if (oldRegId !== regid) {
                    // Save new registration ID
                    localStorage.setItem('registrationId', data.registrationId);
                    // Post registrationId to your app server as the value has changed
                }
                                    $.ajax({
                        type: "POST",
                        url: hostname + "/register/mobile",
                        data: JSON.stringify({"regid" : regid}),
                        contentType : "application/json",
                        dataType: "json"
                    }).fail(function(obj,err,thrown){
                        alert("Fail: " + err + " " + thrown);
                    });

            }
        });
        push.on('notification',function(data){
            var payload = data.additionalData
            if ([payload.tweetid,payload.topid] in seenTweets){
                return;
            }
            if ( paused ){
                tweetQueue.push({"tweetid":payload.tweetid,"topic":payload.topic,"topid":payload.topid})
            }else {
                app.addTweet(payload.tweetid,payload.topic,payload.topid);
            }
            seenTweets[[payload.tweetid,payload.topid]] = true
        });
        push.on('error',function(error){
            alert("Error occurred")
        });
    },
    successHandler: function(result) {
       //alert('Callback Success! Result = '+result);
    },
    errorHandler:function(error) {
        alert("Error found: " + error);
    }
};
