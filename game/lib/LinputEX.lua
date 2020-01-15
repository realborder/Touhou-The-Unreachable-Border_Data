--======================================
--luastg inputex
--增加了对鼠标和键盘字符输入的支持
--======================================

MouseState={
	WheelDelta=0
}
_MOUSE={
	LEFT_BUTTON=0,
	MID_BUTTON=1,
	RIGHT_BUTTON=2
}
MouseStatePre={}

KeyInputTemp={
	enable=false,
	temp={},
	keys={
		[{'0',')'}]=0x30
		,[{'1','!'}]=0x31
		,[{'2','@'}]=0x32
		,[{'3','#'}]=0x33
		,[{'4','$'}]=0x34
		,[{'5','%'}]=0x35
		,[{'6','^'}]=0x36
		,[{'7','&'}]=0x37
		,[{'8','*'}]=0x38
		,[{'9','('}]=0x39
		
		,A=0x41
		,B=0x42
		,C=0x43
		,D=0x44
		,E=0x45
		,F=0x46
		,G=0x47
		,H=0x48
		,I=0x49
		,J=0x4A
		,K=0x4B
		,L=0x4C
		,M=0x4D
		,N=0x4E
		,O=0x4F
		,P=0x50
		,Q=0x51
		,R=0x52
		,S=0x53
		,T=0x54
		,U=0x55
		,V=0x56
		,W=0x57
		,X=0x58
		,Y=0x59
		,Z=0x5A
		
		,[{'`','~'}]=0xC0
		,[{'-','_'}]=0xBD
		,[{'=','+'}]=0xBB
		,[{'\\','|'}]=0xDC
		,[{'[','{'}]=0xDB
		,[{']','}'}]=0xDD
		,[{';',':'}]=0xBA
		,[{'\'','\"'}]=0xDE
		,[{',','<'}]=0xBC
		,[{'.','>'}]=0xBE
		,[{'/','?'}]=0xBF
		
		,[' ']=0x20
		,['\t']=0x09


		,NUMPAD0=0x60
		,NUMPAD1=0x61
		,NUMPAD2=0x62
		,NUMPAD3=0x63
		,NUMPAD4=0x64
		,NUMPAD5=0x65
		,NUMPAD6=0x66
		,NUMPAD7=0x67
		,NUMPAD8=0x68
		,NUMPAD9=0x69
		
		,['*']=0x6A
		,['/']=0x6F
		,['+']=0x6B
		,['-']=0x6D
		,['.']=0x6E},
	sys_keys={
		ESCAPE=0x1B,
		BACKSPACE=0x08,
		ENTER=0x0D,

		SHIFT=0x10,
		CTRL=0x11,
		ALT=0x12,

		LWIN=0x5B,
		RWIN=0x5C,
		APPS=0x5D,

		PAUSE=0x13,
		CAPSLOCK=0x14,
		NUMLOCK=0x90,
		SCROLLLOCK=0x91,

		PGUP=0x21,
		PGDN=0x22,
		HOME=0x24,
		END=0x23,
		INSERT=0x2D,
		DELETE=0x2E,

		LEFT=0x25,
		UP=0x26,
		RIGHT=0x27,
		DOWN=0x28},
	keystate={},
	keystate_pre={},
	keysys_state={},
	keysys_state_pre={},
	wordlimit1=0x41,
	wordlimit2=0x5A,
	-- backspace_timer=0
}
function GetInputExtra()
		--鼠标输入不参与录像
	--鼠标操作自机之后看情况加入

	-- 刷新MouseStatePre
	for k, v in pairs(MouseState) do
		MouseStatePre[k] = MouseState[k]
	end

	--更新鼠标输入
	local x,y=GetMousePosition()
	local ux,uy=ScreenToUI(x,y)
	local wx,wy=UIToWorld(ux,uy)
	MouseState.x=x
	MouseState.y=y
	MouseState.WheelDelta=lstg.GetMouseWheelDelta()
	MouseState.x_in_UI=ux
	MouseState.y_in_UI=uy
	MouseState.x_in_world=wx
	MouseState.y_in_world=wy
	for i=0,7 do MouseState['MouseButton_'..i]=lstg.GetMouseState(i) end
	MouseState.LeftButton=MouseState.MouseButton_0
	MouseState.RightButton=MouseState.MouseButton_2
	MouseState.MiddleButton=MouseState.MouseButton_1

	--更新输入缓冲
	KeyInputTemp:RefreshAll()
end

function GetMousePositionInUI()
	return MouseState.x_in_UI,MouseState.y_in_UI
end
function GetMousePositionInWorld()
	return MouseState.x_in_world,MouseState.y_in_world
end
function GetMouseDelta(index)
	return MouseState[index]-MouseStatePre[index]
end

local Original_GetInput=GetInput
if not _GetInput_overwrited then
	function GetInput()
		Original_GetInput()
		GetInputExtra()
	end
end _GetInput_overwrited=true --防止重载出问题

function MouseIsDown(i)
	return MouseState['MouseButton_'..i]
end MousePress=MouseIsDown
function MouseIsPressed(i)
	return MouseState['MouseButton_'..i] and (not MouseStatePre['MouseButton_'..i])
end MouseTrigger=MouseIsPressed
function MouseIsReleased(i)
	return MouseStatePre['MouseButton_'..i] and (not MouseState['MouseButton_'..i])
end 

-------------------------------------
---激活文本缓冲区
---@param str_init string 初始值
function KeyInputTemp:Activate(str_init) 
	self.enable=true
	str_init=str_init or ''
	KeyInputTemp.temp=str_init
	self.keystate_pre={}
	self.keysys_state_pre={}
end

function KeyInputTemp:RefreshAll()
	if not self.enable then return end
	local b_tmp
	for k,v in pairs(self.keystate) do
		self.keystate_pre[k]=v end
	for k,v in pairs(self.sys_keys) do
		self.keysys_state_pre[k]=self.keysys_state[k]
		self.keysys_state[k]=lstg.GetKeyState(v)
	end    
	
	for k,v in pairs(self.keys) do
		self.keystate[k]=lstg.GetKeyState(v)
		if self.keystate[k] and (not self.keystate_pre[k]) then
			if type(k)=='table' then
				if self.keysys_state['SHIFT'] then 
					b_tmp=k[2]
				else b_tmp=k[1] end
			elseif type(k)=='string' then
				if string.len(k)==1 then
					if self.keys[k]>=self.wordlimit1 and self.keys[k]<=self.wordlimit2 and not self.keysys_state['SHIFT'] then
						b_tmp=string.lower(k)
					else b_tmp=k end
				else b_tmp=string.sub(k,-1) end 
			end 
		end 
	end

	if b_tmp then self:Push(b_tmp) 
	else
		if (self.keysys_state['BACKSPACE'] and (not self.keysys_state_pre['BACKSPACE'])) then
			if self.keysys_state['CTRL'] then
				self:BackSpace(5)
			else
				self:BackSpace(1)
			end
		elseif self.keysys_state['ESCAPE'] and (not self.keysys_state_pre['ESCAPE']) then
			self:Clear()
		end
	end


		-- ESCAPE=0x1B
		-- BACKSPACE=0x08
		-- ENTER=0x0D

		-- SHIFT=0x10
		-- CTRL=0x11

		-- HOME=0x24
		-- END=0x23
		-- DELETE=0x2E

		-- LEFT=0x25
		-- RIGHT=0x27

end

------------------------------------------
---向文本缓冲区压入文本
---@param text string
---@param id number 若忽略这项则对所有缓冲区压入text
function KeyInputTemp:Push(text) 
	if not self.enable then return end
	if not text then return false end
	self.temp=self.temp..text 
end
function KeyInputTemp:Pull() 
	if not self.enable then return end
	if type(self.temp)=='string' then
		return self.temp end
end

function KeyInputTemp:BackSpace(num) 
	if not self.enable then return end
	self.temp=string.sub(self.temp,1,string.len(self.temp)-num)
end 
function KeyInputTemp:Clear() 
	if not self.enable then return end
	self.temp=''
end 
KeyInputTemp.Reset=KeyInputTemp.Clear
function KeyInputTemp:Deactivate(id) 
	self:Clear()
	self.enable=false
end
KeyInputTemp.Del=KeyInputTemp.Delete
KeyInputTemp.Recycle=KeyInputTemp.Delete

--重载
local OriginalFocusLoseFunc=FocusLoseFunc
function FocusLoseFunc()
	OriginalFocusLoseFunc()
	for i=0,7 do MouseState['MouseButton_'..i]=false end
end