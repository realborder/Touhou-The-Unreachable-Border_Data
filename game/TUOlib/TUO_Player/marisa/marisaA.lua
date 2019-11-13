---=====================================
---东方梦无垠自机系列
---灵梦A机体
---Author:Xiliusha
---Email:Xiliusha@outlook.com
---=====================================


local RT_NAME="_marisa_blackhole_render_target"
CreateRenderTarget(RT_NAME)
----------------------------------------
---support shoot


--高速拖尾--------------------------------------
local marisa_high_bullet_tail=Class(object)

function marisa_high_bullet_tail:init(master)
	self.master=master
	self.x,self.y=master.x,master.y
	self.img="_marisa_high_shoot_tail"
	self.group=GROUP_GHOST
	self.layer=LAYER_PLAYER_BULLET-50
	ParticleFire(self)
	ParticleSetEmission(self,15)
end

function marisa_high_bullet_tail:frame()
	if IsValid(self.master) then 	self.x,self.y=self.master.x,self.master.y
	else ParticleStop(self) RawDel(self) end
end

--高速消亡--------------------------------------
local marisa_high_bullet_ef=Class(object)

function marisa_high_bullet_ef:init(x,y,dmg)
	self.x=x self.y=y self.dmg=dmg
	self.img="_marisa_high_shoot_ef"
	self.layer=LAYER_PLAYER_BULLET+50
	self.group=GROUP_PLAYER_BULLET
	self.a_init,self.b_init=self.a,self.b
	self.killflag=true
end

function marisa_high_bullet_ef:frame()
	local k=sin(90*self.timer/30)
	self.vscale,self.hscale=1+k,1+k
	self.a=self.a_init*(1+k)/2
	self.b=self.b_init*(1+k)/2
	if self.timer>=30 then self.status="del" end
end

function marisa_high_bullet_ef:render()
	local k=1-self.timer/30
	SetImageState(self.img,"mul+add",Color(125*k,255,255,255))
	Render(self.img,self.x,self.y,self.rot,self.hscale)
end

--高速--------------------------------------
local marisa_high_bullet=Class(player_bullet_straight)

function marisa_high_bullet:init(x,y,v,angle,dmg)
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.img='_marisa_high_shoot'
	self.par=New(marisa_high_bullet_tail,self)
	self.x=x
	self.y=y
	self.rot=angle
	self.vy=v
	self.dmg=dmg
	self.omiga=5
end

function marisa_high_bullet:frame()
end

function marisa_high_bullet:kill()
	New(marisa_high_bullet_ef,self.x,self.y,0.04)
end

--低速消亡--------------------------------------
local marisa_slow_bullet_ef=Class(object)

function marisa_slow_bullet_ef:init(x,y,size)
	self.group=GROUP_GHOST
	self.layer=LAYER_PLAYER_BULLET
	self.img="_marisa_slow_shoot_ef"
	self.x,self.y=x,y
	self.rot=-90
	ParticleFire(self)
	ParticleSetEmission(self,60+20*size)
end

function marisa_slow_bullet_ef:frame()
	if self.timer>=15 then ParticleStop(self) 
	elseif self.timer>=60 then RawDel(self) end
end

--低速拖尾--------------------------------------
local marisa_slow_bullet_tail=Class(object)

function marisa_slow_bullet_tail:init(master)
	self.group=GROUP_GHOST
	self.layer=LAYER_PLAYER_BULLET-50
	self.img="_marisa_slow_shoot_trail"..ran:Int(1,3)
	self.x,self.y=master.x,master.y
	self.master=master
	self.rot=90
end

function marisa_slow_bullet_tail:frame()
	if IsValid(self.master) then self.x,self.y=self.master.x,self.master.y 
	else 
		self.vscale=max(0,self.vscale-0.15) 
		if self.vscale<=0 then RawDel(self) end
	end
end
	
--低速--------------------------------------
local marisa_slow_bullet=Class(object)
--这个子弹自机只会发一个，火力越强子弹越大伤害越高，可能onenote里没描述清楚
function marisa_slow_bullet:init(x,y,v,size,dmg)
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.img='_marisa_slow_shoot'
	self.tail=New(marisa_slow_bullet_tail,self)
	self.x=x
	self.y=y
	self.rot=90
	self.hscale,self.vscale=size,size
	self.vy=v
	self.dmg=dmg*1.08
	self.omiga=5
end
function marisa_slow_bullet:render()
	SetImageState("_marisa_slow_shoot","mul+add",Color(0x60FFFFFF))
	object.render(self)
end
function marisa_slow_bullet:kill()
	New(marisa_slow_bullet_ef,self.x,self.y,self.hscale)
end

--子机行为变更

local render_support=function (self)
	local spimg
	if self.slow==0 then
		spimg="_marisa_support_1"
	elseif self.slow==1 then
		spimg="_marisa_support_2"
	end
	local max_n=6
	for i=1,max_n do
		if self.sp[i] and self.sp[i][3]>0 then
			--使用self.sp[i][3]来进行过渡
			SetImageState(spimg,"",Color(self.sp[i][3]*255,self.sp[i][3]*255,self.sp[i][3]*255,self.sp[i][3]*255))
			Render(spimg,self.sp[i][1],self.sp[i][2],0, 0.7+0.1*sin(self.timer*6))
			SetImageState(spimg,"",Color(255,255,255,255))
		end
	end
end
----------------------------------------
---高速符卡

marisa_stardust=Class(object)
function marisa_stardust:init(x,y,rot,v,dmg,index)
	self.index=index
	self.img="_marisa_slow_shoot"
	self.x,self.y=x,y
	self.rot=rot+ran:Float(-20,20)
	self.dmg=dmg
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.omiga=10
	self.killflag=true
	self.scale=0.9+(ran:Float(0,1)^2)*0.1 --让比例在0.5到1.1之间波动
	self.hscale,self.vscale=0,0
	v=v*(1.5-self.scale)
	self.vx=v*cos(rot)
	self.vy=v*sin(rot)
	-- self.vx=v*cos(rot)*0.4
	-- self.vy=v*sin(rot)*0.4
	-- self.ax=v/100*cos(rot+90)
	-- self.ay=v/100*sin(rot+90)
	self._blend="mul+add"
	self.alpha=0
	self.bkiller_time=ran:Int(0,19)
	if index==1 then self.hue=0 self.brightness=255 --设置色相和亮度，饱和度默认拉满
	elseif index==2 then self.hue=ran:Int(0,256*3-1) self.brightness=100
	elseif index==3 then self.color=Color(0xFFFFF42C) end
	task.New(self,function() 
		for i=1,10 do
			self.hscale,self.vscale=i/10,i/10
			self.alpha=i/10
			task.Wait()
		end
	end)
end
function marisa_stardust:frame()
	task.Do(self)
	if self.timer%20==self.bkiller_time then New(bomb_bullet_killer,self.x,self.y,self.a,self.b,false) end

end

function marisa_stardust:render()
	if Dist(0,0,self.x,self.y)>300 then RawDel(self) end
	if self.index==3 then
		SetImageState(self.img,"mul+add",self.color)
	elseif self.index==1 or self.index==2 then
		local a,r,g,b=255*self.alpha,0,0,0
		if self.hue<256 then
									r,g,b=255-self.hue,self.hue,0
		elseif self.hue<256*2 then
			local hue=self.hue-256
									r,g,b=0,255-hue,hue
		elseif self.hue<256*3 then
			local hue=self.hue-256*2
									r,g,b=hue,0,255-hue
		end
		r=r*(255-self.brightness)/255+self.brightness
		g=g*(255-self.brightness)/255+self.brightness
		b=b*(255-self.brightness)/255+self.brightness
		self.color=Color(a,r,g,b)
		SetImageState(self.img,"mul+add",self.color)
	end
	object.render(self)
end



marisa_stardust_summoner=Class(object)
function marisa_stardust_summoner:init(index,player)
	self.index=index
	self.player=player
	self.life=92
	if IsValid(_last_stardust_summoner) then
		if _last_stardust_summoner.index==index then _last_stardust_summoner.life=_last_stardust_summoner.life+90 RawDel(self) self.hide=true
		else RawDel(_last_stardust_summoner)  _last_stardust_summoner=self end
	else 
		_last_stardust_summoner=self
	end
	
	task.New(self,function()
		local a=0
		local dmg=0.2
		local ways=index+2
		for i=1,3*90 do
			local num=int(2+i/270*2)
			local v=10
			local v_boost=1+i/270*0.7
			local da=3+i/270
				for j=1,ways do
					local ap=0+(360/ways)*j
					for k=1,num do
						New(marisa_stardust,self.x+20*cos(a+ap),self.y+20*sin(a+ap),a+ap,v*v_boost,dmg,index)
					end
				end
			a=a+da
			task.Wait()
		end
	end)

end
function marisa_stardust_summoner:frame()
	self.x,self.y=self.player.x,self.player.y
	self.life=self.life-1
	if self.life<=0 then task.Clear(self) RawDel(self) end
	task.Do(self)
end
------------------------------------------
---低速符卡：黑洞
marisa_star_crack=Class(object)
function marisa_star_crack:init(x,y,rot,v,dmg,hue,master)
	self.img="_marisa_slow_shoot"
	self.x,self.y=x,y
	self.master=master
	self.rot=rot+ran:Float(-20,20)
	self.dmg=dmg
	self.bound=false
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.omiga=10
	self.killflag=true
	self.scale=0.6+(ran:Float(0,1)^2)*0.4 --让比例在0.5到1.1之间波动
	self.hscale,self.vscale=0,0
	-- v=v*(1.5-self.scale)
	self.vx=v*cos(rot)
	self.vy=v*sin(rot)
	self._blend="mul+add"
	self.alpha=0
	self.bkiller_time=ran:Int(0,19)
	self.hue=hue self.brightness=0 --设置色相和亮度，饱和度默认拉满
	task.New(self,function() 
		for i=1,10 do
			self.hscale,self.vscale=i/10,i/10
			self.alpha=i/10
			task.Wait()
		end
	end)
end
function marisa_star_crack:frame()
	task.Do(self)
	if not IsValid(self.master) or self.timer>90 then
		self.alpha=self.alpha-0.08
		if self.alpha<=0 then RawDel(self) end
	end
end
function marisa_star_crack:render()
	local a,r,g,b=255*self.alpha,0,0,0
	if self.hue<256 then
								r,g,b=255-self.hue,self.hue,0
	elseif self.hue<256*2 then
		local hue=self.hue-256
								r,g,b=0,255-hue,hue
	elseif self.hue<256*3 then
		local hue=self.hue-256*2
								r,g,b=hue,0,255-hue
	end
	r=r*(255-self.brightness)/255+self.brightness
	g=g*(255-self.brightness)/255+self.brightness
	b=b*(255-self.brightness)/255+self.brightness
	self.color=Color(a,r,g,b)
	SetImageState(self.img,"mul+add",self.color)
	object.render(self)
end

marisa_star_fog=Class(object)
function marisa_star_fog:init(x,y,rot,v,dmg,hue,master)
	self.img="_marisa_playerA_star_fog"
	self.x,self.y=x,y
	self.master=master
	self.rot=rot+ran:Float(-20,20)
	self.dmg=dmg
	self.bound=false
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.omiga=10
	self.killflag=true
	self.scale=5.6+(ran:Float(0,1)^2)*0.4 --让比例在0.5到1.1之间波动
	self.hscale,self.vscale=0,0
	-- v=v*(1.5-self.scale)
	self.vx=v*cos(rot)
	self.vy=v*sin(rot)
	self._blend="mul+add"
	self.alpha=0
	self.bkiller_time=ran:Int(0,19)
	self.hue=hue self.brightness=0 --设置色相和亮度，饱和度默认拉满
	task.New(self,function() 
		for i=1,10 do
			self.hscale,self.vscale=i/10,i/10
			self.alpha=i/10
			task.Wait()
		end
	end)
end
function marisa_star_fog:frame()
	task.Do(self)
	if not IsValid(self.master) then
		self.alpha=self.alpha-0.08
		if self.alpha<=0 then RawDel(self) end
	end
end
function marisa_star_fog:render()
	local a,r,g,b=255*self.alpha,0,0,0
	if self.hue<256 then
								r,g,b=255-self.hue,self.hue,0
	elseif self.hue<256*2 then
		local hue=self.hue-256
								r,g,b=0,255-hue,hue
	elseif self.hue<256*3 then
		local hue=self.hue-256*2
								r,g,b=hue,0,255-hue
	end
	r=r*(255-self.brightness)/255+self.brightness
	g=g*(255-self.brightness)/255+self.brightness
	b=b*(255-self.brightness)/255+self.brightness
	self.color=Color(a,r,g,b)
	SetImageState(self.img,"mul+add",self.color)
	object.render(self)
end



marisa_render_start=Class(object)
function marisa_render_start:init()
	self.img="img_void"
	self.hide=true
	self.group=GROUP_GHOST
	self.layer=-5000
end
function marisa_render_start:render()
	PushRenderTarget(RT_NAME)
	RenderClear(Color(0x00000000))
end

marisa_render_end=Class(object)
function marisa_render_end:init()
	self.img="img_void"
	self.hide=true
	self.group=GROUP_GHOST
	self.layer=LAYER_ENEMY_BULLET+100
	self.radius=10
end
function marisa_render_end:render()
	PopRenderTarget(RT_NAME)
	local x,y = WorldToScreen(self.x,self.y)
	local x1 = x * screen.scale
	local y1 = (screen.height - y) * screen.scale
	PostEffect(RT_NAME,'_marisa_blackhole','', {
		centerX = x1,
		centerY = y1,
		rad = self.radius
	})

end

marisa_blackhole=Class(object)
function marisa_blackhole:init(x,y,dmg,destx,desty,player,size)
	self.player=player
	self.group=GROUP_PLAYER_BULLET
	self.layer=0
	self.x,self.y=x,y
	self.sx,self.sy=x,y
	self.dmg=dmg
	self.img="img_void"
	self.size=0.1
	self.nsize=size
	self.destx=destx
	self.desty=desty
	self.killflag=true
	self.a,self.b=self.size,self.size
	player.rtobj1.hide=false
	player.rtobj2.hide=false
	task.New(self,function()
		for i=1,45 do
			self.x=self.sx+(self.destx-self.sx)*sin(90*i/45)
			self.y=self.sy+(self.desty-self.sy)*sin(90*i/45)
			player.rtobj1.hide=false
			player.rtobj2.hide=false
			self.size=10*i/45
			task.Wait()
		end
		task.Wait(10)
		for i=1,10 do
			local k=sin(90*i/10)
			self.size=self.nsize*k
			player.rtobj1.hide=false
			player.rtobj2.hide=false
			task.Wait()
		end
		local dmg=self.dmg
		for i=1,90*3-10+35 do
			local k=1+i/(90*3-10)
			self.size=self.nsize*k
			self.dmg=dmg*k
			player.rtobj1.hide=false
			player.rtobj2.hide=false
			task.Wait()
		end
		Kill(self)
		
	end)
end
function marisa_blackhole:frame()
	task.Do(self)
	----星尘
	local hue=256*(2+self.timer/270)
	if self.timer%10==1 then self.player.protect=10 end
	if hue>256*3-1 then hue=hue-256*3 end
	for i=1,3 do
		local a=ran:Float(0,360)
		New(marisa_star_crack,self.x+500*cos(a),self.y+500*sin(a),a+180,0.1,0.01,hue,self)
		New(marisa_star_fog,self.x+500*cos(a),self.y+500*sin(a),a+180,0.1,0.01,hue,self)
	end
	
	----
	local force=0.04
	for j,o in ObjList(GROUP_PLAYER_BULLET) do
		o.x,o.y=o.x+(self.x-o.x)*force,o.y+(self.y-o.y)*force
	end
	for j,o in ObjList(GROUP_NONTJT) do
		if not o._bosssys then  o.x,o.y=o.x+(self.x-o.x)*force,o.y+(self.y-o.y)*force end
	end
	for j,o in ObjList(GROUP_ENEMY) do
		if not o._bosssys then o.x,o.y=o.x+(self.x-o.x)*force,o.y+(self.y-o.y)*force end
	end
	for j,o in ObjList(GROUP_ITEM) do
		o.x,o.y=o.x+(self.x-o.x)*force,o.y+(self.y-o.y)*force
	end
	for j,o in ObjList(GROUP_ENEMY_BULLET) do
		o.x,o.y=o.x+(self.x-o.x)*force,o.y+(self.y-o.y)*force
	end
	New(bomb_bullet_killer,self.x,self.y,self.a,self.b,false)
	self.a,self.b=self.size*1.1,self.size*1.1
	local o=self.player.rtobj2
	o.x,o.y=self.x,self.y
	o.radius=self.size
end
function marisa_blackhole:kill()
	New(marisa_blackhole_ef,self.x,self.y,self.size,self.player) RawDel(self)
end
	
marisa_blackhole_ef=Class(object)
function marisa_blackhole_ef:init(x,y,size,player)
	self.group=GROUP_GHOST
	self.player=player
	self.x,self.y=x,y
	self.dmg=dmg
	self.img="img_void"
	self.size=size
	task.New(self,function()
		local s=self.size
		for i=1,10 do
			self.size=s*(1-i/10)
			player.rtobj1.hide=false
			player.rtobj2.hide=false
			task.Wait()
		end
		player.rtobj1.hide=true
		player.rtobj2.hide=true
		RawDel(self)
	end)
end
function marisa_blackhole_ef:frame()
	task.Do(self)
	local o=self.player.rtobj2
	o.x,o.y=self.x,self.y
	o.radius=self.size
end

-----------------------------------------
----低速符卡：使魔

marisa_stardust2=Class(object)
function marisa_stardust2:init(x,y,rot,v,dmg,index)
	self.index=index
	self.img="_marisa_slow_shoot"
	self.x,self.y=x,y
	self.rot=rot
	self.angle=rot
	self.dmg=dmg
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.omiga=10
	self.killflag=true
	self.scale=0.7+(ran:Float(0,1)^2)*0.1 --让比例在0.5到1.1之间波动
	self.hscale,self.vscale=0,0
	self.nv=v*(1.5-self.scale)
	self.vx=0
	self.vy=0
	-- self.vx=v*cos(rot)*0.4
	-- self.vy=v*sin(rot)*0.4
	-- self.ax=v/100*cos(rot+90)
	-- self.ay=v/100*sin(rot+90)
	self._blend="mul+add"
	self.alpha=0.5
	self.bkiller_time=ran:Int(0,299)
	if index==1 then self.hue=0 self.brightness=255 --设置色相和亮度，饱和度默认拉满
	elseif index==2 then self.hue=ran:Int(0,256*3-1) self.brightness=50
	elseif index==3 then self.color=Color(0xFFFFF42C) end
	task.New(self,function() 
		for i=1,20 do
			self.hscale,self.vscale=i/20*self.scale,i/20*self.scale
			task.Wait()
		end
		for i=1,90 do
			local k=sin(i/90*90)
			local v=self.nv*k
			self.vx=v*cos(self.angle)
			self.vy=v*sin(self.angle)
			task.Wait()
		end
	end)
end
function marisa_stardust2:frame()
	task.Do(self)
	if self.timer%29==self.bkiller_time then New(bomb_bullet_killer,self.x,self.y,self.a,self.b,false) end

end

function marisa_stardust2:render()
	if Dist(0,0,self.x,self.y)>300 then RawDel(self) end
	if self.index==3 then
		SetImageState(self.img,"mul+add",self.color)
	elseif self.index==1 or self.index==2 then
		local a,r,g,b=255*self.alpha,0,0,0
		if self.hue<256 then
									r,g,b=255-self.hue,self.hue,0
		elseif self.hue<256*2 then
			local hue=self.hue-256
									r,g,b=0,255-hue,hue
		elseif self.hue<256*3 then
			local hue=self.hue-256*2
									r,g,b=hue,0,255-hue
		end
		r=r*(255-self.brightness)/255+self.brightness
		g=g*(255-self.brightness)/255+self.brightness
		b=b*(255-self.brightness)/255+self.brightness
		self.color=Color(a,r,g,b)
		SetImageState(self.img,"mul+add",self.color)
	end
	object.render(self)
end

marisa_orb=Class(object)
function marisa_orb:init(x,y,rot,v,da,index)
	self.group=GROUP_GHOST
	self.layer=LAYER_PLAYER_BULLET
	self.index=index
	self.x=x
	self.y=y
	self.rot=rot
	self.v=v
	self.angle=rot
	self.da=da
	self.omiga=5
	self.group=GROUP_GHOST
	self.layer=LAYER_PLAYER_BULLET
	self.img="_marisa_orb"..index
end
function marisa_orb:frame()
	self.vx,self.vy=self.v*cos(self.angle),self.v*sin(self.angle)
	self.angle=self.angle+self.da
	if self.timer%10<3 then
		local a=360/(4-self.index)
		for i=1,4-self.index do
			New(marisa_stardust2,self.x,self.y,self.rot+i*a,5,0.02,self.index)
		end
	end
end



--低速符卡驱动器
marisa_blackhole_summoner=Class(object)
function marisa_blackhole_summoner:init(index,player)
	self.index=index
	self.group=GROUP_GHOST
	self.img="img_void"
	self.player=player
	self.life=92
	if IsValid(_last_blackhole_summoner) then
		if _last_blackhole_summoner.index==index then
			_last_blackhole_summoner.life=_last_blackhole_summoner.life+90 
			RawDel(self) 
			return
		else 
			RawDel(_last_blackhole_summoner)  
			_last_blackhole_summoner=self 
		end
	else 
		_last_blackhole_summoner=self
	end
	if index==3 then
		if not IsValid(self.blackhole) then self.blackhole=New(marisa_blackhole,self.x,self.y,1,self.x,self.y+100,self.player,75) end
	else
		task.New(self, function()
			for i=1,3 do
				local ways=4+4*index
				local da=360/ways
				local dirc=(i%2)*2-1
				for i=1,ways do
					New(marisa_orb,self.x,self.y,self.rot+da*i,5,0.9*dirc,index)
				end
				task.Wait(90)
			end
		end)
	end

end
function marisa_blackhole_summoner:frame()
	self.x,self.y=self.player.x,self.player.y
	self.life=self.life-1
	if self.life<=0 then task.Clear(self) Kill(self) end
	task.Do(self)
end
function marisa_blackhole_summoner:kill()
	if self.index==3 then Kill(self.blackhole) end
end

----------------------------------------
---player class

marisa_playerA = Class(player_class)

function marisa_playerA:init(slot)
	marisa_player.load_res_A(self)
	player_class.init(self)
		if not mwy.useMWYwis then self._wisys=mwy.PlayerWalkImageSystem(self) end  --到时候记得删掉，不然会覆盖你们的自机行走图系统
	self.name = "marisaA"
	self.hspeed = 4.5
	self.rtobj1=New(marisa_render_start)
	self.rtobj2=New(marisa_render_end)
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
	--[[
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
	}]]
end

local function high_shoot(self)
	local num = int(self.support)+1
	if self.timer % 16 <4 then
		--local num = int(lstg.var.power / 100) + 1
		for i = 1, 6 do
			if self.sp[i] and self.sp[i][3] > 0.5 then
				New(marisa_high_bullet,
						self.sp[i][1],
						self.sp[i][2],
						8,
						90,
						0.7)
			end
		end
	end
end

local function slow_shoot(self)
	if self.timer%15<4 then
		local num=0
		for i = 1, 6 do		if self.sp[i] and self.sp[i][3] > 0.5 then		num=num+1		end end
		local size=0.5+num*0.13
		New(marisa_slow_bullet,self.x,self.y,10,0.5+num*0.13,5+num*1.2)
			-- New(marisa_side_bullet2, "_marisa_slow_shoot", self.supportx + self.sp[i][1] - 3, self.supporty + self.sp[i][2], 24, 90, 0.3)
			-- New(marisa_side_bullet2, "_marisa_slow_shoot", self.supportx + self.sp[i][1] + 3, self.supporty + self.sp[i][2], 24, 90, 0.3)
	end
end

function marisa_playerA:shoot()
	self.nextshoot = 4
	marisa_player.main_shoot(self)
	if self.support > 0 then
		if self.slow == 1 then
			slow_shoot(self)
		else
			high_shoot(self)
		end
	end
end

function marisa_playerA:spell()
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
		tuolib.DRP_Sys.K_dr_SlowSpell = 1.25 + tuolib.DRP_Sys.K_dr_SpellDmg * lstg.var.dr
		-- New(marisa_kekkai, self.x, self.y, tuolib.DRP_Sys.K_dr_SlowSpell, 3, 20, 12) --低速符卡，横坐标，纵坐标，伤害，每帧变化距离，弹数，等待帧数
		self.nextspell = 240
		self.protect = 360
	else
		PlaySound('nep00', 0.8)
		PlaySound('slash', 0.8)
		New(player_spell_mask, 200, 0, 0, 30, 180, 30)
		local rot = ran:Int(0, 360)
		tuolib.DRP_Sys.K_dr_HighSpell = 1.0 + tuolib.DRP_Sys.K_dr_SpellDmg * lstg.var.dr
		for i = 1, 8 do
			-- New(marisa_sp_ef1, 'marisa_sp_ef', self.x, self.y, 8, rot + i * 45, tar1, 1200, tuolib.DRP_Sys.K_dr_HighSpell, 40 - 10 * i, self) --高速符卡，图像，横坐标，纵坐标，速度，角度，目标，控制释放，伤害，控制时间，符卡中心
		end
		self.nextspell = 300
		self.protect = 360
	end
end

function marisa_playerA:newSpell()
	--发动符卡攻击
	local deep = min(int(self.KeyDownTimer1 / 90) + 1, 3) --用于指示X键持续按下的时长，<90时为阶段1，每过90增加一个阶段,最多阶段三
	if self.SpellIndex > 3 then
		----------低速符卡
		PlaySound('power1', 0.8)
		tuolib.DRP_Sys.K_dr_SlowSpell = 1.25 + tuolib.DRP_Sys.K_dr_SpellDmg * lstg.var.dr
		New(marisa_blackhole_summoner,self.SpellIndex-3,self)
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
		New(marisa_stardust_summoner,self.SpellIndex,self)

	end
	
	self.SpellCardHp = max(0, self.SpellCardHp - tuolib.DRP_Sys.K_SpellCost)
end

function marisa_playerA:frame()
	task.Do(self)
	player_class.frame(self)
	--计算子机的位置
	local sup=self.support
	local max_n=6
	local i=1
	local E_Dist=24 --每个子机之间的间距
	local magnet=0.18
	if not self.sp then self.sp={} end
	while sup>0 do
		local x_aim,y_aim --子机坐标的目标值
		if not self.sp[i] then self.sp[i]={} end
		if self.slow==0 then --高速下子机行为参照以撒小跟班
			if i==1 then  --第一个子机追着自机走
				x_aim,y_aim=self.x,self.y
			else
				x_aim,y_aim=self.sp[i-1][1],self.sp[i-1][2]
			end
		elseif self.slow==1 then
			x_aim,y_aim=self.x,self.y
		end
		if (not self.sp[i][1]) or (not self.sp[i][2]) then self.sp[i][1]=x_aim self.sp[i][2]=y_aim
		else 
			local dist=Dist(self.sp[i][1],self.sp[i][2],x_aim,y_aim)
			if dist>E_Dist and self.slow==0 then
				local theta=Angle(self.sp[i][1],self.sp[i][2],x_aim,y_aim)+180
				x_aim,y_aim=x_aim+cos(theta)*E_Dist,y_aim+sin(theta)*E_Dist	
				self.sp[i][1]=self.sp[i][1]+(x_aim-self.sp[i][1])*magnet
				self.sp[i][2]=self.sp[i][2]+(y_aim-self.sp[i][2])*magnet
			elseif self.slow==1 then
				self.sp[i][1]=self.sp[i][1]+(x_aim-self.sp[i][1])*magnet
				self.sp[i][2]=self.sp[i][2]+(y_aim-self.sp[i][2])*magnet
			end
		end
		self.sp[i][3]=min(1,sup)
		sup=sup-1	i=i+1
	end
	while i<=max_n do
		if not self.sp[i] then self.sp[i]={} end
		self.sp[i][1],self.sp[i][2],self.sp[i][3]=nil,nil,0
		i=i+1
	end
end

function marisa_playerA:render()
	render_support(self)
	player_class.render(self)
end

function marisa_playerA:ccc()
	PlaySound("slash", 0.7)
	New(marisa_drug_bottle,self.x,self.y,6,100)
end
