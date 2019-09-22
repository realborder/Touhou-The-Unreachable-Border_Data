
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
		{REIMU,'speechless1','Ugh, so much trouble just after stepping out the door. I kind of want to go back to the shrine and rest already.'},
		{REIMU,'normal3','You there just now, come out.'}
	},
	[2]={	
		{VALEN,'shock','You didn\'t fall asleep, how...'},
		{REIMU,'smile1','Trying to make me fall asleep with only this ability? I\'m not that weak to let youkai hypnotize me.'},
		{VALEN,'question','Impossible, impossible, impossible! It worked every time before!'},
		{VALEN,'normal','You should have fallen into a deep sleep like those people who came before, and then...'},
		{VALEN,'happy','A wondrous dreamland would be born!'},
		{REIMU,'say2','...already, there are fairies using this incident to play pranks...I\'ll have to set them straight.'},
		{REIMU,'pissedoff1','an ability like this isn\'t much usually, but in this situation it becomes pretty dangerous.'},
		{REIMU,'smile1','Also, that sound to draw people into the forest doesn\'t seem like something you can do. Looks like you have another accomplice.'},
		{VALEN,'question','Eh? How did you find out I have a companion?'},
		{REIMU,'smile3','Since there is one, then come out!'}
	},
	[3]={
		{QUAD,'normal','Is this also a human that\'s been drawn in? How come she isn\'t asleep?'},
		{REIMU,'ease3','What? It\'s just a bird youkai. As I thought, the youkai that can cooperate with fairies can\'t be that strong.'},
		{REIMU,'laugh1','I was hoping I could meet someone interesting.'},
		{QUAD,'annoyed','Hey hey, don\'t look down on me!'},
		{QUAD,'annoyed2','But you don\'t look like you\'re someone who\'s easy to beat.'},
		{VALEN,'normal','Yeah, even I couldn\'t make her fall asleep.'},
		{REIMU,'laugh1','Perfect, you\'ve both revealed your identity, so I don\'t have to go investigate myself.'},
		{REIMU,'smile1','Then, obediently accept the extermination of the Hakurei Shrine Maiden!'},
		{QUAD,'annoyed2','Then, you obediently slumber in this forest!'},
		{VALEN,'happy','That would let me see what your dreams would look like.'}
	},
	[4]={
		{QUAD,'failed','Owwww...'},
		{QUAD,'failed2','Could you be a shrine maiden?'},
		{REIMU,'smile1','You just noticed now?'},
		{REIMU,'smile3','You better explain everything to me in detail.'},
		{QUAD,'failed3','It seems recently regardless of human or youkai, any dreams they have will become reality.'},
		{VALEN,'lose','Dreams becoming reality really has nothing to do with us!!'},
		{QUAD,'failed3','So I drew in people traveling by, then made her put them to sleep.'},
		{VALEN,'lose_happy','Before, someone made a lot of butterflies!'},
		{VALEN,'lose_happy','But there were also people with frightening and exciting dreams.'},
		{VALEN,'lose_happy','But it was still a lot of fun.'},
		{REIMU,'ease1','Hm, what unrepentant folk.'}
	},
	[1+100]={
		{MARISA,'awkward','The path to the human village is hard to travel as always.'},
		{MARISA,'awkward','And I was attacked by annoying people before even going far, what a troubling start.'},
	    {MARISA,'ease','This is probably another reason why the shrine isn\'t popular.'}
	},
	[2+100]={
	    {VALEN,'shock','Aiyaya, another human that isn\'t sleeping.'},
		{MARISA,'scorn','Even at this time, the fairies still look so carefree.'},
		{VALEN,'question','At this time? Do you mean people\'s dreams being able to become reality?'},
		{MARISA,'normal3','I didn\'t think fairies would know about this, you haven\'t burned your house down due to the incident?'},
		{VALEN,'normal','Why would we, this incident is so interesting!'},
		{VALEN,'happy','Ah, dreams are so wonderful, dreams always bring surprises.'},
		{MARISA,'say1','Heh, besides "surprises", there\'s probably even more "scares".'},
		{MARISA,'say1','Whatever, fairies probably can\'t tell the difference between the two anyways.'}
	},
	[3+100]={
		{QUAD,'normal','Hmm? Another unusual human appeared?'},
		{MARISA,'confused','Who?'},
		{MARISA,'say2','A rare combination, a youkai joining forces with a fairy.'},
		{MARISA,'say1','Here, the truth about me being attacked will become clear.'},
		{QUAD,'annoyed2','I didn\'t think I would fail so frequently, it\'s time for us to show our combined power!'},
		{VALEN,'happy','Yes yes, let\'s see what dreams the human with a pointy hat will dream!'},
		{MARISA,'awkward','I\'ve been ignored...'},
		{MARISA,'ease','But this seems like an annoying team, I\'ll take care of them along the way.'}
	},
	[4+100]={
		{VALEN,'lose','we lost...'},
		{QUAD,'failed2','But she was human! Could it be the ones that wear pointy hats are special?'},
		{MARISA,'normal3','I see, one draws people in, the other one hypnotizes.'},
		{MARISA,'normal3','Definitely not friendly folks, it would cause big trouble in this incident.'}--[[,
		{MARISA,'ease','I didn\'t think it would be this quick before the dimwitted youkai and the dimwitted fairies took advantage of this dimwitted incident to cause dimwitted trouble. What an idiotic team of idiot and idiot.'}--]]
	}
}

return _tmp_char_info,_tmp_dialog