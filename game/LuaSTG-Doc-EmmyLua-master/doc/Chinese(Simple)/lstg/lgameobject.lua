---=====================================
---luastg 实例化的游戏对象
---lstg.GameObject 库
---作者:Xiliusha
---邮箱:Xiliusha@outlook.com
---=====================================

----------------------------------------
---GameObject Class

---所有class的基类
---@class lstg.Class
local game_object_class = {
	--数组部分
	function(self)
	end, --init
	function(self, ...)
	end, --del
	function(self)
	end, --frame
	lstg.DefaultRenderFunc, --render
	function(self, other)
	end, --colli
	function(self, ...)
	end; --kill
	
	--散列部分
	---标识一个table是否为合法的lstg.Class
	is_class = true,
	---[不稳定的特性，可能会在日后更改] 标识这个lstg.Class是否可以创建一个lstg.RenderObject对象
	[".render"] = false,
}

---@param self lstg.GameObject
---@vararg any @随着lstg.New传入的参数
function game_object_class.init(self, ...)
end

---@param self lstg.GameObject
function game_object_class.frame(self)
end

---@param self lstg.GameObject
function game_object_class.render(self)
end

---@param self lstg.GameObject
---@vararg any @随着lstg.Del传入的参数
function game_object_class.del(self, ...)
end

---@param self lstg.GameObject
---@vararg any @随着lstg.Kill传入的参数
function game_object_class.kill(self, ...)
end

---@param self lstg.GameObject
---@param other lstg.GameObject
function game_object_class.colli(self, other)
end

----------------------------------------
---GameObject

---luastg中实例化的游戏对象
---@class lstg.GameObject
local game_object = {
	--数组部分
	---class
	---@type lstg.Class
	game_object_class,
	---id
	0;
	
	--散列部分
	--========object========
	---状态，可以为"normal"、"kill"、"del"，分别代表正常状态、被标记为kill、被标记为del
	status = "normal",
	---class，实际上映射到数组部分索引为1的位置
	---@type lstg.Class
	class = game_object_class,
	--========user========
	---计数器，会每帧自增
	timer = 0,
	--========position========
	---x坐标
	x = 0,
	---y坐标
	y = 0,
	---x坐标相对上一帧的变化量
	dx = 0,
	---y坐标相对上一帧的变化量
	dy = 0,
	--========movement========
	---x轴加速度分量
	ax = 0,
	---y轴加速度分量
	ay = 0,
	--[[
	---重力加速度，方向永远朝向y轴负方向
	ag = 0,
	--]]
	---x轴速度分量
	vx = 0,
	---y轴速度分量
	vy = 0,
	--[[
	---最大速度
	maxv = 1e100,
	---x轴最大速度分量
	maxvx = 1e100,
	---y轴最大速度分量
	maxvy = 1e100,
	--]]
	--========render========
	---动画图片精灵计数器，只读
	ani = 0,
	---渲染图层（和游戏对象的渲染顺序有关）
	layer = 0,
	---不参与渲染
	hide = false,
	---图片精灵朝向
	rot = 0,
	---朝向自增量，和navi属性冲突
	omiga = 0,
	---自动根据坐标变换计算朝向，和omiga属性冲突
	navi = false,
	---图片精灵横向缩放
	hscale = 1,
	---图片精灵纵向缩放
	vscale = 1,
	---可应用图片精灵资源、动画资源、HGE粒子资源，赋值为nil时将会释放绑定在对象上的资源
	img = "unkown",
	--========collision========
	---碰撞组id，取值范围 0 到 15
	group = 0,
	---是否出界自动删除，参考lstg.SetBound
	bound = true,
	---是否参与碰撞
	colli = true,
	---如果rect属性为true，则为矩形半宽，否则为椭圆半长轴，如果a严格等于b，则为圆的半径
	a = 0,
	---如果rect属性为true，则为矩形半高，否则为椭圆半短轴，如果a严格等于b，则为圆的半径
	b = 0,
	---碰撞体类型，false时为圆或椭圆，true时为有向矩形
	rect = false,
	--[[
	--========ex+========
	---自动根据当前坐标和上一帧坐标计算vx,vy
	rmove = false,
	---计算出的朝向
	_angle = 0,
	---计算出的速度
	_speed = 0,
	---剩余暂停时间，影响frame回调的执行、速度与坐标的计算、timer和ani等的更新
	pause = 0,
	---不受暂停影响
	nopause = false,
	---世界掩码，与渲染、碰撞检测有关
	world = 1,
	--]]
}

---@class lstg.RenderObject : lstg.GameObject
local render_object = {
	--========.render========
	---渲染时使用的混合模式
	_blend = "",
	---顶点色
	---@type lstg.Color
	_color = {},
	---顶点色alpha分量
	_a = 255,
	---顶点色红色分量
	_r = 255,
	---顶点色绿色分量
	_g = 255,
	---顶点色蓝色分量
	_b = 255,
}

---@class object : lstg.GameObject
local gameobject = game_object
