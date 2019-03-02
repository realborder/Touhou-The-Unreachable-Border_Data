local system={}
system.name="act7"
function system.on_game_start(stagename,diff,players)
	lstg.var.collectingitem=0
end
function system.on_stage_init(stage_object)
	
end
function system.on_player_init(player)
	local self=player
	New(item_bar,self)
	self.collect_time=0
	self.nextcollect=0--HZC收点系统
end
function system.on_player_frame(player)
	local self=player

	if (self.death==0 or self.death>90) and (not self.lock) and not(self.time_stop) then
	
		--shoot and spell
		if not self.dialog then
			if KeyIsDown'spell' and self.nextspell<=0 and lstg.var.bomb>0 and not lstg.var.block_spell then
				item.PlayerSpell()
				self.nextcollect=90
			end
		end
		--item
		if self.y>self.collect_line then
			self.collect_time= self.collect_time + 1
		
			if not(self.itemed) and not(self.collecting) then
				self.itemed=true
				self.collecting=true
	--				lstg.var.collectitem=0
				self.nextcollect=15
			end
			-- for i,o in ObjList(GROUP_ITEM) do 
				-- local flag=false
				-- if o.attract<8 then
					-- flag=true			
				-- elseif o.attract==8 and o.target~=self then
					-- if (not o.target) or o.target.y<self.y then
						-- flag=true
					-- end
				-- end
				-- if flag then
					-- o.attract=8 o.num=self.item 
					-- o.target=self
				-- end
			-- end
		-----
		else
			self.nextcollect=0
			self.collect_time=0
			-- if KeyIsDown'slow' then
				-- for i,o in ObjList(GROUP_ITEM) do
					-- if Dist(self,o)<48 then
						-- if o.attract<3 then
							-- o.attract=max(o.attract,3) 
							-- o.target=self
						-- end	
					-- end
				-- end
			-- else
				-- for i,o in ObjList(GROUP_ITEM) do
					-- if Dist(self,o)<24 then 
						-- if o.attract<3 then
							-- o.attract=max(o.attract,3) 
							-- o.target=self
						-- end	
					-- end
				-- end
			-- end
		end
		if self.nextcollect<=0 and self.itemed then
			item.playercollect(self.item)
			self.item=self.item%6+1
	--			lstg.var.collectitem=0
			self.itemed=false
			self.collecting=false
		end
		if self.collecting and not(self.itemed) then end
	end
	if self.nextcollect>0 then self.nextcollect=self.nextcollect-1 end--HZC收点系统
	
end
function system.on_player_charge(player)

end
function system.on_stage_frame(stage_object)
	
end
local function act7collect(self,player)
	if self.attract>=8 then
		lstg.var.collectitem[self.num]=lstg.var.collectitem[self.num]+1
		if player.nextcollect>0 and player.nextcollect<15 and self.collected and player.itemed then player.nextcollect=15 end
	end
end
function system.on_collect_item(self,player)
	local var=lstg.var
	if self.class==item_power then
		act7collect(self,player)
		var.itembar[1]=var.itembar[1]+1
	elseif self.class==item_faith then
		act7collect(self,player)
		var.itembar[2]=var.itembar[2]+1
	elseif self.class==item_point then
		act7collect(self,player)
		var.itembar[3]=var.itembar[3]+1
	end
end

lstg.systems[2] = system