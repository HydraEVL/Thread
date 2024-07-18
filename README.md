 ผมเขียนเอกสารนี้เพื่อกันลืมโมดูลที่ผมเขียนไว้ใช้เอง

# Thread
การทำงานแบบ Non-blocking รันงานหลายอย่างพร้อมกันโดยไม่รบกวนงานอื่น
ผมเขียนmoduleนี้มาเพื่อจัดการและสั่ง Thread ที่ต้องการให้หยุดการทำงาน ถึงจะเป็นโครงสร้างที่อาจจะไม่ได้ดีที่สุดก็เถอะ แต่ผมคิดว่ามันดีพอแล้วสำหรับการแค่เขียนใช้เองส่วนตัว ซึ่งโมดูลจริงที่เขียนจะมีบางอย่างที่ไม่ได้เขียนไว้ในเอกสารนี้เช่น มีการเพิ่ม Key เข้ามา:
```lua
-- Server Side
  __Thread:New(player,Key)
-- Client Side
  __Thread:New(Key)

-- เนื่องจากผมต้องการให้ทำงานและหยุดแบบพร้อมกันทั้ง2ฝั่ง ทั้งเซิร์ฟเวอร์และผู้เล่น ผมเลยเพิ่ม Key เข้ามาเพื่อให้ฝั่ง Client ง่ายและประหยัดต่อการรับข้อมูลขนาดเล็กที่ Server ส่งมา แทนที่จะเป็น threadId ซึ่งผมออกแบบให้ threadId นั้นมีไว้เพื่อทำให้สร้างtaskการทำงานและเก็บไว้ในตารางที่ไม่ซ่ำกัน

-- ฝั่งของเซิร์ฟเวอร์สามารถหยุดการทำงานของ Thread player หรือ Keyทั้งหมดของผู้เล่นคนนั้นได้ และสามารถระบุหยุดแบบเจาะจงแค่ threadId ได้อีกด้วย

-- ส่วนของฝั่งผู้เล่น(Client) ทำได้เพียงรับข้อมูล การสร้าง และหยุด แต่จะไม่สามารถหยุดแบบ Manual ได้ จะสามารถหยุดแบบ Manual  ได้ถ้าฝั่งของผู้เล่นเป็นผู้สร้าง Thread นั้นเอง

```
(ผมไม่รู้ว่าที่ผมเขียนเอกสารนี้มันจะทำให้เกิดปะโยชน์กับใครได้บ้าง ผมไม่ได้เก่งอะไร แต่ถ้าหากว่าพี่ๆอ่านแล้วมันดูมั่วๆงงๆมีความผิดพลาดหลายๆอย่างหลายๆด้านความเข้าใจผิดบางคำหรือความหมาย ผมก็ต้องขอโทษด้วยนะครับ)

## การเริ่มสร้างงานใหม่
```lua
local thread0 = __Thread:New(player)
```
เพื่อสร้างพื้นที่ทำงาน Thread ใหม่ที่เชื่อมโยงกับุผู้เล่น

## เพิ่มรายการที่จะลบออกหรือหยุดทำงานเมื่อ Thread หยุดทำงาน
รายการที่เพิ่มได้จะเป็นประเภท AnimationTrack หรือ Instance หรือ ตัวแปรที่มีฟังก์ชั่น `:Destroy()` ตัวอย่าง:

```lua
-- เพิ่ม AnimationTrack
thread0:Anim(AnimationTrack)

-- เพิ่ม Instance หรือ ตัวแปรที่มีฟังก์ชั่น :Destroy() 
thread0:Ins(Instance)
```

## เริ่มรัน Thread 
```lua
local thread0Id = thread0:Spawn(function()
    -- code ที่ต้องการดำเนินการ
end)
```

## วิธีใช้ `.Canceled()`
ฟังก์ชันนี้ช่วยให้คุณกำหนดคำสั่งที่จะรันเมื่อ Thread ถูกยกเลิกหรือหลังที่มันทำงานเสร็จเองแบบปกติ

- กำหนดฟังก์ชัน
    เพื่อกำหนดสิ่งที่เกิดขึ้นเมื่อ Thread ถูกยกเลิกหรือทำงานเสร็จ:
    ```lua
    local canceled0 = thread0:Canceled(function()
      print("Thread canceled or finished.")
    end)
    ```
- เรียกใช้ฟังก์ชั่นแบบ Manual
    สามารถเรียกใช้ฟังก์ชั่นก่อนที่มันจะทำงานเสร็จเองแบบปกติได้
    และฟังก์ชั่นจะไม่ถูกเรียกซ้ำเมื่อถูกใช้ไปแล้ว
    ```lua
    canceled0()
    ```
## รอจนกว่า Thread หยุดทำงาน
เพื่อรอมันหยุดทำงานหรือทำงานเสร็จตามปกติก่อนที่จะเริ่ทคำสั่งในบรรทัดต่อไป
```lua
thread0:WaitStopped()
```

## การยกเลิก Thread
หยุดทำงานแบบ Manual:
```lua
thread0.Cancel()
```
เมื่อมันหยุดทำงานรายการต่างๆจะถูกหยุดและลบออกเหมือนกัน

## ยกเลิก Thread ทั้งหมด
หยุด Thread ที่กำลังทำงานและเกี่ยวข้องกับผู้เล่นที่กำหนด
```lua
__Thread.Clear(player)
```

# ตัวอย่าง
```lua
-- Example usage of thread management
local thread0 = __Thread:New(player)

-- Adding a function to be executed when thread is canceled or finished
    local light: PointLight = workspace.PointLight;
local canceled01 = thread0:Canceled(function()
    light.Enabled = true
end)

-- Adding an AnimationTrack
thread0:Anim(AnimationTrack)

-- Adding an Instance or a module with :Destroy()
   local instanceToDestroy = Instance.new("Part")
thread0:Ins(instanceToDestroy)
   instanceToDestroy.Parent = workspace

   local moduleToDestroy = {}
   function moduleToDestroy:Destroy()
       -- Destruction logic for module
   end
thread0:Ins(moduleToDestroy)

local thread0Id = thread0:Spawn(function()
    -- Thread execution code
    light.Enabled = false
    task.wait(5)
    canceled01() -- Manually trigger the cancellation function
    print("Thread completed.")
})

thread0:WaitStopped()
print("End")
```
