reimu_player=Class(player_class)

function reimu_player:init(slot)
	LoadTexture('reimu_player','THlib\\player\\reimu\\reimu.png')
	LoadTexture('reimu_player2p','THlib\\player\\reimu\\reimu_2p.png')
	LoadTexture('reimu_kekkai','THlib\\player\\reimu\\reimu_kekkai.png')
	LoadTexture('reimu_orange_ef2','THlib\\player\\reimu\\reimu_orange_eff.png')
	--LoadImageFromFile('reimu_bomb_ef','THlib\\player\\reimu\\reimu_bomb_ef.png')
	LoadAnimation('reimu_bullet_orange_ef2','reimu_orange_ef2',0,0,64,16,1,9,1)
	SetAnimationCenter('reimu_bullet_orange_ef2',0,8)
	LoadImageGroup('reimu_player','reimu_player',0,0,32,48,8,3,0.5,0.5)
	LoadImageGroup('reimu_player2p','reimu_player2p',0,0,32,48,8,3,0.5,0.5)
	LoadImage('reimu_bullet_red','reimu_player',192,160,64,16,16,16)
	SetImageState('reimu_bullet_red','',Color(0xA0FFFFFF))
	SetImageCenter('reimu_bullet_red',56,8)
	LoadAnimation('reimu_bullet_red_ef','reimu_player',0,144,16,16,4,1,4)
	SetAnimationState('reimu_bullet_red_ef','mul+add',Color(0xA0FFFFFF))
	LoadImage('reimu_bullet_blue','reimu_player',0,160,16,16,16,16)
	SetImageState('reimu_bullet_blue','',Color(0x80FFFFFF))
	LoadAnimation('reimu_bullet_blue_ef','reimu_player',0,160,16,16,4,1,4)
	SetAnimationState('reimu_bullet_blue_ef','mul+add',Color(0xA0FFFFFF))
	LoadImage('reimu_support','reimu_player',64,144,16,16)
	LoadImage('reimu_bullet_ef_img','reimu_player',48,144,16,16)
	LoadImage('reimu_kekkai','reimu_kekkai',0,0,256,256,0,0)
	SetImageState('reimu_kekkai','mul+add',Color(0x804040FF))
	LoadPS('reimu_bullet_ef','THlib\\player\\reimu\\reimu_bullet_ef.psi','reimu_bullet_ef_img')
	LoadPS('reimu_sp_ef','THlib\\player\\reimu\\reimu_sp_ef.psi','parimg1',16,16)
	-----------------------------------------
	LoadImage('reimu_bullet_orange','reimu_player',64,176,64,16,64,16)
	SetImageState('reimu_bullet_orange','',Color(0x80FFFFFF))
	SetImageCenter('reimu_bullet_orange',32,8)
	LoadImage('reimu_bullet_orange_ef','reimu_player',64,176,64,16,64,16)
	SetImageState('reimu_bullet_orange_ef','',Color(0x80FFFFFF))
	SetImageCenter('reimu_bullet_orange_ef',32,8)
	-----------------------------------------
	--新旧素材分界
	-----------------------------------------
	local cf=0.5 --colli_fix
	LoadTexture('reimu_bullet','THlib\\player\\reimu\\reimu_bullet.png')
	LoadImage('reimu_orb_T','reimu_bullet',512,256,128,128,64*cf,64*cf)
	LoadImageGroup('reimu_orb_T','reimu_bullet',832,128,192,128,1,4)
	for i=1,4 do SetImageCenter('reimu_orb_T'..i,128,64) SetImageState('reimu_orb_T'..i,'',Color(255,255,255,255)) end
	LoadImage('reimu_orb_M','reimu_bullet',512,384,256,256,128*cf,128*cf)
    LoadImageGroup('reimu_orb_M','reimu_bullet',0,640,512,256,2,2)
    for i=1,4 do SetImageCenter('reimu_orb_M'..i,384,128) SetImageState('reimu_orb_M'..i,'',Color(255,255,255,255)) end
	
	LoadImageFromFile('orb_huge_base','THlib\\player\\reimu\\orb_huge_base.png')
	LoadImageFromFile('orb_huge','THlib\\player\\reimu\\orb_huge.png',false,500*cf,500*cf)
	LoadImageFromFile('orb_huge_highlight','THlib\\player\\reimu\\orb_huge_highlight.png')
	SetImageState('orb_huge_base','',Color(255,255,255,255))
    SetImageState('orb_huge','mul+add',Color(255,255,255,255))
    SetImageState('orb_huge_highlight','mul+add',Color(255,255,255,255))
	
	LoadPS('reimu_high_spell','THlib\\player\\reimu\\reimu_sp_ef.psi','parimg1',32,32)
	LoadImageFromFile('reimu_bomb_ef','THlib\\player\\reimu\\reimu_bomb_ef.png')
	-----------------------------------------
	LoadImage('reimu_main_bullet','reimu_bullet',128,0,128,64,32*cf,32*cf)
	SetImageState('reimu_main_bullet','',Color(0xA0FFFFFF))
	SetImageCenter('reimu_main_bullet',96,32)
	LoadAnimation('reimu_main_bullet_ef','reimu_bullet',256,0,64,64,2,2,4)
	SetAnimationState('reimu_main_bullet_ef','mul+add',Color(0xA0FFFFFF))
	
	LoadImage('reimu_side_bullet','reimu_bullet',384,0,64,64,32*cf,32*cf)
	SetImageState('reimu_side_bullet','',Color(0x80FFFFFF))
	SetImageCenter('reimu_side_bullet',32,32)
	LoadAnimation('reimu_side_bullet_ef','reimu_bullet',448,0,64,64,2,2,4)
	SetAnimationState('reimu_side_bullet_ef','mul+add',Color(0x80FFFFFF))
	
	LoadImage('reimu_side_bullet2','reimu_bullet',128,64,128,64,64*cf,16*cf)
	SetImageState('reimu_side_bullet2','',Color(0x80FFFFFF))
	SetImageCenter('reimu_side_bullet2',64,32)
	LoadImage('reimu_side_bullet_ef2','reimu_bullet',128,64,128,64)
	SetImageState('reimu_side_bullet_ef2','mul+add',Color(0x80FFFFFF))
	-----------------------------------------
	LoadImage('reimu_support1','reimu_bullet',0,0,64,64)
	LoadImage('reimu_support2','reimu_bullet',64,0,64,64)
	LoadImage('reimu_support3','reimu_bullet',0,64,64,64)
	LoadImage('reimu_support4','reimu_bullet',64,64,64,64)
	-----------------------------------------
	LoadImageFromFile('reimu_walkimage','THlib\\player\\reimu\\reimu_walkimage.png')
	LoadImageGroup('reimu_walkimage','reimu_walkimage',0,0,64,96,12,3)
	-----------------------------------------
	-- 必杀技所用素材 --
	LoadImageGroup('reimu_ccc_gap','reimu_bullet',0,128,64*4,64,1,8)
	LoadImageGroup('reimu_ccc_bullet','reimu_bullet',256,128,64*4,64,1,8,90,10)
	
	----------------------
	
	
	
	
	player_class.init(self)
	self.name='Reimu'
	self.hspeed=4.5
	self.imgs={}
	self.A=0.5 self.B=0.5
	if slot and slot==2 and jstg.players[1].name==self.name then
		for i=1,36 do self.imgs[i]='reimu_player2p'..i end
	else
		for i=1,36 do self.imgs[i]='reimu_walkimage'..i end
	end
	self.slist=
	{
		{nil,nil,nil,nil},
		{{0,36,0,24}     ,           nil,         nil,           nil,nil,nil},
		{{-32,0,-12,24}    ,{32,0,12,24}    ,         nil,           nil,nil,nil},
		{{-32,-8,-16,20}   ,{0,-32,0,28}  ,{32,-8,16,20} ,           nil,nil,nil},
		{{-36,-12,-16,20},{-16,-32,-6,28},{16,-32,6,28},{36,-12,16,20},nil,nil},
		{{-40,-16,-16,20},{-30,-28,-6,28},{0,-40,0,32}  ,{30,-28,6,28},{40,-16,16,20},nil},
		{{-40,-12,-16,20},{-25,-26,-12,26},{-10,-40,-6,32} ,{10,-40,6,32},{25,-26,12,26},{40,-12,16,20}},
		{{-40,-12,-16,20},{-25,-26,-12,26},{-10,-40,-6,32} ,{10,-40,6,32},{25,-26,12,26},{40,-12,16,20}},
	}
	self.anglelist=
	{
		{90,90,90,90,90,90},
		{90,90,90,90,90,90},
		{100,80,90,90,80,70},
		{100,90,80,90,80,70},
		{110,100,80,70,90,80},
		{110,100,90,80,70,70},
		{110,100,95,85,80,70},
	}
end
-------------------------------------------------------
function reimu_player:shoot()
	PlaySound('plst00',0.3,self.x/1024)
	self.nextshoot=4
	New(reimu_main_bullet,'reimu_main_bullet',self.x+10,self.y,24,90,2)
	New(reimu_main_bullet,'reimu_main_bullet',self.x-10,self.y,24,90,2)
	if self.support>0 then
		if self.slow==1 then
			for i=1,6 do
				if self.sp[i] and self.sp[i][3]>0.5 then
					New(reimu_side_bullet2,'reimu_side_bullet2',self.supportx+self.sp[i][1]-3,self.supporty+self.sp[i][2],24,90,0.3)
					New(reimu_side_bullet2,'reimu_side_bullet2',self.supportx+self.sp[i][1]+3,self.supporty+self.sp[i][2],24,90,0.3)
				end
			end
		else
--			local num=60/(self.support+1)
		if self.timer%8<4 then
			local num=int(lstg.var.power/100)+1
			for i=1,6 do
				if self.sp[i] and self.sp[i][3]>0.5 then
					New(reimu_side_bullet,'reimu_side_bullet',self.supportx+self.sp[i][1],self.supporty+self.sp[i][2],8,self.anglelist[num][i],self.target,900,0.7)
				end
			end
		end 
		end
	end
end
-------------------------------------------------------
function reimu_player:spell()
	self.collect_line=self.collect_line-300
	New(tasker,function()
		task.Wait(90)
		self.collect_line=self.collect_line+300
	end)
	if self.slow==1 then
		PlaySound('power1',0.8)
		PlaySound('cat00',0.8)
		misc.ShakeScreen(210,3)
--		New(bullet_killer,self.x,self.y)
		New(player_spell_mask,64,64,255,30,210,30)
		K_dr_SlowSpell=1.25 + K_dr_SpellDmg*lstg.var.dr
		New(reimu_kekkai,self.x,self.y,K_dr_SlowSpell,3,20,12) --低速符卡，横坐标，纵坐标，伤害，每帧变化距离，弹数，等待帧数
		self.nextspell=240
		self.protect=360
	else
		PlaySound('nep00',0.8)
		PlaySound('slash',0.8)
		New(player_spell_mask,200,0,0,30,180,30)
		local rot=ran:Int(0,360)
		K_dr_HighSpell=1.0 + K_dr_SpellDmg*lstg.var.dr
		for i=1,8 do
			New(reimu_sp_ef1,'reimu_sp_ef',self.x,self.y,8,rot+i*45,tar1,1200,K_dr_HighSpell,40-10*i,self) --高速符卡，图像，横坐标，纵坐标，速度，角度，目标，控制释放，伤害，控制时间，符卡中心
		end
		self.nextspell=300
		self.protect=360
	end
end
-------------------------------------------------------
function reimu_player:newSpell()
	local deep=min(int(self.KeyDownTimer1/90)+1,3) --用于表示符卡持续按下的阶段，<90时为阶段1，每过90增加一个阶段,最多阶段三
	if self.SpellIndex>3 then            ----------低速符卡
	    PlaySound('power1',0.8)
	    K_dr_SlowSpell=1.25 + K_dr_SpellDmg*lstg.var.dr
		if self.SpellIndex==4 then
		    task.New(player,function()
			    for i=1,9 do
				    --New(reimu_orb_T,player.x,player.y,10,i*20,4+deep,0.7+0.3*deep,0.2,player)
					New(reimu_orb_T,player.x,player.y,5,i*20,4+deep,0.35+0.15*deep,K_dr_SlowSpell,player)
				    task.Wait(5)
			    end
		    end)
		end
		if self.SpellIndex==5 then
		    task.New(player,function()
			    for i=1,3 do
				    --New(reimu_orb_M,player.x,player.y,3,i*45,1+deep,0.7+0.3*deep,1,player)
					New(reimu_orb_M,player.x,player.y,1.5,i*45,1+deep,0.35+0.15*deep,K_dr_SlowSpell*3,player)
				    task.Wait(10)
			    end
		    end)
		end
		if self.SpellIndex==6 then
		    task.New(player,function() 
			    if deep == 1 then
				    --lstg.tmpvar.orb=New(reimu_orb_H,player.x,player.y)
					lstg.tmpvar.orb=New(reimu_orb_H,player.x,player.y,K_dr_SlowSpell*10)
			    end
			    local orb=lstg.tmpvar.orb
			    orb.released = false
			    for i=1,90 do
				    orb.omiga=orb.omiga-0.02
				    orb.s=orb.s+0.0037037*2
				    orb.x=player.x
				    orb.y=player.y+10+225*orb.s
					orb.a=400*orb.s
					orb.b=orb.a
				    task.Wait(1)
			    end
			    orb.released = true
		    end)
		end
	else                            ----------高速符卡
	    PlaySound('nep00',0.8)
		PlaySound('slash',0.8)
		K_dr_HighSpell=1.0 + K_dr_SpellDmg*lstg.var.dr
		local rot=ran:Int(0,360)
		local scale=1.0 local radius=0.8 local n=10
		if self.SpellIndex==2 then scale=1.2 radius=1.0 else if self.SpellIndex==3 then scale=1.4 radius=1.2 end end
		if self.SpellIndex==1 then
		    if deep==1 then n=10 end
			if deep==2 then n=12 end
			if deep==3 then n=14 end
		end
		if self.SpellIndex==2 then
			if deep==1 then n=14 end
			if deep==2 then n=18 end
			if deep==3 then n=22 end
		end
		if self.SpellIndex==3 then
		    if deep==1 then n=10 end
			if deep==2 then n=12 end
			if deep==3 then n=14 end
		end
		for i=1,n do
			New(reimu_sp_ef1,'reimu_sp_ef',self.x,self.y,8,rot+i*(360/n),tar1,1200,K_dr_HighSpell,n*3-6*i,self,scale,radius,1) --高速符卡，图像，横坐标，纵坐标，速度，角度，目标，控制释放，伤害，控制时间，符卡中心
		end
		if self.SpellIndex==3 then
		    for i=1,n do
			    New(reimu_sp_ef1,'reimu_sp_ef',self.x,self.y,8,rot+i*(360/n),tar1,1200,K_dr_HighSpell,n*3-6*i,self,scale,0.6*radius,-1) --高速符卡，图像，横坐标，纵坐标，速度，角度，目标，控制释放，伤害，控制时间，符卡中心
		    end
		end
		--for i=1,18 do
		--	New(reimu_high_spell,'reimu_high_spell',self.x,self.y,8,rot+i*20,tar1,1200,K_dr_HighSpell,self,self.SpellIndex) --高速符卡，图像，横坐标，纵坐标，速度，角度，目标，控制释放，伤害，控制时间，符卡中心
		--end
	end
	
    self.SpellCardHp=max(0,self.SpellCardHp-K_SpellCost)
end
-------------------------------------------------------
function reimu_player:render()
    local n=10 local t=0 local x=1
	if self.slow==1 then x=2 end
    if player.PowerDelay1>0 then
	    n=int(self.support)+1
	    t=player.PowerDelay1*255/180 end
	for i=1,6 do
		if self.sp[i] and self.sp[i][3]>0.5 then
		    if i~=n then Render('reimu_support'..x,self.supportx+self.sp[i][1],self.supporty+self.sp[i][2],self.timer*3)
			else SetImageState('reimu_support'..x,'',Color(t,255,255,255))
			     Render('reimu_support'..x,self.supportx+self.sp[i][1],self.supporty+self.sp[i][2],self.timer*3)
				 SetImageState('reimu_support'..x,'',Color(255,255,255,255)) end
		end
	end
	
	player_class.render(self)
	task.Do(player)
end

-- 释放必杀
function reimu_player:ccc()
	PlaySound('slash',0.7)
	New(reimu_ccc_gap)
end

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
	self.dmg=1
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
end

-------------------------------------------------------
reimu_sp_ef1=Class(object)
function reimu_sp_ef1:init(img,x,y,v,angle,target,trail,dmg,t,player,scale,radius,flag)
	self.killflag=true
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.img=img
	self.vscale=1.2*scale
	self.hscale=1.2*scale
	self.a=self.a*1.2*scale
	self.b=self.b*1.2*scale
	self.x=x
	self.y=y
	self.rot=angle
	self.angle=angle
	self.v=v
	self.target=target
	self.trail=trail
	self.dmg=dmg
	self.DMG=dmg
	self.bound=false
	self.tflag=t
	self.player=player
	self.radius=radius
	self.flag=flag
end
function reimu_sp_ef1:frame()
	if BoxCheck(self,-192,192,-224,224) then self.inscreen=true end
	if self.timer<120+self.tflag then
	self.rot=(self.angle-4*self.timer-90)*self.flag
	self.x=self.timer*1.5*cos(self.rot+90)*self.radius+self.player.x
	self.y=self.timer*1.5*sin(self.rot+90)*self.radius+self.player.y
	end
	player_class.findtarget(self)
	if self.timer>120+self.tflag then
		self.killflag=false
		self.dmg=20
		if IsValid(self.target) and self.target.colli then
		local a=math.mod(Angle(self,self.target)-self.rot+720,360)
		if a>180 then a=a-360 end
		local da=self.trail/(Dist(self,self.target)+1)
		if da>=abs(a) then self.rot=Angle(self,self.target)
		else self.rot=self.rot+sign(a)*da end
		end
		self.vx=8*cos(self.rot)
		self.vy=8*sin(self.rot)
		if self.inscreen then
			if self.x>192 then self.x=192 self.vx=0 self.vy=0 end
			if self.x<-192 then self.x=-192 self.vx=0 self.vy=0 end
			if self.y>224 then self.y=224 self.vx=0 self.vy=0 end
			if self.y<-224 then self.y=-224 self.vx=0 self.vy=0 end
		end
	end
	if self.timer>190 then
		self.killflag=true
		self.dmg=0.4*self.DMG
		self.a=2*self.a
		self.b=2*self.b
		self.vscale=(self.timer-190)*0.5+1
		self.hscale=(self.timer-190)*0.5+1
	end
	if self.timer>200 then
		Kill(self)
	end
	New(bomb_bullet_killer,self.x,self.y,self.a*1.5,self.b*1.5,false)
end

function reimu_sp_ef1:kill()
	misc.ShakeScreen(5,5)
	PlaySound('explode',0.3)
	New(bubble,'parimg12',self.x,self.y,30,4,6,Color(0xFFFFFFFF),Color(0x00FFFFFF),LAYER_ENEMY_BULLET_EF,'')
	local a=ran:Float(0,360)
	for i=1,12 do
		New(reimu_sp_ef2,self.x,self.y,ran:Float(4,6),a+i*30,2,ran:Int(1,3))
	end
	self.vscale=2
	self.hscale=2
--	misc.KeepParticle(self)
end

function reimu_sp_ef1:del()
	PlaySound('explode',0.3)
	New(bubble,'parimg12',self.x,self.y,30,4,6,Color(0xFFFFFFFF),Color(0x00FFFFFF),LAYER_ENEMY_BULLET_EF,'')
--	for i=1,4 do
--		New(reimu_sp_ef2,16,16,self.x,self.y,3,360/16*i,0.25,4,30)
--	end
	misc.KeepParticle(self)
	self.vscale=6
	self.hscale=6
end
-------------------------------------------------------
reimu_sp_ef2=Class(object)

function reimu_sp_ef2:init(x,y,v,angle,scale,index)
	self.img='reimu_bomb_ef'
	self.group=GROUP_GHOST
	self.layer=LAYER_PLAYER_BULLET
	self.colli=false
	self.x=x
	self.y=y
	self.rot=angle
	self.vx=v*cos(angle)
	self.vy=v*sin(angle)
	self.dmg=dmg
	self.hide=false
	self.scale=scale
	self.hscale=scale self.vscale=scale
	self.rbg={{255,0,0},{0,255,0},{0,0,255}}
	self.index=index
--	ParticleSetEmission(self,10)
end

function reimu_sp_ef2:frame()
	self.vscale=self.scale*(1-self.timer/60)
	self.hscale=self.scale*(1-self.timer/60)
	if self.timer>=30 then Del(self) end
end

function reimu_sp_ef2:render()
	SetImageState(self.img,'mul+add',Color(255-255*self.timer/30,self.rbg[self.index][1],self.rbg[self.index][2],self.rbg[self.index][3]))
	Render(self.img,self.x,self.y)
	SetImageState(self.img,'mul+add',Color(255,255,255,255))
end
-------------------------------------------------------
--[[
reimu_bullet_red=Class(player_bullet_straight)

function reimu_bullet_red:kill()
	New(reimu_bullet_red_ef,self.x,self.y,self.rot+180)
end
-------------------------------------------------------
reimu_bullet_red_ef=Class(object)

function reimu_bullet_red_ef:init(x,y)
	self.x=x self.y=y self.rot=90 self.img='reimu_bullet_red_ef' self.layer=LAYER_PLAYER_BULLET+50 self.group=GROUP_GHOST
	self.vy=2.25
end
function reimu_bullet_red_ef:frame()
	if self.timer>14 then self.y=600 Del(self) end
end
-------------------------------------------------------
reimu_bullet_orange=Class(player_bullet_straight)

function reimu_bullet_orange:kill()
	New(reimu_bullet_orange_ef,self.x,self.y,self.rot+180+ran:Float(-15,15))
	New(reimu_bullet_orange_ef2,self.x,self.y)
end
-------------------------------------------------------
reimu_bullet_blue=Class(player_bullet_trail)
function reimu_bullet_blue:init(img,x,y,v,angle,target,trail,dmg)
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

function reimu_bullet_blue:frame()
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

function reimu_bullet_blue:kill()
	New(reimu_bullet_blue_ef,self.x,self.y,self.rot)
end
-------------------------------------------------------
reimu_bullet_blue_ef=Class(object)

function reimu_bullet_blue_ef:init(x,y,rot)
	self.x=x self.y=y self.rot=rot self.img='reimu_bullet_blue_ef' self.layer=LAYER_PLAYER_BULLET+50 self.group=GROUP_GHOST
	self.vx=1*cos(rot) self.vy=1*sin(rot)
end

function reimu_bullet_blue_ef:frame()
	if self.timer>14 then Del(self) end
end
--]]
-------------------------------------------------------
reimu_sp_ef=Class(player_bullet_trail)

function reimu_sp_ef:kill()
	PlaySound('explode',0.3)
	New(bubble,'parimg12',self.x,self.y,30,4,6,Color(0xFFFFFFFF),Color(0x00FFFFFF),LAYER_ENEMY_BULLET_EF,'')
	for i=1,16 do
		New(reimu_sp_ef2,16,16,self.x,self.y,3,360/16*i,0.25,4,30)
	end
	misc.KeepParticle(self)
end

function reimu_sp_ef:del()
	misc.KeepParticle(self)
end
-------------------------------------------------------
--[[
reimu_bullet_ef=Class(object)

function reimu_bullet_ef:init(x,y,rot)
	self.x=x self.y=y self.rot=rot self.img='reimu_bullet_ef' self.layer=LAYER_PLAYER_BULLET+50 self.group=GROUP_GHOST
end

function reimu_bullet_ef:frame()
	if self.timer==4 then ParticleStop(self) end
	if self.timer==30 then Del(self) end
end
-------------------------------------------------------
reimu_bullet_orange_ef=Class(object)

function reimu_bullet_orange_ef:init(x,y,rot)
	self.x=x self.y=y+32 self.rot=rot self.img='reimu_bullet_orange_ef' self.layer=LAYER_PLAYER_BULLET+50 self.group=GROUP_GHOST self.vy=2
	self.hscale=ran:Float(1.4,1.6)
end

function reimu_bullet_orange_ef:frame()
	SetImgState(self,'mul+add',255-255*self.timer/16,255,255,255)
	if self.timer>15 then self.x=600 Del(self) end
end
-------------------------------------------------------
reimu_bullet_orange_ef2=Class(object)

function reimu_bullet_orange_ef2:init(x,y)
	self.x=x self.y=y+32 self.rot=-90+ran:Float(-10,10) self.img='reimu_bullet_orange_ef2' self.layer=LAYER_PLAYER_BULLET+50 self.group=GROUP_GHOST
	self.hscale=ran:Float(1.5,1.8) self.vscale=1.5
end

function reimu_bullet_orange_ef2:frame()
	SetImgState(self,'mul+add',255,255,155,155)
	if self.timer>=9 then self.x=600 Del(self) end
end
--]]
-------------------------------------------------------

reimu_kekkai=Class(object)

function reimu_kekkai:init(x,y,dmg,dr,n,t)
	self.x=x
	self.y=y
	self.dmg=dmg
	SetImageState('reimu_kekkai','mul+add',Color(0x804040FF))
	self.killflag=true
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.r=0
	self.a=0
	self.b=0
	self.dr=dr
	self.ds=dr/256
	self.n=0
	self.mute=true
	self.list={}
	task.New(self,function()
		for i=1,n do
			self.list[i]={scale=0,rot=0}
			self.n=self.n+1
			task.Wait(t)
		end
		self.dmg=0
		PlaySound('slash',1.0)
--		New(bullet_killer,self.x,self.y)
		for i=128,0,-4 do
			SetImageState('reimu_kekkai','mul+add',Color(0x004040FF)+i*Color(0x01000000))
			task.Wait(1)
		end
		Del(self)
	end)
end

function reimu_kekkai:frame()
	task.Do(self)
	if self.timer%6==0 then self.mute=false else self.mute=true end
	self.r=self.r+self.dr
	self.a=self.r
	self.b=self.r
	for i=1,self.n do
		self.list[i].scale=self.list[i].scale+self.ds
		self.list[i].rot=self.list[i].rot+(-1)^i
	end
	New(bomb_bullet_killer,self.x,self.y,self.a/1.25,self.b/1.25,false)
end

function reimu_kekkai:render()
	for i=1,self.n do
		Render('reimu_kekkai',self.x,self.y,self.list[i].rot,self.list[i].scale)
	end
end
-------------------------------------
function reboundCheck(self)--边界反弹仍然需要改的更自然一点
	if not BoxCheck(self,lstg.world.boundl,lstg.world.boundr,lstg.world.boundb,lstg.world.boundt) then
		if self.rebound == nil then return
		elseif self.rebound <= 0 then --这边过完之后rebound就是负的，不会再进这个循环了
			self.bound=true
			--task.New(self, function() task.Wait(5) RawDel(self) end) --避免出屏即消突然不见的尴尬
		else
			if abs(self.y)>224 then
				self.y = sign(self.y)*(224*2-abs(self.y))
				self.rot=-self.rot
			elseif abs(self.x)>196 then
				self.x = sign(self.x)*(196*2-abs(self.x))
				self.rot=sign(self.rot)*(180-abs(self.rot))
			end
		end
		self.rebound = self.rebound - 1
	end
end
-------------------------------------
reimu_main_bullet=Class(player_bullet_straight)

function reimu_main_bullet:kill()
	New(reimu_main_bullet_ef,self.x,self.y,self.rot+180)
end

reimu_main_bullet_ef=Class(object)

function reimu_main_bullet_ef:init(x,y)
	self.x=x self.y=y self.rot=90 self.img='reimu_main_bullet_ef' self.layer=LAYER_PLAYER_BULLET+50 self.group=GROUP_GHOST
	self.vy=2.25
end
function reimu_main_bullet_ef:frame()
	if self.timer>14 then self.y=600 Del(self) end
end
-------------------------------------
reimu_side_bullet=Class(player_bullet_trail)
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
	New(reimu_side_bullet_ef,self.x,self.y,self.rot)
end

reimu_side_bullet_ef=Class(object)

function reimu_side_bullet_ef:init(x,y,rot)
	self.x=x self.y=y self.rot=rot self.img='reimu_side_bullet_ef' self.layer=LAYER_PLAYER_BULLET+50 self.group=GROUP_GHOST
	self.vx=1*cos(rot) self.vy=1*sin(rot)
end

function reimu_side_bullet_ef:frame()
	self.rot=self.rot+15
	self.vscale,self.hscale=self.vscale+0.1,self.hscale+0.1
	if self.timer>14 then Del(self) end
end
-------------------------------------
reimu_side_bullet2=Class(player_bullet_straight)

function reimu_side_bullet2:kill()
	New(reimu_side_bullet_ef2,self.x,self.y,self.rot+180+ran:Float(-15,15))
end

reimu_side_bullet_ef2=Class(object)

function reimu_side_bullet_ef2:init(x,y,rot)
	self.x=x self.y=y+32 self.rot=rot self.img='reimu_side_bullet_ef2' self.layer=LAYER_PLAYER_BULLET+50 self.group=GROUP_GHOST self.vy=2
	self.hscale=ran:Float(1.4,1.6)
end

function reimu_side_bullet_ef2:frame()
	SetImgState(self,'mul+add',255-255*self.timer/16,255,255,255)
	if self.timer>15 then self.x=600 Del(self) end
end
-------------------------------------
--[[
reimu_high_spell=Class(object)
function reimu_high_spell:init(img,x,y,v,angle,target,trail,dmg,player,Index)
	self.group=GROUP_SPELL
	self.layer=LAYER_PLAYER_BULLET
	self.img=img
	self.vscale=2
	self.hscale=2
	self.a=self.a*1.2
	self.b=self.b*1.2
	self.x=x
	self.y=y
	self.rot=angle
	self.angle=angle
	self.v=v
	self.target=target
	self.trail=trail
	self.dmg=dmg
	self.DMG=dmg
	self.bound=false
	self.player=player
	self.Index=Index
	self.colli_timer=-1
	self.ef_timer=-1
end

function reimu_high_spell:frame()
	if BoxCheck(self,-192,192,-224,224) then self.inscreen=true end
	if self.Index==3 then
	    if self.timer<90 then
	        self.rot=self.angle-4*self.timer-90
	        self.x=self.timer*2*cos(self.rot+90)+self.player.x
	        self.y=self.timer*2*sin(self.rot+90)+self.player.y
	    end
	    player_class.findtarget(self)
	    if self.timer>90 then
		    self.dmg=35
		    if IsValid(self.target) and self.target.colli then
		        local a=math.mod(Angle(self,self.target)-self.rot+720,360)
		        if a>180 then a=a-360 end
		        local da=self.trail/(Dist(self,self.target)+1)
		        if da>=abs(a) then self.rot=Angle(self,self.target)
		        else self.rot=self.rot+sign(a)*da end
			end
		end
		self.vx=8*cos(self.rot)
		self.vy=8*sin(self.rot)
	end
	if self.inscreen then
		if self.x>192 then self.x=192 self.vx=0 self.vy=0 end
		if self.x<-192 then self.x=-192 self.vx=0 self.vy=0 end
		if self.y>224 then self.y=224 self.vx=0 self.vy=0 end
		if self.y<-224 then self.y=-224 self.vx=0 self.vy=0 end
	end
	if self.colli_timer>0 then self.colli_timer=self.colli_timer-1 end
	if self.timer>180 or self.colli_timer==0 then
	    if self.ef_timer<0 then self.ef_timer=self.timer end
	    self.colli_timer=-1
		self.dmg=0.4*self.DMG
		self.a=2*self.a
		self.b=2*self.b
		self.vscale=1.6*((self.timer-self.ef_timer)*0.5+1)
		self.hscale=1.6*((self.timer-self.ef_timer)*0.5+1)
	end
	if self.timer>self.ef_timer+10 then Kill(self) end
	New(bomb_bullet_killer,self.x,self.y,self.a*1.5,self.b*1.5,false)
end

function reimu_high_spell:colli(other)
    if other.group==GROUP_ENEMY and self.colli_timer<0 and self.timer>90 then self.colli_timer=15 end
end

function reimu_high_spell:kill()
	misc.ShakeScreen(5,5)
	PlaySound('explode',0.3)
	New(bubble,'parimg12',self.x,self.y,30,4,6,Color(0xFFFFFFFF),Color(0x00FFFFFF),LAYER_ENEMY_BULLET_EF,'')
	local a=ran:Float(0,360)
	for i=1,12 do
		New(reimu_sp_ef2,self.x,self.y,ran:Float(4,6),a+i*30,2,ran:Int(1,3))
	end
	self.vscale=3
	self.hscale=3
--	misc.KeepParticle(self)
end

function reimu_high_spell:del()
	PlaySound('explode',0.3)
	New(bubble,'parimg12',self.x,self.y,30,4,6,Color(0xFFFFFFFF),Color(0x00FFFFFF),LAYER_ENEMY_BULLET_EF,'')
--	for i=1,4 do
--		New(reimu_sp_ef2,16,16,self.x,self.y,3,360/16*i,0.25,4,30)
--	end
	misc.KeepParticle(self)
	self.vscale=8
	self.hscale=8
end

reimu_sp_ef2=Class(object)

function reimu_sp_ef2:init(x,y,v,angle,scale,index)
	self.img='reimu_bomb_ef'
	self.group=GROUP_GHOST
	self.layer=LAYER_PLAYER_BULLET
	self.colli=false
	self.x=x
	self.y=y
	self.rot=angle
	self.vx=v*cos(angle)
	self.vy=v*sin(angle)
	self.dmg=dmg
	self.hide=false
	self.scale=2*scale
	self.hscale=2*scale self.vscale=2*scale
	self.rbg={{255,0,0},{0,255,0},{0,0,255}}
	self.index=index
--	ParticleSetEmission(self,10)
end

function reimu_sp_ef2:frame()
	self.vscale=self.scale*(1-self.timer/60)
	self.hscale=self.scale*(1-self.timer/60)
	if self.timer>=30 then Del(self) end
end

function reimu_sp_ef2:render()
	SetImageState(self.img,'mul+add',Color(255-255*self.timer/30,self.rbg[self.index][1],self.rbg[self.index][2],self.rbg[self.index][3]))
	Render(self.img,self.x,self.y)
	SetImageState(self.img,'mul+add',Color(255,255,255,255))
end
--]]
-------------------------------------
reimu_orb_T = Class(object)
function reimu_orb_T:init(x,y,v,angle,rebound,s,dmg,player)
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.vscale=0
	self.hscale=0
	self.s=s --scale的最终值
	self.a=64
	self.b=64
	self.x=x
	self.y=y
	self.rot=angle
	self.v=v
	self.rebound=rebound
	self.dmg=dmg
	self.bound=false
	self.player=player
	self.img='reimu_orb_T'
	self.imgs='reimu_orb_T1'
	self.killflag=true
end

function reimu_orb_T:frame()
	self.x=self.x+self.v*cos(self.rot)
	self.y=self.y+self.v*sin(self.rot)
	reboundCheck(self)
	if self.timer<=10 then 
	    self.vscale,self.hscale = self.timer/10*self.s,self.timer/10*self.s 
		self.a,self.b = 64*self.timer/10*self.s,64*self.timer/10*self.s 
	end
	self.imgs='reimu_orb_T'..int(self.timer/5%4+1)
	New(bomb_bullet_killer,self.x,self.y,self.a*1.2,self.b*1.2,false)
end

function reimu_orb_T:render()
	Render(self.imgs,self.x,self.y,self.rot,self.vscale)
	Render(self.img,self.x,self.y,self.timer*4,self.vscale)
end
-------------------------------------
reimu_orb_M = Class(object)
function reimu_orb_M:init(x,y,v,angle,rebound,s,dmg,player)
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.vscale=0
	self.hscale=0
	self.s=s --scale的最终值
	self.a=128
	self.b=128
	self.x=x
	self.y=y
	self.rot=angle
	self.v=v
	self.rebound=rebound
	self.dmg=dmg
	self.bound=false
	self.player=player
	self.img='reimu_orb_M'
	self.imgs='reimu_orb_M1'
	self.killflag=true
end

function reimu_orb_M:frame()
	self.x=self.x+self.v*cos(self.rot)
	self.y=self.y+self.v*sin(self.rot)
	reboundCheck(self)
	if self.timer<=10 then 
	    self.vscale,self.hscale = self.timer/10*self.s,self.timer/10*self.s 
		self.a,self.b = 128*self.timer/10*self.s,128*self.timer/10*self.s 
	end
	self.imgs='reimu_orb_M'..int(self.timer/3%4+1)
	New(bomb_bullet_killer,self.x,self.y,self.a*1.2,self.b*1.2,false)
end

function reimu_orb_M:render()
	Render(self.img,self.x,self.y,self.timer*4,self.vscale)
	Render(self.imgs,self.x,self.y,self.rot,self.vscale)
end
-------------------------------------
reimu_orb_H = Class(object)
function reimu_orb_H:init(x,y,dmg)
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.vscale=0
	self.hscale=0
	self.s=0 --scale的最终值
	self.a=128
	self.b=128
	self.x=x
	self.y=y
	self.rot=0
	self.omiga=6
	self.v=v
	self.dmg=dmg
	self.bound=false
	self.player=player
	self.img='orb_huge'
	self.released=false
	self.killflag=true
end

function reimu_orb_H:frame() 
	--self.rot=self.rot+self.omega
	if self.released then 
		--misc.ShakeScreen(2,120)
		self.y=self.y+2
	end 
	New(bomb_bullet_killer,self.x,self.y,self.a*1.2,self.b*1.2,false)
end

function reimu_orb_H:render()
	Render('orb_huge_base',self.x,self.y,self.rot,self.s)
	Render('orb_huge',self.x,self.y,self.rot,self.s)
	Render('orb_huge_highlight',self.x,self.y,0,self.s)
end
