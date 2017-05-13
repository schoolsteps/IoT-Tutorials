package.loaded.config = nil
local config = require("config")
wifi.setmode(wifi.STATION)
wifi.sta.config(config.credentials.SSID,config.credentials.PASSWORD)
print(config.clientid)
tmr.alarm(1,2500, tmr.ALARM_AUTO, function()
    ip = wifi.sta.getip()
    if ip~= nil then
        print("IP IS..."..ip)
        tmr.stop(1)
    else
        print("Trying to fetch the ip address")    
    end
end
)
