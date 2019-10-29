st2bg_village=Class(object)
local PATH='TUOlib\\TUO_Background\\st2bg_village\\'

function st2bg_village.load_res()
	local _LoadImageFromFile=function(para1,para2,...)
		_LoadImageFromFile(para1,PATH..para2,...)
	end

	_LoadImageFromFile('image:'.."bg_test","bg_test.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st2bg_land","st2bg_land.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st2bg_land_l","st2bg_land_l.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st2bg_land_r","st2bg_land_r.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st2bg_roof_l","st2bg_roof_l.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st2bg_roof_r","st2bg_roof_r.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st2bg_wall_l","st2bg_wall_l.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st2bg_wall_r","st2bg_wall_r.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st2bg_wall2_l","st2bg_wall2_l.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st2bg_wall2_r","st2bg_wall2_r.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st2bg_sky","st2bg_sky.png",true,0,0,false,0)

end
function st2bg_village:init()
	--
	background.init(self,false)
	self.load_res()
	SetImageState('image:bg_test','',Color(255,255,255,255))
	self.fogc=Color(255,215,226,255)
	--set 3d camera and fog
	Set3D('eye',0,3.0,0)
	Set3D('at',1.375,0.6,0)--向x正方向看
	Set3D('up',0,1,0)
	Set3D('z',1,24)
	Set3D('fovy',0.7)
	Set3D('fog',0.01,0.02,self.fogc)
	--
	self.speed=0.03--即行走速度
	self.xpos=0--等效的摄像机x轴位置,x轴方向向前

end

--rnd=math.random

function st2bg_village:frame()
	--还原正作雾化距离拉远的效果
	if self.timer>15 and self.timer<=15+240 then
		Set3D('eye',0,3.0-sin((self.timer-15)/240*90)*1.9,0)--用sin平滑处理
		Set3D('fog', 4.3*(self.timer-15)/240, 9*(self.timer-15)/240, self.fogc)
	elseif self.timer>=360 then
		Set3D('up',0,10,sin((self.timer-360)/5))
		Set3D('at',1.375,0.6+0.1*sin((self.timer-360)/5))
		--视角轻微摇晃
	end
	self.xpos=self.xpos+self.speed
	
end

function st2bg_village:render()
	SetViewMode'3d'
	local showboss = IsValid(_boss)
	if showboss then
        background.WarpEffectCapture()
    end
	
	RenderClear(lstg.view3d.fog[3])
	Render4V('image:st2bg_sky',4.3,3,-5,	4.3,3,5,	10.5,0.3,5,	10.5,0.3,-5)
	--以上是固定要放进去的代码
	--下面是渲染
	local x=self.xpos%1.5
	--地面贴图的渲染
	for i=-1.5,10.5,1.5 do--这层循环令贴图在x方向（向前）上重复
		--令贴图在z方向（向右）上重复
		Render4V('image:st2bg_land_r',	i-x,0,-1.5-0.75,i-x,0,-1.5+0.75,i+1.5-x,0,-1.5+0.75,i+1.5-x,0,-1.5-0.75)
		Render4V('image:st2bg_land',	i-x,0,-0.75,	i-x,0,0.75,		i+1.5-x,0,0.75,		i+1.5-x,0,-0.75)
		Render4V('image:st2bg_land_l',	i-x,0,1.5-0.75,	i-x,0,1.5+0.75,	i+1.5-x,0,1.5+0.75,	i+1.5-x,0,1.5-0.75)
	end
--屋顶与屋顶之间有空隙，还要多渲染一层墙

--因为墙面和棚子支架被遮挡的问题，所以把这两行注释掉了，以后可能会改

	for j=10.5,-1.5,-1.5 do
		--朝向自机的墙面的渲染
		Render4V('image:st2bg_wall2_l',	j+0.1-x,0.7,0.75,	j+0.1-x,0.7,1.75,		j+0.1-x,0,1.75,		j+0.1-x,0,0.75) -- 改成渲染一整张图
		Render4V('image:st2bg_wall2_r',	j+0.1-x,0.7,-0.75,	j+0.1-x,0.7,-1.75,		j+0.1-x,0,-1.75,	j+0.1-x,0,-0.75) -- 改成渲染一整张图
		
		-- Render4V('image:bg_test',	j+0.1-x,0.4,0.75*i,	j+0.1-x,0.7,1.25*i,		j+0.1-x,0,1.25*i,	j+0.1-x,0,0.75*i)
		-- Render4V('image:bg_test',	j+0.1-x,0.7,1.25*i,	j+0.1-x,0.4,1.75*i,		j+0.1-x,0,1.75*i,	j+0.1-x,0,1.25*i)
	end

	for j=10.5,-1.5,-1.5 do
		--朝向街面的墙面的渲染
		Render4V('image:st2bg_wall_l',	j+1.3-x,0.4,0.75,	j+0.1-x,0.4,0.75,	j+0.1-x,0,0.75,		j+1.3-x,0,0.75)
		Render4V('image:st2bg_wall_r',	j+1.3-x,0.4,-0.75,	j+0.1-x,0.4,-0.75,	j+0.1-x,0,-0.75,	j+1.3-x,0,-0.75)
	end

	for i=-1.5,10.5,1.5 do
		--屋顶的渲染
		Render4V('image:st2bg_roof_l',	i+1.49-x,0.75,1.35,		i+0.01-x,0.75,1.35,		i+0.01-x,0.30,0.6,		i+1.49-x,0.30,0.6)
		Render4V('image:st2bg_roof_r',	i+1.49-x,0.75,-1.35,	i+0.01-x,0.75,-1.35,	i+0.01-x,0.30,-0.6,		i+1.49-x,0.30,-0.6)
	end

	
	
	
	-- for i=-5,9 do--这层循环令贴图在z方向（向前）上重复
		-- for j=-3,3 do--这层循环令贴图在x方向（向右）上重复
			-- Render4V('image:bg_test',	j-0.5,0,0-z+i,	j-0.5,0,1-z+i,	j+0.5,0,1-z+i,		j+0.5,0,-z+i)
		-- end
	-- end
	SetImageState('image:bg_test','',Color(255,255,255,255))
	
	
	
	SetImageState('image:bg_test','',Color(255,255,255,255))

	
	
	--以下是给boss加特技的代码
	if showboss then
		background.WarpEffectApply()
	end
	
	--恢复viewmode至正常
	SetViewMode'world'
end