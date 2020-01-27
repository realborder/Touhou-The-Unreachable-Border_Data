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
			table.insert(self.display_value, { name = i, v = v })
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
					table.insert(self.display_value, { name = i, v = v })
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
			table.insert(self.display_value, { name = i, v = player_list[i][1] })
		end
	end

	local m1, m2, m3, m4

	m2 = Neww "value_displayer"
	m2.monitoring_value = function(self)
		return { { name = "stage.current_stage.name", v = stage.current_stage.name } }
	end
	m2.visiable = false

	m3 = Neww "value_displayer"
	m3.monitoring_value = function(self)
		return { { name = "lstg.var.start_from_boss", v = lstg.var.start_from_boss } }
	end
	m3.visiable = false

	m4 = Neww "value_displayer"
	m4.monitoring_value = function(self)
		return { { name = "debugPoint", v = debugPoint } }
	end
	m4.visiable = false

	m1 = Neww "value_displayer"
	m1.monitoring_value = "stage.groups"
	m1.visiable = false




	TUO_Developer_UI.SetWidgetSlot('slot2')
	Neww 'title'.text = '操作'
	local cb1
	--------------------------------------------
	local start_btn = Neww "button"
	start_btn.text = "快速启动"
	start_btn._event_mouseclick = function(self)
		lstg.var.start_from_boss = false
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
			plr_index = i
		else
			TUO_Developer_Flow:ErrorWindow("无法进入关卡：机体名错误")
		end
		ResetPool()
		if string.find(tostring(stage.current_stage.name), "@", 1, true) ~= nil then
			stage.group.ReturnToTitle()
			return
		end

		scoredata.player_select = plr_index
		lstg.var.player_name = player_list[plr_index][2]
		lstg.var.rep_player = player_list[plr_index][3]
		stage.group.Start(stage.groups[d])
		TUO_Developer_UI.cur = 1
	end
	--------------------------------------------
	local start_btn2 = Neww "button"
	start_btn2.text = "单关练习"
	start_btn2._event_mouseclick = function(self)
		lstg.var.start_from_boss = false
		debugPoint=cb1.cur-1
		local _stage, plr_index
		local cur
		do
			local i, name, v = TUO_Developer_UI.GetListSingleSel(stage_list)
			if i and v then
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
			plr_index = i
		else
			TUO_Developer_Flow:ErrorWindow("无法进入关卡：机体名错误")
		end
		if string.find(tostring(stage.current_stage.name), "@", 1, true) ~= nil then
			stage.group.ReturnToTitle()
			return
		end
		ResetPool()
		scoredata.player_select = plr_index
		lstg.var.player_name = player_list[plr_index][2]
		lstg.var.rep_player = player_list[plr_index][3]
		stage.group.PracticeStart(_stage)
		TUO_Developer_UI.cur = 1
	end
	--------------------------------------------
	local start_btn3 = Neww "button"
	start_btn3.text = "boss练习"
	start_btn3._event_mouseclick = function(widget)
		start_btn2._event_mouseclick()
		lstg.var.start_from_boss = true
	end
	--------------------------------------------
	local rtn_btn = Neww 'button'
	rtn_btn.text = '返回到标题菜单'
	rtn_btn._event_mouseclick = function(widget)
		if stage.current_stage.stage_name then
			ResetPool()
			stage.group.ReturnToTitle()
		end
	end
	--------------------------------------------


	Neww 'text_displayer'.text = "要跳过的道中块"
	cb1 = Neww 'checkbox_l'
	cb1.display_value = {}
	for i = 0, 9 do
		table.insert(cb1.display_value, tostring(i))
	end
	cb1.width = start_btn.width
	cb1.cur = 1
	cb1._event_mouseclick = function(widget)
		debugPoint = widget.cur - 1
	end

	local sw1 = Neww 'switch'

	sw1.text_on = "详细信息 开"
	sw1.text_off = "详细信息 关"
	sw1.width = 150
	sw1._event_switched = function(widget, flag)
		m1.visiable = flag
		m2.visiable = flag
		m3.visiable = flag
		m4.visiable = flag
	end

	-- 调试参数

	Neww 'title'.text = '保护选项'
	local sw21 = Neww 'switch'
	local sw22 = Neww 'switch'
	local sw23 = Neww 'switch'
	local sw24 = Neww 'switch'
	local sw25 = Neww 'switch'
	sw21.text_on, sw21.text_off = 'current_stage:frame', 'current_stage:frame'
	sw22.text_on, sw22.text_off = 'ObjFrame', 'ObjFrame'
	sw23.text_on, sw23.text_off = 'BoundCheck', 'BoundCheck'
	sw24.text_on, sw24.text_off = 'CollisionCheck', 'CollisionCheck'
	sw25.text_on, sw25.text_off = 'RenderFunc', 'RenderFunc'
	sw21.monitoring_value = 'TUO_Developer_Tool_kit.safe_mode_flags.current_stage'
	sw22.monitoring_value = 'TUO_Developer_Tool_kit.safe_mode_flags.ObjFrame'
	sw23.monitoring_value = 'TUO_Developer_Tool_kit.safe_mode_flags.BoundCheck'
	sw24.monitoring_value = 'TUO_Developer_Tool_kit.safe_mode_flags.CollisionCheck'
	sw25.monitoring_value = 'TUO_Developer_Tool_kit.safe_mode_flags.RenderFunc'
end

local modmgr = TUO_Developer_UI:NewPanel()
function modmgr:init()
	self.name = "mod包管理"

	Neww "title".text = "mod包列表"
	Neww "text_displayer".text = "以下是所有mod文件夹中有zip后缀名的文件列表，已默认加载文件名中带有\n“STAGE”的文件。\n请注意，安全模式仅保证加载mod时出错不会使游戏报错退出，不保证运行时\n出错退出。"

	local list = Neww "list_box"
	list.refresh = function(self)
		self.display_value = {}
		for k, v in pairs(tuolib.mod_manager.modlist) do
			table.insert(self.display_value, { name = k, v = tostring(v) })
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
	btn_reload.text = "加载/卸载Mod"
	btn_reload._event_mouseclick = function(self)
		for i, v in ipairs(list.display_value) do
			if list.selection[i] then
				if list.display_value[i].v=='false' then
					local r, err = tuolib.mod_manager.LoadMod(v.name)
					if not r then
						TUO_Developer_Flow:ErrorWindow(err)
					else
						TUO_Developer_Flow:MsgWindow("成功加载：" .. v.name)
						InitAllClass()
					end
				else
					tuolib.mod_manager.UnloadMod(v.name)
					TUO_Developer_Flow:MsgWindow("成功卸载：" .. v.name)
				end
			end
		end
	end
	--local btn_reloadall = Neww "button"
	--btn_reloadall.text = "卸载Mod"
	--btn_reloadall._event_mouseclick = function(self)
	--	for k, v in pairs(list.display_value) do
	--		if list.selection[k] then
	--		end
	--	end
	--end
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

local scprac = TUO_Developer_UI:NewPanel()
function scprac:init()
	self.name = "符卡练习"
	Neww 'title'.text = "符卡练习"
	Neww 'text_displayer'.text = "boss索引"
	local cb1 = Neww 'checkbox_l'
	cb1.display_value = { "1A", "1B", "2", "3", "4", "5", "6A", "6B", "EX" }
	cb1.width = 304
	cb1.cur = 1
	Neww 'text_displayer'.text = "选择难度"
	local cb2 = Neww 'checkbox_l'
	cb2.display_value = { "Easy", "Normal", "Hard", "Lunatic" }
	cb2.width = 304
	cb2.cur = 1
	cb1._event_mousepress = function()
		if cb1.cur == #cb1.display_value then
			cb2.cur = 1
			cb2.display_value = { "Extra" }
		else
			cb2.display_value = { "Easy", "Normal", "Hard", "Lunatic" }
		end
	end

	local list1 = Neww 'list_box'
	list1.width = 304
	list1._ban_mul_select = true
	list1.monitoring_value = function()
		local ret = {}
		if cb1.cur then
			local tb = _sc_table_new[cb1.cur_value]
			if not tb then
				return
			end
			for i, v in ipairs(tb) do
				local c = v
				local name
				if type(c.card_name) == 'table' then
					if c.is_sc == true or c.is_sc[cb2.cur] then
						name = c.card_name[cb2.cur]
					else
						name = "通常弹幕"
					end
				else
					if c.is_sc then
						name = c.card_name
					else
						name = "通常弹幕"
					end
				end
				table.insert(ret, name)
			end
		end
		return ret
	end
	Neww "text_displayer".text = "选择机体"
	local plr_list = Neww "list_box"
	plr_list.width = 256
	plr_list._ban_mul_select = true
	plr_list.refresh = function(self)
		self.display_value = {}
		for i = 1, #player_list do
			table.insert(self.display_value, { name = i, v = player_list[i][1] })
		end
	end
	local btn1 = Neww 'button'
	btn1.text = "开始"
	btn1._event_mouseclick = function()
		if cb1.cur and cb2.cur and list1.cur then
			-- local cardinfo=_sc_table_new[cb1.cur_value][list1.cur]
			local cardinfo1 = cb1.cur_value
			local cardinfo2 = list1.cur
			if cb2.cur then
				difficulty = cb2.cur
			end

			local plr_index = plr_list.cur
			if not plr_index then
				TUO_Developer_Flow:ErrorWindow("未选择机体")
				return
			end

			-- if string.find(tostring(stage.current_stage.name), "@", 1, true) ~= nil then
			-- 	stage.current_stage.task[1] =
			-- 		coroutine.create(
			-- 		function()
			-- 		end
			-- 	)
			-- 	-- stage.current_stage.task[2]=coroutine.create(function() end)
			-- 	stage.group.FinishStage()
			-- end

			ResetPool()
			scoredata.player_select = plr_index
			-- lstg.var.sc_index_new=cardinfo
			lstg.var.sc_index_new1 = cardinfo1
			lstg.var.sc_index_new2 = cardinfo2
			lstg.var.player_name = player_list[plr_index][2]
			lstg.var.rep_player = player_list[plr_index][3]
			Print(cardinfo1, cardinfo2)
			stage.group.PracticeStart("Spell Practice New@Spell Practice New")
			TUO_Developer_UI.cur = 1
		end
	end
	local sw1 = Neww 'switch'
	local vd1 = Neww 'value_displayer'
	vd1.monitoring_value = _sc_table_new
	vd1.visiable = false
	sw1.text_on = "详细信息 开"
	sw1.text_off = "详细信息 关"
	sw1.width = 150
	sw1._stay_in_this_line = true
	sw1._event_switched = function(widget, flag)
		vd1.visiable = flag
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

---@type TUO_Dev_Panel
local classmonitor = TUO_Developer_UI:NewPanel()
function classmonitor:init()
	self.name = "类"
	Neww 'title'.text = 'LuaSTG Class'
	--local btn1=Neww'button'
	local list1 = Neww 'list_box'
	local search = ''

	list1.display_value = { "点击刷新" }
	--btn1._event_mouseclick=function(widget)
	list1.monitoring_value = function(widget)
		local out = {}
		local count = 1
		for k, v in pairs(_G) do
			if type(v) == 'table' and v.is_class then
				--count=count+1
				--if count>256 then break end
				if search == '' or search == nil then
					table.insert(out, k)
				else
					if string.find(k, search) ~= nil then
						table.insert(out, k)
					end
				end
			end
		end
		return out
		--list1.display_value=out
	end

	TUO_Developer_UI.SetWidgetSlot('slot2')
	Neww 'title'.text = '操作'
	local totop = Neww 'button'
	totop.text = '回到顶部'
	totop._event_mouseclick = function(self)
		classmonitor.y_offset_aim = 0
	end
	local txt2 = Neww 'text_displayer'
	txt2.text = '输入文字以筛选'
	txt2.gap_t = 12
	local txt = Neww 'inputer'
	txt.text = ''
	txt.width = 120
	txt._event_textchange = function(self)
		search = self.text
	end
	local btnclr = Neww 'button'
	btnclr.text = '清除'
	btnclr.width = 64
	btnclr._event_mouseclick = function(self)
		txt.text = ''
		search = nil
	end
end

local objmonitor = TUO_Developer_UI:NewPanel()
function objmonitor:init()
	self.name = '对象追踪'

end