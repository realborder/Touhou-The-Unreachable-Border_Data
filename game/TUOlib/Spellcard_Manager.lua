
local function 说明()
	local sample_sc_table_new={
		--boss标识符，从一面到EX面分别为"1A","1B","1F","2"......"6A","6B","EX"
		['1A']={
			{
				--boss在_editor_class中的索引
				"Valenria",
				--显示在符卡练习界面的符卡名
					--如果是string，则无论什么难度都显示这个名称，为空字符串，则显示为“通常弹幕X”，X的值依照前后顺序而定
					--如果是table，则分别对应四个难度来显示，规则和string一样
					--只有对这项的处理不能照抄
				{"静符「情感的抑制」","静符「情感的抑制」","眠符「Abandon Thinking」","眠符「Abandon Thinking」"},
				--符卡本体
				_tmp_sc,
				--符卡在boss符卡流中的次序
				#_editor_class["Valenria"].cards,
				--performing action 对这一项的处理直接照抄就行
				false
			}
		},

	}
end

----------------------------------------
---添加至符卡练习列表，支持直接覆盖
---@param card table 符卡本体
---@param name table 符卡名集合
---@param boss_id string 
---@param card_index number
function _AddToSCPRList(card,name,boss_id,card_index)


end