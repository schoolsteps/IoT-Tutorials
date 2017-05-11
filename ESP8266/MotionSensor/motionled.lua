local motionpin = 1
local ledpin = 7
local ledpinstatus = gpio.LOW
local duration = 1000

gpio.mode(motionpin, gpio.INPUT)
gpio.mode(ledpin,gpio.OUTPUT)
gpio.write(ledpin,ledpinstatus)

tmr.alarm(0,duration,tmr.ALARM_AUTO,function()
    motionstatus = gpio.read(motionpin)
    if motionstatus == 0 then
        print("No Motion")
        ledpinstatus = gpio.LOW
        gpio.write(ledpin,ledpinstatus)
    else
        print("Motion Detected")
        ledpinstatus = gpio.HIGH
        gpio.write(ledpin,ledpinstatus)
    end

    end)

