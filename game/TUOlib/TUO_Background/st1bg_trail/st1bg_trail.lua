st1bg_trail=Class(object)
local PATH='TUOlib\\TUO_Background\\st1bg_trail\\'
function st1bg_trail.LoadRes()
	local _LoadImageFromFile=function(para1,para2,...)
		_LoadImageFromFile(para1,PATH..para2,...)
	end
	_LoadImageFromFile('image:'.."st1bg_road","st1bg_road.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st1bg_tree1","st1bg_tree1.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st1bg_grass1","st1bg_grass1.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st1bg_grass2","st1bg_grass2.png",true,0,0,false,0)
end
function st1bg_trail.UnloadRes()
	_UnloadImageFromFile ('image:'.."st1bg_road")
	_UnloadImageFromFile('image:'.."st1bg_tree1")
	_UnloadImageFromFile('image:'.."st1bg_grass1")
	_UnloadImageFromFile('image:'.."st1bg_grass2")
end
function st1bg_trail:init(summon_from_st4)
	self.summon_from_st4=summon_from_st4
	if not summon_from_st4 then
		background.init(self,false)
		st1bg_trail.LoadRes()
	end
	--resource
	-- LoadImageFromFile('woods_ground','road1.png')
	-- LoadImageFromFile('_woods_leaf','woods_leaf.png')
	SetImageState('image:st1bg_road','',Color(255,255,255,255))
	-- LoadImageFromFile('tree1','tree1.png')
	-- LoadImageFromFile('tree2','tree1.png')
	-- LoadImageFromFile('tree3','tree1.png')
	-- LoadTexture('woods','forest1.png')
	-- LoadImage('grass1','woods',0,0,512,256,0,0)
	-- LoadImage('grass2','woods',0,256,512,256,0,0)
	--set 3d camera and fog
	Set3D('eye',1.5,1,-5)
	Set3D('at',1.5,-0.4,0)
	Set3D('up',0,1,0)
	Set3D('z',1,24)
	Set3D('fovy',0.7)
	Set3D('fog',0.01,0.02,Color(255,63,157,131))
	--
	self.list={0,0,0,0,0,0,0,0}--作用未知
	self.liststart=1--作用未知
	self.listend=0--作用未知
	self.imgs={'image:st1bg_tree1','image:st1bg_tree1','image:st1bg_tree1','image:st1bg_grass1','image:st1bg_grass2'}--作用未知
	self.speed=0.07--即行走速度
	self.interval=0.5--作用未知
	self.acc=self.interval--作用未知
	for i=1,400 do st1bg_trail.frame(self) end

end

rnd=math.random

function st1bg_trail:frame()


	self.acc=self.acc+self.speed
	if self.acc>=self.interval then
		self.acc=self.acc-self.interval
		self.listend=self.listend+1
		self.list[self.listend]={rnd(1,3), 0.9+rnd()*3,0,rnd()*0.2-0.2,0.7+0.3*rnd(),24+0.1*rnd(),ran:Float(-0.5,1.5)+1.5,-2+6,3}--rnd()*0.4-0.2
		self.listend=self.listend+1
		self.list[self.listend]={rnd(1,3),-0.9-rnd()*3,0,rnd()*0.2-0.2,0.7+0.3*rnd(),24+0.1*rnd(),ran:Float(-1.5,0.5)-1.5,-2+6,3}
		self.acc=self.acc-self.interval
		self.listend=self.listend+1
		self.list[self.listend]={rnd(4,5), 1.5+rnd()*2,-1.8+rnd(),rnd()*0.6-0.3,-0.7-0.3*rnd(),24+0.1*rnd(),ran:Float(-0.5,1.5)+2,-2+1,2}--2=1.6
		self.listend=self.listend+1
		self.list[self.listend]={rnd(4,5),-1.5-rnd()*2,-1.8+rnd(),rnd()*0.6-0.3, 0.7+0.3*rnd(),24+0.1*rnd(),ran:Float(-1.5,0.5)-1,-2+1,2}
	end
	for i=self.liststart,self.listend do
		self.list[i][6]=self.list[i][6]-self.speed
	end
	while true do
		if self.list[self.liststart][6]<-6 then
			self.list[self.liststart]=nil
			self.liststart=self.liststart+1
		else break
		end
	end
	--这段是飘叶子的代码，码了
	-- if IsValid(_boss) and _boss.cards[_boss.card_num] and _boss.cards[_boss.card_num].is_sc then
	-- else
		-- if self.timer%15==0 and self.timer>5 then
			-- for i=1,ran:Int(2,7) do
				-- local size=ran:Float(0.5,1.5)
				-- local x=ran:Float(220,240)
				-- local y=ran:Float(-100,480)
				-- local color=Color(125+125*(size-1),ran:Int(225,255),ran:Int(100,155),0)
				-- New(woods_leaf,x,y,size,color)
			-- end
		-- end
	-- end
--	self.list[self.timer%5+1]=ran:Float(-0.2,0.2)
end

function st1bg_trail:render()
	--强行赋值以适配四面
	--还原正作雾化距离拉远的效果
	if self.timer>15 and self.timer<=15+240 then
		Set3D('eye',1.5,1,-5)
		Set3D('at',1.5,-0.4,0)
		Set3D('up',0,1,0)
		Set3D('z',1,24)
		Set3D('fovy',0.7)
		Set3D('fog', 8.3*(self.timer-15)/240, 20*(self.timer-15)/240, Color(255,63,157,131))
	end
	--视角轻微摇晃
	if self.timer>=360 then
		Set3D('eye',1.5,1,-5)
		Set3D('up',0,10,sin((self.timer-360)/5))
		Set3D('at',1.5+0.3*sin((self.timer-360)/2.5),-0.4+0.2*sin((self.timer-360)/5),0)
		Set3D('z',1,24)
		Set3D('fovy',0.7)
		Set3D('fog', 8.3, 20, Color(255,63,157,131))
	end
	SetViewMode'3d'

	local showboss = IsValid(_boss) and (not self.summon_from_st4) --为了在四面节省性能
	if showboss then
        PostEffectCapture()
    end
	if self.summon_from_st4 then
		PushRenderTarget('st4_bg_render_target3')
	end

	RenderClear(lstg.view3d.fog[3])
	for j=0,6 do
		local dz=j*4-math.mod(self.timer*self.speed,4)
		for i=-3,1 do 
			Render4V('image:st1bg_road',i*4,-2,dz,	4+i*4,-2,dz,	4+i*4,-2,-4+dz,	i*4,-2,-4+dz) end
	end
--[[	for j=0,6 do
		local dz=j*4-math.mod(self.timer*self.speed,4)
		for i=-2,1 do
		Render4V('tree1',self.list[i+3],4,-4+dz,self.list[i+3]+1,4,-4+dz,self.list[i+3]+1,0,-4+dz,self.list[i+3],0,-4+dz) end
	end]]
	local dz=0*4-math.mod(self.timer*self.speed,4)
--	Render4V('grass1',0,2,1,2,2,1,2,0,0,0,0,1)
--	Render4V('tree1',0,2,dz,1,2,dz,1,0,dz,0,0,dz)
	for i=self.listend,self.liststart,-1 do
		local p=self.list[i]
--		Render(self.imgs[p[1]],p[2],p[3],p[4]*57,p[5],abs(p[5]),p[6])
		Render4V(self.imgs[p[1]],p[7],p[8],p[6],p[7]+p[9],p[8],p[6],p[7]+p[9],-2,p[6],p[7],-2,p[6])
		--Render(self.imgs[1],0,0,0,1,1,0)
	end
	if self.summon_from_st4 then
		PopRenderTarget('st4_bg_render_target3')
	end
	--boss的背景扭曲效果
	if showboss then
		local x,y = WorldToScreen(_boss.x,_boss.y)
		local x1 = x * screen.scale
		local y1 = (screen.height - y) * screen.scale
		local fxr = _boss.fxr or 163
		local fxg = _boss.fxg or 73
		local fxb = _boss.fxb or 164
		PostEffectApply("boss_distortion", "", {
			centerX = x1,
			centerY = y1,
			size = _boss.aura_alpha*200*lstg.scale_3d,
			color = Color(125,fxr,fxg,fxb),
			colorsize = _boss.aura_alpha*200*lstg.scale_3d,
			arg=1500*_boss.aura_alpha/128*lstg.scale_3d,
			timer = self.timer
        })
	end
	SetViewMode'world'
end


--[[和飘动的叶子有关的代码，码了
woods_leaf=Class(object)
function woods_leaf:init(x,y,size,color)
	self.x=x
	self.y=y
	self.img='_woods_leaf'
	self.size=size
	self.hscale=size
	self.vscale=size
	self.group=GROUP_GHOST
	self.omiga=ran:Float(-3,-2)
	self.layer=LAYER_BG+size
	self.color=color
	self._vx=ran:Float(1,1.7)
	self.bound=false
	self.vx=-size*7
	self.vy=-ran:Float(2,3.5)
end

function woods_leaf:frame()
	task.Do(self)
	self.hscale=self.hscale+self.size/100
	self.vscale=self.vscale+self.size/100
	if self.x<-240 then Del(self) end
end

function woods_leaf:render()
	SetImageState(self.img,"",self.color)
	SetViewMode"world"
	object.render(self)
	SetImageState(self.img,"",Color(255,255,255,255))
end
--]]