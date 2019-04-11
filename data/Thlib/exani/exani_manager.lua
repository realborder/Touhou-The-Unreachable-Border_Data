Include'THlib\\exani\\exani.lua'

LoadImageFromFile('exani_editor_background','Thlib\\exani\\exani_editor_background.png')
LoadImageFromFile('exani_editor_blackback','Thlib\\exani\\exani_editor_blackback.png')
LoadImageFromFile('exani_editor_ruler','Thlib\\exani\\exani_editor_ruler.png')
LoadTTF('Word','THlib\\UI\\ttf\\杨任东竹石体-Heavy.ttf',60)

LoadImageFromFile('exani_editor_frame_nil','Thlib\\exani\\exani_editor_frame_nil.png')
LoadImageFromFile('exani_editor_frame_normal','Thlib\\exani\\exani_editor_frame_normal.png')
LoadImageFromFile('exani_editor_frame_spec','Thlib\\exani\\exani_editor_frame_spec.png')

local EXANI_PATH="Thlib\\exani\\exani_data\\"

exani_manager=Class(object)
function exani_manager:init()
	self.layer=LAYER_TOP+1
	self.exanis_path=plus.ReturnDirectory(EXANI_PATH)
	self.exanis={}
	PrintSimpleTable(self.exanis_path) ----测试用
	exani_manager.CreateExanis(self)
	exani_manager.PrintExani(self)  ----测试用
	
	self.key=nil --当前按键
	
	self.render_startx=-160 --渲染列表左端x坐标（world坐标系）
	self.render_starty=170  --渲染列表上端y坐标（world坐标系）
	self.render_dy=-20      --渲染列表项之间的y轴间隔
	
	self.frame_startx=-140  --渲染帧开始的x坐标
	self.frame_dx=10        --帧之间的x间隔
	self.frame_n=30         --帧的个数
	self.frame_offset=0     --开始渲染的第一帧与实际上第一帧的偏移量
	
	self.check_exani=1      --切换exani列表项
	self.check_timer=0      --切换计时
	self.check_delay=10     --切换间隔
	self.choose_exani=1     --选择列表项
	
	self.check_image=1      --切换image列表项
	
	self.check_layer=1      --切换layer列表项
	self.check_frame=1      --切换关键帧
end

function exani_manager:frame()
	if self.check_timer>0 then self.check_timer=self.check_timer-1 end
	if self.key~=nil then
		if not lstg.GetKeyState(self.key) then self.key=nil
		else
			exani_manager.DealWithInput(self,self.key)
		end
	else
		if lstg.GetKeyState(KEY.O) then self.key=KEY.O exani_manager.DealWithInput(self,KEY.O)
		else if lstg.GetKeyState(KEY.I) then self.key=KEY.I exani_manager.DealWithInput(self,KEY.I)
		else if lstg.GetKeyState(KEY.L) then self.key=KEY.L exani_manager.DealWithInput(self,KEY.L)
		end end end 
	end
end

function exani_manager:render()
	SetViewMode('ui')
	Render('exani_editor_background',320,240,0,0.5)
	if self.key~=nil then
		SetViewMode('world')
		SetImageState('exani_editor_blackback','',Color(150,255,255,255))
		--SetImageState('exani_editor_ruler','',Color(200,255,255,255))
		self.layer=self.layer+10
		Render('exani_editor_blackback',0,0)
		--Render('exani_editor_ruler',0,0)
		self.layer=self.layer-10
		if self.key==KEY.O then 
			RenderTTF('Word','ExaniList',0,0,200,200,Color(200,255,255,255),'center','vcenter')
			for i=1,#self.exanis do
				if i==self.choose_exani then
					RenderTTF('Word',self.exanis[i].name,self.render_startx,self.render_startx,self.render_starty+(i-1)*self.render_dy,self.render_starty+(i-1)*self.render_dy,Color(200,100,255,255),'left','vcenter')
				elseif i==self.check_exani then
					RenderTTF('Word',self.exanis[i].name,self.render_startx,self.render_startx,self.render_starty+(i-1)*self.render_dy,self.render_starty+(i-1)*self.render_dy,Color(200,255,255,255),'left','vcenter')
				else
					RenderTTF('Word',self.exanis[i].name,self.render_startx,self.render_startx,self.render_starty+(i-1)*self.render_dy,self.render_starty+(i-1)*self.render_dy,Color(100,255,255,255),'left','vcenter')
				end
			end
		elseif self.key==KEY.I then 
			RenderTTF('Word','ImageList',0,0,200,200,Color(200,255,255,255),'center','vcenter')
			local ex=clone(self.exanis[self.choose_exani].imgList)
			for i=1,#ex do
				if i==self.check_image then
					RenderTTF('Word',ex[i],self.render_startx,self.render_startx,self.render_starty+(i-1)*self.render_dy,self.render_starty+(i-1)*self.render_dy,Color(200,255,255,255),'left','vcenter')
				else
					RenderTTF('Word',ex[i],self.render_startx,self.render_startx,self.render_starty+(i-1)*self.render_dy,self.render_starty+(i-1)*self.render_dy,Color(100,255,255,255),'left','vcenter')
				end
			end
		elseif self.key==KEY.L then
			RenderTTF('Word','LayerList',0,0,200,200,Color(200,255,255,255),'center','vcenter')
			local ex=clone(self.exanis[self.choose_exani].picList)
			for i=1,#ex do
				if i==self.check_layer then
					RenderTTF('Word',ex[i].Prio,self.render_startx,self.render_startx,self.render_starty+(i-1)*self.render_dy,self.render_starty+(i-1)*self.render_dy,Color(200,255,255,255),'left','vcenter')
				else
					RenderTTF('Word',ex[i].Prio,self.render_startx,self.render_startx,self.render_starty+(i-1)*self.render_dy,self.render_starty+(i-1)*self.render_dy,Color(100,255,255,255),'left','vcenter')
				end
				-----渲染帧
				local y=self.render_starty+(i-1)*self.render_dy
				for j=1,self.frame_n do --渲染空帧
					if i==self.check_layer and j==(self.check_frame-self.frame_offset) then
						SetImageState('exani_editor_frame_nil','',Color(255,100,255,100))
						Render('exani_editor_frame_nil',self.frame_startx+(j-1)*self.frame_dx,y)
						SetImageState('exani_editor_frame_nil','',Color(255,255,255,255))
					else
						Render('exani_editor_frame_nil',self.frame_startx+(j-1)*self.frame_dx,y)
					end
				end
				for k,v in pairs(ex[i].keyFrames) do
					if v.frame_at>self.frame_offset and v.frame_at<=(self.frame_offset+self.frame_n) then
						if i==self.check_layer and v.frame_at==self.check_frame then
							SetImageState('exani_editor_frame_spec','mul+add',Color(255,255,255,255))
							Render('exani_editor_frame_spec',self.frame_startx+(v.frame_at-self.frame_offset-1)*self.frame_dx,y)
							SetImageState('exani_editor_frame_spec','',Color(255,255,255,255))
						else
							Render('exani_editor_frame_spec',self.frame_startx+(v.frame_at-self.frame_offset-1)*self.frame_dx,y)
						end
					end
				end
			end
		end
	end
end

function exani_manager:CreateExanis()
	for k,v in pairs(self.exanis_path) do
		table.insert(self.exanis,New(exani,v))
	end
end

function exani_manager:DealWithInput(key)
	if key==KEY.O then
		--Print('O')
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
		-------O+回车键
		if lstg.GetKeyState(KEY.ENTER) then self.choose_exani=self.check_exani Print(self.choose_exani) end
		
		
	elseif key==KEY.I then
		--Print('I')
		-------I+↑/↓键
		local ex=clone(self.exanis[self.choose_exani].imgList)
		if lstg.GetKeyState(KEY.DOWN) and self.check_timer==0 then
			self.check_timer=self.check_delay
			self.check_image=self.check_image+1
			if self.check_image>(#ex) then self.check_image=1 end
		elseif lstg.GetKeyState(KEY.UP) and self.check_timer==0 then
			self.check_timer=self.check_delay
			self.check_image=self.check_image-1
			if self.check_image<1 then self.check_image=(#ex) end
		end
		-------I+回车键
		
		
		
	elseif key==KEY.L then
		--Print('L')
		-------L+↑/↓键
		local ex=clone(self.exanis[self.choose_exani].picList)
		if lstg.GetKeyState(KEY.DOWN) and self.check_timer==0 then
			self.check_timer=self.check_delay
			self.check_layer=self.check_layer+1
			if self.check_layer>(#ex) then self.check_layer=1 end
		elseif lstg.GetKeyState(KEY.UP) and self.check_timer==0 then
			self.check_timer=self.check_delay
			self.check_layer=self.check_layer-1
			if self.check_layer<1 then self.check_layer=(#ex) end
		end
		-------L+←/→键
		if lstg.GetKeyState(KEY.RIGHT) and self.check_timer==0 then
			self.check_timer=self.check_delay
			self.check_frame=self.check_frame+1
		elseif lstg.GetKeyState(KEY.LEFT) and self.check_timer==0 then
			self.check_timer=self.check_delay
			self.check_frame=max(1,self.check_frame-1)
		end
	end
end

function exani_manager:PrintExani()
	for k,v in pairs(self.exanis) do
		Print(v.name)
	end
end

------测试用打印单层表
function PrintSimpleTable(table)
	for k,v in pairs(table) do
		Print(k.."="..v)
	end
end


-----网上copy的打印表的方法，先放着
-- key = ""
-- function PrintTable(table , level)
  -- level = level or 1
  -- local indent = ""
  -- for i = 1, level do
    -- indent = indent.."  "
  -- end

  -- if key ~= "" then
    -- print(indent..key.." ".."=".." ".."{")
  -- else
    -- print(indent .. "{")
  -- end

  -- key = ""
  -- for k,v in pairs(table) do
     -- if type(v) == "table" then
        -- key = k
        -- PrintTable(v, level + 1)
     -- else
        -- local content = string.format("%s%s = %s", indent .. "  ",tostring(k), tostring(v))
      -- print(content)  
      -- end
  -- end
  -- print(indent .. "}")

-- end
