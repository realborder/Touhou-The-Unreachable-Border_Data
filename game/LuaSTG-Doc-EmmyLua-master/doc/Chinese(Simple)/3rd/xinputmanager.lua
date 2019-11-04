---=====================================
---luastg 对XInput的包装
---作者:Xiliusha
---邮箱:Xiliusha@outlook.com
---=====================================

---[不稳定的实现，日后可能会被去除，并以dll第三方库的形式提供]
---@class lstg.XInputManager
local m = {}

---@type lstg.XInputManager
lstg.XInputManager = m

----------------------------------------
---XInputManager

---获取指定手柄上某个键的状态
---@param index number @手柄索引，一般为1到4
---@param vkey number @按键码，请参考微软官方doc
---@return boolean
function m.GetKeyState(index, vkey)
end

---获取手柄上左右扳机的状态
---@param index number @手柄索引，一般为1到4
---@return number,number  @扳机状态，0到255
function m.GetTriggerState(index)
end

---获取手柄左右摇杆状态
---@param index number @手柄索引，一般为1到4
---@return number,number,number,number @LX,LT,RX,RY,取值范围-32768到32767
function m.GetThumbState(index)
end

---设置手柄震动（如果手柄支持并且开启该功能的话）
---@param index number @手柄索引，一般为1到4
---@param lowMotorSpeed number @低频马达转速，取值范围0到65535
---@param hightMotorSpeed number @高频马达转速，取值范围0到65535
---@return boolean @如果设置失败则返回false
function m.SetMotorSpeed(index, lowMotorSpeed, hightMotorSpeed)
end

---获取手柄震动状态，失败则第三个返回值为假
---@param index number @手柄索引，一般为1到4
---@return number,number,boolean @低频马达，高频马达，获取成功或失败
function m.GetMotorSpeed(index)
end

---获取被识别的设备数量，设备为支持XInput的游戏控制器
---@return number
function m.GetDeviceCount()
end

---重新枚举设备，并返回识别的设备数量
---@return number
function m.Refresh()
end

---更新并获取所有设备的状态，引擎已自动在FrameFunc自动调用一次，如果需要立即更新可以手动调用一次
function m.Update()
end
