
local L,R='left','right'
--角色名用变量代替
local REIMU='reimu'
local MARISA='marisa'

local TEE='Boss4'
local _tmp_char_info={
	--角色定义，包括：
	--pos 角色通常处于那一策，用L或R指代
	--emolist 角色表情信息列表
		--键值必须是string类型，指代表情类型，同时也是图片和文件名的一部分
		--表项的值是角色表情对应的气泡索引
	[TEE]={pos=R,emolist={
		-- ['normal']=1,
		}
	}
}

--对话内容，如此一来写对话可完全简化为角色，表情和文字三项
local _tmp_dialog={
	--1代表第一个对话块
	--角色，表情，对话文字，对话气泡停留时长（帧）可不填
	[1]={
	},
	[2]={
	},
	[3]={		
	},
	[4]={		
	},
	[5]={		
	},
	[100+1]={
		},
	[100+2]={
		},
	[100+3]={
		},
	[100+4]={
		},
	[100+5]={
	}
	

}

return _tmp_char_info,_tmp_dialog