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

local function high_shoot(self)
	local num = int(self.support)+1
	if self.timer % 8 < 4 then
		--local num = int(lstg.var.power / 100) + 1
		for i = 1, 6 do
			if self.sp[i] and self.sp[i][3] > 0.5 then
				New(reimu_side_bullet, "_reimu_high_shoot",
						self.supportx + self.sp[i][1],
						self.supporty + self.sp[i][2],
						8,
						self.anglelist[num][i],
						self.target, 900, 0.7)
			end
		end
	end
end

local function slow_shoot(self)
	for i = 1, 6 do
		if self.sp[i] and self.sp[i][3] > 0.5 then
			New(reimu_side_bullet2, "_reimu_slow_shoot", self.supportx + self.sp[i][1] - 3, self.supporty + self.sp[i][2], 24, 90, 0.3)
			New(reimu_side_bullet2, "_reimu_slow_shoot", self.supportx + self.sp[i][1] + 3, self.supporty + self.sp[i][2], 24, 90, 0.3)
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
	do return end
	--发动符卡攻击
	local deep = min(int(self.KeyDownTimer1 / 90) + 1, 3) --用于指示X键持续按下的时长，<90时为阶段1，每过90增加一个阶段,最多阶段三
	if self.SpellIndex > 3 then
		----------低速符卡
		PlaySound('power1', 0.8)
		--PlaySound('cat00',0.8)
		K_dr_SlowSpell = 1.25 + K_dr_SpellDmg * lstg.var.dr
		if self.SpellIndex == 4 then
			--低速符卡1
			for i = 1, 9 do
				New(reimu_orb_T, player.x, player.y, 10, i * 20, 4 + deep, 0.35 + 0.15 * deep, K_dr_SlowSpell, player, (i - 1) * 5)
			end
			-- task.New(player,function()
			-- for i=1,9 do
			-- New(reimu_orb_T,player.x,player.y,10,i*20,4+deep,0.35+0.15*deep,K_dr_SlowSpell,player)
			-- task.Wait(5)
			-- end
			-- end)
		end
		if self.SpellIndex == 5 then
			--低速符卡2
			for i = 1, 3 do
				New(reimu_orb_M, player.x, player.y, 3, i * 45, 1 + deep, 0.35 + 0.15 * deep, K_dr_SlowSpell * 3, player, (i - 1) * 10)
			end
			-- task.New(player,function()
			-- for i=1,3 do
			-- New(reimu_orb_M,player.x,player.y,3,i*45,1+deep,0.35+0.15*deep,K_dr_SlowSpell*3,player)
			-- task.Wait(10)
			-- end
			-- end)
		end
		if self.SpellIndex == 6 then
			--低速符卡3
			task.New(player, function()
				if deep == 1 then
					lstg.tmpvar.orb = New(reimu_orb_H, player.x, player.y, K_dr_SlowSpell * 10)
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
			if deep == 1 then
				n = 10
			end
			if deep == 2 then
				n = 12
			end
			if deep == 3 then
				n = 14
			end
		end
		if self.SpellIndex == 2 then
			if deep == 1 then
				n = 14
			end
			if deep == 2 then
				n = 18
			end
			if deep == 3 then
				n = 22
			end
		end
		if self.SpellIndex == 3 then
			if deep == 1 then
				n = 10
			end
			if deep == 2 then
				n = 12
			end
			if deep == 3 then
				n = 14
			end
		end
		for i = 1, n do
			New(reimu_sp_ef1, 'reimu_sp_ef', self.x, self.y, 8, rot + i * (360 / n), tar1, 1200, K_dr_HighSpell, n * 3 - 6 * i, self, scale, radius, 1) --高速符卡，图像，横坐标，纵坐标，速度，角度，目标，控制释放，伤害，控制时间，符卡中心
		end
		if self.SpellIndex == 3 then
			for i = 1, n do
				New(reimu_sp_ef1, 'reimu_sp_ef', self.x, self.y, 8, rot + i * (360 / n), tar1, 1200, K_dr_HighSpell, n * 3 - 6 * i, self, scale, 0.6 * radius, -1) --高速符卡，图像，横坐标，纵坐标，速度，角度，目标，控制释放，伤害，控制时间，符卡中心
			end
		end
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
	do return end
	PlaySound("slash", 0.7)
	New(reimu_ccc_gap)
end
