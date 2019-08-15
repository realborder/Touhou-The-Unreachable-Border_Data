
local L,R='left','right'
--角色名用变量代替
local REIMU='reimu'
local VALEN='valenria'
local QUAD='quadrib'
local _tmp_char_info={
	--角色定义，包括：
	--img 角色本体所用的图像
	--rx 角色的表情图像中心与本体图像中心的相对x坐标
	--ry 角色的表情图像中心与本体图像中心的相对y坐标
	--pos 角色通常处于那一策，用L或R指代
	--emolist 角色表情信息列表
		--键值必须是string类型，指代表情类型
		--img 角色表情图像
		--balloontype 角色表情对应的气泡
	[REIMU]={img='',rx=0,ry=0,pos=L,emolist={
		['normal']={img='',balloontype=1},
		['happy']={},
	}},
	[VALEN]={
	}
}

--对话内容，如此一来写对话可完全简化为角色，表情和文字三项
local _tmp_dialog={
	--1代表第一个对话块
	--角色，表情，对话文字，对话气泡停留时长（帧）可不填
	[1]={
		{REIMU,'smile3','...',30},
		{REIMU,'normal','You just piss me off.'},
		...
	},
	[2]={
	
	
	},
	...
}

return _tmp_char_info,_tmp_dialog