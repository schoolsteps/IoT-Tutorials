require("credentials")
wifi.setmode(wifi.STATION)
wifi.sta.config(ssid,password)

print("Fetching IP Address...")

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
    