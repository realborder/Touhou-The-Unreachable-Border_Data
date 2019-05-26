---=====================================
---javastg players
---=====================================

----------------------------------------
---javastage world

jstg.worldcount=1--world总数
jstg.worlds={lstg.world}--储存所有world的参数
jstg.currentworld=1--当前执行渲染的world

---对传入的world表设置world参数
---@param world table @传入的table
---@param width number @world宽度
---@param height number @world高度
---@param boundout number @出屏消失扩展范围
---@param sl number @world左边缘在屏幕上的位置
---@param sr number @world右边缘在屏幕上的位置
---@param sb number @world底部在屏幕上的位置
---@param st number @world顶部在屏幕上的位置
function SetLuaSTGWorld(world,width,height,boundout,sl,sr,sb,st)
	world.l=-width/2
	world.pl=-width/2
	world.boundl=-width/2-boundout
	world.r=width/2
	world.pr=width/2
	world.boundr=width/2+boundout
	world.b=-height/2
	world.pb=-height/2
	world.boundb=-height/2-boundout
	world.t=height/2
	world.pt=height/2
	world.boundt=height/2+boundout
	world.scrl=sl
	world.scrr=sr
	world.scrb=sb
	world.scrt=st
end

---对传入的world表设置world参数
---@param world table @传入的table
---@param width number @world宽度
---@param height number @world高度
---@param boundout number @出屏消失扩展范围
---@param sl number @world左边缘在屏幕上的位置
---@param sb number @world底部在屏幕上的位置
---@param m number @world的掩码，用于多world
function SetLuaSTGWorld2(world,width,height,boundout,sl,sb,m)
	SetLuaSTGWorld(world,width,height,boundout,sl,sl+width,sb,sb+height)
	world.world=m
end

---设置当前world数量
---@param cnt number @world数量
function jstg.SetWorldCount(cnt)
	jstg.worldcount=cnt
end

---返回当前world数量
---@return number
function jstg.GetWorldCount()
	return jstg.worldcount
end

---更新world，根据world数量和world掩码激活和设置world
function jstg.UpdateWorld()
	local a={0,0,0,0}
	for i=1,jstg.worldcount do
		a[i]=jstg.worlds[i].world or 0
	end
	ActiveWorlds(a[1],a[2],a[3],a[4])
end

---设置world
---@param index number @world槽位
---@param world table @传入的table
---@param mask number @world的掩码，用于多world
function jstg.SetWorld(index,world,mask)
	world.world=mask
	jstg.worlds[index]=world
end

---根据world槽位获取world参数表
---@param index number @world槽位
---@return table @world参数表
function jstg.GetWorld(index)
	return jstg.worlds[index]
end

---通过world掩码获取worlds对象表
---@param world number @world的掩码
---@return table @worlds对象表
function jstg.GetWorldsByWorld(world)
	return jstg.GetObjectByWorld(jstg.worlds,world)
end

---切换到槽位指定的world
---@param index number @world槽位
function jstg.SwitchWorld(index)
	jstg.currentworld=index
	jstg.ApplyWorld(jstg.GetWorld(index))
end

---应用world参数
---@param world table @world参数表
function jstg.ApplyWorld(world)
	lstg.world=world
	SetBound(lstg.world.boundl,lstg.world.boundr,lstg.world.boundb,lstg.world.boundt)
end

---清除多world参数
function jstg.ResetWorlds()
	jstg.SetWorldCount(1)
	jstg.worlds={}
	jstg.worlds[1]=GetDefaultWorld()--Lscreen
	jstg.SwitchWorld(1)
	jstg.UpdateWorld()
end

---设置为花映冢样式的版面
function jstg.TestWorld(a)
	jstg.SetWorldCount(2)
	local w1={}
	SetLuaSTGWorld(w1,288,448,32,16,288+16,16,16+448);
	jstg.SetWorld(1,w1,1+2)
	local w2={}
	SetLuaSTGWorld(w2,288,448,32,320+16,288+320+16,16,16+448);
	jstg.SetWorld(2,w2,1+4)
end

----------------------------------------
---javastage object

---对表内所有对象（table）的key=a的value，设置为v
---(设置list中所有obj的attr属性为value)
---@param l table @传入的table
---@param a number|string @索引
---@param v object any @万物皆允
function ListSet(l,a,v)
	for i=1,#l do
		l[i][a]=v
	end
end

-- TODO:以后这个加入到Lmath豪华套餐里面吧
---传入一个table，随机获取table中的一个对象
---@param list table @传入的table
---@return object any @万物皆允
function ran:List(list)
	return list[ran:Int(1,#list)]
end

---传入一个对象表，通过world掩码取得所有在该world掩码下的对象
---@param list table @对象表
---@param world number @world掩码
---@return table @处于同world的对象
function jstg.GetObjectByWorld(list,world)
	local w={}
	local j=1
	for i=1,#list do
		if IsInWorld(world,list[i].world) then
			w[j]=list[i]
			j=j+1
		end
	end
	return w
end

---传入一个对象表，通过world掩码取得所有在该world掩码下的对象
---@param list table @对象表
---@param world number @world掩码
---@return table @处于同world的对象
function jstg.GetObjectByObject(list,world)
	local w={}
	local j=1
	for i=1,#list do
		if IsSameWorld(world,list[i].world) then
			w[j]=list[i]
			j=j+1
		end
	end
	return w
end

----------------------------------------
---javastage player

--jstg.player_template={}--unkown
jstg.players={}--储存实例化的自机对象

---摇奖，获取一个自机对象
---@param o object|nil @要获取自机对象的对象，不传入则自动获取
function ran:Player(o)
	return ran:List(Players(o))
end

---通过world掩码获取自机对象表
function jstg.GetPlayersByWorld(world)
	return jstg.GetObjectByWorld(jstg.players,world)
end

---计算在当前多场地多玩家情况下，自机应该在哪里出现
---@return number,number
function jstg:GetPlayerBirthPos()
	--Get players that may be in a same world
	local ps=jstg.GetPlayersByWorld(self.world)
	local n=#ps
	local p=1
	for i=1,n do
		if self==ps[i] then
			p=i
			break
		end
	end
	if n==0 then n=1 end --the player is not actually in game
	--Get worlds
	local ws=jstg.GetWorldsByWorld(self.world)
	--if this player is in no world,abandon
	if #ws==0 then
		return 0,-24
	end
	--just use the first one
	ws=ws[1]
	return (ws.r-ws.l)/n*0.5*(2*i-1)+ws.r,ws.b-24
end

---替换xxx==player，和IsPlayerEnd成对使用
---@param obj object @要判断的object对象
---@return boolean
function IsPlayer(obj)
	for i=1,#jstg.players do
		if obj==jstg.players[i] then
			jstg._player=player
			player=obj
			return true
		end
	end
	return false
end
---结束IsPlayer，清理变量
function IsPlayerEnd()
	if jstg._player then
		player=jstg._player
		jstg._player=nil
	end
end

---设置当前的自机对象
---@param p object|nil @要设置为当前自机的对象
function SetPlayer(p)
	jstg.current_player=p
end

---替换editor中的player（单体），获取自机对象
---@param o object|nil @要获取自机对象的对象，不传入则自动获取
function _Player(o)
	if jstg.current_player then return jstg.current_player end
	return Player(o)
end

---替换player（单体），不使用随机数，获取自机对象，获取的自机会和传入的对象同一个world
---@param o object|nil @要获取自机对象的对象，不传入则自动获取
function Player(o)
	if o==nil then o=GetCurrentObject() end
	if o then
		local w=jstg.GetPlayersByWorld(o.world)
		if #w==0 then return player end --no player in same world,return a random one
		if #w==1 then return w[1] end
		return w[ex.stageframe%#w+1]
	end
	return player
end

---获取自机对象表，获取的自机对象表的自机会和传入的对象同一个world
---@param o object|nil @要获取自机对象的对象，不传入则自动获取
function Players(o)
	if o==nil then o=GetCurrentObject() end
	if o then
		local w=jstg.GetObjectByObject(jstg.players,o.world)
		return w
	end
	return jstg.players
end
