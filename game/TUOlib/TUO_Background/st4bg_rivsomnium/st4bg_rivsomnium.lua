---------------------------
--code by janrilw
---------------------------
local PATH='TUOlib\\TUO_Background\\st4bg_rivsomnium\\'
st4bg_rivsomnium=Class(object)

local cracks=Class(object)
local c_pos={
	{218,99},
	{479,120},
	{686,186},
	{158,170},
	{317,289},
	{413,232},
	{595,327},
	{527,237},
	{567,160},
	{160,603},
	{508,626},
	{506,845},
	{606,706}
}
for i=1,#c_pos do
	c_pos[i][1]=c_pos[i][1]/2-196
	c_pos[i][2]=-(c_pos[i][2]/2-224)
end
function cracks:init(index,layer)
	self.index=index
	self.img='st4bg_crack'..index
	self.group=GROUP_ENEMY
	self.a=10
	self.b=10
	self.layer=layer
	self.x=c_pos[index][1]
	self.y=c_pos[index][2]
	local a=math.random(45,135)
	local v=math.random(50,200)/100
	self.vx=cos(a)*v
	self.vy=sin(a)*v
	self.omiga=math.random(-1,1)
	self.ay=-math.random(0.15,0.17)
	self.bound=false
	self.dhs=math.random(0.45,0.75)
end
function cracks:frame()
	if self.y<=-500 then RawDel(self) end
	self.vscale=1-self.dhs*self.timer/60
end
function cracks:render()
	local alpha=min(1,self.timer/60)
	local alpha2=1-min(1,self.timer/60)
	SetImageState(self.img,'',Color((1-alpha)*255*alpha2,255,255,255))
	object.render(self)
	SetImageState(self.img,'mul+add',Color(alpha*255*alpha2,255,255,255))
	object.render(self)
end
cracks[1]=cracks.init
cracks[2]=cracks.del
cracks[3]=cracks.frame
cracks[4]=cracks.render
cracks[5]=cracks.colli
cracks[6]=cracks.kill




function st4bg_rivsomnium:InitPhaseInfo(phase)
	self.phaseinfo=lstg.DoFile(PATH..'_phase_info.lua')
	tuolib.BGHandler.DoPhaseLogic(self,1)
end

function st4bg_rivsomnium.load_res()
	local res_list={
		{'st4bg_tree1','st4bg_tree1.png'},
		{'st4bg_brancch','st4bg_brancch.png'},
		{'st4bg_tree2','st4bg_tree2.png'},
		{'st4bg_cloud','st4bg_cloud.png'},
		{'st4bg_rivsomnium_flow','st4bg_rivsomnium_flow.png'},
	}
	for _,v in pairs(res_list) do
		_LoadImageFromFile(v[1],PATH..v[2],true,0,0,false,0)
	end
	local TEXNAME='st4bg_crack'
	lstg.LoadTexture(TEXNAME,PATH..'st4bg_crack.png',true)
	local coor_temp={
		{942,0,436,204},
		{1378,0,369,236},
		{1852,0,196,362},
		{963,789,321,308},
		{0,0,433,155},
		{1747,171,105,65},
		{433,0,378,204},
		{1694,236,158,51},
		{1747,0,105,171},
		{983,204,321,585},
		{1490,462,558,541},
		{1490,362,558,100},
		{1693,1003,355,308},
		{942,0,436,204}
	}
	for i=1,#coor_temp do
		lstg.LoadImage('st4bg_crack'..i,TEXNAME,coor_temp[i][1],coor_temp[i][2],coor_temp[i][3],coor_temp[i][4])
	end
	lstg.LoadImage('st4bg_crack_b1',TEXNAME,0,1152,784,896)
	lstg.LoadImage('st4bg_crack_b2',TEXNAME,784,1152,784,896)
	lstg.LoadImage('st4bg_crack_b3',TEXNAME,0,256,784,896)

	
end
function st4bg_rivsomnium:init(phase)
	background.init(self,false)
	st4bg_rivsomnium.load_res()
	self.speed=0.03--即行走速度
	self.xpos=0--等效的摄像机x轴位置,x轴方向向前
	st4bg_rivsomnium.InitPhaseInfo(self,phase)
	SetImageState('st4bg_tree1','',Color(0xFFFFFFFF))
	SetImageState('st4bg_tree2','',Color(0xFFFFFFFF))
end

function st4bg_rivsomnium:frame()
	self.xpos=self.xpos-self.speed

	tuolib.BGHandler.DoPhaseLogic(self)

	task.Do(self)
end

function st4bg_rivsomnium:render()
	SetViewMode'3d'
	tuolib.BGHandler.Apply3DParamater(self)
	local phase=tuolib.BGHandler.GetCurPhase(self)
	local showboss = IsValid(_boss)

	if showboss then background.WarpEffectCapture() end
	RenderClear(Color(255,self.cur.fogc[1],self.cur.fogc[2],self.cur.fogc[3]))

	--以上是固定要放进去的代码
	--下面是渲染
	-- local x=self.xpos%1
	local rfv=Render4V

	if phase<=6 then
		local z=0
		local dy=2.5
		local dx=dy*1.1
		local dr=sqrt(dx^2+dy^2)

		if self.cur.eye[3]<0 then
			local c=255*min(60,self.timer)/60
			RenderClear(Color(255,c,c,c))
			rfv('st4bg_tree1',dx,-dy,z,dx,dy,z,-dx,dy,z,-dx,-dy,z)
			for z=-0.5,-3.5,-1 do
				local dx=dx+(dr)*cos(-z*360)*0.25
				local dy=dy+(dr)*sin(-z*360)*0.25
				rfv('st4bg_brancch',dx,-dy,z,dx,dy,z,-dx,dy,z,-dx,-dy,z)
			end
		else
			local dddx=0
			if phase>=5 then
				dddx=(self.xpos*0.25)%(dx*2)
			end
			for ddx=-4*dx,4*dx,dx*2 do
				for ddy=-4*dy,4*dy,dy*2 do
					rfv('st4bg_tree2',dddx+ddx+dx,ddy-dy,z,dddx+ddx+dx,ddy+dy,z,dddx+ddx-dx,ddy+dy,z,dddx+ddx-dx,ddy-dy,z)
				end
			end
			local x,dx=10,(-self.xpos)%10
			local y=5
			for z=1.5,2.5,0.05 do
				SetImageState('st4bg_cloud','',Color(255*(1-abs(z-2))^3,255,255,255))
				for ddx=-10,10,10 do
					for ddy=-10,10,10 do
						rfv('st4bg_cloud',x-dx+ddx,y+ddy,z,-dx+ddx,y+ddy,z,-dx+ddx,-y+ddy,z,x-dx+ddx,-y+ddy,z)
					end
				end
			end
			if phase==6 then
				local time_end=self.phaseinfo[6].duration-1
				local time={time_end-60*3,time_end-60*2,time_end-60,time_end}
				local t=self.timer-self.phaseinfo[6].time
				SetViewMode'world'
				if t>=time[1] and t<time[2] then
					if t==time[1] then misc.ShakeScreen(30,3) end
					Render('st4bg_crack_b1',0,0)
				elseif t>=time[2] and t<time[3] then
					if t==time[2] then  misc.ShakeScreen(30,3) end
					Render('st4bg_crack_b2',0,0)
				elseif t>=time[3] and t<time[4] then
					if t==time[3] then misc.ShakeScreen(30,3) end
					Render('st4bg_crack_b3',0,0)
				elseif t==time[4] then
					misc.ShakeScreen(60,5)
					for i=1,#c_pos do
						New(cracks,i,self.layer)
					end
				end
				SetViewMode'3d'
			end
		end
	elseif phase>=7 then
		for i=1,3 do
			local speed=1+0.5*sin(60*i-45)
			local x,dx=10,(-self.xpos*speed)%10
			local dddy=speed*5
			local y=5
			for z=i-0.5,i+0.5,0.1 do
				SetImageState('st4bg_rivsomnium_flow','mul+add',Color(15*(1-(abs(z-i)*2)^8),20,255,255))
				for ddx=-10,10,10 do
					for ddy=-10+dddy,10+dddy,10 do
						rfv('st4bg_rivsomnium_flow',x-dx+ddx,y+ddy,z,-dx+ddx,y+ddy,z,-dx+ddx,-y+ddy,z,x-dx+ddx,-y+ddy,z)
					end
				end
			end
		end
	end

	if showboss then background.WarpEffectApply() end
	--恢复viewmode至正常
	SetViewMode'world'
end

