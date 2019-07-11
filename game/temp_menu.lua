menus={}

base_menu=Class(object)
--options格式为含有多个('exani','next_menu_name',function())的表,其中next_menu_name和function()可为''
function base_menu:init(name,title,options,pre_menu)
	self.layer=LAYER_TOP
	self.group=GROUP_GHOST
	
	self.name=name
	self.title=title
	self.exani_names={}
	self.menu_names={}
	self.functions={}
	for i=1,#options do
		self.exani_names[i]=options[i][1]
		self.menu_names[i]=options[i][2]
		self.functions[i]=options[i][3]
	end
	self.pre_menu=pre_menu
	
	self.locked=true
	self.choose=1
	self.changed=false --更换选项
	self.choosed=false --选中选项(包括z和x)
	
	self.delay=30 --选中后播放选中动画的时间以便于跳转下一个菜单
	self.timer=-1
	
	menus[name]=self
end

function base_menu:frame()
	if self.locked then return end
	if self.timer>=0 then self.timer=self.timer-1 end
	
	if self.timer=-1 then
		if not self.changed and lstg.GetKeyStat(KEY.UP) then self.choose=self.choose-1 end
		if not self.changed and lstg.GetKeyStat(KEY.DOWN) then self.choose=self.choose+1 end
		if self.choose<1 then self.choose=#self.exani_names end
		if self.choose>#self.exani_names then self.choose=1 end
		if not self.choosed and lstg.GetKeyStat(KEY.Z) then self.choosed=true self.timer=self.delay end
		if not self.choosed and lstg.GetKeyStat(KEY.X) then self.choosed=true end
	end
end

function base_menu:render()
	if self.locked then return end
	
	--还差一个常时'keep'和'ignite'状态
	
	if self.choosed then
		if lstg.GetKeyStat(KEY.Z) then
			exani_player_manager.ExecuteExaniPredefine(player_manager,self.exani_names[self.choose],'choose')
		elseif lstg.GetKeyStat(KEY.X) then
			ChangeLocked(menus[pre_menu])
		end
		self.choosed=false
	end
	
	if self.timer==0 then
		ChangeLocked(self)
	end
	
	if self.changed then
		exani_player_manager.ExecuteExaniPredefine(player_manager,self.exani_names[self.choose],'activate')
		local pos=self.choose
		if lstg.GetKeyStat(KEY.UP) then
			pos=self.choose+1
			if pos>#self.exani_names then pos=1 end
		elseif lstg.GetKeyStat(KEY.DOWN) then
			pos=self.choose-1
			if pos<1 then pos=#self.exani_names end
		end
		exani_player_manager.ExecuteExaniPredefine(player_manager,self.exani_names[pos],'deactivate')
		self.changed=false
	end
	
end

function base_menu:ChangeLocked()
	self.locked=not self.locked
	local action
	if self.locked then action='kill' else action='init' end
	for i=1,#self.exani_names do
		exani_player_manager.ExecuteExaniPredefine(player_manager,self.exani_names[i],action)
	end
end