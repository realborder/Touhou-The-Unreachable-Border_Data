local SIDE_X1,SIDE_X2,SIDE_X3,SIDE_X4=-107,56,72,620
local expl = function(vstart,vend,t)  return vstart+(vend-vstart)*sin(90*t) end

TUO_Developer_HUD={
    timer=0,
    side_x=SIDE_X1,
    panel={}
    --[[
    panel={
        timer=0,
        left=0,
        monitoring_value={} --监视列表，可以是字符串也可以是函数
        display_value={} --取出的监视列表的数值，在这里等待被渲染
    }
    --]]
}
local self=TUO_Developer_HUD
function TUO_Developer_HUD.NewPanel(title,monitoring_value,initfunc,framefunc,renderfunc)
    if initfunc and type(initfunc)=='function' then initfunc() end
    table.insert(TUO_Developer_HUD.panel,{
        title=title,
        timer=0,
        alpha=0,
        y_offset=0,
        monitoring_value=monitoring_value,
        framefunc=framefunc,
        renderfunc=renderfunc})
end
function TUO_Developer_HUD.RenderPanelTitle(index,panel)
    local TOP_OFFSET=16
    local RIGHT_OFFSET=32
    local HEIGHT=32
    local SIZE=1.5
    local GAP=16
    local color=Color(self.timer/30*255,0,0,0)
    local t='f3_word'
    SetImageState('white','',Color(0xFF101010))
    local x1=self.side_x+RIGHT_OFFSET+(SIDE_X1-SIDE_X2)-6
    local y_c=TOP_OFFSET+((2*index-1)*(HEIGHT+GAP)-GAP)/2
    local y_h=expl(0,HEIGHT/2,panel.timer/10)
    RenderRect('white',
        x1-4,x1,
        y_c-y_h,y_c+y_h)
    RenderTTF2(t,panel.title,self.side_x+RIGHT_OFFSET+(SIDE_X1-SIDE_X2),self.side_x-RIGHT_OFFSET,
        TOP_OFFSET+(index-1)*(HEIGHT+GAP),
        TOP_OFFSET+index*(HEIGHT+GAP)-GAP,SIZE,color,'left','vcenter')
    
end
function TUO_Developer_HUD.RenderValue(panel,title,x_pos,value_table)
    title=title or 'Value Monitor'
    local p=panel
    local TOP_OFFSET=16
    local l=expl(SIDE_X4-24,SIDE_X4,p.timer/10)
    if x_pos then l=expl(x_pos-24,x_pos,p.timer/10) end  
    local r=l+640
    local t=480-TOP_OFFSET+panel.y_offset
    local b
    local HEIGHT=16
    local SIZE=1
    local GAP=2
    local ttf='f3_word'
    local color=Color(panel.timer/10*255,0,0,0)
    RenderTTF2(ttf,title,l-5,r,t-HEIGHT*1.5,t,SIZE*1.5,color)
    t=t-HEIGHT*1.5-GAP
    if value_table then
        for k,v in pairs(value_table) do  
            b=t-HEIGHT
            RenderTTF2(ttf,k..': '..tostring(v),l,r,b,t,SIZE,color)
            t=t-HEIGHT-GAP
        end
    else
        for k,v in pairs(panel.display_value) do  
            b=t-HEIGHT
            RenderTTF2(ttf,v.name..': '..tostring(v.v),l,r,b,t,SIZE,color)
            t=t-HEIGHT-GAP
        end
    end
end
function TUO_Developer_HUD.init()
    self.cur=1
    self.scroll_force=0
end
function TUO_Developer_HUD.frame()
    self.side_x=expl(SIDE_X1,SIDE_X2,self.timer/30)

    for k,v in pairs(self.panel) do
        if k==self.cur then
            v.timer=min(10,v.timer+1)*self.timer/30
        else 
            v.timer=max(0,v.timer-1)*self.timer/30
        end
        v.left=expl(SIDE_X2,SIDE_X3,v.timer/10)
        v.alpha=255*v.timer/10
        --上面是丝滑用的代码
        
        if v.framefunc and type(v.framefunc) then v.framefunc(v) end

        if v.monitoring_value then
            if type(v.monitoring_value)=='function' then v.display_value=v.monitoring_value() 
            elseif type(v.monitoring_value)=='string' then  v.display_value={} --待补充
            elseif type(v.monitoring_value)=='table' then v.display_value={}
            else v.display_value=nil
            end
        end
    end
    if lstg.GetKeyState(KEY.PGUP) or lstg.GetKeyState(KEY.PGDN) then
        if self.scroll_force<=0 then self.scroll_force=1
        else self.scroll_force=min(10,self.scroll_force+0.1) end
    else self.scroll_force=0
    end
    if lstg.GetKeyState(KEY.PGUP) then self.panel[self.cur].y_offset=self.panel[self.cur].y_offset+1+self.scroll_force end
    if lstg.GetKeyState(KEY.PGDN) then self.panel[self.cur].y_offset=max(0,self.panel[self.cur].y_offset-1-self.scroll_force) end

end
function TUO_Developer_HUD.render()
    SetViewMode'ui'    
    --渲染白色侧边栏
    local sis=SetImageState
    local rr=RenderRect
    -- local rttf=RenderTTF
    sis('white','',Color(155*self.timer/30,255,255,255))
    rr('white',SIDE_X1,640-SIDE_X1,0,480)
    sis('white','',Color(0xFFFFFFFF))
    rr('white',SIDE_X1,self.side_x,0,480)
    for k,v in pairs(self.panel) do
        self.RenderPanelTitle(k,v)
        if v.display_value then
            self.RenderValue(v)
        end
        if v.renderfunc and type(v.renderfunc)=='function' then v.renderfunc(v) end
    end


end