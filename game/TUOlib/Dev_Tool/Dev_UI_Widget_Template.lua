local ttf='f3_word'
--尚未排除重复索引值带来的问题
local DeserializeTable
local DeserializeTable2
---------------------------------------
---拆表并显示在Display_value里
DeserializeTable=function (widget,t,output,level,index)
    level=level or 1
    output=output or widget.display_value
    index=index or ''
    --长度保护
    if #(widget.display_value)>512 then 
        table.insert(widget.display_value,{name='!!!',v=' Reached Table Print Limit',index=0}) return false
    end
    --深度保护
    if level>4 then 
        local head=''
        for i=0,level-1 do head=head..'    ' end
        table.insert(widget.display_value,{name=head..'!!!',v=' Reached Table Print Limit',index=0})
        return false
    end
    local length=0
    for _k,_v in pairs(t) do
        length=length+1 
        _k=tostring(_k)
        if length>512 then 
            table.insert(widget.display_value,{name='!!!',v=' Reached Table Print Limit',index=0}) return false end
        if type(_v)=='table' then 
            local head=''
            for i=0,level-1 do head=head..'  ' end
            if level>0 then head=head..' +' end
            table.insert(widget.display_value,{name=head.._k,v=_v})
            -- table.insert(widget.display_value,{name=head.._k,v=_v,index=index..tostring(_v)})
            local flag=DeserializeTable(widget,_v,nil,level+1,index..tostring(_v))
            -- if not flag then return false end
        else 
            local head=''
            for i=0,level do head=head..'  ' end
            table.insert(widget.display_value,{name=head.._k,v=_v})
            -- table.insert(widget.display_value,{name=head.._k,v=_v,index=index..tostring(_v)})
        end
    end
    return true
end
---------------------------------------
---拆表并显示在Display_value里，只拆一层
DeserializeTable2=function (widget,t,output,level,index)
    level=level or 0
    output=output or widget.display_value
    index=index or ''
    --长度保护
    if #(widget.display_value)>512 then 
        table.insert(widget.display_value,{name='!!!',v=' Reached Table Print Limit',index=0}) return false
    end
    local length=0
    for _k,_v in pairs(t) do
        length=length+1 
        _k=tostring(_k)
        if length>512 then 
            table.insert(widget.display_value,{name='!!!',v=' Reached Table Print Limit',index=0}) return false end
        if type(_v)=='table' then 
            table.insert(widget.display_value,{name=_k,v=_v})
        else 
            table.insert(widget.display_value,{name=_k,v=_v})
            -- table.insert(widget.display_value,{name=head.._k,v=_v,index=index..tostring(_v)})
        end
    end
    return true
end

---------------------------------
---粗糙的补间函数
-- local itpl = function(vstart,vend,t)  return vstart+(vend-vstart)*(cos(180+180*t)+1)/2 end

-------------------------
---带缓冲的补间函数（如果出问题就换回上面的）
local itpl = function(vstart,vend,t) return vstart+(vend-vstart)*(sin(1.17*180*(t-0.5))/(2*sin(1.17*0.5*180))+0.5) end

------------------------------
---更快捷的方块渲染
local RenderCube= function(l,r,b,t,ca,cr,cg,cb) 
    if ca and cr and cg and cb then
        SetImageState('white','',Color(ca,cr,cg,cb)) end
    if ca and (not cr) then
        SetImageState('white','',ca) end
    RenderRect('white',l,r,b,t)
end
-----------------------------------
---快速判断xy是否落入碰撞箱内
local HitboxCheck=function(widget)
    local mx,my=ScreenToUI(lstg.GetMousePosition())
    local hb=widget.hitbox
    local l,r,b,t=hb.l,hb.r,hb.b,hb.t
    if mx>l and mx<r and my>b and my<t then return true else return false end
end


-- 标题控件，字体更大，跟上面的控件隔开相当的距离
    ---text string 标题
local title=TUO_Developer_UI:NewWidgetTemplate('title')
function title:init()
    self.text='默认标题'
    self.height=24
    self.gap_t=self.height*2
    self.gap_b=6
end

function title:frame() 
    if not self.text then self.visiable=false else self.visiable=true end
end
function title:render(alpha,l,r,b,t)
    -- if alpha==nil then alpha=1 Print('?') end
    local title=self.text
    local color=Color(alpha*255,0,0,0)
    RenderTTF2(ttf,title,l,r,b,t,1.2,color,'left','vcenter')
    local y_c=t-self.height
    local y_h=sin(alpha*90)
    local wr=itpl(l,l+160,alpha)
    RenderCube(l,wr,y_c-y_h,y_c+y_h,255,16,16,16)
end
-- 变量监测控件，
    -- 主要参数为：
    ---monitoring_value 可以是string table funciton 所有可能的用法：
        ---monitoring_value=funciton(self) local t={} <一些操作> return t end
        ---monitoring_value='lstg.var'
        ---monitoring_value=lstg
        ---monitoring_value={'lstg.var','lstg.tmpvar'}
local value_displayer=TUO_Developer_UI:NewWidgetTemplate('value_displayer')
function value_displayer:init()
    self.height=16
    self.text=nil
    self.monitoring_value=nil
    self.display_value={}
    self.value_pre={}
    self.value_change={}
end
function value_displayer:frame()
    if self.monitoring_value==nil then return end
    ----处理数据
        if type(self.monitoring_value)=='function' then self.display_value=self.monitoring_value(self) 
        elseif type(self.monitoring_value)=='string' then  
            self.display_value={}
            local v_tmp=IndexValueByString(self.monitoring_value)
            table.insert(self.display_value,{name=self.monitoring_value,v=v_tmp}) 
            if type(v_tmp)=='table' then DeserializeTable(self,v_tmp) end
        elseif type(self.monitoring_value)=='table' then 
            --支持显示表中表
            self.display_value={}
            --存的是索引值，先索引再拆
            if self.monitoring_value.use_G then
                for _k,_v in pairs(self.monitoring_value) do
                    if type(_v)=='string' then 
                        local v_tmp=IndexValueByString(_v)
                        table.insert(self.display_value,{name=_v,panel=v_tmp})
                        if type(v_tmp)=='table' then DeserializeTable(self,v_tmp) end
                    end
                end
            else --存的不是索引值， 直接拆
                table.insert(self.display_value,{name=tostring(self.monitoring_value),v='table'})
                DeserializeTable(self,self.monitoring_value)
            end
        else self.display_value=nil
        end
    --整理数据
    if not self.value_pre then  self.value_pre={} end
    --这个表用来记录变量做出改变的红色高亮视觉提示，范围0~1,1为红色
    if not self.value_change then  self.value_change={} end
    --缩写下
    local pre=self.value_pre
    local change=self.value_change
    local b,t=self.hitbox.b,self.hitbox.t
    local oringinal_t=t
    for _,v in pairs(self.display_value) do  
        local index=v.index or v.name
        change[index]=change[index] or 0
        -----------------------变量有变化则让这个变成1
        if v.v~=pre[index] then change[index]=1 else change[index]=max(0,change[index]-0.02) end
        pre[index]=v.v
        -----------------------
        b=t-self.height
        t=t-self.height-self.gap_t
    end
    self.hitbox.b=b
    self.hitbox.t=oringinal_t
end
function value_displayer:render(alpha,l,r,b,t)
    
    if not self.display_value then return end
    ---lrbt初始值
    local l=self.hitbox.l
    local r=self.hitbox.r
    local t=self.hitbox.t 
    local b
    
    --缩写下
    local pre=self.value_pre
    local change=self.value_change
    for _,v in pairs(self.display_value) do  
        local index=v.index or v.name
        local color=Color(alpha*255,255*change[index],50*change[index],50*change[index])
        -----------------------
        b=t-self.height
        if self.text then 
            RenderTTF2(ttf,self.text..': '..tostring(v.v),l,r,b,t,1,color,'left','vcenter')
        else
            RenderTTF2(ttf,v.name..': '..tostring(v.v),l,r,b,t,1,color,'left','vcenter')
        end
        t=t-self.height-self.gap_t
    end
end
-- 条状变量监测控件
    -- 主要参数为：
    -- monitoring_value string 必须可以索引至number
    -- max_value number
    -- min_value number
local value_gauge=TUO_Developer_UI:NewWidgetTemplate('value_gauge')
function value_gauge:init()
    self.l=240
    self.w=6
    self.borderwidth=2
    self.height=self.w+self.borderwidth*2
    self.gap_t=3
    self.pos=0
    self.width=240
    self.pos_aim=0
    self.monitoring_value=nil
    self.min_value=0
    self.max_value=100
    self.deviated=false
    self.value_pre=0
    self.changetimer=0
end
function value_gauge:frame()
    local m
    if type(self.monitoring_value)=='string' then 
        m=IndexValueByString(self.monitoring_value)
    else
        m=self.monitoring_value
    end
    if type(m)~='number' then 
        self.deviated=true
        self.pos=(sin(self.timer)*0.5+0.5)*self.l
    else
        if self.value_pre~=m then self.changetimer=1 else self.changetimer=max(0,self.changetimer-0.02) end
        self.pos_aim=max(0,min(self.max_value-self.min_value,m-self.min_value))/(self.max_value-self.min_value)*self.l
        self.pos=self.pos+(self.pos_aim-self.pos)*0.2
        self.value_pre=m
    end
end
function value_gauge:render(alpha,l,r,b,t)
    --panel
    local panel=self.panel
    ---排版
    local BORDER_WIDTH=2
    local TOP_OFFSET=16
    local HEIGHT=self.w+BORDER_WIDTH*2
    local GAP_T=3
    local x_pos=self._x_pos
    

    ---lrbt初始值
    local l=self.hitbox.l
    local r=self.hitbox.r
    local m=l+self.pos
    local t=self.hitbox.t
    local b=self.hitbox.b
    local yc=(t+b)/2
    local h=self.w/2
    RenderCube(l,r,b,t,Color(255*alpha,20,20,20))
    RenderCube(l+BORDER_WIDTH,r-BORDER_WIDTH,b+BORDER_WIDTH,t-BORDER_WIDTH,Color(255*alpha,255,255,255))
    RenderCube(l,m,yc-h,yc+h,Color(255*alpha,20+210*self.changetimer,20,20))
end
-- 滑块条，可以监测并改变某个变量 必须是number
    -- 主要参数为：
    -- monitoring_value string 必须可以索引至number
    -- max_value number
    -- min_value number
local value_slider=TUO_Developer_UI:NewWidgetTemplate('value_slider')
function value_slider:init()
    self.l=240
    self.w=4
    self.borderwidth=2
    self.height=self.w+self.borderwidth*2
    self.gap_t=4
    self.pos=0
    self.pos_aim=0
    self.width=self.l+self.borderwidth*2
    self.monitoring_value=nil
    self.min_value=0
    self.max_value=100
    self.deviated=false
    self.value_pre=0
    self.changetimer=0
    self.force_int=false
end
function value_slider:frame()
    self.l=self.width-self.borderwidth*2
    local m
    if type(self.monitoring_value)=='string' then 
        m=IndexValueByString(self.monitoring_value)
    elseif type(self.monitoring_value)=='function' then
        m=self.monitoring_value(self)
    else
        m=self.monitoring_value
    end
    if type(m)~='number' then 
        self.deviated=true
        self.pos=(sin(self.timer)*0.5+0.5)*self.l
    else
        if self.value_pre~=m then self.changetimer=1 else self.changetimer=max(0,self.changetimer-0.02) end
        self.pos_aim=max(0,min(self.max_value-self.min_value,m-self.min_value))/(self.max_value-self.min_value)*self.l
        self.pos=self.pos+(self.pos_aim-self.pos)*0.2
        self.value_pre=m
    end
    ---排版
    local BORDER_WIDTH=self.borderwidth
    ---lrbt初始值
    local l=self.hitbox.l
    local r=self.hitbox.r
    local t=self.hitbox.t
    local b=self.hitbox.b
    if self._pressed then
        local mx=MouseState.x_in_UI
        local k=(mx-(l+BORDER_WIDTH))/(r-l-2*BORDER_WIDTH)
        local v=(self.max_value-self.min_value)*k+self.min_value
        v=min(self.max_value,max(self.min_value,v))
        if self.force_int then if v-int(v)>0.5 then v=int(v)+1 else v=int(v) end end --强制取证
        if type(self.monitoring_value)=='string' then
            IndexValueByString(self.monitoring_value,v)
        elseif type(self.monitoring_value)=='function' then
            self.monitoring_value(self,v)
        end
        if self._event_valuechange then self:_event_valuechange() end
    end
end
function value_slider:render(alpha,l,r,b,t)
    ---排版
    local BORDER_WIDTH=self.borderwidth
    local HEIGHT=self.w+BORDER_WIDTH*2
    local GAP_T=self.gap_t
    local x_pos=self.x
    ---lrbt初始值
    local l=self.hitbox.l
    local r=self.hitbox.r
    local m=l+self.pos+self.borderwidth
    local t=self.hitbox.t
    local b=self.hitbox.b
    local yc=(t+b)/2
    local h=self.w/2
    local w2=1
    SetImageState('white','',Color(255*alpha,20,20,20))
    RenderRect('white',l,r,b,t)
    if l+BORDER_WIDTH<r-BORDER_WIDTH then
        SetImageState('white','',Color(255*alpha,255,255,255))
        RenderRect('white',l+BORDER_WIDTH,r-BORDER_WIDTH,b+BORDER_WIDTH,t-BORDER_WIDTH)
    end
    SetImageState('white','',Color(255*alpha,20+210*self.changetimer,20,20))
    RenderRect('white',l+BORDER_WIDTH,m,yc-h,yc+h)
    h=h*3
    if self._mouse_stay and (not self._pressed) then 
        SetImageState('white','',Color(255*alpha,50+205*self.changetimer,50,50))
        w2=1.5
    elseif self._pressed then
        SetImageState('white','',Color(255*alpha,150+105*self.changetimer,150,150))
        w2=3
        h=h*1.2
    end
    RenderRect('white',m-w2,m+w2,yc-h,yc+h)
end

-- 按钮
    -- 主要参数为：
    --  width number
    --  height number
local button=TUO_Developer_UI:NewWidgetTemplate('button')
function button:init()
    self.text='Button'
    self.enable=true
    ---排版
    self.width=120
    self.height=24
    self.gap_t=4
    self.size=0.8
end
function button:frame()
end
function button:render(alpha,l,r,b,t)            
    --排版
    local WIDTH=self.width
    local HEIGHT=self.height
    local SIZE=self.size
    local GAP_T=self.gap_t
    ---lrbt初始值
    local l=self.hitbox.l
    local r=self.hitbox.r
    local t=self.hitbox.t
    local b=self.hitbox.b
    
    local k=min(1,0.15*self._ignite_timer+self._pressed_timer)
    local BORDER_WIDTH=min(abs(r-l),abs(t-b))/2*alpha*k
    local bd=BORDER_WIDTH
    for i=1,5,0.5 do
        RenderCube(l-i,r+i,b-i,t+i,(5-i)/5*10*alpha,10,10,10)
    end
    RenderCube(l,r,b,t,255*alpha,30,30,30)
    RenderCube(l+bd,r-bd,b+bd,t-bd,255*alpha,255,255,255)
    if self.text then
        local c=255*(max(0.5,k)-0.5)*2
        RenderTTF2(ttf,self.text,l,r,b,t,self.size,Color(255*alpha,c,c,c),'vcenter','center')
    end
end
    -- 文本框，只能显示固定的文本
        -- 主要参数为：
        --  text string 要显示的文本
local text_displayer=TUO_Developer_UI:NewWidgetTemplate('text_displayer')
function text_displayer:init()
    self.text='text_displayer'
    self.text_table=nil
    self.text_rgb={0,0,0}
end
function text_displayer:frame()
    --排版
    local WIDTH=self.width
    local HEIGHT=self.height
    local SIZE=self.size
    local GAP_T=self.gap_t
    ---lrbt初始值
    local l=self.hitbox.l
    local r=self.hitbox.r
    local t=self.hitbox.t
    local b=self.hitbox.b
    local pos=string.find(self.text,"\n",1,true)
    if not pos then
        self.text_table=nil
    else
        self.text_table={}
        local oringinal_t=t
        local pospre=0
        while pos do
            local text = string.sub(self.text,pospre+1,pos-1)
            table.insert(self.text_table,text)
            t=t-HEIGHT-GAP_T
            pospre=pos
            pos=string.find(self.text,"\n",pos+1,true)
        end
        b=t-HEIGHT
        local text = string.sub(self.text,pospre+1,string.len(self.text))
        table.insert(self.text_table,text)
        self.hitbox.b=b
        self.hitbox.t=oringinal_t
    end
end
function text_displayer:render(alpha,l,r,b,t)
    --排版
    local WIDTH=self.width
    local HEIGHT=self.height
    local SIZE=self.size
    local GAP_T=self.gap_t
    ---lrbt初始值
    local l=self.hitbox.l
    local r=self.hitbox.r
    local t=self.hitbox.t
    local b=self.hitbox.b
    local color=Color(255*alpha,self.text_rgb[1],self.text_rgb[2],self.text_rgb[3])
    local pos=string.find(self.text,"\n",1,true)
    local ux,uy=MouseState.x_in_UI,MouseState.y_in_UI
    if not self.text_table then
        RenderTTF2(ttf,self.text,l+2,r,b,t,SIZE,color,'left','vcenter')
    else
        for k,v in pairs(self.text_table) do
            b=t-HEIGHT
            if ux>l and ux<r and uy>b and uy<t then
                RenderCube(l,r,b,t,25*alpha,0,0,0)
            end
            RenderTTF2(ttf,v,l+2,r,b,t,SIZE,color,'left','vcenter')
            t=b-GAP_T
        end
    end
end
-- 列表框，监视或存放一列值，可以对其中的内容进行删改
    ---魔改自 value_displayer
    -- 主要参数为：
    -- monitoring_value 与value_displayer的逻辑一样
    -- keep_refresh boolean 是否持续根据被监测变量刷新列表
    -- width number
    -- refreshfunc function 如果没有 monitoring_value 则会尝试调用这个函数
local list_box=TUO_Developer_UI:NewWidgetTemplate('list_box')
function list_box:init()
    self.keep_refresh=true
    self.cur=1
    self.gap=2
    self.gap_t=2
    self.gap_b=4
    self.monitoring_value=nil
    self.display_value={}
    self.selection={}
    self.select_timer={}
    self._ban_pressed_effect=true
    self._ban_mul_select=false
end
function list_box:frame()
    --处理数据
        if type(self.display_value)=='table' then 
            for i,v in pairs(self.display_value) do
                self.select_timer[i]=self.select_timer[i] or 0
                if self.selection[i] then 
                    self.select_timer[i]=min(1,self.select_timer[i]+0.1)
                else
                    self.select_timer[i]=max(0,self.select_timer[i]-0.05)
                end
            end
        end

        if self.keep_refresh then 
            if self.monitoring_value then
                if type(self.monitoring_value)=='function' then self.display_value=self.monitoring_value(self) 
                elseif type(self.monitoring_value)=='string' then  
                    self.display_value={}
                    local v_tmp=IndexValueByString(self.monitoring_value)
                    if type(v_tmp)=='table' then  DeserializeTable2(self,v_tmp) 
                    else table.insert(self.display_value,{name=self.monitoring_value,panel=v_tmp}) end
                elseif type(self.monitoring_value)=='table' then 
                    --支持显示表中表
                    self.display_value={}
                    --存的是索引值，先索引再拆
                    if self.monitoring_value.use_G then
                        for _k,_v in pairs(self.monitoring_value) do
                            if type(_v)=='string' then 
                                local v_tmp=IndexValueByString(_v)
                                if type(v_tmp)=='table' then  DeserializeTable2(self,v_tmp) 
                                else table.insert(self.display_value,{name=_v,panel=v_tmp}) end
                            end
                        end
                    else --存的不是索引值， 直接拆
                        table.insert(self.display_value,{name=tostring(self.monitoring_value),v=''})
                        DeserializeTable2(self,self.monitoring_value)
                    end
                else self.display_value={name='',v='* List is empty'}
                end
            elseif self.refresh then self:refresh() 
            else self.display_value={name='',v='* List is empty'} self.visiable=false self.vanish_cause_novalue=true return end
            if self.vanish_cause_novalue then self.visiable=true end
            --对display_value进行排序
            if self.display_value and self.display_value[1] and (type(self.display_value[1].name)=='string' or type(self.display_value[1].name)=='number')  then 
                local sortfunc=self.sortfunc or function(v1,v2)  return v1.name<v2.name end
                table.sort(self.display_value,sortfunc)
            end
        end

    --处理排版
        if not self.display_value then return end
        --排版
        local WIDTH=self.width
        local HEIGHT=self.height
        local SIZE=self.size
        local GAP_T=self.gap_t
        local GAP=self.gap
        ---lrbt初始值
        local l=self.hitbox.l
        local r=self.hitbox.r
        local t=self.hitbox.t
        local oringinal_t=t
        local b=self.hitbox.b
        t=t-2-GAP

        for i,v in pairs(self.display_value) do  
            b=t-HEIGHT
            local ux,uy=MouseState.x_in_UI,MouseState.y_in_UI
            local flag=(ux>l and ux<r and uy>b and uy<t)
            local mul=lstg.GetKeyState(KEY.CTRL) and (not self._ban_mul_select)
            if MouseTrigger(0) and flag then
                if mul then
                    local ori=self.selection[i] or false
                    self.selection[i]=not ori 
                else
                    self.selection={}
                    for _i=1,#self.display_value do
                        if _i==i then
                            self.selection[_i]=true
                        else
                            self.selection[_i]=false
                        end
                    end
                    -- self.selection[i]=true
                end
            end
            t=t-HEIGHT-GAP
        end
        t=t-GAP
        b=t+GAP/2+2
        self.hitbox.b=b
        self.hitbox.t=oringinal_t
end
function list_box:render(alpha,l,r,b,t)
    if not self.display_value then return end
    --排版
    local WIDTH=self.width
    local HEIGHT=self.height
    local SIZE=self.size
    local GAP_T=self.gap_t
    local GAP=self.gap
    ---lrbt初始值
    local l=self.hitbox.l
    local r=self.hitbox.r
    local t=self.hitbox.t
    local oringinal_t=t
    local b=self.hitbox.b
    RenderCube(l,r,t-2-GAP/2,t,Color(255*alpha,30,30,30))
    t=t-2-GAP

    for i,v in pairs(self.display_value) do  
        local color=Color(alpha*255,20,20,20)
        b=t-HEIGHT
        if b<480 then
            local ux,uy=MouseState.x_in_UI,MouseState.y_in_UI
            local flag=(ux>l and ux<r and uy>b and uy<t)
            if flag then
                RenderCube(l,r,b,t,25*alpha,20,20,20)
            end
            if i%2==0 then
                RenderCube(l,r,b,t,25*alpha,20,20,20)
            else
                RenderCube(l,r,b,t,25*alpha,255,255,255)
            end
            --选择高亮
            local colorw=Color(alpha*255,0,0,0)
            if self.select_timer[i] and self.select_timer[i]>0 then
                local l,r=l+GAP,r-GAP
                local m=(l+r)/2
                local l2=itpl(l,m,self.select_timer[i])
                local r2=itpl(r,m,self.select_timer[i])
                RenderCube(l,l2,b-GAP/2,t+GAP/2,color)
                RenderCube(r2,r,b-GAP/2,t+GAP/2)
                local c=self.select_timer[i]*255
                colorw=Color(alpha*255,c,c,c)
            end
            RenderCube(l,l+2,b-GAP/2,t+GAP/2,color)
            RenderCube(r-2,r,b-GAP/2,t+GAP/2)
            if type(v)~='table' then 
                RenderTTF2(ttf,tostring(v),l+2+GAP,r+2+GAP,b,t,SIZE,colorw,'left','vcenter')
            elseif v.name=='' then
                RenderTTF2(ttf, tostring(v.v),l+2+GAP,r+2+GAP,b,t,SIZE,colorw,'left','vcenter')
            else
                RenderTTF2(ttf,v.name..': '..tostring(v.v),l+2+GAP,r+2+GAP,b,t,SIZE,colorw,'left','vcenter')
            end
        end
        t=t-HEIGHT-GAP
        if t<0 then break end
    end
    t=t-GAP
    RenderCube(l,r,t,t+GAP/2+2)
end

-- 输入框
    -- 主要参数为：
    -- text string 输入框的内容
    -- _event_textchange function 文本内容发生变化后调用的函数
local inputer=TUO_Developer_UI:NewWidgetTemplate('inputer')
function inputer:init()
        self.text=''
        self.txtepre=''
        self.enable=true
        self.connected=false
        self.connect_timer=0
        self._tpl_event_mousepress=function(self)
            if not KeyInputTemp.enable then
                self.connected=true
                KeyInputTemp:Activate(self.text)
            end
            -- Print('_tpl_event_mousepress')
        end
        self._tpl_event_mouseleave=function(self)
            if self.connected then
                self.connected=false
                self.text=KeyInputTemp:Pull()
                KeyInputTemp:Deactivate()
            end
            -- Print('_tpl_event_mousepress')
        end
        ---排版
        self.width=360
        self.height=24
        self.gap=4
        self.size=0.8
        --为了同排多个输入框
        self.x_pos2=0
end
function inputer:frame()
    if self.connected then
        self.text=KeyInputTemp:Pull()
        self.connect_timer=self.connect_timer+(1-self.connect_timer)*0.2
        if self.text~=self.txtepre then if self._event_textchange then self:_event_textchange() end end
    else
        self.connect_timer=self.connect_timer+(0-self.connect_timer)*0.2
    end
    
end
function inputer:render(alpha,l,r,b,t)        
    --排版
    local WIDTH=self.width
    local HEIGHT=self.height
    local SIZE=self.size
    local GAP_T=self.gap_t
    ---lrbt初始值
    local l=self.hitbox.l
    local r=self.hitbox.r
    local t=self.hitbox.t
    local b=self.hitbox.b

    local h=2+(HEIGHT-2)*self.connect_timer
    local k=0.15*self._ignite_timer+0.85*self._pressed_timer


    for i=1,5,0.5 do
        RenderCube(l-i,r+i,b-i,b+h+i,(5-i)/5*10*alpha,10,10,10)
    end
    RenderCube(l,r,b,b+h,255*alpha,30,30,30)
    local m=(r+l)/2
    local l2=m+(l-m)*self._ignite_timer
    local r2=m+(r-m)*self._ignite_timer
    RenderCube(l2,r2,b,b+2,255*alpha,150,150,150)
    if self.text then
        local c=255*self.connect_timer
        RenderTTF2(ttf,self.text,l+4,r-4,b,t,self.size,Color(255*alpha,c,c,c),'vcenter','left')
    end
end

-- 开关
    -- 主要参数为：
    --  flag boolean
    --  text_on string
    --  text_off string
    --  _event_switched fun<widget:table,flag:boolean> 切换选项事件
local switch=TUO_Developer_UI:NewWidgetTemplate('switch')
function switch:init()
    self.enable=true
    self.flag=false
    self.flag_timer=0
    self.monitoring_value=nil
    self._tpl_event_mouseclick=function(self)
        self.flag= not self.flag
        local m=self.monitoring_value
        if type(m)=='string' then
            local v=IndexValueByString(self.monitoring_value)
            if type(v)=='boolean' or type(v)=='nil' then
                IndexValueByString(self.monitoring_value,self.flag)
            end
        elseif type(m)=='function' then
            m(self.flag)
        end

        if self._event_switched then self:_event_switched(self.flag) end
    end
    ---排版
    self.box_width=36
    -- self.width=36
    self.height=18
    self.gap=5
    self.size=0.8
end
function switch:frame()
    if self.monitoring_value then
        local m=self.monitoring_value
        if type(m)=='string' then
            local v=IndexValueByString(self.monitoring_value)
            if type(v)=='boolean'  then
                self.flag=v
            end
        elseif type(m)=='function' then
            self.flag=m()
        end
    end
    if self.flag then
        self.flag_timer=min(1,self.flag_timer+0.1)
    else
        self.flag_timer=max(0,self.flag_timer-0.1)
    end
end
function switch:render(alpha,l,r,b,t)
    --排版
    local WIDTH=self.box_width
    local HEIGHT=self.height
    local SIZE=self.size
    local GAP_T=self.gap_t
    ---lrbt初始值
    local l=self.hitbox.l
    -- local r=self.hitbox.r
    local r=l+WIDTH
    local t=self.hitbox.t
    local b=self.hitbox.b

    
    local k=0.3+0.7*self.flag_timer
    local c=30+225*self.flag_timer
    local BORDER_WIDTH=min(abs(r-l),abs(t-b))/2*alpha*k
    local bd=BORDER_WIDTH
    local bd2=min(abs(r-l),abs(t-b))/2*0.3*2
    for i=1,5,0.5 do
        RenderCube(l-i,r+i,b-i,t+i,(5-i)/5*10*alpha,10,10,10)
    end
    RenderCube(l,r,b,t,255*alpha,30,30,30)
    RenderCube(l+bd,r-bd,b+bd,t-bd,255*alpha,255,255,255)
    
    local w2=t-b-bd2*2
    local d=r-l-2*bd2-w2
    l=l+d*self.flag_timer
    RenderCube(l+bd2,l+bd2+w2,b+bd2,t-bd2,255*alpha,c,c,c)
    l=r+GAP_T*2
    r=self.hitbox.r

    local c=255*(max(0.5,k)-0.5)*2
    local text='nil'
    if self.flag then   text=self.text_on or 'On'
    else                text=self.text_off or 'Off' end
    RenderTTF2(ttf,text,l,r,b,t,self.size,Color(255*alpha,0,0,0),'vcenter','left')
end
local color_sampler=TUO_Developer_UI:NewWidgetTemplate('color_sampler')
function color_sampler:init()
    self.flag_timer=0
    self.monitoring_value=nil

    --颜色信息
        if HSVColor then 
            self.alpha=100
            self.hue=0
            self.saturation=0
            self.lightness=0
            self.color=HSVColor(100,0,0,0)
            self.colorpre=HSVColor(100,0,0,0)
        end
    ---排版
        self.width=512
        self.height=256
        self.gap_t=12
        self.gap_b=12
        self.size=0.8
        self.ringw=16
    --
    self._tpl_event_mousehold=function(self)
        --兼容性保证
        if not HSVColor then return end
        local w=self.ringw
        local l=self.hitbox.l
        local b,t=self.hitbox.b,self.hitbox.t
        local r=l+t-b
        local x,y=(l+r)/2,(b+t)/2
        local r1=x-l
        local r2=r1-w
        local r3=r2-w/2
        local r4=r3-w
        local l2=l+t-b+16
        local mx,my=MouseState.x_in_UI,MouseState.y_in_UI
        local mr=Dist(mx,my,x,y)
        local ma=atan2(my-y,mx-x)
        if mr>r3 and mr<r1 then
            self.hue=(ma+360)%360
            self.color=HSVColor(self.alpha,self.hue,self.saturation,self.lightness)
        elseif mr<r3 then
            --xy中心
            local xc,yc=x,y
            local x,y=mr*cos(ma-self.hue+30),mr*sin(ma-self.hue+30)
            local b=yc-r4
            local l=xc-cos(30)*r4
            local w=2*cos(30)*r4
            local h=(1+sin(30))*r4
            x,y=x+w/2,y+r4
            local dx=w/2-x
            local y1=y/h
            dx=dx/y1
            x=w/2+dx
            local x1=x/w
            x1=min(1,max(0,x1))
            y1=min(1,max(0,y1))
            self.saturation=100*(1-x1)
            self.lightness=100*y1
            self.color=HSVColor(self.alpha,self.hue,self.saturation,self.lightness)
        elseif mx>l2 and mx<l2+16 and my<t and my>b then
            self.alpha=(my-b)/(t-b)*100
            self.color=HSVColor(self.alpha,self.hue,self.saturation,self.lightness)
        end
        for k,v in pairs({'alpha','hue','saturation','lightness'}) do
            local i,f=math.modf(self[v])
            if f>=0.5 then i=i+1 end
            self[v]=i
        end
        
    end
end
function color_sampler:frame()
    if self.monitoring_value then
        if type(self.monitoring_value)=='string' then

        elseif type(self.monitoring_value)=='function' then
            local color=self:monitoring_value()
            local a,h,s,v=color:AHSV()
            self.color=color
            self.alpha,self.hue,self.saturation,self.lightness=a,h,s,v
        end
    end
    if self.flag then
        self.flag_timer=min(1,self.flag_timer+0.1)
    else
        self.flag_timer=max(0,self.flag_timer-0.1)
    end
    if not self._pressed then self.colorpre=self.color end
end
function color_sampler:render(alpha,l,r,b,t)
    --排版
        local WIDTH=self.width
        local HEIGHT=self.height
        local SIZE=self.size
        local GAP_T=self.gap_t
    ---lrbt初始值
        local l=self.hitbox.l
        local r=self.hitbox.r
        local t=self.hitbox.t
        local b=self.hitbox.b
    
    --兼容性保证
    if not HSVColor then 
        RenderTTF2(ttf,'底层不支持HSV颜色对象构造，控件不可用',l,r,b,t,1,Color(255,0,0,0))
        return
    end
    ----渲染大色环
    do
        local w=self.ringw
        local l=l
        local b,t=b,t
        local r=l+t-b
        local x,y=(l+r)/2,(b+t)/2
        local r1=x-l
        local r2=r1-w
        local r3=r2-w/2
        local r4=r3-w
        --SV跟随色相环
            for i=0,359 do
                SetImageState('white','',HSVColor(100*alpha,i,self.saturation,self.lightness))
                sp.misc.RenderFanShape('white',x,y,i,i+1,r2,r3)
            end
        --纯色色相环
            for i=0,359 do
                SetImageState('white','',HSVColor(100*alpha,i,100,100))
                sp.misc.RenderFanShape('white',x,y,i,i+1,r1,r2)
            end
            for i=0,359 do
                if int(self.hue)==i then 
                    for j=1,3,0.5 do
                        SetImageState('white','',Color(10*(4-j)*alpha,10,10,10))
                        sp.misc.RenderFanShape('white',x,y,i-j,i+1+j,r1+j,r2-j)
                    end
                    SetImageState('white','',HSVColor(100*alpha,i,100,100))
                    sp.misc.RenderFanShape('white',x,y,i,i+1,r1,r2)
                end
            end
        --渐变三角色块
            local c1={x+r4*cos(self.hue+120),   y+r4*sin(self.hue+120), 0.5}
            local c2={x+r4*cos(self.hue),       y+r4*sin(self.hue),     0.5}
            local c3={x+r4*cos(self.hue-120),   y+r4*sin(self.hue-120), 0.5}
            SetImageState('white','',Color(255*alpha,255,255,255),HSVColor(100*alpha,self.hue,100,100),Color(255*alpha,0,0,0),Color(255*alpha,0,0,0))
            Render4V('white',c1[1],c1[2],c1[3],c2[1],c2[2],c2[3],c3[1],c3[2],c3[3],c3[1],c3[2],c3[3])
        --显示当前选取的颜色的位置，这段代码是_event_mousehold中函数的反演函数
            do  
                local w=self.ringw
                local l=self.hitbox.l
                local b,t=self.hitbox.b,self.hitbox.t
                local r=l+t-b
                local xc,yc=(l+r)/2,(b+t)/2
                local b=yc-r4
                local l=xc-cos(30)*r4
                local w=2*cos(30)*r4
                local h=(1+sin(30))*r4
                local x1=1-self.saturation/100
                local y1=self.lightness/100
                local x=x1*w
                local dx=(x-w/2)*y1
                local y=y1*h
                x=w/2-dx
                x,y=x-w/2,y-r4
                local r,a=Dist(0,0,x,y),atan2(y,x)
                a=a-30+self.hue
                x,y=r*cos(a)+xc,r*sin(a)+yc
                SetImageState('white','',Color(160*alpha,64,64,64))
                sp.misc.RenderRing('white', x, y, 6, 5, 32, 0)
                SetImageState('white','',Color(160*alpha,255,255,255))
                sp.misc.RenderRing('white', x, y, 5, 4, 32, 0)
            end
    end
    ----渲染透明度条
        l=l+t-b+16
        do
            local r=l+16
            SetImageState('white','',Color(255*alpha,180,180,180))
            for i=0,16-4,4 do for j=0,t-b-4,4 do
                    if (i/4+j/4)%2==0 then RenderRect('white',l+i,l+i+4,b+j,b+j+4) end
            end end
            SetImageState('white','',Color(255*alpha,255,255,255))
            for i=0,16-4,4 do for j=0,t-b-4,4 do
                    if (i/4+j/4)%2==1 then RenderRect('white',l+i,l+i+4,b+j,b+j+4) end
            end end
            SetImageState('white','',HSVColor(100*alpha,self.hue,self.saturation,self.lightness),HSVColor(100*alpha,self.hue,self.saturation,self.lightness),HSVColor(0,self.hue,self.saturation,self.lightness),HSVColor(0,self.hue,self.saturation,self.lightness))
            RenderRect('white',l,r,b,t)
            local a=self.alpha/100*(t-b)+b
            RenderCube(l-2,r+2,a-2,a+2,alpha*150,20,20,20)
        end
    ----渲染信息
        l=l+24
        r=l+48
        b=t-32
        RenderCube(l,r,b,t,self.color)
        t=b b=t-32
        RenderCube(l,r,b,t,self.colorpre)
        t=b-8 b=t-16
        local disp={
            string.format('A:%d',self.color.a),
            string.format('R:%d',self.color.r),
            string.format('G:%d',self.color.g),
            string.format('B:%d',self.color.b),
            string.format('H:%d',self.hue),
            string.format('S:%d',self.saturation),
            string.format('V:%d',self.lightness),
        }
        for k,v in pairs(disp) do
            RenderTTF2(ttf,v,l,r,b,t,self.size,Color(255*alpha,0,0,0),'top','left')
            t=t-16 b=t-16
        end
end

local saperater=TUO_Developer_UI:NewWidgetTemplate('saperater')
function saperater:init()
        self.enable=true
        ---排版
        self.height=2
        self.gap_t=3
        self.gap_b=3
end
function saperater:render(alpha,l,r,b,t)        
    ---lrbt初始值
    local l=self.hitbox.l
    local r=self.hitbox.r
    local t=self.hitbox.t
    local b=self.hitbox.b
    RenderCube(l,r,b,t,100,0,0,0)
end


-- 列表框，监视或存放一列值，可以对其中的内容进行删改
    ---魔改自 list_box，只改了渲染
    -- 主要参数为：
    -- monitoring_value 与value_displayer的逻辑一样
    -- keep_refresh boolean 是否持续根据被监测变量刷新列表
    -- width number
    -- refreshfunc function 如果没有 monitoring_value 则会尝试调用这个函数
local checkbox_l=TUO_Developer_UI:NewWidgetTemplate('checkbox_l')
function checkbox_l:init()
    self.cur=1
    self.gap=2
    self.gap_t=2
    self.gap_b=4
    self.display_value={}
    self.cur=nil
    self.select_timer={}
end
function checkbox_l:frame()
    if self.refresh then self:refresh() end
    if type(self.display_value)=='table' then 
        for i,v in pairs(self.display_value) do
            self.select_timer[i]=self.select_timer[i] or 0
            if self.cur==i then 
                self.select_timer[i]=min(1,self.select_timer[i]+0.1)
            else
                self.select_timer[i]=max(0,self.select_timer[i]-0.05)
            end
        end
    end

    local l=self.hitbox.l+2
    local r=self.hitbox.r+4
    local t=self.hitbox.t
    local b=self.hitbox.b
    local dw=self.width/(#self.display_value)
    for i,v in pairs(self.display_value) do  
        r=l+dw
        local ux,uy=MouseState.x_in_UI,MouseState.y_in_UI
        if MouseTrigger(0) and ux>l and ux<r and uy>b and uy<t then
            self.cur=i
        end
        l=r
    end
end
function checkbox_l:render(alpha,l,r,b,t)
    if not self.display_value then return end
    --排版
    local WIDTH=self.width
    local HEIGHT=self.height
    local SIZE=self.size
    local GAP_T=self.gap_t
    local GAP=self.gap
    ---lrbt初始值
    local l=self.hitbox.l
    local r=self.hitbox.r
    local t=self.hitbox.t
    local oringinal_t=t
    local b=self.hitbox.b

    RenderCube(l,r+4,t,t+2,Color(255*alpha,30,30,30))
    RenderCube(l,r+4,b+2,b)
    RenderCube(l,l+2,b,t)
    RenderCube(r+2,r+4,b,t)
    l=l+2
    -- t=t-2-GAP
    local dw=self.width/(#self.display_value)
    for i,v in pairs(self.display_value) do  
        local color=Color(alpha*255,20,20,20)
        r=l+dw
        local ux,uy=MouseState.x_in_UI,MouseState.y_in_UI
        local flag=(ux>l and ux<r and uy>b and uy<t)
        if flag then
            RenderCube(l,r,b,t,25*alpha,20,20,20)
        end

        --选择高亮
        local colorw=Color(alpha*255,0,0,0)
        if self.select_timer[i] and self.select_timer[i]>0 then
            local m=(t+b)/2
            local dh=itpl(0,t-b,self.select_timer[i])/2
            RenderCube(l,r,m-dh,m+dh,color)
            local c=self.select_timer[i]*255
            colorw=Color(alpha*255,c,c,c)
        end
        RenderTTF2(ttf,tostring(v),l+2,r-2,b,t,SIZE,colorw,'center','vcenter')
        l=r
    end
end
        

local object_list=TUO_Developer_UI:NewWidgetTemplate('object_list')
function object_list:init()
    self.keep_refresh=true
    self.cur=1
    self.gap=2
    self.gap_t=2
    self.gap_b=4
    self.display_value={}
    self._ban_pressed_effect=true
    self._ban_mul_select=true
end
function object_list:frame()
	if self.keep_refresh then
		if self.refresh then self:refresh()
		else self.display_value={name='',v='* List is empty'} self.visiable=false self.vanish_cause_novalue=true return end
		if self.vanish_cause_novalue then self.visiable=true end
		--对display_value进行排序
		if self.display_value and self.display_value[1] and (type(self.display_value[1].name)=='string' or type(self.display_value[1].name)=='number')  then 
			local sortfunc=self.sortfunc or function(v1,v2)  return v1.name<v2.name end
			table.sort(self.display_value,sortfunc)
		end
	end

    --处理排版
	if not self.display_value then return end
	--排版
	local WIDTH=self.width
	local HEIGHT=self.height
	local SIZE=self.size
	local GAP_T=self.gap_t
	local GAP=self.gap
	---lrbt初始值
	local l=self.hitbox.l
	local r=self.hitbox.r
	local t=self.hitbox.t
	local oringinal_t=t
	local b=self.hitbox.b
	t=t-2-GAP

	for i,v in pairs(self.display_value) do  
		b=t-HEIGHT
		local ux,uy=MouseState.x_in_UI,MouseState.y_in_UI
		local flag=(ux>l and ux<r and uy>b and uy<t)
		local mul=lstg.GetKeyState(KEY.CTRL) and (not self._ban_mul_select)
		if MouseTrigger(0) and flag then
			if mul then
				local ori=self.selection[i] or false
				self.selection[i]=not ori 
			else
				self.selection={}
				for _i=1,#self.display_value do
					if _i==i then
						self.selection[_i]=true
					else
						self.selection[_i]=false
					end
				end
				-- self.selection[i]=true
			end
		end
		t=t-HEIGHT-GAP
	end
	t=t-GAP
	b=t+GAP/2+2
	self.hitbox.b=b
	self.hitbox.t=oringinal_t
end

function object_list:render(alpha,l,r,b,t)
    if not self.display_value then return end
    --排版
    local WIDTH=self.width
    local HEIGHT=self.height
    local SIZE=self.size
    local GAP_T=self.gap_t
    local GAP=self.gap
    ---lrbt初始值
    local l=self.hitbox.l
    local r=self.hitbox.r
    local t=self.hitbox.t
    local oringinal_t=t
    local b=self.hitbox.b
    RenderCube(l,r,t-2-GAP/2,t,Color(255*alpha,30,30,30))
    t=t-2-GAP

    for i,v in pairs(self.display_value) do  
        local color=Color(alpha*255,20,20,20)
        b=t-HEIGHT
        if b<480 then
            local ux,uy=MouseState.x_in_UI,MouseState.y_in_UI
            local flag=(ux>l and ux<r and uy>b and uy<t)
            if flag then
                RenderCube(l,r,b,t,25*alpha,20,20,20)
            end
            if i%2==0 then
                RenderCube(l,r,b,t,25*alpha,20,20,20)
            else
                RenderCube(l,r,b,t,25*alpha,255,255,255)
            end
            --选择高亮
            local colorw=Color(alpha*255,0,0,0)
            RenderCube(l,l+2,b-GAP/2,t+GAP/2,color)
            RenderCube(r-2,r,b-GAP/2,t+GAP/2)
            if type(v)~='table' then 
                RenderTTF2(ttf,tostring(v),l+2+GAP,r+2+GAP,b,t,SIZE,colorw,'left','vcenter')
            elseif v.name=='' then
                RenderTTF2(ttf, tostring(v.v),l+2+GAP,r+2+GAP,b,t,SIZE,colorw,'left','vcenter')
            else
                if type(v.v)~='table' then
					RenderTTF2(ttf,v.name..': '..tostring(v.v),l+2+GAP,r+2+GAP,b,t,SIZE,colorw,'left','vcenter')
				else
					RenderTTF2(ttf,v.name,l+2+GAP,r+2+GAP,b,t,SIZE,colorw,'left','vcenter')
					local count=i+1
					for key,value in pairs(v.v) do
						t=t-HEIGHT-GAP
						b=t-HEIGHT
						if count%2==0 then
							RenderCube(l,r,b,t,25*alpha,20,20,20)
						else
							RenderCube(l,r,b,t,25*alpha,255,255,255)
						end
						RenderTTF2(ttf,key..': '..tostring(value),l+12+GAP,r+12+GAP,b,t,SIZE,colorw,'left','vcenter')
						count=count+1
					end
				end
            end
        end
        t=t-HEIGHT-GAP
        if t<0 then break end
    end
    t=t-GAP
    RenderCube(l,r,t,t+GAP/2+2)
end

local texture_displayer=TUO_Developer_UI:NewWidgetTemplate('texture_displayer')

local check_boxes=TUO_Developer_UI:NewWidgetTemplate('check_boxes')

local hyperlinks=TUO_Developer_UI:NewWidgetTemplate('hyperlinks')

