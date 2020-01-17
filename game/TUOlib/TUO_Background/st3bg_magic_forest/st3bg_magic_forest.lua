---------------------------
--code by janrilw
---------------------------
local PATH='TUOlib\\TUO_Background\\st3bg_magic_forest\\'
st3bg_magic_forest=Class(object)

function st3bg_magic_forest.load_res()
	local _LoadImageFromFile=function(para1,para2,...)
		_LoadImageFromFile(para1,PATH..para2,...)
	end
	_LoadImageFromFile('image:'.."st3_grass","st3_grass.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st3_leaves","st3_leaves.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st3_river","st3_river.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st3_river_bottom","st3_river_bottom.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st3_tree","st3_tree.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st3_mushroom","st3_mushroom.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st3_mushroom_glowing","st3_mushroom_glowing.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st3_surface","st3_surface.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st3_river_top","st3_river_top.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st3_leaves_edge","st3_leaves_edge.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st3_leaves_side","st3_leaves_side.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st3_dark","st3_dark.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st3_highlight","st3_highlight.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st3_leaves_edgeB","st3_leaves_edgeB.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st3_sky","st3_sky.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st3_river_h","st3_river_h.png",true,0,0,false,0)
	_LoadImageFromFile('image:'.."st3_river_top_hcover","st3_river_top_hcover.png",true,0,0,false,0)
	LoadFX("fx_dizzy",PATH.."fx_dizzy.fx")
end



function st3bg_magic_forest:init(ph,dph)
	--
	background.init(self,false)
	st3bg_magic_forest.load_res()
	SetImageState('image:st3_grass','',Color(255,255,255,255))
	SetImageState('image:st3_leaves','',Color(200,195,195,195))
	SetImageState('image:st3_river','',Color(100,255,255,255))
	SetImageState('image:st3_river_bottom','',Color(255,255,255,255))
	SetImageState('image:st3_river_top','',Color(255,255,255,255))
	SetImageState('image:st3_tree','',Color(255,255,255,255))
	SetImageState('image:st3_mushroom','',Color(255,255,255,255))
	SetImageState('image:st3_mushroom_glowing','',Color(255,255,255,255))
	SetImageState('image:st3_surface','',Color(255,255,255,255))
	SetImageState('image:st3_highlight','mul+add',Color(170,255,255,255))
	
	
	self.R_target1='st3_bg_render_target1'
	self.R_target2='st3_bg_render_target2'
	CreateRenderTarget(self.R_target1)
	CreateRenderTarget(self.R_target2)
	
	self.halluc=Color(255,60,14,84)
	--self.halluc=Color(255,184,150,79)
	self.skyc=Color(255,170,228,255)
	SetImageState('image:st3_sky','mul+add',self.skyc)
	self.fogc=Color(255,98,129,144)
	--
	self.speed=0.03--即行走速度
	self.xpos=0--等效的摄像机x轴位置,x轴方向向前
	self.switch_phase_time={	18*60+40,
								39*60+1,
								48*60+20,
								58*60+20,
								120*60,
								300*60} --用于记录切换阶段的时间，这里不计背景timer和BGM之间60f的时间差
	-- self.switch_phase_time={0,	39*60+10,	48*60+12,	58*60+20,	300*60} --test
	self.duration={	240,
					240,
					300,
					90,
					180,
					20}--每次切换过程的持续时间
	
	self.eye={	{0,0.1,0},
				{0,0.4,0},
				{0,0.6,0},
				{0,0.8,0},
				{0,0.8,0},
				{0,0.4,0}}--每个阶段的最终状态
	-- self.eye={{0,0.5,0},		{0,0.4,0},	{0,0.6,0},{0,0.8,0},{0,0.8,0}}--test
	self.at={	{1.38,1.3,0},
				{2.98,0.8,0},
				{2.98,0.8,0},
				{1.98,0.2,0},
				{2.98,0.8,0},
				{2.98,0.8,0}}	
	-- self.at={{1.38,0.5,0},	{2.98,0.8,0},	{2.98,0.8,0},{1.98,0.2,0},{2.98,0.8,0}}	--test
	self.fogdis={	{1,4},	
					{5,15},
					{3.5,12},
					{2,10},
					{0.01,9},
					{5,15}}
	--在set3D前具体数值会先在这三个表里存好，这个代表的是实时值
	self.deye={0,0,0}
	self.dat={0,1,0}
	self.dfogdis={0.01,0.02}
	self.dup={0,1,0}
	--用来防止被玩坏的两个变量，改变phase即可平滑切换状态
	self.dphase=dph or 0
	self.phase=ph or 0	
	if dph and ph then -- 如果指定了
		self.timer=60+self.switch_phase_time[ph]--背景音乐在60f之后才会播放
		Print('[st3bg]start in '..ph)
	end

	--记录目前是否执行完转换过程，如果没有，则用当前值作为转换起点
	self.process_completed=false
	
	--顶部树叶的位置记录
	self.leaf_xpos={0,5,10}
	--树、杂草、蘑菇的贴图大小，改了贴图记得在这里改回去
	self.imgscale_tree={268,300}
	self.imgscale_grass={268,264}
	self.imgscale_mushroom={128,128}
	self.imgscale_mushglowing={297,297}
	self.pos_addition_for_glowing_mushroom={}--蘑菇荧光贴图多出的距离，渲染时，直接用蘑菇的坐标表加上这个表就好了
	--随机生成树木、杂草和蘑菇
	self.tree_img={'image:st3_tree','image:st3_tree','image:st3_tree'}
	self.grass_img={'image:st3_grass','image:st3_grass','image:st3_grass'}
	self.list_lenth=80--列表的长度
	self.list_dist=15--贴图达到的最远距离
	self.list_arrow=1 --！！！！指着的是x值最小的一个贴图！！！注意！
	self.poslist={}	--position list of sth.
	for i=1,self.list_lenth do table.insert(self.poslist,{}) end
	
	self.x_count=0 --用于贴图循环刷新的等效摄像机位置记录变量
	--
	self.update=st3bg_magic_forest.random_spawn
	self.update(self,0)
	--
	
	--用于控制画面的变量
	self.hallu_point=0 --Hallucination，即致幻点数
	
	
	--设置3D属性
	Set3D('eye',0,0.1,0)
	Set3D('at',1.38,1.3,0)--向x正方向看
	-- Set3D('eye',0,0.5,0)
	-- Set3D('at',1.38,0.5,0)--向x正方向看
	Set3D('up',0,1,0)
	Set3D('z',0.1,24)--z轴裁剪距离为0则雾化会出问题
	Set3D('fovy',0.7)
	Set3D('fog',0.01,0.02,self.fogc)
	
	
	------------------------------提前设置一下
	__boss3finished=false
end

--rnd=math.random

function st3bg_magic_forest:frame()

	self.xpos=self.xpos+self.speed
	
	for i=1,3 do self.leaf_xpos[i]=self.leaf_xpos[i]+self.speed if self.leaf_xpos[i]>=15 then self.leaf_xpos[i]=self.leaf_xpos[i]-15 end end
--------------------------------------------------
	-- 以下是通用型的切换代码
	local i=1
	while self.switch_phase_time[i]~=nil do--检查现在的phase是多少
		if self.timer<=60+self.switch_phase_time[i] then--背景音乐在60f之后才会播放
			if i~=6 or (i==6 and __boss3finished) then -- boss被击败才恢复原状
				self.phase=i
				break
			end
		end
		i=i+1
	end
	if self.dphase~=self.phase then--如果换阶段，那就把之前的清掉，建一个task令视角平滑过渡
		lstg.tmpvar.dsptmp=self.dphase--就是为了把这个传进下面的task里非要再用一个tmpvar...
		task.Clear(self)--换阶段时清除所有旧的task
		task.New(self,function()
			local sp,dsp=self.phase,lstg.tmpvar.dsptmp
			local t=0
			local dura=self.duration[sp]
			if self.process_completed then
				while t<=dura do
					local k=sin(90*t/dura)--先算平滑切换参数
					t=t+1
					--预先算好eye、at、fog参数
					for i=1,3 do 
						self.deye[i]=self.eye[dsp][i]+(self.eye[sp][i]-self.eye[dsp][i])*k
						self.dat[i]=self.at[dsp][i]+(self.at[sp][i]-self.at[dsp][i])*k
					end
					for i=1,2 do self.dfogdis[i]=self.fogdis[dsp][i]+(self.fogdis[sp][i]-self.fogdis[dsp][i])*k end
					--把数值代入
					Set3D('eye',self.deye[1],self.deye[2],self.deye[3])
					Set3D('at',self.dat[1],self.dat[2],self.dat[3])
					-- Set3D('fog',self.dfogdis[1],self.dfogdis[2],self.fogc) --备份，这个背景里和hallu_point挂钩了
					Set3D('fog',self.dfogdis[1],self.dfogdis[2],self.fogc*(1-self.hallu_point)+self.halluc*self.hallu_point)
					task.Wait(1)
				end
			else--如果上一个过程还没完，那就把现在的位置缓存到t里
				local teye={}
				local tat={}
				local tfog={}
				for i=1,3 do
					teye[i]=self.deye[i]
					tat[i]=self.dat[i]
				end
				for i=1,2 do tfog[i]=self.dfogdis[i] end
				while t<=dura do
					local k=sin(90*t/dura)--先算平滑切换参数
					t=t+1
					--预先算好eye、at、fog参数
					for i=1,3 do 
						self.deye[i]=teye[i]+(self.eye[sp][i]-teye[i])*k
						self.dat[i]=tat[i]+(self.at[sp][i]-tat[i])*k
					end
					for i=1,2 do self.dfogdis[i]=tfog[i]+(self.fogdis[sp][i]-tfog[i])*k end
					--把数值代入
					Set3D('eye',self.deye[1],self.deye[2],self.deye[3])
					Set3D('at',self.dat[1],self.dat[2],self.dat[3])
					-- Set3D('fog',self.dfogdis[1],self.dfogdis[2],self.fogc)
					Set3D('fog',self.dfogdis[1],self.dfogdis[2],self.fogc*(1-self.hallu_point)+self.halluc*self.hallu_point)
					task.Wait(1)
				end
			end
			self.process_completed=true
		end)
	
-------------------------------------------------
--------------这里就是放自定义内容了
--------------注意：切换代码必须建task以避免玩坏，function只能对3D参数进行特定的操作，如果有其他操作，那么请自行写恢复用的函数
		if self.phase==3 and self.dphase==2 then
			self.speed=0.05
			task.New(self,function()
				local t=0
				local teye={self.deye[1],self.deye[2],self.deye[3]}
				while true do 
					if t<=180 then
						self.deye={teye[1],teye[2]+0.2*(sin(t-90)+1)/2,teye[3]+0.2*(sin(t-90)+1)/2}
						self.dup={0,1,0.1*(sin(t-90)+1)/2}
					else
						self.deye={teye[1],teye[2]+0.2*sin(t/2),teye[3]+0.2*sin(t-90)}
						self.dup={0,1,0.1*sin(t-90)}
					end
					Set3D('eye',self.deye[1],self.deye[2],self.deye[3])
					Set3D('up',self.dup[1],self.dup[2],self.dup[3])
					t=t+1
					task.Wait(1)
					self.process_completed=false--不停置false，这样切换状态的时候能以实时值为起点
				end
			end)
		elseif self.phase==4 and self.dphase==3 then
			task.New(self,function()
				for t=1,20 do
					Set3D('fovy',0.7-0.4*sin(t*9))
					self.hallu_point=t/40
					task.Wait(1)
				end
				for t=1,20 do
					self.speed=0.05-0.03*t/20
					task.Wait(1)
				end
			end)
		elseif self.phase==5 and self.dphase==4 then
			task.New(self,function()
				for t=1,60 do
					self.hallu_point=t/120+0.5
					task.Wait(1)
				end
			end)
		elseif self.phase==6 and self.dphase==5 then
			task.New(self,function()
				for t=1,60 do
					self.hallu_point=1-t/60
					task.Wait(1)
				end
			end)
		end
	
	end
	self.dphase=self.phase
	
	--控制树、草和蘑菇贴图刷新的部分
	--Print('before frame:',self.list_arrow/self.list_lenth ,(self.timer%60+1)/60)
	self.x_count = self.x_count + self.speed
	while self.list_arrow/self.list_lenth <= self.x_count/self.list_dist do  --4/4 调整了这里的条件判断，希望能修好恶心人的bug= =
		self.update(self,self.list_arrow)
		if self.x_count >= self.list_dist and self.list_arrow >= self.list_lenth then
			self.list_arrow = 1
			self.x_count = self.x_count - self.list_dist
			break
		else
			self.list_arrow = self.list_arrow + 1
		end
	end
	
	--整体移动
	for i=1,self.list_lenth do 
		for j=2,11,3 do self.poslist[i][j]=self.poslist[i][j]-self.speed end
	end
	
	--old
	-- while self.list_arrow/self.list_lenth < (self.timer%(60*15)+1)/(60*15) do --不管list_length是多少都能做到同步刷新
		-- if self.list_arrow == self.list_lenth and self.timer%(60*15) == (60%15-1) then 
			-- self.update(self,self.list_lenth) 
			-- self.list_arrow=1
			-- break
		-- end		
		-- self.update(self,self.list_arrow)
		-- self.list_arrow = self.list_arrow + 1
	-- end
	--Print('after, arrow and x_count',self.list_arrow,self.x_count)
	
	
	st3bg_magic_forest.operate_hallu(self)

	
	task.Do(self)
	
	-- 
	-- if st<=60+1160 then --BGM在17:40之前的部分，在这之后视角下拉，雾化增大
		
		-- -- 一个3D参数平滑过渡单元
		-- local t=st-60--local timer
		-- local dura=180--duration
		-- if t<=dura then
			-- local k=sin(90*t/dura)--平滑过渡所用的参数，相当于把原本的线性关系y=t/dura改成正弦关系
			-- Set3D('fog',	sf[sp][1]+(sf[sp+1][1]-sf[sp][1])*k,	sf[sp][2]+(sf[sp+1][2]-sf[sp][2])*k,	self.fogc)
			-- Set3D('eye',	se[sp][1]+(se[sp+1][1]-se[sp][1])*k,	se[sp][2]+(se[sp+1][2]-se[sp][2])*k,	se[sp][3]+(se[sp+1][3]-se[sp][3])*k)
			-- Set3D('at',		sa[sp][1]+(sa[sp+1][1]-sa[sp][1])*k,	sa[sp][2]+(sa[sp+1][2]-sa[sp][2])*k,	sa[sp][3]+(sa[sp+1][3]-sa[sp][3])*k)
		-- end
		-- --结束
	-- elseif st<=60+2320 then --BGM在38:769之前的部分，在这之后速度变快
	
	-- elseif st<=60+2900 then --BGM在48:30之前的部分，在这之后开始致幻
	
	-- elseif st<=60+3500 then --BGM在58:20之前的部分，在这之后视角开始摇晃
	
	-- else
	
	-- end

end

local rnd=math.random

function st3bg_magic_forest.random_spawn(self, index)--初始化、以及随机刷新树草蘑菇的位置
--参数1，参数2刷新第几个贴图,为0则初始化
--狗屎代码，有大量重复部分，不重复的部分只有x的赋值和poslist的索引值，先这么着吧，以后优化（咕）
	local function rollType()
		local num=rnd(0,10)
		if num<2.5 then return 1
		elseif num<7 then return 2
		else return 3 end
	end


	if index == 0 then
		local mushroom_list_index = 0
		for i=1,self.list_lenth do
			local typ=rollType()
			local x=self.list_dist*(i-1)/self.list_lenth--i等于1时x最小，即贴图最近，渲染时应当逆着表的次序渲染
			--Print('init,i='..i,';x='..x)
			local y,z=nil,nil
			local s=nil
			if typ==1 then--tree type
				y=1
				z=rnd(0.5,1.5)
				s=self.imgscale_tree
			elseif typ==2 then--grass type
				y=0.75
				z=rnd(0.3,1.1)
				s=self.imgscale_grass
			else
				y=0.15
				z=rnd(0.3,0.8)
				s=self.imgscale_mushroom
				mushroom_list_index = i
			end
			local dirc = ran:Int(1,2)
			if dirc == 1 then
				--Print('No'..i..';spawned in left')
				self.poslist[i]={typ,
					x,y,z,
					x,y,z+y*s[1]/s[2],
					x,0,z+y*s[1]/s[2],
					x,0,z
				}	
			else
				--Print('No'..i..';spawned in right')
				self.poslist[i]={typ,
					x,y,-z-y*s[1]/s[2],
					x,y,-z,
					x,0,-z,
					x,0,-z-y*s[1]/s[2]
				}
			end
		end
		--蘑菇荧光贴图多出的距离的计算
		do
			local p=self.poslist[mushroom_list_index]
			local scale_differ = {	(self.imgscale_mushglowing[1] - self.imgscale_mushroom[1]) / self.imgscale_mushroom[1],
									(self.imgscale_mushglowing[2] - self.imgscale_mushroom[2]) / self.imgscale_mushroom[2]}--荧光贴图和蘑菇贴图比例之差
			local center = {
				(p[2]+p[5]+p[8]+p[11])/4,
				(p[3]+p[6]+p[9]+p[12])/4,
				(p[4]+p[7]+p[10]+p[13])/4
			}
			for j=1,2 do
				for i=2,11,3 do
					self.pos_addition_for_glowing_mushroom[i+j] =(p[i+j] - center[j+1]) * scale_differ[j]
				end
			end
		end
	else
		local typ=rollType()
		local x=self.poslist[index][2]+15
		--Print(index,'move to',x)
		local y,z=nil,nil
		local s=nil
			if typ==1 then--tree type
				y=1
				z=rnd(0.5,1.5)
				s=self.imgscale_tree
			elseif typ==2 then--grass type
				y=0.75
				z=rnd(0.3,1.1)
				s=self.imgscale_grass
			else
				y=0.15
				z=rnd(0.3,0.8)
				s=self.imgscale_mushroom
				mushroom_list_index = i
			end
		if rnd(-1,1)>0 then
			self.poslist[index]={typ,
				x,y,z,
				x,y,z+y*s[1]/s[2],
				x,0,z+y*s[1]/s[2],
				x,0,z
			}	
		else
			self.poslist[index]={typ,
				x,y,-z-y*s[1]/s[2],
				x,y,-z,
				x,0,-z,
				x,0,-z-y*s[1]/s[2]
			}	
		end

	end



end

function st3bg_magic_forest.operate_hallu(self)
	local h=self.hallu_point
	local imgResList={'image:st3_tree',
	'image:st3_grass',
	'image:st3_leaves',
	'image:st3_leaves_edge',
	'image:st3_leaves_edgeB',
	'image:st3_surface',
	'image:st3_river_top'
	}
	local d=255*(1-h)
	for i=1,#imgResList do SetImageState(imgResList[i],'',Color(255,d,d,d)) end
	SetImageState('image:st3_river_h','',Color(255*h,255,255,255))
	SetImageState('image:st3_river_top_hcover','',Color(255*h,255,255,255))
	SetImageState('image:st3_mushroom','',Color(255*h,255,255,255))
	SetImageState('image:st3_mushroom_glowing','',Color(255*h,255,255,255))
	SetImageState('image:st3_sky','mul+add',self.fogc*(1-h)+self.halluc*h)
	Set3D('fog',self.dfogdis[1],self.dfogdis[2],self.fogc*(1-h)+self.halluc*h)
end

function st3bg_magic_forest:render()
	SetViewMode'3d'
	local showboss = IsValid(_boss)
	local dizzyEff = (self.hallu_point>0)

	if dizzyEff or showboss then PushRenderTarget(self.R_target1) end
	
	--这一段有问题，先挂起
	-- RenderClear(Color(255,15,20,25))
	-- Set3D('fog',0.01,0.02,Color(0,0,0,0))
	-- Render4V('image:st3_sky',5,10,2, 5,10,-2, 25,-2,-2, 25,-2,2)
	-- Render4V('image:st3_fog',5,1,10, 5,1,-10, 5,0,-10, 1,0,10)
	-- Set3D('fog',self.dfogdis[1],self.dfogdis[2],self.fogc)
	local h=self.hallu_point
	RenderClear(self.fogc*(1-h)+self.halluc*h)
	--以上是固定要放进去的代码
	--下面是渲染
	local x=self.xpos%1
	
	---------------------------------------------------------
	--河床渲染
	for i=-1,15 do --这层循环令贴图在x方向（向前）上重复
		Render4V('image:st3_river_bottom',	i-x,-0.2,-0.7,	i-x,-0.2,0.7,	i+1-x,-0.2,0.7,	i+1-x,-0.2,-0.7)	
		Render4V('image:st3_river_h',	i-x,-0.2,-0.7,	i-x,-0.2,0.7,	i+1-x,-0.2,0.7,	i+1-x,-0.2,-0.7)
	end

	--水面渲染
	for i=-1,15 do --这层循环令贴图在x方向（向前）上重复
		Render4V('image:st3_river',	i-x,-0.1,-0.6,	i-x,-0.1,0.6,	i+1-x,-0.1,0.6,	i+1-x,-0.1,-0.6)
	end
	--河岸渲染
	for i=-1,15 do --这层循环令贴图在x方向（向前）上重复
		Render4V('image:st3_river_top',	i-x,0,-0.4,	i-x,0,0.4,	i+1-x,0,0.4,	i+1-x,0,-0.4)
	end


	
	---------------------------------------------------------	
	--土壤渲染
	for i=-1,15 do --这层循环令贴图在x方向（向前）上重复
		for j=1,3 do --这层循环令贴图在z方向（向右）上重复
			for dirc=-1,1,2 do if j~=0 then Render4V('image:st3_surface',	i-x,0,(j-0.6)*dirc,	i-x,0,(j+0.4)*dirc,	i+1-x,0,(j+0.4)*dirc,	i+1-x,0,(j-0.6)*dirc) end end
		end
	end
	
	
	---------------------------------------------------------
	--先渲染黑色部分和天空，接着树、草、蘑菇按照远近依次渲染，算法见此代码块下面的大段注释
	-- Render4V('image:')
	for i=15,-1,-1 do --这层循环令贴图在x方向（向前）上重复
		for dirc=-1,1,2 do
			Render4V('image:st3_dark',i-x,1,1.5*dirc,	i-x,1.5,1.5*dirc,	i+1-x,1.5,1.5*dirc,	i+1-x,1,1.5*dirc)
			Render4V('image:st3_dark',i-x,1,1.5*dirc,	i-x,1,10*dirc,	i+1-x,1,10*dirc,	i+1-x,1,1.5*dirc)
		end	
	end
	----------------------------------叶子------------------------
	local xl=self.leaf_xpos
	for y=1,0,-0.5 do
		for i=1,3 do
			Render4V('image:st3_leaves',	15+0.5-xl[i],1.5+y,-2.5/2,	15+0.5-xl[i],1.5+y,2.5/2,	15-4.5-xl[i],1.5+y,2.5/2,	15-4.5-xl[i],1.5+y,-2.5/2)
		end	
	end
	
	
	
	local i2=self.list_arrow-1 if i2==0 then i2=self.list_lenth end
	for i=15,-1,-1 do --这层循环令贴图在x方向（向前）上重复
		--渲染下方随机贴图
		--i从15到-1，减去xpos的小数部分就是x坐标
		--i2属于(1,80)若self.list_arrow为56，渲染顺序则为：从55开始递减至1，再从80开始递减至56，实际的x坐标已经在list里算好了，应当用这个做距离的比较
		--因为是先渲染下面的杂物，所以要让i2的等效x坐标大于i
		
		while i-x<=self.poslist[i2][2] do
			--Print('i:'..i..';i2:'..i2..'!now list_arrow is '..self.list_arrow) --修复一个sbbug用
			local p = self.poslist[i2]
			--Print(self.poslist)
			local imgtmp=''
			if p[1] == 1 then -- 如果贴图是树，那么在渲染的时候会多渲染两个贴图
				imgtmp = self.tree_img[ran:Int(1,3)]
				local sig=sign(p[10])
				local dis=1.1
				for i=1,2 do Render4V(imgtmp,p[2],p[3],p[4]+i*dis*sig,p[5],p[6],p[7]+i*dis*sig,p[8],p[9],p[10]+i*dis*sig,p[11],p[12],p[13]+i*dis*sig) end
			elseif p[1] == 2 then
				imgtmp = self.grass_img[ran:Int(1,3)]
			else
				imgtmp= 'image:st3_mushroom'
				local ad=self.pos_addition_for_glowing_mushroom
				--SetImageState('image:st3_mushroom_glowing','',Color(ran:Int(150,255),255,255,255))--令蘑菇荧光闪动
				Render4V('image:st3_mushroom_glowing',	p[2],p[3]+ad[3],p[4]+ad[4],
														p[5],p[6]+ad[6],p[7]+ad[7],
														p[8],p[9]+ad[9],p[10]+ad[10],
														p[11],p[12]+ad[12],p[13]+ad[13])
			end

			Render4V(imgtmp,p[2],p[3],p[4],p[5],p[6],p[7],p[8],p[9],p[10],p[11],p[12],p[13])
			if i2==self.list_arrow then break
				else i2=i2-1 if i2==0 then i2=self.list_lenth end end
		end
		-----------------------------
		--渲染树叶
		-- for y=0,1.5,0.75 do
			-- for dirc=-1,1,2 do 	Render4V('image:st3_leaves_side',i-x,1.5+y,1.5*dirc,	i-x,1.5+y,0.5*dirc,	i+1-x,1.5+y,0.5*dirc,	i+1-x,1.5+y,1.5*dirc) end
		-- end
		local xl=self.leaf_xpos
		local cospara= (i-x+xl[1])/5*360 --xl[1]前改为负号有奇效
		if dizzyEff then cospara=(i-x-xl[1])/5*360 end
		local zshift=0.25*(-cos(cospara)+1)/2 -- z轴偏移量
		if dizzyEff then zshift=0.3*h*(-cos(cospara)+1)/2 end  --这里的h是self.hallu_point，在上面local了
		for dirc=-1,1,2 do
			Render4V('image:st3_leaves_edge',i-x,1.5,(1.5+zshift)*dirc,	i-x,1.5,0+zshift*dirc,	i-x,1,0+zshift*dirc,	i-x,1,(1.5+zshift)*dirc)
			Render4V('image:st3_leaves_edge',i-x,1,(1.2+zshift)*dirc,	i-x,1,(0.2+zshift)*dirc,	i+1-x,1,(0.2+zshift)*dirc,	i+1-x,1,(1.2+zshift)*dirc)
			Render4V('image:st3_leaves_edgeB',i-x,1,(1.2+zshift)*dirc,	i-x,1,(0.2+zshift)*dirc,	i-x,0.2,(0.2+zshift)*dirc,	i-x,0.2,(1.2+zshift)*dirc)
		end
		
		local function tmpf(x)
			if x<2 then return max(0,x/2)
			elseif x>10 then return max(0,(12-x)/2)
			else return 1 end
		end
		
		for k=1,3 do
			if i>15-xl[k]-3 and i<15-xl[k]-2 then
				--Print(i,xl[k])
				SetImageState('image:st3_highlight','mul+add',Color(50*tmpf(i-x),255,255,255))
				Render4V('image:st3_highlight',	15-xl[k]-2.5,2.5,-2.5,	15-xl[k]-2.5,2.5,2.5,	15-xl[k]-2.5,0,2.5,	15-xl[k]-2.5,0,-2.5)
				break
			end
		end
	end

	--高光
	for i=-1,15 do
		local cospara= (i-x-self.leaf_xpos[1])/5*360
		local zshift=-0.1*cos(cospara) -- z轴偏移量
		Render4V('image:st3_river_top_hcover',	i-x,0,-0.4+zshift,	i-x,0,0.4+zshift,	i-x,0.4,0.4+zshift,	i-x,0.4,-0.4+zshift)
	end
	--为了渲染次序，下面的代码已经被融进上面的循环中，此处留存做备份。
	--算法备份：将上下两for循环的i归一化，记为i1，i2，只要i2<=i1，下面的循环就会执行一次，直到不满足条件为止
	-- for i=self.list_arrow,self.list_arrow-self.list_lenth+1,-1 do--从坐标靠后的往靠前的渲染
		-- local ind=(i-2+self.list_lenth)%self.list_lenth+1
		-- --Print('waiting for render:',ind)
		-- local p = self.poslist[ind]
		-- --Print(self.poslist)
		-- local imgtmp=''
		-- if p[1] == 1 then
			-- imgtmp = self.tree_img[ran:Int(1,3)]
		-- elseif p[1] == 2 then
			-- imgtmp = self.grass_img[ran:Int(1,3)]
		-- else
			-- imgtmp= 'image:st3_mushroom'
			-- local ad=self.pos_addition_for_glowing_mushroom
			-- SetImageState('image:st3_mushroom_glowing','',Color(ran:Int(150,255),255,255,255))--令蘑菇荧光闪动
			-- Render4V('image:st3_mushroom_glowing',	p[2],p[3]+ad[3],p[4]+ad[4],
													-- p[5],p[6]+ad[6],p[7]+ad[7],
													-- p[8],p[9]+ad[9],p[10]+ad[10],
													-- p[11],p[12]+ad[12],p[13]+ad[13])
		-- end
		-- Render4V(imgtmp,p[2],p[3],p[4],p[5],p[6],p[7],p[8],p[9],p[10],p[11],p[12],p[13])
	-- end


	
	if dizzyEff or showboss then PopRenderTarget(self.R_target1) end
	
	if dizzyEff and showboss then
		PushRenderTarget(self.R_target2)
		PostEffect(self.R_target1,'fx_dizzy','',{radiu = 5, angle = self.timer/25})
		PopRenderTarget(self.R_target2)
		local x,y = WorldToScreen(_boss.x,_boss.y)
		local x1 = x * screen.scale
		local y1 = (screen.height - y) * screen.scale
		local fxr = _boss.fxr or 163
		local fxg = _boss.fxg or 73
		local fxb = _boss.fxb or 164
		PostEffect(self.R_target2,"boss_distortion", "", {
			centerX = x1,
			centerY = y1,
			size = _boss.aura_alpha*200*lstg.scale_3d,
			color = Color(125,fxr,fxg,fxb),
			colorsize = _boss.aura_alpha*200*lstg.scale_3d,
			arg=1500*_boss.aura_alpha/128*lstg.scale_3d,
			timer = self.timer
        })
	elseif dizzyEff then PostEffect(self.R_target1,'fx_dizzy','',{radiu = 5, angle = self.timer/25})
	elseif showboss then
		local x,y = WorldToScreen(_boss.x,_boss.y)
		local x1 = x * screen.scale
		local y1 = (screen.height - y) * screen.scale
		local fxr = _boss.fxr or 163
		local fxg = _boss.fxg or 73
		local fxb = _boss.fxb or 164
		PostEffect(self.R_target1,"boss_distortion", "", {
			centerX = x1,
			centerY = y1,
			size = _boss.aura_alpha*200*lstg.scale_3d,
			color = Color(125,fxr,fxg,fxb),
			colorsize = _boss.aura_alpha*200*lstg.scale_3d,
			arg=1500*_boss.aura_alpha/128*lstg.scale_3d,
			timer = self.timer
        })
	end
		--尝试给玩家上boss的扭曲，成功，这说明shader是可以重复应用的
	-- local x,y = WorldToScreen(player.x,player.y)
	-- local x1 = x * screen.scale
	-- local y1 = (screen.height - y) * screen.scale
	-- local fxr = 163
	-- local fxg = 73
	-- local fxb = 73
	-- PostEffect(self.R_target1,'boss_distortion', '', {
		-- centerX = x1,
		-- centerY = y1,
		-- size = 100,
		-- color = Color(125,fxr,fxg,fxb),
		-- colorsize =100,
		-- arg=1500*255/128*lstg.scale_3d,
		-- timer = self.timer
	-- })
	
	--恢复viewmode至正常
	SetViewMode'world'
end

