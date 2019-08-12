---=====================================
---东方梦无垠自机系列
---灵梦机体
---Author:Xiliusha
---Email:Xiliusha@outlook.com
---=====================================

local path="mwy_player/"
local texname="_reimu_texture"
local collibox_scale=1.0--碰撞盒缩放，因为碰撞盒缩放和图片精灵渲染缩放分离了，所以不需要调整

----------------------------------------
---res & player class

reimu_player={}

function reimu_player.load_res(self)
	LoadTexture(texname,path.."reimu.png",false)
	
	LoadImageGroup("_reimu_ani", texname,0, 1152, 64, 96, 12, 3)
	self.imgs={}
	for i=1,36 do
		self.imgs[i]="_reimu_ani"..i
	end
	
	LoadImage("_reimu_main_shoot",texname,128,0,128,64,16*collibox_scale,16*collibox_scale)
	SetImageCenter("_reimu_main_shoot", 96,32)
	SetImageState('_reimu_main_shoot',"",Color(0xA0FFFFFF))
	
	LoadAnimation("_reimu_main_shoot_ef",texname,256,0,64,64,2,2,4)
	SetAnimationState("_reimu_main_shoot_ef","mul+add",Color(0xA0FFFFFF))
end

function reimu_player.load_res_A(self)
	reimu_player.load_res(self)
	
	LoadImage("_reimu_high_shoot",texname,384,0,64,64,16*collibox_scale,16*collibox_scale)
	SetImageState("_reimu_high_shoot","",Color(0x80FFFFFF))
	
	LoadAnimation("_reimu_high_shoot_ef",texname,448,0,64,64,2,2,4)
	SetAnimationState("_reimu_high_shoot_ef","mul+add",Color(0x80FFFFFF))
	
	LoadImage("_reimu_slow_shoot",texname,128,64,128,64,32*collibox_scale,8*collibox_scale)
	SetImageState("_reimu_slow_shoot","",Color(0x80FFFFFF))
	SetImageCenter("_reimu_slow_shoot",64,32)
	
	LoadImage("_reimu_slow_shoot_ef",texname,128,64,128,64)
	SetImageState("_reimu_slow_shoot_ef","mul+add",Color(0x80FFFFFF))
	
	LoadImage("_reimu_support_1",texname,0,0,64,64)
	LoadImage("_reimu_support_2",texname,64,0,64,64)
	
	--[[
	LoadImage('reimu_orb_T','reimu_bullet',512,256,128,128,32,32)
	LoadImageGroup('reimu_orb_T','reimu_bullet',832,128,192,128,1,4)
	for i=1,4 do SetImageCenter('reimu_orb_T'..i,128,64) SetImageState('reimu_orb_T'..i,'',Color(255,255,255,255)) end
	LoadImage('reimu_orb_M','reimu_bullet',512,384,256,256,64,64)
	LoadImageGroup('reimu_orb_M','reimu_bullet',0,640,512,256,2,2)
	for i=1,4 do SetImageCenter('reimu_orb_M'..i,384,128) SetImageState('reimu_orb_M'..i,'',Color(255,255,255,255)) end
	LoadImageFromFile('orb_huge_base','THlib\\player\\reimu\\orb_huge_base.png')
	LoadImageFromFile('orb_huge','THlib\\player\\reimu\\orb_huge.png',false,500,500)
	LoadImageFromFile('orb_huge_highlight','THlib\\player\\reimu\\orb_huge_highlight.png')
	SetImageState('orb_huge_base','',Color(255,255,255,255))
	SetImageState('orb_huge','mul+add',Color(255,255,255,255))
	SetImageState('orb_huge_highlight','mul+add',Color(255,255,255,255))
	LoadPS('reimu_high_spell','THlib\\player\\reimu\\reimu_sp_ef.psi','parimg1',32,32)
	LoadImageFromFile('reimu_bomb_ef','THlib\\player\\reimu\\reimu_bomb_ef.png')
	-----------------------------------------
	-----------------------------------------
	-- 必杀技所用素材 --
	LoadImageGroup('reimu_ccc_gap','reimu_bullet',0,128,64*4,64,1,8)
	LoadImageGroup('reimu_ccc_bullet','reimu_bullet',256,128,64*4,64,1,8,90*sf,10*sf)
	----------------------
	--]]
end

function reimu_player.load_res_B(self)
	reimu_player.load_res(self)
	
	LoadImage("_reimu_high_shoot_big",texname,576,0,128,128,48*collibox_scale,48*collibox_scale)
	SetImageState("_reimu_high_shoot_big","",Color(0x80FFFFFF))
	
	LoadImage("_reimu_high_shoot_big_ef",texname,576,0,128,128)
	--SetImageState("_reimu_high_shoot_big_ef","",Color(0x80FFFFFF))--渲染的时候会更改透明度
	
	LoadImage("_reimu_high_shoot_small",texname,704,0,64,64,16*collibox_scale,16*collibox_scale)
	--SetImageState("_reimu_high_shoot_small","",Color(0x80FFFFFF))--渲染的时候会更改透明度
	
	LoadAnimation("_reimu_high_shoot_small_ef",texname,768,0,64,64,2,2,4)
	SetAnimationState("_reimu_high_shoot_small_ef","mul+add",Color(0x80FFFFFF))
	
	LoadAnimation("_reimu_slow_shoot",texname,512,128,128,64,2,2,4,16*collibox_scale,16*collibox_scale)
	SetAnimationState("_reimu_slow_shoot","",Color(0x80FFFFFF))--渲染的时候会更改混合模式
	SetAnimationCenter("_reimu_slow_shoot",96,32)
	
	LoadImage("_reimu_support_1",texname,0,64,64,64)
	LoadImage("_reimu_support_2",texname,64,64,64,64)
	
	--[[
	LoadTexture('reimu_bullet','THlib\\player\\reimu\\reimu_bullet.png')
	LoadImage('reimu_orb_T','reimu_bullet',512,256,128,128,32,32)
	LoadImageGroup('reimu_orb_T','reimu_bullet',832,128,192,128,1,4)
	for i=1,4 do SetImageCenter('reimu_orb_T'..i,128,64) SetImageState('reimu_orb_T'..i,'',Color(255,255,255,255)) end
	LoadImage('reimu_orb_M','reimu_bullet',512,384,256,256,64,64)
	LoadImageGroup('reimu_orb_M','reimu_bullet',0,640,512,256,2,2)
	for i=1,4 do SetImageCenter('reimu_orb_M'..i,384,128) SetImageState('reimu_orb_M'..i,'',Color(255,255,255,255)) end
	
	LoadImageFromFile('orb_huge_base','THlib\\player\\reimu\\orb_huge_base.png')
	LoadImageFromFile('orb_huge','THlib\\player\\reimu\\orb_huge.png',false,500,500)
	LoadImageFromFile('orb_huge_highlight','THlib\\player\\reimu\\orb_huge_highlight.png')
	SetImageState('orb_huge_base','',Color(255,255,255,255))
	SetImageState('orb_huge','mul+add',Color(255,255,255,255))
	SetImageState('orb_huge_highlight','mul+add',Color(255,255,255,255))
	
	LoadPS('reimu_high_spell','THlib\\player\\reimu\\reimu_sp_ef.psi','parimg1',32,32)
	LoadImageFromFile('reimu_bomb_ef','THlib\\player\\reimu\\reimu_bomb_ef.png')
	
	-----------------------------------------
	-- 必杀技所用素材 --
	LoadImageGroup('reimu_ccc_gap','reimu_bullet',0,128,64*4,64,1,8)
	LoadImageGroup('reimu_ccc_bullet','reimu_bullet',256,128,64*4,64,1,8,90*sf,10*sf)
	--]]
end

function reimu_player.render_support(self)
	--local n=10
	--local t=0
	--[[
	if self.PowerDelay1>0 then
		n=int(self.support)+1
		t=self.PowerDelay1*255/180
	end
	--]]
	local spimg
	if self.slow==0 then
		spimg="_reimu_support_1"
	elseif self.slow==1 then
		spimg="_reimu_support_2"
	end
	local max_n=#(self.slist[#self.slist])
	for i=1,max_n do
		if self.sp[i] and self.sp[i][3]>0 then
			--使用self.sp[i][3]来进行过渡
			SetImageState(spimg,"",Color(self.sp[i][3]*255,self.sp[i][3]*255,self.sp[i][3]*255,self.sp[i][3]*255))
			Render(spimg,self.supportx+self.sp[i][1],self.supporty+self.sp[i][2],self.timer*3, self.sp[i][3])
			SetImageState(spimg,"",Color(255,255,255,255))
		end
	end
end

----------------------------------------
---main shoot

local reimu_main_bullet_ef=Class(object)

function reimu_main_bullet_ef:init(x,y)
	self.x=x self.y=y
	self.rot=90
	self.img="_reimu_main_shoot_ef"
	self.layer=LAYER_PLAYER_BULLET+50
	self.group=GROUP_GHOST
	self.vy=2.25
end

function reimu_main_bullet_ef:frame()
	if self.timer>=15 then
		--self.y=4096
		self.status="del"
	end
end

local reimu_main_bullet=Class(player_bullet_straight)

function reimu_main_bullet:kill()
	New(reimu_main_bullet_ef,
			self.x,self.y,self.rot+180)
end

function reimu_player.main_shoot(self)
	PlaySound("plst00", 0.3, self.x / 768)
	New(reimu_main_bullet, "_reimu_main_shoot", self.x + 10, self.y, 24, 90, 2)
	New(reimu_main_bullet, "_reimu_main_shoot", self.x - 10, self.y, 24, 90, 2)
end

----------------------------------------
---super attack

reimu_ccc_gap=Class(object)

function reimu_ccc_gap:init()
	self.x=player.x
	self.y=player.y+30
	self.killflag=true
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.img='reimu_ccc_gap1'
	self._a=255
end

function reimu_ccc_gap:frame()
	if self.timer<=28 then
		self.img='reimu_ccc_gap'..(int(self.timer/4)+1)
	elseif self.timer>28 and self.timer<=48 and self.timer%3==0 then
		local a1=90+ran:Float(-20,20)
		New(reimu_ccc_stick,self.x+cos(a1)*125,self.y-70+sin(a1)*125,a1,ran:Float(4,5))
	elseif self.timer>48 then
		if self._a<=10 then Del(self) else self._a=self._a-10 end
	end
end

reimu_ccc_stick=Class(object)

function reimu_ccc_stick:init(x,y,a,v)
	self.x=x
	self.y=y
	self.rot=a
	self.v=v
	self.killflag=true
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.img='reimu_ccc_bullet1'
	self.dmg=20
end

function reimu_ccc_stick:frame()
	if self.timer<=6 and self.timer%2==0 then
		local tmpind=int(self.timer/2)+1
		self.img='reimu_ccc_bullet'..tmpind
	elseif self.timer-28>=0 and self.timer-28<=6 and self.timer%2==0 then
		local tmpind=int((self.timer-28)/2)+1+4
		self.img='reimu_ccc_bullet'..tmpind
	elseif self.timer>36 then
		self.vx=self.v*cos(self.rot)
		self.vy=self.v*sin(self.rot)
	end
end

----------------------------------------
---player

Include(path.."reimuA.lua")
Include(path.."reimuB.lua")

--看情况处理，如果自机列表已经写好了，那就可以注释掉这些
table.insert(player_list, {"MWY Hakurei Reimu A","reimu_playerA","ReimuA"})
table.insert(player_list, {"MWY Hakurei Reimu B","reimu_playerB","ReimuB"})



-------------------------------------------------------
reimu_sp_ef1=Class(object)
function reimu_sp_ef1:init(img,x,y,v,angle,target,trail,dmg,t,player,scale,radius,flag)
	self.killflag=true
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.img=img
	self.vscale=1.2*scale
	self.hscale=1.2*scale
	self.a=self.a*1.2*scale
	self.b=self.b*1.2*scale
	self.x=x
	self.y=y
	self.rot=angle
	self.angle=angle
	self.v=v
	self.target=target
	self.trail=trail
	self.dmg=dmg
	self.DMG=dmg
	self.bound=false
	self.tflag=t
	self.player=player
	self.radius=radius
	self.flag=flag
end
function reimu_sp_ef1:frame()
	if BoxCheck(self,-192,192,-224,224) then self.inscreen=true end
	if self.timer<120+self.tflag then
	self.rot=(self.angle-4*self.timer-90)*self.flag
	self.x=self.timer*1.5*cos(self.rot+90)*self.radius+self.player.x
	self.y=self.timer*1.5*sin(self.rot+90)*self.radius+self.player.y
	end
	player_class.findtarget(self)
	if self.timer>120+self.tflag then
		self.killflag=false
		self.dmg=20
		if IsValid(self.target) and self.target.colli then
		local a=math.mod(Angle(self,self.target)-self.rot+720,360)
		if a>180 then a=a-360 end
		local da=self.trail/(Dist(self,self.target)+1)
		if da>=abs(a) then self.rot=Angle(self,self.target)
		else self.rot=self.rot+sign(a)*da end
		end
		self.vx=8*cos(self.rot)
		self.vy=8*sin(self.rot)
		if self.inscreen then
			if self.x>192 then self.x=192 self.vx=0 self.vy=0 end
			if self.x<-192 then self.x=-192 self.vx=0 self.vy=0 end
			if self.y>224 then self.y=224 self.vx=0 self.vy=0 end
			if self.y<-224 then self.y=-224 self.vx=0 self.vy=0 end
		end
	end
	if self.timer>190 then
		self.killflag=true
		self.dmg=0.4*self.DMG
		self.a=2*self.a
		self.b=2*self.b
		self.vscale=(self.timer-190)*0.5+1
		self.hscale=(self.timer-190)*0.5+1
	end
	if self.timer>200 then
		Kill(self)
	end
	New(bomb_bullet_killer,self.x,self.y,self.a*1.5,self.b*1.5,false)
end

function reimu_sp_ef1:kill()
	misc.ShakeScreen(5,5)
	PlaySound('explode',0.3)
	New(bubble,'parimg12',self.x,self.y,30,4,6,Color(0xFFFFFFFF),Color(0x00FFFFFF),LAYER_ENEMY_BULLET_EF,'')
	local a=ran:Float(0,360)
	for i=1,12 do
		New(reimu_sp_ef2,self.x,self.y,ran:Float(4,6),a+i*30,2,ran:Int(1,3))
	end
	self.vscale=2
	self.hscale=2
--	misc.KeepParticle(self)
end

function reimu_sp_ef1:del()
	PlaySound('explode',0.3)
	New(bubble,'parimg12',self.x,self.y,30,4,6,Color(0xFFFFFFFF),Color(0x00FFFFFF),LAYER_ENEMY_BULLET_EF,'')
--	for i=1,4 do
--		New(reimu_sp_ef2,16,16,self.x,self.y,3,360/16*i,0.25,4,30)
--	end
	misc.KeepParticle(self)
	self.vscale=6
	self.hscale=6
end
-------------------------------------------------------
reimu_sp_ef2=Class(object)

function reimu_sp_ef2:init(x,y,v,angle,scale,index)
	self.img='reimu_bomb_ef'
	self.group=GROUP_GHOST
	self.layer=LAYER_PLAYER_BULLET
	self.colli=false
	self.x=x
	self.y=y
	self.rot=angle
	self.vx=v*cos(angle)
	self.vy=v*sin(angle)
	self.dmg=dmg
	self.hide=false
	self.scale=scale
	self.hscale=scale self.vscale=scale
	self.rbg={{255,0,0},{0,255,0},{0,0,255}}
	self.index=index
--	ParticleSetEmission(self,10)
end

function reimu_sp_ef2:frame()
	self.vscale=self.scale*(1-self.timer/60)
	self.hscale=self.scale*(1-self.timer/60)
	if self.timer>=30 then Del(self) end
end

function reimu_sp_ef2:render()
	SetImageState(self.img,'mul+add',Color(255-255*self.timer/30,self.rbg[self.index][1],self.rbg[self.index][2],self.rbg[self.index][3]))
	Render(self.img,self.x,self.y)
	SetImageState(self.img,'mul+add',Color(255,255,255,255))
end
-------------------------------------------------------

-------------------------------------------------------
reimu_sp_ef=Class(player_bullet_trail)

function reimu_sp_ef:kill()
	PlaySound('explode',0.3)
	New(bubble,'parimg12',self.x,self.y,30,4,6,Color(0xFFFFFFFF),Color(0x00FFFFFF),LAYER_ENEMY_BULLET_EF,'')
	for i=1,16 do
		New(reimu_sp_ef2,16,16,self.x,self.y,3,360/16*i,0.25,4,30)
	end
	misc.KeepParticle(self)
end

function reimu_sp_ef:del()
	misc.KeepParticle(self)
end
-------------------------------------------------------

-------------------------------------------------------

reimu_kekkai=Class(object)

function reimu_kekkai:init(x,y,dmg,dr,n,t)
	self.x=x
	self.y=y
	self.dmg=dmg
	SetImageState('reimu_kekkai','mul+add',Color(0x804040FF))
	self.killflag=true
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.r=0
	self.a=0
	self.b=0
	self.dr=dr
	self.ds=dr/256
	self.n=0
	self.mute=true
	self.list={}
	task.New(self,function()
		for i=1,n do
			self.list[i]={scale=0,rot=0}
			self.n=self.n+1
			task.Wait(t)
		end
		self.dmg=0
		PlaySound('slash',1.0)
--		New(bullet_killer,self.x,self.y)
		for i=128,0,-4 do
			SetImageState('reimu_kekkai','mul+add',Color(0x004040FF)+i*Color(0x01000000))
			task.Wait(1)
		end
		Del(self)
	end)
end

function reimu_kekkai:frame()
	task.Do(self)
	if self.timer%6==0 then self.mute=false else self.mute=true end
	self.r=self.r+self.dr
	self.a=self.r
	self.b=self.r
	for i=1,self.n do
		self.list[i].scale=self.list[i].scale+self.ds
		self.list[i].rot=self.list[i].rot+(-1)^i
	end
	New(bomb_bullet_killer,self.x,self.y,self.a/1.25,self.b/1.25,false)
end

function reimu_kekkai:render()
	for i=1,self.n do
		Render('reimu_kekkai',self.x,self.y,self.list[i].rot,self.list[i].scale)
	end
end
-------------------------------------
function reboundCheck(self)--边界反弹仍然需要改的更自然一点
	if not BoxCheck(self,lstg.world.boundl,lstg.world.boundr,lstg.world.boundb,lstg.world.boundt) then
		if self.rebound == nil then return
		elseif self.rebound <= 0 then --这边过完之后rebound就是负的，不会再进这个循环了
			self.bound=true
			--task.New(self, function() task.Wait(5) RawDel(self) end) --避免出屏即消突然不见的尴尬
		else
			if abs(self.y)>224 then
				self.y = sign(self.y)*(224*2-abs(self.y))
				self.rot=-self.rot
			elseif abs(self.x)>196 then
				self.x = sign(self.x)*(196*2-abs(self.x))
				self.rot=sign(self.rot)*(180-abs(self.rot))
			end
		end
		self.rebound = self.rebound - 1
	end
end
-------------------------------------

-------------------------------------

-------------------------------------
reimu_orb_T = Class(object)
-- function reimu_orb_T:init(x,y,v,angle,rebound,s,dmg,player)
function reimu_orb_T:init(x,y,v,angle,rebound,s,dmg,player,delay)
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.vscale=0
	self.hscale=0
	self.s=s --scale的最终值
	self.x=x
	self.y=y
	self.rot=angle
	self.v=v
	self.rebound=rebound
	self.dmg=dmg
	self.bound=false
	self.player=player
	self.img='reimu_orb_T'
	self.imgs='reimu_orb_T1'
	self.killflag=true
	self.delay=delay
	self.tmpa=self.a
	self.tmpb=self.b
end

function reimu_orb_T:frame()
	if self.timer>self.delay then
		self.x=self.x+self.v*cos(self.rot)
		self.y=self.y+self.v*sin(self.rot)
		reboundCheck(self)
	end
	local t = max(0,self.timer-self.delay)
	if self.timer<=10+self.delay and self.timer>self.delay then 
	    self.vscale,self.hscale = t/10*self.s,t/10*self.s 
		self.a,self.b = self.tmpa*t/10*self.s,self.tmpb*t/10*self.s 
	end
	self.imgs='reimu_orb_T'..int(t/5%4+1)
	New(bomb_bullet_killer,self.x,self.y,self.a*1.2,self.b*1.2,false)
end

function reimu_orb_T:render()
	Render(self.imgs,self.x,self.y,self.rot,self.vscale)
	Render(self.img,self.x,self.y,max(0,self.timer-self.delay)*4,self.vscale)
end
-------------------------------------
reimu_orb_M = Class(object)
-- function reimu_orb_M:init(x,y,v,angle,rebound,s,dmg,player)
function reimu_orb_M:init(x,y,v,angle,rebound,s,dmg,player,delay)
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.vscale=0
	self.hscale=0
	self.s=s --scale的最终值
	self.x=x
	self.y=y
	self.rot=angle
	self.v=v
	self.rebound=rebound
	self.dmg=dmg
	self.bound=false
	self.player=player
	self.img='reimu_orb_M'
	self.imgs='reimu_orb_M1'
	self.killflag=true
	self.delay=delay
	self.tmpa=self.a
	self.tmpb=self.b
end

function reimu_orb_M:frame()
	if self.timer>self.delay then
		self.x=self.x+self.v*cos(self.rot)
		self.y=self.y+self.v*sin(self.rot)
		reboundCheck(self)
	end
	local t = max(0,self.timer-self.delay)
	if self.timer<=10+self.delay and self.timer>self.delay then 
	    self.vscale,self.hscale = t/10*self.s,t/10*self.s 
		self.a,self.b = self.tmpa*t/10*self.s,self.tmpb*t/10*self.s 
	end
	self.imgs='reimu_orb_M'..int(t/3%4+1)
	New(bomb_bullet_killer,self.x,self.y,self.a*1.2,self.b*1.2,false)
end

function reimu_orb_M:render()
	Render(self.img,self.x,self.y,max(0,self.timer-self.delay)*4,self.vscale)
	Render(self.imgs,self.x,self.y,self.rot,self.vscale)
end
-------------------------------------
reimu_orb_H = Class(object)
function reimu_orb_H:init(x,y,dmg)
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.vscale=0
	self.hscale=0
	self.s=0 --scale的最终值
	self.x=x
	self.y=y
	self.rot=0
	self.omiga=6
	self.v=v
	self.dmg=dmg
	self.bound=false
	self.player=player
	self.img='orb_huge'
	self.released=false
	self.killflag=true
end

function reimu_orb_H:frame() 
	if self.released then 
		--misc.ShakeScreen(2,120)
		self.y=self.y+2
	end 
	New(bomb_bullet_killer,self.x,self.y,self.a*1.2,self.b*1.2,false)
end

function reimu_orb_H:render()
	Render('orb_huge_base',self.x,self.y,self.rot,self.s)
	Render('orb_huge',self.x,self.y,self.rot,self.s)
	Render('orb_huge_highlight',self.x,self.y,0,self.s)
end
