exports.handler = (event, context, callback) => {
    var mqtt = require("mqtt");
    var url = 'mqtt://m13.cloudmqtt.com:14940';
    var options = {
        clientId:'client_httptomqtt',
        username:'user id of cloud mqtt user',
        password:'password of cloud mqtt user'
    };

    var client = mqtt.connect(url,options);
    var myMessage = event.messageontopic;
    
    client.on('connect',function(){
        client.publish('MyLED',myMessage,function(){
            console.log('Message is published');
            client.end();
        });

        client.subscribe('MyLED',function(){
            console.log('Subscribed to the topic');
        });

    });

    client.on('message',function(topic,message){
        console.log('Received message ' + message + ' on the topic' + topic);
    });
    callback(null, 'Message sent with value'+myMessage);
};



