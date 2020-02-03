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
    TUO_Developer_UI.SetWidgetSlot(440)
    local var={'score','lifeleft','chip','bomb','bombchip','power','faith','pointrate','graze',
			'missed_in_chapter','spelled_in_chapter','ccced_in_chapter',
			'block_spell','is_practice','ran_seed'}
		for __k,__V in pairs(var) do var[__k]='lstg.var.'..__V end
    local title1=Neww'title'
    title1.text='STG基本系统'
    local invincible_mode=Neww'switch'
    invincible_mode.monitoring_value='cheat'
    invincible_mode.text_on='无敌模式：开'
    invincible_mode.text_off='无敌模式：关'
    local fenshu=Neww'value_displayer'
    fenshu.monitoring_value='lstg.var.score'
    fenshu.text='分数'
	local lifeleft1=Neww'value_displayer'
	lifeleft1.monitoring_value='lstg.var.lifeleft'
	lifeleft1.text='残机'
    lifeleft1.width=128
	local lifeleft2=Neww'value_gauge'
	lifeleft2.monitoring_value='lstg.var.lifeleft'
    lifeleft2.max_value=11
    local suicide=Neww'button'
    suicide.text='自杀'
    suicide.width=48
    suicide._stay_in_this_line=true
    suicide._event_mouseclick=function()
        if IsValid(player) then
            player.protect=0
            player.death=91
        end
    end
	local lifeleft3=Neww'button'
	lifeleft3.text='残机归零'
	lifeleft3._event_mouseclick=function(widget) lstg.var.lifeleft=0 end
	for i=1,11 do
		local btntmp=Neww'button'
		btntmp.text=tostring(i)
		btntmp.width=16
		btntmp._stay_in_this_line=true
		btntmp._lifeleft=i
		btntmp.gap_r=0
		btntmp._event_mouseclick=function(widget) lstg.var.lifeleft=widget._lifeleft end
	end
	local lifechip1=Neww'value_displayer'
	lifechip1.monitoring_value='lstg.var.chip'
    lifechip1.text='残机充能槽'
    local lifechip2=Neww'value_slider'
    lifechip2.monitoring_value='lstg.var.chip'
    lifechip2.max_value=300
	
	local b1=Neww'value_displayer'
	b1.monitoring_value='lstg.var.bomb'
    b1.text='符卡剩余数'
    b1.gap_t=16
	local b2=Neww'value_gauge'
	b2.monitoring_value='lstg.var.bomb'
	b2.max_value=3
	local b3=Neww'button'
	b3.text='符卡归零'
	b3._event_mouseclick=function(widget) lstg.var.bomb=0 end
	for i=1,3 do
		local btntmp=Neww'button'
		btntmp.text=tostring(i)
		btntmp.width=48
		btntmp._stay_in_this_line=true
		btntmp._bomb=i
		btntmp.gap_r=0
		btntmp._event_mouseclick=function(widget) lstg.var.bomb=widget._bomb end
	end
	local bc1=Neww'value_displayer'
	bc1.monitoring_value='lstg.var.bombchip'
    bc1.text='符卡充能槽'
    local bc2=Neww'value_slider'
    bc2.monitoring_value='lstg.var.bombchip'
    bc2.max_value=300
	local bc1=Neww'value_displayer'
	bc1.monitoring_value='player.SpellCardHp'
    bc1.text='自机符卡耐久槽'
    local bc2=Neww'value_gauge'
    bc2.monitoring_value='player.SpellCardHp'
    bc2.max_value=75
    
	local p1=Neww'value_displayer'
	p1.monitoring_value='lstg.var.power'
    p1.text='抛瓦'
    p1.gap_t=16
	local p2=Neww'value_gauge'
	p2.monitoring_value='lstg.var.power'
	p2.max_value=600
	local p3=Neww'button'
	p3.text='抛瓦归零'
	p3._event_mouseclick=function(widget) lstg.var.power=0 end
	for i=1,6 do
		local btntmp=Neww'button'
		btntmp.text=tostring(i)
        btntmp.width=24
        btntmp.gap_r=0
		btntmp._stay_in_this_line=true
		btntmp._power=i*100
		btntmp._event_mouseclick=function(widget) lstg.var.power=widget._power end
	end
    local p4=Neww'value_displayer'
    p4.text='火力上限'
    p4.monitoring_value='player.maxPower'

	local faith=Neww'value_displayer'
	faith.monitoring_value='lstg.var.faith'
	faith.text='最大得点基础值'
	local pr=Neww'value_displayer'
	pr.monitoring_value='lstg.var.pointrate'
	pr.text='最大得点'
	local gr=Neww'value_displayer'
	gr.monitoring_value='lstg.var.graze'
	gr.text='擦弹'
	local gr2=Neww'value_displayer'
	gr2.monitoring_value='player.graze_c'
	gr2.text='必杀技充能'
    gr2.gap_b=8

	local rev=Neww'value_displayer'
	rev.monitoring_value=function()
		if IsValid(player) then
			return {{name="player",v=tostring(player.reverse_colli)}}
		else
			return {{name="player",v="玩家对象不可用"}}
		end
	end
	rev.text='判定反转'
	rev.gap_b=8

    for i=10,15 do
        Neww'value_displayer'.monitoring_value=var[i]
    end

end





local drsys=TUO_Developer_UI:NewPanel()
function drsys:init()
    self.name="梦现指针"
    self.left_for_world=true
    TUO_Developer_UI.SetWidgetSlot('world')

	Neww'title'.text='梦现指针系统'

	local dr=Neww'value_displayer'
	dr.monitoring_value='lstg.var.dr'
	dr.text='梦现指针值'
	local dr2=Neww'value_slider'
	dr2.monitoring_value='lstg.var.dr'
	dr2.min_value=-5
	dr2.max_value=5
	local ddr=Neww'value_displayer'
	ddr.monitoring_value='lstg.var.ddr'
	ddr.text='梦现指针增幅'
	local ddr2=Neww'value_slider'
	ddr2.monitoring_value='lstg.var.ddr'
	ddr2.min_value=-5
	ddr2.max_value=5
	local cp=Neww'value_displayer'
	cp.monitoring_value='lstg.var.cp'
	cp.text='连击值'
	local cp2=Neww'value_slider'
	cp2.monitoring_value='lstg.var.cp'
    cp2.max_value=5
    local hd='tuolib.DRP_Sys.'
    local tmp={
        'C_BOUNS_LIMIT',
        'K_dr',
        'K_ddr',
        'K_dr_amplify',
        'K_dr_ccced',
        'K_dr_item',
        'K_dr_enemy',
        'K_graze_c_max',
        'K_graze_c_min',
        'K_dr_graze_c',
        'K_graze_c_k',
        'K_dr_collectline',
        'K_dr_dist',
        'K_dr_SpellDmg',
        'K_dr_SlowSpell',
        'K_dr_HighSpell',
        'K_dr_BonusLimit',
        'K_MaxSpell',
        'K_dr_SpellHp',
        'K_SpellCost',
        'K_SpellDecay',
        'K_BossSpeedKill',
        'K_cp',
        'K_dr_reduce'
    }
    
    -- for i=1,#tmp do
    --     local v=Neww'value_displayer'
    --     v.monitoring_value=hd..tmp[i]
    --     v.text=tmp[i]
    -- end
    local explain1=[[
        使梦现指针增长幅度向正方向偏移的行为（以及偏移量参考值）
            宣卡（2）
            决死（3）
            释放符卡攻击（0.5）
            使用必杀技（1）
        
        使梦现指针增长幅度向负方向偏移的行为（以及偏移量参考值）
            NBNC一个chapter，包括击破boss一次（0.75）
            NMNBNC一个chapter，包括击破boss一次（1）
            NBNC击破符卡（0.15）
            NMNBNC击破符卡（0.2）]]
    local explain2=[[
        使梦现指针增长幅度向当前方向偏移的行为（以及偏移量参考值）
            贴脸射击（根据靠近的程度）
            击破敌机（2）
            擦弹（0.1，boss战中为0.2）
            敌机或boss被速破（根据速破程度）
        
        使梦现指针增长幅度向0偏移的行为（以及偏移量参考值）
            被弹（-2.5）
            遗漏敌机（-0.05）
            遗漏道具（-0.02）]]
    local explain3=[[
        梦现指针每帧都会根据梦现指针增长幅度而增长
        梦现指针增长幅度满了以后上面所说的行为会直接使指针值偏移
        梦现指针绝对值大于1之后开始自动恢复灵力和补给资源
        设置梦现指针增长幅度是为了保留容错空间
        ]]
    local btn=Neww'button'
    btn.text='查看说明'
    btn._event_mouseclick=function(widget) 
        TUO_Developer_Flow:MsgWindow(explain3,'--梦现指针系统详细算法说明--')
        TUO_Developer_Flow:MsgWindow(explain2,'--梦现指针系统详细算法说明--')
        TUO_Developer_Flow:MsgWindow(explain1,'--梦现指针系统详细算法说明--')
    end
end

local input_monitor=TUO_Developer_UI:NewPanel()
function input_monitor:init()
    self.name="输入监测"
    local title1=Neww'title'
    title1.text='键位状态表'
    local table_key_state=Neww'value_displayer'
    table_key_state.monitoring_value=KeyState
    local title2=Neww'title'
    title2.text='键位设置原始状态表'
    local table_setting_keys=Neww'value_displayer'
    table_setting_keys.monitoring_value=JoyState
    local title3=Neww'title'
    title3.text='手柄量化输入'
    local table_handle_input=Neww'value_displayer'
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
    local title4=Neww'title'
    title4.text='手柄按键原始状态表'
    local table_handle_setting=Neww'value_displayer'
    table_handle_setting.monitoring_value=function(widget)
                -- 在只插入一个手柄的情况下joy1和joy2是重复的
                local t={}
                for i=1,32 do
                    table.insert(t,{name='JOY1_'..i,v=lstg.GetKeyState(KEY['JOY1_'..i])})
                end
                return t
            end
    local title5=Neww'title'
    title5.text='鼠标状态表'
    local table_mouse_state=Neww'value_displayer'
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
    local title6=Neww'title'
    title6.text='按键被按下'
    local button_pressed=Neww'value_displayer'
    button_pressed.monitoring_value=function(widget)
                local t={}
                for k,v in pairs(KeyState) do
                    table.insert(t,{name=k,v=KeyTrigger(k)})
                end
                return t
            end

end


local boss_monitor=TUO_Developer_UI:NewPanel()
function boss_monitor:init()
    self.name="Boss"
    self.left_for_world=true
    TUO_Developer_UI.SetWidgetSlot('world')
    Neww'title'.text='boss'
    local sw= Neww'switch'
    sw.text_on='显示血量 开'
    sw.text_off='显示血量 关'
    sw.monitoring_value=function(value)
        if type(value)=='nil' then
            if IsValid(_boss) then 
                return _boss.show_hp
            else
                return false
            end
        else
            if IsValid(_boss) then 
                _boss.show_hp=value
            else
                return
            end
        end
    end

    Neww'value_displayer'.monitoring_value=function() return {{name='boss存在',v=tostring(IsValid(_boss))}} end
    local tmp={
        'drawhp',
        'drawname',
        'drawtime',
        'drawspell',
        'needposition',
        'drawpointer',
        'is_combat'
    }
    for i=1,#tmp do
        local index=tmp[i]
        local sw= Neww'switch'
        sw.text_on=index..' On'
        sw.text_off=index..' Off'
        sw.monitoring_value=function(value)
            if type(value)=='nil' then
                if IsValid(_boss) then 
                    return _boss.ui[index]
                else
                    return false
                end
            else
                if IsValid(_boss) then 
                    _boss.ui[index]=value
                else
                    return
                end
            end
        end
    end
    local tmp2={
        'hploss',
        'speed_kill_minus',
        'virtualhp',
        'hplen',
        'takeDmg_inFrame',
        'timer'
    }
    for i=1,#tmp2 do
        local index=tmp2[i]
        Neww'value_displayer'.monitoring_value=function()
            if IsValid(_boss) and _boss.current_card then 
                return {{name=index,v=_boss.current_card[index]}}
            else
                return {{name=index,v='nil'}}
            end
        end
    end
end
local DPS_monitor=TUO_Developer_UI:NewPanel()
function DPS_monitor:init()
    self.name="伤害显示"
    self.left_for_world=true
    TUO_Developer_UI.SetWidgetSlot('world')
    Neww'title'.text='伤害显示'
    local sw= Neww'switch'
    sw.text_on='显示敌机血量 开'
    sw.text_off='显示敌机血量 关'
    sw.monitoring_value=function(value)
        if type(value)=='nil' then
            return enemy.show_hp
        else
            enemy.show_hp=value
        end
    end
end



