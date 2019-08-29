
local L,R='left','right'
--角色名用变量代替
local REIMU='reimu'
local MARISA='marisa'

local MIO='Boss2'
local _tmp_char_info={
	--角色定义，包括：
	--pos 角色通常处于那一策，用L或R指代
	--emolist 角色表情信息列表
		--键值必须是string类型，指代表情类型，同时也是图片和文件名的一部分
		--表项的值是角色表情对应的气泡索引
	[MIO]={pos=R,emolist={
		['annoy1']=1,
		['annoy2']=1,
		['failed1']=1,
		['failed2']=1,
		['failed3']=1,
		['inflation1']=1,
		['inflation2']=1,
		['inflation3']=1,
		['normal']=1,
		['say']=1,
		['taunt']=1
		}
	}
}

--对话内容，如此一来写对话可完全简化为角色，表情和文字三项
local _tmp_dialog={
	--1代表第一个对话块
	--角色，表情，对话文字，对话气泡停留时长（帧）可不填
	[1]={
		{REIMU,'speechless2','Who would\'ve thought the human village would have such an ostentatious youkai riot.'},
		{REIMU,'pissedoff1','These annoying people are probably taking advantage of the situation, and want to envelop the village in fear during the incident.'},
		{REIMU,'confused1','Who is it?'}
	},
	[2]={
		{REIMU,'confused2','Everyone should have already dispersed from this dangerous area, who are you?'}
	},
	[3]={		
	    {MIO,'annoy1','I am Tokimatsu Mio.'},
		{MIO,'annoy1','Looking at your outfit, you\'re the Hakurei Shrine\'s shrine maiden?'},
		{REIMU,'pissedoff1','Of course, but you appearing alone in such a place is very suspicious activity indeed.'},
		{REIMU,'pissedoff1','Shouldn\'t you go to a safe area to take shelter?'},
		{MIO,'annoy2','Only cowards would do that.'},
		{MIO,'inflation2','We are people resolving the youkai disturbance.'},
		{REIMU,'confused1','We? Are you some sort of special person?'},
		{MIO,'inflation3','Not far, and I don\'t simply want to just resolve the incident.'},
		{MIO,'inflation3','I want to liberate humans from the reign of the youkai!'},
		{REIMU,'laugh3','What are you saying? What a preposterous thought!'},
		{MIO,'inflation1','Originally I was like most of the people in the village, just an ordinary person.'},
		{MIO,'inflation2','But thanks to this incident, I acquired from my dreams a powerful ability -- the power to dissolve the fear in my heart'},
		{MIO,'inflation2','Once I threw off the chains of fear, I saw how wretched humans in Gensokyo were`.'},
		{MIO,'inflation2','People living under the rule of youkai, have no hope to speak of.'},
		{MIO,'inflation2','I tried to learn the secret art of exterminating youkai, and have mastered parts of it.'},
		{MIO,'inflation3','So now, I have the resources to resist the youkai.'},
		{MIO,'inflation3','If the humans in the village gathered, and a master passed to them the secret art of exterminating youkai,'},
		{MIO,'inflation3','then the village would have the means of overthrowing youkai rule.'},
		{REIMU,'speechless1','......'},
		{REIMU,'scorn','Hmph, what a naïve and dangerous way of thinking.'},
		{REIMU,'scorn','You\'ve only learned the basics, it\'s still a big question whether you could survive in front of a youkai.'},
		{REIMU,'yaowei','And talking big about revolting against the youkai, is just due to your ability to not fear.'},
		{REIMU,'selfconfidence1','Then, from your dreams...'}
	},
	[4]={		
		{MIO,'annoy2','Forget it, no one will believe me.'},
		{MIO,'annoy1','Everyone is tied down by fear, even the Hakurei Shrine Maiden.'},
		{MIO,'inflation3','How about we use the spell card rules to have a duel, and see who truly stands on the side of reason?'},
		{REIMU,'scorn','A duel with me? Are you serious?'},
		{MIO,'taunt','Under the spell card rules, even if there is a large power difference between us, I still have a chance to win.'},
		{REIMU,'yaowei','Since you\'ve already thought it all out, I\'ll gladly oblige.'}
	},
	[5]={		
		{MIO,'failed1','Ah...'},
		{REIMU,'selfconfidence2','What is it, can you still continue?'},
		{MIO,'failed3','I\'ve already fallen...I didn\'t think you would be this serious.'},
		{REIMU,'selfconfidence1','The injury is a bit serious, were my attacks a bit too strong?'},
		{REIMU,'smile1','Whatever, just stay at home and heal before the incident is resolved.'},
		{MIO,'failed2','Looks like my skill is not yet up to par, the next time I challenge you I won\'t lose this badly.'},
		{REIMU,'speechless2','You still want to challenge me?'},
		{REIMU,'selfconfidence2','If you ran into a youkai instead of me you would already be dead.'},
		{REIMU,'say1','One more thing, where did you get your power?'},
		{MIO,'failed3','From a dream.'},
		{REIMU,'say3','I know that, what kind of dream?'},
		{MIO,'failed2','It was a wondrous dream, there were unexplored mountains, and...'},
		{MIO,'failed3','I forgot the rest, the dream wasn\'t very clear.'},
		{REIMU,'smile2','I could only get this little bit of information, huh?'}
	},
	[100+1]={
		{MARISA,'say2','Phew, the safety work in the human village is not bad.'}
		},
	[100+2]={
		{MIO,'inflation1','You over there, are you a brave warrior also staying behind to guard this place?'},
		{MARISA,'say3','Brave warrior? I guess you could say that for now.'},
		{MIO,'inflation3','Haha, I knew there would be people like me.'}
		},
	[100+3]={
		{MIO,'normal','My name is Tokimatsu Mio.'},
		{MIO,'normal','Those cowards have all receded to the safe area.'},
		{MIO,'taunt','No one thought of whether these abandoned places would be taken by the youkai.'},
		{MARISA,'say2','So you don\'t fear youkai?'},
		{MIO,'taunt','How would I, the fear youkai gave me has already dissolved into mist.'},
		{MIO,'inflation3','I am a person without fear.'},
		{MARISA,'say2','No fear...is that not very dangerous?'},
		{MIO,'say','Dangerous? Why so?'},
		{MIO,'inflation2','Without fair, I can lead people in resistance against the youkai.'},
		{MARISA,'confused2','Humans and youkai battling?'},
		{MARISA,'ease','Who would do something idiotic like that, no matter how you put it it\'d be a road to death.'},
		{MARISA,'say1','Even if the humans\' power were all gathered, they still wouldn\'t be able to fight the youkai.'},
		{MIO,'taunt','Tch, the only reason you think that is because of the fear in your heart.'},
		{MIO,'taunt','Since you\'re able to come to these dangerous parts of the village during an incident, looks like you aren\'t an ordinary one either.'}
		},
	[100+4]={
		{MIO,'inflation3','I\'ll let you see the power of a human who can cast away fear!'},
		{MARISA,'normal1','First time seeing a human that likes to fight so much, how interesting.'},
		{MARISA,'laugh','Then I\'ll have to oblige.'}
		},
	[100+5]={
		{MIO,'failed1','How strong, obviously not an ordinary person. You relied on your own power to weaken your fear.'},
		{MARISA,'normal3','So I said, you can\'t even beat me, speak nothing of those powerful youkai.'},
		{MARISA,'say1','Relying only on having no fear, you\'re no match for powerful youkai.'},
		{MIO,'failed3','Even though you say that, but my goal will not be swayed.'},
		{MIO,'failed3','The weakness of humans is due to their fear for youkai.'},
		{MIO,'failed3','Hiding in their tiny land and praying for safety, those people have no way of becoming powerful.'},
		{MIO,'failed3','They can only live in fear of the youkai.'},
		{MIO,'failed3','This negative cycle needs to be broken by someone.'},
		{MARISA,'awkward','What a scary way of thinking, this really is a fearless person.'},
		{MARISA,'normal3','If you were to really team up and fight the youkai, the whole village might even get wiped out.'},
		{MIO,'failed2','Say, you\'re so powerful, do you feel the same way?'},
		{MARISA,'say1','I don\'t have the leisure to put in all that work.'},
		{MARISA,'say1','Plus I don\'t even have a place to stay right now.'},
		{MIO,'failed2','You can live at my place!'},
		{MARISA,'mad','Compared to living in this creepy place, I\'d rather guard the shrine for another night.'}
		
	}
	

}

return _tmp_char_info,_tmp_dialog