local path="TUOlib\\TUO_Player\\"
mwy={}
mwy.useMWYwis=true ---false则会在各个机体的init方法中应用新的行走图系统
local  PlayerWalkImageSystem = plus.Class()
function PlayerWalkImageSystem:init(obj, intv, leftlr, rightlr)
	self.obj = obj
	self.obj.ani_intv = intv or 8
	self.obj.lr = self.obj.lr or 1
	self.leftlr = leftlr or 8
	self.rightlr = rightlr or 8
	self.obj.protect = self.obj.protect or 0
end
function PlayerWalkImageSystem:update(dx)
	local obj = self.obj
	if dx == nil then
		dx = obj.dx
	end
	if dx > 0.5 then
		dx = 1
	elseif dx < -0.5 then
		dx = -1
	else
		dx = 0
	end
	
	if dx == 0 then
		if obj.lr > 1 then
			obj.lr = obj.lr - 1
		end
		if obj.lr < -1 then
			obj.lr = obj.lr + 1
		end
	else
		obj.lr = obj.lr + dx
		if obj.lr > self.rightlr then
			obj.lr = self.rightlr
		end
		if obj.lr < -self.leftlr then
			obj.lr = -self.leftlr
		end
		if obj.lr == 0 then
			obj.lr = obj.lr + dx
		end
	end
end
function PlayerWalkImageSystem:frame(dx)
	local obj = self.obj
	PlayerWalkImageSystem.UpdateImage(obj)
	self:update(dx or 0)
end
function PlayerWalkImageSystem:render()
	local obj = self.obj
	local blend = obj._blend or ""
	local a = obj._alpha or 255
	local r = obj._r or 255
	local g = obj._g or 255
	local b = obj._b or 255
	if obj.protect % 3 == 1 then
		SetImageState(obj.img, blend, Color(a, 0, 0, b))
	else
		SetImageState(obj.img, blend, Color(a, r, g, b))
	end
	Render(obj.img, obj.x, obj.y, obj.rot, obj.hscale, obj.vscale)
end
function PlayerWalkImageSystem:UpdateImage()
	local normaln=12
	local intv=self.ani_intv
	if abs(self.lr) == 1 then
		if self.imgs["normal"] then
			self._wisys.UpdateImageByType(self, "normal")
		else
			self.img = self.imgs[int(self.ani / intv) % normaln + 1]
		end
	elseif self.lr == -self._wisys.leftlr then
		if self.imgs["left"] then
			self._wisys.UpdateImageByType(self, "left2")
		else
			self.img = self.imgs[int(self.ani / intv) % (normaln/2) + normaln*1.5 + 1]
		end
	elseif self.lr == self._wisys.rightlr then
		if self.imgs["right"] then
			self._wisys.UpdateImageByType(self, "right2")
		else
			self.img = self.imgs[int(self.ani / intv) % (normaln/2) + normaln*2.5 + 1]
		end
	elseif self.lr < 0 then
		if self.imgs["left"] then
			self._wisys.UpdateImageByType(self, "left1")
		else
			self.img = self.imgs[normaln - 1 - self.lr]
		end
	elseif self.lr > 0 then
		if self.imgs["right"] then
			self._wisys.UpdateImageByType(self, "right1")
		else
			self.img = self.imgs[normaln*2 - 1 + self.lr]
		end
	end
	self.a = self.A
	self.b = self.B
end
function PlayerWalkImageSystem:UpdateImageByType(t)
	local c1, c2
	if t == "normal" then
		c1 = #self.imgs["normal"]
		self.img = self.imgs["normal"][int(self.ani / 8) % c1 + 1]
	elseif t == "left1" then
		self.img = self.imgs["left"][-1 - self.lr]
	elseif t == "right1" then
		self.img = self.imgs["right"][-1 + self.lr]
	elseif t == "left2" then
		c1 = #self.imgs["left"]
		c2 = self.imgs["left"].ani or int(c1 / 2)
		self.img = self.imgs["left"][int(self.ani / 8) % c2 + (c1 - c2) + 1]
	elseif t == "right2" then
		c1 = #self.imgs["right"]
		c2 = self.imgs["right"].ani or int(c1 / 2)
		self.img = self.imgs["right"][int(self.ani / 8) % c2 + (c1 - c2) + 1]
	end
end
mwy.PlayerWalkImageSystem=PlayerWalkImageSystem

Include(path.."reimu\\reimu.lua")
Include(path.."marisa\\marisa.lua")
Include(path.."sanae\\sanae.lua")
Include(path.."sumireko\\sumireko.lua")
