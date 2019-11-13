---=====================================
---东方梦无垠自机系列
---灵梦A机体
---Author:Xiliusha
---Email:Xiliusha@outlook.com
---=====================================
sanae_high_bullet2=Class(object)
function sanae_high_bullet2:init(x,y,rot,dmg)
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.img='_sanae_high_shoot_snake'
	self.x=x
	self.y=y
	self.rot=rot
	self.vx=24*cos(self.rot)
	self.dmg=dmg
	self.flag=true
end

function sanae_high_bullet2:frame()
	if self.timer<=2 then
		self.hscale=self.timer/2
	end
end

sanae_high_bullet=Class(object)
function sanae_high_bullet:init(x,y,dmg)
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.img='_sanae_high_shoot_snake'
	self.x=x
	self.y=y
	self.rot=90
	self.vy=12
	self.dmg=dmg
	self.flag=true
end

function sanae_high_bullet:frame()
	local enm={GROUP_ENEMY,GROUP_NONTJT}
	for e=1,2 do
		for i,o in ObjList(enm[e]) do
			if self.y>=o.y-50 and self.y<o.y+20 and self.flag and o.colli then
				self.vy=0
				self.y=o.y
				if o.x>=self.x then
					New(sanae_high_bullet2,self.x,self.y,0,self.dmg)
				else
					New(sanae_high_bullet2,self.x,self.y,180,self.dmg)
				end
				self.flag=false
				Del(self)
			end
		end
	end
end


sanae_slow_bullet=Class(object)
function sanae_slow_bullet:init(x,y,a0,o,r,dmg)
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.img='_sanae_high_shoot_spell'
	self.x=x
	self.y=y
	self.x0=x
	self.y0=y
	self.a0=a0
	self.o=o
	self.r=r
	self.rot=a0
	self.dmg=dmg
	self.v=8
end

function sanae_slow_bullet:frame()
	local x0,y0,r,a0,o=self.x0,self.y0,self.r,self.a0,self.o
	if self.timer<=60 then 
		self.v=self.v-6/60
	else
		self.v=2
	end
	self.a0=self.a0+self.o
	self.x=x0+self.timer*r*cos(a0)
	self.y=y0+self.timer*r*sin(a0)+self.timer*self.v
	self.rot=a0+90
end
----------------------------------------
---player class

sanae_playerA = Class(player_class)

function sanae_playerA:init(slot)
	sanae_player.load_res_A(self)
	player_class.init(self)
		if not mwy.useMWYwis then self._wisys=mwy.PlayerWalkImageSystem(self) end  --到时候记得删掉，不然会覆盖你们的自机行走图系统
	self.name = "sanaeA"
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
	if self.timer % 4 <4 then
		--local num = int(lstg.var.power / 100) + 1
		for i = 1, 6 do
			if self.sp[i] and self.sp[i][3] > 0.5 then
				New(sanae_high_bullet,
						self.supportx+self.sp[i][1],
						self.supporty+self.sp[i][2]+20,
						1)
			end
		end
	end
end

local function slow_shoot(self)
	if self.timer%16<4 then
		local num=0
		for i = 1, 6 do		if self.sp[i] and self.sp[i][3] > 0.5 then		num=num+1		end end
		local size=0.5+num*0.13
		for i = 1, 6 do
			if self.sp[i] and self.sp[i][3] > 0.5 then
				local a=360/self.support*i
				New(sanae_slow_bullet,self.x,self.y,a,8,0.5,1)
			end
		end
	end
end

function sanae_playerA:shoot()
	self.nextshoot = 4
	sanae_player.main_shoot(self)
	if self.support > 0 then
		if self.slow == 1 then
			slow_shoot(self)
		else
			high_shoot(self)
		end
	end
end

function sanae_playerA:spell()
	do return end
	--宣卡
	self.collect_line = self.collect_line - 300
	New(tasker, function()
		task.Wait(90)
		self.collect_line = self.collect_line + 300
	end)
	if self.slow == 1 then
		self.nextspell = 240
		self.protect = 360
	else
		self.nextspell = 300
		self.protect = 360
	end
end

function sanae_playerA:newSpell()
	--发动符卡攻击
	local deep = min(int(self.KeyDownTimer1 / 90) + 1, 3) --用于指示X键持续按下的时长，<90时为阶段1，每过90增加一个阶段,最多阶段三
	if self.SpellIndex > 3 then
		----------低速符卡
		PlaySound('power1', 0.8)
		tuolib.DRP_Sys.K_dr_SlowSpell = 1.25 + tuolib.DRP_Sys.K_dr_SpellDmg * lstg.var.dr
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
		tuolib.DRP_Sys.K_dr_HighSpell = 1.0 + tuolib.DRP_Sys.K_dr_SpellDmg * lstg.var.dr

	end
	
	self.SpellCardHp = max(0, self.SpellCardHp - tuolib.DRP_Sys.K_SpellCost)
end

function sanae_playerA:frame()
	task.Do(self)
	player_class.frame(self)
end

function sanae_playerA:render()
	sanae_player.render_support(self)
	player_class.render(self)
end

function sanae_playerA:ccc()
	PlaySound("slash", 0.7)
	--New(sanae_drug_bottle,self.x,self.y,6,100)
end
