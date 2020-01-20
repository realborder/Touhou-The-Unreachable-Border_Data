--======================================
--th style boss ui
--======================================

----------------------------------------
--boss ui
--！警告：未适配宽屏等非传统版面

boss_ui=Class(object)

boss_ui.active_count=0--多boss时，boss ui 槽位计数

function boss_ui:init(b)
    self.layer=LAYER_TOP
    self.group=GROUP_GHOST
    self.boss=b
    self.sc_name=''
    self.drawhp=1
    self.drawname=1
    self.drawtime=1
    self.drawspell=1
    self.needposition=1
    self.drawpointer=1
    --b.ex={}
    --test_ex(b.ex)
    if b.class.sc_image then self.sc_image = New(b.class.sc_image) end
    self.hp_bar_timer=0
    self.hp_bar_alpha=0
    --血条被打散的效果列表
    self.hp_break_list={}
    self.hp_break_list_max=10
    self.hp_break_cur=1
    for i=1,self.hp_break_list_max do
        table.insert(self.hp_break_list,{0,0,0})
    end
end

function boss_ui:frame()
    task.Do(self)
    if self.countdown then
        if self.countdown>5 and self.countdown<=10 and self.countdown%1==0 then PlaySound('timeout',0.6) end
        if self.countdown>0 and self.countdown<=5 and self.countdown%1==0 then PlaySound('timeout2',0.8) 
        -- Print(self.timer) 
    end
    end
    if self.drawhp and self.is_combat then
        self.hp_bar_timer=self.hp_bar_timer+(1-self.hp_bar_timer)*0.05
        if self.hp_bar_timer>0.999 then self.hp_bar_timer=1 end
    else
        self.hp_bar_timer=self.hp_bar_timer+(0-self.hp_bar_timer)*0.07
        if self.hp_bar_timer<0.001 then self.hp_bar_timer=0 end
    end
    for i=1,self.hp_break_list_max do
        self.hp_break_list[i][2]=max(0,self.hp_break_list[i][2]-1)
    end
end

function boss_ui:render()
    SetViewMode'world'
    
    local yn=boss_ui.active_count
    local dy1=yn*36
    local dy2=yn*44
    if self.needposition then
    boss_ui.active_count=boss_ui.active_count+1
    end
    local _dy=0
    local alpha1=1-self.boss.hp_flag/30
    self.hp_bar_alpha=alpha1
    SetImageState('base_hp','',Color(alpha1*255,255,0,0))
    SetImageState('hpbar1','',Color(alpha1*255,255,255,255))
    SetImageState('hpbar2','',Color(0,255,255,255))
    SetImageState('life_node','',Color(alpha1*255,255,255,255))
    --血条、boss名、剩余符卡
    -- if self.boss.ex then
    --     if self.boss.ex.cardcount and self.drawhp then
    --         boss_ui.render_hpbar_ex(self)
    --     end
    -- end
    --RenderText('bonus',self.ex.status,0,207,0.5,'right')
    if self.hp_bar_timer>0 then
        if self.hpbarlen or self.boss.ex then
            --boss hpbar
            boss_ui.render_hpbar(self)
            --boss name and cards left
            if self.drawname then
                RenderTTF('boss_name',self.name,-185,-185,222-dy1,222-dy1,Color(0xFF000000),'noclip')
                RenderTTF('boss_name',self.name,-186,-186,223-dy1,223-dy1,Color(0xFF80FF80),'noclip')
                local m = int((self.sc_left-1)/8)
                if m >= 0 then
                    for i=0,m-1 do
                        for j=1,8 do
                            Render('boss_sc_left',-194+j*12,207-i*12-dy1,0,0.5,0.25) 
                        end
                    end
                    for i=1,int(self.sc_left-1-8*m) do
                        Render('boss_sc_left',-194+i*12,207-m*12-dy1,0,0.5,0.25) 
                    end
                end
            end
        end
    end
    --位置指示器
    if self.pointer_x and self.drawpointer then
        SetViewMode'ui'
        local x,y=WorldToUI(max(min(self.pointer_x,lstg.world.r-24),lstg.world.l+24),lstg.world.b)
        Render('boss_pointer',x,y,0,0.5)
        SetViewMode'world'
    end
    --为boss ex时，下方逻辑不执行
    -- if self.boss.ex then
    --     if self.boss.ex.status==0 then
    --         return
    --     end
    -- end
    --透明度和位置处理
    local axy=0
    for _,p in pairs(Players(self)) do
        local ax,ay=0,0
        if IsValid(p) then
            ax=min(max(p.x*0.05,0),0.9)
            ay=min(max((p.y-160)*0.05,0),0.9)
        end
        if ax*ay>axy then axy=ax*ay end
    end
    local alpha=1-axy
    SetFontState('time','',Color(alpha*255,255,255,255))
    local xoffset=384
    if not IsValid(self.boss) then
        Del(self)
        return
    end
    if self.boss.sc_bonus then xoffset=max(384-self.boss.timer*7,0) else xoffset=min(384,(self.boss.timer+1)*7) end
    --符卡
    if self.drawspell then
        if self.sc_name~='' then
            SetImageState('boss_spell_name_bg','',Color(alpha*255,255,255,255))
            Render('boss_spell_name_bg',192+xoffset,236-dy2,0,1)  --这里*2了，之后换素材之后要改
            for r=1,3,0.5 do
                local alpha=0.35
                for a=0,360,30 do
                    RenderTTF('sc_name',self.sc_name,192+xoffset+cos(a)*r,192+xoffset+cos(a)*r,227-dy2+sin(a)*r,227-dy2+sin(a)*r,Color(alpha*255,0,0,0),'right','noclip')
                end

            end
            -- RenderTTF('sc_name',self.sc_name,192+xoffset+2,192+xoffset+2,227-dy2-2,227-dy2-2,Color(alpha*255,10,10,10),'right','noclip')
            RenderTTF('sc_name',self.sc_name,192+xoffset,192+xoffset,227-dy2,227-dy2,Color(alpha*255,255,255,255),'right','noclip')
        end
        if self.boss.sc_bonus and self.sc_hist then
            local b
            if self.boss.sc_bonus>0 then b=string.format('%.0f',self.boss.sc_bonus-self.boss.sc_bonus%10) else b='FAILED ' end
            SetFontState('bonus','',Color(alpha*255,0,0,0))
            RenderText('bonus',b,187+xoffset,207-dy2,0.5*2,'right')
            RenderText('bonus',string.format('%d/%d',self.sc_hist[1],self.sc_hist[2]),97+xoffset,207-dy2,0.5*2,'right')
            RenderText('bonus','HISTORY        BONUS',137+xoffset,207-dy2,0.5*2,'right')
            SetFontState('bonus','',Color(alpha*255,255,255,255))
            RenderText('bonus',b,186+xoffset,208-dy2,0.5*2,'right')
            RenderText('bonus',string.format('%d/%d',self.sc_hist[1],self.sc_hist[2]),96+xoffset,208-dy2,0.5*2,'right')
            RenderText('bonus','HISTORY        BONUS',136+xoffset,208-dy2,0.5*2,'right')
        end
    end
    --非符、符卡时间
    if self.is_combat and self.drawtime then
        local cd=(self.countdown-int(self.countdown))*100
        local yoffset
        if self.boss.sc_bonus then yoffset=max(20-self.boss.timer,0) else yoffset=min(20,(self.boss.timer+1)) end
        if self.countdown>=10.0 then
            SetFontState('time','',Color(alpha1*255,255,255,255))
            RenderText('time',string.format('%d',int(self.countdown)),4,192+yoffset+_dy-dy2,0.5*2,'vcenter','right')
            RenderText('time','.'..string.format('%d%d',min(9,cd/10),min(9,cd%10)),4,189+yoffset+_dy-dy2,0.3*2,'vcenter','left')
        else
            SetFontState('time','',Color(alpha1*255,255,30,30))
            RenderText('time',string.format('0%d',min(99.99,int(self.countdown))),4,192+yoffset+_dy-dy2,0.5*2,'vcenter','right')
            RenderText('time','.'..string.format('%d%d',min(9,cd/10),min(9,cd%10)),4,189+yoffset+_dy-dy2,0.3*2,'vcenter','left')
        end
    end
end

function boss_ui:AddHpBarBreak(dhp)
    if dhp>0 then
        local self=self.ui
        self.hp_break_cur=self.hp_break_cur+1
        if self.hp_break_cur>self.hp_break_list_max then self.hp_break_cur=1 end
        self.hp_break_list[self.hp_break_cur]={dhp/self.boss.maxhp*360,self.hp_break_list_max,self.boss.hp/self.boss.maxhp*360+90}
    end
end


function boss_ui:render_hpbar()
    local c = boss.GetCurrentCard(self.boss)
    local t=self.hp_bar_timer
    if not(self.boss.time_sc) and t>0 then
        local mode, type
        if not(self.hpbarcolor1) and not(self.hpbarcolor2) then
            mode = -1 --无血条（时符等）
        elseif not(self.hpbarcolor2) then
            mode = 0
            type = 1 --全血条（符卡）
        elseif not(self.hpbarcolor1) then
            mode = 0
            type = 2 --全血条（非符）
        elseif self.hpbarcolor1 == self.hpbarcolor2 then
            mode = 2 --组合血条（符卡）
        elseif self.hpbarcolor1 ~= self.hpbarcolor2 then
            mode = 1 --组合血条（非符）
        end
        if mode == -1 then
        elseif mode == 0 and (type == 1 or type==2) then
            -- misc.Renderhpbar(self.boss.x,self.boss.y,90,360,60,64,360,1)
            local k=(1+0.5*(1-t))
            local r=64*k
            local dr=min(1,self.boss.timer/60)*4*t
            SetImageState('base_hp','',Color(255*t*self.hp_bar_alpha,255,255,255))
            Render('base_hp',self.boss.x,self.boss.y,0,0.548*k,0.548*k)
            misc.Renderhp2(self.boss.x,self.boss.y,90,360,r-dr,r,360,self.hpbarlen,c.hplen) 
            SetImageState('base_hp2','',Color(255*t*self.hp_bar_alpha,255,255,255))
            Render('base_hp2',self.boss.x,self.boss.y,0,0.548*k,0.548*k)
            local list=self.hp_break_list
            for i=1,self.hp_break_list_max do
                if list[i][2]>0 then
                    local t=sin(90*list[i][2]/10)
                    local w=list[i][1]
                    local a=list[i][3]
                    if w+a>90+360 then w=90+360-a end
                    SetImageState('hpbar4','',Color(255*t,255,255*t^3,255*t^3))
                    -- SetImageState('hpbar4','',Color(255*t,255,0,0))
                    local k=1-t^4
                    sp.misc.RenderFanShape('hpbar4',self.boss.x,self.boss.y,a,a+w,r+10*k,r-dr)
                end

            end

            if self.boss.sp_point and #self.boss.sp_point~=0 then
                for i=1,#self.boss.sp_point do
                    Render('life_node',self.boss.x+61*cos(self.boss.sp_point[i]),self.boss.y+61*sin(self.boss.sp_point[i]),self.boss.sp_point[i]-90,0.5)
                end
            end
        elseif mode == 2 then
            misc.Renderhpbar(self.boss.x,self.boss.y,90,360,60,64,360,1)
            misc.Renderhp(self.boss.x,self.boss.y,90,self.boss.lifepoint-90,60,64,self.boss.lifepoint-88,self.hpbarlen)
            Render('base_hp',self.boss.x,self.boss.y,0,0.548,0.548)
            Render('base_hp',self.boss.x,self.boss.y,0,0.512,0.512)
        elseif mode == 1 then
            misc.Renderhpbar(self.boss.x,self.boss.y,90,360,60,64,360,1)
            if self.boss.timer<=60 then
                misc.Renderhp(self.boss.x,self.boss.y,90,360,60,64,360,self.hpbarlen*min(1,self.boss.timer/60))
            else
                misc.Renderhp(self.boss.x,self.boss.y,90,self.boss.lifepoint-90,60,64,self.boss.lifepoint-88,1)
                misc.Renderhp(self.boss.x,self.boss.y,self.boss.lifepoint,450-self.boss.lifepoint,60,64,450-self.boss.lifepoint,self.hpbarlen,c.hplen)
            end
            Render('base_hp',self.boss.x,self.boss.y,0,0.548,0.548)
            Render('base_hp',self.boss.x,self.boss.y,0,0.512,0.512)
            Render('life_node',self.boss.x+61*cos(self.boss.lifepoint),self.boss.y+61*sin(self.boss.lifepoint),self.boss.lifepoint-90,0.55)
            SetFontState('bonus','',Color(255,255,255,255))
        end
        if self.boss.show_hp then
            SetFontState('bonus','',Color(215,175,20,20))
            for a=0,330,30 do
                RenderText('bonus',int(max(0,self.boss.hp))..'/'..self.boss.maxhp,self.boss.x-cos(a),self.boss.y-40-sin(a),1,'centerpoint')
            end
            SetFontState('bonus','',Color(255,255,255,255))
            RenderText('bonus',int(max(0,self.boss.hp))..'/'..self.boss.maxhp,self.boss.x,self.boss.y-40,1,'centerpoint')
            RenderText('bonus',self.hp_bar_timer,self.boss.x,self.boss.y+40,1,'centerpoint')
            RenderText('bonus',tostring(self.is_combat),self.boss.x,self.boss.y+50,1,'centerpoint')
        end
    end
end

function boss_ui:render_hpbar_ex()
    SetViewMode'world'
    
    local alpha1=1-self.boss.hp_flag/30
    
    local ex=self.boss.ex
    if ex==nil then return end
    local lifes=ex.lifes
    local lifesmax=ex.lifesmax
    local modes=ex.modes
    local rate=min(1,self.boss.ex.timer/60)
    
    SetImageState('base_hp','',Color(alpha1*255,255,0,0))
    SetImageState('hpbar1','',Color(alpha1*255,155,0,0))
    SetImageState('hpbar2','',Color(alpha1*255,255,255,255))
    SetImageState('life_node','',Color(alpha1*255,255,255,255))
    local maxlife=0
    local life=0
    for i, z in ipairs(lifesmax) do
        maxlife=maxlife+z
    end
    for i, z in ipairs(lifes) do
        life=life+z
    end
    life=min(maxlife*rate,life)
    
    local start=90
    local startlife=0
    local stop=90
    
    local ddy=0
    --RenderText('bonus',ex.cardcount,0,0,0.5,'right')
    
    for i, z in ipairs(lifesmax) do
        stop=90+360*(startlife+z)/maxlife
        if life>startlife then    
            local d=life-startlife
            local r=min(d/z,1)
            
            --RenderText('bonus',d,187,207-ddy,0.5,'right')
            --RenderText('bonus',z,187,207-ddy-20,0.5,'right')
            --ddy=ddy+50
            
             if modes[i]==0 then
                 misc.Renderhpbar(self.boss.x,self.boss.y,start,stop-start,60,64,int(stop-start),r)
             else
                 misc.Renderhp(self.boss.x,self.boss.y,start,stop-start,60,64,int(stop-start),r)
             end
            --misc.Renderhpbar(self.boss.x,self.boss.y,90,360,60,64,360,1)
            --misc.Renderhp(self.boss.x,self.boss.y,90,360,60,64,360,1)
            Render('life_node',self.boss.x+61*cos(stop),self.boss.y+61*sin(stop),stop-90,0.55)
        end
        startlife=startlife+z
        start=stop
    end
    Render('base_hp',self.boss.x,self.boss.y,0,0.274,0.274)
    Render('base_hp',self.boss.x,self.boss.y,0,0.256,0.256)
    start=90
    startlife=0
    stop=90
    
    for i, z in ipairs(lifesmax) do
        stop=90+360*(startlife+z)/maxlife
        Render('life_node',self.boss.x+61*cos(stop),self.boss.y+61*sin(stop),stop-90,0.55)
        startlife=startlife+z
        start=stop
    end
end

function boss_ui:kill()--kill and del function
    Del(self.sc_image)
    boss_ui.active_count=boss_ui.active_count-1
end boss_ui.del=boss_ui.kill

function boss:SetUIDisplay(hp,name,cd,spell,pos,pointer)
    self.ui.drawhp=hp
    self.ui.drawname=name
    self.ui.drawtime=cd
    self.ui.drawspell=spell
    self.ui.needposition=pos
    self.ui.drawpointer=pointer or 1
end
