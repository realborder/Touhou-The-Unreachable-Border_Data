LoadImageFromFile('UI_gaming_item_collect_word','THlib\\UI\\UI_gaming_item_collect_word.png')
LoadImageFromFile('UI_gaming_item_collect_line','THlib\\UI\\UI_gaming_item_collect_line.png')
LoadTTF('sc_card','THlib\\UI\\ttf\\ysszt.ttf',40)

DR_Pin=Class(object)
function DR_Pin:init()
	local var=lstg.var
	local tmpv=lstg.tmpvar
	self.group=GROUP_GHOST
	self.layer=LAYER_TOP
	self.x=0
	self.y=0
	if not var.dr then var.dr=0.01 end--梦(dream)现(reality)指针值
	var.cp=0.0--combo_point 连击点数，用来控制dr的减少
	tmpv.bonus_count=0
	C_BOUNS_LIMIT_IN_CHAPTER=2500
	K_dr=0.003--用于控制dr的增长，每个chapter可能都要微调，所以记在lstg.var里了
	

	K_dr_ccced=1.0 --释放灵击时梦现指针的增加量
	K_dr_item=1.0  --遗漏道具梦现指针变化系数
	K_dr_enemy=1.0 --遗漏敌机梦现指针变化系数
	K_graze_c_max=125 --擦弹计数上限
	K_graze_c_min=50 --擦弹计数下限
	K_dr_graze_c=0.2  --擦弹系数
	K_graze_c_k=(-0.75)/(K_graze_c_max - K_graze_c_min) --释放灵击POWWER减少比例
	K_dr_collectline=22.4 --梦现指针指向现实侧时收点线降低系数
	K_dr_dist=0.2 --梦现指针指向现实侧时道具吸收范围变大系数
	K_dr_SpellDmg=0.02 --梦现指针对符卡伤害影响系数
	K_dr_SlowSpell=1.25 + K_dr_SpellDmg*var.dr --低速符卡伤害
	K_dr_HighSpell=1.0 + K_dr_SpellDmg*var.dr --高速符卡伤害
	K_dr_BonusLimit=1.0 --获得奖残奖雷所需的最低指针绝对值
	
	K_MaxSpell=60 --符卡槽耐久最大值基础值
	K_dr_SpellHp=3 --梦现指针对符卡槽耐久最大值的影响系数
	K_SpellCost=20 --单次符卡攻击消耗的符卡槽耐久
	K_SpellDecay=0.1 --每帧符卡槽耐久衰减系数
	
	K_BossSpeedKill=1 --Boss速破奖励系数
	
	K_cp=0.2
	K_dr_reduce=0.002
	
	self.collectline_a=255 --收点线α值
	self.k_a=(255-100)/(K_dr_collectline*5) --α值改变系数
	self.collectline_y=112
	self.collectline_dy=112
	
	end
function DR_Pin.add(v)--增加连击点数，连击点数的增加会让梦现指针往当前方向偏
	local var=lstg.var
	v = abs(v)
	var.cp = var.cp + v * K_cp
	 if (abs(var.dr)<=5.0 - v * K_dr) then 
		var.dr =  ( abs(var.dr) + v * K_dr ) * sign(var.dr)
	 else
		var.dr = sign(var.dr) * 5.0
	 end --控制dr的增长体现在这里
end
function DR_Pin.reduce(v)
	local var=lstg.var
	var.dr=max(0.01,abs(var.dr)-v)*sign(var.dr)
end
function DR_Pin.reset()--关卡结算点固定会调用的函数
	local var=lstg.var
	local tmpv=lstg.tmpvar
	lstg.var.cp=1.0--重置连击点数
	lstg.tmpvar.bonus_count=0--重置奖残奖雷计数！！！！！

	if not var.spelled_in_chapter and not var.ccced_in_chapter then--一心一意想扭的人是会把x键抠掉的，所以即使单chapterMiss了也给一定偏移
		DR_Pin.pin_shift(-0.15)
		if not var.missed_in_chapter then DR_Pin.pin_shift(-0.8) end
	end
	var.missed_in_chapter=false
	var.spelled_in_chapter=false
	var.ccced_in_chapter=false
end
function DR_Pin.pin_shift(v)
	local var=lstg.var
	if abs(var.dr+v)<=5.0 then
		var.dr = var.dr + v
	else
		var.dr=sign(var.dr)*5.0
	end
end
function DR_Pin:frame() 
	local var=lstg.var
	local tmpv=lstg.tmpvar
	tmpv.bonus_rate=0--这个是具体的奖残奖雷量
	
	if not player.dialog then
		--这段是cp减少的代码
		if (var.cp <=15.0 and var.cp>5.0) then
			var.cp = var.cp-0.2
		elseif (var.cp <= 5.0 and var.cp>1.8) then
			var.cp = var.cp-0.04
		elseif (var.cp <=1.8 and var.cp>=0.008) then
			var.cp = var.cp-0.008--经历125帧cp归零
		else
			var.cp = 0.0
		end
		local drReduce=K_dr_reduce
		if IsValid(_boss) then drReduce=K_dr_reduce/2 else drReduce=K_dr_reduce end
		if (var.cp<=1 and abs(var.dr)>1-	(1-var.cp) * drReduce) then--combo_point小于1且dr大于1的情况下d才会渐渐减小，且越接近1减少越慢
			var.dr = (abs(var.dr)-			(1-var.cp) * drReduce) * sign(var.dr)
		end --ddr为0时，dr减的最快
		
		--这段是给资源的代码
		--设置了单章节最大资源计数值，实际的上限会随着指针而改变
		if abs(var.dr) >= K_dr_BonusLimit then
			tmpv.bonus_count=tmpv.bonus_count+(abs(var.dr)-K_dr_BonusLimit)--指针绝对值多出奖残奖雷阈值的部分会直接加到这个计数变量里
			--具体奖励数量在(2,4)这个区间内分布，偏梦境侧则大于3，偏现实侧则小于3，具体偏移量由指针值定。
			--在此基础上乘一个系数用来控制增长，系数是这个：
			--( C_BOUNS_LIMIT_IN_CHAPTER   -   tmpv.bonus_count )   /   C_BOUNS_LIMIT_IN_CHAPTER
			--也就是一个[0,1]内的系数，bonus_count越高这个系数越小，到最后几乎为0
			--下一行代码很长……但是思路列在上面应该能看明白
			if tmpv.bonus_count>C_BOUNS_LIMIT_IN_CHAPTER then tmpv.bonus_count=C_BOUNS_LIMIT_IN_CHAPTER end
			tmpv.bonus_rate = (  3.0 + sign(var.dr)*  (abs(var.dr)-K_dr_BonusLimit)/(5 - K_dr_BonusLimit) )* (C_BOUNS_LIMIT_IN_CHAPTER-tmpv.bonus_count)/C_BOUNS_LIMIT_IN_CHAPTER
			
			var.chip = var.chip + tmpv.bonus_rate 			* 0.01 	*(1 + min(0,sign(var.dr))* -1.5)
			var.bombchip = var.bombchip + tmpv.bonus_rate 	* 0.01 	*(1 + max(0,sign(var.dr))*0.5)
																	--这一段，若偏向现实侧则残机奖励会2.5倍，若偏向梦境侧则符卡奖励多1.5倍
		end
		--这段是加灵力的代码
		if abs(var.dr) >= 1.0 then
			DR_Pin.GetPower(min((abs(var.dr)-1.0),2.0) * (-2 + sign(var.dr)) / -10 * 0.25) 
		end
	end
end
function DR_Pin:render() --左下角字体渲染
	local var=lstg.var
	local x,y=-182,-204
	-- SetImageState('white','',Color(255,255*0.75+var.dr*0.05,125,255*7/8-var.dr*0.025))
	-- RenderText('bonus','Pin_of_dream&reality:'..var.dr,x,y,0.35,8)
	-- RenderRect('white',x+25,x+25+var.dr*5,y-12,y-10)
	-- SetImageState('white','',Color(255,255,255,255))
	-- RenderText('bonus','combo_point:'..var.cp,x,y+20,0.35,8)
	-- RenderRect('white',x,x+var.cp,y+8,y+10)
	-- RenderText('bonus','graze_count:'..player.graze_c,x,y+40,0.35,16)
	-- RenderRect('white',x,x+player.graze_c,y+28,y+30)
	
	-- RenderText('bonus','SpellCard:'..player.SpellCardHp,x,y+60,0.35,8) --符卡槽
	-- RenderRect('white',x,x+player.SpellCardHp,y+48,y+50)
	
	--------收点线文字
	if self.timer<60 and self.timer%20==0 then 
		SetImageState('UI_gaming_item_collect_word','',Color(255,255,255,255))
	elseif self.timer<60 and (self.timer+10)%20==0 then 
		SetImageState('UI_gaming_item_collect_word','',Color(155,255,255,255))
	elseif self.timer>=60 and self.timer<=120 then
		SetImageState('UI_gaming_item_collect_word','',Color(255-int((self.timer-60)/60*255),255,255,255))
		Render('UI_gaming_item_collect_word',0,player.collect_line+22) 
	end
	--------------------收点线只要有变动就会往不透明变，否则慢慢变回透明
	local y=min(112,player.collect_line+lstg.var.dr*K_dr_collectline)
	self.collectline_y = self.collectline_y + (y - self.collectline_y)*0.25--平滑处理
	self.collectline_a=max(20,min(200,self.collectline_a	-3	+abs(self.collectline_dy-self.collectline_y)*100)) --alpha限制在20到200
	self.collectline_dy=self.collectline_y
	SetImageState('UI_gaming_item_collect_line','',Color(self.collectline_a,255,255,255))
	Render('UI_gaming_item_collect_line',0,self.collectline_y)
	
	-------------
	-- if self.timer<600 then Render('UI_gaming_item_collect_word',0,player.collect_line+22) end
	-- if lstg.var.dr<0 then
	    -- local a=255-(self.k_a*abs(lstg.var.dr)*K_dr_collectline)
		-- local y=player.collect_line-abs(lstg.var.dr)*K_dr_collectline
		-- if self.collectline_a>a then self.collectline_a=max(self.collectline_a-1,a)
		-- else self.collectline_a=min(self.collectline_a+1,a) end
		-- if self.collectline_y>y then self.collectline_y=max(self.collectline_y-0.5,y)
		-- else self.collectline_y=min(self.collectline_y+0.5,y) end
		-- SetImageState('UI_gaming_item_collect_line','',Color(self.collectline_a,255,255,255))
		-- Render('UI_gaming_item_collect_line',0,self.collectline_y)
	-- else
	    -- if self.collectline_a==255 and self.collectline_y==player.collect_line then
		    -- Render('UI_gaming_item_collect_line',0,player.collect_line)
		-- else
		    -- if self.collectline_a~=255 then self.collectline_a=min(self.collectline_a+1,255) end
			-- if self.collectline_y~=player.collect_line then self.collectline_y=min(self.collectline_y+0.5,player.collect_line) end
			-- SetImageState('UI_gaming_item_collect_line','',Color(self.collectline_a,255,255,255))
			-- Render('UI_gaming_item_collect_line',0,self.collectline_y)
		-- end
	-- end
	
	if player.SC_name~='' then
		SetImageState('boss_spell_name_bg','',Color(255,255,255,255))
	    if player.SpellTimer1<=90 then
            Render('boss_spell_name_bg',-51,-100-player.SpellTimer1,0,1.5)
            RenderTTF('sc_card',player.SC_name,-80,-80,-110-player.SpellTimer1,-110-player.SpellTimer1,Color(255,0,0,0),'right','noclip')
            RenderTTF('sc_card',player.SC_name,-81,-81,-109-player.SpellTimer1,-109-player.SpellTimer1,Color(255,255,255,255),'right','noclip')
		else
			Render('boss_spell_name_bg',-51,-190,0,1.5)
            RenderTTF('sc_card',player.SC_name,-80,-80,-200,-200,Color(255,0,0,0),'right','noclip')
            RenderTTF('sc_card',player.SC_name,-81,-81,-199,-199,Color(255,255,255,255),'right','noclip')
		end
	end
end

function DR_Pin.GetPower(v)
	local before=int(lstg.var.power/100)
	lstg.var.power=min(player.maxPower,lstg.var.power+v)
	local after=int(lstg.var.power/100)
	if after>before then PlaySound('powerup1',0.5) end
end