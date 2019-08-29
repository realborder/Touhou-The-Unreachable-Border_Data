
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
		{HALLU,'laugh','Shrine maiden over there, I\'ve been waiting for you.'},
		{REIMU,'confused2','Huh? Who are you?'},
		{REIMU,'selfconfidence2','A youkai actively waiting here to be beat up?'},
	},
	[2]={
		{HALLU,'smile','My name is Hallusehyen, a god here to assist you.'},
		{REIMU,'scorn','God? From what I can see, there\'s no aura of a good at all. On the other hand, the aura of a youkai is abnormally evident.'},
		{REIMU,'selfconfidence1','If you\'re going to impersonate a god, don\'t do it in front of a shrine maiden.'},
		{HALLU,'taught1','As a shrine maiden who serves gods, you don\'t have the aura of a shrine maiden either.'},
		{REIMU,'speechless1','......'},
		{HALLU,'smile','You probably can\'t make heads or tails of this incident right now, correct?'},
		{HALLU,'smile','Relying completely on impulsively barging around will never allow you to grasp the core of this incident.'},
		{REIMU,'laugh3','Dreams are intangible, it\'s like trying to find a spirit in the air.'},
		{REIMU,'laugh3','So an incident having to do with dreams like this, no matter what I can\'t trace it.'},
		{HALLU,'smile','What about giving up on dreams and reality, and viewing this incident from an outside point of view?'},
		{HALLU,'saying1','Someone who is inside a forest or mountain cannot see what the forest or mountain looks like. Once you\'ve given up the two, can you not completely grasp the incident?'},
		{HALLU,'saying2','Currently, Gensokyo\'s dreams and realities have become entangled, like the vines in this forest.'},
		{HALLU,'taught2','And the quickest way to solve these vines, is to free yourself of them, then use a scorching flame to burn them to cinders.'},
		{REIMU,'pissedoff2','...hmph, sounds like the wicked methods a youkai would speak of.'},
		{REIMU,'pissedoff3','Don\'t think I\'ll believe your wicked words.'},
		{HALLU,'taught1','Up to you whether to believe me or not, I\'m just doing my job.'},
		{HALLU,'unholdable','No matter what, to fully resolve this incident, you\'ll have to rely on my power to shatter the two.'},
		{HALLU,'taught2','But looks like the Hakurei Shrine Maiden trapped in this tiny world is just that.'},
		{HALLU,'taught1','You, with the ability to fly through the skies, can\'t even tell if the sky in front of you is real or not.'},
		{REIMU,'rage','What are you saying?'},
		},
	[3]={
		{HALLU,'taught2','Do you know? Your so-called instincts and senses have been tricking you all along.'},
		{HALLU,'taught1','Precisely because Gensokyo has separated you from reality, and has caused you to fly through this illusionary sky.'},
		{REIMU,'rage','Blasphemous youkai, I\'ll have to exterminate you!'},
		{HALLU,'unholdable','Perfect, I shall shatter the false sky in front of you, and let you see the real world!'},
		--{REIMU,'smile','The sky shall shatter in from of you!'},
		},
	[4]={
		{HALLU,'faiil','How stubborn, I can\'t correct you no matter what.'},
		{REIMU,'pissedoff1','Dangerous youkai almost confounded me, good thing I took care of her in time.'},
		{REIMU,'ease3','What should I do now? I can\'t make heads or tails of this incident, what a headache.'},
	},
	[100+1]={
		{HALLU,'smile','No need to rush, everything related to the incident will settle down soon.'},
		{MARISA,'confused2','Who is it?'},
		{HALLU,'laugh','A divine spirit here to assist you.'},
		{MARISA,'confused','Divine spirit? I haven\'t heard of there being any divine spirits around here.'},
		{HALLU,'saying2','Since you\'re not a shrine maiden, how did you discover me so easily?'},
		{HALLU,'smile','I only appeared after I saw you get into a difficult situation.'},
		{MARISA,'mad','Heheh, if you\'re a youkai then show your true form now, don\'t pretend to be a god.'}
			},
	[100+2]={
		{HALLU,'saying2','It\'s a misunderstanding, I am Hallusehyen, a divine spirit born from the power of this incident.'},
		{HALLU,'saying1','By relying on my power, you can easily resolve this incident.'},
		{MARISA,'normal3','Easily resolve the incident? Who\'s going to believe your alluring speech?'},
		{MARISA,'normal3','An incident that has caused me so much trouble, yet you use such a light tone to say the three words "resolve this incident"?'},
		{HALLU,'laugh','Yes, no problem, as lonog as you draw on my power.'},
		{MARISA,'say1','Let\'s hear it.'},
		{HALLU,'saying1','Dreams and reality are like the worlds inside and outside a mirror.'},
		{HALLU,'saying2','If the world outside the mirror changes slightly, then the world in the mirror will instantly change in a corresponding way.'},
		{HALLU,'normal','But no matter how much the world in the mirror changes, the world outside the mirror will not be affected.'},
		{MARISA,'say2','Uh...sounds reasonable. Then?'},
		{HALLU,'saying1','But now the worlds outside and inside the mirror have been reversed, so everything I described before has been reversed.'},
		{HALLU,'saying2','From this, the dreams outside the mirror can easily change the reality in the mirror.'},
		{HALLU,'smile','Someone must have deliberately reversed the two in this incident.'},
		{MARISA,'normal3','...'},
		{MARISA,'say1','So, there is a suspect that has an ability like this.'},
		{MARISA,'say2','But how do we resolve the current happenings?'},
		{HALLU,'unholdable','If we just shatter the mirror, then the whole idea of inside and outside the mirror will vanish, thus settling the incident.'},
		{HALLU,'taught1','Then we have a chance of finding the mastermind.'},
		{MARISA,'say1','Although this sounds like a pretty good method, I still feel a bit...'},
		{HALLU,'laugh','No problem.'},
		{MARISA,'mad','I just though of a problem, are you trying to take advantage of me to do something for you?'},
		{HALLU,'smile','How would I, I\'m also a victim of this incident.'},
		{MARISA,'mad','Victim? Just now you said you obtained power from the incident, now you\'re a victim.'},
		{MARISA,'mad','You\'ve revealed your own lies.'},
		{MARISA,'mad','From the beginning you\'ve been guiding me towards your solution.'},
		{MARISA,'mad','Good thing I exposed you, or else I can\'t imagine what we would face after falling into a youkai\'s evil trap.'}
	},
	[100+3]={
		{HALLU,'unholdable','Magic cannot leave the mana-infused soil!'},
		{HALLU,'taught2','But the earth you stand on now, does it really have magic?'},
		{HALLU,'taught1','Perhaps those treas, shrubs, weeds, mushrooms, and mosses hide a completely meaningless piece of land?'},
		{HALLU,'unholdable','More barren than a desert, more barren than the moon!'},
		{MARISA,'mad','What are you saying? This forest is obviously in front of our eyes, yet you reject its existence?'},
		{HALLU,'taught1','Is it real because you see it? At least I don\'t believe that.'},
		{HALLU,'taught2','Perhaps you should set down all your preconceptions and reevaluate this piece of land.'},
		{MARISA,'mad','An idiotic youkai, after seeing herself exposed, has begun to blabbering nonsense. I\'ll have to teach her a lesson.'}
			},
	[100+4]={
		--{HALLU,'smile','Look! What has been numbed in your heart?'},
		--{HALLU,'smile','Yesterday you were still racking your brain over this barren soil!'},
		{MARISA,'ease','So those people I encountered on the way were all illusions caused by her.'},
		{MARISA,'ease','A fearsome youkai capable of causing hallucinations in people.'},
		{HALLU,'faiil','You destroyed the road to resolving the incident with your bare hands.'},
		{HALLU,'faiil','From now on, you\'ll be in a desperate situation.'},
		{MARISA,'scorn','Still trying to talk your way out?'},
		{MARISA,'normal3','But the mirror reversal she mentioned earlier...'},
		{MARISA,'smile','is an important clue.'}
		
	},


}

return _tmp_char_info,_tmp_dialog