
local L,R='left','right'
--角色名用变量代替
local REIMU='reimu'
local MARISA='marisa'
local VALEN='Boss1A'
local QUAD='Boss1B'
local _tmp_char_info={
	--角色定义，包括：
	--pos 角色通常处于那一策，用L或R指代
	--emolist 角色表情信息列表
		--键值必须是string类型，指代表情类型，同时也是图片和文件名的一部分
		--表项的值是角色表情对应的气泡索引
	[VALEN]={pos=R,emolist={
		['happy']=1,
		['lose_happy']=1,
		['lose']=1,
		['normal']=1,
		['question']=1,
		['shock']=1
		}
	},
	[QUAD]={pos=R,emolist={
		['annoyed']=1,
		['annoyed2']=1,
		['failed']=1,
		['failed2']=1,
		['failed3']=1,
		['normal']=1
		}
	}
}

--对话内容，如此一来写对话可完全简化为角色，表情和文字三项
local _tmp_dialog={
	--1代表第一个对话块 +100则是下一个角色
	--单个表项{角色，表情，对话文字，对话气泡停留时长（帧）可不填}
	--语句过长请用\n分段，参见51行
	[1]={
		{REIMU,'speechless1','一出门就遇上这么多麻烦的事情，都已经有回神社休息的想法了。'},
		{REIMU,'normal3','刚才那个家伙，给我现身吧。'}
	},
	[2]={
		{VALEN,'shock','竟然没有睡着，怎么会……'},
		{REIMU,'smile1','仅仅只是这种程度就想让我睡着？我还没有弱到会被妖精催眠呢。'},
		{VALEN,'question','不可能！不可能！不可能！明明每次都能得手的说！'},
		{VALEN,'normal','你应该会像之前过来的人一样昏睡过去，然后……'},
		{VALEN,'happy','奇妙的梦境便会展现出来！'},
		{REIMU,'say2','……居然已经有妖精在利用这异变来进行恶作剧，有必要教训一顿了。'},
		{REIMU,'pissedoff1','像这样的能力平时没什么，但在现在的这种情形下倒是变得相当危险。'},
		{REIMU,'smile1','而且那个将人吸引入林中的声音可不像你能够做到的事情，\n看起来你还有另一个同伙吧。'},
		{VALEN,'question','诶，你是怎么发现我有同伴的？'},
		{REIMU,'smile3','既然有同伴那就赶快现身！'}
	},
	[3]={
		{QUAD,'normal','这也是被吸引过来的人类吗？怎么没有睡着？'},
		{REIMU,'ease3','什么嘛，原来只是妖怪鸟而已，\n能和妖精合作的妖怪果然也强不到哪里去啊。'},
		{REIMU,'laugh1','本来还在期待能遇到可以令人提得起兴趣的家伙。'},
		{QUAD,'annoyed','喂喂，不要这么看不起我啊。'},
		{QUAD,'annoyed2','不过你看起来不像是容易对付的家伙。'},
		{VALEN,'normal','是呀，就连我也没有成功让她昏睡呢。'},
		{REIMU,'laugh1','正好，都报明了自己的身份，省得我费心去调查了。'},
		{REIMU,'smile1','既然如此，你们就乖乖接受我博丽巫女的退治吧！'},
		{QUAD,'annoyed2','那么你也乖乖的在这树林中沉睡吧！'},
		{VALEN,'happy','正好也让我看看你的梦会是什么样。'}
	},
	[4]={
		{QUAD,'failed','疼疼疼——'},
		{QUAD,'failed2','难不成你是神社的巫女？'},
		{REIMU,'smile1','现在才注意到?'},
		{REIMU,'smile3','你们最好把所有的事情给我全部说清楚。'},
		{QUAD,'failed3','最近无论是人类还是妖怪，做的梦似乎都会成真。'},
		{VALEN,'lose','梦会成真和我们没有关系！！'},
		{QUAD,'failed3','于是我便去引来路过这里的人，再由她让这些人昏睡。'},
		{VALEN,'lose_happy','前一阵可是有人变出了许许多多的蝴蝶哦！'},
		{VALEN,'lose_happy','不过也有人的梦很是惊险刺激。'},
		{VALEN,'lose_happy','但还是乐趣满满呢。'},
		{REIMU,'ease1','嗯哼哼，真是记吃不记打的家伙。'}
	},
	[1+100]={
		{MARISA,'awkward','去人类村落的路还是一如既往地难走。'},
		{MARISA,'awkward','而且没走多远就被烦人的家伙袭击了，真是糟糕的开端啊。'},
	    {MARISA,'ease','这也应该计入神社人气底的原因'}
	},
	[2+100]={
	    {VALEN,'shock','哎呀呀，又一个没有睡着的人类。'},
		{MARISA,'scorn','就算到了这种时候，妖精还是一副无忧无虑的样子呢。'},
		{VALEN,'question','这种时候？……是指因为人们的梦能够到达现实来吗？'},
		{MARISA,'normal3','没想到妖精会清楚这种事情，\n你难道就没有由于异变的原因烧掉房子什么的吗？'},
		{VALEN,'normal','怎么会，明明这异变这么有意思！'},
		{VALEN,'happy','梦多么的美妙啊，人们的梦往往会带来惊喜呢。'},
		{MARISA,'say1','呵，除了‘惊喜’，更多的应该是‘惊吓’才对。'},
		{MARISA,'say1','算了，说不定妖精也分不清这些。'}
	},
	[3+100]={
		{QUAD,'normal','咦？又出现了不一般的人类？'},
		{MARISA,'confused','谁？'},
		{MARISA,'say2','少见的组合，妖怪竟然和妖精联手了。'},
		{MARISA,'say1','这样一来，遭到袭击的真相就浮出了水面。'},
		{QUAD,'annoyed2','没想到会频频失手，\n是时候展现我们联合起来的力量了！'},
		{VALEN,'happy','是呀是呀，\n我们来看看戴尖帽子的人做的梦会是什么样子吧！'},
		{MARISA,'awkward','被无视了……'},
		{MARISA,'ease','不过如此听来是麻烦的组合没错了，顺手解决掉吧。'}
	},
	[4+100]={
		{VALEN,'lose','输掉了……'},
		{QUAD,'failed2','明明就是个人类啊，难道戴尖帽子的就不一般吗！'},
		{MARISA,'normal3','原来如此，一个将人吸引过来，再由另一个进行催眠。'},
		{MARISA,'normal3','果然不是什么友好的家伙，在现在的异变下会制造大麻烦呢。'}--[[,
		{MARISA,'ease','没想到这么快就已经有这种没心没肺的妖怪和没心没肺的妖精在利用这场没心没肺的异变闹出没心没肺的事了，真是笨蛋和笨蛋组成的笨蛋组合。'}--]]
	}
}

return _tmp_char_info,_tmp_dialog