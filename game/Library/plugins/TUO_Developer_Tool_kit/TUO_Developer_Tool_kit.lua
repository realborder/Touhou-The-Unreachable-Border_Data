------------------------------------------------
--开发工具
--F3可以开关调试界面
--F6刷新输入设备
--F9
-----如果boss不存在，则跳过一个chapter（推荐在关卡开头使用）
-----如果boss存在则杀掉boss一身
--F10
--重载指定文件（filereloadlist.lua），如果同时按住shift则直接全部重载（也就是返回stageinit）
--计划中的功能：
--背景调试：读取位于Library\TUO_Developer_Tool_kit\bg中的所有lua文件，提取其中所有资源加载函数中的资源名并卸载，然后重载这些lua文件，并将lstg.bg删除，然后替换为新的背景脚本
--------------按下某个键可以改变背景的phase
--重载指定关卡
--
--这个是界面
Include("Library\\plugins\\TUO_Developer_Tool_kit\\TUO_Developer_HUD.lua")

--独立按键检测
local _KeyDown={}

local PATH={
	FILE_RELOAD='Library\\plugins\\filereloadlist.lua'
}
local Log=function (text) Print('[TUO_Developer_Tool_kit] '..text) end

---------------------------------------------
---重载外部文件或者程序内部指定的单个脚本
---@param path string 脚本的路径
local ReloadSingleFile=function(path)
	if not(lfs.attributes(path) == nil) then 
		local err
		local r,msg=xpcall(lstg.DoFile,function() err=debug.traceback() end,path)
		if r then 
			Log('成功重载脚本：'..path)
			flag=true
		else
			Log('重载脚本：'..path..' 的时候发生错误\n\t行数:'..msg..'\n\t错误详细信息:\n\t\t'..err) 
		end
	else
		Log('脚本 '..path..' 不存在') 
	end
end


---------------------------------------------
---重载指定（多个）脚本
---@param path string 若提供具体文件路径那就重载提供了路径的脚本，也可以传一个表进去
local ReloadFiles = function (path)
	Log('尝试重载指定脚本')
	if path then
		if type(path)=='string' then
			ReloadSingleFile(path)
		elseif type(path)=='table' then
			for k,v in pairs(path) do ReloadSingleFile(v) end
		end
	else
		if not(lfs.attributes(PATH.FILE_RELOAD) == nil) then 
			local list=lstg.DoFile(PATH.FILE_RELOAD) 
			local flag=false
			for k,v in pairs(list) do ReloadSingleFile(v)
			end
			if flag then  
				InitAllClass() --如果有成功重载就初始化所有类
			else 
				Log('重载列表为空')  
			end
		else
			Log('重载列表不存在，尝试生成 Library\\plugins\\filereloadlist.lua 添加项目')
			local text='local tmp={\n	--请在下方添加文件路径\n	--"",\n}\nreturn tmp'
			local f,msg=io.open(PATH.FILE_RELOAD)
			if f then 
				f.write(text)
				f.close()
			else
				Log('生成失败？？\n'..msg)
			end
		end
	end
end

--------------------------------------------
---独立按键检测函数
---@return boolean 返回键值状态
local CheckKeyState= function (k)
	if not _KeyDown[k] then _KeyDown[k]=false end
	if lstg.GetKeyState(k) then
		if not _KeyDown[k] then
			_KeyDown[k] = true
			return true
		end
	else
		_KeyDown[k] = false
	end
	return false
end



TUO_Developer_Tool_kit = {}
function TUO_Developer_Tool_kit.init()
	local self=TUO_Developer_Tool_kit
	--
	LoadTTF('f3_word','THlib\\exani\\times.ttf',32)
	self.visiable=false --标记界面是否可见

	self.hud=TUO_Developer_HUD
	self.hud.init()
	------------------------------------------------------------
	self.hud.NewPanel('KeyState',nil,nil,
	function(panel)

	end,
	function (panel)
		panel.KeyTrigger={}
		for k,v in pairs(KeyState) do
			panel.KeyTrigger[k]=KeyTrigger(k)
		end
		TUO_Developer_HUD.DisplayValue(panel,'Table:setting.keys',440,setting.keys)
		TUO_Developer_HUD.DisplayValue(panel,'KeyTrigger',260,panel.KeyTrigger)
		TUO_Developer_HUD.DisplayValue(panel,'Table:KeyState',80,KeyState)
		TUO_Developer_HUD.DisplayValue(panel,'Table:KeyStatePre',80,KeyStatePre)
	end)
	------------------------------------------------------------
	self.hud.NewPanel('Joystick State',function()
			local t={}
			for i=1,32 do
				table.insert(t,{name='JOY1_'..i,v=lstg.GetKeyState(KEY['JOY1_'..i])})
			end
			-- for i=1,32 do
			-- 	t['JOY2_'..i]=lstg.GetKeyState(KEY['JOY1_'..i])
			-- end
			return t
		end,
		nil,function (panel)
			--获取手柄的摇杆和扳机状态
			panel.joystick_detailed_state={}
			local t=panel.joystick_detailed_state
			t.leftX,t.leftY,t.ringtX,t.ringtY=lstg.XInputManager.GetThumbState(1)
			t.leftT,t.rightT=lstg.XInputManager.GetTriggerState(1)  
			panel.JoyTrigger={}
			for k,v in pairs(JoyState) do
				panel.JoyTrigger[k]=KeyTrigger(k)
			end
		end,
		function(panel)
			TUO_Developer_HUD.DisplayValue(panel,'JoyStickState',80,panel.joystick_detailed_state)
			TUO_Developer_HUD.DisplayValue(panel,'JoyStickTrigger',80,panel.JoyTrigger)
			TUO_Developer_HUD.DisplayValue(panel,'Table:JoyState',260,JoyState)
			TUO_Developer_HUD.DisplayValue(panel,'Table:JoyStatePre',260,JoyStatePre)
		end)
	------------------------------------------------------------
	self.hud.NewPanel('Game Variable')
	self.hud.NewPanel('Resource')
	self.hud.NewPanel('Scripts')
	Log('初始化完毕')
end

function TUO_Developer_Tool_kit.frame()
	local self=TUO_Developer_Tool_kit

	if CheckKeyState(KEY.F10) then 
		if lstg.GetKeyState(KEY.SHIFT) then 
			ResetPool()
			lstg.included={}
			stage.Set('none', 'init') 
		else ReloadFiles() end
	end
	if CheckKeyState(KEY.F9) then
		do
			--适配多boss
			local boss_list={}
			for _,o in ObjList(GROUP_ENEMY) do
				if o._bosssys then table.insert(boss_list,o) end
			end
			if #boss_list>0 and (not lstg.GetKeyState(KEY.SHIFT)) then 
				for i=1,#boss_list do boss_list[i].hp=0 end
			elseif debugPoint then
				if lstg.GetKeyState(KEY.SHIFT) then 
					debugPoint=debugPoint-1
				else 
					debugPoint=debugPoint+1 end
			end
		end
	end
	if CheckKeyState(KEY.F3) then
		self.visiable = not self.visiable
		if self.visiable then Log('F3已开启') else Log('F3已关闭') end
	end
	if CheckKeyState(KEY.TAB) then
		local hud=self.hud
		local num=#hud.panel
		num=max(1,min(num))
		if lstg.GetKeyState(KEY.SHIFT) then
			if hud.cur==1 then hud.cur=num else hud.cur=hud.cur-1 end
		else
			if hud.cur==num then hud.cur=1 else hud.cur=hud.cur+1 end
		end
	end
	if self.visiable then
		self.hud.timer=min(30,self.hud.timer+1)
	else 
		self.hud.timer=max(0,self.hud.timer-1)
	end
	self.hud.frame()
end
function TUO_Developer_Tool_kit.render()
--这里用exanieditor的字体了
	local self=TUO_Developer_Tool_kit
	if self.hud.timer>0 then
		self.hud.render()
		
		
	end
	
end
TUO_Developer_Tool_kit.init()


