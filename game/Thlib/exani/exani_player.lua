layers_player=Class(object)
function layers_player:init(list)
	self.Prio=list[1]
	self.renderFlag=false
	self.keyFrames={}
	for k,v in pairs(list[3]) do
		local t=keyFrame.copy(v)
		table.insert(self.keyFrames,t)
	end
	table.sort(self.keyFrames,function(a,b) return a.frame_at<b.frame_at end)
	self.attr=list[4] or ''
	self.parent=''
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
	self.previousFrame=nil
	self.nextFrame=nil
	self.current_frame=0
	self.screenMode='world'
end

function layers_player:render()
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

function layers_player:copyFrame(tab)
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

function layers_player:CalculateFrame()
	self.renderFrame.flag=false
	if self.current_frame==self.previousFrame.frame_at then layers_player.copyFrame(self,self.previousFrame)
	elseif self.current_frame==self.nextFrame.frame_at then layers_player.copyFrame(self,self.nextFrame)
	elseif self.current_frame>self.nextFrame.frame_at and self.current_frame<self.nextFrame.frame_at then
	else
		self.previousFrame=nil
		self.nextFrame=nil
		for k,v in pairs(self.keyFrames) do
			if v.frame_at<self.current_frame then self.previousFrame=v
			elseif v.frame_at==self.current_frame then layers_player.copyFrame(self,v)
			elseif v.frame_at>self.current_frame then self.nextFrame=v break end
		end
	end
	if not self.renderFrame.flag then
		if self.previousFrame~=nil and self.nextFrame~=nil then
			if self.previousFrame.img==self.nextFrame.img then
				self.renderFrame.img=self.previousFrame.img
			elseif self.previousFrame.img~='' and self.nextFrame.img~='' and self.previousFrame.img~=self.nextFrame.img then
				self.renderFrame.img=(self.current_frame-self.previousFrame.frame_at)/(self.nextFrame.frame_at-self.previousFrame.frame_at)
			end
			self.renderFrame.x=exani_interpolation(self.previousFrame.x+ran:Float(-abs(self.previousFrame.x_ran),abs(self.previousFrame.x_ran)),self.nextFrame.x+ran:Float(-abs(self.nextFrame.x_ran),abs(self.nextFrame.x_ran)),self.current_frame,self.previousFrame.frame_at,self.nextFrame.frame_at,ReturnTypeName(self.previousFrame.v_type),ReturnTypeName(self.nextFrame.v_type))
			self.renderFrame.y=exani_interpolation(self.previousFrame.y+ran:Float(-abs(self.previousFrame.y_ran),abs(self.previousFrame.y_ran)),self.nextFrame.y+ran:Float(-abs(self.nextFrame.y_ran),abs(self.nextFrame.y_ran)),self.current_frame,self.previousFrame.frame_at,self.nextFrame.frame_at,ReturnTypeName(self.previousFrame.v_type),ReturnTypeName(self.nextFrame.v_type))
			self.renderFrame.cx=exani_interpolation(self.previousFrame.cx,self.nextFrame.cx,self.current_frame,self.previousFrame.frame_at,self.nextFrame.frame_at,ReturnTypeName(self.previousFrame.v_type),ReturnTypeName(self.nextFrame.v_type))
			self.renderFrame.cy=exani_interpolation(self.previousFrame.cy,self.nextFrame.cy,self.current_frame,self.previousFrame.frame_at,self.nextFrame.frame_at,ReturnTypeName(self.previousFrame.v_type),ReturnTypeName(self.nextFrame.v_type))
			self.renderFrame.rot=exani_interpolation(self.previousFrame.rot,self.nextFrame.rot,self.current_frame,self.previousFrame.frame_at,self.nextFrame.frame_at,ReturnTypeName(self.previousFrame.r_type),ReturnTypeName(self.nextFrame.r_type))
			self.renderFrame.hs=exani_interpolation(self.previousFrame.hs,self.nextFrame.hs,self.current_frame,self.previousFrame.frame_at,self.nextFrame.frame_at,ReturnTypeName(self.previousFrame.h_type),ReturnTypeName(self.nextFrame.h_type))
			self.renderFrame.vs=exani_interpolation(self.previousFrame.vs,self.nextFrame.vs,self.current_frame,self.previousFrame.frame_at,self.nextFrame.frame_at,ReturnTypeName(self.previousFrame.h_type),ReturnTypeName(self.nextFrame.h_type))
			self.renderFrame.a=exani_interpolation(self.previousFrame.a,self.nextFrame.a,self.current_frame,self.previousFrame.frame_at,self.nextFrame.frame_at,ReturnTypeName(self.previousFrame.a_type),ReturnTypeName(self.nextFrame.a_type))
			if self.previousFrame.blend==self.nextFrame.blend then
				self.renderFrame.blend=self.previousFrame.blend
			else
				self.renderFrame.blend=(self.current_frame-self.previousFrame.frame_at)/(self.nextFrame.frame_at-self.previousFrame.frame_at)
			end
			self.renderFrame.flag=true
		end
	end
end
---------------------------------------------------------------------------------------------------------------
exani_player=Class(object)
function exani_player:init(name)
	self.name=name
	self.path="Thlib\\exani\\exani_data\\"..name.."\\"
	self.viewmode='world'
	self.layerList=lstg.LoadExaniConfig(self.path)
	self.picList={}
	self.isContainShader=false
	for k,v in pairs(self.layerList) do
		table.insert(self.picList,New(layers_player,v))
	end
	table.sort(self.picList,function(a,b) return a.Prio<b.Prio end)
	exani_player.CheckShader(self)
	exani_player.LoadImgSources(self)
	
	self.isInPlay=false
	self.isStop=false
	self.current_frame=0
	self.start_frame=0
	self.end_frame=0
	self.replay_round=0
	self.play_interval=0
	self.isdelete=true
end

function exani_player:frame()
	if self.isInPlay then
		if self.current_frame==self.end_frame then
			---为-1时无限循环播放，需要停止则调用exani_player_manager.ClearExani(exani_name)函数
			---或者exani_player_manager.StopExani(exani_name)函数
			if self.replay_round~=-1 then
				self.replay_round=self.replay_round-1
			end
			if self.replay_round==0 then
				for k,v in pairs(self.picList) do
					v.renderFlag=false
				end
				self.isInPlay=false
				if self.isdelete then
					Del(self)
				end
			else
				self.current_frame=self.start_frame
				exani_player.UpdateLayers(self)
			end
		else
			self.current_frame=self.current_frame+self.play_interval
			if (self.play_interval>0 and self.current_frame>self.end_frame) or (self.play_interval<0 and self.current_frame<self.end_frame) then
				self.current_frame=self.end_frame
			end
			exani_player.UpdateLayers(self)
		end
	end
end

function exani_player:Del()
	for i=#self.picList,1,-1 do
		Del(self.picList[i])
		table.remove(self.picList,i)
	end
end

function exani_player:LoadImgSources()
	local pngs=lstg.FindFiles(self.path,"png","")
	for k,v in pairs(pngs) do
		local imgname=string.sub(v[1],string.len(self.path)+1,-5)
		LoadImageFromFile(imgname,v[1])
	end
	local jpgs=lstg.FindFiles(self.path,"jpg","")
	for k,v in pairs(jpgs) do
		local imgname=string.sub(v[1],string.len(self.path)+1,-5)
		LoadImageFromFile(imgname,v[1])
	end
end

function exani_player:play(start_frame,end_frame,layer,viewmode,replay_round,play_interval,isdelete)
	self.start_frame=start_frame
	self.end_frame=end_frame
	self.layer=layer
	self.viewmode=viewmode
	self.replay_round=replay_round
	self.play_interval=play_interval
	self.isdelete=isdelete
	
	self.current_frame=self.start_frame
	for k,v in pairs(self.picList) do
		v.layer=self.layer+v.Prio*0.01
		v.viewmode=self.viewmode
		v.current_frame=self.current_frame
		layers_player.CalculateFrame(v)
		v.renderFlag=true
	end
	self.isInPlay=true
	self.isStop=false
end

function exani_player:UpdateLayers()
	for k,v in pairs(self.picList) do
		v.current_frame=self.current_frame
		layers_player.CalculateFrame(v)
	end
end

function exani_player:CheckShader()
	Print('进入CheckShader')
	local hasShader=false
	local hasMasked=false
	for k,v in pairs(self.picList) do
		if v.attr=='shader' then hasShader=true end
		if v.attr=='masked' then hasMasked=true end
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