local EXANI_PATH="Thlib\\exani\\exani_data\\"

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
	self.manager_name=''
	self.manager=nil
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
			
			if self.attr=='shader' or self.attr=='final_shader' then PushRenderTarget('RTS'..self.manager_name)
			elseif self.attr=='masked' then PushRenderTarget('RTM'..self.manager_name) end
			
			if type(self.renderFrame.blend)=='string' then
				if type(self.renderFrame.img)=='string' then
					SetImageState(imgname,self.renderFrame.blend,Color(self.renderFrame.a,255,255,255))
					layers_player.render_choose(self,imgname)
				elseif type(self.renderFrame.img)=='number' then
					SetImageState(imgname1,self.renderFrame.blend,Color(self.renderFrame.a*(1-self.renderFrame.img),255,255,255))
					layers_player.render_choose(self,imgname1)
					SetImageState(imgname2,self.renderFrame.blend,Color(self.renderFrame.a*self.renderFrame.img,255,255,255))
					layers_player.render_choose(self,imgname2)
				end
			elseif type(self.renderFrame.blend)=='number' then
				if type(self.renderFrame.img)=='string' then
					SetImageState(imgname,self.previousFrame.blend,Color(self.renderFrame.a*(1-self.renderFrame.blend),255,255,255))
					layers_player.render_choose(self,imgname)
					SetImageState(imgname,self.nextFrame.blend,Color(self.renderFrame.a*self.renderFrame.blend,255,255,255))
					layers_player.render_choose(self,imgname)
				elseif type(self.renderFrame.img)=='number' then
					SetImageState(imgname1,self.previousFrame.blend,Color(self.renderFrame.a*(1-self.renderFrame.blend),255,255,255))
					layers_player.render_choose(self,imgname1)
					SetImageState(imgname2,self.nextFrame.blend,Color(self.renderFrame.a*self.renderFrame.blend,255,255,255))
					layers_player.render_choose(self,imgname2)
				end				
			end
			
			if self.attr=='shader' or self.attr=='final_shader' then PopRenderTarget('RTS'..self.manager_name)
			elseif self.attr=='masked' then PopRenderTarget('RTM'..self.manager_name) end
			
			if self.attr=='final_shader' then
				PostEffect('RTM'..self.manager_name,self.manager_name..'FX','',{tex='RTS'..self.manager_name})
				PushRenderTarget('RTS'..self.manager_name)
				RenderClear(Color(0,0,0,0))
				PopRenderTarget('RTS'..self.manager_name)
				PushRenderTarget('RTM'..self.manager_name)
				RenderClear(Color(0,0,0,0))
				PopRenderTarget('RTM'..self.manager_name)
			end
			
		end
	end
end

function layers_player:render_choose(img)
	if self.manager.mode=='3d' then
		Render(img,self.renderFrame.x+self.manager.center_dx,self.renderFrame.y+self.manager.center_dy,self.renderFrame.rot,self.renderFrame.hs*self.manager._hscale,self.renderFrame.vs*self.manager._vscale,self.manager.z)
	else
		Render(img,self.renderFrame.x,self.renderFrame.y,self.renderFrame.rot,self.renderFrame.hs,self.renderFrame.vs)
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
	if self.previousFrame and self.current_frame==self.previousFrame.frame_at then layers_player.copyFrame(self,self.previousFrame)
	elseif self.nextFrame and self.current_frame==self.nextFrame.frame_at then layers_player.copyFrame(self,self.nextFrame)
	elseif self.previousFrame and self.nextFrame and self.current_frame>self.previousFrame.frame_at and self.current_frame<self.nextFrame.frame_at then
	else
		self.previousFrame=nil
		self.nextFrame=nil
		for k,v in pairs(self.keyFrames) do
			if not self.current_frame then error('How is it happend? \"self.current_frame\" is nil') end
			if v.frame_at<self.current_frame then self.previousFrame=v
			elseif v.frame_at== self.current_frame then layers_player.copyFrame(self,v)
			elseif v.frame_at>self.current_frame then self.nextFrame=v break end
		end
	end
	if not self.renderFrame.flag then
		layers_player.CalculateInterpolation(self)
	end
end

function layers_player:CalculateInterpolation()
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
---------------------------------------------------------------------------------------------------------------
exani_player=Class(object)
function exani_player:init(name)
	self.name=name
	self.path=EXANI_PATH..name.."\\"
	self.viewmode='world'
	self.layer=LAYER_TOP --默认最顶层
	self.layerList=lstg.LoadExaniConfig(self.path)
	self.picList={}
	self.isContainShader=false
	for k,v in pairs(self.layerList) do
		table.insert(self.picList,New(layers_player,v))
	end
	table.sort(self.picList,function(a,b) return a.Prio<b.Prio end)
	for k,v in pairs(self.picList) do
		v.manager=self
	end
	exani_player.CheckShader(self)
	exani_player.LoadImgSources(self)
	
	self.isforce=false --强制补间
	self.force_time=10 --补间时长
	
	self.isInPlay=false
	self.isStop=false
	self.current_frame=0
	self.start_frame=0
	self.end_frame=0
	self.replay_round=1 --默认播放次数1
	self.play_interval=1 --默认播放间隔1（即正常速度）
	self.isdelete=false --默认播完不自毁
	self.mode=''
	if next(FindFiles(self.path,"lua","")) then
		self.predefine=lstg.DoFile(self.path.."_exani_predefine.lua")
		if not self.predefine then error('Oops! Load exani['..self.name..'] predefine failed! We do not know why, please check it!') end
	end
	self.future_action={}
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
				if self.isforce then self.isforce=false end
				if self.isdelete then
					Del(self)
				else
					if next(self.future_action) then table.remove(self.future_action,1) end
					if next(self.future_action) then exani_player.DoPredefine(self) end
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

function exani_player:play(start_frame,end_frame,layer,viewmode,replay_round,play_interval,isdelete,mode,offset_x,offset_y,z,hscale,vscale)
	self.start_frame=start_frame
	self.end_frame=end_frame
	self.layer=layer
	self.viewmode=viewmode
	self.replay_round=replay_round
	self.play_interval=play_interval
	self.isdelete=isdelete
	self.mode=mode
	self.center_dx=offset_x
	self.center_dy=offset_y
	self.z=z
	self._hscale=hscale
	self._vscale=vscale
	
	self.current_frame=self.start_frame
	for k,v in pairs(self.picList) do
		v.layer=self.layer+v.Prio*0.01
		v.screenMode=self.viewmode
		v.current_frame=self.current_frame
		layers_player.CalculateFrame(v)
		v.renderFlag=true
	end
	self.isInPlay=true
	self.isStop=false
	if next(self.future_action) then
		for i=#self.future_action,1,-1 do
			table.remove(self.future_action,i)
		end
	end
end

function exani_player:DoPredefine()
	exani_player.GetActionValue(self)
	if type(self.future_action[1][1])==string then --默认强制补间后面的不是action字符串
		self.isforce=true
		self.replay_round=1
		self.play_interval=1
		self.current_frame=1
		self.force_time=self.future_action[1].force_interpolation_time
		for k,v in pairs(self.picList) do
			v.renderFlag=true
			v.previousFrame=v.renderFrame
			v.previousFrame.frame_at=1
			for i=1,#v.keyFrames do
				if v.keyFrames[i].frame_at==self.future_action[2].startf then
					v.nextFrame=v.keyFrames[i]
					v.nextFrame.frame_at=self.force_time+1
				end
			end
			v.current_frame=1
			--v.current_frame=self.current_frame
			--if not v.current_frame then error('Dont ya kidding me!') end
		end
		self.start_frame=1
		self.end_frame=self.force_time+1
		self.isInPlay=true
		self.isStop=false
	else
		self.start_frame=self.future_action[1].startf
		self.end_frame=self.future_action[1].endf
		self.replay_round=self.future_action[1].repeatc or 1
		self.current_frame=self.start_frame
		for k,v in pairs(self.picList) do
			v.current_frame=1
			--v.current_frame=self.current_frame
			--if not v.current_frame then error('You\'ve got be kidding me!') end
			layers_player.CalculateFrame(v)
			v.renderFlag=true
		end
		self.isInPlay=true
		self.isStop=false
	end
end

function exani_player:SetAttribute(start_frame,end_frame,layer,viewmode,replay_round,play_interval,isdelete,mode,offset_x,offset_y,z,hscale,vscale)
	self.start_frame=start_frame or self.start_frame
	self.end_frame=end_frame or self.end_frame
	self.layer=layer or self.layer
	self.viewmode=viewmode or self.viewmode
	self.replay_round=replay_round or self.replay_round
	self.play_interval=play_interval or self.play_interval
	if isdelete~=nil then self.isdelete=isdelete end
	self.mode=mode or self.mode
	self.center_dx=offset_x or self.center_dx
	self.center_dy=offset_y or self.center_dy
	self.z=z or self.z
	self._hscale=hscale or self._hscale
	self._vscale=vscale or self._vscale
	
	if layer~=nil or viewmode~=nil then
		for k,v in pairs(self.picList) do
			v.layer=self.layer+v.Prio*0.01
			v.screenMode=self.viewmode
			layers_player.CalculateFrame(v)
		end
	end
end

function exani_player:GetActionValue()
	local is_ok=false
	while(not is_ok)
	do
		is_ok=true
		if type(self.future_action[1])==string then
			is_ok=false
			local action=self.future_action[1]
			table.remove(self.future_action,1)
			for i=#self.predefine[action],1,-1 do
				table.insert(self.future_action,1,self.predefine[action][i])
			end
		end
	end
end

function exani_player:UpdateLayers()
	for k,v in pairs(self.picList) do
		v.current_frame=self.current_frame
		if not self.isforce then
			layers_player.CalculateFrame(v)
		else
			layers_player.CalculateInterpolation(v)
		end
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
			v.manager_name=self.name
		end
	elseif hasShader or hasMasked then
		for k,v in pairs(self.picList) do
			v.attr=''
		end
	end
end