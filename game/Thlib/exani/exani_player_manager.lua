Include'THlib\\exani\\exani_player.lua'

play_manager={}
local EXANI_PATH="Thlib\\exani\\exani_data\\"

exani_player_manager=Class(object)
function exani_player_manager:init()
	self.exanis_path=plus.ReturnDirectory(EXANI_PATH)
	self.exanis={}
	play_manager=self
end

function exani_player_manager:Del()
	for i=#self.exanis,1,-1 do
		Del(self.exanis[i])
		table.remove(self.exanis,i)
	end
end

--创建单个exani对象
function exani_player_manager:CreateSingleExani(exani_name)
	for i=1,#self.exanis do
		if self.exanis[i].name==exani_name then return i end
	end
	for k,v in pairs(self.exanis_path) do
		if v==exani_name then
			table.insert(self.exanis,New(exani_player,v))
			return true
		end
	end
	return false
end

--初始化exani播放状态
function exani_player_manager:play_exani(exani_name,start_frame,end_frame,layer,viewmode,replay_round,play_interval,isdelete,mode,offset_x,offset_y,z,hscale,vscale)
	if not exani_name or not start_frame or not end_frame then
		Print("init exani play failed! need necessary param!")
	end
	
	if mode=='3d' then
		if offset_x==nil then offset_x=0 end
		if offset_y==nil then offset_y=0 end
		if z==nil then z=0.5 end
		if hscale==nil then hscale=1 end
		if vscale==nil then vscale=1 end
	end
	
	if isdelete==nil then isdelete=true end
	if play_interval==nil then play_interval=1 end
	if replay_round==nil then replay_round=1 end
	if viewmode==nil then viewmode='world' end
	if layer==nil then layer=LAYER_TOP end
	
	if start_frame>end_frame then
		play_interval=-play_interval
	end
	
	local i=exani_player_manager.CreateSingleExani(self,exani_name)
	if type(i)=='number' then
		exani_player.play(self.exanis[i],start_frame,end_frame,layer,viewmode,replay_round,play_interval,isdelete,mode,offset_x,offset_y,z,hscale,vscale)
	elseif i then
		local j=#self.exanis
		exani_player.play(self.exanis[j],start_frame,end_frame,layer,viewmode,replay_round,play_interval,isdelete,mode,offset_x,offset_y,z,hscale,vscale)
	else
		error('create exani object named: '..exani_name..' failed')
		--Print('创建exani对象'..exani_name..'失败')
	end
end

--执行预定义动作(有瑕疵，建议先创建Set好属性再调用，或者之前play过也行，之后再改)
function exani_player_manager:ExecuteExaniPredefine(exani_name,action)
	local i=exani_player_manager.CreateSingleExani(self,exani_name)
	if type(i)=='number' then
		local ex=self.exanis[i]
		if next(ex.future_action) then
			for k=#ex.future_action,1,-1 do
				table.remove(ex.future_action,k)
			end
		end
		for j=1,#ex.predefine[action] do
			table.insert(ex.future_action,ex.predefine[action][j])
		end
		exani_player.DoPredefine(ex)
	elseif i then
		local ex=self.exanis[#self.exanis]
		if next(ex.future_action) then
			for k=#ex.future_action,1,-1 do
				table.remove(ex.future_action,k)
			end
		end
		for j=1,#ex.predefine[action] do
			table.insert(ex.future_action,ex.predefine[action][j])
		end
		exani_player.DoPredefine(ex)
	else
		error('create exani object named:'..exani_name..' failed')
		--Print('创建exani对象'..exani_name..'失败')
	end
end

--设置exani属性
function exani_player_manager:SetExaniAttribute(exani_name,start_frame,end_frame,layer,viewmode,replay_round,play_interval,isdelete,mode,offset_x,offset_y,z,hscale,vscale)
	for i=#self.exanis,1,-1 do
		if self.exanis[i].name==exani_name then
			exani_player.SetAttribute(self.exanis[i],start_frame,end_frame,layer,viewmode,replay_round,play_interval,isdelete,mode,offset_x,offset_y,z,hscale,vscale)
		end
	end
end

function exani_player_manager:GetExani(exani_name)
	for k,v in pairs(self.exanis) do
		if v.name==exani_name then return v end
	end
end

---清除exani，exani_name为''则清除所有
function exani_player_manager:ClearExani(exani_name)
	if exani_name=='' then
		for i=#self.exanis,1,-1 do
			Del(self.exanis[i])
			table.remove(self.exanis,i)
		end
	else
		for i=#self.exanis,1,-1 do
			if self.exanis[i].name==exani_name then
				Del(self.exanis[i])
				table.remove(self.exanis,i)
			end
		end
	end
end

---停止播放exani，exani_name为''则停止所有
function exani_player_manager:StopExani(exani_name)
	if exani_name=='' then
		for i=1,#self.exanis do
			self.exanis[i].isInPlay=false
			self.exanis[i].isStop=true
			for k,v in pairs(self.exanis[i].picList) do
				v.renderFlag=false
			end
		end
	else
		for i=1,#self.exanis do
			if self.exanis[i].name==exani_name then
				self.exanis[i].isInPlay=false
				self.exanis[i].isStop=true
				for k,v in pairs(self.exanis[i].picList) do
					v.renderFlag=false
				end
			end
		end
	end
end

---将停止播放的exani继续播放
function exani_player_manager:Resume(exani_name)
	if exani_name=='' then
		for i=1,#self.exanis do
			if self.exanis[i].isStop then
				self.exanis[i].isInPlay=true
				self.exanis[i].isStop=false
				for k,v in pairs(self.exanis[i].picList) do
					v.renderFlag=true
				end
			end
		end
	else
		for i=1,#self.exanis do
			if self.exanis[i].name==exani_name then
				if self.exanis[i].isStop then
					self.exanis[i].isInPlay=true
					self.exanis[i].isStop=false
					for k,v in pairs(self.exanis[i].picList) do
						v.renderFlag=true
					end
				end
			end
		end
	end
end

---删除所有
function exani_player_manager:ClearAll()
	Del(self)
end