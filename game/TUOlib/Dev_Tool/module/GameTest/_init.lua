local gametest=TUO_Developer_UI:NewModule()

function gametest:init()
    self.name='游戏系统调试'
end

local basic=TUO_Developer_UI:NewPanel()
function basic:init()
    self.name="基本系统"
    self.left_for_world=true
end
local drsys=TUO_Developer_UI:NewPanel()
function drsys:init()
    self.name="梦现指针"
    self.left_for_world=true
end
local input_monitor=TUO_Developer_UI:NewPanel()
function input_monitor:init()
    self.name="输入监测"

    local title1=TDU_New_title(self)
    title1.text='table:KeyState'
    local table_keystate=TDU_New_value_displayer(self)
    table_keystate.monitoring_value=KeyState



end


    
    -- TUO_Developer_HUD:NewWidget(panel,'slot1','value_displayer',{title='table:setting.keys',monitoring_value=setting.keys})
--     TUO_Developer_HUD:NewWidget(panel,260,'value_displayer',{title='table:JoyState',monitoring_value=JoyState})
--     TUO_Developer_HUD:NewWidget(panel,260,'value_displayer',{title='手柄可量化输入',
--     monitoring_value=function(widget)
--         local t={}
--         local leftX,leftY,rightX,rightY=lstg.XInputManager.GetThumbState(1)
--         local leftT,rightT=lstg.XInputManager.GetTriggerState(1) 
--         table.insert(t,{name='leftThumb_X',v=leftX})
--         table.insert(t,{name='leftThumb_Y',v=leftY})
--         table.insert(t,{name='rightThumb_X',v=rightX})
--         table.insert(t,{name='rightThumb_Y',v=rightY})
--         table.insert(t,{name='leftTrigger',v=leftT})
--         table.insert(t,{name='rightTrigger',v=rightT})
--         return t
--     end
--     })
-- TUO_Developer_HUD:NewWidget(panel,260,'value_displayer',{title='手柄原始按键状态',
--     monitoring_value=function(widget)
--         -- 在只插入一个手柄的情况下joy1和joy2是重复的
--         local t={}
--         for i=1,32 do
--             table.insert(t,{name='JOY1_'..i,v=lstg.GetKeyState(KEY['JOY1_'..i])})
--         end
--         return t
--     end
--     })
-- TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{title='鼠标状态',
--     monitoring_value=function(widget)
--         local t={}
--         local x,y=GetMousePosition()
--         local ux,uy=ScreenToUI(lstg.GetMousePosition())
--         if not panel.MouseState then panel.MouseState={} end
--         table.insert(t,{name='横坐标(窗口)',v=x})
--         table.insert(t,{name='纵坐标(窗口)',v=y})
--         table.insert(t,{name='滚轮滚动',v=MouseState.WheelDelta})
--         table.insert(t,{name='横坐标(UI)',v=string.format('%.1f',ux)})
--         table.insert(t,{name='纵坐标(UI)',v=string.format('%.1f',uy)})
--         for i=0,7 do table.insert(t,{name='鼠标按键'..i,v=lstg.GetMouseState(i)}) end
--         return t
--     end})
-- TUO_Developer_HUD:NewWidget(panel,'slot2','value_displayer',{title='按键被按下',
--     monitoring_value=function(widget)
--         local t={}
--         for k,v in pairs(KeyState) do
--             table.insert(t,{name=k,v=KeyTrigger(k)})
--         end
--         return t
--     end})


