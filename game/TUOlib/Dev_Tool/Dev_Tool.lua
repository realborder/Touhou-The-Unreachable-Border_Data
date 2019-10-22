-------------------------------------
---开发者工具
---code by JanrilW
---不打算去插件化，而是直接内含在游戏内部
---
---

TUO_Developer_Tool_kit = TUO_Developer_Tool_kit or {}
-- local self=TUO_Developer_Tool_kit
--载入其他部件
local PATH_HEAD='TUOlib\\Dev_Tool\\'
local IncludePlus=function(path)
    if lfs.attributes(path) == nil then
        path=PATH_HEAD..path
    end 
    Include(path)
end
--简易的日志输出
local ENABLED_LOG_LEVEL=4
local Log=function (text,level) 
	level=level or 4
	if level>ENABLED_LOG_LEVEL then return end
	Print('[TUO_Developer_Tool_kit] '..text) 
end
local DT_FILE_LIST={
	"Dev_UI.lua", --UI层
	"Dev_Module.lua", --UI里的模块
	"Dev_Panel.lua", --UI里的模块里的面板
	"Dev_Widget.lua", --UI里的模块里的面板里的控件
	"Dev_UI_Widget_Template.lua", --UI里的模块里的面板里的控件的模版
	"Dev_Flow.lua", --UI全局浮动面板
	"Dev_Flow_Template.lua", --UI全局浮动面板的模板
	"Dev_Tool_functions.lua" --其他功能
}
for k,v in pairs(DT_FILE_LIST) do IncludePlus(v) end





local PATH={FILE_RELOAD='Library\\plugins\\filereloadlist.lua'}


function TUO_Developer_Tool_kit:LoadResource()
	--这个文件可能放在这几个地方，所以都过一遍
	local ttfpath={"TUOlib\\Dev_Tool\\simfang.ttf",
		"THlib\\exani\\times.ttf",
		"TUOlib\\Dev_Tool\\times.ttf",
		"times.ttf"
	}
	local i=1
	while lfs.attributes(ttfpath[i])==nil do
		i=i+1
	end
	local path=PATH_HEAD.."Dev_Tool_logo.png"
	if not (lfs.attributes(path) == nil) then
		LoadImageFromFile('_Dev_UI_Logo',path)
	else
		self.no_logo=true
	end
	do
		local PATH_HEAD=PATH_HEAD..'sound\\'
		LoadSound('TUO_Dev_HUD_unlock',PATH_HEAD..'TUO_Dev_HUD_unlock.wav')
		LoadSound('TUO_Dev_HUD_open',PATH_HEAD..'TUO_Dev_HUD_open.wav')
		LoadSound('TUO_Dev_HUD_close',PATH_HEAD..'TUO_Dev_HUD_close.wav')
		LoadSound('TUO_Dev_HUD_panel',PATH_HEAD..'TUO_Dev_HUD_panel.wav')
		RemoveResource('stage',8,'f3_word')
		LoadTTF('f3_word',ttfpath[i],32)
		self.ttf='f3_word'
		-- LoadTTF('f3_word','SimSun',32)
	end

	
end

function TUO_Developer_Tool_kit:SortAllTemplate()
	local t=self.ui.TemplateWidget
	for k,v in pairs(t) do
		_G['TDU_New_'..k]=function(self,x)
			x=TUO_Developer_Tool_kit.ui.widget_x_pos or x
			return TUO_Developer_UI:AttachWidget(self,k,x) end
	end
	function TDU_New(Template)
		return _G['TDU_New_'..Template]
	end
end

function TUO_Developer_Tool_kit:LoadAllModule()
	local folders=plus.EnumFiles(PATH_HEAD..'\\module')
	for i,v in pairs(folders) do
		if v.isDirectory then
			local PATH=PATH_HEAD..'module\\'..v.name..'\\'
			---!!!注意这里添加面板的逻辑是载入一个模块后把新增的面板塞进模块里，对模块的排序必须放在后面
			self.ui._panel_temp={}
			self.ReloadSingleFile(PATH..'_init.lua')
			self.ui.module[#self.ui.module].panel=self.ui._panel_temp
			self.ui._panel_temp=nil
			if not(lfs.attributes(PATH..'logo.png')==nil) then
				Log('发现logo: '..v.name)
				self.ui.module[#self.ui.module].logo='_Dev_Module_'..v.name
				LoadImageFromFile('_Dev_Module_'..v.name,PATH..'logo.png')

			end

		end
	end
	for k,v in pairs(self.ui.module) do 
		if v.init then v:init() end 
		if v.panel then
			for _,panel in pairs(v.panel) do
				self.ui.SetWidgetSlot()
				if panel.init then panel:init() end
				if panel.widget then
					for _,widget in pairs(panel.widget) do
						if widget.init then widget:init() end
					end
				end
			end
			if #(v.panel)~=0 then v.cur=1 end
		end
	end
	--排序
	-- table.sort(self.ui.module,
	-- function(v1,v2) 
	-- 	local 
		
	-- end)
end


function TUO_Developer_Tool_kit:init()
	--
	self:LoadResource()
	self.visiable=false --标记界面是否可见
	self.locked=true --标记是否锁定
	self.unlock_time_limit=0
	self.UNLOCK_TIME_LIMIT=60
	self.unlock_count=0
	self.UNLOCK_COUNT=3
	self.mouse_click_list={}
	self.mouseR_click_list={}
	self.ui=TUO_Developer_UI
	self.ui:init()
	self:SortAllTemplate()
	self:LoadAllModule()
	self.flow=TUO_Developer_Flow
	self.flow:init()
	Log('初始化完毕',4)
end

function TUO_Developer_Tool_kit:frame()
	local CheckKeyState=self.CheckKeyState
	--切关时迷之报错，拿这个先顶一下	
	if stage.next_stage then return end
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
			self.ui.visiable = not self.ui.visiable
			if self.ui.visiable then Log('F3调试界面已开启') PlaySound('TUO_Dev_HUD_unlock',4)
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
			self.ui.visiable = not self.ui.visiable
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
				-- self:RefreshPanels()
			end
		end
		if CheckKeyState(KEY.TAB) then end
		if not self.flow.ban_UI_frame then
			self.ui:frame()
		end
		self.flow:frame()
	end
	--点击效果
	if MouseTrigger(0) and self.mouse_click_list then
		table.insert(self.mouse_click_list,{x=MouseState.x_in_UI,y=MouseState.y_in_UI,timer=20})
	end 
	if MouseTrigger(2) and self.mouseR_click_list then
		table.insert(self.mouseR_click_list,{x=MouseState.x_in_UI,y=MouseState.y_in_UI,timer=20})
	end 

end
function TUO_Developer_Tool_kit:render()
	--切关时迷之报错，拿这个先顶一下
	if stage.next_stage or not self.ui then return end
	SetViewMode'ui'
	if self.ui.timer~=0 then
		self.ui:render()
	end
	if self.flow then
		self.flow:render() 
	end


	--点击效果
	if self.mouse_click_list then
        for i, v in pairs(self.mouse_click_list) do
            v.timer=v.timer-1
            if v.timer<=0 then self.mouse_click_list[i]=nil end
			for i=0,2,0.5 do
				sp.misc.DrawCircle2(v.x,v.y,(1+2*sin(90*(20-v.timer)/20))*(10+i),32,'mul+rev',(2-i)*30*v.timer/20,255,255,255,0)
			end
			sp.misc.DrawCircle2(v.x,v.y,(1+2*sin(90*(20-v.timer)/20))*10,32,'mul+add',150*v.timer/20,255,255,255,0)

		end
	end
	if self.mouseR_click_list then
        for i, v in pairs(self.mouseR_click_list) do
            v.timer=v.timer-1
            if v.timer<=0 then self.mouseR_click_list[i]=nil end
			for i=0,2,0.5 do
				sp.misc.DrawCircle2(v.x,v.y,(1+2*sin(90*(20-v.timer)/20))*(10+i),32,'mul+alpha',(2-i)*30*v.timer/20,255,255,255,0)
			end
			sp.misc.DrawCircle2(v.x,v.y,(1+2*sin(90*(20-v.timer)/20))*10,32,'mul+rev',150*v.timer/20,255,255,255,0)
		end
	end
end

function TUO_Developer_Tool_kit:Reload()
	Log('开始重载整个插件',4)
	local errwin=TUO_Developer_Flow.ErrorWindow
	local ReloadSingleFile=function(path)
		if not(lfs.attributes(path) == nil) then 
			local r,err=xpcall(lstg.DoFile,debug.traceback,path)
			if r then 
				Log('成功重载脚本：'..path,2)
				-- flag=true
			else
				Log('重载脚本：'..path..' 的时候发生错误\n\t错误详细信息:\n\t\t'..err,1) 
				errwin(err)
			end
		else
			Log('脚本 '..path..' 不存在',1) 
		end
	end
	local PATH_HEAD='TUOlib\\Dev_Tool\\'
	local DoFilePlus=function(path)
		if lfs.attributes(path) == nil then
			path=PATH_HEAD..path
		end 
		ReloadSingleFile(path)
	end
	TUO_Developer_Tool_kit = {}
	for k,v in pairs(DT_FILE_LIST) do DoFilePlus(v) end
	DoFilePlus'Dev_Tool.lua'
end

TUO_Developer_Tool_kit:init()

