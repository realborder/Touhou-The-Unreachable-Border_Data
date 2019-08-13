--------------------
---魔理沙机体
---模板来自Xiliusha


local path="mwy_player\\"
local texname='marisa_texture'
local collibox_scale=1.0--碰撞盒缩放，因为碰撞盒缩放和图片精灵渲染缩放分离了，所以不需要调整

marisa_player={}

function marisa_player.load_res(self)
	LoadTexture(texname,path..'marisa.png')
	LoadImageGroup('_marisa_ani',texname,0,0,64,96,12,3)
	self.imgs={}
	for i=1,36 do
		self.imgs[i]="_marisa_ani"..i
	end
	
	LoadImage("_marisa_main_shoot",texname,0,288,64,48,16*collibox_scale,16*collibox_scale)
	SetImageState('_marisa_main_shoot',"",Color(0xA0FFFFFF))
	LoadAnimation("_marisa_main_shoot_ef",texname,0,288,64,48,4,1,4)
	SetAnimationState("_marisa_main_shoot_ef","mul+add",Color(0xA0FFFFFF))
	
	--必杀技所用素材
	LoadImage("_marisa_drug_bottle",texname,896,576,64*2,64*3,32,32)
	SetImageCenter("_marisa_drug_bottle",64,128)
	LoadPS("_marisa_drug_bottle_eff",path.."marisa_bottle_ef.psi","parimg6")
	LoadImageFromFile("_marisa_explode_ring",path.."player_explode_ring.png")
	SetImageState("_marisa_explode_ring","mul+add",Color(0x5FCEEA))
end

function marisa_player.load_res_A(self)
	marisa_player.load_res(self)
	
	LoadImage("_marisa_high_shoot",texname,768,64,64,64,16*collibox_scale,16*collibox_scale)
	SetImageState("_marisa_high_shoot","mul+add",Color(0x60FFFFFF))
	
	LoadImage("_marisa_high_shoot_ef",texname,896,64,128,128,64,64)
	SetImageState("_marisa_high_shoot_ef","mul+add",Color(0x50FFFFFF))
	
	LoadPS("_marisa_high_shoot_tail",path.."marisa_playerA_highshoot_eff.psi","parimg6")
	
	LoadImage("_marisa_slow_shoot",texname,832,64,64,64,32*collibox_scale,32*collibox_scale)
	SetImageState("_marisa_slow_shoot","mul+add",Color(0x60FFFFFF))
	LoadImageGroup("_marisa_slow_shoot_trail",texname,768,192,256,128,1,3)
	for i=1,3 do 
		SetImageState("_marisa_slow_shoot_trail"..i,"mul+add",Color(0x70FFFFFF)) 
		SetImageCenter("_marisa_slow_shoot_trail"..i,64*3,64)
	end
	
	LoadPS("_marisa_slow_shoot_ef",path.."marisa_playerA_slowshoot_eff.psi","parimg6")
	
	LoadImage("_marisa_support_1",texname,768,0,64,64)
	LoadImage("_marisa_support_2",texname,832,0,64,64)
	----符卡所用素材
	LoadImageFromFile("_marisa_playerA_star_fog",path.."marisa_playerA_star_fog.png")
	LoadFX("_marisa_blackhole","shader\\edge_of_blackhole.fx")
	LoadImage("_marisa_orb2",texname,768,128,64,64)
	LoadImage("_marisa_orb1",texname,768+64,128,64,64)
	SetImageState("_marisa_orb1","mul+add",Color(0xA0FFFFFF))
	SetImageState("_marisa_orb2","mul+add",Color(0xA0FFFFFF))
	
end

function marisa_player.load_res_B(self)
	marisa_player.load_res(self)
	
	LoadImageGroup("_marisa_slowlaser",texname,0,320,64*12/self.slowLaserPartNum,64,self.slowLaserPartNum,1)
	for i=1,self.slowLaserPartNum do SetImageState("_marisa_slowlaser"..i,"mul+add",Color(0xA0FFFFFF)) end
	LoadImage("_marisa_support_1",texname,768+2*64,0,64,64)
	LoadImage("_marisa_support_2",texname,768+3*64,0,64,64)
	LoadTexture("_marisa_highlaser",path.."marisa_highlaser.png")
	--符卡所用素材
	LoadImageGroup("_marisa_ray_bottle",texname,768,576,128,64,1,3,64,64)
	for i=1,3 do SetImageCenter("_marisa_ray_bottle"..i,32,32) end
	LoadImage("_marisa_spark",texname,192,384,64*9,64*6,64*4,64)
	LoadImage("_marisa_spark2",texname,192,384,64*9,64*6,64*4,64)
	SetImageState("_marisa_spark","mul+add",Color(0xA0FFFFFF))
	SetImageState("_marisa_spark2","mul+add",Color(0xFFFFF42C))
	SetImageCenter("_marisa_spark",32,64*3)
	SetImageCenter("_marisa_spark2",32,64*3)
	LoadImage("_marisa_spark_wave",texname,0,384,64*3,64*6,64,128)
	SetImageState("_marisa_spark_wave","mul+add",Color(0xA0FFFFFF))
	LoadImage("_marisa_spark_wave2",texname,0,384,64*3,64*6,64,128)
	SetImageState("_marisa_spark_wave2","mul+add",Color(0xFFFFF42C))
	LoadImage("_marisa_spark_magicsquare",texname,768,768,256,256)
	LoadImage("_marisa_spark_magicring",texname,192,768,64*9,64)
	LoadPS("_marisa_playerB_high_spell_ef1",path.."marisa_playerB_high_spell_ef.psi","parimg6")
	LoadPS("_marisa_playerB_high_spell_ef2",path.."marisa_playerB_high_spell_ef2.psi","parimg6")
	
	
	
end


function marisa_player.render_support(self)
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
		spimg="_marisa_support_1"
	elseif self.slow==1 then
		spimg="_marisa_support_2"
	end
	local max_n=#(self.slist[#self.slist])
	for i=1,max_n do
		if self.sp[i] and self.sp[i][3]>0 then
			--使用self.sp[i][3]来进行过渡
			SetImageState(spimg,"",Color(self.sp[i][3]*255,255,255,255))
			Render(spimg,self.supportx+self.sp[i][1],self.supporty+self.sp[i][2],0,0.7+0.1*sin(self.timer*6))
			SetImageState(spimg,"",Color(255,255,255,255))
		end
	end
	local imgname=""
	if self.shootstate==1 then imgname="preimg6"
	elseif self.shootstate==2 then imgname="preimg3" end
		if imgname~="" then 
		for i=1,max_n do
			if self.sp[i] and self.sp[i][3]>0 then
				SetImageState(imgname,"mul+add",Color(0xA0FFFFFF))
				Render(imgname,self.supportx+self.sp[i][1],self.supporty+self.sp[i]	[2],self.timer*30,0.7+0.1*sin(self.timer*60))
				Render(imgname,self.supportx+self.sp[i][1],self.supporty+self.sp[i][2],self.timer*-30,0.7+0.1*sin(self.timer*60))
				SetImageState(imgname,"mul+add",Color(0xFFFFFFFF))
			end
		end
	end
end


----------------------------------------
---main shoot

local marisa_main_bullet_ef=Class(object)

function marisa_main_bullet_ef:init(x,y)
	self.x=x self.y=y
	self.rot=90
	self.img="_marisa_main_shoot_ef"
	self.layer=LAYER_PLAYER_BULLET+50
	self.group=GROUP_GHOST
	self.vy=2.25
end

function marisa_main_bullet_ef:frame()
	if self.timer>=15 then
		--self.y=4096
		self.status="del"
	end
end

local marisa_main_bullet=Class(player_bullet_straight)

function marisa_main_bullet:kill()
	New(marisa_main_bullet_ef,
			self.x,self.y,self.rot+180)
end

function marisa_player.main_shoot(self)
	PlaySound("plst00", 0.3, self.x / 768)
	New(marisa_main_bullet, "_marisa_main_shoot", self.x + 10 +3, self.y, 24, 90, 2)
	New(marisa_main_bullet, "_marisa_main_shoot", self.x - 10 +3, self.y, 24, 90, 2)
end

--super attack

marisa_drug_bottle_ef=Class(object)

function marisa_drug_bottle_ef:init(x,y)
	self.x,self.y=x,y
	self.img="_marisa_drug_bottle_eff"
	self.group=GROUP_GHOST
	self.layer=LAYER_PLAYER_BULLET+1
	New(marisa_drug_bottle_ef2,self.x,self.y,30)
	ParticleFire(self)
end
function marisa_drug_bottle_ef:frame()
	if self.timer==12 then ParticleStop(self)
	elseif self.timer==30 then RawDel(self) end
end

marisa_drug_bottle=Class(object)

function marisa_drug_bottle:init(x,y,v,dmg)
	self.x,self.y=x,y
	self.img="_marisa_drug_bottle"
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.vy=v
	self.dmg=dmg
	self.omiga=15
end
function marisa_drug_bottle:kill()
	New(marisa_drug_bottle_ef,self.x,self.y)
	New(bullet_cleaner,self.x,self.y, 125, 30, 30, 1)
end

marisa_drug_bottle_ef2=Class(object)
function marisa_drug_bottle_ef2:init(x,y,remainTime)
	self.x,self.y=x,y
	self.img="_marisa_explode_ring"
	self.hscale,self.vscale=0.5,0.5
	self.group=GROUP_GHOST
	self.layer=LAYER_PLAYER_BULLET+50
	task.New(self,function ()
		for i=1,remainTime do
			self.hscale=0.5+sin(i/remainTime)
			self.vscale=self.hscale
		end
	end)
end
function marisa_drug_bottle_ef2:frame()
	task.Do(self)
end


Include(path.."marisaA.lua")
Include(path.."marisaB.lua")




table.insert(player_list, {"MWY Kirisame Marisa A","marisa_playerA","MarisaA"})
table.insert(player_list, {"MWY Kirisame Marisa B","marisa_playerB","MarisaB"})




