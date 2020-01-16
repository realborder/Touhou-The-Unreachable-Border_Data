TUO_Developer_UI={}
----排版信息
local UI_L=-107
local UI_R=640-UI_L

local self=TUO_Developer_UI
self.core=TUO_Developer_Tool_kit


---------------------------------
---粗糙的补间函数
local itpl = function(vstart,vend,t)  return vstart+(vend-vstart)*(cos(180+180*t)+1)/2 end
------------------------------
---更快捷的方块渲染
local RenderCube= function(l,r,b,t,ca,cr,cg,cb) 
	if ca and cr and cg and cb then
		SetImageState('white','',Color(ca,cr,cg,cb)) end
	if ca and (not cr) then
		SetImageState('white','',ca) end
	RenderRect('white',l,r,b,t)
end



function TUO_Developer_UI:init()
	self.visiable=false
	self.cur=nil
	--展开用timer，范围是0到1
	self.timer=0

	self.mouse_click_list={}
	self.mouse_cur_timer=0

	self.bgalpha=0.8
	self.module={}
	self.scroll_force=0
	self.left_for_world=false
	self.left_for_world_timer=0

	--模块排版
		--每个模块选项之间的角度差
		self.module_da=22
		--可被选中的模块的角度限制范围
		self.module_angle_limit=45
		--模块选项环绕中心位置和半径
		self.module_cx,self.module_cy=240,230
		self.module_cr=200
		--模块选项自身的默认半径
		self.module_r=32
		--
		self.module_a_offset=0
		self.module_a_offset_aim=0
	--面板排版
		self.topbar_width=32
		self.topbar_width_aim=32
		self.panel_top_offset=16
		self.panel_left_offset=16
		self.leftbar_width=107+35
		self.panel_bottom_offset=16
		self.panel_left_offset=16
		self.panel_height=32
		self.panel_gap=8
	--面板焦点机制
		self.panel_operation_keys={
			-- prev={KEY.UP,KEY.LEFT,KEY.W,KEY.A},
			-- next={KEY.DOWN,KEY.RIGHT,KEY.S,KEY.D},
			-- confirm={KEY.Z,KEY.ENTER},
			-- back={KEY.X,KEY.ESCAPE},
			prev={KEY.W,KEY.A},
			next={KEY.S,KEY.D},
			confirm={KEY.ENTER},
			back={KEY.ESCAPE}
		}
		self.panel_operation_keypre={}
		self.panel_operation_keytrigger={}

end

function TUO_Developer_UI:frame()
	-----timer变换部分
		if not self.visiable then
			self.timer=self.timer+(0-self.timer)*0.15
			if abs(self.timer)<0.03 then self.timer=0 end
		else 
			if self.cur then
				self.timer=self.timer+(-1-self.timer)*0.15
				if abs(self.timer)>0.9999 then self.timer=-1 end

			else
				self.timer=self.timer+(1-self.timer)*0.15
				if abs(self.timer)>0.97 then self.timer=1 end

			end
			if self.left_for_world then
				self.left_for_world_timer=self.left_for_world_timer+(1-self.left_for_world_timer)*0.2
				if self.left_for_world_timer>0.99 then self.left_for_world_timer=1 end
				self.topbar_width_aim=16
			else
				self.left_for_world_timer=self.left_for_world_timer+(0-self.left_for_world_timer)*0.4
				if self.left_for_world_timer<0.01 then self.left_for_world_timer=0 end
				self.topbar_width_aim=32
			end
		end
		if GetMouseDelta("x")~=0 or GetMouseDelta("y")~=0 then self.mouse_cur_timer=min(1,self.mouse_cur_timer+0.1) end
		self.mouse_cur_timer=max(0,self.mouse_cur_timer-0.04)
		self.topbar_width=self.topbar_width+(self.topbar_width_aim-self.topbar_width)*0.2
		if self.timer==0 then return end
	------在完全不显示的时候会彻底关掉自身的逻辑
		--模块和面板快速切换，按下Ctrl+Tab才会回退到一开始的页面
			local CheckKey=self.core.CheckKeyState
			local ctrl_tr=CheckKey(KEY.CTRL)
			local shift_tr=CheckKey(KEY.SHIFT)
			local tab_tr=CheckKey(KEY.TAB)
			local ctrl=lstg.GetKeyState(KEY.CTRL)
			local shift=lstg.GetKeyState(KEY.SHIFT)
			local tab=lstg.GetKeyState(KEY.TAB)
			if self.cur then
				if self.timer<0 and not ctrl then
					local module=self.module[self.cur]
					local num=#module.panel
					if num>0 then
						if tab_tr and not shift then 
							module.cur=module.cur+1
							if module.cur>num then module.cur=1 end
						elseif tab_tr and shift then
							module.cur=module.cur-1
							if module.cur<1 then module.cur=num end
						end
					end
				elseif self.timer<0 and ctrl and tab_tr then
					if tab_tr and not shift then
						self.cur_sel=self.cur+1
						if self.cur_sel>#(self.module) then self.cur_sel=1 end
					elseif tab_tr and shift then
						self.cur_sel=self.cur-1
						if self.cur_sel<1 then self.cur_sel=#(self.module) end
					end
					self.cur=nil
					self.module_a_offset=(self.cur_sel-1)*self.module_da
				end
			else
				if self.cur_sel then
					if ctrl then
						if tab_tr and not shift then
							self.cur_sel=self.cur_sel+1
							if self.cur_sel>#(self.module) then self.cur_sel=1 end
						elseif tab_tr and shift then
							self.cur_sel=self.cur_sel-1
							if self.cur_sel<1 then self.cur_sel=#(self.module) end
						end
						self.module_a_offset=(self.cur_sel-1)*self.module_da
					else
						self.cur=self.cur_sel
						self.cur_sel=nil
					end
				end
			end
		--数字键快速切换模块
			if KeyInputTemp.enable==false then
				for i=1,10 do
					local index=tostring(i)
					if i==10 then index='0' end
					if lstg.GetKeyState(KEY[index]) then
						if self.module[i] then self.cur=i end
					end
				end
			end
		--由于esc键与X键等价，所以返回键改到F1去
		if lstg.GetKeyState(KEY.F1) then self.cur=nil self.cur_sel=nil end
		--鼠标滚轮
		if MouseState.WheelDelta~=0 and self.timer>0 then
			self.module_a_offset=min(max(0,self.module_a_offset-MouseState.WheelDelta/6),(#self.module-1)*self.module_da)
		end
		if MouseTrigger(0) or MouseTrigger(2) or MouseState.WheelDelta~=0 then  self.cur_sel=nil end

		--处理模块的点击逻辑和位置
			for _,module in pairs(self.module) do
				self:DoModuleFrame(module)
			end
end

function TUO_Developer_UI:RenderMonitorBar()
		SetImageState('white','',Color(0,255,255,255),Color(75,255,255,255),Color(75,255,255,255),Color(0,255,255,255))
		--性能监视条
		local alpha=-self.timer
		local r=745-200*(self.topbar_width/32)
		local l=r-1
		local len=40
		local b=480-self.topbar_width*alpha
		local t=480+self.topbar_width*(1-alpha)
		local m=(t+b)/2
		RenderCube(l-240,r,m-0.5,m)
		local pm=self.core.performance_monitor
		if pm.frame then
			local k=pm.frame/(1/60)

			if not self.core.ban_framefunc then 
				if not pm.frame_pre then pm.frame_pre={} end
				local fpre=pm.frame_pre
				if #fpre<=240 then 
					table.insert(fpre,k)
					pm.frame_pre_cur=#fpre
				else
					pm.frame_pre_cur=pm.frame_pre_cur+1
					if pm.frame_pre_cur>240 then pm.frame_pre_cur=pm.frame_pre_cur-240 end
					fpre[pm.frame_pre_cur]=k
				end
			end
			local t=b+len*k/2
			RenderCube(l,r,b,t,alpha*255,255,150*(1-k),150*(1-k))
			b=t
		end
		if pm.render then
			local k=pm.render/(1/60)
			local k2=1-min(1,k)
			if not self.core.ban_framefunc then 

				if not pm.render_pre then pm.render_pre={} end
				local fpre=pm.render_pre
				if #fpre<240 then 
					table.insert(fpre,k)
				else
					fpre[pm.frame_pre_cur]=k
				end
			end
			local t=b+len*k/2
			RenderCube(l,r,b,t,alpha*255,175*k2,255,175*k2)
		end
		-- if pm.frame_pre_cur then
			if pm.frame_pre and #pm.frame_pre<240  then
				for i=#pm.frame_pre,1,-1 do
					local a=alpha*min(120,i)/120
					r=l l=r-1
					local b=480-self.topbar_width*alpha
					local k=pm.frame_pre[i]
					local k2=1-min(1,k)
					t=b+self.topbar_width*k/2
					RenderCube(l,r,b,t,a*255,255,150*k2,150*k2)
					k=pm.render_pre[i]
					k2=1-min(1,k)
					b=t t=b+self.topbar_width*k/2
					RenderCube(l,r,b,t,a*255,175*k2,255,175*k2)
				end
			else
				for i=pm.frame_pre_cur,pm.frame_pre_cur-239,-1 do
					r=l l=r-1
					local b=480-self.topbar_width*alpha
					local a=alpha*min(120,i-(pm.frame_pre_cur-239))/120
					local i=i if i<1 then i=i+240 end
					local k=pm.frame_pre[i]
					local k2=1-min(1,k)
					t=b+self.topbar_width*k/2
					RenderCube(l,r,b,t,a*255,255,150*k2,150*k2)
					k=pm.render_pre[i]
					k2=1-min(1,k)
					b=t t=b+self.topbar_width*k/2
					RenderCube(l,r,b,t,a*255,175*k2,255,175*k2)

				end
			end
		-- end
		
end



function TUO_Developer_UI:render()
	SetViewMode'ui'    
	local sis=SetImageState
	local rr=RenderRect
	local rttf=RenderTTF2
	--背景
		if self.timer>0 then
			RenderCube(UI_L,UI_R,0,480,155*self.timer,0,0,0)
		elseif self.timer<0 then
			if self.left_for_world_timer>0 then
				local t=self.left_for_world_timer
				local w=lstg.world
				local mx,my=(w.scrl+w.scrr)/2,(w.scrb+w.scrt)/2
				local l=lstg.world.scrl*t+mx*(1-t)
				local r=lstg.world.scrr*t+mx*(1-t)
				local b=lstg.world.scrb*t+my*(1-t)
				local t=lstg.world.scrt*t+my*(1-t)
				RenderCube(UI_L,l,0,480,255*self.bgalpha*-self.timer,255,255,255)
				RenderCube(r,UI_R,0,480)
				RenderCube(l,r,0,b)
				RenderCube(l,r,t,480)
			else
				RenderCube(UI_L,UI_R,0,480,255*self.bgalpha*-self.timer,255,255,255)
			end
			RenderCube(UI_L,UI_L+self.leftbar_width*-self.timer,0,480,255*-self.timer,255,255,255)

		end
		
	--logo
		if self.timer>0 and not (self.core.no_logo) then
			local offset=itpl(0,10,1-self.timer)
			local l=-31-offset
			local r=-31+512+offset
			local b=-24-offset
			local t=-24+512+offset
			SetImageState('_Dev_UI_Logo','',Color(255*self.timer,255,255,255))
			RenderRect('_Dev_UI_Logo',l,r,b,t)
		end
	--模块
		for _,module in pairs(self.module) do
			self:RenderModule(module)
		end
	--条
	if self.timer<0 then
		RenderCube(UI_L,UI_R,480-self.topbar_width*-self.timer,480,255*-self.timer,30,30,30)
		if self.cur then
			local SIZE=1.2*self.topbar_width/32
			RenderTTF2(self.core.ttf,self.module[self.cur].name,UI_L+32+5,UI_R,480-self.topbar_width*-self.timer,480,SIZE,Color(255*-self.timer,255,255,255),'vcenter')
		end
		local text=string.format('fps:%.1f | objects:%d',GetFPS(),GetnObj())
		local SIZE=self.topbar_width/32
		RenderTTF2(self.core.ttf,text,UI_L+32+5,UI_R-12,480-self.topbar_width*-self.timer,480,SIZE,Color(255*-self.timer,255,255,255),'vcenter','right')
		self:RenderMonitorBar()

	end
	--返回键
	if self.timer<0 then
		local t=-self.timer
		local x,y=-115+20*t,480-self.topbar_width*t*0.5
		local s=self.topbar_width/32
		local p1,p2,p3={x+3*s,y},{x+3*s+8*s,y+8*s},{x+8*s,y+8*s}
		SetImageState('white','',Color(255*t,255,255,255))
		Render4V('white',x,y,0.5,p1[1],p1[2],0.5,p2[1],p2[2],0.5,p3[1],p3[2],0.5)
		p1,p2,p3={x+3*s,y},{x+3*s+8*s,y-8*s},{x+8*s,y-8*s}
		Render4V('white',x,y,0.5,p1[1],p1[2],0.5,p2[1],p2[2],0.5,p3[1],p3[2],0.5)
	end
	--指针
	local alpha=abs(self.timer)
	local scale=abs(self.timer)/2
	local t=self.mouse_cur_timer
	if self.timer>0 then
		SetImageState('_Dev_Tool_cur','',Color(255*alpha,255,255*(1-t),255*(1-t)))
	elseif self.timer<0 then
		SetImageState('_Dev_Tool_cur','',Color(255*alpha,255*(t),0,0))
	end
	Render('_Dev_Tool_cur',MouseState.x_in_UI,MouseState.y_in_UI,os.clock()*5,scale)


end
