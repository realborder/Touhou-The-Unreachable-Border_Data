
local L,R='left','right'
--角色名用变量代替
local REIMU='reimu'
local MARISA='marisa'

local HALLU='Boss3'
local _tmp_char_info={
	--角色定义，包括：
	--pos 角色通常处于那一策，用L或R指代
	--emolist 角色表情信息列表
		--键值必须是string类型，指代表情类型，同时也是图片和文件名的一部分
		--表项的值是角色表情对应的气泡索引
	[HALLU]={pos=R,emolist={
		['faiil']=1,
		['laugh']=1,
		['normal']=1,
		['saying1']=1,
		['saying2']=1,
		['smile']=1,
		['taught1']=1,
		['taught2']=1,
		['unholdable']=1
		}
	}
}

--对话内容，如此一来写对话可完全简化为角色，表情和文字三项
local _tmp_dialog={
	--1代表第一个对话块
	--角色，表情，对话文字，对话气泡停留时长（帧）可不填
	[1]={
		{REIMU,'smile1','你看到的是一个没完成的对话',30},
		{REIMU,'smile1','直接帮你跳过了嗷',30}
	},
	[2]={
		{REIMU,'smile1','你看到的是一个没完成的对话',30},
		{REIMU,'smile1','直接帮你跳过了嗷',30}
	},
	[3]={
		{REIMU,'smile1','你看到的是一个没完成的对话',30},
		{REIMU,'smile1','直接帮你跳过了嗷',30}
	},
	[4]={
		{REIMU,'smile1','你看到的是一个没完成的对话',30},
		{REIMU,'smile1','直接帮你跳过了嗷',30}
	},
	[5]={
		{HALLU,'faiil','你看到的是一个没完成的对话',30},
		{HALLU,'faiil','直接帮你跳过了嗷QAQ',30}
	},
	[100+1]={
		{MARISA,'smile','你看到的是一个没完成的对话',30},
		{MARISA,'smile','直接帮你跳过了嗷',30}
	},
	[100+2]={
		{MARISA,'smile','你看到的是一个没完成的对话',30},
		{MARISA,'smile','直接帮你跳过了嗷',30}
	},
	[100+3]={
		{MARISA,'smile','你看到的是一个没完成的对话',30},
		{MARISA,'smile','直接帮你跳过了嗷',30}
	},
	[100+4]={
		{MARISA,'smile','你看到的是一个没完成的对话',30},
		{MARISA,'smile','直接帮你跳过了嗷',30}
	},
	[100+5]={
		{HALLU,'faiil','你看到的是一个没完成的对话',30},
		{HALLU,'faiil','直接帮你跳过了嗷QAQ',30}
	}

}

return _tmp_char_info,_tmp_dialog