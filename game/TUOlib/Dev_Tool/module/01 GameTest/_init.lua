local gametest=TUO_Developer_UI:NewModule()

function gametest:init()
    self.name='游戏系统调试'
end

---游戏变量监测---------------------------------------------------------
--包括以下数值的显示和修改：
--------（游戏基本数值）分数，残机，奖残计数，符卡，符卡奖励计数，灵力，灵力上限，最大得点，擦弹，擦弹计数，每个单位的hp		
--------（特殊系统数值）梦现指针值，连击数，玩家对每个单位的DPS
local basic=TUO_Developer_UI:NewPanel()
function basic:init()
    self.name="基本系统"
    self.left_for_world=true
    TUO_Developer_UI:SetWidgetSlot(440)
    local var={'score','lifeleft','chip','bomb','bombchip','power','faith','pointrate','graze',
			'missed_in_chapter','spelled_in_chapter','ccced_in_chapter',
			'block_spell','is_practice','ran_seed'}
		for __k,__V in pairs(var) do var[__k]='lstg.var.'..__V end
    local title1=TDU_New_title(self)
    title1.text='STG基本系统'
    local invincible_mode=TDU_New_switch(self)
    invincible_mode.monitoring_value='cheat'
    invincible_mode.text_on='无敌模式：开'
    invincible_mode.text_off='无敌模式：关'
    local fenshu=TDU_New_value_displayer(self)
    fenshu.monitoring_value='lstg.var.score'
    fenshu.text='分数'
	local lifeleft1=TDU_New_value_displayer(self)
	lifeleft1.monitoring_value='lstg.var.lifeleft'
	lifeleft1.text='残机'
	local lifeleft2=TDU_New_value_gauge(self)
	lifeleft2.monitoring_value='lstg.var.lifeleft'
	lifeleft2.max_value=11
	local lifeleft3=TDU_New_button(self)
	lifeleft3.text='残机归零'
	lifeleft3._event_mouseclick=function(widget) lstg.var.lifeleft=0 end
	for i=1,11 do
		local btntmp=TDU_New_button(self)
		btntmp.text=tostring(i)
		btntmp.width=16
		btntmp._stay_in_this_line=true
		btntmp._lifeleft=i
		btntmp.gap_r=0
		btntmp._event_mouseclick=function(widget) lstg.var.lifeleft=widget._lifeleft end
	end
	local lifechip1=TDU_New'value_displayer'(self)
	lifechip1.monitoring_value='lstg.var.chip'
    lifechip1.text='残机充能槽'
    local lifechip2=TDU_New'value_slider'(self)
    lifechip2.monitoring_value='lstg.var.chip'
    lifechip2.max_value=300
	
	local b1=TDU_New_value_displayer(self)
	b1.monitoring_value='lstg.var.bomb'
    b1.text='符卡剩余数'
    b1.gap_t=16
	local b2=TDU_New_value_gauge(self)
	b2.monitoring_value='lstg.var.bomb'
	b2.max_value=3
	local b3=TDU_New_button(self)
	b3.text='符卡归零'
	b3._event_mouseclick=function(widget) lstg.var.bomb=0 end
	for i=1,3 do
		local btntmp=TDU_New_button(self)
		btntmp.text=tostring(i)
		btntmp.width=48
		btntmp._stay_in_this_line=true
		btntmp._bomb=i
		btntmp.gap_r=0
		btntmp._event_mouseclick=function(widget) lstg.var.bomb=widget._bomb end
	end
	local bc1=TDU_New'value_displayer'(self)
	bc1.monitoring_value='lstg.var.bombchip'
    bc1.text='符卡充能槽'
    local bc2=TDU_New'value_slider'(self)
    bc2.monitoring_value='lstg.var.bombchip'
    bc2.max_value=300
	local bc1=TDU_New'value_displayer'(self)
	bc1.monitoring_value='player.SpellCardHp'
    bc1.text='自机符卡耐久槽'
    local bc2=TDU_New'value_gauge'(self)
    bc2.monitoring_value='player.SpellCardHp'
    bc2.max_value=75
    
	local p1=TDU_New'value_displayer'(self)
	p1.monitoring_value='lstg.var.power'
    p1.text='抛瓦'
    p1.gap_t=16
	local p2=TDU_New'value_gauge'(self)
	p2.monitoring_value='lstg.var.power'
	p2.max_value=600
	local p3=TDU_New'button'(self)
	p3.text='抛瓦归零'
	p3._event_mouseclick=function(widget) lstg.var.power=0 end
	for i=1,6 do
		local btntmp=TDU_New'button'(self)
		btntmp.text=tostring(i)
        btntmp.width=24
        btntmp.gap_r=0
		btntmp._stay_in_this_line=true
		btntmp._power=i*100
		btntmp._event_mouseclick=function(widget) lstg.var.power=widget._power end
	end

	local faith=TDU_New'value_displayer'(self)
	faith.monitoring_value='lstg.var.faith'
	faith.text='最大得点基础值'
	local pr=TDU_New'value_displayer'(self)
	pr.monitoring_value='lstg.var.pointrate'
	pr.text='最大得点'
	local gr=TDU_New'value_displayer'(self)
	gr.monitoring_value='lstg.var.graze'
	gr.text='擦弹'

end
local drsys=TUO_Developer_UI:NewPanel()
function drsys:init()
    self.name="梦现指针"
    self.left_for_world=true
    TUO_Developer_UI:SetWidgetSlot('world')

	TDU_New_title(self).text='梦现指针系统'

	local dr=TDU_New'value_displayer'(self)
	dr.title='梦现指针系统'
	dr.monitoring_value='lstg.var.dr'
	dr.text='梦现指针值'
	local dr2=TDU_New'value_slider'(self)
	dr2.monitoring_value='lstg.var.dr'
	dr2.min_value=-5
	dr2.max_value=5
	local cp=TDU_New'value_displayer'(self)
	cp.monitoring_value='lstg.var.cp'
	cp.text='连击值'
	local cp2=TDU_New'value_slider'(self)
	cp2.monitoring_value='lstg.var.cp'
	cp2.max_value=5
	
end
local input_monitor=TUO_Developer_UI:NewPanel()
function input_monitor:init()
    self.name="输入监测"
    local title1=TDU_New_title(self)
    title1.text='键位状态表'
    local table_key_state=TDU_New_value_displayer(self)
    table_key_state.monitoring_value=KeyState
    local title2=TDU_New_title(self)
    title2.text='键位设置原始状态表'
    local table_setting_keys=TDU_New_value_displayer(self)
    table_setting_keys.monitoring_value=JoyState
    local title3=TDU_New_title(self)
    title3.text='手柄量化输入'
    local table_handle_input=TDU_New_value_displayer(self)
    table_handle_input.monitoring_value=function(widget)
        local t={}
        local leftX,leftY,rightX,rightY=lstg.XInputManager.GetThumbState(1)
        local leftT,rightT=lstg.XInputManager.GetTriggerState(1) 
        table.insert(t,{name='leftThumb_X',v=leftX})
        table.insert(t,{name='leftThumb_Y',v=leftY})
        table.insert(t,{name='rightThumb_X',v=rightX})
        table.insert(t,{name='rightThumb_Y',v=rightY})
        table.insert(t,{name='leftTrigger',v=leftT})
        table.insert(t,{name='rightTrigger',v=rightT})
        return t
    end
    local title4=TDU_New_title(self)
    title4.text='手柄按键原始状态表'
    local table_handle_setting=TDU_New_value_displayer(self)
    table_handle_setting.monitoring_value=function(widget)
                -- 在只插入一个手柄的情况下joy1和joy2是重复的
                local t={}
                for i=1,32 do
                    table.insert(t,{name='JOY1_'..i,v=lstg.GetKeyState(KEY['JOY1_'..i])})
                end
                return t
            end
    local title5=TDU_New_title(self)
    title5.text='鼠标状态表'
    local table_mouse_state=TDU_New_value_displayer(self)
    table_mouse_state.monitoring_value=function(widget)
                local t={}
                local x,y=GetMousePosition()
                local ux,uy=ScreenToUI(lstg.GetMousePosition())
                table.insert(t,{name='横坐标(窗口)',v=x})
                table.insert(t,{name='纵坐标(窗口)',v=y})
                table.insert(t,{name='滚轮滚动',v=MouseState.WheelDelta})
                table.insert(t,{name='横坐标(UI)',v=string.format('%.1f',ux)})
                table.insert(t,{name='纵坐标(UI)',v=string.format('%.1f',uy)})
                for i=0,7 do table.insert(t,{name='鼠标按键'..i,v=lstg.GetMouseState(i)}) end
                return t
            end
    local title6=TDU_New_title(self)
    title6.text='按键被按下'
    local button_pressed=TDU_New_value_displayer(self)
    button_pressed.monitoring_value=function(widget)
                local t={}
                for k,v in pairs(KeyState) do
                    table.insert(t,{name=k,v=KeyTrigger(k)})
                end
                return t
            end

end




	-- 		--绿点和擦弹


	-- 		--梦现指针系统
	-- 		--其他信息
	-- 			TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{title='其他信息',monitoring_value='lstg.var.player_name',text='机体名'})
	-- 			for i,v in pairs(var) do
	-- 				TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{monitoring_value=var[i]})
	-- 			end



			
			
	-- 	end)