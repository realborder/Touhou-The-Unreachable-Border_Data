special_manual=Class(object)
function special_manual:init()
	self.layer=LAYER_TOP
	self.group=GROUP_GHOST
	
	self.title='Manual_title'
	self.pre_menu='main_menu'
	self.has_logo=false
	self.locked=true
	
	self.choose=1
	self.changed=false --更换选项
	
	self.exani_names={'Manual_item'}
	self.enables={true}

	-- for _,v in ipairs({'Manual_item','Manual_title'}) do
	-- 	exani_player_manager.CreateSingleExani(play_manager,v)
	-- end

	menus['manual_menu']=self
end

function special_manual:frame()
	if self.locked then return end
	
	if self.changed and not KeyTrigger'up' and not KeyTrigger'down' then self.changed=false end
	
	if not self.changed then
		local action
		if KeyTrigger'up' then
			self.choose=self.choose-1
			if self.choose<1 then
				self.choose=10
				action='1to10'
			else
				action=(self.choose+1)..'to'..self.choose
			end
			exani_player_manager.ExecuteExaniPredefine(play_manager,'Manual_item',action)
			PlaySound('select00', 0.3)
			self.changed=true
		elseif KeyTrigger'down' then
			self.choose=self.choose+1
			if self.choose>10 then
				self.choose=1
				action='10to1'
			else
				action=(self.choose-1)..'to'..self.choose
			end
			exani_player_manager.ExecuteExaniPredefine(play_manager,'Manual_item',action)
			PlaySound('select00', 0.3)
			self.changed=true
		elseif KeyTrigger'spell' then
			if self.pre_menu~='' then base_menu.ChangeLocked(self) base_menu.ChangeLocked(menus[self.pre_menu]) end
			PlaySound('cancel00', 0.3)
			self.changed=true
		end
	end
end

-------------------------------------------------

local function FetchReplaySlots()
	local ret = {}
	ext.replay.RefreshReplay()

	for i = 1, ext.replay.GetSlotCount() do
		local text={}
		local slot = ext.replay.GetSlot(i)
		if slot then
			-- 使用第一关的时间作为录像时间
			local date = os.date("!%Y/%m/%d", slot.stages[1].stageDate + setting.timezone * 3600)

			-- 统计总分数
			local totalScore = 0
			local diff,stage_num=0,0
			local tmp
			for i, k in ipairs(slot.stages) do
				totalScore = totalScore + slot.stages[i].score
				diff=string.match(k.stageName,'^.+@(.+)$')
				tmp=string.match(k.stageName,'^(.+)@.+$')
				if string.match(tmp,'%d+')==nil then
					stage_num=tmp
				else
					stage_num='St'..string.match(tmp,'%d+')
				end
			end
			if diff=='Spell Practice' then diff='SpellCard' end
			if tmp=='Spell Practice' then stage_num='SC' end
			if slot.group_finish == 1 then stage_num='All' end
			text = {string.format('No.%02d',i), slot.userName, date, slot.stages[1].stagePlayer, diff, stage_num}
		else
			text = {string.format('No.%02d',i), '--------', '----/--/--', '--------', '--------', '---'}
		end
		table.insert(ret, text)
	end
	return ret
end

special_replay=Class(object)

function special_replay:init()
	self.layer = LAYER_TOP
	self.group = GROUP_GHOST
	self.bound = false
	self.x = screen.width * 0.5 + screen.width
	self.y = screen.height * 0.5-100
	
	self.title='Replay_titleAndTable'
	self.pre_menu='main_menu'
	self.has_logo=false
	self.locked = true

	self.shakeValue = 0

	self.state = 0
	self.state1Selected = 1
	self.state1Text = {}
	self.state2Selected = 1
	self.state2Text = {}

	special_replay.Refresh(self)
	
	menus['replay_menu']=self
		
	for _,v in ipairs({'Replay_titleAndTable'}) do
		exani_player_manager.CreateSingleExani(play_manager,v)
	end
end

function special_replay:Refresh()
	self.state1Text = FetchReplaySlots()
end

function special_replay:frame()
	task.Do(self)
	if self.locked then return end

	if self.shakeValue > 0 then
		self.shakeValue = self.shakeValue - 1
	end

	if self.state == 0 then
		local lastKey = GetLastKey()
		if lastKey == setting.keys.up then
			self.state1Selected = max(1, self.state1Selected - 1)
			self.shakeValue = ui.menu.shake_time
			PlaySound('select00', 0.3)
		elseif lastKey == setting.keys.down then
			self.state1Selected = min(ext.replay.GetSlotCount(), self.state1Selected + 1)
			self.shakeValue = ui.menu.shake_time
			PlaySound('select00', 0.3)
		elseif KeyIsPressed("shoot") then
			-- 构造关卡列表
			local slot = ext.replay.GetSlot(self.state1Selected)
			if slot ~= nil then
				self.state = 1
				self.state2Text = {}
				self.state2Selected = 1
				self.shakeValue = ui.menu.shake_time

				for i, v in ipairs(slot.stages) do
					local stage = string.match(v.stageName,'^(.+)@.+$')
					local score = string.format("%012d", v.score)
					table.insert(self.state2Text, {stage, score})
				end
				PlaySound('ok00', 0.3)
			end
		elseif KeyIsPressed("spell") then
			if self.pre_menu~='' then
				base_menu.ChangeLocked(self)
				base_menu.ChangeLocked(menus[self.pre_menu])
				menu.FadeOut2(replay_menu,'right')
			end
			PlaySound('cancel00', 0.3)
		end
	elseif self.state == 1 then
		local slot = ext.replay.GetSlot(self.state1Selected)
		local lastKey = GetLastKey()
		if lastKey == setting.keys.up then
			self.state2Selected = max(1, self.state2Selected - 1)
			self.shakeValue = ui.menu.shake_time
			PlaySound('select00', 0.3)
		elseif lastKey == setting.keys.down then
			self.state2Selected = min(#slot.stages, self.state2Selected + 1)
			self.shakeValue = ui.menu.shake_time
			PlaySound('select00', 0.3)
		elseif KeyIsPressed("shoot") then
			-- 转场
			local slot = ext.replay.GetSlot(self.state1Selected)
			menu.FadeOut2(replay_menu,'right')
            stage.IsReplay=true--判定进入rep播放的flag add by OLC
            stage.Set('load', slot.path, slot.stages[self.state2Selected].stageName)
			PlaySound('ok00', 0.3)
		elseif KeyIsPressed("spell") then
			self.shakeValue = ui.menu.shake_time
			self.state = 0
		end
	end
end

function special_replay:render()
	if self.locked then return end
	SetViewMode('ui')
	if self.state == 0 then
		ui.DrawRepText(
			"replayfnt",
			"",
			self.state1Text,
			self.state1Selected,
			self.x,
			self.y,
			1,
			self.timer,
			self.shakeValue
			)
	elseif self.state == 1 then
		ui.DrawRepText2(
			"replayfnt",
			"",
			self.state2Text,
			self.state2Selected,
			self.x,
			self.y+120,
			1,
			self.timer,
			self.shakeValue,
			"center")
	end
end

function menu:FadeIn2()
	self.x=screen.width*0.5
	task.Clear(self)
	task.New(self,function()
		for i=0,29 do
			self.alpha=i/29
			task.Wait()
		end
	end)
end

function menu:FadeOut2()
	task.Clear(self)
	if not self.locked then
		task.New(self,function()
			for i=29,0,-1 do
				self.alpha=i/29
				task.Wait()
			end
		end)
	end
end

-------------------------------------
special_scpractice=Class(object)
function special_scpractice:init()
    self.bound=false
    self.pre_menu='start_menu'
    self.has_logo=false
    self.locked=true
    
    self.init_timer=0
    self.init_delay=10
    
    menus['scpractice_menu']=self
    
    menu_sc_pr=New(sc_pr_menu,function(index)
        if index then
            last_menu=menu_sc_pr
            lstg.var.sc_index=index
            menu.FlyOut(menu_sc_pr,'left')
        else
            menu.FlyOut(menu_sc_pr,'right')
        end
    end)
end

function special_scpractice:frame()
    if self.locked then return end
    
    self.init_timer=self.init_timer+1
    
    if self.init_timer>self.init_delay then
        if KeyTrigger'shoot' then
            base_menu.ChangeLocked(self)
            base_menu.ChangeLocked(menus['player_menu'])
            exani_player_manager.ExecuteExaniPredefine(play_manager,'ChooseChar_reimu','init')
        end
        
        if KeyTrigger 'spell' then
            base_menu.ChangeLocked(self)
            base_menu.ChangeLocked(menus[self.pre_menu])
        end
    end
end

-------------------------------------
special_difficulty=Class(object)
function special_difficulty:init()
	self.layer=LAYER_TOP-5
	self.group=GROUP_GHOST
	self.bound=false
	
	self.title='ChooseDiff_title'
	self.pre_menu={'start_menu','stage_menu'}
	self.menu_back=1
	self.has_logo=false
	self.locked=true
	self.init_timer=0
	self.init_delay=15
	
	self.choose=2
	self.pre_choose=0
	self.changed=false
	
	self.choose_timer=-1
	self.choose_delay=25
	
	self.interval_timer=0
	self.interval_delay=5
	
	self.cancel_timer=0
	self.cancel_delay=30
	
	self.is_choose=false
	self.delay=0
	
	self.pics={'ChooseDiff_Easy','ChooseDiff_Normal','ChooseDiff_Hard','ChooseDiff_Lunatic'} --exani名字刚好和图片相同
	
	self.gap=480
	self.repeats=3
	self.speed=0.5
	self.y=200
	self.z=10
	self.tmpdx=0
	
	self.current_dx=0.5*self.gap
	self.destinate_dx=0.5*self.gap
	self.multiply=0.1
	
	self.x_offset={}
	for i=(#self.pics)*self.repeats/2,1,-1 do
		local dx=-self.gap*(i-0.5)
		table.insert(self.x_offset,dx)
	end
	for i=1,(#self.pics)*self.repeats/2 do
		local dx=self.gap*(i-0.5)
		table.insert(self.x_offset,dx)
	end
	
	menus['diff_menu']=self

	exani_player_manager.CreateSingleExani(play_manager,self.title)
	for _,v in ipairs(self.pics) do
		exani_player_manager.CreateSingleExani(play_manager,v)
	end
end

function special_difficulty:frame()
	if self.cancel_timer>0 then
		self.cancel_timer=self.cancel_timer-1
		local z=exani_interpolation(self.z-0.5,0,self.cancel_delay-self.cancel_timer+1,1,self.cancel_delay,'smooth','smooth')
		Set3D('eye',0,0,z)
	end
	
	if self.delay>0 then self.delay=self.delay-1 end

	if self.locked or self.delay>0 then return end
	self.init_timer=self.init_timer+1
	if self.changed and not KeyTrigger'left' and not KeyTrigger'right' then self.changed=false end
	
	if self.interval_timer>0 then self.interval_timer=self.interval_timer-1 end
	if self.choose_timer>=0 then self.choose_timer=self.choose_timer-1 end
	
	if self.init_timer>0 and self.init_timer<=self.init_delay then
		local z=exani_interpolation(0,self.z-0.5,self.init_timer,1,self.init_delay,'smooth','smooth')
		Set3D('eye',0,0,z)
		self.choose=2
	end
	
	if self.init_timer==self.init_delay then
		self.current_dx=0.5*self.gap
		self.destinate_dx=0.5*self.gap
		self.interval_timer=self.interval_delay
		exani_player_manager.ExecuteExaniPredefine(play_manager,self.pics[self.choose],'activate')
	end
	
	if self.destinate_dx>2*self.gap then
		self.destinate_dx=self.destinate_dx-4*self.gap
		self.current_dx=self.current_dx-4*self.gap
	elseif self.destinate_dx<-2*self.gap then
		self.destinate_dx=self.destinate_dx+4*self.gap
		self.current_dx=self.current_dx+4*self.gap
	end
	
	if self.current_dx~=self.destinate_dx then
		self.current_dx=self.current_dx+(self.destinate_dx-self.current_dx)*self.multiply
	end
	
	if abs(self.destinate_dx-self.current_dx)<0.1 then
		self.current_dx=self.destinate_dx
	end
	
	if self.init_timer>self.init_delay and self.interval_timer==0 and not self.is_choose then
		if KeyTrigger'left' then
			self.pre_choose=self.choose
			self.choose=self.choose-1
			if self.choose==0 then self.choose=#self.pics end
			self.interval_timer=self.interval_delay
			self.destinate_dx=self.destinate_dx+self.gap
			PlaySound('select00', 0.3)
			exani_player_manager.ExecuteExaniPredefine(play_manager,self.pics[self.choose],'activate')
			exani_player_manager.ExecuteExaniPredefine(play_manager,self.pics[self.pre_choose],'deactivate')
			self.changed=true
		elseif KeyTrigger'right' then
			self.pre_choose=self.choose
			self.choose=self.choose+1
			if self.choose==(#self.pics+1) then self.choose=1 end
			self.interval_timer=self.interval_delay
			self.destinate_dx=self.destinate_dx-self.gap
			PlaySound('select00', 0.3)
			exani_player_manager.ExecuteExaniPredefine(play_manager,self.pics[self.choose],'activate')
			exani_player_manager.ExecuteExaniPredefine(play_manager,self.pics[self.pre_choose],'deactivate')
			self.changed=true
		elseif KeyTrigger'shoot' then
			self.is_choose=true
			exani_player_manager.ExecuteExaniPredefine(play_manager,self.pics[self.choose],'choose')
			self.choose_timer=self.choose_delay
			PlaySound('ok00', 0.3)
		elseif KeyTrigger'spell' then
			base_menu.ChangeLocked(self)
			self.cancel_timer=self.cancel_delay
			self.timer=0
			if self.pre_menu[self.menu_back]~='' then base_menu.ChangeLocked(menus[self.pre_menu[self.menu_back]]) end
			exani_player_manager.ExecuteExaniPredefine(play_manager,self.pics[self.choose],'deactivate')
			PlaySound('cancel00', 0.3)
		end
	end
	
	for i=1,#self.pics do
		local exani=exani_player_manager.GetExani(play_manager,self.pics[i])
		if exani.isInPlay then
			local x_fix=640/2
			local y_fix=480/2
			local dx=10000
			for j=0,(self.repeats-1) do
				if abs(self.x_offset[i+4*j]+self.current_dx)<abs(dx) then
					dx=self.x_offset[i+4*j]+self.current_dx
				end
			end
			exani_player_manager.SetExaniAttribute(play_manager,self.pics[i],nil,nil,nil,nil,nil,nil,nil,'3d',dx+x_fix,y_fix,self.z,0.5,0.5)
		end
	end
	
	if self.choose_timer==0 and self.is_choose then
		self.change_timer=0
		if self.title then exani_player_manager.ExecuteExaniPredefine(play_manager,self.title,'kill') end
		
		base_menu.ChangeLocked(menus['player_menu'])
		exani_player_manager.ExecuteExaniPredefine(play_manager,'ChooseChar_reimu','init')
	end
end

function special_difficulty:render()
	local scalefix=0.5
	if self.locked and not self.is_choose then
		SetViewMode('ui')
		local dx=(self.timer*self.speed)%((#self.pics)*self.gap)
		self.tmpdx=dx
		for i=1,(#self.pics)*self.repeats do
			local x=self.x_offset[i]+dx
			local n=i%(#self.pics)
			if n==0 then n=#self.pics end
			Render(self.pics[n],x,self.y,0,1*scalefix,1*scalefix,self.z)
		end
	elseif not self.locked and self.init_timer>0 and self.init_timer<=self.init_delay then
		SetViewMode('ui')
		local dx=exani_interpolation(self.tmpdx,self.gap*(3-self.choose),self.init_timer,1,self.init_delay,'smooth','smooth')
		for i=1,(#self.pics)*self.repeats do
			local x=self.x_offset[i]+dx
			local n=i%(#self.pics)
			if n==0 then n=#self.pics end
			Render(self.pics[n],x,self.y,0,1*scalefix,1*scalefix,self.z)
		end
	elseif not self.locked then
		for i=1,(#self.pics)*self.repeats do
			local x=self.x_offset[i]
			local n=i%(#self.pics)
			if n==0 then n=#self.pics end
			local tmpcx,tmpcy=GetImageSize(self.pics[n])
			Render(self.pics[n],x+self.current_dx+tmpcx/2,self.y,0,1*scalefix,1*scalefix,self.z)
		end
	end
end

-------------------------------------
stage_diffs={'Easy','Normal','Hard','Lunatic'}
stage_choices={'Stage 1','Stage 1','Stage 2','Stage 2','Stage 3','Stage 3'}


special_player=Class(object)
function special_player:init()
	self.layer=LAYER_TOP
	self.group=GROUP_GHOST
	self.bound=false
	
    self.pre_menu={'diff_menu','scpractice_menu'}
	self.menu_back=1
    
	self.title='ChoosePlayer_title'
	self.has_logo=false
	self.locked=true
	self.init_timer=0
	self.init_delay=15
	
	self.choose=1
	self.choose_timer=-1
	self.choose_delay=48
	
	self.cancel_timer=0
	self.cancel_delay=30
	
	self.changed=false
	
	self.z=1
	
	self.player={'ChooseChar_reimu','ChooseChar_marisa'}
	
	menus['player_menu']=self

	exani_player_manager.CreateSingleExani(play_manager,self.title)
	for _,v in ipairs(self.player) do
		exani_player_manager.CreateSingleExani(play_manager,v)
	end
end

function special_player:frame()
	task.Do(self)
	if self.cancel_timer>0 then
		self.cancel_timer=self.cancel_timer-1
		local z=exani_interpolation(self.z-0.5,menus['diff_menu'].z-0.5,self.cancel_delay-self.cancel_timer+1,1,self.cancel_delay,'smooth','smooth')
		Set3D('at',0,0,z)
	end

	if self.locked then return end
	
	self.init_timer=self.init_timer+1
	if self.changed and not KeyTrigger'left' and not KeyTrigger'right'
		and not KeyTrigger'up' and not KeyTrigger'down' then self.changed=false end
	
	if self.choose_timer>=0 then self.choose_timer=self.choose_timer-1 end
	
	if self.init_timer>0 and self.init_timer<=self.init_delay then
		local z=exani_interpolation(menus['diff_menu'].z-0.5,self.z-0.5,self.init_timer,1,self.init_delay,'smooth','smooth')
		Set3D('at',0,0,z)
	end
	
	if self.init_timer>self.init_delay and not self.changed and self.cancel_timer==0 and self.choose_timer==-1 then
		if KeyTrigger'down' then
			if (self.choose%2)==1 then
				self.changed=true
				self.choose=self.choose+1
				PlaySound('select00', 0.3)
				exani_player_manager.ExecuteExaniPredefine(play_manager,self.player[self.choose/2],'AtoB')
			end
		elseif KeyTrigger'up' then
			if (self.choose%2)==0 then
				self.changed=true
				self.choose=self.choose-1
				PlaySound('select00', 0.3)
				exani_player_manager.ExecuteExaniPredefine(play_manager,self.player[(self.choose+1)/2],'BtoA')
			end
		elseif KeyTrigger'right' then
			if self.choose<3 then
				self.changed=true
				PlaySound('select00', 0.3)
				local action=''
				if self.choose==1 then action='killA' else action='killB' end
				exani_player_manager.ExecuteExaniPredefine(play_manager,self.player[1],action)
				self.choose=3
				exani_player_manager.ExecuteExaniPredefine(play_manager,self.player[2],'init')
			end
		elseif KeyTrigger'left' then
			if self.choose>2 then
				self.changed=true
				PlaySound('select00', 0.3)
				local action=''
				if self.choose==3 then action='killA' else action='killB' end
				exani_player_manager.ExecuteExaniPredefine(play_manager,self.player[2],action)
				self.choose=1
				exani_player_manager.ExecuteExaniPredefine(play_manager,self.player[1],'init')
			end
		elseif KeyTrigger'spell' then
			self.cancel_timer=self.cancel_delay
			base_menu.ChangeLocked(self)
            if self.menu_back==1 then
                local diff=menus['diff_menu']
                diff.locked=false
                diff.is_choose=false
                diff.pre_choose=0
                diff.delay=30
                exani_player_manager.ExecuteExaniPredefine(play_manager,diff.title,'init')
                exani_player_manager.ExecuteExaniPredefine(play_manager,diff.pics[diff.choose],'unchoose')
            elseif self.menu_back==2 then
                base_menu.ChangeLocked(menus['scpractice_menu'])
                menu.FlyIn(menu_sc_pr,'left')
            end
			if self.choose==1 then exani_player_manager.ExecuteExaniPredefine(play_manager,self.player[1],'killA')
			elseif self.choose==2 then exani_player_manager.ExecuteExaniPredefine(play_manager,self.player[1],'killB')
			elseif self.choose==3 then exani_player_manager.ExecuteExaniPredefine(play_manager,self.player[2],'killA')
			elseif self.choose==4 then exani_player_manager.ExecuteExaniPredefine(play_manager,self.player[2],'killB')
			end
			PlaySound('cancel00', 0.3)
		elseif KeyTrigger'shoot' then
			self.choose_timer=self.choose_delay
			PlaySound('ok00', 0.3)
			if self.choose==1 then exani_player_manager.ExecuteExaniPredefine(play_manager,self.player[1],'chooseA')
			elseif self.choose==2 then exani_player_manager.ExecuteExaniPredefine(play_manager,self.player[1],'chooseB')
			elseif self.choose==3 then exani_player_manager.ExecuteExaniPredefine(play_manager,self.player[2],'chooseA')
			elseif self.choose==4 then exani_player_manager.ExecuteExaniPredefine(play_manager,self.player[2],'chooseB')
			end
		end
	end
	
	if self.choose_timer==0 then 
	-- if self.choose_timer==0 and self.choose ~= 2 then --上t锁定梦B
		base_menu.ChangeLocked(self)
		scoredata.player_select=self.choose
		lstg.var.player_name=player_list[self.choose][2]
        lstg.var.rep_player=player_list[self.choose][3]
		exani_player_manager.ExecuteExaniPredefine(play_manager,'Title_Menu_bg','kill')
		task.New(player_menu,function() for i=1,60 do SetBGMVolume('menu',1-i/60) task.Wait() end end)
		local diff=menus['diff_menu']
		local stage_pr=menus['stage_menu']
		task.New(player_menu,function()
			task.Wait(30)
			New(mask_fader,'close','fullscreen')
			task.Wait(30)
			if practice=='stage' then
				-- Print("关卡练习参数是 "..stage_choices[stage_pr.choose]..'@'..stage_diffs[diff.choose])
				stage.group.PracticeStart(stage_choices[stage_pr.choose]..'@'..stage_diffs[diff.choose])
            elseif practice=='spell' then
                stage.IsSCpractice=true--判定进入符卡练习的flag add by OLC
                stage.group.PracticeStart('Spell Practice@Spell Practice')
			else
				stage.group.Start(stage.groups[stage_diffs[diff.choose]])
			end
        end)
	end
end

function special_player:render()

end