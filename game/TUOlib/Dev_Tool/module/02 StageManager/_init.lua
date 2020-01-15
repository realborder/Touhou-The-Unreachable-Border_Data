local gametest = TUO_Developer_UI:NewModule()

---给道中分段用
debugPoint = debugPoint or 0
function gametest:init()
	self.name = "关卡调试"
end
local quickboost = TUO_Developer_UI:NewPanel()
function quickboost:init()
	self.name = "快速启动"
	Neww "title".text = "关卡列表"
	Neww "value_displayer".monitoring_value = function(self)
		return {{name = "stage.current_stage.name", v = stage.current_stage.name}}
	end

	Neww "text_displayer".text = "选择难度"
	local diff_list = Neww "list_box"
	Neww "text_displayer".text = "选择关卡"
	local stage_list = Neww "list_box"
	diff_list.width = 256
	diff_list._ban_mul_select = true
	stage_list._ban_mul_select = true
	stage_list.width = 256
	diff_list.refresh = function(self)
		self.display_value = {}
		for i, v in ipairs(stage.groups) do
			table.insert(self.display_value, {name = i, v = v})
		end
	end
	diff_list._event_mousepress = function(self)
		local cur
		-- TUO_Developer_Flow:MsgWindow(tostring(#(self.display_value)))
		local i, name, v = TUO_Developer_UI.GetListSingleSel(self)
		if i then
			cur = i
		end
		-- for i,v in pairs(self.selection) do
		--     if v then cur=i end break
		-- end
		local d
		if cur then
			d = self.display_value[cur].v
		end
		if d then
			stage_list.refresh = function(self)
				self.display_value = {}
				for i, v in ipairs(stage.groups[d]) do
					table.insert(self.display_value, {name = i, v = v})
				end
			end
		end
	end

	Neww "text_displayer".text = "选择机体"
	local plr_list = Neww "list_box"
	plr_list.width = 256
	plr_list.refresh = function(self)
		self.display_value = {}
		for i = 1, #player_list do
			table.insert(self.display_value, {name = i, v = player_list[i][1]})
		end
	end

	local start_btn = Neww "button"
	start_btn.text = "快速启动"
	start_btn._event_mouseclick = function(self)
		----------
		local _stage, plr_index
		local cur
		do
			local i, name, v = TUO_Developer_UI.GetListSingleSel(diff_list)
			if i then
				-- TUO_Developer_Flow:MsgWindow('关卡'..i)
				cur = i
			else
				TUO_Developer_Flow:ErrorWindow("无法进入关卡：关卡名错误")
			end
		end

		local d
		if cur then
			d = diff_list.display_value[cur].v
		end
		local i, name, v = TUO_Developer_UI.GetListSingleSel(plr_list)
		if i then
			-- TUO_Developer_Flow:MsgWindow('机体'..i)
			plr_index = i
		else
			TUO_Developer_Flow:ErrorWindow(
				"无法进入关卡：机体名错误\n    错误发生位置:  TUOlib\\Dev_Tool\\module\\StageManager\\_init.lua:75"
			)
		end
		-- if d and plr_index then
		ResetPool()
		if string.find(tostring(stage.current_stage.name), "@", 1, true) ~= nil then
			stage.current_stage.task[1] =
				coroutine.create(
				function()
				end
			)
		end

		scoredata.player_select = plr_index
		lstg.var.player_name = player_list[plr_index][2]
		lstg.var.rep_player = player_list[plr_index][3]
		stage.group.Start(stage.groups[d])
		TUO_Developer_UI.cur = 1
		-- end
	end
	local start_btn2 = Neww "button"
	start_btn2.text = "单关练习"
	start_btn2._stay_in_this_line = true
	start_btn2._event_mouseclick = function(self)
		local _stage, plr_index
		local cur
		do
			local i, name, v = TUO_Developer_UI.GetListSingleSel(stage_list)
			if i and v then
				-- TUO_Developer_Flow:MsgWindow('关卡'.._stage)
				cur = i
				_stage = v
			else
				TUO_Developer_Flow:ErrorWindow("无法进入关卡：关卡名错误")
			end
		end

		local d
		if cur then
			d = diff_list.display_value[cur].v
		end
		local i, name, v = TUO_Developer_UI.GetListSingleSel(plr_list)
		if i then
			-- TUO_Developer_Flow:MsgWindow('机体'..i)
			plr_index = i
		else
			TUO_Developer_Flow:ErrorWindow(
				"无法进入关卡：机体名错误\n    错误发生位置:  TUOlib\\Dev_Tool\\module\\StageManager\\_init.lua:75"
			)
		end
		if string.find(tostring(stage.current_stage.name), "@", 1, true) ~= nil then
			stage.current_stage.task[1] =
				coroutine.create(
				function()
				end
			)
			-- stage.current_stage.task[2]=coroutine.create(function() end)
			stage.group.FinishStage()
		end
		ResetPool()
		scoredata.player_select = plr_index
		lstg.var.player_name = player_list[plr_index][2]
		lstg.var.rep_player = player_list[plr_index][3]
		stage.group.PracticeStart(_stage)
		TUO_Developer_UI.cur = 1
	end

	Neww "value_displayer".monitoring_value = "stage.groups"
end

local scprac=TUO_Developer_UI:NewPanel()
function scprac:init()
	self.name="符卡练习"
	Neww'title'.text="符卡练习"
	Neww'text_displayer'.text="boss索引"
	local cb1=	Neww'checkbox_l'
	cb1.display_value={"1A","1B","2","3","4","5","6A","6B","EX"}
	cb1.width=304
	Neww'text_displayer'.text="选择难度"
	local cb2=	Neww'checkbox_l'
	cb2.display_value={"Easy","Normal","Hard","Lunatic","Extra"}
	cb2.width=304
	local list1=Neww'list_box'
	list1.width=304
	list1.monitoring_value=function()
		local ret={}
		if cb1.cur then
			local tb=_sc_table_new[cb1.cur_value]
			if not tb then return end
			for i,v in ipairs(tb) do
				---@type cardinfo
				local c=v
				local name
				if type(c.card_name)=='table' then
					if cb2.cur then
						name=c.card_name[cb2.cur]
					else
						name=table.concat(c.card_name,", ")
					end
				else
					name=c.card_name[cb2.cur]
				end
				if name=='' then name="通常弹幕"
					table.insert(ret,name)
				end
			end
		end
		return ret
	end
	local btn1=Neww'button'
	btn1.text="开始"
	Neww'value_displayer'.monitoring_value=_sc_table_new
end


local modmgr = TUO_Developer_UI:NewPanel()
function modmgr:init()
	self.name = "mod包管理"

	Neww "title".text = "mod包列表"
	Neww "text_displayer".text =
		"以下是所有mod文件夹中有zip后缀名的文件列表，已默认加载文件名中带有\n“STAGE”的文件。\n请注意，安全模式仅保证加载mod时出错不会使游戏报错退出，不保证运行时\n出错退出。"

	local list = Neww "list_box"
	list.refresh = function(self)
		self.display_value = {}
		for k, v in pairs(tuolib.mod_manager.modlist) do
			table.insert(self.display_value, {name = k, v = tostring(v)})
		end
	end
	TUO_Developer_UI.SetWidgetSlot("slot2")
	local title2 = Neww "title"
	title2.text = "操作"

	local swc_reload = Neww "switch"
	swc_reload.text_on = "保护模式 开"
	swc_reload.text_off = "保护模式 关"
	swc_reload.monitoring_value = "tuolib.mod_manager.protect_mode"
	local btn_refresh = Neww "button"
	btn_refresh.text = "刷新列表"
	btn_refresh._event_mouseclick = function(self)
		tuolib.mod_manager:RefreshModList()
	end
	local btn_reload = Neww "button"
	btn_reload.text = "加载Mod"
	btn_reload._event_mouseclick = function(self)
		for k, v in pairs(list.display_value) do
			if list.selection[k] then
				-- local r=lstg.FindFiles('_editor_output.lua',v.name)
				-- TUO_Developer_Flow:MsgWindow(tostring(r))
				local r, err = tuolib.mod_manager.LoadMod(v.name)
				if not r then
					TUO_Developer_Flow:ErrorWindow(err)
				else
					TUO_Developer_Flow:MsgWindow("成功加载：" .. v.name)
					InitAllClass()
				end
			end
		end
	end
	local btn_reloadall = Neww "button"
	btn_reloadall.text = "卸载Mod"
	btn_reloadall._event_mouseclick = function(self)
		for k, v in pairs(list.display_value) do
			if list.selection[k] then
				tuolib.mod_manager.UnloadMod(v.name)
				TUO_Developer_Flow:MsgWindow("成功卸载：" .. v.name)
			end
		end
	end
	local totop = Neww "button"
	totop.text = "回到顶部"
	totop.gap_t = 12
	totop._event_mouseclick = function(widget)
		widget.panel.y_offset_aim = 0
	end
	local rev = Neww "button"
	rev.text = "反转逻辑值"
	rev._event_mouseclick = function(widget)
		for k, v in pairs(list.display_value) do
			if list.selection[k] then
				tuolib.mod_manager.modlist[v.name] = not tuolib.mod_manager.modlist[v.name]
			end
		end
	end
	local revsel = Neww "button"
	revsel.text = "反选"
	revsel.gap_t = 12
	revsel._event_mouseclick = function(widget)
		for i = 1, #list.display_value do
			list.selection[i] = not list.selection[i]
		end
	end
	local selall = Neww "button"
	selall.text = "全选"
	selall._event_mouseclick = function(widget)
		list.selection = {}
		for i = 1, #list.display_value do
			list.selection[i] = true
		end
	end
	local diselall = Neww "button"
	diselall.text = "全不选"
	diselall._event_mouseclick = function(widget)
		list.selection = {}
	end
end
local steptest = TUO_Developer_UI:NewPanel()
function steptest:init()
	self.name = "步进调试"
	self.ban_framefunc_timer = 0
	self.left_for_world = true
	-- local world_switch=TDU_New_switch(self,'world')
	-- world_switch._event_switched=function(self,v)
	-- steptest.left_for_world=v end
	TUO_Developer_UI.SetWidgetSlot("world")
	Neww "title".text = "步进调试"
	local sw1 = Neww "switch"
	sw1.monitoring_value = "TUO_Developer_Tool_kit.ban_framefunc"
	sw1.text_on = "已冻结帧函数"
	sw1.text_off = "已解冻帧函数"
	local sw2 = Neww "switch"
	sw2.monitoring_value = "TUO_Developer_Tool_kit.ban_renderfunc"
	sw2.text_on = "已冻结帧渲染函数"
	sw2.text_off = "已解冻帧渲染函数"
	local btn1 = Neww "button"
	btn1.text = "前进一帧"
	btn1._event_mouseclick = function(widget)
		TUO_Developer_Tool_kit.ban_framefunc = false
		steptest.ban_framefunc_timer = 1
	end
end
function steptest:frame()
	self.ban_framefunc_timer = self.ban_framefunc_timer - 1
	if self.ban_framefunc_timer == 0 then
		TUO_Developer_Tool_kit.ban_framefunc = true
	end
end
