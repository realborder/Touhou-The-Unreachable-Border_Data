---------------------------
--code by janrilw
---------------------------
local PATH='TUOlib\\TUO_Background\\st4bg_rivsomnium\\'
st4bg_rivsomnium=Class(object)
function st4bg_rivsomnium:InitPhaseInfo(phase)
	self.phaseinfo={
		{
			time=0,
			duration=1,
			eye={0.44,0.2,-4.9},
			at={0.45,0.2,0},
			up={0,0,1},
			fogdist={0.1,0.2},
			fogc={0,0,0},
			z={0.1,15},
			fovy={0.9}
		},
		{
			time=1,
			duration=240,
			eye={0.44,0.2,-4.4},
			at={0.45,0.2,0},
			up={0,0,1},
			fogdist={0.1,7},
			fogc={0,0,0},
			z={0.1,15},
			fovy={0.7}
		},
		{
			time=241,
			duration=75,
			eye={0.44,0.2,0.9},
			at={0.45,0.2,0},
			up={0,0,1},
			fogdist={0.1,0.2},
			fogc={255,255,255},
			z={0.1,15},
			fovy={1.5}
		},
		{
			time=311,
			duration=240,
			itpl=function(v1,v2,t)
				return v1+(v2-v1)*t
			end,
			eye={0.44,0.2,4.9},
			at={0.45,0.2,0},
			up={0,0,1},
			fogdist={7,15},
			fogc={255,255,255},
			z={0.1,15},
			fovy={0.9}
		},
		{
			time=551,
			duration=240,
			itpl=function(v1,v2,t)
				return v1+(v2-v1)*t
			end,
			eye={0.44,0.2,6.9},
			at={0.45,0.2,0},
			up={0,0,1},
			fogdist={0.1,3},
			fogc={255,255,255},
			z={0.1,15},
			fovy={0.6}
		},

	}
	tuolib.BGHandler.DoPhaseLogic(self,1)
end

function st4bg_rivsomnium.load_res()
	local res_list={
		{'st4bg_tree1','st4bg_tree1.png'},
		{'st4bg_brancch','st4bg_brancch.png'},
		{'st4bg_tree2','st4bg_tree2.png'},
		{'st4bg_cloud','st4bg_cloud.png'},
	}
	for _,v in pairs(res_list) do
		_LoadImageFromFile(v[1],PATH..v[2],true,0,0,false,0)
	end
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


	task.Do(self)
end

function st4bg_rivsomnium:render()
	SetViewMode'3d'
	tuolib.BGHandler.DoPhaseLogic(self)
	local phase=tuolib.BGHandler.GetCurPhase(self)
	local showboss = IsValid(_boss)

	if showboss then background.WarpEffectCapture() end

	RenderClear(Color(0xFFFFFFFF))
	--以上是固定要放进去的代码
	--下面是渲染
	local x=self.xpos%1
	local z=0
	local rfv=Render4V
	local dy=2.5
	local dx=dy*1.1
	local dr=sqrt(dx^2+dy^2)

	if phase<=4 then
		if self.cur.eye[3]<0 then
			rfv('st4bg_tree1',dx,-dy,z,dx,dy,z,-dx,dy,z,-dx,-dy,z)
			for z=-0.5,-3.5,-1 do
				local dx=dx+(dr)*cos(-z*360)*0.25
				local dy=dy+(dr)*sin(-z*360)*0.25
				rfv('st4bg_brancch',dx,-dy,z,dx,dy,z,-dx,dy,z,-dx,-dy,z)
			end
		else
			rfv('st4bg_tree2',dx,-dy,z,dx,dy,z,-dx,dy,z,-dx,-dy,z)
			local x,dx=10,self.xpos%10
			local y=5
			for z=1,3,0.1 do
				SetImageState('st4bg_cloud','',Color(255*(1-abs(z-2)^3),255,255,255))
				for ddx=-10,10,10 do
					for ddy=-10,10,10 do
						rfv('st4bg_cloud',x-dx+ddx,y+ddy,z,-dx+ddx,y+ddy,z,-dx+ddx,-y+ddy,z,x-dx+ddx,-y+ddy,z)
					end
				end
			end
		end

	end


	if showboss then background.WarpEffectApply() end
	--恢复viewmode至正常
	SetViewMode'world'
end

