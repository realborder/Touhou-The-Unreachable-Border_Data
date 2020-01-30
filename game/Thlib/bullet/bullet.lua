




local bk=0.5
LoadTexture('bullet1','THlib\\bullet\\bullet1.png',true)
LoadImageGroup('preimg','bullet1',80*2,0,32*2,32*2,1,8)
--for i=1,8 do SetImageState('preimg'..i,'mul+add') end
LoadImageGroup('arrow_big','bullet1',0,0,16*2,16*2,1,16,5*bk,5*bk)
LoadImageGroup('gun_bullet','bullet1',24*2,0,16*2,16*2,1,16,5*bk,5*bk)
LoadImageGroup('gun_bullet_void','bullet1',56*2,0,16*2,16*2,1,16,5*bk,5*bk)
LoadImageGroup('butterfly','bullet1',112*2,0,32*2,32*2,1,8,8*bk,4*bk)
LoadImageGroup('square','bullet1',152*2,0,16*2,16*2,1,16,6*bk,6*bk)
LoadImageGroup('ball_mid','bullet1',176*2,0,32*2,32*2,1,8,8*bk,8*bk)
LoadImageGroup('mildew','bullet1',208*2,0,16*2,16*2,1,16,4*bk,4*bk)
LoadImageGroup('ellipse','bullet1',224*2,0,32*2,32*2,1,8,9*bk,9*bk)

LoadTexture('bullet2','THlib\\bullet\\bullet2.png')
LoadImageGroup('star_small','bullet2',96*2,0,16*2,16*2,1,16,6*bk,6*bk)
LoadImageGroup('star_big','bullet2',224*2,0,32*2,32*2,1,8,11*bk,11*bk)
for i=1,8 do SetImageCenter('star_big'..i,15.5*2,16*2) end
--LoadImageGroup('ball_huge','bullet2',0,0,64,64,1,4,16,16)
--LoadImageGroup('fade_ball_huge','bullet2',0,0,64,64,1,4,16,16)
LoadImageGroup('ball_big','bullet2',192*2,0,32*2,32*2,1,8,16*bk,16*bk)
for i=1,8 do SetImageCenter('ball_big'..i,16*2,16.5*2) end
LoadImageGroup('ball_small','bullet2',176*2,0,16*2,16*2,1,16,4*bk,4*bk)
LoadImageGroup('grain_a','bullet2',160*2,0,16*2,16*2,1,16,5*bk,5*bk)
LoadImageGroup('grain_b','bullet2',128*2,0,16*2,16*2,1,16,5*bk,5*bk)

LoadTexture('bullet3','THlib\\bullet\\bullet3.png')
LoadImageGroup('knife','bullet3',0,0,32*2,32*2,1,8,8*bk,8*bk)
LoadImageGroup('grain_c','bullet3',48*2,0,16*2,16*2,1,16,5*bk,5*bk)
LoadImageGroup('arrow_small','bullet3',80*2,0,16*2,16*2,1,16,5*bk,5*bk)
LoadImageGroup('kite','bullet3',112*2,0,16*2,16*2,1,16,5*bk,5*bk)
LoadImageGroup('fake_laser','bullet3',144*2,0,14*2,16*2,1,16,10*bk,10*bk,true)
for i=1,16 do
	SetImageState('fake_laser'..i,'mul+add')
	SetImageCenter('fake_laser'..i,0,8*2)
end

LoadTexture('bullet4','THlib\\bullet\\bullet4.png')
LoadImageGroup('star_big_b','bullet4',32*2,0,32*2,32*2,1,8,12*bk,12*bk)
LoadImageGroup('ball_mid_b','bullet4',64*2,0,32*2,32*2,1,8,8*bk,8*bk)
for i=1,8 do SetImageState('ball_mid_b'..i,'mul+add',Color(200,200,200,200)) end
LoadImageGroup('arrow_mid','bullet4',96*2,0,32*2,32*2,1,8,7*bk,7*bk)
for i=1,8 do SetImageCenter('arrow_mid'..i,24*2,16*2) end
LoadImageGroup('heart','bullet4',128*2,0,32*2,32*2,1,8,18*bk,18*bk)
LoadImageGroup('knife_b','bullet4',192*2,0,32*2,32*2,1,8,7*bk,7*bk)
for i=1,8 do LoadImage('ball_mid_c'..i,'bullet4',232*2,(i*32-24)*2,16*2,16*2,8*bk,8*bk) end
LoadImageGroup('money','bullet4',168*2,0,16*2,16*2,1,8,8*bk,8*bk)
LoadImageGroup('ball_mid_d','bullet4',168*2,128*2,16*2,16*2,1,8,6*bk,6*bk)
for i=1,8 do SetImageState('ball_mid_d'..i,'mul+add') end
--------ball_light--------
LoadTexture('bullet5','THlib\\bullet\\bullet5.png')
LoadImageGroup('ball_light','bullet5',0,0,64*2,64*2,4,2,23*bk,23*bk)
LoadImageGroup('fade_ball_light','bullet5',0,0,64*2,64*2,4,2,23*bk,23*bk)
LoadImageGroup('ball_light_dark','bullet5',0,0,64*2,64*2,4,2,23*bk,23*bk)
LoadImageGroup('fade_ball_light_dark','bullet5',0,0,64*2,64*2,4,2,23*bk,23*bk)
for i=1,8 do SetImageState('ball_light'..i,'mul+add') end
LoadImageGroup('ball_dark','bullet5',0,256,64*2,64*2,4,2,23*bk,23*bk)
LoadImageGroup('fade_ball_dark','bullet5',0,256,64*2,64*2,4,2,23*bk,23*bk)
LoadImageGroup('ball_dark_dark','bullet5',0,256,64*2,64*2,4,2,23*bk,23*bk)
LoadImageGroup('fade_ball_dark_dark','bullet5',0,256,64*2,64*2,4,2,23*bk,23*bk)
for i=1,8 do SetImageState('ball_dark'..i,'mul+add') end
--------------------------
--------ball_huge---------
LoadTexture('bullet_ball_huge','THlib\\bullet\\bullet_ball_huge.png')
LoadImageGroup('ball_huge','bullet_ball_huge',0,0,64*2,64*2,4,2,27*bk,27*bk)
LoadImageGroup('fade_ball_huge','bullet_ball_huge',0,0,64*2,64*2,4,2,27*bk,27*bk)
LoadImageGroup('ball_huge_dark','bullet_ball_huge',0,0,64*2,64*2,4,2,27*bk,27*bk)
LoadImageGroup('fade_ball_huge_dark','bullet_ball_huge',0,0,64*2,64*2,4,2,27*bk,27*bk)
for i=1,8 do SetImageState('ball_huge'..i,'mul+add') end
LoadImageGroup('ball_huge_rev','bullet_ball_huge',0,0,64*2,64*2,4,2,27*bk,27*bk)
LoadImageGroup('fade_ball_huge_rev','bullet_ball_huge',0,0,64*2,64*2,4,2,27*bk,27*bk)
LoadImageGroup('ball_huge_rev_dark','bullet_ball_huge',0,0,64*2,64*2,4,2,27*bk,27*bk)
LoadImageGroup('fade_ball_huge_rev_dark','bullet_ball_huge',0,0,64*2,64*2,4,2,27*bk,27*bk)
for i=1,8 do SetImageState('ball_huge_rev'..i,'mul+add') end
--------------------------
--------water_drop--------
LoadTexture('bullet_water_drop','THlib\\bullet\\bullet_water_drop.png')
for i=1,8 do
	LoadAnimation('water_drop'..i,'bullet_water_drop',48*(i-1)*2,0,48*2,32*2,1,4,4,8*bk,8*bk)
	SetAnimationState('water_drop'..i,'mul+add')
end
for i=1,8 do LoadAnimation('water_drop_dark'..i,'bullet_water_drop',48*(i-1)*2,0,48*2,32*2,1,4,4,8*bk,8*bk) end
--------------------------
--------music-------------
LoadTexture('bullet_music','THlib\\bullet\\bullet_music.png')
for i=1,8 do
	LoadAnimation('music'..i,'bullet_music',60*(i-1)*2,0,60*2,32*2,1,3,8,8*bk,8*bk)
end
------silence-------------
LoadTexture('bullet6','THlib\\bullet\\bullet6.png')
LoadImageGroup('silence','bullet6',192,0,32,32,1,8,9*bk,9*bk)

--消弹效果
LoadTexture('etbreak','THlib\\bullet\\etbreak.png')
for j=1,16 do
	LoadAnimation('etbreak'..j,'etbreak',0,0,64,64,4,2,3)
end
BulletBreakIndex={
	Color(0xC0FF3030),--red
	Color(0xC0FF30FF),--purple
	Color(0xC03030FF),--blue
	Color(0xA030FFFF),--cyan
	Color(0xA030FF30),--green
	Color(0xA0FFFF30),--yellow
	Color(0xC0FF8030),--orange
	Color(0xC0D0D0D0),--gray
}

for j=1,16 do
	if j%2==0 then
		SetAnimationState('etbreak'..j,'mul+add',BulletBreakIndex[j/2])
	elseif j==15 then
		SetAnimationState('etbreak'..j,'',0.5*BulletBreakIndex[(j+1)/2]+Color(0x60000000))
	else
		SetAnimationState('etbreak'..j,'mul+add',0.5*BulletBreakIndex[(j+1)/2]+Color(0x60000000))
	end
end


--region TUO新弹型
local TUO_bullet_list1={
	--------------------------------------------
	--资源名			横坐标	宽度 	高度		判定a	判定b
	{'riv',			0,		1,		1,		3,		2},
	{'diamond_m',	1,		1,		1,		4,		4},
	{'diamond_l',	2,		1,		1,		6,		6},
	{'diamond_s',	3,		1,		1,		2,		2},
	{'triangle',	4,		1,		1,		3,		3},
	{'flower',		5,		1,		1,		2,		2},
	{'lua',			6,		1,		1,		2,		2},
	{'arrow_w',		7,		1,		1,		4,		4},
	{'clip',		8,		2,		1,		2,		2},
	{'typec',		10,		2,		1,		12,		1.5},
	{'pill',		12,		2,		1,		10,		3.5},
	{'ginkgo',		14,		2,		2,		8,		8},
	--------------------------------------------
}
local TUO_bullet_list2={
	--------------------------------------------
	--资源名			横坐标	宽度 	高度		判定a	判定b
	{'gear_s',		0,		1,		1,		3,		3},
	{'jigsaw_a',	1,		1,		1,		3,		3},
	{'jigsaw_b',	2,		1,		1,		3,		3},
	{'jigsaw_c',	3,		1,		1,		3,		3},
	{'jigsaw_d',	4,		1,		1,		3,		3},
	{'evil_a',		5,		1,		1,		2,		2},
	{'evil_b',		6,		4,		1,		3,		3},
	{'evil_c',		10,		2,		2,		3,		3},
	{'evil_d',		12,		2,		2,		3,		3},
	{'gear_l',		14,		2,		2,		11,		11},
	--------------------------------------------
}
local function LoadBulletRes_TUO()
	LoadTexture('bulletTUO1','THlib\\bullet\\bulletTUO1.png')
	LoadTexture('bulletTUO2','THlib\\bullet\\bulletTUO2.png')
	for i,list in ipairs({TUO_bullet_list1,TUO_bullet_list2}) do
		for _,v in ipairs(list) do
			LoadImageGroup(v[1],'bulletTUO'..i,v[2]*32,0,v[3]*32,v[4]*32,1,16/v[4],v[5],v[6])
		end
	end
	for i=1,16 do
		SetImageCenter('riv'..i,24,16)
		SetImageCenter('triangle'..i,11,16)
		SetImageCenter('lua'..i,20,16)
	end	
	for i=1,8 do
		SetImageCenter('ginkgo'..i,41,16)
	end
end
local function UnloadBulletRes_TUO()
	local pool
	for _,list in ipairs({TUO_bullet_list1,TUO_bullet_list2}) do
		for _,v in ipairs(list) do
			for i=1,16 do
				pool=CheckRes('img',v[1]..i)
				if pool then
					lstg.RemoveResource(pool,2,v[1]..i)
				end
			end
		end
	end
	lstg.RemoveResource('global',1,'bulletTUO1')
	lstg.RemoveResource('global',1,'bulletTUO2')

end

--UnloadBulletRes_TUO()
LoadBulletRes_TUO()
--endregion


--region BulletBreak
BulletBreak=Class(object)

function BulletBreak:init(x,y,index)
	self.x=x
	self.y=y
	self.group=GROUP_GHOST
	self.layer=LAYER_ENEMY_BULLET-50
	self.img='etbreak'..index
	local s = ran:Float(0.9,1)
	self.hscale=s self.vscale=s
	self.rot=ran:Float(0,360)
	--if index%2==0 then
	--	self.color=BulletBreakIndex[index/2]
	--else
	--	self.color=0.5*BulletBreakIndex[(index+1)/2]+Color(0x60000000)
	--end
end

function BulletBreak:frame()
	if self.timer==23 then Del(self) end
end
--endregion

--region bullet
bullet=Class(object)
function bullet:init(imgclass,index,stay,destroyable)
	self.logclass=self.class
	self.imgclass=imgclass
	self.class=imgclass
	if destroyable then self.group=GROUP_ENEMY_BULLET else self.group=GROUP_INDES end
	if type(index)=='number' then
		self.colli=true
		self.stay=stay
		index=int(min(max(1,index),16))
		self.layer=LAYER_ENEMY_BULLET_EF-imgclass.size*0.001+index*0.00001
		self._index=index
		self.index=int((index+1)/2)
	end
	imgclass.init(self,index)
end

function bullet:frame()
	task.Do(self)
end

function bullet:kill()
	local w=lstg.world
	New(item_faith_minor,self.x,self.y)
	if self._index and BoxCheck(self,w.boundl,w.boundr,w.boundb,w.boundt) then New(BulletBreak,self.x,self.y,self._index) end
	if self.imgclass.size==2.0 then
		self.imgclass.del(self)
	end
end
function bullet:del()
--	self.imgclass.del(self)
	local w=lstg.world
	if self.imgclass.size==2.0 then
		self.imgclass.del(self)
	end
	if self._index and BoxCheck(self,w.boundl,w.boundr,w.boundb,w.boundt) then New(BulletBreak,self.x,self.y,self._index) end
end
function bullet:render()
	if self._blend and self._a and self._r and self._g and self._b then
		SetImgState(self,self._blend,self._a,self._r,self._g,self._b)
	end
	DefaultRenderFunc(self)
	if self._blend and self._a and self._r and self._g and self._b then
		SetImgState(self,'',255,255,255,255)
	end
end
--endregion

--region img_class
img_class=Class(object)
function img_class:frame()
	if not self.stay then
		if not(self._forbid_ref) then--by OLC，修正了defaul action死循环的问题
			self._forbid_ref=true
			self.logclass.frame(self)
			self._forbid_ref=nil
		end
	else
		self.x=self.x-self.vx
		self.y=self.y-self.vy
		self.rot=self.rot-self.omiga
	end
	if self.timer==11 then
		self.class=self.logclass
		self.layer=LAYER_ENEMY_BULLET-self.imgclass.size*0.001+self._index*0.00001
--		self.colli=true
		if self.stay then self.timer=-1 end
	end
end
function img_class:del()
	New(bubble2,'preimg'..self.index,self.x,self.y,self.dx,self.dy,11,self.imgclass.size,0,Color(0xFFFFFFFF),Color(0xFFFFFFFF),self.layer,'mul+add')
end
function img_class:kill()
	img_class.del(self)
	New(BulletBreak,self.x,self.y,self._index)
	New(item_faith_minor,self.x,self.y)
end
function img_class:render()
	--更改了发弹动画，但是动画资源出事，不能用Render渲染动画资源
	if self._blend and self.timer<=11 then
		SetImgState(self,self._blend,255*self.timer/11,255,255,255)
	else
		SetImgState(self,'',255*self.timer/11,255,255,255)
	end
	local vs,hs=self.vscale,self.hscale
	self.hscale,self.vscale=self.hscale*(3-2*self.timer/11),self.vscale*(3-2*self.timer/11)
	DefaultRenderFunc(self)
	self.vscale,self.hscale=vs,hs
	SetImgState(self,'',255,255,255,255)
end
--endregion


function ChangeBulletImage(obj,imgclass,index)
	if obj.class==obj.imgclass then
		obj.class=imgclass
		obj.imgclass=imgclass
	else
		obj.imgclass=imgclass
	end
	obj._index=index
	imgclass.init(obj,obj._index)
end
----------------------------------------------------------------
bullet.gclist = {}
function ChangeBulletHighlight(imgclass,index,on)
	local ble = ''
	if on then ble = 'mul+add' end
	local obj = {}
	imgclass.init(obj,index)
	SetImageState(obj.img,ble,Color(0xFFFFFFFF))
	if not bullet.gclist[imgclass] then bullet.gclist[imgclass]={} end
	bullet.gclist[imgclass][index] = on
end
----------------------------------------------------------------
particle_img=Class(object)
function particle_img:init(index)
	self.layer=LAYER_ENEMY_BULLET
	self.img=index
	self.class=self.logclass
end
function particle_img:del()
	misc.KeepParticle(self)
end
function particle_img:kill()
	particle_img.del(self)
end
----------------------------------------------------------------
--region simple_bullet
arrow_big=Class(img_class)
arrow_big.size=0.6
function arrow_big:init(index)
	self.img='arrow_big'..index
end
----------------------------------------------------------------
arrow_mid=Class(img_class)
arrow_mid.size=0.61
function arrow_mid:init(index)
	self.img='arrow_mid'..int((index+1)/2)
end
----------------------------------------------------------------
gun_bullet=Class(img_class)
gun_bullet.size=0.4
function gun_bullet:init(index)
	self.img='gun_bullet'..index
end
----------------------------------------------------------------
gun_bullet_void=Class(img_class)
gun_bullet_void.size=0.4
function gun_bullet_void:init(index)
	self.img='gun_bullet_void'..index
end
----------------------------------------------------------------
butterfly=Class(img_class)
butterfly.size=0.7
function butterfly:init(index)
	self.img='butterfly'..int((index+1)/2)
end
----------------------------------------------------------------
square=Class(img_class)
square.size=0.8
function square:init(index)
	self.img='square'..index
end
----------------------------------------------------------------
ball_mid=Class(img_class)
ball_mid.size=0.75
function ball_mid:init(index)
	self.img='ball_mid'..int((index+1)/2)
end
----------------------------------------------------------------
ball_mid_b=Class(img_class)
ball_mid_b.size=0.751
function ball_mid_b:init(index)
	self.img='ball_mid_b'..int((index+1)/2)
end
----------------------------------------------------------------
ball_mid_c=Class(img_class)
ball_mid_c.size=0.752
function ball_mid_c:init(index)
	self.img='ball_mid_c'..int((index+1)/2)
end
----------------------------------------------------------------
ball_mid_d=Class(img_class)
ball_mid_d.size=0.753
function ball_mid_d:init(index)
	self.img='ball_mid_d'..int((index+1)/2)
end
----------------------------------------------------------------
money=Class(img_class)
money.size=0.753
function money:init(index)
	self.img='money'..int((index+1)/2)
end
----------------------------------------------------------------
mildew=Class(img_class)
mildew.size=0.401
function mildew:init(index)
	self.img='mildew'..index
end
----------------------------------------------------------------
ellipse=Class(img_class)
ellipse.size=0.701
function ellipse:init(index)
	self.img='ellipse'..int((index+1)/2)
end
----------------------------------------------------------------
star_small=Class(img_class)
star_small.size=0.5
function star_small:init(index)
	self.img='star_small'..index
end
----------------------------------------------------------------
star_big=Class(img_class)
star_big.size=0.998
function star_big:init(index)
	self.img='star_big'..int((index+1)/2)
end
----------------------------------------------------------------
star_big_b=Class(img_class)
star_big_b.size=0.999
function star_big_b:init(index)
	self.img='star_big_b'..int((index+1)/2)
end
----------------------------------------------------------------
--endregion


--region huge_bullet
ball_huge=Class(img_class)
ball_huge.size=2.0
function ball_huge:init(index)
	self.img='ball_huge'..int((index+1)/2)
end
function ball_huge:frame()
	if not self.stay then
		if not(self._forbid_ref) then--by OLC，修正了defaul action死循环的问题
			self._forbid_ref=true
			self.logclass.frame(self)
			self._forbid_ref=nil
		end
	else
		self.x=self.x-self.vx
		self.y=self.y-self.vy
		self.rot=self.rot-self.omiga
	end
	if self.timer==11 then
		self.class=self.logclass
		self.layer=LAYER_ENEMY_BULLET-2.0+self.index*0.00001
		--self.colli=true
		if self.stay then self.timer=-1 end
	end
end
function ball_huge:render()
	SetImageState('fade_'..self.img,'mul+add',Color(255*self.timer/11,255,255,255))
	Render('fade_'..self.img,self.x,self.y,self.rot,(11-self.timer)/11+1)
end
function ball_huge:del()
	New(bubble2,'fade_'..self.img,self.x,self.y,self.dx,self.dy,11,1,0,Color(0xFFFFFFFF),Color(0x00FFFFFF),self.layer,'mul+add')
end
function ball_huge:kill()
	ball_huge.del(self)
end
----------------------------------------------------------------------------
ball_huge_dark=Class(img_class)
ball_huge_dark.size=2.0
function ball_huge_dark:init(index)
	self.img='ball_huge_dark'..int((index+1)/2)
end
function ball_huge_dark:frame()
	if not self.stay then
		if not(self._forbid_ref) then--by OLC，修正了defaul action死循环的问题
			self._forbid_ref=true
			self.logclass.frame(self)
			self._forbid_ref=nil
		end
	else
		self.x=self.x-self.vx
		self.y=self.y-self.vy
		self.rot=self.rot-self.omiga
	end
	if self.timer==11 then
		self.class=self.logclass
		self.layer=LAYER_ENEMY_BULLET-2.0+self.index*0.00001
		--self.colli=true
		if self.stay then self.timer=-1 end
	end
end
function ball_huge_dark:render()
	SetImageState('fade_'..self.img,'',Color(255*self.timer/11,255,255,255))
	Render('fade_'..self.img,self.x,self.y,self.rot,(11-self.timer)/11+1)
end
function ball_huge_dark:del()
	New(bubble2,'fade_'..self.img,self.x,self.y,self.dx,self.dy,11,1,0,Color(0xFFFFFFFF),Color(0x00FFFFFF),self.layer,'')
end
function ball_huge_dark:kill()
	ball_huge.del(self)
end
----------------------------------------------------------------
ball_huge_rev=Class(img_class)
ball_huge_rev.size=2.0
function ball_huge_rev:init(index)
	self.img='_rev'..int((index+1)/2)
end
function ball_huge_rev:frame()
	if not self.stay then
		if not(self._forbid_ref) then
			self._forbid_ref=true
			self.logclass.frame(self)
			self._forbid_ref=nil
		end
	else
		self.x=self.x-self.vx
		self.y=self.y-self.vy
		self.rot=self.rot-self.omiga
	end
	if self.timer==11 then
		self.class=self.logclass
		self.layer=LAYER_ENEMY_BULLET-2.0+self.index*0.00001
		--self.colli=true
		if self.stay then self.timer=-1 end
	end
end
function ball_huge_rev:render()
	SetImageState('fade_'..self.img,'mul+add',Color(255*self.timer/11,255,255,255))
	Render('fade_'..self.img,self.x,self.y,self.rot,(11-self.timer)/11+1)
end
function ball_huge_rev:del()
	New(bubble2,'fade_'..self.img,self.x,self.y,self.dx,self.dy,11,1,0,Color(0xFFFFFFFF),Color(0x00FFFFFF),self.layer,'mul+add')
end
function ball_huge:kill()
	ball_huge.del(self)
end
----------------------------------------------------------------------------
ball_huge_rev_dark=Class(img_class)
ball_huge_rev_dark.size=2.0
function ball_huge_rev_dark:init(index)
	self.img='ball_huge_rev_dark'..int((index+1)/2)
end
function ball_huge_rev_dark:frame()
	if not self.stay then
		if not(self._forbid_ref) then--by OLC，修正了defaul action死循环的问题
			self._forbid_ref=true
			self.logclass.frame(self)
			self._forbid_ref=nil
		end
	else
		self.x=self.x-self.vx
		self.y=self.y-self.vy
		self.rot=self.rot-self.omiga
	end
	if self.timer==11 then
		self.class=self.logclass
		self.layer=LAYER_ENEMY_BULLET-2.0+self.index*0.00001
		--self.colli=true
		if self.stay then self.timer=-1 end
	end
end
function ball_huge_rev_dark:render()
	SetImageState('fade_'..self.img,'',Color(255*self.timer/11,255,255,255))
	Render('fade_'..self.img,self.x,self.y,self.rot,(11-self.timer)/11+1)
end
function ball_huge_rev_dark:del()
	New(bubble2,'fade_'..self.img,self.x,self.y,self.dx,self.dy,11,1,0,Color(0xFFFFFFFF),Color(0x00FFFFFF),self.layer,'')
end
function ball_huge_rev_dark:kill()
	ball_huge.del(self)
end
----------------------------------------------------------------
ball_light=Class(img_class)
ball_light.size=2.0
function ball_light:init(index)
	self.img='ball_light'..int((index+1)/2)
end
function ball_light:frame()
	if not self.stay then
		if not(self._forbid_ref) then--by OLC，修正了defaul action死循环的问题
			self._forbid_ref=true
			self.logclass.frame(self)
			self._forbid_ref=nil
		end
	else
		self.x=self.x-self.vx
		self.y=self.y-self.vy
		self.rot=self.rot-self.omiga
	end
	if self.timer==11 then
		self.class=self.logclass
		self.layer=LAYER_ENEMY_BULLET-2.0+self.index*0.00001
		--self.colli=true
		if self.stay then self.timer=-1 end
	end
end
function ball_light:render()
	SetImageState('fade_'..self.img,'mul+add',Color(255*self.timer/11,255,255,255))
	Render('fade_'..self.img,self.x,self.y,self.rot,(11-self.timer)/11+1)
end
function ball_light:del()
	New(bubble2,'fade_'..self.img,self.x,self.y,self.dx,self.dy,11,1,0,Color(0xFFFFFFFF),Color(0x00FFFFFF),self.layer,'mul+add')
end
function ball_light:kill()
	ball_light.del(self)
end
----------------------------------------------------------------
ball_light_dark=Class(img_class)
ball_light_dark.size=2.0
function ball_light_dark:init(index)
	self.img='ball_light_dark'..int((index+1)/2)
end
function ball_light_dark:frame()
	if not self.stay then
		if not(self._forbid_ref) then--by OLC，修正了defaul action死循环的问题
			self._forbid_ref=true
			self.logclass.frame(self)
			self._forbid_ref=nil
		end
	else
		self.x=self.x-self.vx
		self.y=self.y-self.vy
		self.rot=self.rot-self.omiga
	end
	if self.timer==11 then
		self.class=self.logclass
		self.layer=LAYER_ENEMY_BULLET-2.0+self.index*0.00001
		--self.colli=true
		if self.stay then self.timer=-1 end
	end
end
function ball_light_dark:render()
	SetImageState('fade_'..self.img,'',Color(255*self.timer/11,255,255,255))
	Render('fade_'..self.img,self.x,self.y,self.rot,(11-self.timer)/11+1)
end
function ball_light_dark:del()
	New(bubble2,'fade_'..self.img,self.x,self.y,self.dx,self.dy,11,1,0,Color(0xFFFFFFFF),Color(0x00FFFFFF),self.layer,'')
end
function ball_light_dark:kill()
	ball_light.del(self)
end
----------------------------------------------------------------
ball_dark=Class(img_class)
ball_dark.size=2.0
function ball_dark:init(index)
	self.img='ball_dark'..int((index+1)/2)
end
function ball_dark:frame()
	if not self.stay then
		if not(self._forbid_ref) then--by OLC，修正了defaul action死循环的问题
			self._forbid_ref=true
			self.logclass.frame(self)
			self._forbid_ref=nil
		end
	else
		self.x=self.x-self.vx
		self.y=self.y-self.vy
		self.rot=self.rot-self.omiga
	end
	if self.timer==11 then
		self.class=self.logclass
		self.layer=LAYER_ENEMY_BULLET-2.0+self.index*0.00001
		--self.colli=true
		if self.stay then self.timer=-1 end
	end
end
function ball_dark:render()
	SetImageState('fade_'..self.img,'mul+add',Color(255*self.timer/11,255,255,255))
	Render('fade_'..self.img,self.x,self.y,self.rot,(11-self.timer)/11+1)
end
function ball_dark:del()
	New(bubble2,'fade_'..self.img,self.x,self.y,self.dx,self.dy,11,1,0,Color(0xFFFFFFFF),Color(0x00FFFFFF),self.layer,'mul+add')
end
function ball_dark:kill()
	ball_light.del(self)
end
----------------------------------------------------------------
ball_dark_dark=Class(img_class)
ball_dark_dark.size=2.0
function ball_dark_dark:init(index)
	self.img='ball_dark_dark'..int((index+1)/2)
end
function ball_dark_dark:frame()
	if not self.stay then
		if not(self._forbid_ref) then--by OLC，修正了defaul action死循环的问题
			self._forbid_ref=true
			self.logclass.frame(self)
			self._forbid_ref=nil
		end
	else
		self.x=self.x-self.vx
		self.y=self.y-self.vy
		self.rot=self.rot-self.omiga
	end
	if self.timer==11 then
		self.class=self.logclass
		self.layer=LAYER_ENEMY_BULLET-2.0+self.index*0.00001
		--self.colli=true
		if self.stay then self.timer=-1 end
	end
end
function ball_dark_dark:render()
	SetImageState('fade_'..self.img,'',Color(255*self.timer/11,255,255,255))
	Render('fade_'..self.img,self.x,self.y,self.rot,(11-self.timer)/11+1)
end
function ball_dark_dark:del()
	New(bubble2,'fade_'..self.img,self.x,self.y,self.dx,self.dy,11,1,0,Color(0xFFFFFFFF),Color(0x00FFFFFF),self.layer,'')
end
function ball_dark_dark:kill()
	ball_light.del(self)
end

--endregion

--region special_bullet
ball_big=Class(img_class)
ball_big.size=1.0
function ball_big:init(index)
	self.img='ball_big'..int((index+1)/2)
end
----------------------------------------------------------------
heart=Class(img_class)
heart.size=1.0
function heart:init(index)
	self.img='heart'..int((index+1)/2)
end
----------------------------------------------------------------
ball_small=Class(img_class)
ball_small.size=0.402
function ball_small:init(index)
	self.img='ball_small'..index
end
----------------------------------------------------------------
grain_a=Class(img_class)
grain_a.size=0.403
function grain_a:init(index)
	self.img='grain_a'..index
end
----------------------------------------------------------------
grain_b=Class(img_class)
grain_b.size=0.404
function grain_b:init(index)
	self.img='grain_b'..index
end
----------------------------------------------------------------
grain_c=Class(img_class)
grain_c.size=0.405
function grain_c:init(index)
	self.img='grain_c'..index
end
----------------------------------------------------------------
kite=Class(img_class)
kite.size=0.406
function kite:init(index)
	self.img='kite'..index
end
----------------------------------------------------------------
knife=Class(img_class)
knife.size=0.754
function knife:init(index)
	self.img='knife'..int((index+1)/2)
end
----------------------------------------------------------------
knife_b=Class(img_class)
knife_b.size=0.755
function knife_b:init(index)
	self.img='knife_b'..int((index+1)/2)
end
----------------------------------------------------------------
arrow_small=Class(img_class)
arrow_small.size=0.407
function arrow_small:init(index)
	self.img='arrow_small'..index
end
----------------------------------------------------------------
water_drop=Class(img_class)   --2 4 6 10 12
water_drop.size=0.702
function water_drop:init(index)
	self.img='water_drop'..int((index+1)/2)
	--self.is_ani=true
end
function water_drop:render()
	SetImageState('preimg'..self.index,'mul+add',Color(255*self.timer/11,255,255,255))
	Render('preimg'..self.index,self.x,self.y,self.rot,((11-self.timer)/11*2+1)*self.imgclass.size)
end
----------------------------------------------------------------
water_drop_dark=Class(img_class)   --2 4 6 10 12
water_drop_dark.size=0.702
function water_drop_dark:init(index)
	self.img='water_drop_dark'..int((index+1)/2)
	--self.is_ani=true
end
----------------------------------------------------------------
music=Class(img_class)
music.size=0.8
function music:init(index)
	self.img='music'..int((index+1)/2)
	--self.is_ani=true
end
----------------------------------------------------------------
--silence=Class(img_class)
--silence.size=0.8
--function silence:init(index)
--	self.img='silence'..int((index+1)/2)
--end
----------------------------------------------------------------
--endregion

--region TUO_bullet
for i,list in ipairs({TUO_bullet_list1,TUO_bullet_list2}) do
	for _,v in ipairs(list) do
		local bul=Class(img_class)
		local classname=v[1]
		bul.size=0.5
		if v[4]==2 then
			function bul:init(index)
				self.img=v[1]..int((index+1)/2)
			end
		else
			function bul:init(index)
				self.img=v[1]..index
			end
		end
		_G[classname]=bul
	end
end

arrow_mid=Class(img_class)
arrow_mid.size=0.61
function arrow_mid:init(index)
	self.img='arrow_mid'..int((index+1)/2)
end

--endregion

----------------------------------------------------------------
straight=Class(bullet)
function straight:init(imgclass,index,stay,x,y,v,angle,omiga)
	self.x=x self.y=y
	SetV(self,v,angle,true)
	self.omiga=omiga or 0
	bullet.init(self,imgclass,index,stay,true)
end
----------------------------------------------------------------
straight_indes=Class(bullet)
function straight_indes:init(imgclass,index,stay,x,y,v,angle,omiga)
	self.x=x self.y=y
	SetV(self,v,angle,true)
	self.omiga=omiga or 0
	bullet.init(self,imgclass,index,stay,false)
	self.group=GROUP_INDES
end
----------------------------------------------------------------
straight_495=Class(bullet)
function straight_495:init(imgclass,index,stay,x,y,v,angle,omiga)
	self.x=x self.y=y
	SetV(self,v,angle,true)
	self.omiga=omiga or 0
	bullet.init(self,imgclass,index,stay,true)
end
function straight_495:frame()
	if not self.reflected then
		local world = lstg.world
		local x, y = self.x, self.y
		if y > world.t then
			self.vy = -self.vy
			self.y = world.t * 2 - self.y
			if self.acceleration and self.acceleration.ay then
				self.acceleration.ay = -self.acceleration.ay
			end
			self.rot = -self.rot
			self.reflected = true
			return
		end
		if x > world.r then
			self.vx = -self.vx
			self.x = world.r * 2 - self.x
			if self.acceleration and self.acceleration.ax then
				self.acceleration.ax = -self.acceleration.ax
			end
			self.rot = 180 - self.rot
			self.reflected = true
			return
		end
		if x < world.l then
			self.vx = -self.vx
			self.x = world.l * 2 - self.x
			if self.acceleration and self.acceleration.ax then
				self.acceleration.ax = -self.acceleration.ax
			end
			self.rot = 180 - self.rot
			self.reflected = true
			return
		end
	end
end
----------------------------------------------------------------
bullet_killer=Class(object)
function bullet_killer:init(x,y,kill_indes)
	self.x=x
	self.y=y
	self.group=GROUP_GHOST
	self.hide=true
	self.kill_indes=kill_indes
end
function bullet_killer:frame()
	if self.timer==40 then Del(self) end
	for i,o in ObjList(GROUP_ENEMY_BULLET) do
		if Dist(self,o)<self.timer*20 then Kill(o) end
	end
	if self.kill_indes then
		for i,o in ObjList(GROUP_INDES) do
			if Dist(self,o)<self.timer*20 then Kill(o) end
		end
	end
end
----------------------------------------------------------------
bullet_deleter=Class(object)
function bullet_deleter:init(x,y,kill_indes)
	self.x=x
	self.y=y
	self.group=GROUP_GHOST
	self.hide=true
	self.kill_indes=kill_indes
end
function bullet_deleter:frame()
	if self.timer==60 then Del(self) end
	for i,o in ObjList(GROUP_ENEMY_BULLET) do
		if Dist(self,o)<self.timer*20 then Del(o) end
	end
	if self.kill_indes then
		for i,o in ObjList(GROUP_INDES) do
			if Dist(self,o)<self.timer*20 then Del(o) end
		end
	end
end
--------------------------------------------------------------
bullet_killer_SP=Class(object)
function bullet_killer_SP:init(x,y,kill_indes)
	self.x=x
	self.y=y
	self.group=GROUP_GHOST
	self.hide=false
	self.kill_indes=kill_indes
	self.img='yubi'
end
function bullet_killer_SP:frame()

	self.rot=-6*self.timer
	if self.timer==60 then Del(self) end
	for i,o in ObjList(GROUP_ENEMY_BULLET) do
		if Dist(self,o)<60 then Kill(o) end
	end
	if self.kill_indes then
		for i,o in ObjList(GROUP_INDES) do
			if Dist(self,o)<60 then Kill(o) end
		end
	end
end
--------------------------------------------------------------
bullet_deleter2=Class(object)
function bullet_deleter:init(x,y,kill_indes)
	self.player=Player(self)--by ETC，多玩家时处理
	self.x=self.player.x
	self.y=self.player.y
	self.group=GROUP_GHOST
	self.hide=true
	self.kill_indes=kill_indes
end
function bullet_deleter2:frame()
	self.x=self.player.x
	self.y=self.player.y
	if self.timer==30 then Del(self) end
	for i,o in ObjList(GROUP_ENEMY_BULLET) do
		if Dist(self,o)<self.timer*5 then Del(o) end
	end
	if self.kill_indes then
		for i,o in ObjList(GROUP_INDES) do
			if Dist(self,o)<self.timer*5 then Del(o) end
		end
	end
end
--------------------------------------------------------------
--------------------------------------------------------------
bomb_bullet_killer=Class(object)
function bomb_bullet_killer:init(x,y,a,b,kill_indes)
	self.x=x self.y=y
	self.a=a self.b=b
	if self.a~=self.b then self.rect=true end
	self.group=GROUP_PLAYER
	self.hide=true
	self.kill_indes=kill_indes
end
function bomb_bullet_killer:frame()
	if self.timer==1 then Del(self) end
end
function bomb_bullet_killer:colli(other)
	if self.kill_indes then
		if other.group==GROUP_INDES then
			Kill(other)
		end
	end
	if other.group==GROUP_ENEMY_BULLET then Kill(other) end
end
--------------------------------------------------------------
--------------------------------------------------------------
bomb_bullet_killer2=Class(object)
function bomb_bullet_killer2:init(x,y,a,b,rot,kill_indes,rect)
	self.x=x self.y=y
	self.a=a self.b=b
	self.rot=rot
	if rect then self.rect=true end
	self.group=GROUP_PLAYER
	self.hide=true
	self.kill_indes=kill_indes
end
function bomb_bullet_killer2:frame()
	if self.timer==1 then Del(self) end
end
function bomb_bullet_killer2:colli(other)
	if self.kill_indes then
		if other.group==GROUP_INDES then
			Kill(other)
		end
	end
	if other.group==GROUP_ENEMY_BULLET then Kill(other) end
end
--------------------------------------------------------------
COLOR_DEEP_RED=1
COLOR_RED=2
COLOR_DEEP_PURPLE=3
COLOR_PURPLE=4
COLOR_DEEP_BLUE=5
COLOR_BLUE=6
COLOR_ROYAL_BLUE=7
COLOR_CYAN=8
COLOR_DEEP_GREEN=9
COLOR_GREEN=10
COLOR_CHARTREUSE=11
COLOR_YELLOW=12
COLOR_GOLDEN_YELLOW=13
COLOR_ORANGE=14
COLOR_DEEP_GRAY=15
COLOR_GRAY=16
BULLETSTYLE=
{
	arrow_big,arrow_mid,arrow_small,gun_bullet,butterfly,square,
	ball_small,ball_mid,ball_mid_c,ball_big,ball_huge,ball_light,
	star_small,star_big,grain_a,grain_b,grain_c,kite,knife,knife_b,
	water_drop,mildew,ellipse,heart,money,music,silence,
	water_drop_dark,ball_huge_dark,ball_light_dark,
	ball_huge_rev,ball_huge_rev_dark,ball_dark,ball_dark_dark,
	riv,diamond_m,diamond_l,diamond_s,triangle, flower,lua,arrow_w,clip,typec,pill,ginkgo,
	gear_s,jigsaw_a,jigsaw_b,jigsaw_c,jigsaw_d,evil_a,evil_b,evil_c,evil_d,gear_l
}--30
BULLETSTYLE_TUO={
	riv,diamond_m,diamond_l,diamond_s,triangle, flower,lua,arrow_w,clip,typec,pill,ginkgo,
	gear_s,jigsaw_a,jigsaw_b,jigsaw_c,jigsaw_d,evil_a,evil_b,evil_c,evil_d,gear_l}
--BULLETSTYLE_TUO={'ball_huge_rev','ball_huge_rev_dark','ball_dark','ball_dark_dark',
--'riv','diamond_m','diamond_l','diamond_s','triangle', 'flower','lua','arrow_w','clip','typec','pill','ginkgo',
--'gear_s','jigsaw_a','jigsaw_b','jigsaw_c','jigsaw_d','evil_a','evil_b','evil_c','evil_d','gear_l'}