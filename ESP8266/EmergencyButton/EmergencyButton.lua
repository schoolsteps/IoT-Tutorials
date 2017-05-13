local pin = 7
local duration = 200
local panicstatus = 1

gpio.mode(pin,gpio.INPUT)

tmr.alarm(0,duration,tmr.ALARM_AUTO,function()
    panicstatus = gpio.read(pin)
    print(panicstatus)
    if panicstatus == 0 then
        print("Emergency...")
        executeIFTTTMakerService()
    else
        print("Relax...")
    end        
end
)

function executeIFTTTMakerService()
    http.post('Your IFTTT Maker Service URL',
  'Content-Type: application/json\r\n',
  '{"value1":"Emergency","value2":"Test Value2","value3":"Test Value3"}',
  function(code, data)
    if (code < 0) then
      print("HTTP request failed")
    else
      print(code, data)
    end
  end)

end






















