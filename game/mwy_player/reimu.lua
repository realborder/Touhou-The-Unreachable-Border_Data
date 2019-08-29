---=====================================
---东方梦无垠自机系列
---灵梦机体
---Author:Xiliusha
---Email:Xiliusha@outlook.com
---=====================================

local path="mwy_player\\"
local texname="_reimu_texture"
local collibox_scale=1.0--碰撞盒缩放，因为碰撞盒缩放和图片精灵渲染缩放分离了，所以不需要调整

----------------------------------------
---res & player class

reimu_player={}

function reimu_player.load_res(self)
	LoadTexture(texname,path.."reimu.png",false)
	LoadTexture(texname .. "boundary", path .. "reimu_booundary.png", false)

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
	


	LoadImage('reimu_orb_T',texname,512,256,128,128,32,32)
	LoadImageGroup('reimu_orb_T',texname,832,128,192,128,1,4)
	for i=1,4 do SetImageCenter('reimu_orb_T'..i,128,64) SetImageState('reimu_orb_T'..i,'',Color(255,255,255,255)) end
	LoadImage('reimu_orb_M',texname,512,384,256,256,64,64)
	LoadImageGroup('reimu_orb_M',texname,0,640,512,256,2,2)
	for i=1,4 do SetImageCenter('reimu_orb_M'..i,384,128) SetImageState('reimu_orb_M'..i,'',Color(255,255,255,255)) end
	LoadImageFromFile('orb_huge_base',path..'orb_huge_base.png')
	LoadImageFromFile('orb_huge',path..'orb_huge.png',false,500,500)
	LoadImageFromFile('orb_huge_highlight',path..'orb_huge_highlight.png')
	SetImageState('orb_huge_base','',Color(255,255,255,255))
	SetImageState('orb_huge','mul+add',Color(255,255,255,255))
	SetImageState('orb_huge_highlight','mul+add',Color(255,255,255,255))
	LoadPS('reimu_high_spell',path..'reimu_sp_ef.psi','parimg1',32,32)
	LoadImageFromFile('reimu_bomb_ef',path..'reimu_bomb_ef.png')
	-----------------------------------------
	-----------------------------------------
	-- 必杀技所用素材 --
	LoadImageGroup('reimu_ccc_gap',texname,0,128,64*4,64,1,8)
	LoadImageGroup('reimu_ccc_bullet',texname,256,128,64*4,64,1,8,45,5)
	----------------------
	
end

function reimu_player.load_res_B(self)
	reimu_player.load_res(self)
	
	LoadImage("_reimu_high_shoot_big", texname, 576, 0, 128, 128, 48 * collibox_scale, 48 * collibox_scale)
	SetImageState("_reimu_high_shoot_big", "", Color(0x80FFFFFF))
	
	LoadImage("_reimu_high_shoot_big_ef", texname, 576, 0, 128, 128)
	--SetImageState("_reimu_high_shoot_big_ef","",Color(0x80FFFFFF))--渲染的时候会更改透明度
	
	LoadImage("_reimu_high_shoot_small", texname, 704, 0, 64, 64, 16 * collibox_scale, 16 * collibox_scale)
	--SetImageState("_reimu_high_shoot_small","",Color(0x80FFFFFF))--渲染的时候会更改透明度
	
	LoadAnimation("_reimu_high_shoot_small_ef", texname, 768, 0, 64, 64, 2, 2, 4)
	SetAnimationState("_reimu_high_shoot_small_ef", "mul+add", Color(0x80FFFFFF))
	
	LoadAnimation("_reimu_slow_shoot", texname, 512, 128, 128, 64, 2, 2, 4, 16 * collibox_scale, 16 * collibox_scale)
	SetAnimationState("_reimu_slow_shoot", "", Color(0x80FFFFFF))--渲染的时候会更改混合模式
	SetAnimationCenter("_reimu_slow_shoot", 96, 32)
	
	LoadImage("_reimu_support_1", texname, 0, 64, 64, 64)
	LoadImage("_reimu_support_2", texname, 64, 64, 64, 64)
	---符卡


	LoadImage("_reimu_high_spell_ef", texname, 0, 1440, 768, 96)
	LoadImage("_reimu_slow_spell1", texname, 0, 1440, 768, 96)
	
	--LoadImage("_reimu_slow_spell_ef1", texname, 1024, 0, 1024, 1024)
	--LoadImage("_reimu_slow_spell_ef2", texname, 1024, 1024, 1024, 1024)
	
	LoadImage("_reimu_slow_spell_ef1", texname .. "boundary", 512, 0, 512, 512)
	LoadImage("_reimu_slow_spell_ef2", texname .. "boundary", 512, 512, 512, 512)
	LoadImage("_reimu_boundary_spread",texname.."boundary",0,0,512,512)
	LoadImage("_reimu_boundary_4way",texname.."boundary",512,0,512,512)
	LoadImage("_reimu_boundary_4waycenter",texname.."boundary",512,512,512,512)

	LoadImage("_reimu_boundary_8_outside",texname,1024,0,1024,1024)
	LoadImage("_reimu_boundary_8_inside",texname,1024,1024,1024,1024)
	SetImageState("_reimu_boundary_8_outside","mul+add",Color(0xFFFFFFFFF))
	SetImageState("_reimu_boundary_8_inside","mul+add",Color(0xFFFFFFFFF))
	LoadImageFromFile("_reimu_explode_ring",path.."player_explode_ring.png")
	SetImageState("_reimu_explode_ring","mul+add",Color(255,225,108,72))
	-----------------------------------------
	-- 必杀技所用素材 --
	LoadImageGroup('reimu_ccc_gap',texname,0,128,64*4,64,1,8)
	LoadImageGroup('reimu_ccc_bullet',texname,256,128,64*4,64,1,8,45,5)	
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
	self.dmg=0.2
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
	New(bomb_bullet_killer,self.x,self.y,self.a,self.b,false)
end

----------------------------------------
---player

Include(path.."reimuA.lua")
Include(path.."reimuB.lua")
