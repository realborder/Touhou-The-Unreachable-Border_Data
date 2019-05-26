---=====================================
---javastg input controll
---=====================================

local LOG_MODULE_NAME="[jstg][player|input]"

----------------------------------------
---Input

jstg.keys={}--各个输入槽位对应的当前帧按键状态
jstg.keypres={}--各个输入槽位对应的前一帧按键状态
jstg.KeyState={}
jstg.KeyStatePre={}
jstg.LastKey=0--最后输入的按键对应的VKEYcode
jstg.OldKeyState={}--这屌玩意一直是空的表，不知道干嘛用的，也有可能是一个引用类型的表

---旧函数，获取最后按下的按键
_GetLastKey=GetLastKey

---获取最后按下的按键
---@param id number @输入槽位
---@return number @VKEYcode
function GetLastKey(id)
	if id then
		local k1=jstg.keys[id]
		local kp=jstg.keypres[id]
		for k, v in pairs(jstg.syskey) do
			if k1[k]~= kp[k] and k1[k] then
				return jstg.SysVKey2Key(v)
			end
		end
	else
		return jstg.LastKey
	end
end

---判断某个按键是否处于按下状态
---@param key string @按键名
---@param id number @输入槽位
---@return boolean
function KeyIsDown(key,id)
	if id then
		return jstg.keys[id][key]
	else
		return KeyState[key]
	end
end

---判断某个按键是否处于当前帧按下
---@param key string @按键名
---@param id number @输入槽位
---@return boolean
function KeyIsPressed(key,id)
	if id then
		return jstg.keys[id][key] and (not jstg.keypres[id][key])
	else
		return KeyState[key] and (not KeyStatePre[key])
	end
end

---判断某个按键是否处于按下状态
KeyPress = KeyIsDown

---判断某个按键是否处于按下状态
KeyTrigger = KeyIsPressed

----------------------------------------
---Player Input

--jstg.keymaps={}--unkown
--jstg.splitplayer=false--unkown

jstg.inputcount=1--当前输入槽位数量
jstg.enable_player=false--若进入关卡初始化后该值为false，则代表该mod为旧mod

---更新自机输入槽位总数
---@param count number @自机输入槽位数量
function jstg.CreateInput(count)
	jstg.inputcount=count
	for i=count,0,-1 do
		jstg.keys[i]={}
		jstg.keypres[i]={}
	end
end

---获得自机输入槽位总数
---@return number
function jstg.GetInputCount()
	return jstg.inputcount
end

---创建自机，ex+版
function jstg.CreatePlayers()
	jstg.enable_player=true
	
	local last=New(_G[lstg.var.player_name],1)
	jstg.players={last}
	jstg.CreateInput(1)
	last.key=jstg.keys[1]
	last.keypre=jstg.keypres[1]
	
	if lstg.var.player_name2 then
		last.world=2
		
		jstg.CreateInput(2)
		last.key=jstg.keys[1]
		last.keypre=jstg.keypres[1]
		
		last=New(_G[lstg.var.player_name2],2)
		last.key=jstg.keys[2]
		last.keypre=jstg.keypres[2]
		last.world=4
		jstg.players[2]=last
	end
end

---创建自机，兼容旧mod
function jstg.Compatible()--for old mod
	jstg.players={player}
	local last=player
	jstg.CreateInput(1)
	
	if last then
		last.key=jstg.keys[1]
		last.keypre=jstg.keypres[1]
	end
	
	if lstg.var.player_name2 then
		last.world=2
		
		jstg.CreateInput(2)
		last.key=jstg.keys[1]
		last.keypre=jstg.keypres[1]
		last=New(_G[lstg.var.player_name2],2)
		last.key=jstg.keys[2]
		last.keypre=jstg.keypres[2]
		last.world=4
		jstg.players[2]=last
	end
end

----------------------------------------
---Game Input

---刷新输入状态
---@param is_pause boolean @是否处于暂停状态
function jstg.GetInputEx(is_pause)--OLC提供的一个解决方法，解决了非自机输入在rep中检测不到的问题
	--get players input
	for i=1,jstg.GetInputCount() do
		KeyStatePre = {}
		KeyState = jstg.keys[i]
		jstg.GetInputSingleEx(i,is_pause)
		for k, v in pairs(setting.keys) do
			jstg.keypres[i][k] = KeyStatePre[k]
		end
	end
	--get system input
	KeyStatePre = {}
	KeyState = jstg.KeyState
	--update and get last key
	for k, v in pairs(jstg.syskey) do
		KeyStatePre[k] = KeyState[k]
	end
	jstg.LastKey=0
	for k, v in pairs(jstg.syskey) do
		local t = GetVKeyStateEx(0,jstg.syskey[k])
		if t~= KeyState[k] then
			local s=jstg.SysVKey2Key(v)
			if t then
				jstg.LastKey=s
			else
				if s==jstg.LastKey then
					jstg.LastKey=0
				end
			end
			KeyState[k]=t
		end
	end
	if not is_pause then
		for k, v in pairs(setting.keys) do
			KeyState[k] = false
		end
		for i=1,jstg.inputcount do
			for k, v in pairs(jstg.keys[i]) do
				KeyState[k] = v or KeyState[k]
			end
		end
	end
	--compatible old stage replay
	if ext.replay.IsReplay() and jstg.enable_player==false then
		KeyState=jstg.OldKeyState
		KeyStatePre = {}
		for k, v in pairs(setting.keys) do
			KeyStatePre[k] = KeyState[k]
			KeyState[k] = jstg.keys[1][k]
		end
	end
end
function jstg.OldGetInputEx(is_pause)--旧方法的备份
	--get players input
	for i=1,jstg.inputcount do
		KeyStatePre = {}
		KeyState = jstg.keys[i]
		jstg.GetInputSingleEx(i,is_pause)
		for k, v in pairs(setting.keys) do
			jstg.keypres[i][k] = KeyStatePre[k]
		end
	end
	--get system input
	--！！警告：jstg.KeyState一直是空的草
	KeyStatePre = {}
	KeyState = jstg.KeyState
	for k, v in pairs(jstg.syskey) do
		KeyStatePre[k] = KeyState[k]
	end
	--update and get last key
	--！！警告：lastkey虽然正常，但是还是有问题
	jstg.LastKey=0
	for k, v in pairs(jstg.syskey) do
		local t = GetVKeyStateEx(0,jstg.syskey[k])
		if t~= KeyState[k] then
			local s=jstg.SysVKey2Key(v)
			if t then
				jstg.LastKey=s
			else
				if s==jstg.LastKey then
					jstg.LastKey=0
				end
			end
			KeyState[k]=t
		end
	end
	--compatible old stage replay
	if ext.replay.IsReplay() and jstg.enable_player==false then
		KeyState=jstg.OldKeyState
		KeyStatePre = {}
		for k, v in pairs(setting.keys) do
			KeyStatePre[k] = KeyState[k]
			KeyState[k] = jstg.keys[1][k]
		end
	end
end

---从指定输入槽位刷新输入状态
---@param i number @槽位
---@param is_pause boolean @是否处于暂停状态
function jstg.GetInputSingleEx(i,is_pause)
	local sk=setting.keys
	if stage.next_stage then
		KeyStatePre = {}
	else
		-- 刷新KeyStatePre
		for k, v in pairs(sk) do
			KeyStatePre[k] = KeyState[k]
		end
	end
	
	-- 不是录像时更新按键状态
	if not ext.replay.IsReplay() then
		for k,v in pairs(sk) do
			KeyState[k] = GetVKeyStateEx(jstg.network.playerkeymask[i],jstg.syskey[k])
		end
	end
	
	if not is_pause then
		if ext.replay.IsRecording() then
			-- 录像模式下记录当前帧的按键
			replayWriter:Record(KeyState)
		elseif ext.replay.IsReplay() then
			-- 回放时载入按键状态
			replayReader:Next(KeyState)
		end
	end
end
