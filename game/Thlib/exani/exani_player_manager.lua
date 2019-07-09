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

function exani_player_manager:play_exani(exani_name,start_frame,end_frame,layer,viewmode,replay_round,play_interval,isdelete,mode,offset_x,offset_y,z,hscale,vscale)
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
		Print('创建exani对象'..exani_name..'失败')
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
function exani_player_manager:ReStart(exani_name)
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