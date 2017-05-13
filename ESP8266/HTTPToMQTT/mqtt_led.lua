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

function subscribe_ledState()
    m:subscribe(ENDPOINT_LED,0,function(client)
        print("Subscribed to MyLED")
    end
    )
end

function keep_alive()
tmr.alarm(1,60000, tmr.ALARM_AUTO, function()
    m:publish(ENDPOINT_LED,"alive",0,0,function(client)
        print("Sent Keep Alive Ping")
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
 if message=="on" then
    status = gpio.HIGH
 elseif message=="off" then
     status = gpio.LOW
 end
 gpio.write(ledpin,status)
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
        print("Connected...")
        subscribe_ledState()
        keep_alive()
       end
    )
    m:lwt("/lwt","offline",0,0)

    
end


