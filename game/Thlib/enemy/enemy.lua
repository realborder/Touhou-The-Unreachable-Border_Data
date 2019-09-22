LoadTexture('enemy1','THlib\\enemy\\enemy1.png')
--function LoadImageGroup(prefix,texname,x,y,w,h,cols,rows,a,b,rect)
--参数表：前缀，纹理名称，单个图像资源x，y，w，h，列数，行数，a，b，是否为方形判定

--前四行敌机图像资源的加载,enemy1~8
for j=0,1 do
	for i=1,4 do
		LoadImageGroup('enemy'..(j*4+i)..'_','enemy1',768*j,64*(i-1),64,64,12,1,16,16)
	end
end
for i=1,4 do--96x敌机图像资源的加载
	LoadImageGroup('enemy'..(8+i)..'_','enemy1',0,256+96*(i-1),96,96,12,1,16,16)
end
for i=1,4 do--128x敌机图像资源的加载
	LoadImageGroup('enemy'..(12+i)..'_','enemy1',0,640+128*(i-1),128,128,12,1,16,16)
end--神灵型敌机的加载
for i=1,8 do
	LoadImageGroup('ghost'..i..'_','enemy1',0,1152+64*(i-1),64,64,8,1,16,16)
	LoadPS('ghost_fire'..i,'THlib\\enemy\\ghost_fire'..i..'.psi','parimg1',16,16)
end
--阴阳玉的加载
LoadImageGroup('enemy_orb','enemy1',512,1152,64,64,1,8,16,16)
LoadImageGroup('enemy_orb_ring','enemy1',576,1152,64,64,1,8,16,16)
--毛玉敌机的加载
LoadImageGroup('kedama','enemy1',640,1152,64,64,1,8,16,16)

enemybase=Class(object)

function enemybase:init(hp, nontaijutsu)
	self.layer=LAYER_ENEMY
	self.group=GROUP_ENEMY
	if nontaijutsu then self.group = GROUP_NONTJT end
	self.bound=false
	self.colli=false
	self.maxhp=hp or 1
	self.hp=hp or 1
	
	self.speed_kill_point=0 --速破奖励指针值
	self.speedKillBase=30 --速破时间基础值
	self.speedKillHp=0.1 --速破血量系数
	self.speedTime=self.speedKillBase+self.maxhp*self.speedKillHp --速破时间上限
	
	self.take_dmg_in_frame=true
	setmetatable(self,{__index=GetAttr,__newindex=enemy_meta_newindex})
	self.colli=true
	self._servants={}
	
	--self.takeDmg_inFrame=0 --每帧受到的伤害量【旧速破相关】
	self.flag=false --用于判断出屏一瞬
end

function enemy_meta_newindex(t,k,v)
	if k=='colli' then rawset(t,'_colli',v)
	else SetAttr(t,k,v) end
end

function enemybase:frame()
	SetAttr(self,'colli',BoxCheck(self,lstg.world.boundl,lstg.world.boundr,lstg.world.boundb,lstg.world.boundt) and self._colli)
	if self.take_dmg_in_frame then --【修改标记】
		self.take_dmg_in_frame=false
	end
	
	if self.hp<=0 then 
		Kill(self)
		DR_Pin.add(2) --【修改标记】
		
		if self.timer<=self.speedTime then
		    if lstg.var.dr>0 then
		        DR_Pin.pin_shift(self.speed_kill_point)
		    else
		        DR_Pin.pin_shift(-self.speed_kill_point)
		    end
		end
		
	end
	task.Do(self)
end

function enemybase:colli(other)
	if other.dmg then
		lstg.var.score=lstg.var.score+10
		local dmg=other.dmg
		if #jstg.players>1 then
			local k=#Players(self)
			if k>1 then
				dmg=dmg*2/(1+k)
			end
		end
		Damage(self,dmg)
		self.take_dmg_in_frame=true--【修改标记】
		if Dist(player,self)<=100 then--贴脸射击
			DR_Pin.add(0.2 - Dist(player,self) / 1000)
		end
		if self._master and self._dmg_transfer and IsValid(self._master) then
			Damage(self._master,dmg*self._dmg_transfer)--敌方子机帮敌机吸收伤害
		end
	end
	other.killerenemy=self
	if not(other.killflag) then
		Kill(other)
	end
	if not other.mute then
		if self.dmg_factor then
			if self.hp>100 then PlaySound('damage00',0.4,self.x/200)
			else PlaySound('damage01',0.6,self.x/200) end
		else
			if self.hp>60 then
				if self.hp>self.maxhp*0.2 then PlaySound('damage00',0.4,self.x/200)
				else PlaySound('damage01',0.6,self.x/200) end
			else PlaySound('damage00',0.35,self.x/200,true)
			end
		end
	end
end

function enemybase:del()
	_del_servants(self)
end

function Damage(obj,dmg)
	if obj.class.base.take_damage then obj.class.base.take_damage(obj,dmg) end
end

enemy=Class(enemybase)

_enemy_aura_tb={1,2,3,4,3,1,nil,nil,nil,3,1,4,1,nil,3,1,2,4,3,1,2,4,1,2,3,4,nil,nil,nil,nil,1,3,2,1}
_death_ef_tb  ={1,2,3,4,1,2,3,4,	2,4,1,3,	1,1,1,1,	1,1,3,3,2,2,4,4,	1,1,3,3,2,2,4,4,	1,1,3,3,2,2,4,4}

function enemy:init(style,hp,clear_bullet,auto_delete,nontaijutsu)
	enemybase.init(self,hp,nontaijutsu)
	self.clear_bullet=clear_bullet
	self.auto_delete=auto_delete
	self._wisys = EnemyWalkImageSystem(self, style, 8)--by OLC，新行走图系统
end

function enemy:frame()
	enemybase.frame(self)
	self._wisys:frame()--by OLC，新行走图系统
	if self.dmgt then self.dmgt = max(0, self.dmgt - 1) end
	
	if self.auto_delete and BoxCheck(self,lstg.world.boundl,lstg.world.boundr,lstg.world.boundb,lstg.world.boundt) and self.flag==false then self.flag=true end
	if not BoxCheck(self,lstg.world.boundl,lstg.world.boundr,lstg.world.boundb,lstg.world.boundt) and self.flag==true then 
	    DR_Pin.add(K_dr_enemy) self.flag=false
		if self.auto_delete then self.bound=true end
	end
end

function enemy:render()
	self._wisys:render(self.dmgt, self.dmgmaxt)--by OLC and ETC，新行走图系统
end

function enemy:take_damage(dmg)
	if self.dmgmaxt then self.dmgt = self.dmgmaxt end
	if not self.protect then
		self.hp=self.hp-dmg
	end
end

function enemy:kill()
	New(enemy_death_ef,self.death_ef,self.x,self.y)
	if self.drop then item.DropItem(self.x,self.y,self.drop) end
	
	if self.clear_bullet then 
		for _,p in pairs(Players(self)) do 
			New(bullet_killer,p.x,p.y,false)
		end
	--	New(bullet_killer,lstg.player.x,lstg.player.y,false) 
	end
	_kill_servants(self)
end

enemy_death_ef=Class(object)

function enemy_death_ef:init(index,x,y)
	self.img='bubble'..index
	self.layer=LAYER_ENEMY+50
	self.group=GROUP_GHOST
	self.x=x self.y=y self.rot=ran:Float(0,360)
	PlaySound('enep00',0.3,self.x/200,true)
end

function enemy_death_ef:render()
	-- local alpha=1-self.timer/30
	local k=self.timer/30
	local alpha=255*(1-k)
	k=sin(90*k)
	SetImageState(self.img,'mul+add',Color(0.5*alpha/1.5,255,255,255))
	Render(self.img,self.x,self.y, 0,1+0.7*k,1+0.7*k)
	SetImageState(self.img,'mul+add',Color(0.5*alpha,255,255,255))
	Render(self.img,self.x,self.y, self.rot,0.3,5*k)
	SetImageState(self.img,'',Color(0.5*alpha/1.5,255,255,255))
	Render(self.img,self.x,self.y, 0,1+0.7*k,1+0.7*k)
	SetImageState(self.img,'',Color(0.5*alpha,255,255,255))
	Render(self.img,self.x,self.y, self.rot,0.3,5*k)
end

function enemy_death_ef:frame()
	if self.timer==30 then Kill(self) end
end

Include'THlib\\enemy\\boss.lua'

EnemySimple=Class(enemy)

function EnemySimple:init(style,hp,x,y,drop,pro,clr,bound,tjt,tf)
	enemy.init(self,style,hp,clr,bound,tjt)
	self.x,self.y = x,y
	self.drop = drop
	task.New(self,function() self.protect=true task.Wait(pro) self.protect=false end)
	tf(self)
end
