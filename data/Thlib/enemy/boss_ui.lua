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
end

function boss_ui:frame()
    task.Do(self)
    if self.countdown then
        if self.countdown>5 and self.countdown<=10 and self.countdown%1==0 then PlaySound('timeout',0.6) end
        if self.countdown>0 and self.countdown<=5 and self.countdown%1==0 then PlaySound('timeout2',0.8) Print(self.timer) end
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
    
    SetImageState('base_hp','',Color(alpha1*255,255,0,0))
    SetImageState('hpbar1','',Color(alpha1*255,255,255,255))
    SetImageState('hpbar2','',Color(0,255,255,255))
    SetImageState('life_node','',Color(alpha1*255,255,255,255))
    --血条、boss名、剩余符卡
    if self.boss.ex then
        if self.boss.ex.cardcount and self.drawhp then
            boss_ui.render_hpbar_ex(self)
        end
    end
    --RenderText('bonus',self.ex.status,0,207,0.5,'right')
    if self.is_combat then
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
                            Render('boss_sc_left',-194+j*12,207-i*12-dy1,0,2) --【临时修改】
                        end
                    end
                    for i=1,int(self.sc_left-1-8*m) do
                        Render('boss_sc_left',-194+i*12,207-m*12-dy1,0,2) --【临时修改】
                    end
                end
            end
        end
    end
    --位置指示器
    if self.pointer_x and self.drawpointer then
        SetViewMode'ui'
        Render('boss_pointer',WorldToScreen(max(min(self.pointer_x,lstg.world.r-24),lstg.world.l+24),lstg.world.b))--适配宽屏
        SetViewMode'world'
    end
    --为boss ex时，下方逻辑不执行
    if self.boss.ex then
        if self.boss.ex.status==0 then
            return
        end
    end
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
    if self.boss.sc_bonus then xoffset=max(384-self.boss.timer*7,0) else xoffset=min(384,(self.boss.timer+1)*7) end
    --符卡
    if self.drawspell then
        if self.sc_name~='' then
            SetImageState('boss_spell_name_bg','',Color(alpha*255,255,255,255))
            Render('boss_spell_name_bg',192+xoffset,236-dy2,0,2)  --这里*2了，之后换素材之后要改
            RenderTTF('sc_name',self.sc_name,193+xoffset,193+xoffset,226-dy2,226-dy2,Color(alpha*255,0,0,0),'right','noclip')
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

function boss_ui:render_hpbar()
	local c = boss.GetCurrentCard(self.boss)
    if not(self.boss.time_sc) and self.drawhp then
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
        elseif mode == 0 and type == 1 then
            misc.Renderhpbar(self.boss.x,self.boss.y,90,360,60,64,360,1)
            if self.boss.timer<=60 then misc.Renderhp(self.boss.x,self.boss.y,90,360,60,64,360,self.hpbarlen*min(1,self.boss.timer/60))
			else misc.Renderhp2(self.boss.x,self.boss.y,90,360,60,64,360,self.hpbarlen,c.hplen) end
            Render('base_hp',self.boss.x,self.boss.y,0,0.274*2,0.274*2)
            Render('base_hp',self.boss.x,self.boss.y,0,0.256*2,0.256*2)
            if self.boss.sp_point and #self.boss.sp_point~=0 then
                for i=1,#self.boss.sp_point do
                    Render('life_node',self.boss.x+61*cos(self.boss.sp_point[i]),self.boss.y+61*sin(self.boss.sp_point[i]),self.boss.sp_point[i]-90)
                end
            end
        elseif mode == 0 and type == 2 then
            misc.Renderhpbar(self.boss.x,self.boss.y,90,360,60,64,360,1)
            if self.boss.timer<=60 then misc.Renderhp(self.boss.x,self.boss.y,90,360,60,64,360,self.hpbarlen*min(1,self.boss.timer/60))
			else misc.Renderhp2(self.boss.x,self.boss.y,90,360,60,64,360,self.hpbarlen,c.hplen) end
            Render('base_hp',self.boss.x,self.boss.y,0,0.274*2,0.274*2) -- 渲染时*2修改标记，后同
            Render('base_hp',self.boss.x,self.boss.y,0,0.256*2,0.256*2)
        elseif mode == 2 then
            misc.Renderhpbar(self.boss.x,self.boss.y,90,360,60,64,360,1)
            misc.Renderhp(self.boss.x,self.boss.y,90,self.boss.lifepoint-90,60,64,self.boss.lifepoint-88,self.hpbarlen)
            Render('base_hp',self.boss.x,self.boss.y,0,0.274*2,0.274*2)
            Render('base_hp',self.boss.x,self.boss.y,0,0.256*2,0.256*2)
        elseif mode == 1 then
            misc.Renderhpbar(self.boss.x,self.boss.y,90,360,60,64,360,1)
            if self.boss.timer<=60 then
                misc.Renderhp(self.boss.x,self.boss.y,90,360,60,64,360,self.hpbarlen*min(1,self.boss.timer/60))
            else
                misc.Renderhp(self.boss.x,self.boss.y,90,self.boss.lifepoint-90,60,64,self.boss.lifepoint-88,1)
                misc.Renderhp(self.boss.x,self.boss.y,self.boss.lifepoint,450-self.boss.lifepoint,60,64,450-self.boss.lifepoint,self.hpbarlen)
            end
            Render('base_hp',self.boss.x,self.boss.y,0,0.274*2,0.274*2)
            Render('base_hp',self.boss.x,self.boss.y,0,0.256*2,0.256*2)
            Render('life_node',self.boss.x+61*cos(self.boss.lifepoint),self.boss.y+61*sin(self.boss.lifepoint),self.boss.lifepoint-90,0.55)
            SetFontState('bonus','',Color(255,255,255,255))
        end
        if self.boss.show_hp then
        SetFontState('bonus','',Color(255,0,0,0))
        RenderText('bonus',int(max(0,self.boss.hp))..'/'..self.boss.maxhp,self.boss.x-1,self.boss.y-40-1,0.6,'centerpoint')
        SetFontState('bonus','',Color(255,255,255,255))
        RenderText('bonus',int(max(0,self.boss.hp))..'/'..self.boss.maxhp,self.boss.x,self.boss.y-40,0.6,'centerpoint')
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
    SetImageState('hpbar1','',Color(alpha1*255,255,100,100))
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
