local pin = 0
local status = gpio.LOW
local duration = 1000

gpio.mode(pin, gpio.OUTPUT)
gpio.write(pin, status)

tmr.alarm(0,duration,tmr.ALARM_AUTO,function()
    if status == gpio.LOW then
        status = gpio.HIGH
    else
        status = gpio.LOW
    end

    gpio.write(pin,status)
    end)
        
