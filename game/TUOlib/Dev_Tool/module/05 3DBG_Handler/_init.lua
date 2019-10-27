local _3DBG_Handler=TUO_Developer_UI:NewModule()

function _3DBG_Handler:init()
    self.name='3D背景处理'
end
local _3dbg_info=TUO_Developer_UI:NewPanel()
function _3dbg_info:init()
    self.name="3D信息"
    local title=TUO_Developer_UI:AttachWidget(self,'title')
    title.text='lstg.view3d信息'
    local disp=TUO_Developer_UI:AttachWidget(self,'value_displayer')
	disp.monitoring_value=lstg.view3d
end