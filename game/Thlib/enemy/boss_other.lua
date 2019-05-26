---=====================================
---th style boss
---特效、其他组件
---=====================================

----------------------------------------
---boss move

--随机移动（没有使用）

function boss.MoveTowardsPlayer(t)
    local dirx,diry
    local self=task.GetSelf()
    local p=Player(self)
    if self.x>64 then dirx=-1 elseif self.x<-64 then dirx=1
    else
        --if self.x>lstg.player.x then dirx=-1 else dirx=1 end
        if self.x>p.x then dirx=-1 else dirx=1 end
    end
    if self.y>144 then diry=-1 elseif self.y<128 then diry=1 else diry=ran:Sign() end
    --local dx=max(16,min(abs((self.x-lstg.player.x)*0.3),32))
    local dx=max(16,min(abs((self.x-p.x)*0.3),32))
    task.MoveTo(self.x+ran:Float(dx,dx*2)*dirx,self.y+diry*ran:Float(16,32),t)
end

--boss移动

boss.move={}
function boss.move.New(x,y,t,m)
    local c={}
    c.frame=boss.move.frame
    c.render=boss.move.render
    c.init=boss.move.init
    c.del=boss.move.del
    c.name=''
    c.t1=999999999
    c.t2=999999999
    c.t3=999999999
    c.hp=999999999
    c.is_sc=false
    c.is_extra=false
    c.is_combat=false
    c.is_move=true
    c.x=x c.y=y c.t=t c.m=m
    return c
end
function boss.move:frame() end
function boss.move:render() end
function boss.move:init()
    local c = boss.GetCurrentCard(self)
    task.New(self,function()
        task.MoveTo(c.x,c.y,c.t,c.m)
        Kill(self)
    end)
end
function boss.move:del() end

boss.escape={}--这个和boss.move有什么区别？？？
function boss.escape.New(x,y,t,m)
    local c={}
    c.frame=boss.escape.frame
    c.render=boss.escape.render
    c.init=boss.escape.init
    c.del=boss.escape.del
    c.name=''
    c.t1=999999999
    c.t2=999999999
    c.t3=999999999
    c.hp=999999999
    c.is_sc=false
    c.is_extra=false
    c.is_combat=false
    c.is_escape=true
    c.x=x c.y=y c.t=t c.m=m
    return c
end
function boss.escape:frame() end
function boss.escape:render() end
function boss.escape:init()
    local c = boss.GetCurrentCard(self)
    task.New(self,function()
        task.MoveTo(c.x,c.y,c.t,c.m)
        Kill(self)
    end)
end
function boss.escape:del() end

----------------------------------------
---boss 特效
---一些华丽的效果（

--开卡文字
--！警告：未适配宽屏等非传统版面

spell_card_ef=Class(object)
function spell_card_ef:init()
    self.layer=LAYER_BG+1
    self.group=GROUP_GHOST
    self.alpha=0
    task.New(self,function()
        for i=1,50 do
            task.Wait()
            self.alpha=self.alpha+0.02
        end
        task.Wait(60)
        for i=1,50 do
            task.Wait()
            self.alpha=self.alpha-0.02
        end
        Del(self)
    end)
end
function spell_card_ef:frame()
    task.Do(self)
end
function spell_card_ef:render()
    SetImageState('spell_card_ef','',Color(255*self.alpha,255,255,255))
    for j=1,10 do
        local h=(j-5.5)*32
        for i=-2,2 do
            local l=i*128+((self.timer*2)%128)*(2*(j%2)-1)
            Render('spell_card_ef',l*cos(30),l*sin(30)+h,-60)
        end
    end
end

--蓄力

boss_cast_ef=Class(object)
function boss_cast_ef:init(x,y)
    self.hide=true
    PlaySound('ch00',0.5,0)
    for i=1,50 do
        local angle=ran:Float(0,360)
        local lifetime=ran:Int(50,80)
        local l=ran:Float(300,500)
        New(boss_cast_ef_unit,x+l*cos(angle),y+l*sin(angle),l/lifetime,angle+180,lifetime,ran:Float(2,3))
    end
    Del(self)
end

boss_cast_ef_unit=Class(object)
function boss_cast_ef_unit:init(x,y,v,angle,lifetime,size)
    self.x=x self.y=y self.rot=ran:Float(0,360)
    SetV(self,v,angle)
    self.lifetime=lifetime
    self.omiga=5
    self.layer=LAYER_ENEMY-50
    self.group=GROUP_GHOST
    self.bound=false
    self.img='leaf'
    self.hscale=size
    self.vscale=size
end
function boss_cast_ef_unit:frame()
    if self.timer==self.lifetime then Del(self) end
end
function boss_cast_ef_unit:render()
    if self.timer>self.lifetime-15 then
        SetImageState('leaf','mul+add',Color((self.lifetime-self.timer)*12,255,255,255))
    else
        SetImageState('leaf','mul+add',Color((self.timer/(self.lifetime-15))^6*180,255,255,255))
    end
    DefaultRenderFunc(self)
end

--死亡爆炸

boss_death_ef=Class(object)
function boss_death_ef:init(x,y)
    PlaySound('enep01',0.4,0)
    self.hide=true
    misc.ShakeScreen(30,15)
    for i=1,70 do
        local angle=ran:Float(0,360)
        local lifetime=ran:Int(40,120)
        local l=ran:Float(100,500)
        New(boss_death_ef_unit,x,y,l/lifetime,angle,lifetime,ran:Float(2,4))
    end
    Del(self)--哪个傻吊把这个漏了……
end

boss_death_ef_unit=Class(object)
function boss_death_ef_unit:init(x,y,v,angle,lifetime,size)
    self.x=x self.y=y self.rot=ran:Float(0,360)
    SetV(self,v,angle)
    self.lifetime=lifetime
    self.omiga=3
    self.layer=LAYER_ENEMY+50
    self.group=GROUP_GHOST
    self.bound=false
    self.img='leaf'
    self.hscale=size
    self.vscale=size
end
function boss_death_ef_unit:frame()
    if self.timer==self.lifetime then Del(self) end
end
function boss_death_ef_unit:render()
    if self.timer<15 then
        SetImageState('leaf','mul+add',Color(self.timer*12,255,255,255))
    else
        SetImageState('leaf','mul+add',Color(((self.lifetime-self.timer)/(self.lifetime-15))*180,255,255,255))
    end
    DefaultRenderFunc(self)
end

--非或符结束时弹出的文字

kill_timer=Class(object)
function kill_timer:init(x,y,t)
    self.t=t
    self.x=x
    self.y=y
    self.yy=y
    self.alph=0
end
function kill_timer:frame()
    if self.timer<=30 then self.alph=self.timer/30 self.y=self.yy-30*cos(3*self.timer) end
    if self.timer>120 then self.alph=1-(self.timer-120)/30 end
    if self.timer>=150 then Del(self) end
end
function kill_timer:render()
    SetViewMode'world'
    local alpha=self.alph
    SetFontState('time','',Color(alpha*255,0,0,0))
    RenderText('time',string.format("%.2f", self.t/60)..'s',41,self.y-1,0.5,'centerpoint')
    SetFontState('time','',Color(alpha*255,200,200,200))
    RenderText('time',string.format("%.2f", self.t/60)..'s',40,self.y,0.5,'centerpoint')
    SetImageState('kill_time','',Color(alpha*255,255,255,255))
    Render('kill_time',-40,self.y-2,0.6,0.6)
end

hinter_bonus=Class(object)
function hinter_bonus:init(img,size,x,y,t1,t2,fade,bonus)
    self.img=img
    self.x=x
    self.y=y
    self.t1=t1
    self.t2=t2
    self.fade=fade
    self.group=GROUP_GHOST
    self.layer=LAYER_TOP
    self.size=size
    self.t=0
    self.hscale=self.size
    self.bonus=bonus
end
function hinter_bonus:frame()
    if self.timer<self.t1 then
        self.t=self.timer/self.t1
    elseif self.timer<self.t1+self.t2 then
        self.t=1
    elseif self.timer<self.t1*2+self.t2 then
        self.t=(self.t1*2+self.t2-self.timer)/self.t1
    else
        Del(self)
    end
end
function hinter_bonus:render()
    if self.fade then
        SetImageState(self.img,'',Color(self.t*255,255,255,255))
        self.vscale=self.size
        SetFontState('score3','',Color(self.t*255,255,255,255))
        RenderScore('score3',self.bonus,self.x+1,self.y-41,0.7,'centerpoint')
        object.render(self)
    else
        SetImageState(self.img,'',Color(0xFFFFFFFF))
        self.vscale=self.t*self.size
        SetFontState('score3','',Color(255,255,255,255))
        RenderScore('score3',self.bonus,self.x+1,self.y-41,0.7,'centerpoint')
        object.render(self)
    end
end

----------------------------------------
---杂项

function Render_RIng_4(angle,r,angle_offset,x0,y0,r_,imagename)--未使用
    local A_1 = angle+angle_offset
    local A_2 = angle-angle_offset
    local R_1 = r+r_
    local R_2 = r-r_
    local x1,x2,x3,x4,y1,y2,y3,y4
    x1=x0+(R_1)*cos(A_1)
    y1=y0+(R_1)*sin(A_1)

    x2=x0+(R_1)*cos(A_2)
    y2=y0+(R_1)*sin(A_2)

    x3=x0+(R_2)*cos(A_2)
    y3=y0+(R_2)*sin(A_2)

    x4=x0+(R_2)*cos(A_1)
    y4=y0+(R_2)*sin(A_1)
    Render4V(imagename,x1,y1,0.5,x2,y2,0.5,x3,y3,0.5,x4,y4,0.5)
end

function test_ex(ex)--测试代码，日后要移除
    ex.lifes={300,100,400}
    ex.lifesmax={300,100,700}
    ex.modes={0,1,0}
end
