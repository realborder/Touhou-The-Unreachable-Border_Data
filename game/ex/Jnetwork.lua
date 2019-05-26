---=====================================
---javastg network|input device
---=====================================

local LOG_MODULE_NAME="[jstg][network|input device]"

local function DecToBin(dec,length)
	length=length or 0
	local bitstr=""
	
	while math.floor(dec/2)>0 do
		local ret=math.floor(dec/2)
		local bret=dec%2
		print(ret,bret)
		dec=ret
		bitstr=bret..bitstr
	end
	
	local ret=math.floor(dec/2)
	local bret=dec%2
	print(ret,bret)
	dec=ret
	bitstr=bret..bitstr
	
	local n=length-#bitstr
	if n>0 then
		bitstr=string.rep("0",n)..bitstr
	end
	
	return bitstr
end

----------------------------------------
---JavaStage NetWork

jstg.network={}
jstg.network.type=nil--游戏类型
jstg.network.status=0
jstg.network.host="127.0.0.1"
jstg.network.port=26033
jstg.network.slots={}
jstg.network.delay=0
jstg.network.ran_seed=nil--随机数种子
jstg.devices={}
jstg.network.playerkeymask={0,0,0,0,0,0}
jstg.pingframe = 0

jstg.NETSTATES={'Connecting','Wait for reply','Wait for player','Wait for sync','Connected'}

---发送一个字符串
---@vararg number|boolean|string|table @要发送的内容
---@return boolean
function jstg.SendData(...)
	local arg={...}
	local ret=SendData('O'..Serialize(arg))
	return ret
end

---触发联机的函数
---@param ctype number @游戏类型
function jstg.CreateConnect(ctype)
	if ctype==0 then
		jstg.SinglePlayer()
	elseif jstg.network.status==0 then
		jstg.network.type=ctype
		jstg.network.status=1
		jstg.network.host=network.server
		jstg.network.port=network.port
		jstg.network.delay=network.delay or -1
		if jstg.network.type==1 then
			jstg.network.delay=0
		end
	end
end

---网络连接到指定位置，失败则取消连接
---@param host string @地址
---@param port number @端口
---@return boolean
function jstg.ConnectTo(host,port)
	host=host or jstg.network.host
	port=port or jstg.network.port
	local rt=ConnectTo(host,port)
	if not(rt) then
		ConnectTo('',0)
	end
	return rt
end

---数据包收发以及游戏状态设置，持续网络连接
function jstg.ProceedConnect()
	--已连接的情况下
	if jstg.network.status>1 then
		--获得传送的数据
		local dt=ReceiveData()
		while dt do
			--Print(jstg.network.status,dt)
			lstg.Log(1,LOG_MODULE_NAME,jstg.network.status,dt)
			--由服务器发送的数据
			if string.sub(dt,1,1)=='S' then
				--服务器发送该游戏副本的Slot号，如果是1则认为是房主，负责处理其他信息
				dt=string.sub(dt,2,string.len(dt))
				jstg.network.slot=tonumber(dt)
				jstg.network.slots={}
				jstg.network.is_host=(jstg.network.slot==1)
				jstg.network.status=3
				if not jstg.network.is_host then
					--如果不是房主，则广播一则消息告诉大家“我进来了”
					jstg.SendData('client',jstg.network.slot)
				else
					--房主，本地状态
					jstg.network.slots[1]='local'
				end
			end
			
			--由其他客户端广播的数据
			if string.sub(dt,1,1)=='O' then
				--得到用户发送的lua对象
				dt=string.sub(dt,2,string.len(dt))
				local da=DeSerialize(dt)
				if da[1]=='client' and jstg.network.is_host and jstg.network.status==3 then
					--房主收到其他玩家加入房间的信息
					jstg.network.slots[da[2]]='remote'
					--该玩家的slot是2，说明已经有两个人了，可以开始游戏了
					if da[2]==2 then
						--如果没有设置延迟，发送一个ping包，等back包，再设置延迟开始
						if jstg.network.delay==-1 then
							--send a ping package
							jstg.pingframe = ex.stageframe
							jstg.SendData('ping')
						else
							--if we have enough players ,send message to start
							jstg.network.status=4
							jstg.network.ran_seed = ((os.time() % 65536) * 877) % 65536
							--send players,delay,ran,type seed to sync game status
							jstg.SendData('server',2,jstg.network.delay,jstg.network.ran_seed,jstg.network.type)
						end
					end
				end
				
				--客户端接收到同步参数，准备开始游戏
				if da[1]=='server' and not jstg.network.is_host then
					--receive players,delay,ran seed to sync game status
					jstg.network.status=4
					for i=1,da[2] do
						jstg.network.slots[i]='remote'
					end
					jstg.network.slots[jstg.network.slot]='local'
					jstg.network.delay=da[3]
					jstg.network.ran_seed=da[4]
					jstg.network.type=da[5]
				end
				
				--响应Ping包
				if da[1]=='ping' then
					jstg.SendData('back',jstg.network.slot)
				end
				--Ping成功，开始同步
				if da[1]=='back' and da[2]==2 and jstg.network.is_host and jstg.network.status==3 then
					jstg.network.delay = ex.stageframe - jstg.pingframe
					jstg.network.status=4
					jstg.network.ran_seed = ((os.time() % 65536) * 877) % 65536
					
					--send players,delay,ran,type seed to sync game status
					jstg.SendData('server',2,jstg.network.delay,jstg.network.ran_seed,jstg.network.type)
				end
			end
			
			dt=ReceiveData()
		end
	end
	
	--尝试连接指定IP
	if jstg.network.status==1 then
		local ret=jstg.ConnectTo()
		if ret then
			jstg.network.status=2
		else
			jstg.network.status=0
		end
	end
	
	--后处理：开始游戏
	if jstg.network.status==4 then
		jstg.InitPlayerState()
	end
end

---根据jstg.network.type设置游戏模式
function jstg.InitPlayerState()
	--选择游戏类型
	if jstg.network.type==1 then
		jstg.WatchSinglePlayer()
	elseif jstg.network.type==2 then
		jstg.CoopSinglePlayer()
	elseif jstg.network.type==3 then
		jstg.MultiPlayer()
	end
	jstg.network.status=5
	
	--修改联机菜单标题，返回主菜单
	jstg.nettitle[1]='Disconnect'
	stage_menu.update(jstg.menu_title)
	menu.FlyIn(jstg.menu_title,'left')
	menu.FlyOut(jstg.menu_network,'right')
	ran:Seed(jstg.network.ran_seed)
end

---获取本地玩家列表，返回的table中的数字slot指定jstg.players表中slot位置的自机
---@return table @{slot1,slot2, ... }
function jstg.GetLocalPlayerIndexs()
	local p={}
	for i=1,#jstg.players do
		if jstg.network.playerkeymask[i] == 0 or jstg.network.slots[jstg.network.playerkeymask[i]]=='local' then
			p[#p+1]=i
		end
	end
	return p
end

---单人游戏
function jstg.SinglePlayer()
	if jstg.network.status>1 then
		--退出网络连接
		jstg.ReleaseInputDevices()
		ConnectTo('',0)
	end
	--重设网络连接
	jstg.network.slots={'local'}
	jstg.network.delay=0
	jstg.network.status=0
	jstg.network.ran_seed=nil
	--update input
	jstg.ChangeInput()
	--set key usage
	jstg.network.playerkeymask={0,0,0,0,0,0} --same as 1
	--Print('Single')
	lstg.Log(2,LOG_MODULE_NAME,"已切换到本地单人模式")
end

---旁观模式
function jstg.WatchSinglePlayer()
	--update input
	jstg.ChangeInput2()
	--set key usage
	jstg.network.playerkeymask={0,0,0,0,0,0} --same as 1
	--Print('Single')
	lstg.Log(1,LOG_MODULE_NAME,'Single')
end

---加入游戏
function jstg.CoopSinglePlayer()
	--update input
	jstg.ChangeInput()
	--set key usage
	jstg.network.playerkeymask={0,0,0,0,0,0} --same as 1
	--Print('Single')
	lstg.Log(1,LOG_MODULE_NAME,'Single')
end

---多人游戏
function jstg.MultiPlayer()
	--update input
	jstg.ChangeInput()
	--set key usage
	jstg.network.playerkeymask={1,2,3,4,5,6}
	--Print('Multi')
	lstg.Log(2,LOG_MODULE_NAME,"已切换到网络多人模式")
end

---双人游戏
function jstg.TwoPlay()
	--update input
	jstg.ChangeInput()
	--set key usage
	jstg.network.playerkeymask={0,0,0,0,0,0}
	--Print('Single')
	lstg.Log(1,LOG_MODULE_NAME,'Single')
end

----------------------------------------
---Input Device

local PROTECT_VKEY_INDEX=13--系统默认的虚拟键数量
local DEVICE_MAX_VKEY=32--单个设备最大虚拟键数量

---格式化输入的列表，对应vkey值
---该表为散列表
jstg.syskey={
	--玩家输入
	shoot =0,--1
	spell =1,
	special =2,
	slow =3,
	right =4,
	left =5,
	down =6,
	up =7,--8
	
	--系统输入
	repslow =8,--9
	menu =9,
	repfast =10,
	snapshot =11,
	retry =12,--13
}

---对应的反查字符串
---该表为有序表
---反查时，会偏移一位
jstg.syskey2={
	--玩家输入
	"shoot",--1
	"spell",
	"special",
	"slow",
	"right",
	"left",
	"down",
	"up",--8
	
	--系统输入
	"repslow",--9
	"menu",
	"repfast",
	"snapshot",
	"retry",--13
}

---寻找虚拟键表的空穴
---@param pos number @起始位置
---@return number|boolean @pos
function jstg.FindVkeyVacancy(pos)
	pos=pos or PROTECT_VKEY_INDEX+1
	pos=math.max(PROTECT_VKEY_INDEX+1,pos)
	for i=pos,DEVICE_MAX_VKEY do
		if jstg.syskey2[i]==nil then
			return i
		end
	end
	return false
end

---添加一个虚拟键到jstg中
---@param keyname string @虚拟键名
---@param vkey number|nil @要添加的虚拟键对应的vkey码
---@return boolean
function jstg.RegisterVkey(keyname,vkey)
	if vkey then
		if (vkey+1)>PROTECT_VKEY_INDEX and (vkey+1)<=DEVICE_MAX_VKEY then
			jstg.syskey[keyname]=vkey
			jstg.syskey2[vkey+1]=keyname
			lstg.Log(2,LOG_MODULE_NAME,"添加虚拟键成功，键名为："..keyname.." ，vkey码为："..vkey)
			do return true end
		else
			if (vkey+1)<=PROTECT_VKEY_INDEX then
				lstg.Log(4,LOG_MODULE_NAME,"添加虚拟键失败，键名为："..keyname.." ，vkey码为："..vkey.." ，该位置已被默认虚拟键占用")
			elseif (vkey+1)>DEVICE_MAX_VKEY then
				lstg.Log(4,LOG_MODULE_NAME,"添加虚拟键失败，键名为："..keyname.." ，vkey码为："..vkey.." ，该位置超出设备支持的虚拟键数量")
			end
			do return false end
		end
	else
		local ret=jstg.FindVkeyVacancy()
		if ret then
			jstg.syskey[keyname]=ret-1
			jstg.syskey2[ret]=keyname
			lstg.Log(2,LOG_MODULE_NAME,"添加虚拟键成功，键名为："..keyname.." ，vkey码为："..(ret-1))
			do return true end
		else
			lstg.Log(4,LOG_MODULE_NAME,"添加虚拟键失败，键名为："..keyname.." ，已经没有空间添加虚拟键")
			do return false end
		end
	end
end

---将虚拟按键码转化为setting中的VKEYcode
---@param vkey number @vkey ID，ex+的虚拟键码
---@return number @VKEYcode，操作系统的虚拟键码
function jstg.SysVKey2Key(vkey)
	local keyname=jstg.syskey2[vkey+1]
	
	if setting.keysys[keyname] then
		return setting.keysys[keyname]
	end
	if setting.keys[keyname] then
		return setting.keys[keyname]
	end
	if setting.keys2[keyname] then
		return setting.keys2[keyname]
	end
	
	return 0
end

---清空当前的输入设备
function jstg.ReleaseInputDevices()
	--清空当前的输入设备
	for i=1,#jstg.devices do
		BindInput(0,i,0,0)--取消输入设备挂载
		ReleaseInputDevice(jstg.devices[i])--删除输入设备
	end
	jstg.devices={}
end

---对设备device，用setting中的设置注册VKEYcode到vkey
---@param device userdata @输入设备
---@param slot number @setting的玩家槽位，比如1p、2p等
function jstg.RegisterVkeyToAlias(device,slot)
	local playerkeyinfo=setting.keys
	local syskeyinfo=setting.keysys
	if slot>1 then
		playerkeyinfo=setting['keys'..slot]
	end
	--这里的k，v是jstg.syskey的按键名和对应的vkey
	for k,v in pairs(jstg.syskey) do
		local key=playerkeyinfo[k]--在自机输入设置里拿到VKEYcode
		if key==nil then
			key=syskeyinfo[k]--自机输入里面拿不到就在系统输入里面拿
		end
		if key==nil then
			key=0--都拿不到，直接设置为空(NULL)
		end
		--这里的v，key是jstg.syskey的vkey和VKEYcode
		--增加绑定输入设备的按键，vkey为虚拟按键（0-31），key为实际键值，只对本地输入有效
		AddInputAlias(device,v,key)
	end
end

---重新加载和设置输入设备
function jstg.ChangeInput()
	jstg.ReleaseInputDevices()--清空当前的输入设备
	ResetInput()--重置总线的时间戳
	local playerid=1
	local slotmask=2
	for i=1,#jstg.network.slots do
		if jstg.network.slots[i]=='local' then
			local p=CreateInputDevice(false)--创建本地输入
			--设置按键
			jstg.RegisterVkeyToAlias(p,playerid)
			--绑定总线
			jstg.devices[i]=p
			BindInput(p,i,1+slotmask,jstg.network.delay)
			--Print('bind',i,1+slotmask)
			lstg.Log(2,LOG_MODULE_NAME,"绑定本地设备 "..i.." 到总线，掩码为 "..1+slotmask.." (Binary: "..DecToBin(1+slotmask,4).." )")
			playerid=playerid+1
		else
			local p=CreateInputDevice(true)--创建远程输入
			jstg.devices[i]=p
			BindInput(p,i,1+slotmask,jstg.network.delay)
			lstg.Log(2,LOG_MODULE_NAME,"绑定远程设备 "..i.." 到总线，掩码为 "..1+slotmask.." (Binary: "..DecToBin(1+slotmask,4).." )")
		end
		slotmask=slotmask+slotmask
	end
end

---重新加载和设置输入设备,for watch single player
function jstg.ChangeInput2()
	jstg.ReleaseInputDevices()--清空当前的输入设备
	ResetInput()--重置总线的时间戳
	local playerid=1
	local slotmask=2
	local i=1
	if jstg.network.slots[i]=='local' then
		local p=CreateInputDevice(false)--创建本地输入
		--设置按键
		jstg.RegisterVkeyToAlias(p,playerid)
		--绑定总线
		jstg.devices[i]=p
		BindInput(p,i,1+slotmask,jstg.network.delay)
		playerid=playerid+1
	else--remote
		local p=CreateInputDevice(true)--创建远程输入
		jstg.devices[i]=p
		BindInput(p,i,1+slotmask,jstg.network.delay)
	end
end
