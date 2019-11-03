local _3DBG_Handler=TUO_Developer_UI:NewModule()
local RT_NAME='_3DBG_Handler_rt'
function _3DBG_Handler:init()
    self.bgname=nil
    self.bgtemp=nil
    self.layer=999
    CreateRenderTarget(RT_NAME)
    local rec=Class(object)
    function rec:init(l)
        self.layer=l
        self.group=GROUP_GHOST
    end
    function rec:render()
        if self.layer<999 then
            -- PushRenderTarget(RT_NAME)
        else
            -- PopRenderTarget(RT_NAME)
        end
    end
    self.recoder1=New(rec,999-0.0000001)
    self.recoder2=New(rec,999+0.0000001)
end

function _3DBG_Handler:frame()
    if IsValid(self.bgtemp) then self.bgtemp.layer=999 end
end

function _3DBG_Handler:render()
    if not IsValid(self.bgtemp) then return end
    local w=lstg.world
    -- RenderRect(RT_NAME,w.l,w.r,w.b,w.t)
end


local bglist


function _3DBG_Handler:init()
    self.name='3D背景处理'
end

local tip1=[[
注意，入口文件名必须和目录名一致。
]]
local bgl=TUO_Developer_UI:NewPanel()
function bgl:init()
    self.name='背景脚本列表'

    self.left_for_world=true


    TUO_Developer_UI.SetWidgetSlot('world')
    Neww'title'.text='背景列表'
    Neww'text_displayer'.text='点按列表项以查看背景'
    local bt1=Neww'button'
    bt1.text='重新载入'
    bt1.width=72
    local sw1=Neww'switch'
    sw1._stay_in_this_line=true
    sw1.text_on='实时重载 开'
    sw1.text_off='实时重载 关'
    local bt3=Neww'button'
    bt3.text='清除背景'
    bt3.width=72
    bt3._event_mouseclick=function(widget)
        if IsValid(_3DBG_Handler.bgtemp) then RawDel(_3DBG_Handler.bgtemp) end
    end
    local bt4=Neww'button'
    bt4.text='刷新列表'
    bt4.width=72
    bt4._stay_in_this_line=true
    bt4._event_mouseclick=function(widget)
        tuolib.BGHandler.LoadAllBG()
    end
    -- bt2._stay_in_this_line=true

    -- local bt3=Neww'button'
    -- bt3.text='读取'
    -- local bt4=Neww'button'
    -- bt4.text='读取'
    
    bglist=Neww'list_box'
    bglist.monitoring_value=function()
        local t={}
        for k,v in pairs(tuolib.BGHandler.list) do
            table.insert(t,k)
        end
        return t
    end
    bglist.width=224
    bglist._ban_mul_select=true
    bglist._event_mousepress=function(widget)
        local i,name=TUO_Developer_UI.GetListSingleSel(widget)
        local bgname= widget.display_value[i]
        local m=_3DBG_Handler
        if IsValid(m.bgtemp) then RawDel(m.bgtemp) end
        m.bgname=bgname
        m.bgtemp=New(_G[bgname])
        m.layer=999

        -- _3DBG_Handler.bgtemp={}
        -- _G[bgname].init(_3DBG_Handler.bgtemp)
        -- _3DBG_Handler.bgname=bgname
        -- TUO_Developer_Flow:MsgWindow(bgname)
    end
    


end

local phsys=TUO_Developer_UI:NewPanel()
function phsys:init()
    self.name='背景调试'

end


local _3dbg_info=TUO_Developer_UI:NewPanel()
function _3dbg_info:init()
    self.name="3D信息"
    TUO_Developer_UI.SetWidgetSlot('world')
    Neww'title'.text='lstg.view3d信息'
    Neww'value_displayer'.monitoring_value=function(widget)
        return {{name='相机位置',v=string.format('%.3f',lstg.view3d.eye[1])..', '..string.format('%.3f',lstg.view3d.eye[2])..', '..string.format('%.3f',lstg.view3d.eye[3])}}
    end
    Neww'value_displayer'.monitoring_value=function(widget)
        return {{name='相机看向',v=string.format('%.3f',lstg.view3d.at[1])..', '..string.format('%.3f',lstg.view3d.at[2])..', '..string.format('%.3f',lstg.view3d.at[3])}}
    end
    Neww'value_displayer'.monitoring_value=function(widget)
        return {{name='相机上方',v=string.format('%.3f',lstg.view3d.up[1])..', '..string.format('%.3f',lstg.view3d.up[2])..', '..string.format('%.3f',lstg.view3d.up[3])}}
    end
    Neww'value_displayer'.monitoring_value=function(widget)
        return {{name='雾气距离',v=string.format('%.3f',lstg.view3d.fog[1])..', '..string.format('%.3f',lstg.view3d.fog[2])}}
    end
    Neww'value_displayer'.monitoring_value=function(widget)
        return {{name='雾气颜色',v=tostring(lstg.view3d.fog[3])}}
    end
    Neww'value_displayer'.monitoring_value=function(widget)
        return {{name='z轴裁切 ',v=string.format('%.3f',lstg.view3d.z[1])..', '..string.format('%.3f',lstg.view3d.z[2])}}
    end
    Neww'value_displayer'.monitoring_value=function(widget)
        return {{name='视野    ',v=string.format('%.3f',lstg.view3d.fovy)}}
    end

end