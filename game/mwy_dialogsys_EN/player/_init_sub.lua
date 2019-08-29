
local L,R='left','right'
--角色名用变量代替
local REIMU='reimu'
local MARISA='marisa'
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
	[REIMU]={pos=L,emolist={
		['confused1']=1,
		['confused2']=1,
		['confused3']=1,
		['ease1']=1,
		['ease2']=1,
		['ease3']=1,
		['laugh1']=1,
		['laugh2']=1,
		['laugh3']=1,
		['normal1']=1,
		['normal2']=1,
		['normal3']=1,
		['pissedoff1']=1,
		['pissedoff2']=1,
		['pissedoff3']=1,
		['rage']=1,
		['say1']=1,
		['say2']=1,
		['say3']=1,
		['scorn']=1,
		['selfconfidence1']=1,
		['selfconfidence2']=1,
		['smile1']=1,
		['smile2']=1,
		['smile3']=1,
		['speechless1']=1,
		['speechless2']=1,
		['speechless3']=1,
		['yaowei']=1
		}
	},
	[MARISA]={pos=L,emolist={
		['awkward']=1,
		['confused']=1,
		['confused2']=1,
		['ease']=1,
		['laugh']=1,
		['mad']=1,
		['normal1']=1,
		['normal2']=1,
		['normal3']=1,
		['say1']=1,
		['say2']=1,
		['say3']=1,
		['scorn']=1,
		['shock']=1,
		['smile']=1
		}
	}
}

return _tmp_char_info,nil