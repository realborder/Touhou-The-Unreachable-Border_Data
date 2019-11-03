---------------------------
--code by janrilw
---------------------------
local PATH='TUOlib\\TUO_Background\\st4bg_river_of_drei_ams\\'
st4bg_river_of_drei_ams=Class(object)

function st4bg_river_of_drei_ams.load_res()
end



function st4bg_river_of_drei_ams:init()
	
	--设置3D属性
	Set3D('eye',0,0.1,0)
	Set3D('at',1.38,1.3,0)--向x正方向看
	-- Set3D('eye',0,0.5,0)
	-- Set3D('at',1.38,0.5,0)--向x正方向看
	Set3D('up',0,1,0)
	Set3D('z',0.1,24)--z轴裁剪距离为0则雾化会出问题
	Set3D('fovy',0.7)
	Set3D('fog',0.01,0.02,Color(0xFFFFFFFF))
	
	
end

function st4bg_river_of_drei_ams:frame()
end

function st4bg_river_of_drei_ams:render()
	SetViewMode'3d'

	SetViewMode'world'
end

