---=====================================
---东方梦无垠自机系列
---灵梦B机体
---Author:Xiliusha
---Email:Xiliusha@outlook.com
---=====================================

-------------------------------------------
---power offset

local power_offset={
	--大符札，小符札，妖怪破坏者
	{{1.0,1.0},1.0},--0
	{{1.0,1.0},1.0},--1
	{{1.0,1.0},0.6},--2
	{{1.0,1.0},1.0},--3
	{{1.0,1.0},0.6},--4
	{{1.0,1.0},1.0},--5
	{{1.0,1.0},0.6},--6
	{{1.0,1.0},0.6},--6
}

-------------------------------------------
---support shoot

local reimu_spread_small_ef = Class(object)

function reimu_spread_small_ef:init(x, y, rot, omiga, dv)
	self.layer = LAYER_PLAYER_BULLET + 50
	self.img = "_reimu_high_shoot_small_ef"
	self.x = x
	self.y = y
	self.rot = rot
	self.omiga = omiga * 1.5
	self.vx = 1 * cos(dv)
	self.vy = 1 * sin(dv)
end

function reimu_spread_small_ef:frame()
	if self.timer >= 15 then
		self.status = "del"
	end
end

local reimu_spread_small = Class(object)

function reimu_spread_small:init(x, y, rot, acr, acc, dmg, sign)
	self.group = GROUP_PLAYER_BULLET
	self.layer = LAYER_PLAYER_BULLET
	self.img = "_reimu_high_shoot_small"
	self.x = x
	self.y = y
	self.rot = rot
	self.v = 0
	self.vx = 1 * cos(self.rot)
	self.vy = 1 * sin(self.rot)
	self.dmg = dmg
	self.hscale = 0
	self.vscale = 0
	self.sa = self.a
	self.sb = self.b
	self.a = 0
	self.b = 0
	sign = sign or 1
	self.omiga = 4 * sign
	self.acc = acc
	self.acr = acr
end

function reimu_spread_small:frame()
	if self.timer <= 6 then
		self.hscale = self.timer / 6
		self.vscale = self.hscale
		self.a = self.hscale * self.sa
		self.b = self.vscale * self.sb
	end
	self.vx = self.vx + self.acc * cos(self.acr)
	self.vy = self.vy + self.acc * sin(self.acr)
end

function reimu_spread_small:render()
	if self.timer <= 6 then
		SetImageState(self.img, "", Color(180 * self.timer / 6, 255, 255, 255))
	else
		SetImageState(self.img, "", Color(180, 255, 255, 255))
	end
	DefaultRenderFunc(self)
end

function reimu_spread_small:kill()
	local efa=0
	if self.dx==0 and self.dy==0 then
		efa=self.rot
	else
		efa=Angle(0, 0, self.dx, self.dy)
	end
	New(reimu_spread_small_ef,
			self.x, self.y,
			self.rot, self.omiga,
			efa)
end

local reimu_spread_big_ef = Class(object)

function reimu_spread_big_ef:init(x, y, rot, omiga, hscale, vscale)
	self.layer = LAYER_PLAYER_BULLET + 49
	self.img = "_reimu_high_shoot_big_ef"
	self.x = x
	self.y = y
	self.hscale = hscale
	self.vscale = vscale
	self.rot = rot
	self.omiga = omiga
	self.alpha = 1
end

function reimu_spread_big_ef:frame()
	self.hscale = self.hscale * 1.05
	self.vscale = self.vscale * 1.05
	self.alpha = 1 - self.timer / 15
	if self.timer >= 15 then
		self.status = "del"
	end
end

function reimu_spread_big_ef:render()
	SetImgState(self, "mul+add", self.alpha * 128, 255, 255, 255)
	DefaultRenderFunc(self)
end

local reimu_spread_big = Class(object)

function reimu_spread_big:init(x, y, rot, dmgL, dmgS, sign)
	self.group = GROUP_PLAYER_BULLET
	self.layer = LAYER_PLAYER_BULLET - 1
	self.img = "_reimu_high_shoot_big"
	self.x = x
	self.y = y
	self.angle = rot
	self.rot = rot
	self.v = 6
	self.dmg = dmgL
	self._dmg=dmgS
	self.sa = self.a
	self.sb = self.b
	self.a = 0
	self.b = 0
	self.hscale = 0
	self.vscale = 0
	if rot==90 then
		local s=ran:Sign()
		self.omiga = 4 * s
		self.sign=s
	else
		self.sign = sign or 1
		self.omiga = 4 * sign
	end
	self.brk=false
end

local function shoot_small(self)
	for a = -60, 60, 40 do
		New(reimu_spread_small,
				self.x + 8 * cos(a + self.angle),
				self.y + 8 * sin(a + self.angle),
				a + self.angle,
				self.angle,
				0.1, self._dmg,
				self.sign)
	end
	for a = -40, 40, 40 do
		New(reimu_spread_small,
				self.x - 8 * cos(a + self.angle),
				self.y - 8 * sin(a + self.angle),
				a + self.angle,
				self.angle,
				0.05, self._dmg,
				self.sign)
	end
end

function reimu_spread_big:frame()
	if self.timer <= 30 then
		--缩放变大
		self.hscale = self.timer / 30
		self.vscale = self.hscale
		self.a = self.hscale * self.sa
		self.b = self.vscale * self.sb
		self.v = self.v - 6 / 30
		SetV(self, self.v, self.angle)
		--提前释放小符札
		if self.timer == 27 then
			shoot_small(self)
			self.brk=true
		end
	elseif self.timer > 30 then
		self.vx = 0
		self.vy = 0
		Kill(self)
	end
end

function reimu_spread_big:kill()
	shoot_small(self)
	New(reimu_spread_big_ef,
			self.x, self.y, self.rot, self.omiga, self.hscale, self.vscale)
end

local reimu_bullet_purple = Class(object)

function reimu_bullet_purple:init(x, y, rot, v, _hp, dmg)
	self.group = GROUP_PLAYER_BULLET
	self.layer = LAYER_PLAYER_BULLET
	self.img = "_reimu_slow_shoot"
	self.x = x
	self.y = y
	self.rot = rot
	self.v = v
	self.vx = v * cos(rot)
	self.vy = v * sin(rot)
	self._hp = _hp
	self.dmg = dmg*0.88
	self._blend = ""
	self.killflag = true
	self.cold = 0
	self.attack = false
end

function reimu_bullet_purple:frame()
	if IsValid(self.killerenemy) then
		if (self.killerenemy.group == GROUP_ENEMY or self.killerenemy.group == GROUP_NONTJT) and self._hp > 0 then
			self.attack = true
			self._blend = "mul+add"
			self.vx = self.vx * 0.6
			self.vy = self.vy * 0.6
			self._hp = self._hp - 0.1
			self.vscale = self.vscale - 0.05
		end
		self.killerenemy = nil
		self.cold = 0
	else
		--防止长时间滞留
		if self.cold >= 60 and self.attack then
			local maxvx = abs(self.v * cos(self.rot))
			local maxvy = abs(self.v * sin(self.rot))
			self.vx = max(-maxvx, min(self.vx * 1.05, maxvx))
			self.vy = max(-maxvy, min(self.vy * 1.05, maxvy))
		end
		self.cold = self.cold + 1
	end
	if self._hp <= 0 then
		self.colli = false
		self.vscale = self.vscale - 0.1
		if self.vscale <= 0 then
			Del(self)
		end
	end
end

function reimu_bullet_purple:render()
	SetAnimationState(self.img, self._blend)
	DefaultRenderFunc(self)
end

----------------------------------------
---player class

reimu_playerB = Class(player_class)

function reimu_playerB:init(slot)
	reimu_player.load_res_B(self)
	player_class.init(self)
		if not mwy.useMWYwis then self._wisys = mwy.PlayerWalkImageSystem(self) end  --到时候记得删掉，不然会覆盖你们的自机行走图系统
	self.name = "ReimuB"
	self.hspeed = 4.5
	self.cardname = {
		high1 = '灵符「扩散结界」',
		high2 = '梦符「二重结界」',
		high3 = '梦境「二重博丽结界」',
		low1 = '梦符「封魔阵」',
		low2 = '神技「四面退魔阵」',
		low3 = '神技「八方龙杀阵」'
	}
	self.slist = {
		{ nil, nil, nil, nil },--0
		{ { 0, 42, 0, 32 }, nil, nil, nil, nil, nil },--1
		{ { -30, 30, -10, 31 }, { 30, 30, 10, 31 }, nil, nil, nil, nil },--2
		{ { -36, 0, -20, 29 }, { 0, 42, 0, 32 }, { 36, 0, 20, 29 }, nil, nil, nil },--3
		{ { -36, -6, -29, 25 }, { -18, 38, -10, 31 }, { 18, 38, 10, 31 }, { 36, -6, 29, 25 }, nil, nil },--4
		{ { -38, -10, -38, 20 }, { -28, 20, -20, 29 }, { 0, 42, 0, 32 }, { 28, 20, 20, 29 }, { 38, -10, 38, 20 }, nil },--5
		{ { -38, -10, -45, 13 }, { -28, 20, -29, 25 }, { -10, 42, -10, 31 }, { 10, 42, 10, 31 }, { 28, 20, 29, 25 }, { 38, -10, 45, 13 } },--6
		{ { -38, -10, -45, 13 }, { -28, 20, -29, 25 }, { -10, 42, -10, 31 }, { 10, 42, 10, 31 }, { 28, 20, 29, 25 }, { 38, -10, 45, 13 } }--6
	}
	self.anglelist = {
		{ -1, -1, -1, -1, -1, -1 },--0
		{ 90, -1, -1, -1, -1, -1 },--1
		{ 95, 85, -1, -1, -1, -1 },--2
		{ 108, 90, 72, -1, -1, -1 },--3
		{ 105, 95, 85, 75, -1, -1 },--4
		{ 126, 108, 90, 72, 54, -1 },--5
		{ 135, 105, 95, 85, 75, 45 },--6
		{ 135, 105, 95, 85, 75, 45 },--6
	}
	self.fire_cold = 30
end

local function high_shoot(self)
	--local num = int(lstg.var.power / 100) + 1
	local num = int(self.support)+1
	if self.fire_cold == 0 then
		--local angle = {110,100,80,70,110,70}
		for i = 1, 6 do
			if self.sp[i] and self.sp[i][3] > 0.5 then
				local x = self.supportx + self.sp[i][1]
				--让符札的自旋方向镜像对称，看起来比较舒服
				local sign
				if x > self.supportx then
					sign = -1
				else
					sign = 1
				end
				New(reimu_spread_big,
						x,
						self.supporty + self.sp[i][2],
						self.anglelist[num][i],
						4*power_offset[num][1][1],
						1*power_offset[num][1][2],
						sign)
			end
		end
		self.fire_cold = 30
	end
end

local function slow_shoot(self)
	--local angle = {110,100,80,70,110,70}
	--local num = int(lstg.var.power / 100) + 1
	local num = int(self.support)+1
	Print(num)
	if self.timer % 15 == 0 then
		for i = 1, 6 do
			if self.sp[i] and self.sp[i][3] > 0.5 then
				New(reimu_bullet_purple,
						self.supportx + self.sp[i][1],
						self.supporty + self.sp[i][2],
						self.anglelist[num][i],
						6, 1.0,
						1.0*power_offset[num][2])
			end
		end
	end
end

function reimu_playerB:shoot()
	if self.timer % 4 == 0 then
		reimu_player.main_shoot(self)
	end
	if self.support > 0 then
		if self.slow == 0 then
			high_shoot(self)
		else
			slow_shoot(self)
		end
	end
end

function reimu_playerB:spell()
	do return end
	self.collect_line = self.collect_line - 512
	New(tasker, function()
		task.Wait(90)
		self.collect_line = self.collect_line + 512
	end)
	if self.slow == 1 then
		PlaySound('power1', 0.8)
		PlaySound('cat00', 0.8)
		misc.ShakeScreen(210, 3)
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

function reimu_playerB:newSpell()
	do
		return
	end
	local deep = min(int(self.KeyDownTimer1 / 90) + 1, 3) --用于表示符卡持续按下的阶段，<90时为阶段1，每过90增加一个阶段,最多阶段三
	if self.SpellIndex > 3 then
		----------低速符卡
		PlaySound('power1', 0.8)
		--PlaySound('cat00',0.8)
		K_dr_SlowSpell = 1.25 + K_dr_SpellDmg * lstg.var.dr
		if self.SpellIndex == 4 then
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

function reimu_playerB:frame()
	task.Do(self)
	player_class.frame(self)
	self.fire_cold = max(self.fire_cold - 1, 0)
end

function reimu_playerB:render()
	reimu_player.render_support(self)
	player_class.render(self)
end

function reimu_playerB:ccc()
	do
		return
	end
	PlaySound('slash', 0.7)
	New(reimu_ccc_gap)
end

