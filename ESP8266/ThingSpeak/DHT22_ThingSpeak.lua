require("credentials")
wifi.setmode(wifi.STATION)
wifi.sta.config(ssid,password)
pin = 2
tmr.alarm(1,5000,tmr.ALARM_AUTO,function()
    local status, temp, humi, temp_dec, humi_dec = dht.read(pin)
    if status == dht.OK then
       -- Integer firmware using this example
       -- print(string.format("DHT Temperature:%d.%03d;Humidity:%d.%03d\r\n",
       --      math.floor(temp),
       --       temp_dec,
       --     math.floor(humi),
       --       humi_dec
       -- ))
        --float 
        print("DHT temperature is: "..temp.."Humidity is: "..humi)
        sendDataToThingSpeak(temp,humi)
    elseif status == dht.ERROR_CHECKSUM then
        print("Checksum error")
    elseif status == dht.ERROR_TIMEOUT then
        print("Timeout error")    
    end   
end)    


function sendDataToThingSpeak(temp,humi)
    myip = wifi.sta.getip()
    print(myip)
    if myip~=nil then
        print("Sending data to thingspeak....")
        http.post('http://api.thingspeak.com/update',
        'Content-Type: application/json\r\n',
        '{"api_key":"Your Thing Speak API Key","field1":'..temp..',"field2":'..humi..'}',
        function(code, data)
            if (code < 0) then
            print("HTTP request failed")
        else
            print(code, data)
        end
  end)
  
    else
        print("Not connected to wifi yet...")
    end    
end
















