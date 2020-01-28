Include'TUOlib\\exani\\exani_player.lua'
Include'TUOlib\\exani\\exani_resource.lua'
Include'TUOlib\\exani\\exani_interpolation.lua'

exaniname_list={
	'BossName1A',
	'BossName1B',
	'BossName2',
	'BossName3',
	'ChapterFinished',
	'ChooseBoss_item_Boss1',
	'ChooseBoss_item_Boss2',
	'ChooseBoss_item_Boss3',
	'ChooseChar_marisa',
	'ChooseChar_reimu',
	'ChooseDiff_Easy',
	'ChooseDiff_Hard',
	'ChooseDiff_Lunatic',
	'ChooseDiff_Normal',
	'ChooseDiff_title',
	'ChooseMode_item_NightmareEcli',
	'ChooseMode_item_SpellCardPrac',
	'ChooseMode_item_StagePrac',
	'ChooseMode_item_StoryMode',
	'ChoosePlayer_title',
	'ChooseStage_item_Stage1',
	'ChooseStage_item_Stage2',
	'ChooseStage_item_Stage3',
	'Life_Extend',
	'Manual_item',
	'Manual_title',
	--'Replay_tablePointer',
	'Replay_titleAndTable',
	'Spell_Restored',
	-- 'SpellCardAttack_1A',
	-- 'SpellCardAttack_1B',
	-- 'SpellCardAttack_1F',
	-- 'SpellCardAttack_2',
	-- 'SpellCardAttack_3',
	'SpellCardAttack_4',
	-- 'StageTitle1',
	-- 'StageTitle2',
	-- 'StageTitle3',
	'StageTitle4',
	'Title_Menu_bg',
	'Title_Menu_item_Exit',
	'Title_Menu_item_Gallery',
	'Title_Menu_item_Manual',
	'Title_Menu_item_Musicroom',
	'Title_Menu_item_Option',
	'Title_Menu_item_PlayerData',
	'Title_Menu_item_Replay',
	'Title_Menu_item_Start',
	'Title_Menu_LOGO'
}

	
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

function ReturnTypeName(n)
	if n==1 then return 'instant'
	elseif n==2 then return 'linear'
	elseif n==3 then return 'smooth'
	end
end
	
	
play_manager={}
local EXANI_PATH="TUOlib\\exani\\exani_data\\"

exani_player_manager=Class(object)
function exani_player_manager:init()
	-- self.exanis_path=plus.ReturnDirectory(EXANI_PATH)
	self.exanis_path=exaniname_list
	self.exanis={}
	play_manager=self
end

function exani_player_manager:Del()
	for i=#self.exanis,1,-1 do
		Del(self.exanis[i])
		table.remove(self.exanis,i)
	end
end

function exani_player_manager.LoadAllResource()
	Print('[exani]开始加载所有资源')
	for _,v in pairs(exaniname_list) do
		local name=v
		local path=EXANI_PATH..name.."\\"
		--if not exani_resource_list[v] then error(v) end
		--for _,_v in pairs(exani_resource_list[v]) do
		--	local imgname=string.sub(_v,string.len(path)+1,-5)
			-- Print('[exani]加载exani '..name..'的名为'..imgname..'的部件，文件路径：'.._v)
		--	LoadImageFromFile(imgname,_v)
		--end
        if not FileExist(path.."_loadres.lua") then error(path.." not found _loadres.lua") end
        local _res=lstg.DoFile(path.."_loadres.lua")
        local respath=path.."\\"..name.."_res.png"
        if FileExist(respath) then
            LoadTexture(name.."_res",respath)
        end
        for i=1,#_res do
            if type(_res[i])=="string" then
                local imgname=string.sub(_res[i],1,-5)
                LoadImageFromFile(imgname,path.."\\".._res[i])
            else
                local imgname=string.sub(_res[i][1],1,-5)
                LoadImage(imgname,name.."_res",_res[i][2][1],_res[i][2][2],_res[i][2][3],_res[i][2][4])
            end
        end
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
		-- Print('查看'..exani_name..'future_action')
		-- for k,v in pairs(ex.future_action) do
		-- 	if(type(v)=='string') then
		-- 		Print(v)
		-- 	else
		-- 		Print(v.startf)
		-- 		Print(v.endf)
		-- 		Print(v.repeatc)
		-- 	end
		-- end
		exani_player.DoPredefine(ex)
	elseif i then
		local ex=self.exanis[#self.exanis]
		if next(ex.future_action) then
			for k=#ex.future_action,1,-1 do
				table.remove(ex.future_action,k)
			end
		end
		if not ex.predefine then error('exani_predefine is empty:'..ex.name) end
		for j=1,#ex.predefine[action] do
			table.insert(ex.future_action,ex.predefine[action][j])
		end
		-- Print('查看'..exani_name..'future_action')
		-- for k,v in pairs(ex.future_action) do
		-- 	if(type(v)=='string') then
		-- 		Print(v)
		-- 	else
		-- 		Print(v.startf)
		-- 		Print(v.endf)
		-- 		Print(v.repeatc)
		-- 	end
		-- end
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

function exani_player_manager:SetPlayInterval(exani_name,play_interval)
	for k,v in pairs(self.exanis) do
		if v.name==exani_name then v.play_interval=play_interval end
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