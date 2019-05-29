function clone(tab)
	local ins={}
	for key,var in pairs(tab) do
		ins[key]=var
	end
	return ins
end

keyFrame={
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
keyFrame.new=function()
	local self=clone(keyFrame)
	return self
end
keyFrame.pass_value=function(t1,t2)
	---少img和frame_at,原因是这两个有的操作不需要甚至不能要(比如L+K)
	t1.x=t2.x
	t1.x_ran=t2.x_ran or 0
	t1.y=t2.y
	t1.y_ran=t2.y_ran or 0
	t1.cx=t2.cx
	t1.cy=t2.cy
	t1.rot=t2.rot
	t1.vs=t2.vs
	t1.hs=t2.hs
	t1.a=t2.a
	t1.blend=t2.blend
	t1.frame_type=t2.frame_type or 0
	t1.v_type=t2.v_type or 2
	t1.h_type=t2.h_type or 2
	t1.r_type=t2.r_type or 2
	t1.a_type=t2.a_type or 2
	t1.b_type=t2.b_type or 1
end
keyFrame.copy=function(tab)
	local ins={}
	ins.img=tab.img
	ins.frame_at=tab.frame_at
	keyFrame.pass_value(ins,tab)
	return ins
end

layers=Class(object)
function layers:init(list)
	---需要渲染的缓存
	self.renderFrame={
		flag=false,
		img='',
		x=0,
		y=0,
		cx=0,
		cy=0,
		rot=0,
		hs=1,
		vs=1,
		a=255,
		blend=''
	}
	if list~=nil then
		self.Prio=list[1]
		---之前是存的renderFlag,为了防止旧保存文件读入时出错
		if list[2]=='world' or list[2]=='ui' then self.screenMode=list[2] end
		self.keyFrames={}
		for k,v in pairs(list[3]) do
			local t=keyFrame.copy(v)
			table.insert(self.keyFrames,t)
		end
		table.sort(self.keyFrames,function(a,b) return a.frame_at<b.frame_at end)
		if self.keyFrames[1].frame_at==current_manager.check_frame then layers.copyFrame(self,self.keyFrames[1]) end
		self.store_attr=list[4] or ''
	else
		self.Prio=50
		self.screenMode='world'
		self.keyFrames={}
		self.store_attr=''
	end
	---为了适配旧保存文件
	if self.screenMode==nil then self.screenMode='world' end
	self.layer=LAYER_TOP+40
	self.renderFlag=false
	self.attr=self.store_attr
	---前一个关键帧
	self.previousFrame=nil
	---后一个关键帧
	self.nextFrame=nil
	
	---最后发现还是得记录一下上级exani名字(用于遮罩),也许可以优化,这名字起的不好,其实是包含关系
	self.parent=''
end
function layers:render()
	if self.renderFlag then
		if self.renderFrame.flag then
			SetViewMode(self.screenMode)
			local imgname,imgname1,imgname2
			if type(self.renderFrame.img)=='string' then
				imgname=string.sub(self.renderFrame.img,1,-5)
				SetImageCenter(imgname,self.renderFrame.cx,self.renderFrame.cy)
			elseif type(self.renderFrame.img)=='number' then
				imgname1=string.sub(self.previousFrame.img,1,-5)
				imgname2=string.sub(self.nextFrame.img,1,-5)
				SetImageCenter(imgname1,self.renderFrame.cx,self.renderFrame.cy)
				SetImageCenter(imgname2,self.renderFrame.cx,self.renderFrame.cy)
			end
			
			if self.attr=='shader' or self.attr=='final_shader' then PushRenderTarget('RTS'..self.parent)
			elseif self.attr=='masked' then PushRenderTarget('RTM'..self.parent) end
			
			if type(self.renderFrame.blend)=='string' then
				if type(self.renderFrame.img)=='string' then
					SetImageState(imgname,self.renderFrame.blend,Color(self.renderFrame.a,255,255,255))
					Render(imgname,self.renderFrame.x,self.renderFrame.y,self.renderFrame.rot,self.renderFrame.hs,self.renderFrame.vs)
				elseif type(self.renderFrame.img)=='number' then
					SetImageState(imgname1,self.renderFrame.blend,Color(self.renderFrame.a*(1-self.renderFrame.img),255,255,255))
					Render(imgname1,self.renderFrame.x,self.renderFrame.y,self.renderFrame.rot,self.renderFrame.hs,self.renderFrame.vs)
					SetImageState(imgname2,self.renderFrame.blend,Color(self.renderFrame.a*self.renderFrame.img,255,255,255))
					Render(imgname2,self.renderFrame.x,self.renderFrame.y,self.renderFrame.rot,self.renderFrame.hs,self.renderFrame.vs)
				end
			elseif type(self.renderFrame.blend)=='number' then
				if type(self.renderFrame.img)=='string' then
					SetImageState(imgname,self.previousFrame.blend,Color(self.renderFrame.a*(1-self.renderFrame.blend),255,255,255))
					Render(imgname,self.renderFrame.x,self.renderFrame.y,self.renderFrame.rot,self.renderFrame.hs,self.renderFrame.vs)
					SetImageState(imgname,self.nextFrame.blend,Color(self.renderFrame.a*self.renderFrame.blend,255,255,255))
					Render(imgname,self.renderFrame.x,self.renderFrame.y,self.renderFrame.rot,self.renderFrame.hs,self.renderFrame.vs)
				elseif type(self.renderFrame.img)=='number' then
					SetImageState(imgname1,self.previousFrame.blend,Color(self.renderFrame.a*(1-self.renderFrame.blend),255,255,255))
					Render(imgname1,self.renderFrame.x,self.renderFrame.y,self.renderFrame.rot,self.renderFrame.hs,self.renderFrame.vs)
					SetImageState(imgname2,self.nextFrame.blend,Color(self.renderFrame.a*self.renderFrame.blend,255,255,255))
					Render(imgname2,self.renderFrame.x,self.renderFrame.y,self.renderFrame.rot,self.renderFrame.hs,self.renderFrame.vs)
				end				
			end
			
			if self.attr=='shader' or self.attr=='final_shader' then PopRenderTarget('RTS'..self.parent)
			elseif self.attr=='masked' then PopRenderTarget('RTM'..self.parent) end
			
			if self.attr=='final_shader' then
				PostEffect('RTM'..self.parent,self.parent..'FX','',{tex='RTS'..self.parent})
				PushRenderTarget('RTS'..self.parent)
				RenderClear(Color(0,0,0,0))
				PopRenderTarget('RTS'..self.parent)
				PushRenderTarget('RTM'..self.parent)
				RenderClear(Color(0,0,0,0))
				PopRenderTarget('RTM'..self.parent)
			end
			
		end
	end
end

function layers:save()
	local t={}
	table.insert(t,self.Prio)
	table.insert(t,self.screenMode)
	table.insert(t,self.keyFrames)
	table.insert(t,self.store_attr)
	return t
end

function layers:copyFrame(tab)
	self.renderFrame.flag=true
	self.renderFrame.img=tab.img
	self.renderFrame.x=tab.x
	self.renderFrame.y=tab.y
	self.renderFrame.cx=tab.cx
	self.renderFrame.cy=tab.cy
	self.renderFrame.rot=tab.rot
	self.renderFrame.hs=tab.hs
	self.renderFrame.vs=tab.vs
	self.renderFrame.a=tab.a
	self.renderFrame.blend=tab.blend
end

function layers:CalculateFrame()
	self.renderFrame.flag=false
	self.previousFrame=nil
	self.nextFrame=nil
	for k,v in pairs(self.keyFrames) do
		if v.frame_at<current_manager.check_frame then self.previousFrame=v
		elseif v.frame_at==current_manager.check_frame then layers.copyFrame(self,v)
		elseif v.frame_at>current_manager.check_frame then self.nextFrame=v break end
	end
	if not self.renderFrame.flag then
		if self.previousFrame~=nil and self.nextFrame~=nil then
			if self.previousFrame.img==self.nextFrame.img then
				self.renderFrame.img=self.previousFrame.img
			elseif self.previousFrame.img~='' and self.nextFrame.img~='' and self.previousFrame.img~=self.nextFrame.img then
				self.renderFrame.img=(current_manager.check_frame-self.previousFrame.frame_at)/(self.nextFrame.frame_at-self.previousFrame.frame_at)
			end
			self.renderFrame.x=exani_interpolation(self.previousFrame.x+ran:Float(-abs(self.previousFrame.x_ran),abs(self.previousFrame.x_ran)),self.nextFrame.x+ran:Float(-abs(self.nextFrame.x_ran),abs(self.nextFrame.x_ran)),current_manager.check_frame,self.previousFrame.frame_at,self.nextFrame.frame_at,ReturnTypeName(self.previousFrame.v_type),ReturnTypeName(self.nextFrame.v_type))
			self.renderFrame.y=exani_interpolation(self.previousFrame.y+ran:Float(-abs(self.previousFrame.y_ran),abs(self.previousFrame.y_ran)),self.nextFrame.y+ran:Float(-abs(self.nextFrame.y_ran),abs(self.nextFrame.y_ran)),current_manager.check_frame,self.previousFrame.frame_at,self.nextFrame.frame_at,ReturnTypeName(self.previousFrame.v_type),ReturnTypeName(self.nextFrame.v_type))
			self.renderFrame.cx=exani_interpolation(self.previousFrame.cx,self.nextFrame.cx,current_manager.check_frame,self.previousFrame.frame_at,self.nextFrame.frame_at,ReturnTypeName(self.previousFrame.v_type),ReturnTypeName(self.nextFrame.v_type))
			self.renderFrame.cy=exani_interpolation(self.previousFrame.cy,self.nextFrame.cy,current_manager.check_frame,self.previousFrame.frame_at,self.nextFrame.frame_at,ReturnTypeName(self.previousFrame.v_type),ReturnTypeName(self.nextFrame.v_type))
			self.renderFrame.rot=exani_interpolation(self.previousFrame.rot,self.nextFrame.rot,current_manager.check_frame,self.previousFrame.frame_at,self.nextFrame.frame_at,ReturnTypeName(self.previousFrame.r_type),ReturnTypeName(self.nextFrame.r_type))
			self.renderFrame.hs=exani_interpolation(self.previousFrame.hs,self.nextFrame.hs,current_manager.check_frame,self.previousFrame.frame_at,self.nextFrame.frame_at,ReturnTypeName(self.previousFrame.h_type),ReturnTypeName(self.nextFrame.h_type))
			self.renderFrame.vs=exani_interpolation(self.previousFrame.vs,self.nextFrame.vs,current_manager.check_frame,self.previousFrame.frame_at,self.nextFrame.frame_at,ReturnTypeName(self.previousFrame.h_type),ReturnTypeName(self.nextFrame.h_type))
			self.renderFrame.a=exani_interpolation(self.previousFrame.a,self.nextFrame.a,current_manager.check_frame,self.previousFrame.frame_at,self.nextFrame.frame_at,ReturnTypeName(self.previousFrame.a_type),ReturnTypeName(self.nextFrame.a_type))
			if self.previousFrame.blend==self.nextFrame.blend then 
				self.renderFrame.blend=self.previousFrame.blend
			else
				self.renderFrame.blend=(current_manager.check_frame-self.previousFrame.frame_at)/(self.nextFrame.frame_at-self.previousFrame.frame_at)
			end
			self.renderFrame.flag=true
		end
	end
end
----------------------------------------------------------------------------------------------
exani=Class(object)
function exani:init(dir)
	self.name=dir
	self.path="Thlib\\exani\\exani_data\\"..dir.."\\"
	self.Prio_in_dev=1
	self.show=false
	self.changeShowFlag=false
	self.viewmode='world'
	self.changeModeFlag=false
	self.coor_3d={}
	self.layerList=lstg.LoadExaniConfig(self.path)
	self.picList={}
	self.imgList={}
	self.isContainShader=false
	for k,v in pairs(self.layerList) do
		table.insert(self.picList,New(layers,v))
	end
	table.sort(self.picList,function(a,b) return a.Prio<b.Prio end)
	exani.CheckShader(self)
	exani.LoadImgSources(self)
end

function exani:frame()
	if self.changeShowFlag then
		self.changeShowFlag=false
		if self.show then
			for k,v in pairs(self.picList) do
				v.renderFlag=true
			end
		else
			for k,v in pairs(self.picList) do
				v.renderFlag=false
			end
		end
	end
	if self.changeModeFlag and self.show then
		self.changeModeFlag=false
		for k,v in pairs(self.picList) do
			v.screenMode=self.viewmode
		end
	end
end

function exani:Del()
	for i=#self.picList,1,-1 do
		Del(self.picList[i])
	end
end

function exani:save()
	local tab={}
	for k,v in pairs(self.picList) do
		table.insert(tab,layers.save(v))
	end
	lstg.SaveExaniConfig(tab,self.path)
end

function exani:LoadImgSources()
	local pngs=lstg.FindFiles(self.path,"png","")
	for k,v in pairs(pngs) do
		local imgname=string.sub(v[1],string.len(self.path)+1,-5)
		table.insert(self.imgList,string.sub(v[1],string.len(self.path)+1,-1))
		LoadImageFromFile(imgname,v[1])
	end
	local jpgs=lstg.FindFiles(self.path,"jpg","")
	for k,v in pairs(jpgs) do
		local imgname=string.sub(v[1],string.len(self.path)+1,-5)
		table.insert(self.imgList,string.sub(v[1],string.len(self.path)+1,-1))
		LoadImageFromFile(imgname,v[1])
	end
end

function exani:PlayInit()
	local maxframe=0
	for i=1,#(self.picList) do
		local n=#(self.picList[i].keyFrames)
		local m=self.picList[i].keyFrames[n].frame_at
		if maxframe<m then maxframe=m end
	end
	return maxframe
end

function exani:RangeLayer(l)
	for i=1,#(self.picList) do
		self.picList[i].layer=l+self.picList[i].Prio*0.01
	end
end

---检查是否符合遮罩要求
function exani:CheckShader()
	local hasShader=false
	local hasMasked=false
	for k,v in pairs(self.picList) do
		if v.store_attr=='shader' then self.hasShader=true end
		if v.store_attr=='masked' then self.hasMasked=true end
	end
	if hasMasked and hasShader then
		self.isContainShader=true
	else
		self.isContainShader=false
	end
	if self.isContainShader then
		local rtsname='RTS'..self.name  ---RenderTargetShaderName
		local rtmname='RTM'..self.name	---RenderTargetMaskedName
		CreateRenderTarget(rtsname)
		CreateRenderTarget(rtmname)
		local path='Thlib\\exani\\exani_data\\'..self.name..'\\'..self.name..'FX.fx'
		LoadFX(self.name..'FX',path)
		for i=#self.picList,1,-1 do
			if self.picList[i].attr=='shader' then self.picList[i].attr='final_shader' break end
		end
		for k,v in pairs(self.picList) do
			v.parent=self.name
		end
	elseif hasShader or hasMasked then
		for k,v in pairs(self.picList) do
			v.attr=''
		end
	end
end
