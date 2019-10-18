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
                panel.y_offset_aim=max(0,panel.y_offset_aim-MouseState.WheelDelta/3)
            end
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












-- ---@type Panel
-- --------------------------------------------------
-- ---在HUD里新建面板
-- ---@param title string 面板标题，显示在左边栏
-- ---@param monitoring_value any 监视列表，可以传字符串索引（构成的表），也可以直接传值，也可以用函数来将待监视的值导入self.display_value
-- ---@param initfunc function 
-- ---@param framefunc function
-- ---@param renderfunc function
-- ---@param force_refresh boolean 若设为true，面板就算不显示也会强制执行frame函数
-- function TUO_Developer_HUD.NewPanel(title,monitoring_value,initfunc,framefunc,renderfunc,force_refresh)
--     local tmp_panel={
--         title=title,
--         timer=0,
--         mouseDrop=false,
--         clicktimer=0,
--         alpha=0,
--         y_offset=0,
--         y_offset_aim=0,
--         value_pre={},
--         value_change={},
--         WidgetList={},
--         monitoring_value=nil,
--         framefunc=framefunc,
--         renderfunc=renderfunc,
--         force_refresh=force_refresh or false}
--     if initfunc and type(initfunc)=='function' then initfunc(tmp_panel) end
--     table.insert(TUO_Developer_HUD.panel,tmp_panel)
-- end
-- --------------------------------------------------
-- ---渲染面板的标题
-- ---@param index number 位于第几个槽位
-- ---@param panel Panel 记录面板信息的表
-- function TUO_Developer_HUD.RenderPanelTitle(index,panel)
--     local t=panel.timer/10
--     local tc=panel.clicktimer/10
--     local SIZE=expl(1.09,1.2,t)
--     local color=Color(self.timer/30*255,t*255,t*255,t*255)
--     local ttf=self.self.ttf
--     --侧条
--     SetImageState('white','',Color(0xFF101010))
--     local x1=self.side_x+RIGHT_OFFSET+(SIDE_X1-SIDE_X2)-6
--     local y_c=TOP_OFFSET+((2*index-1)*(HEIGHT+GAP)-GAP)/2
--     local y_h=expl(HEIGHT/(12-tc*10),HEIGHT/1.8,t)
--     RenderRect('white',
--         x1-4,x1,
--         y_c-y_h,y_c+y_h)
--     --黑条
--     local x2=expl(x1,SIDE_X2,t)
--     local y_h=expl(0,HEIGHT/2,t)
--     SetImageState('white','',Color(0xFF202020))
--     RenderRect('white',
--         x1,x2,
--         y_c-y_h,y_c+y_h)
--     --灰条
--     local x2=expl(x1,SIDE_X2,tc)
--     local y_h=expl(0,HEIGHT/2,tc)
--     SetImageState('white','',Color(35*tc,32,32,32))
--     RenderRect('white',
--         x1,x2,
--         y_c-y_h,y_c+y_h)
--     RenderTTF2(ttf,panel.title,self.side_x+RIGHT_OFFSET+(SIDE_X1-SIDE_X2),self.side_x-RIGHT_OFFSET,
--         TOP_OFFSET+(index-1)*(HEIGHT+GAP)+1,
--         TOP_OFFSET+index*(HEIGHT+GAP)-GAP+1,SIZE,color,'left','vcenter')
--     local y1=math.log(panel.y_offset/320+1,8)*320
--     local y2=math.log(panel.y_offset_aim/320+1,8)*320
--     -- 反推函数
--     -- local y_offset=(math.exp((y/320)*math.log(8))-1)*320
--     local yt,yb=464-max(y1,y2)-16,464-min(y1,y2)+16
--     SetImageState('white','',Color(panel.timer/10*255,50,50,50))
--     RenderRect('white',744,748,yt,yb)
-- end




-- local DeserializeTable
-- DeserializeTable=function (panel,t,output,level)
--     level=level or 0
--     output=output or panel.display_value
--     --长度保护
--     if #(panel.display_value)>512 then 
--         table.insert(panel.display_value,{name='!!!',v=' Reached Length Limit'}) return
--     end
--     --深度保护
--     if level>3 then 
--         local head=''
--         for i=0,level-1 do head=head..'    ' end
--         table.insert(panel.display_value,{name=head..'!!!',v=' Reached Table Depth Limit'})
--         return 
--     end
--     local length=0
--     for _k,_v in pairs(t) do
--         length=length+1 
--         if length>512 then 
--             table.insert(panel.display_value,{name='!!!',v=' Reached Length Limit'}) return end
--         if type(_v)=='table' then 
--             local head=''
--             for i=0,level-1 do head=head..'    ' end
--             if level>0 then head=head..'   +' end
--             table.insert(panel.display_value,{name=head.._k,v=_v})
--             DeserializeTable(panel,_v,level+1) 
--         else 
--             local head=''
--             for i=0,level do head=head..'    ' end
--             table.insert(panel.display_value,{name=head.._k,v=_v})
--         end
--     end
-- end

-- -------------------------
-- ---每个面板对鼠标的响应
-- function TUO_Developer_HUD.PanelMouseAction(index,panel)
--     local t=panel.timer/10
--     local SIZE=expl(1.09,1.2,t)
--     local x1=self.side_x+RIGHT_OFFSET+(SIDE_X1-SIDE_X2)-6
--     local y_c=TOP_OFFSET+((2*index-1)*(HEIGHT+GAP)-GAP)/2
--     local y_h=HEIGHT/1.8
--     local ux,uy=ScreenToUI(lstg.GetMousePosition())
--     if ux>x1 and ux<SIDE_X2 and abs(uy-y_c)<y_h then panel.mouseDrop=true else panel.mouseDrop=false end
--     --下面三行代码的作用……你去掉试试看就知道为啥了
--     local force=0.75
--     for i,p in pairs(self.panel) do
--         if p.clicktimer>0 then force=force+0.75 end end
--     if panel.mouseDrop then
--         panel.clicktimer=min(10,panel.clicktimer+force)*self.timer/30
--     else 
--         panel.clicktimer=max(0,panel.clicktimer-0.75)*self.timer/30
--     end
-- end
-- --------------------------
-- ---面板帧函数
-- function TUO_Developer_HUD.DoPanelFrame(index,panel)
--     -----丝滑部分，不用动
--     if index==self.cur then
--         panel.timer=min(10,panel.timer+1)*self.timer/30
--     else 
--         panel.timer=max(0,panel.timer-1)*self.timer/30
--     end
--     panel.left=expl(SIDE_X2,SIDE_X3,panel.timer/10)
--     panel.alpha=255*panel.timer/10
--     -------监测鼠标点击部分，不用动，算是全局的
--     self.PanelMouseAction(index,panel)
--     --不显示的时候不会执行自身和控件的frame函数
--     if (panel.framefunc and type(panel.framefunc)=='function')   then 
--         panel.framefunc(panel) 
--     end
--     if panel.timer>0 then
--         --重置控件排版用的变量
--         panel.__DH_last_top=0
--         panel.__DH_last_x_pos=0
--         ----控件帧函数
--         ----观测变量部分已经移动至widget
--         for _,widget in pairs(panel.WidgetList) do
--             if widget.framefunc and type(widget.framefunc)=='function' then widget.framefunc(widget) end
--         end
--     end
-- end

-- function TUO_Developer_HUD.init()
--     self.cur=1
--     self.scroll_force=0
--     self.timer=0
--     self.alpha=0.9
-- end

-- function TUO_Developer_HUD.frame()
--     self.side_x=expl(SIDE_X1,SIDE_X2,self.timer/30)

--     for k,v in pairs(self.panel) do
--         self.DoPanelFrame(k,v)
--     end
--     --鼠标滚轮滚动调整tab
--     local mx,my=ScreenToUI(lstg.GetMousePosition())
--     if MouseState.WheelDelta~=0 and mx<=SIDE_X2 then
--         local num=#self.panel
--         num=max(1,min(num))
--         if MouseState.WheelDelta<0 then 
--             if self.cur==1 then self.cur=num else self.cur=self.cur-1 end
--         else
--             if self.cur==num then self.cur=1 else self.cur=self.cur+1 end
--         end
--     end
--     --直接点击
--     for k,v in pairs(self.panel) do
--         if v.mouseDrop then
--             if MouseTrigger(_MOUSE.LEFT_BUTTON) then self.cur=k PlaySound('TUO_Dev_HUD_panel',4) end
--         end
--     end
--     --翻页
--     if lstg.GetKeyState(KEY.HOME) then self.panel[self.cur].y_offset_aim=0 end
--     if lstg.GetKeyState(KEY.PGUP) or lstg.GetKeyState(KEY.PGDN) then
--         if self.scroll_force<=0 then self.scroll_force=1
--         else self.scroll_force=min(50,self.scroll_force+0.5) end
--     else self.scroll_force=0 end
--     if lstg.GetKeyState(KEY.PGUP) then self.panel[self.cur].y_offset_aim=max(0,self.panel[self.cur].y_offset_aim-5-self.scroll_force) end
--     if lstg.GetKeyState(KEY.PGDN) then self.panel[self.cur].y_offset_aim=self.panel[self.cur].y_offset_aim+5+self.scroll_force end
--     if MouseState.WheelDelta~=0 and mx>=SIDE_X2 then self.panel[self.cur].y_offset_aim=max(0,self.panel[self.cur].y_offset_aim-MouseState.WheelDelta/3) end
--     self.panel[self.cur].y_offset=self.panel[self.cur].y_offset*0.85+self.panel[self.cur].y_offset_aim*0.15

-- end
-- function TUO_Developer_HUD.render()
--     SetViewMode'ui'    
--     --渲染白色侧边栏
--     local sis=SetImageState
--     local rr=RenderRect
--     -- local rttf=RenderTTF
--     --白色背景
--     sis('white','',Color(255*self.alpha*self.timer/30,255,255,255))
--     rr('white',SIDE_X1,640-SIDE_X1,0,480)
--     --面板渲染
--     for _,panel in pairs(self.panel) do
--         if panel.timer>0 then
--             for _,widget in pairs(panel.WidgetList) do
--                 if widget.renderfunc and type(widget.renderfunc)=='function' then widget.renderfunc(widget) end
--                 -- if v.display_value then
--                 --     if v.renderfunc then
--                 --         self.DisplayValue(v)
--                 --     else
--                 --         self.DisplayValue(v,nil,SIDE_X3)
--                 --     end
--                 -- end
--             end
--             if panel.renderfunc and type(panel.renderfunc)=='function' then panel.renderfunc(panel) end
--         end
--     end
--     --侧边栏
--     sis('white','',Color(0xFFFFFFFF))
--     rr('white',SIDE_X1,self.side_x,0,480)
--     for i=1,10 do
--         sis('white','',Color((1-i/10)*100*self.timer/30,0,0,0))
--         rr('white',self.side_x+i-1,self.side_x+i,0,480)
--     end
--     for k,v in pairs(self.panel) do
--         self.RenderPanelTitle(k,v)
--     end
-- end


--重载
-- local OriginalFocusLoseFunc=FocusLoseFunc
-- function FocusLoseFunc()
--     OriginalFocusLoseFunc()


-- end