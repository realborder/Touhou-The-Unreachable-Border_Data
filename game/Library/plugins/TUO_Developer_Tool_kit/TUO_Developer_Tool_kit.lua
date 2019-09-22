------------------------------------------------
--开发工具
--F3可以开关调试界面（第一次开启需要快速连按3下）
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
--!注意，插件外的鼠标滚轮状态获取函数可能会失效，如有需要请把这里的移出去
TUO_Developer_Tool_kit = {}
local self=TUO_Developer_Tool_kit
--这个是界面
Include("Library\\plugins\\TUO_Developer_Tool_kit\\TUO_Developer_HUD.lua")

--独立按键检测
local _KeyDown={}

local PATH={
	FILE_RELOAD='Library\\plugins\\filereloadlist.lua'
}
--简易的日志输出
local ENABLED_LOG_LEVEL=4
local Log=function (text,level) 
	level=level or 4
	if level>ENABLED_LOG_LEVEL then return end
	Print('[TUO_Developer_Tool_kit] '..text) 
end

---------------------------------------------
---重载外部文件或者程序内部指定的单个脚本
---@param path string 脚本的路径
local ReloadSingleFile=function(path)
	if not(lfs.attributes(path) == nil) then 
		local err
		local r,msg=xpcall(lstg.DoFile,function() err=debug.traceback() end,path)
		if r then 
			Log('成功重载脚本：'..path,2)
			flag=true
		else
			Log('重载脚本：'..path..' 的时候发生错误\n\t行数:'..msg..'\n\t错误详细信息:\n\t\t'..err,1) 
		end
	else
		Log('脚本 '..path..' 不存在',1) 
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
				Log('重载列表为空',2)  
			end
		else
			Log('重载列表不存在，尝试生成 Library\\plugins\\filereloadlist.lua 添加项目',1)
			local text='local tmp={\n	--请在下方添加文件路径\n	--"",\n}\nreturn tmp'
			local f,msg=io.open(PATH.FILE_RELOAD)
			if f then 
				f.write(text)
				f.close()
			else
				Log('生成失败？？\n'..msg,1)
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
--------------------------------------------
---添加面板，为了方便阅读相关内容全部放在这里
function TUO_Developer_Tool_kit.AddPanels()
	
	---键盘输入监测（已完成）---------------------------------------------------------
	
	self.hud.NewPanel('Key State',nil,nil,
	function (panel)
		panel.KeyTrigger={}
		for k,v in pairs(KeyState) do
			panel.KeyTrigger[k]=KeyTrigger(k)
		end
	end,
	function (panel)
		TUO_Developer_HUD.DisplayValue(panel,'Table:KeyState',80,KeyState)
		TUO_Developer_HUD.DisplayValue(panel,'Table:KeyStatePre',80,KeyStatePre)		
		TUO_Developer_HUD.DisplayValue(panel,'Table:setting.keys',440,setting.keys)
		TUO_Developer_HUD.DisplayValue(panel,'KeyTrigger',260,panel.KeyTrigger)
	end)


	---手柄输入监测（已完成）---------------------------------------------------------

	self.hud.NewPanel('Joystick State',function()
			local t={}
			for i=1,32 do
				table.insert(t,{name='JOY1_'..i,v=lstg.GetKeyState(KEY['JOY1_'..i])})
			end
			-- 在只插入一个手柄的情况下joy1和joy2是重复的
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
			TUO_Developer_HUD.DisplayValue(panel,'Table:JoyState',80,JoyState)
			TUO_Developer_HUD.DisplayValue(panel,'Table:JoyStatePre',80,JoyStatePre)
			TUO_Developer_HUD.DisplayValue(panel,'JoyStickState',260,panel.joystick_detailed_state)
			TUO_Developer_HUD.DisplayValue(panel,'JoyStickTrigger',260,panel.JoyTrigger)
			TUO_Developer_HUD.DisplayValue(panel,'Table:setting.joysticks',440,setting.joysticks)
		end)

	---鼠标输入监测----------------------------------------------------------------------

	self.hud.NewPanel('Mouse State',function()
			local t={}
			local x,y=GetMousePosition()
			local mouse={}
			for i=0,7 do
				table.insert(mouse,lstg.GetMouseState(i))
			end
			local wheel=lstg.GetMouseWheelDelta()
			--!注意，插件外的鼠标滚轮状态获取函数可能会失效，如有需要请把这里的移出去
			table.insert(t,{name='MouseX',v=x})
			table.insert(t,{name='MouseY',v=y})
			for i=1,8 do
				table.insert(t,{name='Button'..(i),v=mouse[i]})
			end
			table.insert(t,{name='WheelDelta',v=wheel})
			return t
		end)
	---游戏变量监测---------------------------------------------------------
	--包括以下数值的显示和修改：
	--------（游戏基本数值）分数，残机，奖残计数，符卡，符卡奖励计数，灵力，灵力上限，最大得点，擦弹，擦弹计数，每个单位的hp
	--------（特殊系统数值）梦现指针值，连击数，玩家对每个单位的DPS
	--------（关卡debug）设置和快速重启关卡并跳转到指定部分，设置和跳过boss符卡，（以多种模式）查看、输出和调整判定

	self.hud.NewPanel('Basic Variable')
	self.hud.NewPanel('Dream & Reality')
	self.hud.NewPanel('Stage & Boss')


	---资源列表显示和快速重载（可能需要修改loadImage等等的定义）---------------------------------------------------------

	self.hud.NewPanel('Resource')
	

	---使用脚本列表显示和快速重载---------------------------------------------------------
	---相关代码：Include定义

	self.hud.NewPanel('Lua Scripts')


	---背景脚本的3D参数显示，可直接在游戏内调整和写入3D背景参数---------------------------------------------------------

	self.hud.NewPanel('3D Background')

	---临时变量监测（支持在外部动态添加）---------------------------------------------------------

	self.hud.NewPanel('Quick Monitor')



end


function TUO_Developer_Tool_kit.init()
	--
	self.ttf='f3_word'
	-- LoadTTF('f3_word','THlib\\UI\\ttf\\yrdzst.ttf',32)
	LoadTTF('f3_word','THlib\\exani\\times.ttf',32)
	self.visiable=false --标记界面是否可见
	self.locked=true
	self.unlock_time_limit=0
	self.unlock_count=1
	self.hud=TUO_Developer_HUD
	self.hud.init()
	self.AddPanels()
	Log('初始化完毕',4)
end

function TUO_Developer_Tool_kit.frame()
	--解锁需要在一秒内连按三下F3
	if self.locked then 
		if CheckKeyState(KEY.F3) then
			if self.unlock_time_limit<=0 then 
				self.unlock_time_limit=60
				self.unlock_count=1
			else
				self.unlock_count=self.unlock_count+1
			end
		end
		self.unlock_time_limit=max(0,self.unlock_time_limit-1)
		if self.unlock_time_limit<=0 then
			self.unlock_count=0
		end
		if self.unlock_count>=3 and self.unlock_time_limit>0 then 
			self.locked=false 
			self.visiable = not self.visiable
			if self.visiable then Log('F3调试界面已开启') else Log('F3调试界面已关闭') end
		end
	else
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
			if self.visiable then Log('F3调试界面已开启') else Log('F3调试界面已关闭') end
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
end
function TUO_Developer_Tool_kit.render()
--这里用exanieditor的字体了
	if self.hud.timer>0 then
		self.hud.render()
	end
end

TUO_Developer_Tool_kit.init()