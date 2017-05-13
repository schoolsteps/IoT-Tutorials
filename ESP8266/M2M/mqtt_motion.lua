require("credentials")
require("mqttconfig")
wifi.setmode(wifi.STATION)
wifi.sta.config(SSID,PASSWORD)

print("Fetching IP Address...")
tmr.alarm(1,10000, tmr.ALARM_SINGLE, function()
    myip = wifi.sta.getip()
    if myip~=nil then
        print(myip)
        mqttStart()    
    else
        print("Error in connecting to wifi")
    end
end) 

function publish_motionDetected()
    m:publish(ENDPOINT_MOTION,"1",0,0,function(client)
        print("Motion Detected. Sent 1 to MQTT")
    end
    )
end

function publish_keepalive()
    tmr.alarm(1,1000,tmr.ALARM_AUTO,function()
           m:publish("aliveMotion","alive",0,0,function(client)
                print("Keep alive message")
            end
            )
    end
    )
end

local motionpin = 1
gpio.mode(motionpin, gpio.INPUT)

function motionDetection()
    tmr.alarm(0,1000,tmr.ALARM_AUTO,function()
        motionStatus = gpio.read(motionpin)
        if motionStatus == 1 then
            print("motion detected")
            publish_motionDetected()
        else
            print("No motion")             
        end
    end
    )
    
end


function mqttStart()
    m = mqtt.Client(CLIENTID1,120,"user id of cloud mqtt user","password of cloud mqtt user")
    m:connect(HOST,PORT,0,0,function(client)
        print("Connected...")
    end,
    function(client,reason)
        print("Reason..."..reason)
    end
    )
    m:on("message",function(client,topic,message)
        if message ~= nil then
            print(topic .. "  " .. message)
        end    
    end
    )

    m:on("offline", function(client)
        print("In offline mode")
       end 
       )
    m:on("connect", function(client)
        print("Connected")
        motionDetection()
        publish_keepalive()
    end 
    )

    m:lwt("/lwt","offline",0,0)
   
    
end








