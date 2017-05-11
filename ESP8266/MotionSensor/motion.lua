local motionpin = 1
local duration = 1000

gpio.mode(motionpin, gpio.INPUT)

tmr.alarm(0,duration,tmr.ALARM_AUTO,function()
    motionstatus = gpio.read(motionpin)
    if motionstatus == 0 then
        print("No Motion")
    else
        print("Motion Detected")
    end

    end)
