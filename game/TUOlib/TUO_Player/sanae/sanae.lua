--------------------
---魔理沙机体
---模板来自Xiliusha


local path="TUOlib\\TUO_Player\\sanae\\"
local texname='sanae_texture'
local collibox_scale=1.0--碰撞盒缩放，因为碰撞盒缩放和图片精灵渲染缩放分离了，所以不需要调整

sanae_player={}

function sanae_player.load_res(self)
	LoadTexture(texname,path..'sanae.png')
	LoadImageGroup('_sanae_ani',texname,0,0,64,96,12,3)
	self.imgs={}
	for i=1,36 do
		self.imgs[i]="_sanae_ani"..i
	end
	
	LoadImage("_sanae_main_shoot",texname,0,288,128,32,32*collibox_scale,20*collibox_scale)
	SetImageCenter("_sanae_main_shoot",96,16)
	SetImageState('_sanae_main_shoot',"",Color(0xA0FFFFFF))
	LoadAnimation("_sanae_main_shoot_ef",texname,64,288,64,32,4,1,4)
	SetAnimationState("_sanae_main_shoot_ef","mul+add",Color(0xA0FFFFFF))
	
	--必杀技所用素材
end

function sanae_player.load_res_A(self)
	sanae_player.load_res(self)
	
	LoadImage("_sanae_high_shoot_snake",texname,380,288,192,32,52*collibox_scale,6*collibox_scale,true)

	LoadImage("_sanae_high_shoot_spell",texname,0,320,64,64,12*collibox_scale,12*collibox_scale,true)
	
	LoadImage("_sanae_support_1",texname,768,0,64,64)
	LoadImage("_sanae_support_2",texname,768,0,64,64)
end

function sanae_player.load_res_B(self)
	sanae_player.load_res(self)
	
	LoadImage("_sanae_high_shoot_frog",texname,64,320,128,128,64*collibox_scale,64*collibox_scale)
	
	LoadImage("_sanae_support_1",texname,768,0,64,64)
	LoadImage("_sanae_support_2",texname,768,0,64,64)
end


function sanae_player.render_support(self)
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
		spimg="_sanae_support_1"
	elseif self.slow==1 then
		spimg="_sanae_support_2"
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

local sanae_main_bullet_ef=Class(object)

function sanae_main_bullet_ef:init(x,y)
	self.x=x self.y=y
	self.rot=90
	self.img="_sanae_main_shoot_ef"
	self.layer=LAYER_PLAYER_BULLET+50
	self.group=GROUP_GHOST
	self.vy=2.25
end

function sanae_main_bullet_ef:frame()
	if self.timer>=15 then
		--self.y=4096
		self.status="del"
	end
end

local sanae_main_bullet=Class(player_bullet_straight)

function sanae_main_bullet:kill()
	New(sanae_main_bullet_ef,
			self.x,self.y,self.rot+180)
end

function sanae_player.main_shoot(self)
	PlaySound("plst00", 0.3, self.x / 768)
	New(sanae_main_bullet, "_sanae_main_shoot", self.x + 10 +3, self.y, 24, 90, 2)
	New(sanae_main_bullet, "_sanae_main_shoot", self.x - 10 +3, self.y, 24, 90, 2)
end

----------------------------------------
---main shoot

Include(path.."sanaeA.lua")
Include(path.."sanaeB.lua")








