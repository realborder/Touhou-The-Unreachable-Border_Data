-----------------------------
--  Code By Janril --
--  test version
-----------------------------
title_bg=Class(object)
LoadImageFromFile('title_sky','THlib\\UI\\title_sky.png')
LoadImageFromFile('title_diff_e','Thlib\\UI\\title\\difficulty_E.png')
LoadImageFromFile('title_diff_n','Thlib\\UI\\title\\difficulty_N.png')
LoadImageFromFile('title_diff_h','Thlib\\UI\\title\\difficulty_H.png')
LoadImageFromFile('title_diff_l','Thlib\\UI\\title\\difficulty_L.png')
LoadImageFromFile('cube_side','Thlib\\UI\\title\\bg_test.png')
for i=1,4 do LoadImageFromFile('title_char_'..i,'Thlib\\UI\\title\\char_'..i..'.png') end

function title_bg:init()
	self.group=GROUP_GHOST
	self.layer=LAYER_BG-0.1 -- 仿原本的background.init方法
	
	--mdzz
	ui.title_bg=self
	
	
	self.fogc=Color(255,105,132,223)
	
	-- 记录所有难度贴图的位置
	-- self.diff_pos={
		-- e=1,
		-- n=3,
		-- h=5,
		-- l=7
	-- }
	--贴图的倾斜度，大小
	-- self.diff_angle=-15
	-- self.diff_w=1.4
	-- self.diff_h=2.0

	-- self.char_pos={
		-- reimu=1,
		-- marisa=3,
		-- sanae=5,
		-- usami=7
	-- }
	-- self.char_angle=5
	-- self.char_w=1.4
	-- self.char_h=2.0

	-- self.zpos=0 -- 等效的z轴位置
	-- self.zspeed=-0.005 -- z轴运动速度
	
	-- self.particle={}
	
	-- Set3D('eye',0,0,0)
	-- Set3D('at',-1,0,0)--向x正方向看
	-- Set3D('up',0,1,0)
	-- Set3D('z',1,24)
	-- Set3D('fovy',0.7)
	-- Set3D('fog',4.3,9,self.fogc)
	-- Print('title_bg has initialed')	-- Set3D('eye',0,0,0)
	
	self.T=60*24
	self.period=1 --1,2,3,4分别代表摄像机在xOy平面上的投影所处的象限
	
	Set3D('eye',2,0,0)
	Set3D('at',0,0,0)--向x正方向看
	Set3D('up',0,1,1)
	Set3D('z',1,24)
	Set3D('fovy',0.7)
	Set3D('fog',4.3,9,self.fogc)
	Print('title_bg has initialed')
	
	
end

function title_bg:frame()
	local s=self
	-- s.zpos=s.zpos-s.zspeed
	-- s.diff_pos.e=s.diff_pos.e-s.zspeed
	-- s.diff_pos.n=s.diff_pos.n-s.zspeed
	-- s.diff_pos.h=s.diff_pos.h-s.zspeed
	-- s.diff_pos.l=s.diff_pos.l-s.zspeed
	-- s.char_pos.reimu=s.char_pos.reimu+s.zspeed
	-- s.char_pos.marisa=s.char_pos.marisa+s.zspeed
	-- s.char_pos.sanae=s.char_pos.sanae+s.zspeed
	-- s.char_pos.usami=s.char_pos.usami+s.zspeed
	local angle=((s.timer/s.T)%1)*360
	if angle<=90 then self.period=1
	elseif angle<=180 then self.period=2
	elseif angle<=270 then self.period=3
	else self.period=4 end
	local x=cos(angle)*4
	local y=sin(angle)*-2*sqrt(2)
	local z=sin(angle)*2*sqrt(2)
	Set3D('eye',x,y,z)
	
	
end

function title_bg:render()
	--mdzz
	self=ui.title_bg
	SetViewMode'3d'
	
	RenderClear(Color(255,255,255,255))
	
	------
	Render4V('cube_side',-1,-1,1,	-1,1,1,		-1,1,-1,	-1,-1,-1)
	Render4V('cube_side',-1,-1,-1,	-1,1,-1,	1,1,-1,		1,-1,-1)
	Render4V('cube_side',1,-1,1,	-1,-1,1,	-1,-1,-1,	1,-1,-1)
	------
	Render4V('cube_side',-1,-1,1,	-1,1,1,		1,1,1,		1,-1,1)
	Render4V('cube_side',1,-1,1,	1,1,1,		1,1,-1,		1,-1,-1)
	Render4V('cube_side',1,1,1,		-1,1,1,		-1,1,-1,	1,1,-1)

	
	-- RenderClear(Color(255,105,132,223))
	-- Render4V('title_sky',-4.3,2,-5,	-4.3,2,5,	-10.5,0,5,		-10.5,0,-5)
	-- Render4V('title_sky',-4.3,-2,-5,	-4.3,-2,5,	-10.5,0,5,		-10.5,0,-5)
	-- -- 渲染四个难度
	-- local e,n,h,l=self.diff_pos.e,self.diff_pos.n,self.diff_pos.h,self.diff_pos.l
	-- local l,n={e,n,h,l},{'e','n','h','l'}
	-- local w,h=self.diff_w,self.diff_h
	-- do local cos_,sin_=cos(self.diff_angle),sin(self.diff_angle) for i=1,4 do 
		-- l[i]=l[i]%8-4
		-- Render4V('title_diff_'..n[i],	-6.5,	h/2+l[i]*sin_,	l[i]*cos_,	
										-- -6.5,	h/2+l[i]*sin_,	l[i]*cos_+w,	
										-- -6.5,	-h/2+l[i]*sin_,	l[i]*cos_+w,	
										-- -6.5,	-h/2+l[i]*sin_,	l[i]*cos_)
	-- end end
	-- -- 渲染4个角色
		-- local r,m,s,u=self.char_pos.reimu,self.char_pos.marisa,self.char_pos.sanae,self.char_pos.usami
	-- local l={r,m,s,u}
	-- local w,h=self.char_w,self.char_h
	-- do local cos_,sin_=cos(self.char_angle),sin(self.char_angle) for i=1,4 do 
		-- l[i]=l[i]%8-4
		-- Render4V('title_char_'..i,	-5.5,	h/2+l[i]*sin_,	l[i]*cos_,	
									-- -5.5,	h/2+l[i]*sin_,	l[i]*cos_+w,	
									-- -5.5,	-h/2+l[i]*sin_,	l[i]*cos_+w,	
									-- -5.5,	-h/2+l[i]*sin_,	l[i]*cos_)
	-- end end

	SetViewMode'ui'

end