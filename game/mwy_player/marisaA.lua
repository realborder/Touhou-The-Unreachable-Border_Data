---=====================================
---东方梦无垠自机系列
---灵梦A机体
---Author:Xiliusha
---Email:Xiliusha@outlook.com
---=====================================

----------------------------------------
---support shoot


--高速拖尾--------------------------------------
local marisa_high_bullet_tail=Class(object)

function marisa_high_bullet_tail:init(master)
	self.master=master
	self.x,self.y=master.x,master.y
	self.img="_marisa_high_shoot_tail"
	self.group=GROUP_GHOST
	self.layer=LAYER_PLAYER_BULLET-50
	ParticleFire(self)
	ParticleSetEmission(self,15)
end

function marisa_high_bullet_tail:frame()
	if IsValid(self.master) then 	self.x,self.y=self.master.x,self.master.y
	else ParticleStop(self) RawDel(self) end
end

--高速消亡--------------------------------------
local marisa_high_bullet_ef=Class(object)

function marisa_high_bullet_ef:init(x,y,dmg)
	self.x=x self.y=y self.dmg=dmg
	self.img="_marisa_high_shoot_ef"
	self.layer=LAYER_PLAYER_BULLET+50
	self.group=GROUP_PLAYER_BULLET
	self.a_init,self.b_init=self.a,self.b
	self.killflag=true
end

function marisa_high_bullet_ef:frame()
	local k=sin(90*self.timer/30)
	self.vscale,self.hscale=1+k,1+k
	self.a=self.a_init*(1+k)/2
	self.b=self.b_init*(1+k)/2
	if self.timer>=30 then self.status="del" end
end

function marisa_high_bullet_ef:render()
	local k=1-self.timer/30
	SetImageState(self.img,"mul+add",Color(125*k,255,255,255))
	Render(self.img,self.x,self.y,self.rot,self.hscale)
end

--高速--------------------------------------
local marisa_high_bullet=Class(player_bullet_straight)

function marisa_high_bullet:init(x,y,v,angle,dmg)
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.img='_marisa_high_shoot'
	self.par=New(marisa_high_bullet_tail,self)
	self.x=x
	self.y=y
	self.rot=angle
	self.vy=v
	self.dmg=dmg
	self.omiga=5
end

function marisa_high_bullet:frame()
end

function marisa_high_bullet:kill()
	New(marisa_high_bullet_ef,self.x,self.y,0.04)
end

--低速消亡--------------------------------------
local marisa_slow_bullet_ef=Class(object)

function marisa_slow_bullet_ef:init(x,y,size)
	self.group=GROUP_GHOST
	self.layer=LAYER_PLAYER_BULLET
	self.img="_marisa_slow_shoot_ef"
	self.x,self.y=x,y
	self.rot=-90
	ParticleFire(self)
	ParticleSetEmission(self,60+20*size)
end

function marisa_slow_bullet_ef:frame()
	if self.timer>=15 then ParticleStop(self) 
	elseif self.timer>=60 then RawDel(self) end
end

--低速拖尾--------------------------------------
local marisa_slow_bullet_tail=Class(object)

function marisa_slow_bullet_tail:init(master)
	self.group=GROUP_GHOST
	self.layer=LAYER_PLAYER_BULLET-50
	self.img="_marisa_slow_shoot_trail"..ran:Int(1,3)
	self.x,self.y=master.x,master.y
	self.master=master
	self.rot=90
end

function marisa_slow_bullet_tail:frame()
	if IsValid(self.master) then self.x,self.y=self.master.x,self.master.y 
	else 
		self.vscale=max(0,self.vscale-0.15) 
		if self.vscale<=0 then RawDel(self) end
	end
end
	
--低速--------------------------------------
local marisa_slow_bullet=Class(object)
--这个子弹自机只会发一个，火力越强子弹越大伤害越高，可能onenote里没描述清楚
function marisa_slow_bullet:init(x,y,v,size,dmg)
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.img='_marisa_slow_shoot'
	self.tail=New(marisa_slow_bullet_tail,self)
	self.x=x
	self.y=y
	self.rot=90
	self.hscale,self.vscale=size,size
	self.vy=v
	self.dmg=dmg*1.08
	self.omiga=5
end
function marisa_slow_bullet:kill()
	New(marisa_slow_bullet_ef,self.x,self.y,self.hscale)
end

--子机行为变更

local render_support=function (self)
	local spimg
	if self.slow==0 then
		spimg="_marisa_support_1"
	elseif self.slow==1 then
		spimg="_marisa_support_2"
	end
	local max_n=6
	for i=1,max_n do
		if self.sp[i] and self.sp[i][3]>0 then
			--使用self.sp[i][3]来进行过渡
			SetImageState(spimg,"",Color(self.sp[i][3]*255,self.sp[i][3]*255,self.sp[i][3]*255,self.sp[i][3]*255))
			Render(spimg,self.sp[i][1],self.sp[i][2],0, 0.7+0.1*sin(self.timer*6))
			SetImageState(spimg,"",Color(255,255,255,255))
		end
	end
end
----------------------------------------
---高速符卡
---
marisa_stardust_summoner=Class(object)
function marisa_stardust_summoner:init(index,player)
	self.index=index
	self.player=player
	self.life=92
	if IsValid(_last_stardust_summoner) then
		if _last_stardust_summoner.index==index then _last_stardust_summoner.life=_last_stardust_summoner.life+90 RawDel(self) self.hide=true
		else RawDel(_last_stardust_summoner)  _last_stardust_summoner=self end
	else 
		_last_stardust_summoner=self
	end
	
	if index==1 or index==2 then
		task.New(self,function()
			for i=1,3 do
				local num=6+2*i
				for i=1,num do

					task.Wait(8)
				end
				task.Wait(90-8*num)
			end
		end)
	elseif index==3 then
		task.New(self,function()
			for i=1,3 do
				for j=1,90 do
					if j%(8-i)==0 then
						
					end
					task.Wait()
				end
			end
		end)
	end
end
function marisa_stardust_summoner:frame()
	self.x,self.y=self.player.x,self.player.y
	self.life=self.life-1
	if self.life<=0 then task.Clear(self) RawDel(self) end
	task.Do(self)
end


----------------------------------------
---player class

marisa_playerA = Class(player_class)

function marisa_playerA:init(slot)
	marisa_player.load_res_A(self)
	player_class.init(self)
		if not mwy.useMWYwis then self._wisys=mwy.PlayerWalkImageSystem(self) end  --到时候记得删掉，不然会覆盖你们的自机行走图系统
	self.name = "marisaA"
	self.hspeed = 4.5
	self.cardname = {
		high1 = '魔符「Milky Way」',
		high2 = '魔空「Asteroid Belt」',
		high3 = '魔星「Star Ring」',
		low1 = '魔符「Stardust Reverie」',
		low2 = '黑魔「Event Horizon」',
		low3 = '黑洞「Star of Void」'
	}
	self.A = 0.5
	self.B = 0.5
	--[[
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
	}]]
end

local function high_shoot(self)
	local num = int(self.support)+1
	if self.timer % 16 <4 then
		--local num = int(lstg.var.power / 100) + 1
		for i = 1, 6 do
			if self.sp[i] and self.sp[i][3] > 0.5 then
				New(marisa_high_bullet,
						self.sp[i][1],
						self.sp[i][2],
						8,
						90,
						0.7)
			end
		end
	end
end

local function slow_shoot(self)
	if self.timer%15<4 then
		local num=0
		for i = 1, 6 do		if self.sp[i] and self.sp[i][3] > 0.5 then		num=num+1		end end
		local size=0.5+num*0.13
		New(marisa_slow_bullet,self.x,self.y,10,0.5+num*0.13,5+num*1.2)
			-- New(marisa_side_bullet2, "_marisa_slow_shoot", self.supportx + self.sp[i][1] - 3, self.supporty + self.sp[i][2], 24, 90, 0.3)
			-- New(marisa_side_bullet2, "_marisa_slow_shoot", self.supportx + self.sp[i][1] + 3, self.supporty + self.sp[i][2], 24, 90, 0.3)
	end
end

function marisa_playerA:shoot()
	self.nextshoot = 4
	marisa_player.main_shoot(self)
	if self.support > 0 then
		if self.slow == 1 then
			slow_shoot(self)
		else
			high_shoot(self)
		end
	end
end

function marisa_playerA:spell()
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
		-- New(marisa_kekkai, self.x, self.y, K_dr_SlowSpell, 3, 20, 12) --低速符卡，横坐标，纵坐标，伤害，每帧变化距离，弹数，等待帧数
		self.nextspell = 240
		self.protect = 360
	else
		PlaySound('nep00', 0.8)
		PlaySound('slash', 0.8)
		New(player_spell_mask, 200, 0, 0, 30, 180, 30)
		local rot = ran:Int(0, 360)
		K_dr_HighSpell = 1.0 + K_dr_SpellDmg * lstg.var.dr
		for i = 1, 8 do
			-- New(marisa_sp_ef1, 'marisa_sp_ef', self.x, self.y, 8, rot + i * 45, tar1, 1200, K_dr_HighSpell, 40 - 10 * i, self) --高速符卡，图像，横坐标，纵坐标，速度，角度，目标，控制释放，伤害，控制时间，符卡中心
		end
		self.nextspell = 300
		self.protect = 360
	end
end

function marisa_playerA:newSpell()
	do return end
	--发动符卡攻击
	local deep = min(int(self.KeyDownTimer1 / 90) + 1, 3) --用于指示X键持续按下的时长，<90时为阶段1，每过90增加一个阶段,最多阶段三
	if self.SpellIndex > 3 then
		----------低速符卡
		PlaySound('power1', 0.8)
		K_dr_SlowSpell = 1.25 + K_dr_SpellDmg * lstg.var.dr
		New(marisa_stardust_summoner,self.SpellIndex,self)
		if self.SpellIndex == 4 then

		end
		if self.SpellIndex == 5 then

		end
		if self.SpellIndex == 6 then

		end
	else
		----------高速符卡
		PlaySound('nep00', 0.8)
		PlaySound('slash', 0.8)
		K_dr_HighSpell = 1.0 + K_dr_SpellDmg * lstg.var.dr

	end
	
	self.SpellCardHp = max(0, self.SpellCardHp - K_SpellCost)
end

function marisa_playerA:frame()
	task.Do(self)
	player_class.frame(self)
	--计算子机的位置
	local sup=self.support
	local max_n=6
	local i=1
	local E_Dist=28 --每个子机之间的间距
	local magnet=0.09
	if not self.sp then self.sp={} end
	while sup>0 do
		local x_aim,y_aim --子机坐标的目标值
		if not self.sp[i] then self.sp[i]={} end
		if self.slow==0 then --高速下子机行为参照以撒小跟班
			if i==1 then  --第一个子机追着自机走
				x_aim,y_aim=self.x,self.y
			else
				x_aim,y_aim=self.sp[i-1][1],self.sp[i-1][2]
			end
		elseif self.slow==1 then
			x_aim,y_aim=self.x,self.y
		end
		if (not self.sp[i][1]) or (not self.sp[i][2]) then self.sp[i][1]=x_aim self.sp[i][2]=y_aim
		else 
			local dist=Dist(self.sp[i][1],self.sp[i][2],x_aim,y_aim)
			if dist>E_Dist and self.slow==0 then
				local theta=Angle(self.sp[i][1],self.sp[i][2],x_aim,y_aim)+180
				x_aim,y_aim=x_aim+cos(theta)*E_Dist,y_aim+sin(theta)*E_Dist	
				self.sp[i][1]=self.sp[i][1]+(x_aim-self.sp[i][1])*magnet
				self.sp[i][2]=self.sp[i][2]+(y_aim-self.sp[i][2])*magnet
			elseif self.slow==1 then
				self.sp[i][1]=self.sp[i][1]+(x_aim-self.sp[i][1])*magnet*2
				self.sp[i][2]=self.sp[i][2]+(y_aim-self.sp[i][2])*magnet*2
			end
		end
		self.sp[i][3]=min(1,sup)
		sup=sup-1	i=i+1
	end
	while i<=max_n do
		if not self.sp[i] then self.sp[i]={} end
		self.sp[i][1],self.sp[i][2],self.sp[i][3]=nil,nil,0
		i=i+1
	end
end

function marisa_playerA:render()
	render_support(self)
	player_class.render(self)
end

function marisa_playerA:ccc()
	PlaySound("slash", 0.7)
	New(marisa_drug_bottle,self.x,self.y,6,100)
end
