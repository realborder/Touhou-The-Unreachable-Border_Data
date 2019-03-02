--======================================
--javastg compatible api
--======================================

----------------------------------------
--用于兼容javastage的js类似接口 todo or not todo

jstgobj=Class(object)

frame=0
stg_target={}

function jstgobj:init(baseobj)
	self.layer=LAYER_ENEMY
	self.group=GROUP_GHOST
	self.frame=0
	self.obj=baseobj
	for _,v in baseobj do
		self[_]=v
	end
	if self.init ~= nil then
		self.init(self)
	end
end
function jstgobj:frame()
	task.Do(self)
	self.frame=self.frame+1
	frame=self.frame
	stg_target=self
	if self.script ~= nil then
		self.script(self)
	end
end
function jstgobj:del()
	if self.finalize ~= nil then
		self.finalize(self)
	end
end

function jstg.AddObject(obj)
	return New(jstgobj,obj)
end

--按照CD执行
--用法
-- 在on_frame中
-- if jstg.ActionCoolDown(self,"shoot1",6, allowshoot==true) then ... end
function jstg:ActionCoolDown(varname,delay,condition)
	self[varname]=self[varname] or 0
	if self[varname]>0 then
		self[varname]=self[varname]-1
	else
		if condition then
			self[varname]=delay
			return true
		end
	end
	return false
end


--jstg player object system
--const
jstg.PLAYER_NORMAL=1
jstg.PLAYER_HIT=2
jstg.PLAYER_DEAD=3
jstg.PLAYER_BIRTH=0

jstg.player_class=Class(object)
jstg.player_properties={'power','bomb','lifeleft','chip','bombchip'}

function jstg.player_class:init(slot,world,var)
	self.slot=slot
	self.world=world
	jstg.players[slot]=self
	self.group=GROUP_PLAYER
	self.y=-176
	self.supportx=0
	self.supporty=self.y
	self.hspeed=4
	self.lspeed=2
	self.collect_line=96
	self.slow=0
	self.layer=LAYER_PLAYER
	self.lr=1
	self.lh=0
	self.fire=0
	self.lock=false
	self.dialog=false
	self.nextshoot=0
	self.nextspell=0
	self.A=0        --自机判定大小
	self.B=0
	self.nextcollect=0--HZC收点系统
	self.item=1
	self.death=0
	self.protect=120
	lstg.player=self
	player=self
	self.grazer=New(grazer)
	if not lstg.var.init_player_data then error('Player data has not been initialized. (Call function item.PlayerInit.)') end
	self.support=int(var.power/100)
	--set playerside data
	for i=1,#jstg.player_properties do
		self[jstg.player_properties[i]]=var[i]
	end
	
	self.sp={}
	self.time_stop=false
	--New(item_bar)
end



function jstg.player_class:frame()
	local _temp_key=nil
	local _temp_keyp=nil
	if self.key then
		_temp_key=KeyState
		_temp_keyp=KeyStatePre
		KeyState=self.key
		KeyStatePre=self.keypre
	end


	--find target
	if ((not IsValid(self.target)) or (not self.target.colli)) then player_class.findtarget(self) end
	if not KeyIsDown'shoot' then self.target=nil end
	--
	local dx=0
	local dy=0
	local v=self.hspeed
	if (self.death==0 or self.death>90) and (not self.lock) and not(self.time_stop) then
		--slow
		if KeyIsDown'slow' then self.slow=1 else self.slow=0 end
		--shoot and spell
		if not self.dialog then
			if KeyIsDown'shoot' and self.nextshoot<=0 then self.class.shoot(self) end
			if KeyIsDown'spell' and self.nextspell<=0 and lstg.var.bomb>0 and not lstg.var.block_spell then
				item.PlayerSpell()
				lstg.var.bomb=lstg.var.bomb-1
				self.class.spell(self)
				self.death=0
				self.nextcollect=90
			end
		else self.nextshoot=15 self.nextspell=30
		end
		--move
		if self.death==0 and not self.lock then
		if self.slowlock then self.slow=1 end
		if self.slow==1 then v=self.lspeed end
		if KeyIsDown'up' then dy=dy+1 end
		if KeyIsDown'down' then dy=dy-1 end
		if KeyIsDown'left' then dx=dx-1 end
		if KeyIsDown'right' then dx=dx+1 end
		if dx*dy~=0 then v=v*SQRT2_2 end
		self.x=self.x+v*dx
		self.y=self.y+v*dy
		self.x=math.max(math.min(self.x,lstg.world.pr-8),lstg.world.pl+8)
		self.y=math.max(math.min(self.y,lstg.world.pt-32),lstg.world.pb+16)
		end
		--fire
		if KeyIsDown'shoot' and not self.dialog then self.fire=self.fire+0.16 else self.fire=self.fire-0.16 end
		if self.fire<0 then self.fire=0 end
		if self.fire>1 then self.fire=1 end
		--item
		if self.y>self.collect_line then
			if not(self.itemed) and not(self.collecting) then
				self.itemed=true
				self.collecting=true
--				lstg.var.collectitem=0
				self.nextcollect=15
			end
			for i,o in ObjList(GROUP_ITEM) do o.attract=8 o.num=self.item end
		-----
		else
			self.nextcollect=0
			if KeyIsDown'slow' then
				for i,o in ObjList(GROUP_ITEM) do
					if Dist(self,o)<48 then o.attract=max(o.attract,3) end
				end
			else
				for i,o in ObjList(GROUP_ITEM) do
					if Dist(self,o)<24 then o.attract=max(o.attract,3) end
				end
			end
		end
		if self.nextcollect<=0 and self.itemed then
			item.playercollect(self.item)
			self.item=self.item%6+1
--			lstg.var.collectitem=0
			self.itemed=false
			self.collecting=false
		end
		if self.collecting and not(self.itemed) then end
	elseif self.death==90 then
		if self.time_stop then self.death=self.death-1 end
		item.PlayerMiss()
		self.deathee={}
		self.deathee[1]=New(deatheff,self.x,self.y,'first')
		self.deathee[2]=New(deatheff,self.x,self.y,'second')
		New(player_death_ef,self.x,self.y)
	elseif self.death==84 then
		if self.time_stop then self.death=self.death-1 end
		self.hide=true
		self.support=int(lstg.var.power/100)
	elseif self.death==50 then
		if self.time_stop then self.death=self.death-1 end
		self.x=0
		self.supportx=0
		self.y=-236
		self.supporty=-236
		self.hide=false
		New(bullet_deleter,self.x,self.y)
	elseif self.death<50 and not(self.lock) and not(self.time_stop) then
		self.y=-176-1.2*self.death
	end
	--img
	---加上time_stop的限制来实现图像时停
	if not(self.time_stop) then
	if abs(self.lr)==1 then
		self.img=self.imgs[int(self.ani/8)%8+1]
	elseif self.lr==-6 then
		self.img=self.imgs[int(self.ani/8)%4+13]
	elseif self.lr== 6 then
		self.img=self.imgs[int(self.ani/8)%4+21]
	elseif self.lr<0 then
		self.img=self.imgs[7-self.lr]
	elseif self.lr>0 then
		self.img=self.imgs[15+self.lr]
	end
	--------------------
	self.a=self.A
	self.b=self.B
	--some status
	self.lr=self.lr+dx;
	if self.lr> 6 then self.lr= 6 end
	if self.lr<-6 then self.lr=-6 end
	if self.lr==0 then self.lr=self.lr+dx end
	if dx==0 then
		if self.lr> 1 then self.lr=self.lr-1 end
		if self.lr<-1 then self.lr=self.lr+1 end
	end

	self.lh=self.lh+(self.slow-0.5)*0.3
	if self.lh<0 then self.lh=0 end
	if self.lh>1 then self.lh=1 end

	if self.nextshoot>0 then self.nextshoot=self.nextshoot-1 end
	if self.nextspell>0 then self.nextspell=self.nextspell-1 end
	if self.nextcollect>0 then self.nextcollect=self.nextcollect-1 end--HZC收点系统

	if self.support>int(lstg.var.power/100) then self.support=self.support-0.0625
	elseif self.support<int(lstg.var.power/100) then self.support=self.support+0.0625 end
	if abs(self.support-int(lstg.var.power/100))<0.0625 then self.support=int(lstg.var.power/100) end

	self.supportx=self.x+(self.supportx-self.x)*0.6875
	self.supporty=self.y+(self.supporty-self.y)*0.6875

	if self.protect>0 then self.protect=self.protect-1 end
	if self.death>0 then self.death=self.death-1 end

	lstg.var.pointrate=item.PointRateFunc(lstg.var)
	--update supports
		if self.slist then
			self.sp={}
			if self.support==5 then
				for i=1,4 do self.sp[i]=MixTable(self.lh,self.slist[6][i]) self.sp[i][3]=1 end
			else
				local s=int(self.support)+1
				local t=self.support-int(self.support)
				for i=1,4 do
					if self.slist[s][i] and self.slist[s+1][i] then
						self.sp[i]=MixTable(t,MixTable(self.lh,self.slist[s][i]),MixTable(self.lh,self.slist[s+1][i]))
						self.sp[i][3]=1
					elseif self.slist[s+1][i] then
						self.sp[i]=MixTable(self.lh,self.slist[s+1][i])
						self.sp[i][3]=t
					end
				end
			end
		end
	--
	end---time_stop
	if self.time_stop then self.timer=self.timer-1 end
	
	
	if self.key then
		KeyState=_temp_key
		KeyStatePre=_temp_keyp
	end
	
end

function jstg.player_class:render()
	if self.protect%3==1 then SetImageState(self.img,'',Color(0xFF0000FF))
	else SetImageState(self.img,'',Color(0xFFFFFFFF)) end
	object.render(self)
end

function jstg.player_class:colli(other)
	if self.death==0 and not self.dialog and not cheat then
		if self.protect==0 then
			PlaySound('pldead00',0.5)
			self.death=100
		end
		if other.group==GROUP_ENEMY_BULLET then Del(other) end
	end
end

function jstg.player_class:findtarget()
	self.target=nil
	local maxpri=-1
	for i,o in ObjList(GROUP_ENEMY) do
		if o.colli then
			local dx=self.x-o.x
			local dy=self.y-o.y
			local pri=abs(dy)/(abs(dx)+0.01)
			if pri>maxpri then maxpri=pri self.target=o end
		end
	end
end
