local AllSetting=TUO_Developer_UI:NewModule()

function AllSetting:init()
    self.name='设置'
end
function AllSetting:render()
    --测试用
        -- local list={
        --     self.panel[1].widget[2].monitoring_value,
        --     self.panel[1].widget[2].display_value[2].name,
        --     self.panel[1].widget[2].display_value[2].v,
        --     self.panel[1].widget[2].hitbox.t,
        --     self.panel[1].widget[2].hitbox.b,
        -- }
        -- local t=400
        -- -- Print('AAOOOSDAOOE')
        -- for k,v in pairs(list) do
        --     RenderTTF2('f3_word',tostring(v),53,53,t,t,1,Color(0xFF000000))
        --     t=t-24
        -- end
end
local sandbox=TUO_Developer_UI:NewPanel()
function sandbox:init()
    lstg.test_value=0
    self.name="测试场地"
    -- local title=TUO_Developer_UI:AttachWidget(self,'title')
    --     title.text='标题控件测试'
    local title=TDU_New_title(self)
        title.text='标题控件测试'

    local value_displayer=TUO_Developer_UI:AttachWidget(self,'value_displayer')
        value_displayer.monitoring_value='lstg.test_value'

    local value_gauge=TUO_Developer_UI:AttachWidget(self,'value_gauge')
        value_gauge.monitoring_value='lstg.test_value'
        value_gauge.max_value=480

    local value_slider=TUO_Developer_UI:AttachWidget(self,'value_slider')
        value_slider.monitoring_value='lstg.test_value'

    local button1=TUO_Developer_UI:AttachWidget(self,'button')
        button1.text='Hello LuaSTG!'

    local button2=TUO_Developer_UI:AttachWidget(self,'button')
        button2.text='Hello LuaSTG!'
        button2._stay_in_this_line=true

    local text_displayer=TUO_Developer_UI:AttachWidget(self,'text_displayer')
        text_displayer.text='Hello LuaSTG!'
        text_displayer.width=128

    local text_displayer2=TUO_Developer_UI:AttachWidget(self,'text_displayer')
        text_displayer2.text='Hello LuaSTG!\nHello LuaSTG!\nHello LuaSTG!\nHello LuaSTG!\nHello LuaSTG!\nHello LuaSTG!\nHello LuaSTG!\nHello LuaSTG!'
        text_displayer2._stay_in_this_line=true

    local inputer=TUO_Developer_UI:AttachWidget(self,'inputer')
        inputer.text='lstg.world'

    local button2=TUO_Developer_UI:AttachWidget(self,'button')
        button2.text='Apply!'
        button2._stay_in_this_line=true

    local list_box
    local button3=TUO_Developer_UI:AttachWidget(self,'button')
        button3.text='Vanish'
        button3.width=96
        button3._event_mouseclick=function(self) list_box.visiable=false end

    local button4=TUO_Developer_UI:AttachWidget(self,'button')
        button4.text='Apprear'
        button4.width=96
        button4._stay_in_this_line=true
        button4._event_mouseclick=function(self) list_box.visiable=true end

    local button5=TUO_Developer_UI:AttachWidget(self,'button')
        button5.text='ban'
        button5.width=96
        button5._stay_in_this_line=true
        button5._event_mouseclick=function(self) list_box.enable=false end

    local button6=TUO_Developer_UI:AttachWidget(self,'button')
        button6.text='unban'
        button6.width=96
        button6._stay_in_this_line=true
        button6._event_mouseclick=function(self) list_box.enable=true end

    list_box=TUO_Developer_UI:AttachWidget(self,'list_box')
        list_box.monitoring_value='lstg.world'


    local switch=TUO_Developer_UI:AttachWidget(self,'switch')
        switch.monitoring_value='cheat'
        switch.text_on='cheat on'
        switch.text_off='cheat off'

    local color_sampler=TUO_Developer_UI:AttachWidget(self,'color_sampler')
    -- local switch2=TUO_Developer_UI:AttachWidget(self,'switch')
    -- switch2.monitoring_value=function(v) if type(v)~=nil then list_box.visiable=v else return list_box.visiable end end
    -- switch2.text_on='color on'
    -- switch2.text_off='color off'

end

local setting=TUO_Developer_UI:NewPanel()
function setting:init()
    self.name="游戏设置"
    (TDU_New_title(self)).text='特效开关'
end

local toolsetting=TUO_Developer_UI:NewPanel()
function toolsetting:init()
    self.name="工具设置"
end
