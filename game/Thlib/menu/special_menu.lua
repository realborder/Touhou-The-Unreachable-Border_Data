special_manual=Class(object)
function special_manual:init()
	self.layer=LAYER_TOP
	self.group=GROUP_GHOST
	
	self.title='Manual_title'
	self.pre_menu='main_menu'
	self.locked=true
	
	self.choose=1
	self.changed=false --更换选项
	
	menus['manual_menu']=self
end

function special_manual:frame()
	if self.locked then return end
	
	if not self.changed then
		local action
		if lstg.GetKeyStat(KEY.UP) then
			self.choose=self.choose-1
			if self.choose<1 then
				self.choose=10
				action='1to10'
			else
				action=(self.choose+1)..'to'..self.choose
			end
		elseif lstg.GetKeyStat(KEY.DOWN) then
			self.choose=self.choose+1
			if self.choose>10 then
				self.choose=1
				action='10to1'
			else
				action=(self.choose-1)..'to'..self.choose
			end
		end
		exani_player_manager.ExecuteExaniPredefine(player_manager,'Manual_item',action)
		self.changed=true
	end
	
	if not self.changed then
		if lstg.GetKeyStat(KEY.X) then
			if self.pre_menu~='' then base_menu.ChangeLocked(self) base_menu.ChangeLocked(menus[self.pre_menu]) end
		end
		self.changed=true
	end
end