-- TUO_Developer_HUD={
--     timer=0,
--     side_x=SIDE_X1,
--     panel={}
-- }
----排版信息
local TOP_OFFSET=16
local RIGHT_OFFSET=16
local HEIGHT=32
local GAP=8    
local UI_L=-107
local UI_R=640-UI_L
local SIDE_X1,SIDE_X2,SIDE_X3,SIDE_X4=-107,35,72,620

-- local self=TUO_Developer_HUD
-- self.self=TUO_Developer_Tool_kit


---------------------------------
---粗糙的补间函数
local itpl = function(vstart,vend,t)  return vstart+(vend-vstart)*(cos(180+180*t)+1)/2 end

--------------------------------------------------
---在当前模块中新建面板
function TUO_Developer_UI:NewPanel()
    local tmp={
        name='未命名',
        --槽位
        slot=#self._panel_temp+1,
        l=0,r=0,b=0,t=0,
        y_offset=0,
        y_offset_aim=0,
        mouse_stay=false,
        stay_timer=0,
        mouse_pressed=false,
        pressed_timer=0,--这个同时也针对widget
        widget={}
    }
    -- if initfunc and type(initfunc)=='function' then initfunc(tmp_panel) end
    table.insert(self._panel_temp,tmp)
    return tmp
end

--------------------------------------------------
---渲染面板的标题
function TUO_Developer_UI:RenderPanelTitle(panel)
    local index=panel.slot
    local t=panel.pressed_timer*-self.timer
    local tc=panel.stay_timer*-self.timer
    local SIZE=itpl(1.09,1.2,t)
    local color=Color(-self.timer*255,t*255,t*255,t*255)
    local ttf=self.core.ttf
    local TOP_OFFSET=self.panel_bottom_offset
    local RIGHT_OFFSET=self.panel_left_offset
    local HEIGHT=self.panel_height
    local GAP=self.panel_gap

    --侧条
    SetImageState('white','',Color(0xFF101010))
    local x1=UI_L+self.panel_left_offset+self.leftbar_width*(-1-self.timer)-6
    local SIDE_X2=x1+self.leftbar_width-self.panel_left_offset+6
    local y_c=TOP_OFFSET+((2*index-1)*(HEIGHT+GAP)-GAP)/2
    local y_h=itpl(HEIGHT/(12-tc*10),HEIGHT/1.8,t)
    RenderRect('white',
        x1-4,x1,
        y_c-y_h,y_c+y_h)
    --黑条
    local x2=itpl(x1,SIDE_X2,t)
    local y_h=itpl(0,HEIGHT/2,t)
    SetImageState('white','',Color(0xFF202020))
    RenderRect('white',
        x1,x2,
        y_c-y_h,y_c+y_h)
    --灰条
    local x2=itpl(x1,SIDE_X2,tc)
    local y_h=itpl(0,HEIGHT/2,tc)
    SetImageState('white','',Color(35*tc,32,32,32))
    RenderRect('white',
        x1,x2,
        y_c-y_h,y_c+y_h)
    RenderTTF2(ttf,panel.name,x1+6,UI_L+RIGHT_OFFSET+(UI_L-SIDE_X2),
        TOP_OFFSET+(index-1)*(HEIGHT+GAP)+1,
        TOP_OFFSET+index*(HEIGHT+GAP)-GAP+1,SIZE,color,'left','vcenter')
    local y1=math.log(panel.y_offset/320+1,8)*320
    local y2=math.log(panel.y_offset_aim/320+1,8)*320
    -- 反推函数
    -- local y_offset=(math.exp((y/320)*math.log(8))-1)*320
    local yt=464-self.topbar_width-max(y1,y2)-16
    local yb=464-self.topbar_width-min(y1,y2)+16
    SetImageState('white','',Color(t*255,50,50,50))
    RenderRect('white',744,748,yt,yb)
end



function TUO_Developer_UI:DoPanelFrame(module,panel)
    --排版
        local cx,cy,r=self.module_cx,self.module_cy,self.module_cr
        local t=-self.timer
        local SIZE=itpl(1.09,1.2,t)
        local dx=(SIDE_X2-UI_L)-self.panel_left_offset
        local l=UI_L+self.panel_left_offset
        local r=l+dx
        local y_c=self.panel_bottom_offset+((2*panel.slot-1)*(self.panel_height+self.panel_gap)-self.panel_gap)/2
        local y_h=self.panel_height/1.8
        local b,t=y_c-y_h,y_c+y_h
        local ux,uy=MouseState.x_in_UI,MouseState.y_in_UI
    --停留
        if ux>l and ux<r and abs(uy-y_c)<y_h then panel.mouse_stay=true else panel.mouse_stay=false end
    --点击
        if panel.mouse_stay and MouseTrigger(0) then
            panel.mouse_pressed=true
            PlaySound('TUO_Dev_HUD_panel',1.5,-1)
            module.cur=panel.slot
        end
    --timer变化
        local force=0.05
        for i,p in pairs(module.panel) do if p.stay_timer>0 then force=max(0.2,force+0.05) end end
        if panel.mouse_stay then 
            panel.stay_timer=panel.stay_timer+(1-panel.stay_timer)*(0.2+force)
        else 
            panel.stay_timer=panel.stay_timer+(0-panel.stay_timer)*0.2
        end
    --处理点击效果
        if module.cur==panel.slot then
            panel.pressed_timer=panel.pressed_timer+(1-panel.pressed_timer)*0.2
        else 
            panel.pressed_timer=panel.pressed_timer+(0-panel.pressed_timer)*0.2
        end
    --滚动
        if module.cur==panel.slot then
            local mx,my=MouseState.x_in_UI,MouseState.y_in_UI
            if MouseState.WheelDelta~=0 and mx>=UI_L+self.leftbar_width then
                panel.y_offset_aim=max(0,panel.y_offset_aim-MouseState.WheelDelta/1.5)
            end
            if lstg.GetLastKey()==KEY.PGUP then panel.y_offset_aim=max(0,panel.y_offset_aim-480) end
            if lstg.GetLastKey()==KEY.PGDN then panel.y_offset_aim=panel.y_offset_aim+480 end
            panel.y_offset=panel.y_offset*0.85+panel.y_offset_aim*0.15
        end
    --逻辑
        if module.cur==panel.slot then
            if panel.left_for_world then self.left_for_world=true else self.left_for_world=false end
            if panel.frame then panel:frame(module) end
            panel._DH_last_top=0
            panel._DH_last_x_pos=0
            panel._DH_last_l=0
            if panel.widget then
                for _,widget in pairs(panel.widget) do
                    self:DoWidgetFrame(module,panel,widget)
                end
            end

            if panel.AfterFrame then panel.AfterFrame() end
        end
end

function TUO_Developer_UI:RenderPanel(module,panel)
    self:RenderPanelTitle(panel)
    if panel.pressed_timer<0.1 then return end
    for _,widget in pairs(panel.widget) do
        local l=widget.hitbox.l
        local r=widget.hitbox.r
        local b=widget.hitbox.b
        local t=widget.hitbox.t
        local k=1
        local f=widget.enable if not f then k=0.5 end
        local alpha=panel.pressed_timer*-self.timer*min(1,(widget.real_hitbox.t-widget.real_hitbox.b)/8)*k
        -- if widget.real_hitbox.t-widget.real_hitbox.b>0.1 then
        --     self:RenderWidget(widget,alpha,l,r,b,t)
        -- end
        if widget.visiable then
            self:RenderWidget(widget,alpha,l,r,b,t)
        end
    end
end

