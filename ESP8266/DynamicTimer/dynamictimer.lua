wificonfig = require("wificonfig")
wifi.sta.config(wificonfig.ssid,wificonfig.password)
local ipTimer = tmr.create()
ipTimer:register(2500,tmr.ALARM_AUTO,function(t)
    print(ipTimer)
    print(t)
    ip = wifi.sta.getip()
    if ip~=nil then
        print("IP address is"..ip)
        t:unregister()
    else
        print("trying to fetch ip")
    end
end
)
ipTimer:start()