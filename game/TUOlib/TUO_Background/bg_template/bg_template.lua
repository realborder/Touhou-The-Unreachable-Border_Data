---------------------------
--code by janrilw
---------------------------
local PATH='TUOlib/TUO_Background/bg_template/'
bg_template=Class(object)
--------------------------------
---加载资源
function bg_template.load_res()
	local res_list={
		{'bg_test','bg_test.png'}
	}
	for _,v in pairs(res_list) do
		_LoadImageFromFile(v[1],PATH..v[2],true,0,0,false,0)
	end
end
---------------------------------
---设置每个phase的属性
---算法说明：
---phaseinfo表用来记录所有的phase固有属性
---stt表用来记录当前3d参数的起始点，
---cur表用来记录当前3d参数
function bg_template:InitPhaseInfo()
	self.ph={
		{
			duration=180,
			eye={0,0,0},
			at={1,0,0},
			up={0,0,1},
			fogdist={5,10},
			fogc={255,255,255},
			z={0.1,15},
			fovy=0.7
		},
	}



end

function bg_template:init()
	--
	background.init(self,false)
	bg_template.load_res()
	self.speed=0.03--即行走速度
	self.xpos=0--等效的摄像机x轴位置,x轴方向向前
	
	--设置3D属性
	Set3D('eye',0,0,5)
	Set3D('at',5,0,0)--向x正方向看
	-- Set3D('eye',0,0.5,0)
	-- Set3D('at',1.38,0.5,0)--向x正方向看
	Set3D('up',0,0,1)
	Set3D('z',0.1,12)--z轴裁剪距离为0则雾化会出问题
	Set3D('fovy',0.7)
	Set3D('fog',5,10,Color(0xFFFFFFFF))
	
	
end

function bg_template:frame()
	self.xpos=self.xpos-self.speed
	

	task.Do(self)
end

function bg_template:render()
	SetViewMode'3d'
	local showboss = IsValid(_boss)

	if showboss then background.WarpEffectCapture() end

	RenderClear(Color(0xFFFFFFFF))
	--以上是固定要放进去的代码
	--下面是渲染
	local x=self.xpos%1
	for dx=12,-1,-1 do
		for y=5,-5,-1 do
			Render4V('bg_test',x+dx+1,y,-0.1,x+dx+1,y+1,-0.1,x+dx,y+1,-0.1,x+dx,y,-0.1)
		end
	end
	

	if showboss then background.WarpEffectApply() end
	--恢复viewmode至正常
	SetViewMode'world'
end

