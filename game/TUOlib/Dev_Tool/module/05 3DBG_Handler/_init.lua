local _3DBG_Handler=TUO_Developer_UI:NewModule()
local RT_NAME='_3DBG_Handler_rt'
CreateRenderTarget(RT_NAME)
function _3DBG_Handler:init()
    self.name='3D背景处理'
    self.bgname=nil
    self.bgtemp=nil
end

function _3DBG_Handler:frame()
    if IsValid(self.bgtemp) then self.bgtemp.layer=999 end
end



local bglist

local tip1=[[
注意，入口文件名必须和目录名一致。
]]
local bgl=TUO_Developer_UI:NewPanel()
function bgl:init()
    self.name='背景脚本列表'
    self.auto_reload=false
    -- self.left_for_world=true

    -- TUO_Developer_UI.SetWidgetSlot('world')
    Neww'title'.text='背景列表'
    Neww'text_displayer'.text='点按列表项以查看背景'
    local bt1=Neww'button'
    bt1.text='重新载入'
    bt1.width=72
    bt1._event_mouseclick=function(widget)
        local i,name,value=TUO_Developer_UI.GetListSingleSel(bglist)
        if IsValid(_3DBG_Handler.bgtemp) then RawDel(_3DBG_Handler.bgtemp) end
        tuolib.BGHandler.LoadSingleBG(name)
        _3DBG_Handler.bgname=name
        _3DBG_Handler.bgtemp=New(_G[name])
        _3DBG_Handler.cur=2
    end
    -- local sw1=Neww'switch'
    -- sw1._stay_in_this_line=true
    -- sw1.text_on='实时重载 开'
    -- sw1.text_off='实时重载 关'
    -- sw1._event_switched=function(widget,flag)
    --     self.auto_reload=flag
    -- end
    local bt3=Neww'button'
    bt3.text='删除背景'
    bt3.width=72
    bt3._stay_in_this_line=true
    bt3._event_mouseclick=function(widget)
        if IsValid(_3DBG_Handler.bgtemp) then RawDel(_3DBG_Handler.bgtemp) end
    end
    local bt4=Neww'button'
    bt4.text='刷新全部'
    bt4.width=72
    bt4._stay_in_this_line=true
    bt4._event_mouseclick=function(widget)
        tuolib.BGHandler.LoadAllBG()
    end
    
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
        m.cur=2
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
    eye=10,
    at=10,
    up=1,
    fogdist=32,
    z=64,
    fovy=3.13
}
local info_min={
    eye=-10,
    at=-10,
    up=-1,
    fogdist=0.1,
    z=0.01,
    fovy=0.01
}
local phsys=TUO_Developer_UI:NewPanel()
function phsys:init()
    self.name='参数调整'
    self.left_for_world=true
    TUO_Developer_UI.SetWidgetSlot('world')
    local title=Neww'title'
    title.text='参数调整'
    title.width=160
    local btn=Neww'button'
    btn.text='保存'
    btn.gap_b=5
    btn._stay_in_this_line=true
    btn._event_mouseclick=function(widget)
        tuolib.BGHandler.SavePhaseInfo(_3DBG_Handler.bgtemp,_3DBG_Handler.bgname)
    end

    local txt1= Neww'text_displayer'
    txt1.text='阶段'
    txt1.width=31
    local cb=Neww'checkbox_l'
    cb.width=245
    cb.gap_b=0
    cb._stay_in_this_line=true
    cb.frame=function(widget)
        if _3DBG_Handler.bgtemp and (not widget._mouse_stay) then
            local bg=_3DBG_Handler.bgtemp
            local bgcur=tuolib.BGHandler.GetCurPhase(bg)
            if bgcur then
                widget.cur=bgcur
            else
                
            end
            widget.display_value={}
            if bg.phaseinfo then
                for i=1,#(bg.phaseinfo) do
                    table.insert(widget.display_value,i)
                end
            else
                widget.display_value={}
            end
        end
    end
    cb.display_value={}
    cb._event_mouseclick=function(widget)
        local bg=_3DBG_Handler.bgtemp
        if bg then
            if bg.phaseinfo then
                bg.timer=bg.phaseinfo[widget.cur].time
            end
        end


    end

    local v1=Neww'value_displayer'
    v1.text= '触发时刻'
    v1.width=276
    v1.gap_b=0
    v1.monitoring_value=function() 
        if _3DBG_Handler.bgtemp and _3DBG_Handler.bgtemp.phaseinfo then 
            local cur=tuolib.BGHandler.GetCurPhase(_3DBG_Handler.bgtemp)
            if cur then
                return {{name='',v=tostring(_3DBG_Handler.bgtemp.phaseinfo[cur].time)}} 
            else
                return {{name='',v='nil'}}
            end
        end 
    end


    local s1=Neww'value_slider'
    s1.width=276
    s1.max_value=2000
    s1.min_value=0
    s1.monitoring_value=function(widget,value) 
        local cur=tuolib.BGHandler.GetCurPhase(_3DBG_Handler.bgtemp)
        if not cur then return 0 end
        if value==nil then 
            if cur then
                return _3DBG_Handler.bgtemp.phaseinfo[cur].time
            else
                return 0
            end
        else
            _3DBG_Handler.bgtemp.phaseinfo[cur].time=value
        end
    end
    local v2=Neww'value_displayer'
    v2.text='变换时间'
    v2.gap_b=0
    v2.width=276
    v2.monitoring_value=function() 
        local cur=tuolib.BGHandler.GetCurPhase(_3DBG_Handler.bgtemp)
        if cur then
            return {{name='',v=_3DBG_Handler.bgtemp.phaseinfo[cur].duration}} 
        else
            return {{name='',v='nil'}} 
        end
    end

    local s2=Neww'value_slider'
    s2.width=276
    s2.max_value=1000
    s2.min_value=0
    s2.frame=function(widget)
        if _3DBG_Handler.bgtemp then
            local bg=_3DBG_Handler.bgtemp
            if bg.cur then
                local p=bg.phaseinfo
                local cur=tuolib.BGHandler.GetCurPhase(bg)
                if cur==#p then
                    widget.max_value=1000
                else
                    widget.max_value=p[cur+1].time-p[cur].time
                end
            end
        end
    end
    s2.monitoring_value=function(widget,value) 
        local cur=tuolib.BGHandler.GetCurPhase(_3DBG_Handler.bgtemp)
        if value==nil then 
            if cur then
                return _3DBG_Handler.bgtemp.phaseinfo[cur].duration
            else
                return 0
            end
        else
            _3DBG_Handler.bgtemp.phaseinfo[cur].duration=value
        end
    end

    Neww'text_displayer'.text='补间'
    local cb2=Neww'checkbox_l'
    cb2.width=276
    cb2.gap_b=0
    cb2.cur=1
    cb2.display_value={"LIN","A_D","ACC","DEC","INE","IND","INA"}
    cb2.real_value={"LINEAR","ACC_DEC","ACC","DEC","INERTIA","INERTIA_DEC","INERTIA_ACC"}
    cb2.frame=function(widget)
        if _3DBG_Handler.bgtemp and (not widget._mouse_stay) then
            local bg=_3DBG_Handler.bgtemp
            local cur=tuolib.BGHandler.GetCurPhase(bg)
            if cur then
                local ph=bg.phaseinfo[cur]
                for i,v in ipairs(widget.display_value) do
                    if widget.real_value[i]==ph.itpl then
                        widget.cur=i break
                    end
                end
            end
        end
    end
    cb2._event_mouseclick=function(widget)
        if _3DBG_Handler.bgtemp then
            local bg=_3DBG_Handler.bgtemp
            local cur=tuolib.BGHandler.GetCurPhase(bg)
            if cur then
                bg.phaseinfo[cur].itpl=widget.real_value[widget.cur]
            end
        end    
    end


    local cb=Neww'checkbox_l'
    cb.width=276
    cb.height=24
    cb.gap_t=24
    cb.gap_b=0
    cb.cur=1
    cb.display_value={'查看','编辑'}

    for k,v in pairs(info_tmp) do
        for _k,_v in ipairs(v) do
            local m1=Neww'value_displayer'
            m1.text=string.format('%s[%d]',string.upper(k),_k)
            m1.gap_t=0
            m1.gap_b=0
            m1.width=276
            if _k==1 then 
                m1.gap_t=6
            end
            m1.monitoring_value=function() 
                if cb.cur==1 then
                    if _3DBG_Handler.bgtemp and _3DBG_Handler.bgtemp.cur and _3DBG_Handler.bgtemp.cur[k] then
                        return {{name='',v=_3DBG_Handler.bgtemp.cur[k][_k]}} 
                    else
                        return {{name='',v='nil'}} 
                    end
                else
                    local cur=tuolib.BGHandler.GetCurPhase(_3DBG_Handler.bgtemp)
                    if cur then
                        return {{name='',v=_3DBG_Handler.bgtemp.phaseinfo[cur][k][_k]}} 
                    else
                        return {{name='',v='nil'}} 
                    end
                end
            end
            local sl=Neww'value_slider'
            sl.gap_t=0
            sl.gap_b=0
            sl.width=276
            sl.l=276
            sl.max_value=info_max[k]
            sl.min_value=info_min[k]
            sl.monitoring_value=function(widget,value)
                if cb.cur==1 then
                    if value==nil then 
                        if _3DBG_Handler.bgtemp and _3DBG_Handler.bgtemp.cur and _3DBG_Handler.bgtemp.cur[k] then
                            return _3DBG_Handler.bgtemp.cur[k][_k]
                        else
                            return 0
                        end
                    else
                        _3DBG_Handler.bgtemp.cur[k][_k]=value
                    end
                else
                    local cur=tuolib.BGHandler.GetCurPhase(_3DBG_Handler.bgtemp)
                    if value==nil then 
                        
                        if cur then
                            return _3DBG_Handler.bgtemp.phaseinfo[cur][k][_k]
                        else
                            return 0
                        end
                    else
                        
                        _3DBG_Handler.bgtemp.phaseinfo[cur][k][_k]=value
                    end
                end
            end
        end
    end
    --直接调整背景颜色
    local txt3=Neww'text_displayer'
    txt3.text='背景颜色'
    txt3.gap_t=10
    local cs=Neww'color_sampler'
    cs.gap_t=1
    cs.height=200
    cs.monitoring_value=function(widget)
        if not widget._mouse_stay then
            if cb.cur==1 then
                if _3DBG_Handler.bgtemp and _3DBG_Handler.bgtemp.cur and _3DBG_Handler.bgtemp.cur.fogc then
                    local f=_3DBG_Handler.bgtemp.cur.fogc
                    return Color(255,f[1],f[2],f[3])
                end
            else
                local cur=tuolib.BGHandler.GetCurPhase(_3DBG_Handler.bgtemp)
                if cur then
                    local f=_3DBG_Handler.bgtemp.phaseinfo[cur].fogc
                    return Color(255,f[1],f[2],f[3])
                end
            end
        else
            return 
        end
    end
    cs._event_mousehold=function(widget)
        if cb.cur==1 then
            if _3DBG_Handler.bgtemp and _3DBG_Handler.bgtemp.cur and _3DBG_Handler.bgtemp.cur.fogc then
                local a,r,g,b= widget.color:ARGB()
                _3DBG_Handler.bgtemp.cur.fogc[1]=r
                _3DBG_Handler.bgtemp.cur.fogc[2]=g
                _3DBG_Handler.bgtemp.cur.fogc[3]=b
            end
        else
            local cur=tuolib.BGHandler.GetCurPhase(_3DBG_Handler.bgtemp)
            local fogc=_3DBG_Handler.bgtemp.phaseinfo[cur].fogc
            local a,r,g,b= widget.color:ARGB()
            fogc[1]=r
            fogc[2]=g
            fogc[3]=b
        end
            
    end

end
function phsys:frame()
    if IsValid(_3DBG_Handler.bgtemp) and _3DBG_Handler.bgtemp.phaseinfo then
        for i,v in ipairs(self.widget) do
            v.enable=true
        end
    else
        for i,v in ipairs(self.widget) do
            v.enable=false
        end
    end
end 


local _3dbg_info=TUO_Developer_UI:NewPanel()
function _3dbg_info:init()
    self.name="背景对象信息"
    -- TUO_Developer_UI.SetWidgetSlot('world')

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
