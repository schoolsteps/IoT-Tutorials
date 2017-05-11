local pin = 7
local status = gpio.LOW
local duration = 1000

gpio.mode(pin, gpio.OUTPUT)
gpio.write(pin, status)

tmr.alarm(0,duration,1,function()
    if status == gpio.LOW then
        status = gpio.HIGH
    else
        status = gpio.LOW
    end

    gpio.write(pin,status)
    end)
