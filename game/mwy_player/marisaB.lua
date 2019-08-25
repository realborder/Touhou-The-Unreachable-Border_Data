---=====================================
---魔理沙A机体
---模板来自Xiliusha

---=====================================
_lastSpark={}
-------------------------------------------
---support shoot

marisa_high_laser=Class(object)

function marisa_high_laser:init()
	self.hide=true
	self.data=BentLaserData()
	self.w=0
end

function marisa_high_laser.Update(self,master,index)
	---[[
	local t=master.highlaser_data[index]
	-- for k,v in pairs(t) do
	-- 	Print("[debug][player]marisa_high_laser_data["..k.."]: x="..v.x.." ,y="..v.y)
	-- end
	local w=master.highlaserWidth
	self.w=w
	local testTable={{x=1,y=2},{x=3,y=4}}
	self.data:UpdatePositionByList(t,#t,w*24,1,0)--]]
end

--------------------------------------------
local CalculatePriority=function(self,o,rot)
	local dist=Dist(self,o)
	local angle=abs(Angle(self,o)-rot) if angle<-180 then angle=angle+360 end
	angle=1-angle/180*3
	dist=(400-dist)/400
	return dist*angle
end

-------------------------------------------
---寻找多个目标
---@return table 输出一个成员为对象的表，表的第一个永远是玩家
function marisa_player.findtargetplus (self,num,IsFirst)
	local rot
	if IsFirst then
		 self.targetlist={self} rot=90 
		 for i,o in ObjList(GROUP_ENEMY) do
			o.laser_target=false
		end
		for i,o in ObjList(GROUP_NONTJT) do
			o.laser_target=false
		end
	else rot=Angle(self.targetlist[(#self.targetlist)-1],self.targetlist[(#self.targetlist)]) end
	
	if num<=0 then return end
	local priority=0  --如果遍历到自己那么优先度肯定是0
	local target=nil

	for i,o in ObjList(GROUP_ENEMY) do
		if o.colli and not o.laser_target then
			local _pri=CalculatePriority(self,o,rot)
			if _pri>priority then priority=_pri target=o end
		end
	end
	for i,o in ObjList(GROUP_NONTJT) do
		if o.colli and not o.laser_target then
			local pri=CalculatePriority(self,o,rot)
			if _pri>priority then priority=_pri target=o end
		end
	end
	if priority>0 then 
		table.insert(self.targetlist,target)
		target.laser_target=true
		num=num-1
		marisa_player.findtargetplus(self,num,false)
	else 
		if IsFirst then return false else return true end
	end
	if IsFirst then return true end
end

-------------------------------------------
---catmullRom曲线 魔改自Ltask中青山写的埃尔金样条
---@param t number 分割数量
---@return _output table 分割结果
local InterpolationByCatmullRom=function (sx,sy,t,arg)
	--local arg={ ... }
	local count=(#arg)-1
	local x={}
	local y={}
	local _output={}
	t=t-1
	for i=1,count+1 do
		if not arg[i] then error("argument"..i.."is nil") end
		x[i]=arg[i][1]
		y[i]=arg[i][2]
	end
	
	table.insert(x,2*x[#x]-x[#x-1])
	table.insert(x,1,2*x[1]-x[2])
	table.insert(y,2*y[#y]-y[#y-1])
	table.insert(y,1,2*y[1]-y[2])
	t=math.max(1,t)
	local timeMark={}
	for i=0,t do
		timeMark[i]=count*(i/t)
	end

	for i=0,t-1 do
		local s=math.floor(timeMark[i])+1
		local j=timeMark[i]%1
		local _x=x[s]*(-0.5*j*j*j + j*j-0.5*j)
			+ x[s+1] * (1.5*j*j*j - 2.5*j*j + 1.0)
			+ x[s+2] * (-1.5*j*j*j + 2.0*j*j + 0.5*j)
			+ x[s+3] * (0.5*j*j*j-0.5*j*j)
		local _y=y[s]*(-0.5*j*j*j + j*j-0.5*j)
			+ y[s+1] * (1.5*j*j*j - 2.5*j*j + 1.0)
			+ y[s+2] * (-1.5*j*j*j + 2.0*j*j + 0.5*j)
			+ y[s+3] * (0.5*j*j*j-0.5*j*j)
		table.insert(_output,{x=_x,y=_y})
	end
	table.insert(_output,{x=x[count+2],y=y[count+2]})
	return _output
end

--判定unit到高速激光的最短距离是否小于r
---@param unit lstgobject
---@param r number 距离
local IsInLaser=function(unit,r)
	if unit.a then r=r+sqrt(unit.a*unit.a+unit.b*unit.b) end--算上obj的碰撞体积
	local t=self.highlaser_data
	for i=1,(#t)-1 do
		local x1,y1,x2,y2=t[i].x,t[i].y,t[i+1].x,t[i+1].y
		local dx,dy=x2-x1,y2-y1
		local theta=atan2(unit.y-y1,unit.x-x1)
		local ur=Dist(unit.x,unit.y,x1,y1)
		local dtheta=atan2(dy,dx)
		local l=Dist(x1,y1,x2,y2)
		local ux,uy=ur*cos(theta-dtheta),ur*sin(theta-dtheta)
		if ux>=0 and ux<=l and uy<=r and uy>=-r then return true end
		--elseif Dist(0,0,ux,uy)<=r or Dist(0,l,ux,uy)<=r then return true end  --节省性能这个影响不大就不要了
	end
	return false
end
--
local UpdateLaser=function(self)
	if self.shootstate==0 then
		self.highlaserWidth=max(0,self.highlaserWidth-self.laserWidenSpeed)
		self.slowlaserWidth=max(0,self.slowlaserWidth-self.laserWidenSpeed)
		-- for i=1,6 do 
		-- 	if not self.highlaserWidth[i] then self.highlaserWidth[i]=0 end
		-- 	self.highlaserWidth[i]=max(0,self.highlaserWidth[i]-self.laserWidenSpeed)  
		-- end
		--直接初始化位置
		for i=1,self.target_num+2 do
			if not self.nodelist_aim[i] then self.nodelist_aim[i]={} end
			self.nodelist_aim[i][1],self.nodelist_aim[i][2]=self.x,self.y+180*(i-1) 
		end


	elseif self.shootstate==1 then
		--
		self.highlaserWidth=min(1,self.highlaserWidth+self.laserWidenSpeed)
		self.slowlaserWidth=max(0,self.slowlaserWidth-self.laserWidenSpeed)

		-- for i=1,6 do 
		-- 	if not self.highlaserWidth[i] then self.highlaserWidth[i]=0 end  --先用无脑补救流苟着
		-- 	self.highlaserWidth[i]=min(1,self.highlaserWidth[i]+self.laserWidenSpeed)
		-- end
		
		
		local enemyExist=marisa_player.findtargetplus(self,self.target_num,true) 
		self.nodelist_aim={}
		for i=1,self.target_num+1 do if self.targetlist[i] then
			self.nodelist_aim[i]={}
			self.nodelist_aim[i][1]=self.targetlist[i].x
			self.nodelist_aim[i][2]=self.targetlist[i].y end 
		end
		if enemyExist then --有敌机
			local l=#self.nodelist_aim  --把这个表的最后一个节点作为出屏节点，接下来就是要算这个出屏节点
			local t=self.nodelist_aim
			local sx=t[l][1] --s = Source
			local sy=t[l][2]
			local dx=t[l][1]-t[l-1][1]
			local dy=t[l][2]-t[l-1][2]
			local theta=atan2(dy,dx)
			--暴力dowhile算法，把激光节点延伸到屏幕外
			local ax=sx+dx -- a = Aim 
			local ay=sy+dy
			while Dist(ax,ay,0,0)<=300 do ax,ay=ax+64*cos(theta),ay+64*sin(theta) end
			--最后一个节点在屏幕外，剩下的要平均分配了
			if l==self.target_num+1 then
				t[l+1]={}
				t[l+1][1]=ax
				t[l+1][2]=ay
			else
				local part=self.target_num+2-l
				for i=1,part do
					local k=i/part
					t[l+i]={}
					if not t[l+i] then error(i) end
					t[l+i][1]=sx+(ax-sx)*k
					t[l+i][2]=sy+(ay-sy)*k
				end
			end
		else--无敌机则重置为初始值
			for i=1,self.target_num+2 do
				if not self.nodelist_aim[i] then self.nodelist_aim[i]={} end
				self.nodelist_aim[i][1],self.nodelist_aim[i][2]=self.x,self.y+270*(i-1) 
			end
		end
		--Print("[debug][player]#self.nodelist_aim="..#self.nodelist_aim)
		--PrintSimpleTable(self.nodelist_aim,"self.nodelist_aim")
		
	elseif self.shootstate==2 then
		self.highlaserWidth=max(0,self.highlaserWidth-self.laserWidenSpeed)
		self.slowlaserWidth=min(1,self.slowlaserWidth+self.laserWidenSpeed)

		-- for i=1,6 do 
		-- 	if not self.highlaserWidth[i] then self.highlaserWidth[i]=0 end
		-- 	self.highlaserWidth[i]=max(0,self.highlaserWidth[i]-self.laserWidenSpeed)  
		-- end
		--直接初始化位置
		for i=1,self.target_num+2 do
			if not self.nodelist_aim[i] then self.nodelist_aim[i]={} end
			self.nodelist_aim[i][1],self.nodelist_aim[i][2]=self.x,self.y+180*(i-1) 
		end
	
	end
	--将目标点集的第二项置为玩家前面一个店

	----------目标值已经设定，接下来丝滑化和计算点集
	local t=self.nodelist_aim
	for i=1,self.target_num+2 do 
		if not self.nodelist[i] then self.nodelist[i]={} end --没有表就补上
		if not self.nodelist[i][1] then --没有值直接给补上
			self.nodelist[i][1]=t[i][1]
			self.nodelist[i][2]=t[i][2]
		else
			self.nodelist[i][1]=self.nodelist[i][1]+(self.nodelist_aim[i][1]-self.nodelist[i][1])*0.1
			self.nodelist[i][2]=self.nodelist[i][2]+(self.nodelist_aim[i][2]-self.nodelist[i][2])*0.1
		end
	end


	--丝滑化完毕的激光节点拿去补间，得到一系列用来渲染的坐标 捎带把激光的宽度给算了
	for i=1,6 do
		if self.sp[i] and self.sp[i][3] > 0.5 then
			
			----如果这个子机是有效的那么就将第一个节点移到子机上，否则照常
			self.nodelist[1][1],self.nodelist[1][2]=self.supportx+self.sp[i][1],self.supporty+self.sp[i][2]
			table.insert(self.nodelist,2,{self.x,self.y+128})
		else
			
		end
		--Print("[debug][player]#self.nodelist="..#self.nodelist)

		--PrintSimpleTable(self.nodelist[i],"self.nodelist")
		-- error("go to log.txt plzzzzzz")
		self.highlaser_data[i]=InterpolationByCatmullRom(self.nodelist[1][1],self.nodelist[1][2],self.laserNode_num,self.nodelist)
		if self.sp[i] and self.sp[i][3] > 0.5 then
			table.remove(self.nodelist,2)
		end

	
	end
	for i=1,6 do 
		marisa_high_laser.Update(self.highlaser[i],self,i) 
	end
end

--[[function PrintATable(t,name)
	name=name or ""
	for i,v in ipairs(t) do
		Print("[debug][player]"..name.."["..i.."]: x="..v.x.." ,y="..v.y)
	end
end]]

local DoLaserDamage=function(self)
	local num=#(self.sp)
	if self.shootstate==1 then  --为了性能，激光不需要视觉上照到敌机即可造成伤害，不然要对每个敌机遍历一边激光节点伤不起
		local l=#self.targetlist
		for i=2,l do
			local offset=(l-i)/l*(1+0.2*(6-l))*0.9  --越靠后的目标伤害越低，但是目标越少伤害最多能到多目标的1.8倍
			Damage(self.targetlist[i],0.15*num*offset)
			if self.targetlist[i].hp>self.targetlist[i].maxhp*0.1 then
				PlaySound('damage00',0.3,self.targetlist[i].x/1024)
			else
				PlaySound('damage01',0.6,self.targetlist[i].x/1024)
			end
		end
	elseif self.shootstate==2 then
		for i=1,6 do
			if self.sp[i] and self.sp[i][3]>0.5 then
				local target,dist={},{}
				local x,y=self.supportx+self.sp[i][1],self.supporty+self.sp[i][2]
				for j,o in ObjList(GROUP_ENEMY) do
					if o.colli and o.y>self.y and abs(o.x-self.x)<32 then
						table.insert(target,o)
						table.insert(dist,o.y-self.y)
					end
				end
				for j,o in ObjList(GROUP_NONTJT) do
					if o.colli and o.y>self.y and abs(o.x-self.x)<32 then
						table.insert(target,o)
						table.insert(dist,o.y-self.y)
					end
				end
				if target then
					for i=1,#target do	
						local dmgoffset=(1-dist[i]/448*0.15)*(0.52+num*0.31)*0.92
						Damage(target[i],0.1*dmgoffset)
						if target[i].hp>target[i].maxhp*0.1 then
							PlaySound('damage00',0.3,target[i].x/1024)
						else
							PlaySound('damage01',0.6,target[i].x/1024)
						end
					end
				end
			end
		end
	end

end

local RenderLaser=function(self)
	--高速激光
	for i=1,6 do 
		local l=self.highlaser[i]
		-- if l.w>0 then l.data:Render("_marisa_highlaser","mul+add",Color(0x80FFFFFF),0,64*(int(0.5*l.timer)%4),512,28) end
		if self.highlaserWidth>0 and self.sp[i] and self.sp[i][3] > 0.5  then
			l.data:Render("_marisa_highlaser","mul+add",Color(0x30FFFFFF),512*((self.timer/20)%1),0,512,32)
		end
	end
	--低速激光
	local h=32*12/self.slowLaserPartNum
	local scale=1.1
	for i=1,self.slowLaserPartNum do
		Render("_marisa_slowlaser"..(self.timer+i)%self.slowLaserPartNum+1,self.supportx,self.supporty+30-h*0.5*scale+h*i*scale,90,1*scale,scale*self.slowlaserWidth)
	end
end


------------------------------------------------------------------------------------
--SpellCard Slow

marisa_spark=Class(object)

function marisa_spark:init(x,y,rot,turnOnTime,wait,turnOffTime,p,index)
	self.player=p
	self.x=x
	self.y=y
	self.rot=rot
	self.index=index
	self.img='_marisa_spark'
	self.group=GROUP_GHOST
	self.layer=LAYER_PLAYER_BULLET
	self.hscale=2.5
	self.life=92
	self.player.slowlock=true
	_lastSpark[index]=self
	-- Print("[spark]"..index..": "..tostring(IsValid(_lastSpark[index])))
	-- lstg.var.block_spell=true
	task.New(self,function()
		for i=0,turnOnTime do
			self.vscale=2*i/turnOnTime
			task.Wait(1)
		end
		for i=0,90*3-turnOnTime do
			self.vscale=self.vscale+0.007
			SetImageState(self.img,"mul+add",Color(160+45*i/(90*3-turnOnTime),255,255,255))
			task.Wait(1)
		end
		local vs=self.vscale
		for i=1,10 do
			self.vscale=vs*(1-i/10)
			task.Wait(1)
		end
		RawDel(self)
	end)
end

function marisa_spark:frame()
	task.Do(self)
	if self.timer%90==1 then misc.ShakeScreen(90,5) end
	-- Print("[life]"..self.life)
	self.x=self.player.x
	self.y=self.player.y
	if self.timer%10==0 then
		New(marisa_spark_wave,self.x,self.y,self.rot,12,0.9,self.player,self.vscale)
	end
	self.life=self.life-1
	if self.life==0 then 
		task.Clear(self)
		_lastSpark[self.index]=nil
		task.New(self,function ()
			local vs=self.vscale
			for i=1,10 do
				self.vscale=vs*(1-i/10)
				task.Wait(1)
			end
			self.player.slowlock=false
			RawDel(self)
		end)

	end
	for j,o in ObjList(GROUP_NONTJT) do
		if not o._bosssys then  o.y=min(224,o.y+1) end
	end
	for j,o in ObjList(GROUP_ENEMY) do
		if not o._bosssys then  o.y=min(224,o.y+1) end
	end
	for j,o in ObjList(GROUP_ITEM) do
		o.y=min(226,o.y+2)
	end
end

marisa_spark2=Class(object)

function marisa_spark2:init(x,y,rot,turnOnTime,wait,turnOffTime,p)
	self.player=p
	self.x=x
	self.y=y
	self.rot=rot
	self.hscale=0
	self.vscale=0.05
	self.img='_marisa_spark2'
	self.group=GROUP_GHOST
	self.layer=LAYER_PLAYER_BULLET
	self.hscale=2.5
	self.player.slowlock=true
	lstg.var.block_spell=true
	task.New(self,function()
		for i=0,90 do
			self.hscale=i/90*2.5
			task.Wait()
		end
		for i=0,turnOnTime do
			self.vscale=2*i/turnOnTime
			task.Wait(1)
		end
		for i=0,wait-turnOnTime-90-180 do
			self.vscale=self.vscale+0.007
			task.Wait()
		end
		local vs = self.vscale
		for i=0,15 do
			self.vscale=vs+(7.5-vs)*i/15
			task.Wait()
		end
		task.Wait(165)
		local vs=self.vscale
		for i=1,10 do
			self.vscale=vs*(1-i/10)
			task.Wait()
		end
		lstg.var.block_spell=false
		self.player.slowlock=false
		RawDel(self)
	end)
end

function marisa_spark2:frame()
	task.Do(self)
	self.player.SpellCardHp=self.player.SpellCardHp-K_SpellDecay/2
	self.x=self.player.x
	self.y=self.player.y
	if self.timer>=75 and self.timer%10==0 then
		New(marisa_spark_wave2,self.x,self.y,self.rot,12,0.9,self.player,self.vscale)
	end
	for j,o in ObjList(GROUP_NONTJT) do
		if not o._bosssys then  o.y=min(224,o.y+1) end
	end
	for j,o in ObjList(GROUP_ENEMY) do
		if not o._bosssys then  o.y=min(224,o.y+1) end
	end
	for j,o in ObjList(GROUP_ITEM) do
		o.y=min(226,o.y+2)
	end
end

marisa_spark_wave=Class(object)

function marisa_spark_wave:init(x,y,rot,v,dmg,p,vs)
	self.player=p
	self.x=x
	self.y=y
	self.rot=rot
	self.img='_marisa_spark_wave'
	self.A=self.a
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.vx=v*cos(rot)
	self.vy=v*sin(rot)
	self.dmg=dmg
	self.bound=false
	-- self.rect=true
	self.killflag=true
	self.vs=max(2.5,vs)
end

function marisa_spark_wave:frame()
	self.x=self.player.x
	if self.y>self.a+224 then RawDel(self) end
	if self.timer<=25 then self.vscale=self.vs*sin(90*self.timer/25) end
	self.hscale=self.vscale
	self.a,self.b=self.A*self.hscale,self.A*self.hscale --让碰撞体积随时间也变大
	local last=New(bomb_bullet_killer,self.x,self.y,self.a,self.b,false)
	last.rect=false
	task.Do(self)
end

marisa_spark_wave2=Class(object)

function marisa_spark_wave2:init(x,y,rot,v,dmg,p,vs)
	self.player=p
	self.x=x
	self.y=y
	self.rot=rot
	self.img='_marisa_spark_wave2'
	self.A=self.a
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.vx=v*cos(rot)
	self.vy=v*sin(rot)
	self.dmg=dmg
	self.bound=false
	-- self.rect=true
	self.killflag=true
	self.vs=max(2.5,vs)
end

function marisa_spark_wave2:frame()
	self.x=self.player.x
	if self.y>self.a+224 then RawDel(self) end
	if self.timer<=25 then self.vscale=self.vs*sin(90*self.timer/25) end
	self.hscale=self.vscale
	self.a,self.b=self.A*self.hscale,self.A*self.hscale --让碰撞体积随时间也变大
	local last=New(bomb_bullet_killer,self.x,self.y,self.a,self.b,false)
	last.rect=false	task.Do(self)
end

local releaseMasterSpark=function (self,rot,index)
	self.slowlock=true
	-- New(player_spell_mask,255,255,0,30,240,30)
	-- Print(IsValid(_lastSpark[index]))
	if _lastSpark[index] --[[and _lastSpark[index].life>0--]] then _lastSpark[index].life=_lastSpark[index].life+90 return end
	PlaySound('slash',1.0)
	PlaySound('nep00',1.0)
	-- self.nextspell=300
	self.nextshoot=self.nextshoot+90
	-- self.protect=360
	_lastSpark[index]=New(marisa_spark,self.x,self.y,rot,30,240,30,self,index)
	New(tasker,function()
		
		for i=1,27 do
			-- New(marisa_spark_wave,self.x,self.y,rot,12,0.9,self)
			task.Wait(10)
		end
		New(bullet_killer,self.x,self.y)
		-- PlaySound('slash',1.0)
		self.slowlock=false
	end)
end

local releaseUnlimitedSpark=function (self)
	self.slowlock=true
	PlaySound('slash',1.0)
	PlaySound('nep00',1.0)
	-- self.nextspell=300
	self.nextshoot=self.nextshoot+90
	self.protect=360
	New(marisa_spark2,self.x,self.y,90,15,int(self.SpellCardHpMax/(1.5*K_SpellDecay)),30,self)
	New(tasker,function()
		task.Wait(90)
		for i=1,int(self.SpellCardHpMax/K_SpellDecay/10)-9 do
			-- New(marisa_spark_wave2,self.x,self.y,90,12,0.9,self)
			task.Wait(10)
		end
		New(bullet_killer,self.x,self.y)
		-- PlaySound('slash',1.0)
		
	end)
	misc.ShakeScreen(7.5*60,5)
end

----------------------------------------------------
---SpellCard high1
ray_bullet_killer=Class(object)
function ray_bullet_killer:init(x,y,a,b,rot,kill_indes)
	self.x=x self.y=y
	self.a=a self.b=b
	self.rot=rot
	if self.a~=self.b then self.rect=true end
	self.group=GROUP_PLAYER
	self.hide=true
	self.kill_indes=kill_indes
end
function ray_bullet_killer:frame()
	if self.timer==1 then Del(self) end
end
function ray_bullet_killer:colli(other)
	if self.kill_indes then
		if other.group==GROUP_INDES then
			Kill(other)
		end
	end
	if other.group==GROUP_ENEMY_BULLET then Kill(other) end
end

marisa_ray=Class(object)

function marisa_ray:init(x,y,rot,w,index,dmg,turnOnTime,remainTime,length)
	PlaySound('lazer01',0.6)
	self.x=x self.y=y
	self.sx=x 
	self.sy=y
	self.rot=rot
	self.index=index
	self.img="laserfull"..index
	self.bound=false
	SetImageState(self.img,"mul+add",Color(0xA0FFFFFF))
	self.group=GROUP_PLAYER_BULLET
	self.layer=LAYER_PLAYER_BULLET
	self.vscale=0
	self.hscale=0
	self.killflag=true
	self.node=1
	self.dmg=dmg
	self.length=length
	task.New(self,function()
		for i=0,turnOnTime do
			self.vscale=i/turnOnTime
			self.x=x+length/2*cos(rot)*i/turnOnTime
			self.y=y+length/2*sin(rot)*i/turnOnTime
			self.hscale=length/256*i/turnOnTime
			self.node=(1-i/turnOnTime)
			task.Wait()
		end
		self.node=0
		local v=length/turnOnTime
		self.vx=v*cos(self.rot)
		self.vy=v*sin(self.rot)
	end)
end

function marisa_ray:frame()
	task.Do(self)
	New(ray_bullet_killer,self.x,self.y,self.a,self.b,self.rot,false)
	
	if abs(self.y)>224+self.length/2 then RawDel(self) end
end

function marisa_ray:render()
	local index=self.index/2
	if index%1~=0 then index=index+0.5 end
	-- Print("[debug][marisa_player]"..index)
	SetImageState("preimg"..index,"mul+add",Color(0xFFFFFFFF))
	if self.node>0 then Render("preimg"..index,self.sx,self.sy,self.timer*10,self.node) end
	SetImageState("preimg"..index,"",Color(0xFFFFFFFF))
	object.render(self)
end

marisa_ray_bottle_ef=Class(object)
function marisa_ray_bottle_ef:init(x,y,i)
	self.img="_marisa_playerB_high_spell_ef"..i
	self.x,self.y=x,y
	self.group=GROUP_GHOST
	self.layer=LAYER_PLAYER_BULLET
	ParticleFire(self)
end
function marisa_ray_bottle_ef:frame()
	if self.timer==6 then ParticleStop(self) 
	elseif self.timer==30 then RawDel(self) end
end

marisa_ray_bottle=Class(object)
function marisa_ray_bottle:init(x,y,vx,vy,type,player)
	self.type=type
	self.x,self.y=x,y
	self.player=player
	self.img="_marisa_ray_bottle"..type
	self.rot=ran:Float(0,360)
	self.vx=vx
	self.vy=vy
	self.group=GROUP_GHOST
	self.layer=LAYER_PLAYER_BULLET
	self.omiga=2

	if type==3 then
		self.ay=-0.1
		task.New(self,function() 
			for i=1,45 do
				self.hscale=0.3+0.5*i/45
				self.vscale=0.3+0.5*i/45
				task.Wait()
			end
			-- local w=16
			-- New(marisa_ray,self.x-self.player.x,self.y-self.player.y,ran:Float(80,100),w,13,0.8,45,90,224)
			-- RawDel(self)
		end)
	else
		self.ay=0.1
	end
end
function marisa_ray_bottle:frame()
	task.Do(self)
	
	if self.type==3 then
		local w=16
		local index=13
		if self.y<-224 then 
			New(marisa_ray,self.x,-223,ran:Float(80,100),w,index,0.5,45,90,448) 
			New(marisa_ray_bottle_ef,self.x,self.y,2)
			RawDel(self) 
		end
	else
		if self.y>224 then
			local w=16
			local index=ran:Int(1,16)
			if self.type==1 then index=15 end
			New(marisa_ray,self.x,223,ran:Float(-80,-100),w,index,0.5,45,90,448)
			New(marisa_ray_bottle_ef,self.x,self.y,1)
			RawDel(self)
		end
	end
end

function marisa_ray_bottle:render()
	local k=min(1,self.timer/60)
	SetImageState(self.img,"mul+add",Color(255*k,255,255,255))
	object.render(self)
	SetImageState(self.img,"",Color(255*(1-k),255,255,255))
	object.render(self)
end

function marisa_ray_bottle:kill()
	local w=16
	-- if self.type==1 then
	-- 	New(marisa_ray,self.x,self.y,w,16,0.8,45,90,224,self.player)
		
	-- elseif  self.type==2 then
	-- 	New(marisa_ray,self.x,self.y,w,ran:Int(1,16),0.8,45,90,224,self.player)
	-- end
end

marisa_ray_summoner=Class(object)
function marisa_ray_summoner:init(index,player)
	self.index=index
	self.player=player
	self.life=92
	if IsValid(_last_ray_summoner) then
		if _last_ray_summoner.index==index then _last_ray_summoner.life=_last_ray_summoner.life+90 RawDel(self) self.hide=true
		else RawDel(_last_ray_summoner)  _last_ray_summoner=self end
	else 
		_last_ray_summoner=self
	end
	
	if index==1 or index==2 then
		task.New(self,function()
			for i=1,3 do
				local num=6+2*i
				for i=1,num do
					local vx,vy=-self.x/45+ran:Float(-0.9,0.9),-2.5
					New(marisa_ray_bottle,self.x,self.y,vx,vy,index)
					task.Wait(8)
				end
				task.Wait(90-8*num)
			end
		end)
	elseif index==3 then
		task.New(self,function()
			for i=1,3 do
				for j=1,90 do
					if j%(8-i)==0 then
						
						local vx,vy=-self.x/45+ran:Float(-0.9,0.9),2.5
						New(marisa_ray_bottle,self.x,self.y,vx,vy,3,self.player)
					end
					task.Wait()
				end
			end
		end)
	end
end
function marisa_ray_summoner:frame()
	self.x,self.y=self.player.x,self.player.y
	self.life=self.life-1
	if self.life<=0 then task.Clear(self) RawDel(self) end
	task.Do(self)
end


----------------------------------------------------
---player class

marisa_playerB = Class(player_class)

function marisa_playerB:init(slot)
	self.slowLaserPartNum=16
	marisa_player.load_res_B(self)
	player_class.init(self)
		if not mwy.useMWYwis then self._wisys = mwy.PlayerWalkImageSystem(self) end --到时候记得删掉，不然会覆盖你们的自机行走图系统
	self.name = "marisaB"
	self.hspeed = 4.5
	self.laserWidenSpeed=0.1  --激光增速
	self.laserNode_num=30
	self.highlaser={}
	for i=1,6 do table.insert(self.highlaser,New(marisa_high_laser)) end
	self.highlaser_data={{},{},{},{},{},{}}  --高速激光数据
	self.highlaserWidth=0  --高速激光宽度
	self.slowlaserWidth=0 --低速激光宽度
	self.target_num=5
	self.targetlist={}  --高速激光目标列表，第一个必定是self
	self.nodelist={} --高速激光渲染用点集
	self.nodelist_aim={} --高速激光渲染用过渡点集
	self.cardname = {		
		high1 = '光符「Earth Light Ray」',
		high2 = '光击「Shoot the Moon」',
		high3 = '闪击「Million Steam」',
		low1 = '恋符「Master Spark」',
		low2 = '恋心「Double Spark」',
		low3 = '魔炮「Unlimited Spark」'
	}
	self.slist = {
		{ nil, nil, nil, nil },--0
		{ { 0, 38, 0, 30 }, nil, nil, nil, nil, nil },--1
		{ { 0, 48, 0, 30 }, { 0, 36, 0, 30 }, nil, nil, nil, nil },--2
		{ { 0, 46, 0, 30 }, { -12, 32, 0, 30 }, { 12, 32, 0, 30 }, nil, nil, nil },--3
		{ { 0, 46, 0, 30 }, { -16, 24, 0, 30 }, { 16, 24, 0, 30 }, { 0, 32, 0, 30 }, nil, nil },--4
		{ { 0, 46, 0, 30 }, { -16, 24, 0, 30 }, { 16, 24, 0, 30 }, { -10, 32, 0, 30 }, { 10, 32, 0, 30 }, nil },--5
		{ { -10, 46, 0, 30 }, { -16, 24, 0, 30 }, { 16, 24, 0, 30 }, { -10, 32, 0, 30 }, { 10, 32, 0, 30 }, { 10, 46, 0, 30 } },--6
		{ { -10, 46, 0, 30 }, { -16, 24, 0, 30 }, { 16, 24, 0, 30 }, { -10, 32, 0, 30 }, { 10, 32, 0, 30 }, { 10, 46, 0, 30 } }--6
	}
	self.anglelist = {
		{ -1, -1, -1, -1, -1, -1 },--0
		{ 90, -1, -1, -1, -1, -1 },--1
		{ 90, 90, -1, -1, -1, -1 },--2
		{ 90, 90, 90, -1, -1, -1 },--3
		{ 90, 95, 85, 90, -1, -1 },--4
		{ 90, 95, 85, 90, 90, -1 },--5
		{ 95, 90, 90, 90, 90, 85 },--6
		{ 95, 90, 90, 90, 90, 85 },--6
	}
	self.fire_cold = 30
end

local function high_shoot(self)
	--local num = int(lstg.var.power / 100) + 1
	self.shootstate=1
	
	--[[
	local num = int(self.support)+1
	if self.fire_cold == 0 then
		--local angle = {110,100,80,70,110,70}
		for i = 1, 6 do
			if self.sp[i] and self.sp[i][3] > 0.5 then
				
			end
		end
		self.fire_cold = 30
	end	
	]]
	

end

local function slow_shoot(self)
	self.shootstate=2
	--local angle = {110,100,80,70,110,70}
	--local num = int(lstg.var.power / 100) + 1
	-- local num = int(self.support)+1
	-- Print(num)
	-- if self.timer % 15 == 0 then
		-- for i = 1, 6 do
			-- if self.sp[i] and self.sp[i][3] > 0.5 then

			-- end
		-- end
	-- end
end

function marisa_playerB:shoot()
	if self.timer % 4 == 0 then
		marisa_player.main_shoot(self)
	end
	if self.support > 0 then
		if self.slow == 0 then
			high_shoot(self)
		else
			slow_shoot(self)
		end
	end
end

function marisa_playerB:spell()

	if self.slow == 1 then ----低速符卡
		if self.SpellIndex == 5 or self.SpellIndex == 4 then
			
		end
		if self.SpellIndex == 6 then
			releaseUnlimitedSpark(self)
		end
	else

	end
end

function marisa_playerB:newSpell()
	local deep = min(int(self.KeyDownTimer1 / 90) + 1, 3) --用于表示符卡持续按下的阶段，<90时为阶段1，每过90增加一个阶段,最多阶段三
	if self.SpellIndex > 3 then
		----------低速符卡
		-- PlaySound('power1', 0.8)
		--PlaySound('cat00',0.8)
		K_dr_SlowSpell = 1.25 + K_dr_SpellDmg * lstg.var.dr
		---------------------------------------------
		if self.SpellIndex == 4 then
			releaseMasterSpark(self,90,1)
		end
		if self.SpellIndex == 5 then
			releaseMasterSpark(self,75,1)
			releaseMasterSpark(self,105,2)
		end

	else
		----------高速符卡
		-- PlaySound('nep00', 0.8)
		PlaySound('slash', 0.8)
		K_dr_HighSpell = 1.0 + K_dr_SpellDmg * lstg.var.dr
		New(marisa_ray_summoner,self.SpellIndex,self)
	end
	if self.SpellIndex ~=6 then self.SpellCardHp = max(0, self.SpellCardHp - K_SpellCost) end
end

function marisa_playerB:frame()
	task.Do(self)
	self.shootstate=0
	player_class.frame(self)
	UpdateLaser(self)
	DoLaserDamage(self)
end

function marisa_playerB:render()
	marisa_player.render_support(self)
	
	RenderLaser(self)
	player_class.render(self)

	--调试用
	-- for i=1,#self.targetlist do
	-- 	if IsValid(self.targetlist[i]) then 
	-- 		if self.targetlist[i].x then 
	-- 			-- SetImageState("white","",Color(0x50FFFFFF))
	-- 			RenderText("score",i-1,self.targetlist[i].x,self.targetlist[i].y,2,'center','vcenter')
	-- 			-- Render("white",self.targetlist[i].x,self.targetlist[i].y)
	-- 			-- SetImageState("white","",Color(0xFFFFFFFF))
	-- 		end 
	-- 	end
	-- end
	-- for i=1,6 do 
	-- 	for k,v in pairs(self.highlaser_data[i]) do
	-- 		RenderText("score",k,v.x or 0,v.y or 0,0.5,'center','vcenter')
	-- 	end
	-- end
end

function marisa_playerB:ccc()
	PlaySound('slash', 0.7)
	New(marisa_drug_bottle,self.x,self.y,6,100)
end

