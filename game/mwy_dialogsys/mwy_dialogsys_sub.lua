-----------------------------------------------------------------------------------
--外挂式对话系统
--目的是将原本在工程内的对话和对话所用的立绘全部移到外部脚本中

dialogsys_sub={}
dialogsys_sub.data={}
local LOG_HEAD='[dialogsys]'
--这个player是玩家，毕竟不可能往所有stage里都放一次丽灵梦对吧~
local STAGE={'player','st1','st2','st3'--[[,'st4','st5','st6a','st6b','ex']]} --未制作的关卡暂时屏蔽

local PATH='mwy_dialogsys\\'

---对话系统初始化
---需要在游戏启动的时候调用，如果在游戏过程中重复调用则相当于重载

function dialogsys_sub.Init()
	if dialogsys_sub.inited then return end
	dialogsys_sub.data={}
	for k,v in pairs(STAGE) do
		local ch,dia=lstg.DoFile(PATH..v..'\\_init_sub.lua')
		if ch or dia then 
			dialogsys_sub.data[v]={} 
			--校检对话所用资源是否与定义一一对应
			--但是没时间做
		end
		if ch then 
			dialogsys_sub.data[v].character={} 
			for _k,_v in pairs(ch) do dialogsys_sub.data[v].character[_k]=_v end 
		end
		if dia then 
			dialogsys_sub.data[v].dialog={} 
			for _k,_v in pairs(dia) do dialogsys_sub.data[v].dialog[_k]=_v end 
		end
	end
	dialogsys_sub.LoadImage('player')
	dialogsys_sub.inited=true
end

---在关卡开头载入对话所用的img
---@param stage string 关卡对应的字符串索引值
function dialogsys_sub.LoadImage(stage) --对应工程中的load部分
	local PATH=PATH..stage.."\\"
	if dialogsys_sub.data[stage].character then 
		for k,v in pairs(dialogsys_sub.data[stage].character) do
			local imgname=k.."_dialog_"
			for _k,_v in pairs(v.emolist) do 
				LoadImageFromFile(imgname.._k,PATH..imgname.._k..".png") 
				Print('[mwy_dialogsys]加载'..PATH..imgname.._k..".png")
			end
		end
	end
	---底层更新之后不再需要在一开始缓存字形了
	-- if dialogsys_sub.data[stage].dialog then
	-- 	for k,v in pairs(dialogsys_sub.data[stage].dialog) do
	-- 		for _,_v in pairs(v) do
	-- 			-- CacheTTFString('balloon_font',_v[3])
	-- 		end
	-- 	end
	-- end
end

---在关卡内应用对话块
---@param stage string 关卡对应的字符串索引值
---@param index number 对块索引值
function dialogsys_sub.Play(self,stage,index) --对应工程中的sentence部分
	if type(stage)~='string' then error('param#1 requeire string value') end
	if type(index)~='number' then error('param#2 requeire number value') end
	if not dialogsys_sub.data[stage] then error('Look at dialog of '..stage..'['..index..']  It\'s just empty!') end
	if not IsValid(player) then  error("I dont know now who is player") end
	local i=0
	if player.name=="reimuA" or player.name=="reimuB" then i=0 end
	if player.name=="marisaA" or player.name=="marisaB" then i=1 end
	index=index+i*100

	local stagech=dialogsys_sub.data[stage].character
	local dia=dialogsys_sub.data[stage].dialog[index]
	for k,v in pairs(dia) do
		local ch
		if stagech[v[1]] then ch=stagech[v[1]] 
		else --如果找不到就从玩家里找
			if dialogsys_sub.data['player'].character[v[1]] then ch=dialogsys_sub.data['player'].character[v[1]] 
			else error(LOG_HEAD..'Undefined character named'..v[1]) end
		end
		local text=v[3]
		local emo=v[2]
		local imgname=v[1].."_dialog_"..emo
		local tpic=ch.emolist[emo]
		boss.dialog.sentence(self, imgname, ch.pos, text, v[4], 0.5, 0.5, tpic)
	end
end

