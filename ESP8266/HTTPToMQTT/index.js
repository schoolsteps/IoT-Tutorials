exports.handler = (event, context, callback) => {
    var mqtt = require("mqtt");
    var url = 'mqtt://m13.cloudmqtt.com:14940';
    var options = {
        clientId:'client_httptomqtt',
        username:'user id of cloudmqtt user',
        password:'password of cloudmqtt user'
    };

    var client = mqtt.connect(url,options);
    var myMessage = event.messageontopic;

    client.on('connect',function(){
        client.publish('MyLED',myMessage,function(){
            console.log('Message is published');
            client.end();
        });


    });

   callback(null, 'Message sent with value ' + myMessage);
};




