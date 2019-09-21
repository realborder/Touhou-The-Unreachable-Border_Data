--======================================
--luastg input
--======================================

----------------------------------------
--按键状态更新

KeyState={}
KeyStatePre={}
--由云绝添加，用于手柄适配
JoyState={}
JoyStatePre={}

-- function GetInput()--于ext中重载，然后被ESC抛弃了……
-- 	for k,v in pairs(setting.keys) do
-- 		KeyStatePre[k]=KeyState[k]
-- 		KeyState[k]=GetKeyState(v)
-- 	end
-- end

function KeyIsDown(key)
	-- return KeyState[key]
	return KeyState[key] or JoyState[key]
end KeyPress = KeyIsDown

function KeyIsPressed(key)--(划掉 于javastage中重载
	-- return KeyState[key] and (not KeyStatePre[key])
	return (KeyState[key] and (not KeyStatePre[key])) or (JoyState[key] and (not JoyStatePre[key]))
end KeyTrigger = KeyIsPressed

--将按键二进制码转换为字面值，用于设置界面
function KeyCodeToName()
	local key2name={}
	--按键code（参见launch和微软文档）作为索引，名称为值
	for k,v in pairs(KEY) do
		key2name[v]=k
	end
	--似乎是按照keycode从0到255重新排列keyname
	for i=0,255 do
		key2name[i]=key2name[i] or '?'
	end
	return key2name
end
------------------------------------------------
---更新输入信息
--jstg输入已爆破，遗迹坐标jstg.GetInputEX
function GetInput()
	if stage.next_stage then
		KeyStatePre = {}
		JoyStatePre = {}
	else
		-- 刷新KeyStatePre
		for k, v in pairs(setting.keys) do
			KeyStatePre[k] = KeyState[k]
		end
		-- 刷新JoyStatePre
		for k, v in pairs(setting.joysticks) do
			JoyStatePre[k] = JoyState[k]
		end
	end
	-- 不是录像时更新按键状态
	if not ext.replay.IsReplay() then
		for k,v in pairs(setting.keys) do
			KeyState[k] = GetKeyState(v)
		end
		for k,v in pairs(setting.joysticks) do
			JoyState[k] = GetKeyState(v)
		end
	end
	
	if ext.replay.IsRecording() then
		-- 录像模式下记录当前帧的按键
		replayWriter:Record(KeyState)
		replayWriter:Record(JoyState)
	elseif ext.replay.IsReplay() then
		-- 回放时载入按键状态
		replayReader:Next(KeyState)
		replayReader:Next(JoyState)
		--assert(replayReader:Next(KeyState), "Unexpected end of replay file.")
	end
end