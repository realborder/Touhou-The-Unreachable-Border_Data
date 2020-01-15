local m={}
tuolib.spellcard_manager=m



local function 说明()
	local sample_sc_table_new={
		--boss标识符，从一面到EX面分别为"1A","1B","2"......"6A","6B","EX"
		['1A']={
			---@class cardinfo
			{
				--boss在_editor_class中的索引
				boss_name="Valenria",
				--显示在符卡练习界面的符卡名
					--如果是string，则无论什么难度都显示这个名称，为空字符串，则显示为“通常弹幕X”，X的值依照前后顺序而定
					--如果是table，则分别对应四个难度来显示，规则和string一样
					--只有对这项的处理不能照抄
				card_name={"静符「情感的抑制」","静符「情感的抑制」","眠符「Abandon Thinking」","眠符「Abandon Thinking」"},
				--符卡本体, 可能会变成{sc_Easy,sc_Normal,sc_Hard,sc_Lunatic}，因为都是表所以通过判断有无init属性来判断是否是符卡吧
				card=_tmp_sc,
				performingaction=false
			}
		},

	}
end
-- 说明() --卧槽真就可以用中文当函数名？好吧，挺正常的
----------------------------------------
---添加至符卡练习列表，支持直接覆盖
---@param card table 符卡本体
---@param name table 符卡名集合
---@param boss_name string
---@param boss_id string 
---@param card_index number 这个数字代表了这张卡在符卡练习列表里的次序，在编辑器里把这个留空则不计入符卡练习列表中
---@param performingaction boolean
function m.EditSpellCardList(card, name, boss_name, boss_id, card_index ,performingaction)
	if not card_index then return end

	if not _sc_table_new[boss_id] then _sc_table_new[boss_id]={} end
	local sctb=_sc_table_new[boss_id]

	if not sctb[card_index] then sctb[card_index]={} end
	local cardinfo=sctb[card_index]
	
	local pos=string.find(boss_name,":") 
	local index=nil

	--符卡信息分难度的话用表存储
	if pos then
		local diff=string.sub(boss_name,pos+1)
		for i,v in ipairs({"Easy","Normal","Hard","Lunatic"}) do
			if diff==v then index=i end
		end
	end

	--是否为道中，这个属性备用
	if string.find(boss_name,"mid") then cardinfo.is_mid=true end

	--符卡名字、符卡本体、是否为符卡这些信息的存入
	if index then 
		if not cardinfo.card then cardinfo.card={} end
		if not cardinfo.card_name then cardinfo.card_name={} end
		cardinfo.card_name[index]=name
		cardinfo.card[index]=card
		if name~='' then cardinfo.is_sc[index]=true end
	else
		cardinfo.card_name=name
		cardinfo.card=card
		if name~='' then cardinfo.is_sc=true end
	end
	cardinfo.performingaction=performingaction
	cardinfo.boss_name=boss_name
	
end
_AddToSCPRList=m.EditSpellCardList





local non_sc_prefix1="道中-通常弹幕"
local non_sc_prefix2="通常弹幕"
---废弃的函数，用来整理符卡名字，让通常弹幕也带上次序
function m.SortCardName(boss_id,card_index,difficulty)
	local sctb=_sc_table_new[boss_id]
	if not sctb then TUO_Developer_Flow:ErrorWindow("没这boss！\nboss_id: "..boss_id) end
	local mid_nonsc_count,nonsc_count=0,0
	for i,v in ipairs(sctb) do
		local is_sc=false
		if type(v.is_sc)=='table' then
			is_sc=v.is_sc[difficulty]
			-- if not v.realname then v.realname={} end
		else
			is_sc=v.is_sc
		end
		if not is_sc then
			local realname
			if v.is_mid then
				mid_nonsc_count	=mid_nonsc_count+1
				realname=non_sc_prefix1..tostring(mid_nonsc_count)
			else
				nonsc_count=nonsc_count+1
				realname=non_sc_prefix2..tostring(nonsc_count)
			end
			if type(v.is_sc)=='table' then
				v.name[difficulty]=realname
			else
				v.name=realname
			end
		else

		end
	end




	
	local cardinfo=sctb[card_index]
	if not cardinfo then TUO_Developer_Flow:ErrorWindow("没这张符卡！\nboss_id: "..boss_id.."\ncard_index: "..card_index) end

end