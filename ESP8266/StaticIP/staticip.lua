require("credentials")
wifi.setmode(wifi.STATION)
wifi.sta.config(SSID,PASSWORD)
cfg = 
{
  ip = "x.x.x.x",
  netmask = "x.x.x.x",
  gateway = "x.x.x.x"
}

wifi.sta.setip(cfg)

print("Fetching IP Address...")
tmr.alarm(1,10000, tmr.ALARM_SINGLE, function()
print(wifi.sta.getip())
print(tmr.ALARM_SINGLE)
end) 

if srv == nil then
    srv = net.createServer(net.TCP,30)
end

srv:listen(80,function(conn)
    conn:on("receive", function(netsocket,data)
        print(data)
        netsocket:send("Web Server...")
        end)
    conn:on("sent", function(netsocket) netsocket:close() end)
    end)
