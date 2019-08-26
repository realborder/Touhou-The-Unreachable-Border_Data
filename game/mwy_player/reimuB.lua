---=====================================
---东方梦无垠自机系列
---灵梦B机体
---Author:Xiliusha
---Email:Xiliusha@outlook.com
---=====================================

-------------------------------------------
---power offset

local power_offset = {
	--大符札，小符札，妖怪破坏者
	{ { 1.0, 1.0 }, 1.0 }, --0
	{ { 1.0, 1.0 }, 1.0 }, --1
	{ { 1.0, 1.0 }, 0.6 }, --2
	{ { 1.0, 1.0 }, 1.0 }, --3
	{ { 1.0, 1.0 }, 0.6 }, --4
	{ { 1.0, 1.0 }, 1.0 }, --5
	{ { 1.0, 1.0 }, 0.6 }, --6
	{ { 1.0, 1.0 }, 0.6 }, --6
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
		SetImageState(self.img, "", Color(125 * self.timer / 6, 255, 255, 255))
	else
		SetImageState(self.img, "", Color(125, 255, 255, 255))
	end
	DefaultRenderFunc(self)
end

function reimu_spread_small:kill()
	local efa = 0
	if self.dx == 0 and self.dy == 0 then
		efa = self.rot
	else
		efa = Angle(0, 0, self.dx, self.dy)
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
	SetImageState(self.img, "mul+add", Color(self.alpha * 128, 255, 255, 255))
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
	self._dmg = dmgS
	self.sa = self.a
	self.sb = self.b
	self.a = 0
	self.b = 0
	self.hscale = 0
	self.vscale = 0
	if rot == 90 then
		local s = ran:Sign()
		self.omiga = 4 * s
		self.sign = s
	else
		self.sign = sign or 1
		self.omiga = 4 * sign
	end
	self.brk = false
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
		self.hscale = 0.5+0.5*self.timer / 30
		self.vscale = self.hscale
		self.a = self.hscale * self.sa
		self.b = self.vscale * self.sb
		self.v = self.v - 6 / 30
		SetV(self, self.v, self.angle)
		--提前释放小符札
		if self.timer == 27 then
			shoot_small(self)
			self.brk = true
		end
	elseif self.timer > 30 then
		self.vx = 0
		self.vy = 0
		Kill(self)
	end
end
function reimu_spread_big:render()
	SetImageState(self.img, "mul+add", Color(0x80FFFFFF))
	DefaultRenderFunc(self)
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
	self.dmg = dmg * 0.88
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

---------------------------------------
---高速雷

local reimu_boundary_line = Class(object)

function reimu_boundary_line:init(master, dmg, rot, ra, t, r, w, h, index)
	local dmg_offset={0.6,0.8,1}
	self.group = GROUP_PLAYER_BULLET
	self.layer = LAYER_PLAYER_BULLET
	self.bound = false
	self.rect = true
	self.index=index
	if not dmg_offset[index] then error(index) end
	self.dmg = dmg * dmg_offset[index]
	self.killflag = true
	self.master = master
	self.x = self.master.x
	self.y = self.master.y
	self.img = "_reimu_high_spell_ef"
	self.hscale, self.vscale = 0, 0
	self._rot = rot
	self.rot = self._rot + 90
	if index==1 then
		_object.set_color(self, "mul+add", 192, 100, 100, 255)
	elseif index==2 then
		_object.set_color(self, "mul+add", 192, 255, 100, 255)
	elseif index==3 then
		_object.set_color(self, "mul+add", 192, 255, 255, 100)
	end
	task.New(self, function()
		local dw = w / t
		local dr = r / t
		self.b = h / 2
		for i = 1, t do
			if IsValid(self.master) then
				self.r = dr * i
				self.a = (dw * i) / 2
				self._rot = self._rot + ra
				self.rot = self._rot + 90
				self.x = self.master.x + (self.r - (self.b / 2)) * cos(self._rot)
				self.y = self.master.y + (self.r - (self.b / 2)) * sin(self._rot)
				self.hscale = self.a / 192
				self.vscale = self.b / 48
				task.Wait(1)
			else
				break
			end
		end
		Del(self)
	end)
end

function reimu_boundary_line:frame()
	New(boundary_bullet_killer,self.x,self.y,self.a,self.b,self.rot)
	task.Do(self)
end

function reimu_boundary_line:render()
	if self._blend and self._a and self._r and self._g and self._b then
		SetImgState(self, self._blend, self._a, self._r, self._g, self._b)
		DefaultRenderFunc(self)
		SetImgState(self, "", 255, 255, 255, 255)
	else
		DefaultRenderFunc(self)
	end
end

function reimu_boundary_line:del()
	if not (self.killed) then
		PreserveObject(self)
		self.killed = true
		self.colli = false
		if IsValid(self.master) then
			self.master.obj_n = self.master.obj_n - 1
		end
		task.Clear(self)
		task.New(self, function()
			local a = self._a
			for i = 29, 0, -1 do
				self._a = a * (i / 30)
				task.Wait(1)
			end
			Del(self)
		end)
	end
end

local reimu_boundary = Class(object)

function reimu_boundary:init(x, y, n, d, dmg, index)
	self.x, self.y = x, y
	self.obj_n = 0
	task.New(self, function()
		local a = 0
		local _a = 15
		local da = 0.5
		local t = 500
		local r = 800
		local w = r * 2
		local h = 64
		local dmg = dmg
		local dd = (n - 1) / n	
		local dd2 = (dd * 0.95)
		for i = 1, n do
			for j = 1, 4 do
				New(reimu_boundary_line, self, dmg, 90 + a + j * 90, da, t, r, w, h, index)
				self.obj_n = self.obj_n + 1
			end
			for j = 1, 4 do
				New(reimu_boundary_line, self, dmg, 90 - a + j * 90, -da, t, r, w, h, index)
				self.obj_n = self.obj_n + 1
			end
			a = a + _a
			task.Wait(d)
			d = d * dd
			--dmg = dmg * 0.95
			t = t * dd2
		end
		self.finish = true
	end)
end

function reimu_boundary:frame()
	task.Do(self)
	if self.finish and self.obj_n <= 0 then
		Del(self)
	end
end



---------------------------------------
---低速雷




local reimu_boundary2_obj = Class(object)

function reimu_boundary2_obj:init(master, x, y, dmg)
	self.group = GROUP_PLAYER_BULLET
	self.layer = LAYER_PLAYER_BULLET
	self.bound = false
	self.dmg = dmg
	self.killflag = true
	self.master = master
	self.x, self.y = x, y
	self.img = "_reimu_slow_spell_ef1"
	self.img2 = "_reimu_slow_spell_ef2"
	self.scale = 0
	reimu_boundary2_obj._scale(self)
	_object.set_color(self, "mul+add", 255, 255, 255, 255)
end

function reimu_boundary2_obj:frame()
	local _temp_key, _temp_keyp
	if self.master.key then
		_temp_key = KeyState
		_temp_keyp = KeyStatePre
		KeyState = self.master.key
		KeyStatePre = self.master.keypre
	end
	if KeyIsDown("spell") then
		if self.scale < 1 then
			self.scale = min(self.scale + 0.23, 1.35)
		else
			self.scale = min(self.scale + 0.07, 1.35)
		end
		self.flag = true
		self.omiga = 1.35
	else
		if self.scale > 1 then
			self.scale = max(self.scale - 0.07, 1)
		else
			self.scale = min(self.scale + 0.16, 1)
		end
		self.flag = false
		self.omiga = 0.75
	end
	reimu_boundary2_obj._scale(self)
	if self.master.key then
		KeyState = _temp_key
		KeyStatePre = _temp_keyp
	end
end

function reimu_boundary2_obj:render()
	if self._blend and self._a and self._r and self._g and self._b then
		SetImageState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
		SetImageState(self.img2, self._blend, Color(self._a, self._r, self._g, self._b))
		reimu_boundary2_obj._render(self)
		if self.flag then
			reimu_boundary2_obj._render(self)
		end
		SetImageState(self.img, "", Color(0xFFFFFFFF))
		SetImageState(self.img2, "", Color(0xFFFFFFFF))
	else
		reimu_boundary2_obj._render(self)
		if self.flag then
			reimu_boundary2_obj._render(self)
		end
	end
end

function reimu_boundary2_obj:del()
	if not(self.killed) then
		PreserveObject(self)
		self.killed = true
	end
end

function reimu_boundary2_obj:_scale()
	self.a, self.b = self.scale * 128, self.scale * 128
	--self.hscale, self.vscale = self.a / 256, self.b / 256
	self.hscale, self.vscale = self.a / 128, self.b / 128
end

function reimu_boundary2_obj:_render()
	Render(self.img2, self.x, self.y, self.rot, self.hscale, self.vscale)
	Render(self.img, self.x, self.y, -self.rot, self.hscale, self.vscale)
end

boundary_bullet_killer=Class(object)
function boundary_bullet_killer:init(x,y,a,b,rot,kill_indes,rect)
	self.x=x self.y=y
	self.a=a self.b=b
	self.rot=rot
	self.rect=rect or false
	-- if self.a~=self.b then self.rect=true end
	self.group=GROUP_PLAYER
	self.hide=true
	self.kill_indes=kill_indes
end
function boundary_bullet_killer:frame()
	if self.timer==1 then Del(self) end
end
function boundary_bullet_killer:colli(other)
	if self.kill_indes then
		if other.group==GROUP_INDES then
			Kill(other)
		end
	end
	if other.group==GROUP_ENEMY_BULLET then Kill(other) end
end

reimu_slowspell1=Class(object)
function reimu_slowspell1:init(x,y,rgb,rot,dmg,scale_fix)
	self.x,self.y=x,y
	self.color=color
	self.rot=rot
	self._blend='mul+add'
	self._r,self._g,self._b=rgb[1],rgb[2],rgb[3]
	self.dmg=dmg
	self.scale_fix=scale_fix
	self.a=500
	self.hscale=200
	self.vscale=5
	self.b=0
	self.img="white"
	self.alpha=0.5
	task.New(self,function () 
		for i=1,45 do
			local k=i/45
			self.vscale=k*10
			self.alpha=0.5+0.5*k
			self.a=448
			self.b=20+20*k*scale_fix
			task.Wait()
		end
		misc.ShakeScreen(30,3)
		New(reimu_slowspell1_wave,self.x,self.y,5,self.rot+90,rgb,dmg,60,scale_fix)
		New(reimu_slowspell1_wave,self.x,self.y,5,self.rot-90,rgb,dmg,60,scale_fix)
		RawDel(self)
	end)
end
function reimu_slowspell1:frame()
	task.Do	(self)
	New(boundary_bullet_killer,self.x,self.y,self.a,self.b,self.rot,false,true)
end
function reimu_slowspell1:render()
	if self.timer<=45 then
		local k=self.timer/45
		local alpha=255*k
		local w=10*k
		SetImageState('white',"mul+add",Color(alpha,self._r,self._g,self._b))
		object.render(self)
	end
end

reimu_slowspell1_wave=Class(object)
function reimu_slowspell1_wave:init(x,y,v,rot,rgb,dmg,remainTime,scale_fix)
	--麻烦的是素材，如果朝向0度放这个波那么素材的rot应该为-90，也就是渲染和判定的时候rot要-90（嗯？）
	--好吧，应该是传入朝向角，计算好vx和vy后再-90，所以看到不要奇怪
	self.x,self.y=x,y
	self.rot=rot+90
	self.vx,self.vy=v*cos(rot),v*sin(rot)
	self._blend='mul+add'
	self._r,self._g,self._b=rgb[1],rgb[2],rgb[3]
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.alpha=1
	self.killflag=true
	self.dmg=dmg
	self.img='_reimu_slow_spell1'
	self.a=448
	self.b=40
	self.rect=true
	self.hscale=3
	task.New(self,function ()
		local vx,vy=self.vx,self.vy
		for i=1,60 do
			local k=1-i/60
			self.vx,self.vy=vx*k,vy*k
			self.vscale=1+(1-k)
			task.Wait()
		end
	end)
	task.New(self,function() 
		task.Wait(15)
		for i=1,60 do
			local k=1-i/60
			self.alpha=k
			task.Wait()
		end
		RawDel(self)
	end)
end
function reimu_slowspell1_wave:frame()
	New(boundary_bullet_killer,self.x,self.y,self.a,self.b,self.rot,false,true)
	task.Do(self)
end
function reimu_slowspell1_wave:render()
	SetImageState(self.img,self._blend,Color(self.alpha*255,self._r,self._g,self._b))
	object.render(self)
end

reimu_slowspell2=Class(object)
function reimu_slowspell2:init(x,y,dmg)
	self.x,self.y=x,y
	self.omiga=10
	self.omiga1=2
	self.omiga2=10
	self.img='img_void'
	self.img1='_reimu_boundary_4way'
	self.img2='_reimu_boundary_4waycenter'
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.dmg=dmg
	self.alpha=0
	self.scale=0.4
	self.killflag=true
	task.New(self,function () 
		local o1,o2=self.omiga1,self.omiga2
		for i=1,270 do
			local k=i/270
			self.omiga=o1+(o2-o1)*i/180
			self.alpha=min(1,i/45)
			self.scale=0.4+0.35*k
			task.Wait()
		end
		for i=1,10 do
			local k=sin(990*i/10)
			self.scale=0.75*(1-k)
			task.Wait()
		end
		RawDel(self)
	end)
end
function reimu_slowspell2:frame()
	self.hscale,self.vscale=self.scale,self.scale
	self.a,self.b=200*self.scale,200*self.scale
	New(boundary_bullet_killer,self.x,self.y,self.a,self.b,self.rot)
	task.Do(self)
end
function reimu_slowspell2:render()
	SetImageState(self.img1,"mul+add",Color(self.alpha*255,255,255,255))
	Render(self.img1,self.x,self.y,-self.rot,self.scale)
	SetImageState(self.img2,"mul+add",Color(self.alpha*205,255,255,255))
	Render(self.img2,self.x,self.y,self.rot,self.scale*1.5)
end
function reimu_slowspell2:kill()
	New(reimu_slowspell2_ef,self)
end
reimu_slowspell2_ef=Class(object)
function reimu_slowspell2_ef:init(master)
	local m=master
	self.group=GROUP_GHOST
	self.layer=LAYER_PLAYER_BULLET
	self.x,self.y=m.x,m.y
	self.rot,self.omiga=m.rot,m.omiga
	self.img1,self.img2,self.scale=m.img1,m.img2,m.scale
	self.alpha=m.alpha
	task.New(self,function () 
		local sc=self.scale
		for i=1,15 do
			local k=1+0.5*sin(90*i/15)
			self.scale=k*sc
			self.hscale=self.scale
			self.vscale=self.scale
			self.alpha=1-i/15
			task.Wait()
		end
		RawDel(self)
	end)
end
function reimu_slowspell2_ef:frame()
	task.Do(self)
end
function reimu_slowspell2_ef:render()
	SetImageState(self.img1,"mul+add",Color(self.alpha*255,255,255,255))
	Render(self.img1,self.x,self.y,-self.rot,self.scale)
	SetImageState(self.img2,"mul+add",Color(self.alpha*205,255,255,255))
	Render(self.img2,self.x,self.y,self.rot,self.scale*1.5)
end

reimu_slowspell2_pre=Class(object)
function reimu_slowspell2_pre:init(x,y,sx,sy,dmg)
	self.x,self.y=x,y
	self.sx,self.sy=sx,sy
	self._dmg=dmg
	self.group=GROUP_GHOST
	self.layer=LAYER_PLAYER_BULLET
	self.img='_reimu_high_shoot_big'
	self.serv=nil
	self.omiga=15
	self.scale=0.5
	self.alpha=1
	task.New(self,function()
		for i=1,15 do
			local x,y=self.x,self.y
			local k=sin(90*i/15)
			self.x=x+(self.sx-x)*k
			self.y=y+(self.sy-y)*k
			self.scale=0.8+0.2*k
			task.Wait()
		end
		self.serv=New(reimu_slowspell2,self.x,self.y,self._dmg)
		for i=1,8 do
			local k=i/8
			self.scale=1+k
			self.alpha=1-k
			task.Wait()
		end
		task.Wait(270-28)
		Kill(self)
	end)
end
function reimu_slowspell2_pre:frame()
	task.Do(self)
	self.hscale,self.vscale=self.scale,self.scale
	-- New(boundary_bullet_killer,self.x,self.y,self.a,self.b,self.rot)
end
function reimu_slowspell2_pre:render()
	SetImageState(self.img,'mul+add',Color(255*self.alpha,255,255,255))
	object.render(self)
end
function reimu_slowspell2_pre:kill()
	if IsValid(self.serv) then Kill(self.serv) end
end

reimu_slowspell3=Class(object)
function reimu_slowspell3:init(x,y,dmg,player,remainTime)
	self.x,self.y=x,y
	self.player=player
	self.dmg=0
	self._dmg=dmg
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_ENEMY_BULLET
	self.killflag=true
	self.img1="_reimu_boundary_8_inside"
	self.img2="_reimu_boundary_8_outside"
	self.scale_max=1.2
	self.scale1=0
	self.scale2=0
	self.omiga1=0
	self.omiga2=0
	self.rot1,self.rot2=0,0
	self.remainTime=remainTime
	self.hspeed=player.hspeed
	self.lspeed=player.lspeed
	player.hspeed=0
	player.lspeed=0
	player.slowlock=true
	lstg.var.block_spell=true
	task.New(self,function()
		local s_max=self.scale_max
		for	i=1,90 do
			local k=sin(90*i/90)
			self.scale1=s_max*k*0.8
			self.dmg=0.1*5*self._dmg
			task.Wait()
		end
		local domiga=0.1
		for i=1,remainTime-90 do
			local k=i/(remainTime-90)
			self.scale1=s_max*(k*0.2+0.8)
			self.omiga1=min(4,self.omiga1+domiga)
			self.dmg=self._dmg*(0.5+0.5*k)
			task.Wait()
		end
		for i=1,20 do
			local k=sin(90*i/20)
			self.scale1=s_max*(1-k)
			task.Wait()
		end
		player.hspeed=self.hspeed
		player.lspeed=self.lspeed
		player.slowlock=false
		lstg.var.block_spell=false
		RawDel(self)
	end)
	task.New(self,function ()
		local s_max=self.scale_max
		task.Wait(90)
		for	i=1,90 do
			local k=sin(90*i/90)
			self.scale2=s_max*k*0.8
			task.Wait()
		end
		local domiga=0.1
		for i=1,remainTime-90-90 do
			local k=i/(remainTime-90-90)
			self.omiga2=min(5,self.omiga2+domiga)
			self.scale1=s_max*(k*0.2+0.8)
			task.Wait()
		end
		for i=1,20 do
			local k=sin(90*i/20)
			self.scale2=s_max*(1-k)
			task.Wait()
		end
	end)
end
function reimu_slowspell3:frame()
	task.Do(self)
	if self.timer%10==1 then 
		misc.ShakeScreen(10,3) 
		self.player.protect=10
	end
	New(boundary_bullet_killer,self.x,self.y,self.a,self.b,self.rot)
	self.rot1=self.rot1+self.omiga1
	self.rot2=self.rot2-self.omiga2
	self.a,self.b=(0.5+0.5*self.scale2)*512*0.5,(0.5+0.5*self.scale2)*512*0.5
	self.player.SpellCardHp=self.player.SpellCardHp-K_SpellDecay/2

end
function reimu_slowspell3:render()
	Render(self.img1,self.x,self.y,self.rot1,self.scale1)
	Render(self.img2,self.x,self.y,self.rot2,self.scale2)
end


reimu_slow_boundary_summoner=Class(object)
function reimu_slow_boundary_summoner:init(index,player)
	self.index=index
	self.hide=true
	self.player=player
	self.x,self.y=player.x,player.y
	self.life=92
	self.serv={}
	if IsValid(_last_boundaryS_summoner) then
		if _last_boundaryS_summoner.index==index then
			 _last_boundaryS_summoner.life=_last_boundaryS_summoner.life+90 
			 RawDel(self) 
			 self.hide=true
			 return
		else 
			RawDel(_last_boundaryS_summoner)  
			_last_boundaryS_summoner=self end
	else 
		_last_boundaryS_summoner=self
	end


	if self.index==3 then
		--低速三卡
		RawDel(self)
	elseif self.index==2 then 
		local dist=100
		if not IsValid(self.serv) then 
			self.serv[1]=New(reimu_slowspell2_pre,self.x,self.y,self.x,self.y+dist,0.5*K_dr_SlowSpell)
			self.serv[2]=New(reimu_slowspell2_pre,self.x,self.y,self.x,self.y-dist,0.5*K_dr_SlowSpell)
			self.serv[3]=New(reimu_slowspell2_pre,self.x,self.y,self.x+dist,self.y,0.5*K_dr_SlowSpell)
			self.serv[4]=New(reimu_slowspell2_pre,self.x,self.y,self.x-dist,self.y,0.5*K_dr_SlowSpell)
		end
	elseif self.index==1 then
		task.New(self,function()
			New(reimu_slowspell1,self.x,self.y,{255,100,100},0,0.5,1)
			New(reimu_slowspell1,self.x,self.y,{100,100,255},90,0.5,1)
			task.Wait(90)
			New(reimu_slowspell1,self.x,self.y,{255,100,100},0,0.8,1.2)
			New(reimu_slowspell1,self.x,self.y,{100,100,255},90,0.8,1.2)
			task.Wait(90)
			New(reimu_slowspell1,self.x,self.y,{255,100,100},0,1,1.4)
			New(reimu_slowspell1,self.x,self.y,{100,100,255},45,1,1.4)
			New(reimu_slowspell1,self.x,self.y,{255,100,100},90,1,1.4)
			New(reimu_slowspell1,self.x,self.y,{100,100,255},135,1,1.4)
			RawDel(self)
		end)
	end

end
function reimu_slow_boundary_summoner:frame()
	self.x,self.y=self.player.x,self.player.y
	self.life=self.life-1
	if self.life<=0 then 
		task.Clear(self) 
		RawDel(self)
		for i=1,4 do
			if IsValid(self.serv[i]) then Kill(self.serv[i]) end
		end	
	end
	task.Do(self)
end



----------------------------------------
---player class

reimu_playerB = Class(player_class)

function reimu_playerB:init(slot)
	reimu_player.load_res_B(self)
	player_class.init(self)
	if not mwy.useMWYwis then
		self._wisys = mwy.PlayerWalkImageSystem(self)
	end  --到时候记得删掉，不然会覆盖你们的自机行走图系统
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
		{ nil, nil, nil, nil }, --0
		{ { 0, 42, 0, 32 }, nil, nil, nil, nil, nil }, --1
		{ { -30, 30, -10, 31 }, { 30, 30, 10, 31 }, nil, nil, nil, nil }, --2
		{ { -36, 0, -20, 29 }, { 0, 42, 0, 32 }, { 36, 0, 20, 29 }, nil, nil, nil }, --3
		{ { -36, -6, -29, 25 }, { -18, 38, -10, 31 }, { 18, 38, 10, 31 }, { 36, -6, 29, 25 }, nil, nil }, --4
		{ { -38, -10, -38, 20 }, { -28, 20, -20, 29 }, { 0, 42, 0, 32 }, { 28, 20, 20, 29 }, { 38, -10, 38, 20 }, nil }, --5
		{ { -38, -10, -45, 13 }, { -28, 20, -29, 25 }, { -10, 42, -10, 31 }, { 10, 42, 10, 31 }, { 28, 20, 29, 25 }, { 38, -10, 45, 13 } }, --6
		{ { -38, -10, -45, 13 }, { -28, 20, -29, 25 }, { -10, 42, -10, 31 }, { 10, 42, 10, 31 }, { 28, 20, 29, 25 }, { 38, -10, 45, 13 } }--6
	}
	self.anglelist = {
		{ -1, -1, -1, -1, -1, -1 }, --0
		{ 90, -1, -1, -1, -1, -1 }, --1
		{ 95, 85, -1, -1, -1, -1 }, --2
		{ 108, 90, 72, -1, -1, -1 }, --3
		{ 105, 95, 85, 75, -1, -1 }, --4
		{ 126, 108, 90, 72, 54, -1 }, --5
		{ 135, 105, 95, 85, 75, 45 }, --6
		{ 135, 105, 95, 85, 75, 45 }, --6
	}
	self.fire_cold = 30
end

local function high_shoot(self)
	--local num = int(lstg.var.power / 100) + 1
	local num = int(self.support) + 1
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
						4 * power_offset[num][1][1],
						1 * power_offset[num][1][2],
						sign)
			end
		end
		self.fire_cold = 30
	end
end

local function slow_shoot(self)
	--local angle = {110,100,80,70,110,70}
	--local num = int(lstg.var.power / 100) + 1
	local num = int(self.support) + 1
	-- Print(num)
	if self.timer % 15 == 0 then
		for i = 1, 6 do
			if self.sp[i] and self.sp[i][3] > 0.5 then
				New(reimu_bullet_purple,
						self.supportx + self.sp[i][1],
						self.supporty + self.sp[i][2],
						self.anglelist[num][i],
						6, 1.0,
						1.0 * power_offset[num][2])
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
	-- do return end
	if self.SpellIndex == 6 then
		New(reimu_slowspell3,self.x,self.y,5,self,int(self.SpellCardHpMax/(1.5*K_SpellDecay)))
	end
	do
		return
	end
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
	local deep = min(int(self.KeyDownTimer1 / 90) + 1, 3) --用于表示符卡持续按下的阶段，<90时为阶段1，每过90增加一个阶段,最多阶段三
	if self.SpellIndex > 3 then
		----------低速符卡
		PlaySound('power1', 0.8)
		K_dr_SlowSpell = 1.25 + K_dr_SpellDmg * lstg.var.dr
		if self.SpellIndex == 4 then
		elseif self.SpellIndex == 5 then
		elseif self.SpellIndex == 6 then
		end
		New(reimu_slow_boundary_summoner,self.SpellIndex-3,self)
		-- New(reimu_slow_boundary_summoner,1,self)
	else
		----------高速符卡
		PlaySound('nep00', 0.8)
		PlaySound('slash', 0.8)
		K_dr_HighSpell = 1.0 + K_dr_SpellDmg * lstg.var.dr
		local n, dmg, index
		index=self.SpellIndex
		if self.SpellIndex == 1 then
			dmg = 0.2
			if deep == 1 then
				n = 3
			elseif deep == 2 then
				n = 6
			elseif deep == 3 then
				n = 10
			end
		elseif self.SpellIndex == 2 then
			dmg = 0.25
			if deep == 1 then
				n = 6
			elseif deep == 2 then
				n = 10
			elseif deep == 3 then
				n = 14
			end
		elseif self.SpellIndex == 3 then
			dmg = 0.35
			if deep == 1 then
				n = 10
			elseif deep == 2 then
				n = 15
			elseif deep == 3 then
				n = 20
			end
		end
		New(reimu_boundary, self.x, self.y, n, 20, dmg*K_dr_HighSpell, index)
	end
	if self.SpellIndex~=6 then self.SpellCardHp = max(0, self.SpellCardHp - K_SpellCost) end
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
	PlaySound('slash', 0.7)
	New(reimu_ccc_gap)
end

