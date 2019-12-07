Include'THlib\\exani\\exani.lua'
Include'THlib\\exani\\exani_interpolation.lua'
-- Include'THlib\\exani\\exani_player_manager.lua'

LoadImageFromFile('exani_editor_background','THlib\\exani\\exani_editor_background.png')
LoadImageFromFile('exani_editor_background_night','THlib\\exani\\exani_editor_background_night.png')
LoadImageFromFile('exani_editor_blackback','THlib\\exani\\exani_editor_blackback.png')
LoadImageFromFile('exani_editor_ruler','THlib\\exani\\exani_editor_ruler.png') --SetImageCenter('exani_editor_ruler',0,0)--【云绝】
LoadImageFromFile('exani_editor_tip','THlib\\exani\\exani_editor_tip.png') --SetImageCenter('exani_editor_tip',0,0)
LoadImageFromFile('exani_editor_tip_night','THlib\\exani\\exani_editor_tip_night.png') --SetImageCenter('exani_editor_tip',0,0)
LoadImageFromFile('exani_pointer','THlib\\exani\\exani_pointer.png') SetImageCenter('exani_pointer',64,64)
LoadImageFromFile('exani_pointer2','THlib\\exani\\exani_pointer2.png') SetImageCenter('exani_pointer2',32,32)
LoadTTF('Word','THlib\\UI\\ttf\\杨任东竹石体-Heavy.ttf',60)
LoadTTF('Information','THlib\\exani\\times.ttf',26)
LoadTTF('Number','THlib\\UI\\ttf\\杨任东竹石体-Heavy.ttf',30)

LoadImageFromFile('exani_editor_frame_nil','THlib\\exani\\exani_editor_frame_nil.png')
LoadImageFromFile('exani_editor_frame_normal','THlib\\exani\\exani_editor_frame_normal.png')
LoadImageFromFile('exani_editor_frame_spec','THlib\\exani\\exani_editor_frame_spec.png')
LoadImageFromFile('exani_editor_frame_selector','THlib\\exani\\exani_editor_frame_selector.png')

SetImageState('exani_editor_blackback','',Color(150,255,255,255))

local EXANI_PATH="THlib\\exani\\exani_data\\"
current_manager={}

exani_manager=Class(object)
function exani_manager:init()
	self.layer=LAYER_TOP+1
	self.exanis_path=plus.ReturnDirectory(EXANI_PATH)
	self.exanis={}
	exani_manager.CreateExanis(self)
	
	self.key=nil --当前按键
	
	self.render_startx=-160 --渲染列表左端x坐标（world坐标系）
	self.render_starty=160  --渲染列表上端y坐标（world坐标系）
	self.render_dy=-20      --渲染列表项之间的y轴间隔
	self.img_yn=18          --渲染img列表的行数
	self.img_yoffset=0      --img列表的偏移量
	
	self.frame_startx=-140  --渲染帧开始的x坐标
	self.frame_dx=5         --帧之间的x间隔
	self.frame_xn=60        --帧的列数
	self.frame_xoffset=0    --开始渲染的第一帧与实际上第一帧的横向偏移量
	self.frame_starty=160   --渲染帧开始的y坐标
	self.frame_dy=-20       --帧之间的y间隔
	self.frame_yn=18        --图层的个数
	self.frame_yoffset=0    --开始渲染的第一个图层与实际上第一个图层的纵向偏移量
	
	self.choose_exani=1     --选择列表项
	self.check_exani=1      --切换exani列表项
	self.check_image=1      --切换image列表项
	self.check_layer=1      --切换layer列表项
	self.check_frame=1      --切换关键帧
	self.check_timer=0      --切换计时
	self.check_delay=10     --切换间隔
	
	self.press_enter=false  --回车键是否按下
	self.press_space=false  --空格键是否按下
	self.press_S=false      --S键是否按下
	self.press_T=false		--T键是否按下
	self.press_D=false		--D键是否按下
	self.press_K=false		--K键是否按下
	self.press_J=false		--J键是否按下
	
	self.frame_on_spec=false--是否停留在关键帧
	self.current_frame={}   --当前关键帧
	self.change_timer=0     --改变图像信息时的输入计时
	self.change_delay=5     --改变图像信息时的输入间隔
	
	self.IsInPlay=false     --是否处于播放状态
	self.max_play_frame=1   --最大播放帧数
	
	self.key_delay=10       --按键延迟时间
	self.key_duration=12    --持续按下多少帧会连续触发
	
	self.copyFrame={		--用于保存被复制的帧（或许应该分出去）
		flag=false,
		img='',
		x=0,
		x_ran=0,
		y=0,
		y_ran=0,
		cx=0,
		cy=0,
		rot=0,
		hs=1,
		vs=1,
		a=255,
		frame_at=0,
		blend='',
		frame_type=0,
		v_type=2,
		h_type=2,
		r_type=2,
		a_type=2,
		b_type=1
	}
	
	self.key_manager={		--某些需要连按的按键管理（或许应该分出去）
		k_up={
			k_value=KEY.UP,
			press=false,
			timer=0,
			state=false
		},
		k_down={
			k_value=KEY.DOWN,
			press=false,
			timer=0,
			state=false
		},
		k_left={
			k_value=KEY.LEFT,
			press=false,
			timer=0,
			state=false
		},
		k_right={
			k_value=KEY.RIGHT,
			press=false,
			timer=0,
			state=false
		},
		k_minus={
			k_value=KEY.MINUS,
			press=false,
			timer=0,
			state=false
		},
		k_add={
			k_value=KEY.EQUALS,
			press=false,
			timer=0,
			state=false
		}
	}
	current_manager=self
	
	--云绝修改和补充
	New(exani_manager_diaplayer)
	self.tip_alpha=0
	self.N_pressed=false
	self.night_mode=false
	self.night_alpha=0 --为255则全黑
	
end

function exani_manager:frame()
	---按键状态更新
	for k,v in pairs(self.key_manager) do 
		if lstg.GetKeyState(v.k_value) then
			v.press=true
			v.timer=v.timer+1
		else
			v.press=false
			v.timer=0
		end
		if (v.timer<=self.key_duration and v.timer%self.key_delay==1) or v.timer>self.key_duration then
			v.state=true
		else
			v.state=false
		end
	end

	if self.check_timer>0 then self.check_timer=self.check_timer-1 end
	if self.change_timer>0 then self.change_timer=self.change_timer-1 end
	if not lstg.GetKeyState(KEY.ENTER) and self.press_enter then self.press_enter=false end
	if not lstg.GetKeyState(KEY.SPACE) and self.press_space then self.press_space=false end
	if not lstg.GetKeyState(KEY.S) and self.press_S then self.press_S=false end
	if not lstg.GetKeyState(KEY.T) and self.press_T then self.press_T=false end
	if not lstg.GetKeyState(KEY.D) and self.press_D then self.press_D=false end
	if not lstg.GetKeyState(KEY.K) and self.press_K then self.press_K=false end
	if not lstg.GetKeyState(KEY.J) and self.press_J then self.press_J=false end
	
	--【云绝】增加夜间模式，方便做UI
	if lstg.GetKeyState(KEY.N) then
		if not self.N_pressed then self.N_pressed=true self.night_mode=not self.night_mode end
	else
		self.N_pressed=false
	end
	if self.night_mode then self.night_alpha=min(255,self.night_alpha+10) else self.night_alpha=max(0,self.night_alpha-10) end
	
	if not self.IsInPlay then
		for k,v in pairs(self.exanis[self.choose_exani].picList[self.check_layer].keyFrames) do
			if v.frame_at==self.check_frame then self.frame_on_spec=true self.current_frame=v break end
			self.frame_on_spec=false
		end
		
		-------处理O,I,L相关操作
		-------self.key的作用是防止同时操作O,I,L,虽然一般也不会就是了
		if self.key~=nil then
			if not lstg.GetKeyState(self.key) then self.key=nil
			else
				exani_manager.DealWithInput(self,self.key)
			end
		else
			if lstg.GetKeyState(KEY.O) then self.key=KEY.O exani_manager.DealWithInput(self,KEY.O)
			elseif lstg.GetKeyState(KEY.I) then self.key=KEY.I exani_manager.DealWithInput(self,KEY.I)
			elseif lstg.GetKeyState(KEY.L) then self.key=KEY.L exani_manager.DealWithInput(self,KEY.L)
			end
		end
		
		-------当没有操作O,I,L时改变图像的属性
		if self.key==nil and self.frame_on_spec==true then
			local pic=self.exanis[self.choose_exani].picList[self.check_layer]
			-------V键调整图像位置/vscale
			if lstg.GetKeyState(KEY.V) and not lstg.GetKeyState(KEY.CTRL) then
				local offset=1
				if lstg.GetKeyState(KEY.SHIFT) then offset=10 end
				if self.key_manager.k_left.state then self.current_frame.x=self.current_frame.x-offset pic.renderFrame.x=self.current_frame.x
				elseif self.key_manager.k_right.state then self.current_frame.x=self.current_frame.x+offset pic.renderFrame.x=self.current_frame.x end
				if self.key_manager.k_up.state then self.current_frame.y=self.current_frame.y+offset pic.renderFrame.y=self.current_frame.y
				elseif self.key_manager.k_down.state then self.current_frame.y=self.current_frame.y-offset pic.renderFrame.y=self.current_frame.y end
				
				if lstg.GetMouseState(0) then
					if self.exanis[self.choose_exani].viewmode=='ui' then
						self.current_frame.x,self.current_frame.y=GetMousePosition()
						self.current_frame.x=self.current_frame.x/screen.scale-screen.dx
						self.current_frame.y=self.current_frame.y/screen.scale-screen.dy
					elseif self.exanis[self.choose_exani].viewmode=='world' then
						self.current_frame.x,self.current_frame.y=GetMousePosition()
						self.current_frame.x=self.current_frame.x/screen.scale-screen.dx
						self.current_frame.y=self.current_frame.y/screen.scale-screen.dy
						self.current_frame.x,self.current_frame.y=ScreenToWorld(self.current_frame.x,self.current_frame.y)
					end
						pic.renderFrame.x=self.current_frame.x
						pic.renderFrame.y=self.current_frame.y
				end
				
				if self.key_manager.k_minus.state then self.current_frame.vs=max(0,self.current_frame.vs-0.05) pic.renderFrame.vs=self.current_frame.vs
				elseif self.key_manager.k_add.state then self.current_frame.vs=min(10,self.current_frame.vs+0.05) pic.renderFrame.vs=self.current_frame.vs end
			end
			-------C键调整图像中心
			if lstg.GetKeyState(KEY.C) then
				local offset=1
				if lstg.GetKeyState(KEY.SHIFT) then offset=10 end
				if self.key_manager.k_left.state then
					self.current_frame.cx=self.current_frame.cx-offset
					self.current_frame.x=self.current_frame.x-offset
					pic.renderFrame.cx=self.current_frame.cx
					pic.renderFrame.x=self.current_frame.x
				elseif self.key_manager.k_right.state then
					self.current_frame.cx=self.current_frame.cx+offset
					self.current_frame.x=self.current_frame.x+offset
					pic.renderFrame.cx=self.current_frame.cx
					pic.renderFrame.x=self.current_frame.x
				end
				if self.key_manager.k_up.state then
					self.current_frame.cy=self.current_frame.cy+offset
					self.current_frame.y=self.current_frame.y+offset
					pic.renderFrame.cy=self.current_frame.cy
					pic.renderFrame.y=self.current_frame.y
				elseif self.key_manager.k_down.state then
					self.current_frame.cy=self.current_frame.cy-offset
					self.current_frame.y=self.current_frame.y-offset
					pic.renderFrame.cy=self.current_frame.cy
					pic.renderFrame.y=self.current_frame.y
				end
				
				------由于鼠标返回的是坐标系坐标，不适合用来改图像中心，不建议使用
				if lstg.GetMouseState(0) then
					local tmpcx,tmpcy=self.current_frame.cx,self.current_frame.cy
					local dcx,dcy=0,0
					if self.exanis[self.choose_exani].viewmode=='ui' then
						self.current_frame.cx,self.current_frame.cy=GetMousePosition()
						self.current_frame.cx=self.current_frame.x/screen.scale-screen.dx
						self.current_frame.cy=self.current_frame.y/screen.scale-screen.dy
					elseif self.exanis[self.choose_exani].viewmode=='world' then
						self.current_frame.cx,self.current_frame.cy=GetMousePosition()
						self.current_frame.cx=self.current_frame.x/screen.scale-screen.dx
						self.current_frame.cy=self.current_frame.y/screen.scale-screen.dy
						self.current_frame.cx,self.current_frame.cy=ScreenToWorld(self.current_frame.cx,self.current_frame.cy)
					end
					dcx=self.current_frame.cx-tmpcx
					dcy=self.current_frame.cy-tmpcy
					self.current_frame.x=self.current_frame.x+dcx
					self.current_frame.y=self.current_frame.y+dcy
					pic.renderFrame.cx=self.current_frame.cx
					pic.renderFrame.cy=self.current_frame.cy
					pic.renderFrame.x=self.current_frame.x
					pic.renderFrame.y=self.current_frame.y
				end
			end
			-------R键调整图像旋转
			if lstg.GetKeyState(KEY.R) and not lstg.GetKeyState(KEY.CTRL) then
				local offset=1
				if lstg.GetKeyState(KEY.SHIFT) then offset=5 end
				if self.key_manager.k_minus.state then self.current_frame.rot=self.current_frame.rot-offset pic.renderFrame.rot=self.current_frame.rot
				elseif self.key_manager.k_add.state then self.current_frame.rot=self.current_frame.rot+offset pic.renderFrame.rot=self.current_frame.rot end
			end
			-------H键调整图像hscale(按住space同时改变hscale和vscale)
			if lstg.GetKeyState(KEY.H) and not lstg.GetKeyState(KEY.CTRL) then
				if self.key_manager.k_minus.state then
					self.current_frame.hs=max(0,self.current_frame.hs-0.05) pic.renderFrame.hs=self.current_frame.hs
					if lstg.GetKeyState(KEY.SPACE) then self.current_frame.vs=max(0,self.current_frame.vs-0.05) pic.renderFrame.vs=self.current_frame.vs end
				elseif self.key_manager.k_add.state then
					self.current_frame.hs=min(10,self.current_frame.hs+0.05) pic.renderFrame.hs=self.current_frame.hs
					if lstg.GetKeyState(KEY.SPACE) then self.current_frame.vs=min(10,self.current_frame.vs+0.05) pic.renderFrame.vs=self.current_frame.vs end
				end
			end
			-------A键调整图像alpha
			if lstg.GetKeyState(KEY.A) and not lstg.GetKeyState(KEY.CTRL) then
				local offset=1
				if lstg.GetKeyState(KEY.SHIFT) then offset=10 end
				if self.key_manager.k_minus.state then self.current_frame.a=max(0,self.current_frame.a-offset) pic.renderFrame.a=self.current_frame.a
				elseif self.key_manager.k_add.state then self.current_frame.a=min(255,self.current_frame.a+offset) pic.renderFrame.a=self.current_frame.a end
			end
			-------数字0~8键调整图像混合模式
			if lstg.GetKeyState(KEY['0']) and self.change_timer==0 then self.current_frame.blend='' pic.renderFrame.blend=self.current_frame.blend self.change_timer=self.change_delay
			elseif lstg.GetKeyState(KEY['1']) and self.change_timer==0 then self.current_frame.blend='mul+add' pic.renderFrame.blend=self.current_frame.blend self.change_timer=self.change_delay
			elseif lstg.GetKeyState(KEY['2']) and self.change_timer==0 then self.current_frame.blend='mul+alpha' pic.renderFrame.blend=self.current_frame.blend self.change_timer=self.change_delay
			elseif lstg.GetKeyState(KEY['3']) and self.change_timer==0 then self.current_frame.blend='mul+sub' pic.renderFrame.blend=self.current_frame.blend self.change_timer=self.change_delay
			elseif lstg.GetKeyState(KEY['4']) and self.change_timer==0 then self.current_frame.blend='mul+rev' pic.renderFrame.blend=self.current_frame.blend self.change_timer=self.change_delay
			elseif lstg.GetKeyState(KEY['5']) and self.change_timer==0 then self.current_frame.blend='add+add' pic.renderFrame.blend=self.current_frame.blend self.change_timer=self.change_delay
			elseif lstg.GetKeyState(KEY['6']) and self.change_timer==0 then self.current_frame.blend='add+alpha' pic.renderFrame.blend=self.current_frame.blend self.change_timer=self.change_delay
			elseif lstg.GetKeyState(KEY['7']) and self.change_timer==0 then self.current_frame.blend='add+sub' pic.renderFrame.blend=self.current_frame.blend self.change_timer=self.change_delay
			elseif lstg.GetKeyState(KEY['8']) and self.change_timer==0 then self.current_frame.blend='add+rev' pic.renderFrame.blend=self.current_frame.blend self.change_timer=self.change_delay
			end
			-------CTRL改变差值方式
			if lstg.GetKeyState(KEY.CTRL) and self.change_timer==0 then
				if lstg.GetKeyState(KEY.V) then
					self.current_frame.v_type=self.current_frame.v_type+1
					if self.current_frame.v_type>3 then self.current_frame.v_type=1 end
					self.change_timer=self.change_delay
				end
				if lstg.GetKeyState(KEY.H) then
					self.current_frame.h_type=self.current_frame.h_type+1
					if self.current_frame.h_type>3 then self.current_frame.h_type=1 end
					self.change_timer=self.change_delay
				end
				if lstg.GetKeyState(KEY.R) then
					self.current_frame.r_type=self.current_frame.r_type+1
					if self.current_frame.r_type>3 then self.current_frame.r_type=1 end
					self.change_timer=self.change_delay
				end
				if lstg.GetKeyState(KEY.A) then
					self.current_frame.a_type=self.current_frame.a_type+1
					if self.current_frame.a_type>3 then self.current_frame.a_type=1 end
					self.change_timer=self.change_delay
				end
				if lstg.GetKeyState(KEY.B) then
					self.current_frame.b_type=self.current_frame.b_type+1
					if self.current_frame.b_type>3 then self.current_frame.b_type=1 end
					self.change_timer=self.change_delay
				end
			end
		end
		-------M键改变当前exani所有图片位置(注意改变后需要移动一下才能反映出效果)
		if self.key==nil then
			if lstg.GetKeyState(KEY.M) then
				if self.key_manager.k_up.state then
					for k,v in pairs(self.exanis[self.choose_exani].picList) do
						for key,value in pairs(v.keyFrames) do
							value.y=value.y+1
						end
					end
				exani_manager.UpdateRenderFrame(self)
				elseif self.key_manager.k_down.state then
					for k,v in pairs(self.exanis[self.choose_exani].picList) do
						for key,value in pairs(v.keyFrames) do
							value.y=value.y-1
						end
					end
				exani_manager.UpdateRenderFrame(self)
				end
				if self.key_manager.k_right.state then
					for k,v in pairs(self.exanis[self.choose_exani].picList) do
						for key,value in pairs(v.keyFrames) do
							value.x=value.x+1
						end
					end
				exani_manager.UpdateRenderFrame(self)
				elseif self.key_manager.k_left.state then
					for k,v in pairs(self.exanis[self.choose_exani].picList) do
						for key,value in pairs(v.keyFrames) do
							value.x=value.x-1
						end
					end
				exani_manager.UpdateRenderFrame(self)
				end
			end
		end	
		
		-------回车键从头播放/+alt从当前帧播放
		if self.key==nil then
			if lstg.GetKeyState(KEY.ENTER) and not self.press_enter then
				self.press_enter=true
				if not lstg.GetKeyState(KEY.ALT) then
					self.check_frame=1
					self.frame_xoffset=0
					exani_manager.UpdateRenderFrame(self)
				end
				for k,v in pairs(self.exanis) do
					if v.show then
						local m=exani.PlayInit(v)
						if m>self.max_play_frame then self.max_play_frame=m end
					end
				end
				self.IsInPlay=true
			end
		end
	else
		-------超过最大帧或者按下ESC退出播放
		if self.max_play_frame<=self.check_frame or lstg.GetKeyState(KEY.ESCAPE) then  
			self.IsInPlay=false
			self.check_frame=1
			self.frame_xoffset=0
			self.max_play_frame=1
		else
			self.check_frame=self.check_frame+1
		end
		exani_manager.UpdateRenderFrame(self)
	end
	
end

function exani_manager:render()
	SetViewMode('ui')
	
	--【云绝】增加夜间模式
	if self.night_alpha==0 then 
		SetImageState('exani_editor_background','',Color(255,255,255,255))
		Render('exani_editor_background',320,240,0,0.5)
	elseif self.night_alpha==255 then
		SetImageState('exani_editor_background_night','',Color(255,255,255,255))
		Render('exani_editor_background_night',320,240,0,0.5)

	else
		SetImageState('exani_editor_background','',Color(255,255,255,255))
		SetImageState('exani_editor_background_night','',Color(self.night_alpha,255,255,255))
		Render('exani_editor_background',320,240,0,0.5)
		Render('exani_editor_background_night',320,240,0,0.5)
	end
	
	if self.frame_on_spec then RenderFrameInformation(self.current_frame) end
end

function exani_manager:CreateExanis()
	for k,v in pairs(self.exanis_path) do
		table.insert(self.exanis,New(exani,v))
	end
	exani_manager.SortExani(self)
end

function exani_manager:SaveAll()
	for k,v in pairs(self.exanis) do
		exani.save(v)
	end
end

function exani_manager:DealWithInput(key)

	if key==KEY.O then
		-------O+↑/↓键
		if lstg.GetKeyState(KEY.DOWN) and self.check_timer==0 then
			self.check_timer=self.check_delay
			self.check_exani=self.check_exani+1
			if self.check_exani>(#self.exanis) then self.check_exani=1 end
		elseif lstg.GetKeyState(KEY.UP) and self.check_timer==0 then
			self.check_timer=self.check_delay
			self.check_exani=self.check_exani-1
			if self.check_exani<1 then self.check_exani=(#self.exanis) end
		end
		-------O+回车键(+shift隐藏/显示)
		if lstg.GetKeyState(KEY.ENTER) and not self.press_enter then
			if not lstg.GetKeyState(KEY.SHIFT) then
				self.choose_exani=self.check_exani 
				self.check_layer=1
				if not self.exanis[self.choose_exani].show then
					self.exanis[self.choose_exani].show=true
					self.exanis[self.choose_exani].changeShowFlag=true
					for k,v in pairs(self.exanis[self.choose_exani].picList) do
						layers.CalculateFrame(v)
					end
				end
			else
				if self.exanis[self.check_exani].show then
					self.exanis[self.check_exani].show=false
				else
					self.exanis[self.check_exani].show=true
					for k,v in pairs(self.exanis[self.check_exani].picList) do
						layers.CalculateFrame(v)
					end
				end
				self.exanis[self.check_exani].changeShowFlag=true
			end
			self.press_enter=true
		end
		-------O+空格保存(+shift只更新不保存)
		if lstg.GetKeyState(KEY.SPACE) and not self.press_space then
			if not lstg.GetKeyState(KEY.SHIFT) then
				exani_manager.SaveAll(self)
			else
				for i=#self.exanis,1,-1 do
					Del(self.exanis[i])
				end
				exani_manager.CreateExanis(self)
			end
			self.press_space=true
		end
		-------O+P键调整exani优先级
		if lstg.GetKeyState(KEY.P) then
			if self.key_manager.k_minus.state then
				self.exanis[self.check_exani].Prio_in_dev=self.exanis[self.check_exani].Prio_in_dev-1
				if self.exanis[self.check_exani].Prio_in_dev<0 then
					self.exanis[self.check_exani].Prio_in_dev=30
				end
				exani_manager.RangeLayer(self)
			elseif self.key_manager.k_add.state then
				self.exanis[self.check_exani].Prio_in_dev=self.exanis[self.check_exani].Prio_in_dev+1
				if self.exanis[self.check_exani].Prio_in_dev>30 then 
					self.exanis[self.check_exani].Prio_in_dev=0
				end
				exani_manager.RangeLayer(self)
			end
		end
		-------O+M键调整exani的ViewMode
		if lstg.GetKeyState(KEY.M) and self.change_timer==0 then
			if self.exanis[self.check_exani].viewmode=='world' then self.exanis[self.check_exani].viewmode='ui'
			elseif self.exanis[self.check_exani].viewmode=='ui' then self.exanis[self.check_exani].viewmode='world' end
			self.exanis[self.check_exani].changeModeFlag=not self.exanis[self.check_exani].changeModeFlag
			self.change_timer=self.change_delay
		end
		
		
	elseif key==KEY.I then
		-------I+↑/↓键，切换图像素材
		local ex=self.exanis[self.choose_exani].imgList
		if lstg.GetKeyState(KEY.DOWN) and self.check_timer==0 then
			self.check_timer=self.check_delay
			self.check_image=self.check_image+1
			if self.check_image>(#ex) then
				self.check_image=1
				self.img_yoffset=0
			elseif self.check_image>self.img_yoffset+self.img_yn then
				self.img_yoffset=self.img_yoffset+1
			end
		elseif lstg.GetKeyState(KEY.UP) and self.check_timer==0 then
			self.check_timer=self.check_delay
			self.check_image=self.check_image-1
			if self.check_image<1 then
				self.check_image=(#ex)
				self.img_yoffset=max(0,(#ex)-self.img_yn)
			elseif self.check_image<(self.img_yoffset+1) then
				self.img_yoffset=self.img_yoffset-1
			end
		end
		-------I+回车键插入帧(+shift创建图层并插入帧)
		if lstg.GetKeyState(KEY.ENTER) and not self.press_enter then
			if lstg.GetKeyState(KEY.SHIFT) then
				table.insert(self.exanis[self.choose_exani].picList,New(layers,nil))
				self.check_layer=#(self.exanis[self.choose_exani].picList)
				self.frame_yoffset=max(0,#(self.exanis[self.choose_exani].picList)-self.frame_yn)
				self.frame_on_spec=false
			end
			exani_manager.InsertFrame(self,'I')
			self.press_enter=true
		end
		
		
	elseif key==KEY.L then
		-------L+↑/↓键
		local ex=self.exanis[self.choose_exani].picList
		if self.key_manager.k_down.state then
			self.check_layer=self.check_layer+1
			if self.check_layer>(#ex) then
				self.check_layer=1
				self.frame_yoffset=0
			elseif self.check_layer>self.frame_yoffset+self.frame_yn then
				self.frame_yoffset=self.frame_yoffset+1
			end
		elseif self.key_manager.k_up.state then
			self.check_layer=self.check_layer-1
			if self.check_layer<1 then
				self.check_layer=(#ex)
				self.frame_yoffset=max(0,(#ex)-self.frame_yn)
			elseif self.check_layer<(self.frame_yoffset+1) then
				self.frame_yoffset=self.frame_yoffset-1
			end
		end
		
		-------L+←/→键(+ctrl调整关键帧)(+空格跳到最近的关键帧)
		if self.key_manager.k_right.state then
			local offset=1
			if lstg.GetKeyState(KEY.SHIFT) then offset=5 end
			if lstg.GetKeyState(KEY.CTRL) and self.frame_on_spec then
				---改变关键帧所在帧数，如果移动位置存在帧则不执行
				for i=#(ex[self.check_layer].keyFrames),1,-1 do
					if ex[self.check_layer].keyFrames[i].frame_at==self.check_frame+offset then
						break
					elseif ex[self.check_layer].keyFrames[i].frame_at==self.check_frame then
						ex[self.check_layer].keyFrames[i].frame_at=ex[self.check_layer].keyFrames[i].frame_at+offset
						break
					end
				end
				table.sort(ex[self.check_layer].keyFrames,function(a,b) return a.frame_at<b.frame_at end)
			elseif lstg.GetKeyState(KEY.SPACE) and not self.press_space then
				for i=1,#(ex[self.check_layer].keyFrames) do
					if ex[self.check_layer].keyFrames[i].frame_at>self.check_frame then
						offset=ex[self.check_layer].keyFrames[i].frame_at-self.check_frame break
					end
				end
				self.press_space=true
			end 
			self.check_frame=self.check_frame+offset
			if self.check_frame>self.frame_xoffset+self.frame_xn then self.frame_xoffset=self.frame_xoffset+offset end
			exani_manager.UpdateRenderFrame(self)
		elseif self.key_manager.k_left.state then
			local offset=1
			if lstg.GetKeyState(KEY.SHIFT) then offset=5 end
			if lstg.GetKeyState(KEY.CTRL) and self.frame_on_spec then
				for i=1,#(ex[self.check_layer].keyFrames) do
					if ex[self.check_layer].keyFrames[i].frame_at==self.check_frame-offset then
						break
					elseif ex[self.check_layer].keyFrames[i].frame_at==self.check_frame then
						ex[self.check_layer].keyFrames[i].frame_at=max(1,ex[self.check_layer].keyFrames[i].frame_at-offset)
						break
					end
				end
				table.sort(ex[self.check_layer].keyFrames,function(a,b) return a.frame_at<b.frame_at end)
			elseif lstg.GetKeyState(KEY.SPACE) and not self.press_space then
				for i=#(ex[self.check_layer].keyFrames),1,-1 do
					if ex[self.check_layer].keyFrames[i].frame_at<self.check_frame then
						offset=self.check_frame-ex[self.check_layer].keyFrames[i].frame_at break
					end
				end
				self.press_space=true
			end 
			self.check_frame=max(1,self.check_frame-offset)
			if self.check_frame<(self.frame_xoffset+1) then self.frame_xoffset=max(0,self.frame_xoffset-offset) end
			exani_manager.UpdateRenderFrame(self)
		end
		-------L+P键调整layer优先级(+shift调整exani(暂未实现))
		if lstg.GetKeyState(KEY.P) then
			if self.key_manager.k_minus.state then
				ex[self.check_layer].Prio=ex[self.check_layer].Prio-1
				if ex[self.check_layer].Prio<0 then ex[self.check_layer].Prio=50 end
				exani_manager.RangeLayer(self)
			elseif self.key_manager.k_add.state then
				ex[self.check_layer].Prio=ex[self.check_layer].Prio+1
				if ex[self.check_layer].Prio>50 then ex[self.check_layer].Prio=0 end
				exani_manager.RangeLayer(self)
			end
		end
		-------L+K键改变当前图层相同img属性为该帧 
		if lstg.GetKeyState(KEY.K) and self.frame_on_spec and not self.press_K then
			for k,v in pairs(ex[self.check_layer].keyFrames) do
				if v.img==self.current_frame.img and v.frame_at~=self.current_frame.frame_at then
					keyFrame.pass_value(v,self.current_frame)
				end
			end
			self.press_K=true
		end
		-------L+D键删除当前帧(删除后需要移动一下才会正确渲染，理由是重置layers中的renderFrame)
		if lstg.GetKeyState(KEY.D) and self.frame_on_spec and not self.press_D then
			exani_manager.DeleteFrame(self)
			self.frame_on_spec=false
			if #(ex[self.check_layer].keyFrames)==0 and #ex>1 then
				Del(ex[self.check_layer])
				table.remove(ex,self.check_layer)
				if self.check_layer>#ex then
					self.check_layer=self.check_layer-1
					if self.frame_yoffset>1 then self.frame_yoffset=self.frame_yoffset-1 end
				end
			end
			self.press_D=true
		end
		-------L+S复制帧
		if lstg.GetKeyState(KEY.S) and self.frame_on_spec and not self.press_S then
			exani_manager.CopyFrame(self)
			self.press_S=true
		end
		-------L+T粘贴帧
		if lstg.GetKeyState(KEY.T) and not self.press_T and self.copyFrame.flag then
			exani_manager.InsertFrame(self,'T')
			self.press_T=true
		end
		-------L+J补间成为关键帧(差值方式是默认值,要调整请手动;x_ran/y_ran置0且不可改，如有需要请保存后改保存文件)
		if lstg.GetKeyState(KEY.J) and not self.press_J and not self.frame_on_spec then
			if ex[self.check_layer].renderFrame.flag and type(ex[self.check_layer].renderFrame.img)=='string' and type(ex[self.check_layer].renderFrame.blend)=='string' then
				exani_manager.InsertFrame(self,'J')
			end
			self.press_J=true
		end
		-------L+M改变图层遮罩属性
		if lstg.GetKeyState(KEY.M) and self.change_timer==0 then
			if ex[self.check_layer].store_attr=='' then
				ex[self.check_layer].store_attr='shader'
			elseif ex[self.check_layer].store_attr=='shader' then
				ex[self.check_layer].store_attr='masked'
			elseif ex[self.check_layer].store_attr=='masked' then
				ex[self.check_layer].store_attr=''
			end
			self.change_timer=self.change_delay
		end
		-------L+鼠标选中帧
		if lstg.GetMouseState(0) then
			--【修改 by OLC】修复鼠标和选中帧有偏移的问题
			local x,y=GetMousePosition()
			x=x/screen.scale-screen.dx
			y=y/screen.scale-screen.dy
			x,y=ScreenToWorld(x,y)
			-----------------------------------
			local startx=self.frame_startx-self.frame_dx/2
			local endx=self.frame_startx+(self.frame_xn-1)*self.frame_dx+self.frame_dx/2
			local starty=self.frame_starty-self.frame_dy/2
			local endy=self.frame_starty+(min(self.frame_yn,#self.exanis[self.choose_exani].picList)-1)*self.frame_dy+self.frame_dy/2
			if x>startx and x<endx and y<starty and y>endy then
				local choosex=int((x-startx)/self.frame_dx)+1
				local choosey=int((y-starty)/self.frame_dy)+1
				self.check_frame=self.frame_xoffset+choosex
				self.check_layer=self.frame_yoffset+choosey
				exani_manager.UpdateRenderFrame(self)
			end
		end
	end
end

function exani_manager:InsertFrame(k)
	local t={}
	if k=='I' then
		t=keyFrame.copy(keyFrame.new())
		t.img=(self.exanis[self.choose_exani].imgList)[self.check_image]
		local imgname=string.sub(t.img,1,-5)
		local tmpcx,tmpcy=GetTextureSize(imgname)
		t.cx,t.cy=tmpcx/2,tmpcy/2
	elseif k=='T' then
		t=keyFrame.copy(self.copyFrame)
	elseif k=='J' then
		keyFrame.pass_value(t,self.exanis[self.choose_exani].picList[self.check_layer].renderFrame)
		t.img=self.exanis[self.choose_exani].picList[self.check_layer].renderFrame.img
	end
	t.frame_at=self.check_frame
	-----这里直接替换重复帧
	if self.frame_on_spec then exani_manager.DeleteFrame(self) end
	table.insert((self.exanis[self.choose_exani].picList)[self.check_layer].keyFrames,t)
	local n=#((self.exanis[self.choose_exani].picList)[self.check_layer].keyFrames)
	if n>1 and t.frame_at<(self.exanis[self.choose_exani].picList)[self.check_layer].keyFrames[n-1].frame_at then
		table.sort((self.exanis[self.choose_exani].picList)[self.check_layer].keyFrames,function(a,b) return a.frame_at<b.frame_at end)
	end
	exani_manager.RangeLayer(self)
	layers.CalculateFrame(self.exanis[self.choose_exani].picList[self.check_layer])
end

function exani_manager:CopyFrame()
	self.copyFrame.flag=true
	self.copyFrame.img=self.current_frame.img
	keyFrame.pass_value(self.copyFrame,self.current_frame)
end

function exani_manager:SortExani()
	table.sort(self.exanis,function(a,b) return a.Prio_in_dev<b.Prio_in_dev end)
	for k,v in pairs(self.exanis) do
		table.sort(v.picList,function(a,b) return a.Prio<b.Prio end)
	end
	exani_manager.RangeLayer(self)
end

function exani_manager:RangeLayer()
	for i=1,#(self.exanis) do
		exani.RangeLayer(self.exanis[i],self.layer+self.exanis[i].Prio_in_dev)
	end
end

function exani_manager:UpdateRenderFrame()
	for i=1,#(self.exanis) do
		if self.exanis[i].show then
			for k,v in pairs(self.exanis[i].picList) do
				layers.CalculateFrame(v)
			end
		end
	end
end

function exani_manager:DeleteFrame()
	for k,v in pairs(self.exanis[self.choose_exani].picList[self.check_layer].keyFrames) do
		if self.check_frame==v.frame_at then table.remove(self.exanis[self.choose_exani].picList[self.check_layer].keyFrames,k) end
	end
end

-- 负责展示I、O、L键和帮助信息
exani_manager_diaplayer=Class(object)
function exani_manager_diaplayer:init() 
	self.layer=233
	self.img='img_void'
end

function exani_manager_diaplayer:render()
	local self=current_manager
	SetViewMode('ui')
	if lstg.GetKeyState(KEY.Q) then --渲染tip
		self.tip_alpha=min(255,self.tip_alpha+15)
	else self.tip_alpha=max(0,self.tip_alpha-15) end
	if (lstg.GetKeyState(KEY.V) and not lstg.GetKeyState(KEY.CTRL)) or lstg.GetKeyState(KEY.L) then --渲染指针
		local x,y=GetMousePosition()
		Render('exani_pointer',x/screen.scale,y/screen.scale,0,0.5)
		Render('exani_editor_ruler',x/screen.scale,y/screen.scale) --【云绝】加了这个
	end
	if lstg.GetKeyState(KEY.C) then
		local x,y=GetMousePosition()
		-- 【云绝】每个图层都以当前的cx和cy为左边渲染pointer2
		Render('exani_pointer2',x/screen.scale,y/screen.scale,0,0.5)
		if self.exanis[self.check_exani].viewmode=='world' then SetViewMode('world')
		else SetViewMode('ui') end
		Render('exani_pointer2',self.current_frame.x,self.current_frame.y,0,0.5)
	end
	if self.tip_alpha>0 then
		SetViewMode('ui')
		local tscale=0.5+(1-sin(self.tip_alpha/255*90))*0.04
		--【云绝】增加夜间模式
		if self.night_alpha==0 then 
			SetImageState('exani_editor_tip','',Color(self.tip_alpha,255,255,255))
			Render('exani_editor_tip',320,240,0,tscale)
		elseif self.night_alpha==255 then
			SetImageState('exani_editor_tip_night','',Color(self.tip_alpha,255,255,255))
			Render('exani_editor_tip_night',320,240,0,tscale)

		else
			SetImageState('exani_editor_tip','',Color((1-self.night_alpha/255)*self.tip_alpha,255,255,255))
			SetImageState('exani_editor_tip_night','',Color(self.night_alpha/255*self.tip_alpha,255,255,255))
			Render('exani_editor_tip',320,240,0,tscale)
			Render('exani_editor_tip_night',320,240,0,tscale)
		end
	end
	if self.key~=nil then
		--【云绝】从这儿开始的内容在exani_manager里是被注释了的
		SetViewMode'world'
		Render('exani_editor_blackback',0,0)
		if self.key==KEY.O then 
			RenderTTF('Word','ExaniList',0,0,200,200,Color(200,255,255,255),'center','vcenter')
			for i=1,#self.exanis do
				if i==self.choose_exani then
					RenderTTF('Word',self.exanis[i].name..' ['..self.exanis[i].viewmode..'] Priority:'..self.exanis[i].Prio_in_dev,self.render_startx,self.render_startx,self.render_starty+(i-1)*self.render_dy,self.render_starty+(i-1)*self.render_dy,Color(200,100,255,255),'left','vcenter')
				elseif i==self.check_exani then
					RenderTTF('Word',self.exanis[i].name..' ['..self.exanis[i].viewmode..'] Priority:'..self.exanis[i].Prio_in_dev,self.render_startx,self.render_startx,self.render_starty+(i-1)*self.render_dy,self.render_starty+(i-1)*self.render_dy,Color(200,100,200,100),'left','vcenter')
				elseif self.exanis[i].show then 
					RenderTTF('Word',self.exanis[i].name..' ['..self.exanis[i].viewmode..'] Priority:'..self.exanis[i].Prio_in_dev,self.render_startx,self.render_startx,self.render_starty+(i-1)*self.render_dy,self.render_starty+(i-1)*self.render_dy,Color(200,255,255,255),'left','vcenter')
				else
					RenderTTF('Word',self.exanis[i].name..' ['..self.exanis[i].viewmode..'] Priority:'..self.exanis[i].Prio_in_dev,self.render_startx,self.render_startx,self.render_starty+(i-1)*self.render_dy,self.render_starty+(i-1)*self.render_dy,Color(100,255,255,255),'left','vcenter')
				end
			end
		elseif self.key==KEY.I then 
			RenderTTF('Word','ImageList',0,0,200,200,Color(200,255,255,255),'center','vcenter')
			local ex=self.exanis[self.choose_exani].imgList
			for i=1,min(#ex,self.img_yn) do
				if i==(self.check_image-self.img_yoffset) then
					RenderTTF('Word',ex[i+self.img_yoffset],self.render_startx,self.render_startx,self.render_starty+(i-1)*self.render_dy,self.render_starty+(i-1)*self.render_dy,Color(200,255,255,255),'left','vcenter')
				else
					RenderTTF('Word',ex[i+self.img_yoffset],self.render_startx,self.render_startx,self.render_starty+(i-1)*self.render_dy,self.render_starty+(i-1)*self.render_dy,Color(100,255,255,255),'left','vcenter')
				end
			end
		elseif self.key==KEY.L then
			RenderTTF('Word','LayerList',0,0,200,200,Color(200,255,255,255),'center','vcenter')
			for i=1,self.frame_xn do
				if i%10==1 then RenderTTF('Number',self.frame_xoffset+i,self.frame_startx+(i-1)*self.frame_dx,self.frame_startx+(i-1)*self.frame_dx,170,170,Color(200,255,255,255),'center','vcenter') end
			end
			local ex=self.exanis[self.choose_exani].picList
			for i=1,min(#ex,self.frame_yn) do
				local shaderx=self.frame_startx+self.frame_dx*self.frame_xn
				if i==(self.check_layer-self.frame_yoffset) then 
					RenderTTF('Word',ex[i+self.frame_yoffset].Prio,self.render_startx,self.render_startx,self.frame_starty+(i-1)*self.frame_dy,self.frame_starty+(i-1)*self.frame_dy,Color(200,255,255,255),'left','vcenter')
					RenderTTF('Word',ex[i+self.frame_yoffset].store_attr,shaderx,shaderx,self.frame_starty+(i-1)*self.frame_dy,self.frame_starty+(i-1)*self.frame_dy,Color(200,255,255,255),'left','vcenter')
				else
					RenderTTF('Word',ex[i+self.frame_yoffset].Prio,self.render_startx,self.render_startx,self.frame_starty+(i-1)*self.frame_dy,self.frame_starty+(i-1)*self.frame_dy,Color(100,255,255,255),'left','vcenter')
					RenderTTF('Word',ex[i+self.frame_yoffset].store_attr,shaderx,shaderx,self.frame_starty+(i-1)*self.frame_dy,self.frame_starty+(i-1)*self.frame_dy,Color(100,255,255,255),'left','vcenter')
				end
				-----渲染帧
				local y=self.frame_starty+(i-1)*self.frame_dy
				for j=1,self.frame_xn do --渲染空帧
					if i==(self.check_layer-self.frame_yoffset) and j==(self.check_frame-self.frame_xoffset) then
						-- SetImageState('exani_editor_frame_nil','',Color(255,100,255,200))
						Render('exani_editor_frame_nil',self.frame_startx+(j-1)*self.frame_dx,y)
						Render('exani_editor_frame_selector',self.frame_startx+(j-1)*self.frame_dx,y)
						-- SetImageState('exani_editor_frame_nil','',Color(255,255,255,255))
						
					else
						Render('exani_editor_frame_nil',self.frame_startx+(j-1)*self.frame_dx,y)
					end
				end
				for k,v in pairs(ex[i+self.frame_yoffset].keyFrames) do --渲染关键帧
					if v.frame_at>self.frame_xoffset and v.frame_at<=(self.frame_xoffset+self.frame_xn) then
						if i==(self.check_layer-self.frame_yoffset) and v.frame_at==self.check_frame then
							-- SetImageState('exani_editor_frame_normal','mul+add',Color(255,255,255,255))
							Render('exani_editor_frame_normal',self.frame_startx+(v.frame_at-self.frame_xoffset-1)*self.frame_dx,y)
							Render('exani_editor_frame_selector',self.frame_startx+(v.frame_at-self.frame_xoffset-1)*self.frame_dx,y)
							-- SetImageState('exani_editor_frame_normal','',Color(255,255,255,255))
						else
							Render('exani_editor_frame_normal',self.frame_startx+(v.frame_at-self.frame_xoffset-1)*self.frame_dx,y)
						end
					end
				end
			end
		end
	end
end

function ReturnTypeName(n)
	if n==1 then return 'instant'
	elseif n==2 then return 'linear'
	elseif n==3 then return 'smooth'
	end
end

-----渲染关键帧信息
function RenderFrameInformation(tab)
	--【云绝】增加夜间模式
	local ctmp=current_manager.night_alpha
	RenderTTF('Information','----Keyframe Information----',435,435,446,446,Color(255,ctmp,ctmp,ctmp),'left','vcenter')
	RenderTTF('Information','[Img Resource]',435,435,426,426,Color(255,ctmp,ctmp,ctmp),'left','vcenter')
	RenderTTF('Information',tab.img,465,465,406,406,Color(255,ctmp,ctmp,ctmp),'left','vcenter')
	RenderTTF('Information','[Positon]'..tab.x..','..tab.y,435,435,386,386,Color(255,ctmp,ctmp,ctmp),'left','vcenter')
	RenderTTF('Information','[Center]'..tab.cx..','..tab.cy,435,435,366,366,Color(255,ctmp,ctmp,ctmp),'left','vcenter')
	RenderTTF('Information','[Rotation]'..tab.rot,435,435,346,346,Color(255,ctmp,ctmp,ctmp),'left','vcenter')
	RenderTTF('Information','[Scale]'..tab.hs..','..tab.vs,435,435,326,326,Color(255,ctmp,ctmp,ctmp),'left','vcenter')
	RenderTTF('Information','[Alpha]'..tab.a,435,435,306,306,Color(255,ctmp,ctmp,ctmp),'left','vcenter')
	RenderTTF('Information','[Blend Mode]'..tab.blend,435,435,286,286,Color(255,ctmp,ctmp,ctmp),'left','vcenter')
	RenderTTF('Information','[Frame Type]'..tab.frame_type,435,435,266,266,Color(255,ctmp,ctmp,ctmp),'left','vcenter')
	RenderTTF('Information','[Frame At]'..tab.frame_at,435,435,246,246,Color(255,ctmp,ctmp,ctmp),'left','vcenter')
	RenderTTF('Information','[Position Transition]'..string.format(ReturnTypeName(tab.v_type)),435,435,226,226,Color(255,ctmp,ctmp,ctmp),'left','vcenter')
	RenderTTF('Information','[Scale Transition]'..string.format(ReturnTypeName(tab.h_type)),435,435,206,206,Color(255,ctmp,ctmp,ctmp),'left','vcenter')
	RenderTTF('Information','[Rotation Transition]'..string.format(ReturnTypeName(tab.r_type)),435,435,186,186,Color(255,ctmp,ctmp,ctmp),'left','vcenter')
	RenderTTF('Information','[Alpha Transition]'..string.format(ReturnTypeName(tab.a_type)),435,435,166,166,Color(255,ctmp,ctmp,ctmp),'left','vcenter')
	RenderTTF('Information','[Blend Mode Transition]'..string.format(ReturnTypeName(tab.b_type)),435,435,146,146,Color(255,ctmp,ctmp,ctmp),'left','vcenter')
end

-----测试用打印单层表
function PrintSimpleTable(tab)
	for k,v in pairs(tab) do
		Print(k.."="..v)
	end
end
