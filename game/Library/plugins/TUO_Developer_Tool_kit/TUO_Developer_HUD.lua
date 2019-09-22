local SIDE_X1,SIDE_X2,SIDE_X3,SIDE_X4=-107,56,72,620
---------------------------------
---粗糙的补间函数
local expl = function(vstart,vend,t)  return vstart+(vend-vstart)*sin(90*t) end

TUO_Developer_HUD={
    timer=0,
    side_x=SIDE_X1,
    panel={}
}
local self=TUO_Developer_HUD
self.self=TUO_Developer_Tool_kit
--------------------------------------------------
---在HUD里新建面板
---@param title string 面板标题，显示在左边栏
---@param monitoring_value table or string or function 监视列表，可以用字符串监视一个变量，也可以直接监视一个表，也可以用函数来将待监视的值导入self.displey_value
---@param initfunc function 
---@param framefunc function
---@param renderfunc function
---@param force_refresh boolean 若设为true，面板就算不显示也会强制执行frame函数
function TUO_Developer_HUD.NewPanel(title,monitoring_value,initfunc,framefunc,renderfunc,force_refresh)
    if initfunc and type(initfunc)=='function' then initfunc() end
    table.insert(TUO_Developer_HUD.panel,{
        title=title,
        timer=0,
        alpha=0,
        y_offset=0,
        y_offset_aim=0,
        value_pre={},
        value_change={},
        monitoring_value=monitoring_value,
        framefunc=framefunc,
        renderfunc=renderfunc,
        force_refresh=force_refresh or false})
end
--------------------------------------------------
---渲染面板的标题
---@param index number 位于第几个槽位
---@param panel table 记录面板信息的表
function TUO_Developer_HUD.RenderPanelTitle(index,panel)
    local t=panel.timer/10
    local TOP_OFFSET=16
    local RIGHT_OFFSET=16
    local HEIGHT=32
    local SIZE=1.2
    local GAP=8
    local color=Color(self.timer/30*255,t*255,t*255,t*255)
    local ttf=self.self.ttf
    SetImageState('white','',Color(0xFF101010))
    local x1=self.side_x+RIGHT_OFFSET+(SIDE_X1-SIDE_X2)-6
    local y_c=TOP_OFFSET+((2*index-1)*(HEIGHT+GAP)-GAP)/2
    local y_h=expl(HEIGHT/10,HEIGHT/1.8,t)
    RenderRect('white',
        x1-4,x1,
        y_c-y_h,y_c+y_h)
    local x2=expl(x1,SIDE_X2,t)
    local y_h=expl(0,HEIGHT/2,t)
    SetImageState('white','',Color(0xFF202020))
    RenderRect('white',
        x1,x2,
        y_c-y_h,y_c+y_h)
    RenderTTF2(ttf,panel.title,self.side_x+RIGHT_OFFSET+(SIDE_X1-SIDE_X2),self.side_x-RIGHT_OFFSET,
        TOP_OFFSET+(index-1)*(HEIGHT+GAP),
        TOP_OFFSET+index*(HEIGHT+GAP)-GAP,SIZE,color,'left','vcenter')
    
end
--------------------------------------------------
---渲染一列值
---@param panel table 面板信息
---@param title string 标题文字，同一个面板下不可重复
---@param x_pos number x起始位置，如果在这个函数调用之后紧接着以相同的该参数调用则新渲染的内容会在其下方而不会重叠，请注意
---@param value_table table 待观测表，目前没对表中表进行处理
function TUO_Developer_HUD.DisplayValue(panel,title,x_pos,value_table)
    local last_top
    title=title or 'Value Monitor'
    local p=panel
    local TOP_OFFSET=16
    local l=expl(SIDE_X4-24,SIDE_X4,p.timer/10)
    if x_pos then l=expl(x_pos-24,x_pos,p.timer/10) end
    local r=l+640
    local t=480-TOP_OFFSET+panel.y_offset
    if self.__DH_last_top~=0 and self.__DH_last_x_pos==x_pos and self.__DH_last_panel_title==panel.title then
        t=self.__DH_last_top-TOP_OFFSET*4 end
    local b
    local HEIGHT=16
    local SIZE=1
    local GAP=2
    local ttf=self.self.ttf
    local color=Color(panel.timer/10*255,0,0,0)
    RenderTTF2(ttf,title,l-5,r,t-HEIGHT*1.5,t,SIZE*1.2,color)
    t=t-HEIGHT*1.5-GAP
    if value_table then
        local index=panel.title..title
        panel.value_pre[index]=panel.value_pre[index] or {}
        --这个表用来记录变量做出改变的红色高亮视觉提示，范围0~1,1为红色
        panel.value_change[index]=panel.value_change[index] or {}
        
        for k,v in pairs(value_table) do  
            --缩写下
            local pre=panel.value_pre[index]
            local change=panel.value_change[index]
            -----------------------
            change[k]=change[k] or 0
            -----------------------变量有变化则让这个变成1
            if v~=pre[k] then change[k]=1 else change[k]=max(0,change[k]-0.02) end
            pre[k]=v
            color=Color(panel.timer/10*255,255*change[k],100*change[k],100*change[k])
            -----------------------
            b=t-HEIGHT
            RenderTTF2(ttf,k..': '..tostring(v),l,r,b,t,SIZE,color)
            t=t-HEIGHT-GAP
        end
    else
        if not panel.display_value then error(panel.title) end
        local index=panel.title..'_display_value'
        if not panel.value_pre[index] then  panel.value_pre[index]={} end
        if not panel.value_change[index] then  panel.value_change[index]={} end
        
        for _,v in pairs(panel.display_value) do  
            local pre=panel.value_pre[index]
            local change=panel.value_change[index]
            change[v.name]=change[v.name] or 0
            if v.v~=pre[v.name] then change[v.name]=1 else change[v.name]=max(0,change[v.name]-0.02) end
            pre[v.name]=v.v
            color=Color(panel.timer/10*255,255*change[v.name],100*change[v.name],100*change[v.name])
            b=t-HEIGHT
            RenderTTF2(ttf,v.name..': '..tostring(v.v),l,r,b,t,SIZE,color)
            t=t-HEIGHT-GAP
        end
    end
    self.__DH_last_panel_title=panel.title
    self.__DH_last_top=t 
    self.__DH_last_x_pos=x_pos
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
        
        if (v.framefunc and type(v.framefunc)=='function') and (v.timer>0 or v.force_refresh) then v.framefunc(v) end

        if v.monitoring_value then
            if type(v.monitoring_value)=='function' then v.display_value=v.monitoring_value() 
            elseif type(v.monitoring_value)=='string' then  v.display_value={} --待补充
            elseif type(v.monitoring_value)=='table' then 
                --临时处理
                v.display_value={} 
                for key,value in pairs(v.monitoring_value) do
                    table.insert(v.display_value,{name=key,v=value})
                end
            else v.display_value=nil
            end
        end
    end
    if lstg.GetKeyState(KEY.PGUP) or lstg.GetKeyState(KEY.PGDN) then
        if self.scroll_force<=0 then self.scroll_force=1
        else self.scroll_force=min(50,self.scroll_force+0.5) end
    else self.scroll_force=0
    end
    if lstg.GetKeyState(KEY.PGUP) then self.panel[self.cur].y_offset_aim=max(0,self.panel[self.cur].y_offset_aim-5-self.scroll_force) end
    if lstg.GetKeyState(KEY.PGDN) then self.panel[self.cur].y_offset_aim=self.panel[self.cur].y_offset_aim+5+self.scroll_force end
    self.panel[self.cur].y_offset=self.panel[self.cur].y_offset*0.85+self.panel[self.cur].y_offset_aim*0.15

end
function TUO_Developer_HUD.render()
    SetViewMode'ui'    
    --渲染白色侧边栏
    local sis=SetImageState
    local rr=RenderRect
    -- local rttf=RenderTTF
    sis('white','',Color(195*self.timer/30,255,255,255))
    rr('white',SIDE_X1,640-SIDE_X1,0,480)
    sis('white','',Color(0xFFFFFFFF))
    rr('white',SIDE_X1,self.side_x,0,480)
    for i=1,10 do
        sis('white','',Color((1-i/10)*100*self.timer/30,0,0,0))
        rr('white',self.side_x+i-1,self.side_x+i,0,480)
    end
    for k,v in pairs(self.panel) do
        self.RenderPanelTitle(k,v)
        if v.display_value then
            self.DisplayValue(v)
        end
        if v.renderfunc and type(v.renderfunc)=='function' then v.renderfunc(v) end
    end

end