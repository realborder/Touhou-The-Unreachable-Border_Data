--======================================
--luastg input
--======================================

----------------------------------------
--按键状态更新

KeyState={}
KeyStatePre={}

function GetInput()--于ext中重载，然后被ESC抛弃了……
	for k,v in pairs(setting.keys) do
		KeyStatePre[k]=KeyState[k]
		KeyState[k]=GetKeyState(v)
	end
end

function KeyIsDown(key)
	return KeyState[key]
end KeyPress = KeyIsDown

function KeyIsPressed(key)--于javastage中重载
	return KeyState[key] and (not KeyStatePre[key])
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
