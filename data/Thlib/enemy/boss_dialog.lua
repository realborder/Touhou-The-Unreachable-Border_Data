--======================================
--th style boss dialog
--======================================

----------------------------------------
--boss dialog
--！警告：未适配多玩家，一部分逻辑代码从编辑器中生成，需要相应去修改编辑器
--#待改进：_dialog_can_skip不应该使用全局变量，其逻辑代码从编辑器中生成，需要相应去修改编辑器

boss.dialog={}

function boss.dialog.New(can_skip)
    local c={}
    c.frame=boss.dialog.frame
    c.render=boss.dialog.render
    c.init=boss.dialog.init
    c.del=boss.dialog.del
    c.name=''
    c.t1=999999999
    c.t2=999999999
    c.t3=999999999
    c.hp=999999999
    c.is_sc=false
    c.is_extra=false
    c.is_combat=false
    _dialog_can_skip=can_skip--怎么是全局变量？？？
    return c
end
function boss.dialog:frame()
    if self.task and coroutine.status(self.task[1])=='dead' then Kill(self) end
end
function boss.dialog:render() end
function boss.dialog:init()
    lstg.player.dialog=true
    self.dialog_displayer=New(dialog_displayer)
end
function boss.dialog:del()
    lstg.player.dialog=false
    Del(self.dialog_displayer)
    self.dialog_displayer=nil
end

----------------------------------------
--boss dialog sentence
--！警告：输入未适配jstg，会造成rep出错
--！警告：未适配宽屏等非传统版面

function boss.dialog:sentence(img,pos,text,t,hscale,vscale)
    if pos=='left' then pos=1 else pos=-1 end
    self.dialog_displayer.text=text
    self.dialog_displayer.char[pos]=img
    if self.dialog_displayer.active~=pos then
        self.dialog_displayer.active=pos
        self.dialog_displayer.t=16
    end
    self.dialog_displayer._hscale[pos]=hscale or pos
    self.dialog_displayer._vscale[pos]=vscale or 1
    task.Wait()
    t=t or (60+#text*5)
    for i=1,t do
        if (KeyIsPressed'shoot' or self.dialog_displayer.jump_dialog>60) and _dialog_can_skip then
            PlaySound('plst00',0.35,0,true)
            break
        end
        task.Wait()
    end
    task.Wait(2)
end

dialog_displayer=Class(object)
function dialog_displayer:init()
    self.layer=LAYER_TOP
    self.char={}
    self._hscale={}
    self._vscale={}
    self.t=16
    self.death=0
    self.co=0
    self.jump_dialog=0
end
function dialog_displayer:frame()
    task.Do(self)
    if self.t>0 then self.t=self.t-1 end
    if self.active then
    self.co=max(min(60,self.co+1.5*self.active),-60)
    end
    if player.dialog==true and self.active then
        if KeyIsDown'shoot' then self.jump_dialog=self.jump_dialog+1 else self.jump_dialog=0 end
    end
end
function dialog_displayer:render()
    if self.active then
        SetViewMode'ui'
            if self.char[-self.active] then
                SetImageState(self.char[-self.active],'',Color(0xFF404040)+(  self.t/16)*Color(0xFFC0C0C0)-(self.death/30)*Color(0xFF000000))
                local t=(1-self.t/16)^3
                Render(self.char[-self.active],224+self.active*(-(1-2*t)*16+128)+self.death*self.active*12,240-65-t*16-25,0,self._hscale[-self.active],self._vscale[-self.active])
            end
            if self.char[self.active] then
                SetImageState(self.char[ self.active],'',Color(0xFF404040)+(1-self.t/16)*Color(0xFFC0C0C0)-(self.death/30)*Color(0xFF000000))
                local t=(  self.t/16)^3
                Render(self.char[ self.active],224+self.active*( (1-2*t)*16-128)-self.death*self.active*12,240-65-t*16-25,0,self._hscale[self.active],self._vscale[self.active])
            end
        SetViewMode'world'
    end
    if self.text and self.active then
        local kx,ky1,ky2,dx,dy1,dy2
            kx=168
            ky1=-210
            ky2=-90
            dx=160
            dy1=-144*1.3
            dy2=-126*1.3
            SetImageState('dialog_box','',Color(225,195-self.co,150,195+self.co))
            Render('dialog_box',0,-144*1.3-self.death*8*1.3,0,2.0)
            RenderTTF('dialog',self.text,-dx,dx,dy1-self.death*8,dy2-self.death*8,Color(0xFF000000),'paragraph')
            if self.active>0 then
                RenderTTF('dialog',self.text,-dx,dx,dy1-self.death*8,dy2-self.death*8,Color(255,255,200,200),'paragraph')
            else
                RenderTTF('dialog',self.text,-dx,dx,dy1-self.death*8,dy2-self.death*8,Color(255,200,200,255),'paragraph')
            end
    end
end
function dialog_displayer:del()
    PreserveObject(self)
    task.New(self,function()
        for i=1,30 do
            self.death=i
            task.Wait()
        end
        RawDel(self)
    end)
end
