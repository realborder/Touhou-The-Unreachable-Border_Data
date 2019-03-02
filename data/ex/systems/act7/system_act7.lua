LoadPS('itembar_par1','ex\\systems\\act7\\itembar_par1.psi','parimg2')
LoadPS('itembar_par2','ex\\systems\\act7\\itembar_par2.psi','parimg2')
LoadPS('itembar_par3','ex\\systems\\act7\\itembar_par3.psi','parimg2')
LoadImageFromFile('itembar','ex\\systems\\act7\\itembar.png')

item_bar=Class(object)
function item_bar:init(player)
	self.group=GROUP_GHOST
	self.layer=LAYER_TOP
	self.img='itembar_par1'
	self.x=-140
	self.y=-200
	self.par=0
	self.r=255 self.g=255 self.b=255
	self.player=player
end
function item_bar:frame()
	if jstg then
		self.world=player.world
	end
	local l1,l2,l3=lstg.var.itembar[1],lstg.var.itembar[2],lstg.var.itembar[3]
	local m=max(l1,max(l2,l3))
	local x,y=-141,-200
	if l1+l2+l3>=300 then
		if (l1~=l2 and l1~=l3) or (l1==l3 and l1<l2) or (l1==l2 and l1<l3) or (l2==l3 and l2<l1) then
			if m==l1 then Getlife(0.3*l1) New(bonus_par,x,y,1)
			elseif m==l2 then Getbomb(0.6*l2) New(bonus_par,x,y,2)
			elseif m==l3 then lstg.var.score=lstg.var.score+lstg.var.pointrate*l3 New(bonus_par,x,y,3) end
		end
		if l1==l2 and l1>l3 then
			Getlife(0.3*l1) New(bonus_par,x-24,y,1)
			Getbomb(0.6*l2) New(bonus_par,x+24,y,2)
		end
		if l1==l3 and l1>l2 then
			Getlife(0.3*l1) New(bonus_par,x-24,y,1)
			lstg.var.score=lstg.var.score+lstg.var.pointrate*l3 New(bonus_par,x+24,y,3)
		end
		if l2==l3 and l2>l1 then
			Getbomb(0.6*l2) New(bonus_par,x-24,y,2)
			lstg.var.score=lstg.var.score+lstg.var.pointrate*l3 New(bonus_par,x+24,y,3)
		end
		if l1==100 and l2==100 then
			Getlife(0.3*l1) New(bonus_par,x-36,y,1)
			Getbomb(0.6*l2) New(bonus_par,x,y,2)
			lstg.var.score=lstg.var.score+lstg.var.pointrate*l3 New(bonus_par,x+36,y,3)
		end
		lstg.var.itembar={0,0,0}
	end
end
function item_bar:render()
	local x,y=-186,-200
	
	if jstg and jstg.worldcount==1 and self.player==jstg.players[2] then
		x=lstg.world.r-100
		y=y+224+lstg.world.b
	else
		x=x+192+lstg.world.l
		y=y+224+lstg.world.b
	end
	
	self.x=x+186-140
	self.y=y
	
	local alpha,dist=1,Dist(self.x,self.y,player.x,player.y)
	if dist<128 then alpha=0.25+dist/170 end
	local var=lstg.var
	local l1,l2,l3=lstg.var.itembar[1]*0.3,lstg.var.itembar[2]*0.3,lstg.var.itembar[3]*0.3
	local n1,n2,n3=lstg.var.itembar[1],lstg.var.itembar[2],lstg.var.itembar[3]
--[[	SetImageState('white','',Color(alpha*255,209,095,238))
	RenderRect('white',self.x,self.x+l1,self.y-6.5,self.y+6.5)
	SetImageState('white','',Color(alpha*255,000,222,000))
	RenderRect('white',self.x+l1,self.x+l1+l2,self.y-6.5,self.y+6.5)
	SetImageState('white','',Color(alpha*255,028,134,238))
	RenderRect('white',self.x+l1+l2,self.x+l1+l2+l3,self.y-6.5,self.y+6.5)]]
	local n=n1+n2+n3
--[[	local r,g,b=	(n1*209+n2*0+n3*28)/n,
					(n1*95+n2*222+n3*134)/n,
					(n1*238+n2*0+n3*238)/n]]
	if n1>=n/3 then self.r=min(255,self.r+2.5) else self.r=max(30,self.r-2.5) end
	if n2>=n/3 then self.g=min(255,self.g+2.5) else self.g=max(30,self.g-2.5) end
	if n3>=n/3 then self.b=min(255,self.b+2.5) else self.b=max(30,self.b-2.5) end
	local r,g,b=self.r,self.g,self.b
	SetImageState('white','',Color(alpha*255,r,g,b))
	RenderRect('white',x,x+l1+l2+l3,y-6.5,y+6.5)
	SetImageState('itembar','',Color(alpha*255,255,255,255))
	SetImageState('item1','',Color(alpha*255,255,255,255))
	SetImageState('item5','',Color(alpha*255,255,255,255))
	SetImageState('item2','',Color(alpha*255,255,255,255))
	Render('itembar',x+45,y)
	Render('item1',x+4,y-16)
	Render('item5',x+36,y-16)
	Render('item2',x+68,y-16)
	SetFontState('bonus','',Color(alpha*255,0,0,0))
	RenderText('bonus','X'..var.itembar[1],x+13,y-11,0.35,'left')
	RenderText('bonus','X'..var.itembar[2],x+46,y-11,0.35,'left')
	RenderText('bonus','X'..var.itembar[3],x+77,y-11,0.35,'left')
	SetFontState('bonus','',Color(alpha*255,255,255,255))
	RenderText('bonus','X'..var.itembar[1],x+12,y-10,0.35,'left')
	RenderText('bonus','X'..var.itembar[2],x+45,y-10,0.35,'left')
	RenderText('bonus','X'..var.itembar[3],x+76,y-10,0.35,'left')
	SetImageState('item1','',Color(255,255,255,255))
	SetImageState('item5','',Color(255,255,255,255))
	SetImageState('item2','',Color(255,255,255,255))
end

bonus_par=Class(object)
function bonus_par:init(x,y,n)
	self.x=x self.y=y
	self.img='itembar_par'..n
	self.group=GROUP_GHOST
	self.layer=LAYER_TOP
end
function bonus_par:frame()
	if self.timer>8 then ParticleStop(self) end
	if self.timer>60 then Del(self) end
end
function bonus_par:render()
	object.render(self)
end


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
			
		else
			self.nextcollect=0
			self.collect_time=0
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