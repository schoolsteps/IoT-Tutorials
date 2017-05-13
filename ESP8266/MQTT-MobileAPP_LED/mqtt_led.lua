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

function subscribe_led()
    m:subscribe(ENDPOINT_LED,0,function(client)
        print("Subscribed to topic ledstate")
    end
    )
end

function publish_keepalive()
    tmr.alarm(1,1000,tmr.ALARM_AUTO,function()
           m:publish("aliveLED","alive",0,0,function(client)
                print("Keep alive message")
            end
            )
    end
    )
end

local ledpin = 7
gpio.mode(ledpin, gpio.OUTPUT)
local status = gpio.LOW
gpio.write(ledpin,status)

function ledState(message)
   if message=="1" then
    status = gpio.HIGH
    gpio.write(ledpin,status)
   elseif message=="0" then
    status = gpio.LOW
    gpio.write(ledpin,status)
   end 
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
            ledState(message)
        end    
    end
    )

    m:on("offline", function(client)
        print("In offline mode")
       end 
       )
    m:on("connect", function(client)
        print("Connected")
        subscribe_led()
        publish_keepalive()
    end 
    )

    m:lwt("/lwt","offline",0,0)
   
    
end