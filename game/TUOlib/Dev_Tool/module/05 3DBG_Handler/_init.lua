local _3DBG_Handler=TUO_Developer_UI:NewModule()

function _3DBG_Handler:init()
    self.name='3D背景处理'
end
local _3dbg_info=TUO_Developer_UI:NewPanel()
function _3dbg_info:init()
    self.name="3D信息"
    TUO_Developer_UI:SetWidgetSlot('world')
    TDU_New'title'(self).text='lstg.view3d信息'
    TDU_New'value_displayer'(self).monitoring_value=function(widget)
        return {{name='相机位置',v=string.format('%.3f',lstg.view3d.eye[1])..', '..string.format('%.3f',lstg.view3d.eye[2])..', '..string.format('%.3f',lstg.view3d.eye[3])}}
    end
    TDU_New'value_displayer'(self).monitoring_value=function(widget)
        return {{name='相机看向',v=string.format('%.3f',lstg.view3d.at[1])..', '..string.format('%.3f',lstg.view3d.at[2])..', '..string.format('%.3f',lstg.view3d.at[3])}}
    end
    TDU_New'value_displayer'(self).monitoring_value=function(widget)
        return {{name='相机上方',v=string.format('%.3f',lstg.view3d.up[1])..', '..string.format('%.3f',lstg.view3d.up[2])..', '..string.format('%.3f',lstg.view3d.up[3])}}
    end
    TDU_New'value_displayer'(self).monitoring_value=function(widget)
        return {{name='雾气距离',v=string.format('%.3f',lstg.view3d.fog[1])..', '..string.format('%.3f',lstg.view3d.fog[2])}}
    end
    TDU_New'value_displayer'(self).monitoring_value=function(widget)
        return {{name='雾气颜色',v=tostring(lstg.view3d.fog[3])}}
    end
    TDU_New'value_displayer'(self).monitoring_value=function(widget)
        return {{name='z轴裁切 ',v=string.format('%.3f',lstg.view3d.z[1])..', '..string.format('%.3f',lstg.view3d.z[2])}}
    end
    TDU_New'value_displayer'(self).monitoring_value=function(widget)
        return {{name='视野    ',v=string.format('%.3f',lstg.view3d.fovy)}}
    end

end