local _3DBG_Handler=TUO_Developer_UI:NewModule()
local RT_NAME='_3DBG_Handler_rt'
CreateRenderTarget(RT_NAME)
function _3DBG_Handler:init()
    self.name='3D背景处理'
    self.bgname=nil
    self.bgtemp=nil
    -- self.layer=999
    -- local rec=Class(object)
    -- function rec:init(l)
    --     self.layer=l
    --     self.group=GROUP_GHOST
    -- end 
    -- function rec:render()
    --     if IsValid(_3DBG_Handler.bgtemp) then
    --         if self.layer<999 then
    --             PushRenderTarget(RT_NAME)
    --             RenderClear(0x000000000)
    --         else
    --             PopRenderTarget(RT_NAME)
    --         end
    --     end
    -- end 
    -- rec[1]=rec.init
    -- rec[2]=nil
    -- rec[3]=nil
    -- rec[4]=rec.render
    -- rec[5]=nil
    -- rec[6]=nil
    -- self.recoder1=New(rec,999-0.0000001)
    -- self.recoder2=New(rec,999+0.0000001)
end

function _3DBG_Handler:frame()
    if IsValid(self.bgtemp) then self.bgtemp.layer=999 end
end
-- local v1,v2,v3,v4
-- do
--     local w=lstg.world
--     v1={w.l,w.t-100,0.5,0,0,Color(0xFFFFFFFF)}
--     v2={w.r,w.t,0.5,1,0,Color(0xFFFFFFFF)}
--     v3={w.r,w.b,0.5,1,1,Color(0xFFFFFFFF)}
--     v4={w.l,w.b,0.5,0,1,Color(0xFFFFFFFF)}
-- end
-- function _3DBG_Handler:render()
    -- if not IsValid(self.bgtemp) then return end
    -- RenderTexture(RT_NAME,'',v1,v2,v3,v4)
-- end


local bglist

local tip1=[[
注意，入口文件名必须和目录名一致。
]]
local bgl=TUO_Developer_UI:NewPanel()
function bgl:init()
    self.name='背景脚本列表'
    self.auto_reload=false
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
    sw1._event_switched=function(widget,flag)
        self.auto_reload=flag
    end
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
        if not i then return end
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

function bgl:frame()
    if self.auto_reload then
        

    end
end

local info_tmp={
    eye={5,0,3},
    at={5.06,0,0},
    up={0,0,0.5},
    fogdist={0.1,15},
    z={0.1,15},
    fovy={0.8}
}
local info_max={
    eye=5,
    at=5,
    up=5,
    fogdist=32,
    z=64,
    fovy=3.13
}
local info_min={
    eye=-5,
    at=-5,
    up=-5,
    fogdist=0.1,
    z=0.01,
    fovy=0.01
}
local phsys=TUO_Developer_UI:NewPanel()
function phsys:init()
    self.name='参数调整'
    self.left_for_world=true
    TUO_Developer_UI.SetWidgetSlot('world')
    Neww'title'.text='参数调整'
    for k,v in pairs(info_tmp) do
        for _k,_v in ipairs(v) do
            local m1=Neww'value_displayer'
            m1.text=string.format('%s[%d]',k,_k)
            m1.monitoring_value=function() 
                if _3DBG_Handler.bgtemp and _3DBG_Handler.bgtemp.cur and _3DBG_Handler.bgtemp.cur[k] then
                    return {{name='',v=_3DBG_Handler.bgtemp.cur[k][_k]}} 
                else
                    return {{name='',v='nil'}} 
                end
            end
            local sl=Neww'value_slider'
            sl.max_value=info_max[k]
            sl.min_value=info_min[k]
            sl.monitoring_value=function(widget,value) 
                if value==nil then 
                    if _3DBG_Handler.bgtemp and _3DBG_Handler.bgtemp.cur and _3DBG_Handler.bgtemp.cur[k] then
                        return _3DBG_Handler.bgtemp.cur[k][_k]
                    else
                        return 0
                    end
                else
                    _3DBG_Handler.bgtemp.cur[k][_k]=value
                end
            end
        end
    end
    --直接调整背景颜色
    Neww'text_displayer'.text='背景颜色'
    local cs=Neww'color_sampler'
    cs._event_mousehold=function(widget)
        if _3DBG_Handler.bgtemp and _3DBG_Handler.bgtemp.cur and _3DBG_Handler.bgtemp.cur.fogc then
            local a,r,g,b= widget.color:ARGB()
            _3DBG_Handler.bgtemp.cur.fogc[1]=r
            _3DBG_Handler.bgtemp.cur.fogc[2]=g
            _3DBG_Handler.bgtemp.cur.fogc[3]=b
        end
        
    end

end
function phsys:frame()

end


local _3dbg_info=TUO_Developer_UI:NewPanel()
function _3dbg_info:init()
    self.name="背景对象信息"
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
