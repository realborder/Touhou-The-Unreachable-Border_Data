menus={}

base_menu=Class(object)
--options格式为含有多个('exani','next_menu_name',function(),enable)的表,其中next_menu_name和function()可为''
function base_menu:init(name,title,options,pre_menu,has_logo)
	self.layer=LAYER_TOP
	self.group=GROUP_GHOST
	
	self.name=name
	self.title=title
	self.exani_names={}
	self.menu_names={}
	self.functions={}
	self.enables={}
	for i=1,#options do
		self.exani_names[i]=options[i][1]
		self.menu_names[i]=options[i][2]
		self.functions[i]=options[i][3]
		self.enables[i]=options[i][4]
	end
	self.pre_menu=pre_menu
	if has_logo then self.has_logo=true else self.has_logo=false end
	
	self.locked=true
	self.choose=1
	self.changed=false --更换选项
	self.choosed=false --选中选项(包括z和x)
	
	self.init_delay=30 --init时间
	self.init_timer=0 --init后的计时
	
	self.choose_delay=30 --选中后播放选中动画的时间以便于跳转下一个菜单
	self.choose_timer=-1
	
	menus[name]=self
end

function base_menu:frame()
	if self.locked then return end
	self.init_timer=self.init_timer+1
	if self.choose_timer>=0 then self.choose_timer=self.choose_timer-1 end
	
	if self.choose_timer==-1 and self.init_timer>30 then
		if not self.changed and lstg.GetKeyState(KEY.UP) then self.choose=self.choose-1 end
		if not self.changed and lstg.GetKeyState(KEY.DOWN) then self.choose=self.choose+1 end
		if self.choose<1 then self.choose=#self.exani_names end
		if self.choose>#self.exani_names then self.choose=1 end
		if not self.choosed and lstg.GetKeyState(KEY.Z) then self.choosed=true self.choose_timer=self.choose_delay end
		if not self.choosed and lstg.GetKeyState(KEY.X) then self.choosed=true end
	end
end

--理论上这些应该都要放在frame里,因为执行预定义的函数并不直接涉及渲染函数
--但是为了看起来清楚，就放到render里了
function base_menu:render()
	if self.locked then return end
	
	if self.init_timer==30 then
		if self.title~='' then exani_player_manager.ExecuteExaniPredefine(play_manager,self.title,'activate') end
		local action
		if self.enables[self.choose] then action='activate' else action='activate_unable' end
		exani_player_manager.ExecuteExaniPredefine(play_manager,self.exani_names[self.choose],action)
	end
	
	if self.choosed then
		if lstg.GetKeyState(KEY.Z) then
			local action
			if self.enables[self.choose] then action='choose' else action='choose_unable' end
			exani_player_manager.ExecuteExaniPredefine(play_manager,self.exani_names[self.choose],action)
		elseif lstg.GetKeyState(KEY.X) then
			if self.pre_menu~='' then base_menu.ChangeLocked(self) base_menu.ChangeLocked(menus[self.pre_menu]) end
		end
		self.choosed=false
	end
	
	if self.choose_timer==0 then
		base_menu.ChangeLocked(self)
		if self.menu_names[self.choose]~='' then base_menu.ChangeLocked(menus[self.menu_names[self.choose]]) end
		if self.functions[self.choose]~='' then self.functions[self.choose]() end
	end
	
	if self.changed then
		local action
		if self.enables[self.choose] then action='activate' else action='activate_unable' end
		exani_player_manager.ExecuteExaniPredefine(play_manager,self.exani_names[self.choose],action)
		local pos=self.choose
		if lstg.GetKeyState(KEY.UP) then
			pos=self.choose+1
			if pos>#self.exani_names then pos=1 end
		elseif lstg.GetKeyState(KEY.DOWN) then
			pos=self.choose-1
			if pos<1 then pos=#self.exani_names end
		end
		exani_player_manager.ExecuteExaniPredefine(play_manager,self.exani_names[pos],'deactivate')
		self.changed=false
	end
	
end

function base_menu:ChangeLocked()
	self.locked=not self.locked
	local action
	if self.locked then action='kill' self.init_timer=0 self.choose_timer=-1 else action='init' end
	if self.title~='' then exani_player_manager.ExecuteExaniPredefine(play_manager,self.title,action) end
	if self.has_logo then exani_player_manager.ExecuteExaniPredefine(play_manager,'Title_Menu_LOGO',action) end
	for i=1,#self.exani_names do
		if self.enables[i] then action='init' else action='init_unable' end
		exani_player_manager.ExecuteExaniPredefine(play_manager,self.exani_names[i],action)
	end
end