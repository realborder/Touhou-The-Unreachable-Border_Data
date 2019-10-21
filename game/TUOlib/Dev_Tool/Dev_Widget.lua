---------------------------------
---粗糙的补间函数
local itpl = function(vstart,vend,t)  return vstart+(vend-vstart)*(cos(180+180*t)+1)/2 end

------------------------------
---更快捷的方块渲染
local RenderCube= function(l,r,b,t,ca,cr,cg,cb) 
    if ca and cr and cg and cb then
        SetImageState('white','',Color(ca,cr,cg,cb)) end
    if ca and (not cr) then
        SetImageState('white','',ca) end
    RenderRect('white',l,r,b,t)
end

------------------------------------------------------
---以模板新建控件并排在面板上
---@param panel panel 
---@param template TemplateWidget
function TUO_Developer_UI:AttachWidget(panel,template,x_pos)
    local tpl=self.TemplateWidget[template]
    local x_pos_list={slot1=53,slot2=620,world=440}
    local lock=(x_pos=='slot2')
    if type(x_pos)=='string' then x_pos=x_pos_list[x_pos] 
    else x_pos=x_pos or 53 end
    local tmp_widget={
        visiable=true,
        visiable_pre=true,
        visiable_timer=0,
        enable=true,
        panel=panel,
        --鼠标是否停留
        _mouse_stay=false,
        --点燃计时器，鼠标停留在控件上就会使其处于点燃状态
        _ignite_timer=0,
        _pressed=false,
        _pressed_timer=0,
        timer=0,
        --控件的碰撞箱，因为各个控件都不一样，所以这里只设置初始值，具体值放在具体控件模板那边
        -- （虽说那个理应放在帧函数来着，但我实在不想加参数了，看着眼花）
        hitbox={l=0,r=0,b=0,t=0},
        real_hitbox={l=0,r=0,b=0,t=0},
        width=540,
        height=16,
        font_size=1,
        left_offset=0,
        gap_t=2,
        gap_b=0,
        gap_r=4,
        x=x_pos,
        _position_lock=lock,
        _stay_in_this_line=false,
        --函数
        tpl_frame=tpl.frame,
        tpl_render=tpl.render,
    }
    if tpl.init then tpl.init(tmp_widget) end
    table.insert(panel.widget,tmp_widget)
    return tmp_widget
end 
-- CreateWidget=function(panel,template,x_pos) TUO_Developer_UI.AttachWidget(TUO_Developer_UI,panel,template,x_pos) end

------------------------------------------------------
---
---
function TUO_Developer_UI:NewWidgetTemplate(name)
    local tmp={
    }
    if not self.TemplateWidget then self.TemplateWidget={} end
    self.TemplateWidget[name]=tmp
    return tmp
end

function TUO_Developer_UI:DoWidgetFrame(module,panel,widget)
    widget.timer=widget.timer+1
    if widget.visiable_pre~=widget.visiable then widget.visiable_timer=10 end
    if widget.visiable_timer>0 then widget.visiable_timer=widget.visiable_timer-1 end
    widget.visiable_pre=widget.visiable
    ---通用处理
        ---位置处理
            ---排版
                local TOP=480-self.topbar_width-self.panel_top_offset
                local LEFT_OFFSET=self.panel_left_offset
                local HEIGHT=widget.height
                local FONT_SIZE=widget.font_size
                local GAP_T=widget.gap_t
                local GAP_B=widget.gap_b
                local GAP_R=widget.gap_r
                if not widget.visiable then GAP_B=0 GAP_T=0 GAP_R=0 end
                local x=widget.x
                local pt=panel.pressed_timer

            ---lrbt初始值
                local l=itpl(x-12,x,pt)-self.leftbar_width*(1+self.timer)
                local r=l+widget.width
                local t=TOP+panel.y_offset+self.topbar_width*(1+self.timer)
                local b
            ---slot2锁定位置不滚动
                if widget._position_lock then t=TOP+self.topbar_width*(1+self.timer) end
            ---沿用上一个控件的y
                if panel._DH_last_top~=0 and panel._DH_last_x_pos==x then
                    if widget._stay_in_this_line then
                        t=panel._DH_last_top+GAP_B+HEIGHT
                        local origin_l=l
                        l=panel._DH_last_l+GAP_R
                        local w=min(540,l-origin_l+widget.width)
                        r=origin_l+w
                    else
                        t=panel._DH_last_top-GAP_T
                    end
                end
                t=t+self.topbar_width*(1+self.timer)*0.25
                b=t-HEIGHT
            --碰撞箱赋值
                widget.hitbox.l=l
                widget.hitbox.r=r
                widget.hitbox.b=b
                widget.hitbox.t=t
            ---模版帧函数，这让模版有机会更新自己的碰撞箱
                if widget.tpl_frame then widget:tpl_frame() end
                b=widget.hitbox.b
                if not widget.visiable then 
                    b=t
                    widget.hitbox.b=b
                end
            --更新位置
                b=b-GAP_B
                if widget.visiable_timer==0 then
                    panel._DH_last_top=b
                else
                    panel._DH_last_top=widget.real_hitbox.b-GAP_B
                end
                panel._DH_last_x_pos=x
                panel._DH_last_l=r
        ---自定义帧函数
            if widget.frame then widget:frame() end
        ---碰撞箱检测和事件触发
            if b<480-self.topbar_width and t>0 then
                local _mouse_stay_pre=widget._mouse_stay
                local ux,uy=MouseState.x_in_UI,MouseState.y_in_UI
                local hb_aim=widget.hitbox
                local hb=widget.real_hitbox
                for k,v in pairs({'l','r','b','t'}) do hb[v]=hb[v]+(hb_aim[v]-hb[v])*0.5 end
                local l,r,b,t=hb.l,hb.r,hb.b,hb.t
                if ux>l and ux<r and uy>b and uy<t then widget._mouse_stay=true else widget._mouse_stay=false end
            

                if widget.enable then
                    --鼠标划入事件
                    if widget._mouse_stay and (not _mouse_stay_pre) then 
                        if widget._tpl_event_mousedrop then widget:_tpl_event_mousedrop() end
                        if widget._event_mousedrop then widget:_event_mousedrop() end
                    end
                    --鼠标离开事件
                    if (not widget._mouse_stay) and _mouse_stay_pre then 
                        if widget._tpl_event_mouseleave then widget:_tpl_event_mouseleave() end
                        if widget._event_mouseleave then widget:_event_mouseleave() end
                    end

                    if widget._mouse_stay then
                        --鼠标按下
                        if MouseTrigger(0) then
                            widget._pressed=true
                            if widget._tpl_event_mousepress then widget:_tpl_event_mousepress() end
                            if widget._event_mousepress then widget:_event_mousepress() end
                        end
                        --鼠标在内部按压后抬起
                        if widget._pressed and MouseIsReleased(0) then
                            widget._pressed=false
                            if widget._tpl_event_mouseclick then widget:_tpl_event_mouseclick() end
                            if widget._event_mouseclick then widget:_event_mouseclick() end
                        end
                        --鼠标在外部按压后抬起，拖入
                        if not widget._pressed and MouseIsReleased(0) then
                            if widget._tpl_event_dragin then widget:_tpl_event_dragin() end
                            if widget._event_dragin then widget:_event_dragin() end
                        end
                        --鼠标持续按压
                        if widget._pressed and MouseIsDown(0) then
                            if widget._tpl_event_mousehold then widget:_tpl_event_mousehold(self) end
                            if widget._event_mousehold then widget:_event_mousehold(self) end
                        end
                    else
                        --拖出
                        if MouseIsDown(0) and _mouse_stay_pre then 
                            if widget._tpl_event_dragout then widget:_tpl_event_dragout() end
                            if widget._event_dragout then widget:_event_dragout() end
                        end
                        --鼠标持续按压
                        if widget._pressed and MouseIsDown(0) then
                            if widget._tpl_event_mousehold then widget:_tpl_event_mousehold(self) end
                            if widget._event_mousehold then widget:_event_mousehold(self) end
                        end
                        if not MouseIsDown(0) then
                            widget._pressed=false
                        end
                    end
                end
            end
        ---timer变换
            if widget.enable then
                if widget._mouse_stay then
                    widget._ignite_timer=widget._ignite_timer+(1-widget._ignite_timer)*0.2
                else
                    widget._ignite_timer=widget._ignite_timer+(0-widget._ignite_timer)*0.2
                end
                if widget._pressed then
                    widget._pressed_timer=widget._pressed_timer+(1-widget._pressed_timer)*0.2
                else
                    widget._pressed_timer=widget._pressed_timer+(0-widget._pressed_timer)*0.2
                end
            end
    ---模版帧后函数
        if widget.tpl_afterframe then widget:tpl_afterframe() end
end

function TUO_Developer_UI:RenderWidget(widget,alpha,l,r,b,t)
    if b>480-self.topbar_width or t<0 then return end
    if widget._ignite_timer>0 and not widget._ban_ignite_effect then
        RenderCube(l,r,b,t,alpha*widget._ignite_timer*35,255,255,255)
        -- RenderCube(l,r,b,t,alpha*widget._ignite_timer*25,50,50,50)
    end
    if widget._pressed_timer>0 and not widget._ban_pressed_effect then
        RenderCube(l,r,b,t,alpha*widget._pressed_timer*65,255,255,255)
        -- RenderCube(l,r,b,t,alpha*widget._pressed_timer*25,50,50,50)
    end
    if widget.tpl_render then widget:tpl_render(alpha,l,r,b,t) end
    if widget.render then widget:render(alpha,l,r,b,t) end    
    if widget.tpl_afterrender then widget:tpl_afterrender(alpha,l,r,b,t) end

end
