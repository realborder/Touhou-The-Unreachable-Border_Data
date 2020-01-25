local UI_L=-107
local UI_R=640-UI_L

---------------------------------
---粗糙的补间函数
local itpl = function(vstart,vend,t)  return vstart+(vend-vstart)*(cos(180+180*t)+1)/2 end



function TUO_Developer_UI:NewModule(index)
    index=index or #(self.module)+1
    local tmp={
        name='未命名',
        path=self._module_path_temp,
        --在主菜单中的槽位
        slot=index,
        --在主菜单中的角度
        angle_aim=self.module_da*index,
        angle=360,
        x=0,y=0,r=0,
        pressed_timer=0,
        mouse_stay=false,
        stay_timer=0,
        mouse_pressed=false,
        panel={}
    }
    if self.module[index] then 
        -- TUO_Developer_Flow:ErrorWindow('')
    end
    self.module[index]=tmp
    return tmp
end



function TUO_Developer_UI:DoModuleFrame(module)
    if self.timer>0 then
        local cx,cy,r=self.module_cx,self.module_cy,self.module_cr*itpl(1.1,1,self.timer)
        module.angle_aim=-self.module_da*(module.slot-1)+self.module_a_offset
        module.angle=module.angle+(module.angle_aim-module.angle)*0.2
        -------------------------------------------------
        local x,y=cx+r*cos(module.angle),cy+r*sin(module.angle)
        local r=self.module_r
        -- r=r*(1+0.2*module.stay_timer-0.2*module.pressed_timer)
        local ux,uy=ScreenToUI(lstg.GetMousePosition()) 
        local exflag=(ux>x and ux<x+300 and abs(uy-y)<24) 
        if ((Dist(x,y,ux,uy)<=r or exflag) and abs(module.angle)<self.module_angle_limit) or self.cur_sel==module.slot then
            module.mouse_stay=true else module.mouse_stay=false 
        end
        ----点击
        if module.mouse_stay and module.mouse_pressed and (not MouseIsDown(0)) and abs(module.angle)<self.module_angle_limit then
            module.mouse_pressed=true
            PlaySound('TUO_Dev_HUD_panel',2,0.75)
            self.cur=module.slot
        end
        if module.mouse_stay and MouseTrigger(0) and abs(module.angle)<self.module_angle_limit then module.mouse_pressed=true end 
        if module.mouse_pressed and not module.mouse_stay then module.mouse_pressed=false end
        if module.mouse_pressed and not MouseIsDown(0) then module.mouse_pressed=false end
        -------------------------------------------------
        if module.mouse_stay then module.stay_timer=min(1,module.stay_timer+0.2) else module.stay_timer=max(0,module.stay_timer-0.1) end
        if module.mouse_pressed then module.pressed_timer=min(1,module.pressed_timer+0.2) else module.pressed_timer=max(0,module.pressed_timer-0.1) end
        module.x,module.y,module.r=x,y,r
    elseif self.timer<0 and self.cur==module.slot then
        local ux=MouseState.x_in_UI
        local uy=MouseState.y_in_UI
        -- if uy>480-self.topbar_width and MouseIsPressed(0) or lstg.GetKeyState(KEY.ESCAPE) then  self.cur=nil end
        if ux<35 and uy>480-self.topbar_width+1 and uy<479 then
            self.return_timer=min(1,self.return_timer+0.2)
            if MouseIsPressed(0) then
                self.cur=nil PlaySound('TUO_Dev_HUD_panel',2,0.75)
            end
        else
            self.return_timer=max(0,self.return_timer-0.05)
        end
        
        -- if uy>480-self.topbar_width and uy<480 and MouseIsPressed(2) then 
        --     if self.topbar_width>24 then
        --         self.topbar_width_aim=16
        --     else
        --         self.topbar_width_aim=32
        --     end
        -- end
        if module.frame then module:frame() end 
        if module.panel then
            for _,panel in pairs(module.panel) do
                self:DoPanelFrame(module,panel)
            end
        end
        if module.AfterFrame then module.AfterFrame() end
    end
end
function TUO_Developer_UI:RenderModuleButton(module)
    if self.timer<=0 then return end
    local x,y,r=module.x,module.y,module.r*itpl(1.2,1,self.timer)

    local ak=1-(max(0.5,min(2,abs(module.angle)/self.module_angle_limit))-0.5)/1.5
    local alpha=255*self.timer*ak
    local stayt=module.stay_timer
    local prest=module.pressed_timer
    local r2=r*(1-0.1*stayt-0.9*prest)
    SetImageState('white','',Color((-50*prest+155*stayt)*self.timer,255,255,255))
    RenderRect('white',x,x+400,y-24*(0.7+0.3*stayt),y+24*(0.7+0.3*stayt))

    for i = 1, 5 do
        sp.misc.DrawCircle(x,y,r+i,32,'',alpha*0.25*(1-i/5),255,255,255,0)
    end
    sp.misc.DrawCircle(x,y,r,32,'',alpha*0.5,255,255,255,0)
    sp.misc.DrawCircle(x,y,r2,32,'',alpha,10,10,10,0)
    if module.logo then
        SetImageState(module.logo,'',Color(alpha,255,255,255))
        Render(module.logo,x,y,0,0.4)
    end

    local rgb=max(0,255*ak-255*stayt)
    RenderTTF2(self.core.ttf,module.name,x+r+20,x+r+20,y,y,1.3*(1+0.1*stayt),Color(alpha,rgb,rgb,rgb),'left','vcenter')


end



function TUO_Developer_UI:RenderModule(module)
    if self.timer>0.1 then 
        self:RenderModuleButton(module)
    elseif self.timer<-0.1 then
        if self.cur~=module.slot then return end
        if module.render then module:render() end 
        if module.panel then
            for _,panel in pairs(module.panel) do
                self:RenderPanel(module,panel)
            end
        end
        if module.AfterRender then module:AfterRender() end 
    end
end