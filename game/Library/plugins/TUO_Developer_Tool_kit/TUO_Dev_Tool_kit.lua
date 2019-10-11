------------------------------------------------
---TUO_Developer_Tool_kit 
---东方梦无垠开发者工具兼大型高危实验基地 
---code by JanrilW
---还没有完全插件化，请手动在FrameFunc和AfterRender那边加frame和render
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
---------------------------------------------------
TUO_Developer_Tool_kit = TUO_Developer_Tool_kit or {}
-- local self=TUO_Developer_Tool_kit
--载入其他部件
local PATH_HEAD='Library\\plugins\\TUO_Developer_Tool_kit\\'
local IncludePlus=function(path)
    if lfs.attributes(path) == nil then
        path=PATH_HEAD..path
    end 
    Include(path)
end

IncludePlus"TUO_Dev_HUD.lua"
IncludePlus"TUO_Dev_Panel_Define.lua"
IncludePlus"TUO_Dev_Widget_Template.lua"




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
		local r,err=xpcall(lstg.DoFile,debug.traceback,path)
		if r then 
			Log('成功重载脚本：'..path,2)
			-- flag=true
		else
			Log('重载脚本：'..path..' 的时候发生错误\n\t错误详细信息:\n\t\t'..err,1) 
		end
	else
		Log('脚本 '..path..' 不存在',1) 
	end
end
TUO_Developer_Tool_kit.ReloadSingleFile=ReloadSingleFile

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
TUO_Developer_Tool_kit.ReloadFiles=ReloadFiles

--------------------------------------------
---独立按键检测函数，这个每帧只能调用一次
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
TUO_Developer_Tool_kit.CheckKeyState=CheckKeyState

--------------------------------------------------
---用文本索引来返回其对应的值
---现在已经能接受类如 'lstg.var'这样的表中表的索引输入
---@param str string 
---@param value any 如果给出这个值那么函数会转而赋值而不是返回值
---@return any
function IndexValueByString(str,value)
	local tmp
	local tmp_k={}
	local i=1
	local pos=string.find(str,".",1,true)
	local pospre
	if not pos then 
		if value~=nil then _G[str]=value return
		else return _G[str] end
	else table.insert(tmp_k,string.sub(str,1,pos-1)) end
	while true do
		pospre=pos+1
		pos=string.find(str,".",pos+1,true)
		if not pos then
			table.insert(tmp_k,string.sub(str,pospre,114514))
			break
		else
		table.insert(tmp_k,string.sub(str,pospre,pos-1)) end
    end
	if not value then
		for k,v in pairs(tmp_k) do
			if k==1 then tmp=_G[v]
			else 
				if type(tmp)==nil then return nil end
				tmp=tmp[v] 
			end
		end
		return tmp
	else
		if #tmp_k == 1 then
			_G[tmp_k[1]]=value
		else
			for k,v in pairs(tmp_k) do
				if k==1 then tmp=_G[v]
				elseif k==#tmp_k then tmp[v]=value
				else tmp=tmp[v] end
			end
		end
	end
end


function TUO_Developer_Tool_kit:init()
	--
	self.ttf='f3_word'
	--这个文件可能放在这几个地方，所以都过一遍
	local ttfpath={"Library\\plugins\\TUO_Developer_Tool_kit\\simfang.ttf",
		"THlib\\exani\\times.ttf",
		"Library\\plugins\\TUO_Developer_Tool_kit\\times.ttf",
		"times.ttf"
	}
	local i=1
	while lfs.attributes(ttfpath[i])==nil do
		i=i+1
	end
	-- LoadSound('TUO_btn_click',PATH_HEAD..'btn_click.wav')
	LoadSound('TUO_Dev_HUD_unlock',PATH_HEAD..'TUO_Dev_HUD_unlock.wav')
	LoadSound('TUO_Dev_HUD_open',PATH_HEAD..'TUO_Dev_HUD_open.wav')
	LoadSound('TUO_Dev_HUD_close',PATH_HEAD..'TUO_Dev_HUD_close.wav')
	LoadSound('TUO_Dev_HUD_panel',PATH_HEAD..'TUO_Dev_HUD_panel.wav')
	RemoveResource('global',8,'f3_word')
	RemoveResource('stage',8,'f3_word')
	LoadTTF('f3_word',ttfpath[i],32)
	
	-- LoadTTF('f3_word','SimSun',32)
	self.visiable=false --标记界面是否可见
	self.locked=true --标记是否锁定
	self.unlock_time_limit=0
	self.UNLOCK_TIME_LIMIT=60
	self.unlock_count=0
	self.UNLOCK_COUNT=3
	self.hud=TUO_Developer_HUD
	self.hud:init()
	self:AddPanels()
	Log('初始化完毕',4)
end

function TUO_Developer_Tool_kit:frame()
	if not ext.pause_menu:IsKilled() then
		GetInputExtra()
	end
	--解锁需要在一秒内连按三下F3
	if self.locked then 
		if CheckKeyState(KEY.F3) then
			if self.unlock_time_limit<=0 then 
				self.unlock_time_limit=	self.UNLOCK_TIME_LIMIT
				self.unlock_count=1
			else
				self.unlock_count=self.unlock_count+1
			end
		end
		self.unlock_time_limit=max(0,self.unlock_time_limit-1)
		if self.unlock_time_limit<=0 then
			self.unlock_count=0
		end
		if self.unlock_count>=self.UNLOCK_COUNT and self.unlock_time_limit>0 then 
			self.locked=false 
			self.visiable = not self.visiable
			if self.visiable then Log('F3调试界面已开启') PlaySound('TUO_Dev_HUD_unlock',4)
			else Log('F3调试界面已关闭') end
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
			self:KillBoss()
		end
		if CheckKeyState(KEY.F8) then
			self:RefreshPanels()
		end
		if CheckKeyState(KEY.F3) then
			self.visiable = not self.visiable
			if self.visiable then 
				Log('F3调试界面已开启') 
				PlaySound('TUO_Dev_HUD_open',4)
			else
				Log('F3调试界面已关闭') 
				PlaySound('TUO_Dev_HUD_close',4)
			end
		end
		if CheckKeyState(KEY.F5) then
			if lstg.GetKeyState(KEY.SHIFT) then
				self:Reload()
			else
				self:RefreshPanels()
			end
		end
		--右键或者esc退出这个界面
		-- 不行这个太沙雕了
		-- if (lstg.GetMouseState(2) or lstg.GetKeyState(KEY.ESCAPE)) and self.visiable then self.visiable=false Log('F3调试界面已关闭') end
		if CheckKeyState(KEY.TAB) then
			local hud=self.hud
			local num=#hud.panel
			num=max(1,min(num))
			if lstg.GetKeyState(KEY.SHIFT) then
				if hud.cur==1 then hud.cur=num else hud.cur=hud.cur-1 end
			else
				if hud.cur==num then hud.cur=1 else hud.cur=hud.cur+1 end
			end
			PlaySound('TUO_Dev_HUD_panel',4)
		end
		--鼠标滚轮的操作写HUD里了

		if self.visiable then
			self.hud.timer=min(30,self.hud.timer+1)
		else 
			self.hud.timer=max(0,self.hud.timer-1)
		end
		--不显示的时候直接关掉frames
		if self.hud.timer>0 then self.hud:frame() end
	end
end
function TUO_Developer_Tool_kit:render()
	--这里用exanieditor的字体了
	if self.hud.timer>0 then
		self.hud:render()
	end
end

function TUO_Developer_HUD:KillBoss()
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

function TUO_Developer_Tool_kit:Reload()
	Log('开始重载整个插件',4)
	local ReloadSingleFile=function(path)
		if not(lfs.attributes(path) == nil) then 
			local r,err=xpcall(lstg.DoFile,debug.traceback,path)
			if r then 
				Log('成功重载脚本：'..path,2)
				-- flag=true
			else
				Log('重载脚本：'..path..' 的时候发生错误\n\t错误详细信息:\n\t\t'..err,1) 
			end
		else
			Log('脚本 '..path..' 不存在',1) 
		end
	end
	local PATH_HEAD='Library\\plugins\\TUO_Developer_Tool_kit\\'
	local DoFilePlus=function(path)
		if lfs.attributes(path) == nil then
			path=PATH_HEAD..path
		end 
		ReloadSingleFile(path)
	end
	TUO_Developer_Tool_kit = {}
	DoFilePlus"TUO_Dev_HUD.lua"
	DoFilePlus"TUO_Dev_Panel_Define.lua"
	DoFilePlus"TUO_Dev_Widget_Template.lua"
	DoFilePlus'TUO_Dev_Tool_kit.lua'
end



TUO_Developer_Tool_kit:init()

