---=====================================
---东方梦无垠自机系列
---灵梦A机体
---Author:Xiliusha
---Email:Xiliusha@outlook.com
---=====================================

----------------------------------------
---support shoot

local reimu_side_bullet_ef=Class(object)

function reimu_side_bullet_ef:init(x,y,rot)
	self.x=x self.y=y self.rot=rot
	self.img="_reimu_high_shoot_ef"
	self.layer=LAYER_PLAYER_BULLET+50
	self.group=GROUP_GHOST
	self.vx=1*cos(rot) self.vy=1*sin(rot)
	self.omiga=15*ran:Sign()
end

function reimu_side_bullet_ef:frame()
	self.vscale,self.hscale=self.vscale+0.1,self.hscale+0.1
	if self.timer>=15 then
		self.status="del"
	end
end

local reimu_side_bullet=Class(player_bullet_trail)

function reimu_side_bullet:init(img,x,y,v,angle,target,trail,dmg)
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.img=img
	self.x=x
	self.y=y
	self.rot=angle
	self.v=v
	self.target=target
	self.trail=trail
	self.dmg=dmg
end

function reimu_side_bullet:frame()
	player_class.findtarget(self)
	if IsValid(self.target) and self.target.colli then
		local a=math.mod(Angle(self,self.target)-self.rot+720,360)
		if a>180 then a=a-360 end
		local da=self.trail/(Dist(self,self.target)+1)
		if da>=abs(a) then self.rot=Angle(self,self.target)
		else self.rot=self.rot+sign(a)*da end
	end
	self.vx=self.v*cos(self.rot)
	self.vy=self.v*sin(self.rot)
end

function reimu_side_bullet:kill()
	New(reimu_side_bullet_ef,
			self.x,self.y,self.rot)
end

local reimu_side_bullet_ef2=Class(object)

function reimu_side_bullet_ef2:init(x,y,rot)
	self.x=x self.y=y+32 self.rot=rot
	self.img="_reimu_slow_shoot_ef"
	self.layer=LAYER_PLAYER_BULLET+50
	self.group=GROUP_GHOST self.vy=2
	self.hscale=ran:Float(1.4,1.6)
end

function reimu_side_bullet_ef2:frame()
	SetImgState(self,"mul+add",128-128*self.timer/16,255,255,255)--0x80FFFFFF
	if self.timer>=15 then
		self.status="del"
	end
end

local reimu_side_bullet2=Class(player_bullet_straight)

function reimu_side_bullet2:kill()
	New(reimu_side_bullet_ef2,
			self.x,self.y,self.rot+180+ran:Float(-15,15))
end
---------------------------------------
---
---

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
end

function reimu_sp_ef1:del()
	PlaySound('explode',0.3)
	New(bubble,'parimg12',self.x,self.y,30,4,6,Color(0xFFFFFFFF),Color(0x00FFFFFF),LAYER_ENEMY_BULLET_EF,'')
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
--[[
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
--]]

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
		-- reboundCheck(self)
	end
	if Dist(self.x,self.y,0,0)>450 then RawDel(self) end
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
	self.bound=false
	self.delay=delay
	self.tmpa=self.a
	self.tmpb=self.b
end

function reimu_orb_M:frame()
	if self.timer>self.delay then
		self.x=self.x+self.v*cos(self.rot)
		self.y=self.y+self.v*sin(self.rot)
		-- reboundCheck(self)
	end
	if Dist(self.x,self.y,0,0)>450 then RawDel(self) end
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
function reimu_orb_H:init(x,y,dmg,player)
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
	player.slowlock=true
	self.img='orb_huge'
	self.released=false
	self.released_pre=false
	self.killflag=true
end

function reimu_orb_H:frame() 
	if self.timer%10==0 then misc.ShakeScreen(10,2) end
	if self.released then 
		self.y=self.y+2
	end 
	if self.released~=self.released_pre then
		misc.ShakeScreen(10,5)
		self.player.slowlock=false
		self.player.protect=2
	end
	self.released_pre=self.released
	if self.y-self.a>=350 then RawDel(self) end
	New(bomb_bullet_killer,self.x,self.y,self.a*1.2,self.b*1.2,false)
end

function reimu_orb_H:render()
	Render('orb_huge_base',self.x,self.y,self.rot,self.s)
	Render('orb_huge',self.x,self.y,self.rot,self.s)
	Render('orb_huge_highlight',self.x,self.y,0,self.s)
end





----------------------------------------
---player class

reimu_playerA = Class(player_class)

function reimu_playerA:init(slot)
	reimu_player.load_res_A(self)
	player_class.init(self)
	if not mwy.useMWYwis then self._wisys=mwy.PlayerWalkImageSystem(self) end  --到时候记得删掉，不然会覆盖你们的自机行走图系统
	self.name = "ReimuA"
	self.hspeed = 4.5
	self.cardname = {
		high1 = '灵符「梦想妙珠」',
		high2 = '灵符「梦想封印」',
		high3 = '神灵「梦想封印·寂」',
		low1 = '珠符「明珠暗投」',
		low2 = '玉符「阴阳宝玉」',
		low3 = '宝具「阴阳飞鸟井」'
	}
	self.A = 0.5
	self.B = 0.5
	self.slist = {
		{ nil, nil, nil, nil },
		{ { 0, -36, 0, 24 }, nil, nil, nil, nil, nil },
		{ { -28, -12, 12, 24 }, { 28, -12, -12, 24 }, nil, nil, nil, nil },
		{ { -24, -16, 16, 20 }, { 0, -32, 0, 28 }, { 24, -16, -16, 20 }, nil, nil, nil },
		{ { -36, -6, 8, 40 }, { -16, -32, 16, 20 }, { 16, -32, -16, 20 }, { 36, -6, -8, 40 }, nil, nil },
		{ { -24, 9, 24, 20 }, { -32, -12, -12, 40 }, { 0, -40, 0, 28 }, { 32, -12, 12, 40 }, { 24, 9, -24, 20 }, nil },
		{ { -36, -12, 24, 36 }, { -20, -16, 12, 26 }, { -20, -40, 16, 8 }, { 20, -40, -16, 8 }, { 20, -16, -12, 26 }, { 36, -12, -24, 36 } },
		{ { -36, -12, -24, 36 }, { -40, -32, 12, 26 }, { -20, -40, 16, 8 }, { 20, -40, -16, 8 }, { 40, -32, -12, 26 }, { 36, -12, -24, 36 } }
	}
	self.anglelist = {
		{ 90, 90, 90, 90, 90, 90 },
		{ 90, 90, 90, 90, 90, 90 },
		{ 100, 80, 90, 90, 80, 70 },
		{ 100, 90, 80, 90, 80, 70 },
		{ 110, 100, 80, 70, 90, 80 },
		{ 110, 100, 90, 80, 70, 70 },
		{ 110, 120, 95, 85, 60, 70 },
	}
end
local dmg_offset={
	{1,1,1,1,1,1},
	{1,1,1,1,1,1},
	{0.95,1.1,0.95,1,1,1,1},
	{0.9,1.15,1.15,0.9,1,1},
	{1,1.1,1.3,1.1,1,1},
	{1,1.3,1.5,1.5,1.3,1},
	{1,1.1,1.4,1.4,1.1,1}
}
local function high_shoot(self)
	local num=#(self.sp)
	if self.timer % 8 < 4 then
		--local num = int(lstg.var.power / 100) + 1
		for i = 1, 6 do
			if self.sp[i] and self.sp[i][3] > 0.5 then
				New(reimu_side_bullet, "_reimu_high_shoot",
						self.supportx + self.sp[i][1],
						self.supporty + self.sp[i][2],
						8,
						self.anglelist[num][i],
						self.target, 900, 0.7*dmg_offset[num][i])
			end
		end
	end
end

local function slow_shoot(self)
	local num=#(self.sp)
	for i = 1, 6 do
		if self.sp[i] and self.sp[i][3] > 0.5 then
			New(reimu_side_bullet2, "_reimu_slow_shoot", self.supportx + self.sp[i][1] - 3, self.supporty + self.sp[i][2], 24, 90, 0.3*dmg_offset[num][i])
			New(reimu_side_bullet2, "_reimu_slow_shoot", self.supportx + self.sp[i][1] + 3, self.supporty + self.sp[i][2], 24, 90, 0.3*dmg_offset[num][i])
		end
	end
end

function reimu_playerA:shoot()
	self.nextshoot = 4
	reimu_player.main_shoot(self)
	if self.support > 0 then
		if self.slow == 1 then
			slow_shoot(self)
		else
			high_shoot(self)
		end
	end
end

function reimu_playerA:spell()
	do return end
	--宣卡
	self.collect_line = self.collect_line - 300
	New(tasker, function()
		task.Wait(90)
		self.collect_line = self.collect_line + 300
	end)
	if self.slow == 1 then
		PlaySound('power1', 0.8)
		PlaySound('cat00', 0.8)
		misc.ShakeScreen(210, 3)
		--		New(bullet_killer,self.x,self.y)
		New(player_spell_mask, 64, 64, 255, 30, 210, 30)
		K_dr_SlowSpell = 1.25 + K_dr_SpellDmg * lstg.var.dr
		New(reimu_kekkai, self.x, self.y, K_dr_SlowSpell, 3, 20, 12) --低速符卡，横坐标，纵坐标，伤害，每帧变化距离，弹数，等待帧数
		self.nextspell = 240
		self.protect = 360
	else
		PlaySound('nep00', 0.8)
		PlaySound('slash', 0.8)
		New(player_spell_mask, 200, 0, 0, 30, 180, 30)
		local rot = ran:Int(0, 360)
		K_dr_HighSpell = 1.0 + K_dr_SpellDmg * lstg.var.dr
		for i = 1, 8 do
			New(reimu_sp_ef1, 'reimu_sp_ef', self.x, self.y, 8, rot + i * 45, tar1, 1200, K_dr_HighSpell, 40 - 10 * i, self) --高速符卡，图像，横坐标，纵坐标，速度，角度，目标，控制释放，伤害，控制时间，符卡中心
		end
		self.nextspell = 300
		self.protect = 360
	end
end

function reimu_playerA:newSpell()
	--发动符卡攻击
	local deep = min(int(self.KeyDownTimer1 / 90) + 1, 3) --用于指示X键持续按下的时长，<90时为阶段1，每过90增加一个阶段,最多阶段三
	if self.SpellIndex > 3 then
		----------低速符卡
		PlaySound('power1', 0.8)
		--PlaySound('cat00',0.8)
		K_dr_SlowSpell = 1.25 + K_dr_SpellDmg * lstg.var.dr
		if self.SpellIndex == 4 then
			--低速符卡1
			self.protect=45
			for i = 1, 9 do
				New(reimu_orb_T, player.x, player.y, 6, i * 20, 2 + deep, 0.7 + 0.3 * deep, K_dr_SlowSpell*0.7, player, (i - 1) * 5)
			end
		end
		if self.SpellIndex == 5 then
			--低速符卡2
			self.protect=45
			for i = 1, 3 do
				New(reimu_orb_M, player.x, player.y, 2.5, i * 45, 0, 0.7 + 0.3 * deep, K_dr_SlowSpell*0.5, player, (i - 1) * 10)
			end
		end
		if self.SpellIndex == 6 then
			--低速符卡3
			task.New(player, function()
				if deep == 1 then
					lstg.tmpvar.orb = New(reimu_orb_H, player.x, player.y, K_dr_SlowSpell,self)
				end
				local orb = lstg.tmpvar.orb
				orb.released = false
				for i = 1, 90 do
					orb.omiga = orb.omiga - 0.02
					orb.s = orb.s + 0.0037037 * 2
					orb.x = player.x
					orb.y = player.y + 10 + 225 * orb.s
					orb.a = 200 * orb.s
					orb.b = orb.a
					task.Wait(1)
				end
				orb.released = true
			end)
		end
	else
		----------高速符卡
		PlaySound('nep00', 0.8)
		PlaySound('slash', 0.8)
		K_dr_HighSpell = 1.0 + K_dr_SpellDmg * lstg.var.dr
		local rot = ran:Int(0, 360)
		local scale = 1.0
		local radius = 0.8
		local n = 10
		if self.SpellIndex == 2 then
			scale = 1.2
			radius = 1.0
		else
			if self.SpellIndex == 3 then
				scale = 1.4
				radius = 1.2
			end
		end
		if self.SpellIndex == 1 then
			if deep == 1 then n = 10 end
			if deep == 2 then n = 12 end
			if deep == 3 then n = 14 end
		end
		if self.SpellIndex == 2 then
			if deep == 1 then n = 14 end
			if deep == 2 then n = 18 end
			if deep == 3 then n = 22 end
		end
		if self.SpellIndex == 3 then
			if deep == 1 then n = 10 end
			if deep == 2 then n = 12 end
			if deep == 3 then n = 14 end
		end
		for i = 1, n do
			New(reimu_sp_ef1, 'reimu_high_spell', self.x, self.y, 8, rot + i * (360 / n), tar1, 1200, K_dr_HighSpell, n * 3 - 6 * i, self, scale, radius, 1) --高速符卡，图像，横坐标，纵坐标，速度，角度，目标，控制释放，伤害，控制时间，符卡中心
		end
		if self.SpellIndex == 3 then
			for i = 1, n do
				New(reimu_sp_ef1, 'reimu_high_spell', self.x, self.y, 8, rot + i * (360 / n), tar1, 1200, K_dr_HighSpell, n * 3 - 6 * i, self, scale, 0.6 * radius, -1) --高速符卡，图像，横坐标，纵坐标，速度，角度，目标，控制释放，伤害，控制时间，符卡中心
			end
		end
		self.protect=45
	end
	
	self.SpellCardHp = max(0, self.SpellCardHp - K_SpellCost)
end

function reimu_playerA:frame()
	task.Do(self)
	player_class.frame(self)
end

function reimu_playerA:render()
	reimu_player.render_support(self)
	player_class.render(self)
end

function reimu_playerA:ccc()
	-- do return end
	PlaySound("slash", 0.7)
	New(reimu_ccc_gap)
end
