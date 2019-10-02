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
        if length>512 then 
            table.insert(widget.display_value,{name='!!!',v=' Reached Table Print Limit',index=0}) return false end
        if type(_v)=='table' then 
            local head=''
            for i=0,level-1 do head=head..'    ' end
            if level>0 then head=head..'   +' end
            table.insert(widget.display_value,{name=head.._k,v=_v})
            -- table.insert(widget.display_value,{name=head.._k,v=_v,index=index..tostring(_v)})
            local flag=DeserializeTable(widget,_v,nil,level+1,index..tostring(_v))
            -- if not flag then return false end
        else 
            local head=''
            for i=0,level do head=head..'    ' end
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
local expl = function(vstart,vend,t)  return vstart+(vend-vstart)*sin(90*t) end

------------------------------
---更快捷的方块渲染
local RenderCube= function(l,r,b,t,ca,cr,cg,cb) 
    if ca and cr and cg and cb then
        SetImageState('white','',Color(ca,cr,cg,cb)) end
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

---@type TemplateWidget table
TUO_Developer_HUD.TemplateWidget={
    -- 所有控件通用参数：
        ---title string 标题，这会让这个控件跟上面的控件隔开相当的距离并含有一个标题
    ['_GENERAL']={
        initfunc=function(self)
            --鼠标是否停留
            self._mouse_stay=false
            --点燃计时器，鼠标停留在控件上就会使其处于点燃状态
            self._ignite_timer=0
            self._pressed=false
            self._pressed_timer=0
            ---标题，false和nil为不显示标题
            ---如果从外部输入标题那么就没事了
            self.title=nil
            self.timer=0
            --控件的碰撞箱，因为各个控件都不一样，所以这里只设置初始值，具体值放在具体控件那边
            -- 因为沿用上一个控件的y的操作是在render函数里进行的，懒得再整理了，那么hitbox的设置就全部放那儿吧
            -- （虽说那个理应放在帧函数来着，但我实在不想加参数了，看着眼花）
            -- self.hitbox={l,r,b,t}
            self.hitbox=nil
        end,
        framefunc=function(self) 
            self.timer = self.timer+1
            if self._mouse_stay then
                self._ignite_timer=min(1,self._ignite_timer+0.2)
            else
                self._ignite_timer=max(0,self._ignite_timer-0.2)
            end
            if self._pressed then
                self._pressed_timer=min(1,self._pressed_timer+0.2)
            else
                self._pressed_timer=max(0,self._pressed_timer-0.2)
            end
            if self.hitbox then 
                local flag = HitboxCheck(self)
                --鼠标划入事件
                if flag and (not self._mouse_stay) and self._event_mousedrop then self._event_mousedrop(self) end
                --鼠标离开事件
                if (not flag) and self._mouse_stay and self._event_mouseleave then self._event_mouseleave(self) end
                self._mouse_stay=flag
                
                --鼠标停留的时候鼠标被按下
                if self._mouse_stay and MouseTrigger(0) then 
                    --如果panel上其他控件没有焦点那么焦点会到自己身上
                    -- if type(self.panel.focusedWidget)==nil then 
                        -- self.panel.focusedWidget=self._index
                        self._pressed=true
                        if self._event_mousepress then self._event_mousepress(self) end
                    -- 如果焦点正好在自己身上，嗯……怎么可能啊
                    -- elseif self.panel.focusedWidget==self._index then
                    -- else -- 如果焦点在别人身上那没事了
                    -- end
                -- 鼠标停留的时候鼠标被抬起，同时自身已经被按下
                elseif self._mouse_stay and self._pressed and MouseIsReleased(0) then
                    self._pressed=false
                    -- self.panel.focusedWidget=nil
                    if self._event_mouseclick then self._event_mouseclick(self) end
                elseif (not self._mouse_stay) and self._pressed then
                    self._pressed=false
                    -- self.panel.focusedWidget=nil
                end
            end
        end,
        renderfunc=function(self)
            --这里主要是对标题的处理
            if not self.title then return end
            local title=self.title
            --panel
            local panel=self.panel
            ---排版
            local TOP_OFFSET=16
            local HEIGHT=16
            local SIZE=1
            local GAP=2
            local x_pos=self._x_pos

            ---lrbt初始值
            local l=expl(x_pos+36,x_pos,panel.timer/10)
            local r=l+640
            local t=480-TOP_OFFSET+panel.y_offset 
            local b
            ---slot2锁定位置不滚动
            if self._position_lock then t=480-TOP_OFFSET end
            ---沿用上一个控件的y
            if panel.__DH_last_top~=0 and panel.__DH_last_x_pos==x_pos then
                t=panel.__DH_last_top-HEIGHT*2 
            end
            
            b=t-HEIGHT*1.5

            local ttf=self.ttf
            
            local color=Color(panel.timer/10*255,0,0,0)
            RenderTTF2(ttf,title,l,r,t-HEIGHT*1.5,t,SIZE*1.2,color,'left','top')
            t=t-HEIGHT*1.5-GAP

            local y_c=t
            local y_h=sin(panel.timer/10*90)
            local wr=expl(l,l+160,panel.timer/10)
            RenderCube(l,wr,y_c-y_h,y_c+y_h,255,16,16,16)
            -- SetImageState('white','',Color(0xFF101010))
            -- RenderRect('white',l,wr,y_c-y_h,y_c+y_h)
            panel.__DH_last_top=t 
            panel.__DH_last_x_pos=x_pos
        end
    },
    -- 变量监测控件，
        -- 主要参数为：
        ---monitoring_value 可以是string table funciton 所有可能的用法：
            ---monitoring_value=funciton(self) local t={} <一些操作> return t end
            ---monitoring_value='lstg.var'
            ---monitoring_value=lstg
            ---monitoring_value={'lstg.var','lstg.tmpvar'}

    ['value_displayer']={
        initfunc=function(self)
            self.monitoring_value=nil
            self.display_value={}
            self.value_pre={}
            self.value_change={}
        end,
        framefunc=function(self)
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
        end,
        renderfunc=function(self)
            if not self.display_value then return end

            --panel
            local panel=self.panel
            ---排版
            local TOP_OFFSET=16
            local HEIGHT=16
            local SIZE=1
            local GAP=2
            local x_pos=self._x_pos

            ---lrbt初始值
            local l=expl(x_pos+36,x_pos,panel.timer/10)
            local r=l+640
            local t=480-TOP_OFFSET+panel.y_offset 
            local b
            ---slot2锁定位置不滚动
            if self._position_lock then t=480-TOP_OFFSET end
            ---沿用上一个控件的y
            if panel.__DH_last_top~=0 and panel.__DH_last_x_pos==x_pos then
                t=panel.__DH_last_top-GAP 
            end
            
            local ttf=self.ttf
            
            if not self.value_pre then  self.value_pre={} end
            --这个表用来记录变量做出改变的红色高亮视觉提示，范围0~1,1为红色
            if not self.value_change then  self.value_change={} end
            --缩写下
            local pre=self.value_pre
            local change=self.value_change

            for _,v in pairs(self.display_value) do  
                local index=v.index or v.name
                change[index]=change[index] or 0
                -----------------------变量有变化则让这个变成1
                if v.v~=pre[index] then change[index]=1 else change[index]=max(0,change[index]-0.02) end
                pre[index]=v.v
                local color=Color(panel.timer/10*255,255*change[index],50*change[index],50*change[index])
                -----------------------
                b=t-HEIGHT
                RenderTTF2(ttf,v.name..': '..tostring(v.v),l,r,b,t,SIZE,color,'left','top')
                t=t-HEIGHT-GAP
            end

            panel.__DH_last_top=t 
            panel.__DH_last_x_pos=x_pos
        end
    },
    -- 条状变量监测控件
        -- 主要参数为：
        -- monitoring_value string 必须可以索引至number
        -- max_value number
        -- min_value number
    ['value_gauge']={
        initfunc=function(self)
            self.l=160
            self.w=3
            self.pos=0
            self.pos_aim=0
            self.monitoring_value=nil
            self.min_value=0
            self.max_value=100
            self.deviated=false
            self.value_pre=0
            self.changetimer=0
        end,
        framefunc=function(self)
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
        end,
        renderfunc=function(self)
            --panel
            local panel=self.panel
            ---排版
            local BORDER_WIDTH=2
            local TOP_OFFSET=16
            local HEIGHT=self.w+BORDER_WIDTH*2
            local GAP=3
            local x_pos=self._x_pos
            

            ---lrbt初始值
            local l=expl(x_pos+36,x_pos,panel.timer/10)
            local r=l+self.l*panel.timer/10
            local m=l+self.pos
            local t=480-TOP_OFFSET+panel.y_offset 
            ---slot2锁定位置不滚动
            if self._position_lock then t=480-TOP_OFFSET end
            ---沿用上一个控件的y
            if panel.__DH_last_top~=0 and panel.__DH_last_x_pos==x_pos then
                t=panel.__DH_last_top-GAP 
            end
            local b=t-HEIGHT
            local yc=(t+b)/2
            local h=self.w/2
            local ttf=self.ttf
            SetImageState('white','',Color(255*panel.timer/10,20,20,20))
            RenderRect('white',l,r,b,t)
            if l+BORDER_WIDTH<r-BORDER_WIDTH then
                SetImageState('white','',Color(255*panel.timer/10,255,255,255))
                RenderRect('white',l+BORDER_WIDTH,r-BORDER_WIDTH,b+BORDER_WIDTH,t-BORDER_WIDTH)
            end
            SetImageState('white','',Color(255*panel.timer/10,20+210*self.changetimer,20,20))
            RenderRect('white',l,m,yc-h,yc+h)
            t=t-HEIGHT

            panel.__DH_last_top=t 
            panel.__DH_last_x_pos=x_pos        
        end
    },
    -- 滑块条，可以监测并改变某个变量 必须是number
        -- 主要参数为：
        -- monitoring_value string 必须可以索引至number
        -- max_value number
        -- min_value number
    ['value_slider']={
        initfunc=function(self)
            self.l=160
            self.w=4
            self.pos=0
            self.pos_aim=0
            self.monitoring_value=nil
            self.min_value=0
            self.max_value=100
            self.deviated=false
            self.value_pre=0
            self.changetimer=0
        end,
        framefunc=function(self)
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
        end,
        renderfunc=function(self)
            --panel
            local panel=self.panel
            ---排版
            local BORDER_WIDTH=2
            local TOP_OFFSET=16
            local HEIGHT=self.w+BORDER_WIDTH*2
            local GAP=4
            local x_pos=self._x_pos
            

            ---lrbt初始值
            local l=expl(x_pos+36,x_pos,panel.timer/10)
            local r=l+self.l*panel.timer/10+BORDER_WIDTH*2
            local m=l+self.pos+BORDER_WIDTH
            local t=480-TOP_OFFSET+panel.y_offset 
            ---slot2锁定位置不滚动
            if self._position_lock then t=480-TOP_OFFSET end
            ---沿用上一个控件的y
            if panel.__DH_last_top~=0 and panel.__DH_last_x_pos==x_pos then
                t=panel.__DH_last_top-GAP 
            end
            local b=t-HEIGHT
            local yc=(t+b)/2
            local h=self.w/2
            local ttf=self.ttf
            SetImageState('white','',Color(255*panel.timer/10,20,20,20))
            RenderRect('white',l,r,b,t)
            if l+BORDER_WIDTH<r-BORDER_WIDTH then
                SetImageState('white','',Color(255*panel.timer/10,255,255,255))
                RenderRect('white',l+BORDER_WIDTH,r-BORDER_WIDTH,b+BORDER_WIDTH,t-BORDER_WIDTH)
            end
            SetImageState('white','',Color(255*panel.timer/10,20+210*self.changetimer,20,20))
            RenderRect('white',l+BORDER_WIDTH,m,yc-h,yc+h)
            if self._mouse_stay and (not self._pressed) then 
                SetImageState('white','',Color(255*panel.timer/10,50+205*self.changetimer,50,50))
                h=h*3
            elseif self._pressed then
                SetImageState('white','',Color(255*panel.timer/10,150+105*self.changetimer,150,150))
                local mx=MouseState.x_in_UI
                local k=(mx-(l+BORDER_WIDTH))/(r-l-2*BORDER_WIDTH)
                local v=(self.max_value-self.min_value)*k+self.min_value
                v=min(self.max_value,max(self.min_value,v))
                IndexValueByString(self.monitoring_value,v)
                h=h*2.5
            end
            RenderRect('white',m-1,m+1,yc-h,yc+h)
            self.hitbox={l=l,r=r,b=b,t=t}
            t=t-HEIGHT
            panel.__DH_last_top=t 
            panel.__DH_last_x_pos=x_pos        
        end,
        _event_change=function(self,value)
        end
    },
    -- 按钮
        -- 主要参数为：
        --  width number
        --  height number
        -- x_pos2 number 如果指定可以同行
    ['button']={
        initfunc=function(self)
            self.text='Button'
            self.enable=true
            ---排版
            self.width=120
            self.height=24
            self.gap=4
            self.size=0.8
            --为了同排多个按钮
            self.x_pos2=0
        end,
        framefunc=function(self)
            
            
        end,
        renderfunc=function(self)
            
            local panel=self.panel
            --排版
            local TOP_OFFSET=16
            local WIDTH=self.width
            local HEIGHT=self.height
            local SIZE=self.size
            local GAP=self.gap
            local x_pos=self._x_pos+self.x_pos2
            ---lrbt初始值
            local l=expl(x_pos+36,x_pos,panel.timer/10)
            local r=l+WIDTH
            local t=480-TOP_OFFSET+panel.y_offset 
            local b
            ---slot2锁定位置不滚动
            if self._position_lock then t=480-TOP_OFFSET end
            ---沿用上一个控件的y
            if panel.__DH_last_top~=0 and panel.__DH_last_x_pos==self._x_pos then
                if self.x_pos2~=0 then
                    t=panel.__DH_last_top+GAP+HEIGHT
                else
                    t=panel.__DH_last_top-GAP 
                end
            end
            b=t-HEIGHT
            self.hitbox={l=l,r=r,b=b,t=t}
            t=t-HEIGHT-GAP
            panel.__DH_last_top=t
            panel.__DH_last_x_pos=self._x_pos
            
            local l=self.hitbox.l
            local r=self.hitbox.r
            local b=self.hitbox.b
            local t=self.hitbox.t
            local ttf=self.ttf
            local k=0.15*self._ignite_timer+0.85*self._pressed_timer
            local BORDER_WIDTH=min(abs(r-l),abs(t-b))/2*panel.timer/10*k
            local bd=BORDER_WIDTH
            for i=1,3 do
                RenderCube(l-i,r+i,b-i,t+i,i/5*15*panel.timer/10,10,10,10)
            end
            RenderCube(l,r,b,t,255*panel.timer/10,30,30,30)
            RenderCube(l+bd,r-bd,b+bd,t-bd,255*panel.timer/10,255,255,255)
            if self.text then
                local c=255*(max(0.5,k)-0.5)*2
                RenderTTF2(ttf,self.text,l,r,b-4,t-4,self.size,Color(255*panel.timer/10,c,c,c),'venter','center')
            end

        end,
    },
    -- 文本框，只能显示固定的文本
        -- 主要参数为：
        --  text string 要显示的文本
    ['text_displayer']={
        initfunc=function(self)
            self.text='text_displayer'
            self.text_rgb={0,0,0}
        end,
        framefunc=function(self)
        end,
        renderfunc=function(self)

            --panel
            local panel=self.panel
            ---排版
            local TOP_OFFSET=16
            local HEIGHT=16
            local SIZE=1
            local GAP=2
            local x_pos=self._x_pos

            ---lrbt初始值
            local l=expl(x_pos+36,x_pos,panel.timer/10)
            local r=l+640
            local t=480-TOP_OFFSET+panel.y_offset 
            local b
            ---slot2锁定位置不滚动
            if self._position_lock then t=480-TOP_OFFSET end
            ---沿用上一个控件的y
            if panel.__DH_last_top~=0 and panel.__DH_last_x_pos==x_pos then
                t=panel.__DH_last_top-GAP 
            end
            
            local ttf=self.ttf
            local color=Color(255*panel.timer/10,self.text_rgb[1],self.text_rgb[2],self.text_rgb[3])
            b=t-HEIGHT
            RenderTTF2(ttf,self.text,l,r,b,t,SIZE,color,'left','top')
            t=t-HEIGHT-GAP

            panel.__DH_last_top=t 
            panel.__DH_last_x_pos=x_pos
        end
    },
    -- 列表框，监视或存放一列值，可以对其中的内容进行删改
        ---魔改自 value_displayer
        -- 主要参数为：
        -- monitoring_value 与value_displayer的逻辑一样
        -- keep_refresh boolean 是否持续根据被监测变量刷新列表
        -- width number
        -- refreshfunc function 如果没有 monitoring_value 则会尝试调用这个函数
    ['list_box']={
        initfunc=function(self)
            self.keep_refresh=true
            self.cur=1
            self.monitoring_value=nil
            self.display_value={}
            self.selection={}
            self.select_timer={}
            self.width=480
        end,
        framefunc=function(self)
            for i,v in pairs(self.display_value) do
                self.select_timer[i]=self.select_timer[i] or 0
                if self.selection[i] then 
                    self.select_timer[i]=min(1,self.select_timer[i]+0.1)
                else
                    self.select_timer[i]=max(0,self.select_timer[i]-0.05)
                end
            end
        
            if (not self.keep_refresh) then return end
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
                else self.display_value={'* List is empty'}
                end
            elseif self.refreshfunc then self.refreshfunc() end
            --对display_value进行排序
            if self.display_value and type(self.display_value[1].name)=='string' then 
                -- local tmp=self.display_value
                -- self.display_value={}
                -- for k,_ in pairs(tmp) do
                --     table.insert(self.display_value,k)
                -- end
                table.sort(self.display_value,function(v1,v2)  return v1.name<v2.name end)
            end
        end,
        renderfunc=function(self)
            if not self.display_value then return end

            --panel
            local panel=self.panel
            ---排版
            local TOP_OFFSET=16
            local HEIGHT=16
            local SIZE=1
            local GAP=2
            local x_pos=self._x_pos

            ---lrbt初始值
            local l=expl(x_pos+36,x_pos,panel.timer/10)
            local r=l+self.width
            local t=480-TOP_OFFSET+panel.y_offset 
            local t_orig=t
            local b
            ---slot2锁定位置不滚动
            if self._position_lock then t=480-TOP_OFFSET end
            ---沿用上一个控件的y
            if panel.__DH_last_top~=0 and panel.__DH_last_x_pos==x_pos then
                t=panel.__DH_last_top-GAP 
            end
            
            local ttf=self.ttf
            SetImageState('white','',Color(255*panel.timer/10,30,30,30))
            RenderRect('white',l,r,t-2-GAP/2,t)
            t=t-2-GAP

            for i,v in pairs(self.display_value) do  
                local color=Color(panel.timer/10*255,0,0,0)
                -----------------------
                b=t-HEIGHT
                ------把点选逻辑写在render里的云绝是屑
                local flag=HitboxCheck({hitbox={l=l,r=r,b=b,t=t}})
                local mul=lstg.GetKeyState(KEY.CTRL)
                -- if not mul then self.selection={} end
                if MouseTrigger(0) and flag then
                    if mul then
                        local ori=self.selection[i] or false
                        self.selection[i]=not ori 
                    else
                        self.selection={}
                        self.selection[i]=true
                    end
                end
                --如果选中就对边框加粗
                local border=2 if (not self._pressed) and flag then border=4 end
                --选择高亮
                if self.select_timer[i] and self.select_timer[i]>0 then
                    local l,r=l+GAP,r-GAP
                    local m=(l+r)/2
                    local l2=expl(l,m,self.select_timer[i])
                    local r2=expl(r,m,self.select_timer[i])
                    RenderRect('white',l,l2,b-GAP/2,t+GAP/2)
                    RenderRect('white',r2,r,b-GAP/2,t+GAP/2)
                    local c=self.select_timer[i]*255
                    color=Color(panel.timer/10*255,c,c,c)
                end
                RenderRect('white',l,l+border,b-GAP/2,t+GAP/2)
                RenderRect('white',r,r-border,b-GAP/2,t+GAP/2)
                if type(v)~='table' then 
                    RenderTTF2(ttf,tostring(v),l+2+GAP,r+2+GAP,b,t,SIZE,color,'left','top')
                else
                    RenderTTF2(ttf,v.name..': '..tostring(v.v),l+2+GAP,r+2+GAP,b,t,SIZE,color,'left','top')
                end
                t=t-HEIGHT-GAP
            end
            t=t-GAP
            -- SetImageState('white','',Color(255*panel.timer/10,30,30,30))
            RenderRect('white',l,r,t,t+GAP/2+2)
            self.hitbox={l=l,r=r,b=t,t=t_orig}
            panel.__DH_last_top=t 
            panel.__DH_last_x_pos=x_pos
        end,
        _event_mousepress=function(self)
            
        end,
        refreshfunc=function(self) 
            self.display_value={'* List is empty'}
        end,
    },
    -- 输入框
        -- 主要参数为：
        -- text string 输入框的内容
        -- _event_textchange function 文本内容发生变化后调用的函数
    ['inputer']={
        initfunc=function(self)
        end,
        framefunc=function(self)
        end,
        renderfunc=function(self)
        end,
        event_text_change=function(self)
        end
    },
    ['switch']={},
    ['texture_displayer']={
        initfunc=function(self)
        end,
        framefunc=function(self)
        end,
        renderfunc=function(self)
        end
    },
    ['check_boxes']={},
    ['hyperlinks']={}

}


function TUO_Developer_HUD:AddWidgetTemplate(name,initfunc,framefunc,renderfunc)
        self.TemplateWidget[name]={
            initfunc=initfunc,
            framefunc=framefunc,
            renderfunc=renderfunc
        }
end


------------------------------------------------------
---以模板新建控件
---@param panel panel 
---@param x_pos number 可以直接用数值指定，也可以写'slot1'或者'slot2'
---@param template TemplateWidget
---@param para table 必须是一个含有控件所必须的参数的表，注意帧函数和渲染函数的执行顺序是先_GENERAL再执行para里的，再执行模板里的
function TUO_Developer_HUD:NewWidget(panel,x_pos,template,para)
    local tpl_g=self.TemplateWidget['_GENERAL']
    local tpl=self.TemplateWidget[template]
    local x_pos_list={slot1=72,slot2=620}
    local tmp_widget={}
    if not tpl then return error('Template \"'..template..'\" dosen\'t exist!') end
    --把_GENERAL里的东西迁过去
    tpl_g.initfunc(tmp_widget)
    tpl.initfunc(tmp_widget)
    tmp_widget.framefunc=function(s) tpl_g.framefunc(s) tpl.framefunc(s) end
    tmp_widget.renderfunc=function(s) tpl_g.renderfunc(s) tpl.renderfunc(s) end
    tmp_widget._x_pos=x_pos_list[x_pos] or x_pos
    if x_pos=='slot2' then tmp_widget._position_lock=true end
    local tmpfunc
    --迁移参数和函数到控件内部

    for k,v in pairs(para) do
        if k=='framefunc' or k=='renderfunc' then
            local tmpfunc=tpl[k]
            if type(para[k])=='function' then tmpfunc=function(s) tpl_g[k](s) para[k](s) tmpfunc(s)  end end
            tmp_widget[k]=tmpfunc
        elseif k=='initfunc' then
        else
            tmp_widget[k]=v 
        end 
    end
    tmp_widget.panel=panel
    tmp_widget.ttf=self.self.ttf
    tmp_widget._index=#panel.WidgetList+1
    if tmp_widget.initfunc and type(tmp_widget.initfunc)=='function' then tmp_widget.initfunc(tmp_widget) end
    table.insert(panel.WidgetList,tmp_widget)
    return tmp_widget
end

