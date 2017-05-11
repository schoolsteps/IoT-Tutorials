require("credentials")
require("myhtml")
wifi.setmode(wifi.STATION)
wifi.sta.config(ssid,password)

local pin = 7
local status = gpio.LOW
gpio.mode(pin, gpio.OUTPUT)
gpio.write(pin, status)

print("Fetching IP Address...")
tmr.alarm(1,10000, tmr.ALARM_SINGLE, function()
print(wifi.sta.getip())
print(tmr.ALARM_SINGLE)
end) 
    
if srv == nil then
    srv = net.createServer(net.TCP,30)
end 

srv:listen(80,function(netsocket)
    netsocket:on("receive",function(netsocket,data)
    --print(data)
    local a,b  = string.find(data,"GET(.+)HTTP")
    local ss1 = string.sub(data,a,b)
    --print(ss1)
    local x,startofval = string.find(ss1,"pin=")
    local endofval,y = string.find(ss1,"HTTP")
    if startofval~=nil and endofval~=nil then
        local finalval = string.sub(ss1,startofval+1,endofval-2)
        if finalval == "ON" then
            status = gpio.HIGH
            gpio.write(pin, status)
        else
            status = gpio.LOW
            gpio.write(pin, status)
        end  
        --print("Final value is..."..finalval)
    end
    netsocket:send(s)
    end)

    netsocket:on("sent",function(netsocket)
        netsocket:close()
        end)
    end)
        
