Include"mwy_dialogsys\\mwy_dialogsys_sub.lua"
-----------------------------------------------------------------------------------
--外挂式对话系统
--目的是将原本在工程内的对话和对话所用的立绘全部移到外部脚本中

dialogsys={}
dialogsys.data={}
local LOG_HEAD='[dialogsys]'
--这个player是玩家，毕竟不可能往所有stage里都放一次丽灵梦对吧~
local STAGE={'player','st1','st2','st3'--[[,'st4','st5','st6a','st6b','ex']]} --未制作的关卡暂时屏蔽

local PATH='mwy_dialogsys\\'

---对话系统初始化
---需要在游戏启动的时候调用，如果在游戏过程中重复调用则相当于重载

function dialogsys.init()
	dialogsys.data={}
	for k,v in pairs(STAGE) do
		local ch,dia=lstg.DoFile(PATH..v..'\\_init.lua')
		if ch or dia then dialogsys.data[v]={} end
		if ch then dialogsys.data[v].character={} end
		for _k,_v in pairs(ch) do dialogsys_sub.data[v].character[_k]=_v end
		if dia then dialogsys_sub.data[v].dialog={} end
		for _k,_v in pairs(dia) do dialogsys_sub.data[v].dialog[_k]=_v end
	end
end

---在关卡开头载入对话所用的img
---@param stage string 关卡对应的字符串索引值
function dialogsys.loadimg(stage) --对应工程中的load部分
	local PATH=PATH..stage.."\\"
	for k,v in pairs(dialogsys.data[stage].character) do
		LoadImageFromFile(v.img,PATH..v.img)
		for k,v in pairs(v.emolist) do LoadImageFromFile(v.img,PATH..v.img) end
	end
end

---在关卡内应用对话块
---@param stage string 关卡对应的字符串索引值
---@param index number 对块索引值
function dialogsys:play(stage,index) --对应工程中的sentence部分
	if type(stage)~='string' then error('param#1 requeire string value') end
	if type(index)~='number' then error('param#2 requeire number value') end
	if not dialogsys.data[stage] then error('Look at dialog of '..stage..'['..index..']  It\'s just empty!') end
	local stagech=dialogsys.data[stage].character
	local dia=dialogsys.data[stage].dialog[index]
	for k,v in dia do
		local ch
		if stagech[v[1]] then ch=stagech[v[1]] 
		else --如果找不到就从玩家里找
			if dialogsys.data['player'].character[v[1]] then ch=dialogsys.data['player'].character[v[1]] 
			else error(LOG_HEAD..'Undefined character named'..v[1]) end
		end
		local text=v[3]
		local emo=dia[2]
		local emoinfo=ch.emolist[emo]
		local text=dia[3]
		local tpic=emoinfo.balloontype
		boss.dialog:sentence(self, ch.img, ch.pos, text, dia[4], nil, nil, tpic, num, emo, ch.rx, ch.ry)
	end
end


