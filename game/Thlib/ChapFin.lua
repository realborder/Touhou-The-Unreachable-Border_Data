	LoadImageFromFile('chapFin','THlib\\chapFin.png')
--用于结算点的obj，奖励chapter分数，结算残机和符卡，以及重置计数
ChapFin=Class(object)
function ChapFin:init(isInboss)
	self.x=0
	self.y=75
	self.img='chapFin'
	self.layer=LAYER_TOP
	self.group=GROUP_GHOST
	self.hscale=2
	self.vscale=2
	self.hide=false
	self.bound=false
	self.colli=false
	self.flag=isInboss
	if self.flag then self.hide=true end
end

function ChapFin:frame()
	if ext.sc_pr then RawDel(self) return end --如果在符卡练习那就跳过，我知道这种写法很蠢，但是要去每张卡下面改太麻烦了
	if self.timer==40 then
		-- DR_Pin.reset()
		tuolib.DRP_Sys.reset()
		
		--残机结算
		if lstg.var.chip>=100 and not self.flag then
			lstg.var.lifeleft=min(11,lstg.var.lifeleft+int(lstg.var.chip/100))
			lstg.var.chip=lstg.var.chip%100
			PlaySound('extend',0.5)
			-----【动画实装】
			exani_player_manager.ExecuteExaniPredefine(play_manager,'Life_Extend','init') 
			-- if not explrmgr_gl then
				-- exani_player_manager.SetExaniAttribute(play_manager,'Life_Extend',1,114,LAYER_TOP,'world',1,1,false) 
				-- explrmgr_gl=true 
			-- end
			-- New(hinter,'hint.extend',0.6,0,112,15,120)
		end
		--符卡结算
		if lstg.var.bombchip>=100 and not self.flag then
			local forw_card=lstg.var.bomb
			lstg.var.bomb=min(3,lstg.var.bomb+int(lstg.var.bombchip/100))
			if lstg.var.bomb==3 then lstg.var.bombchip=0
			else lstg.var.bombchip=lstg.var.bombchip%100 end
			if forw_card<lstg.var.bomb then
				PlaySound('cardget',0.8)
				-----【动画实装】
				exani_player_manager.ExecuteExaniPredefine(play_manager,'Spell_Restored','init') 
				-- if not explrmgr_gc then
					-- exani_player_manager.SetExaniAttribute(play_manager,'Spell_Restored',1,114,LAYER_TOP,'world',1,1,false) 
					-- explrmgr_gc=true 
				-- end
			end
		end 
	end
	if self.timer==1 and not self.flag then 
		-----【动画实装】
		if not self.flag then ClearAllEnemyAndBullet() end --击破boss一个阶段自带消弹了
		exani_player_manager.ExecuteExaniPredefine(play_manager,'ChapterFinished','init') 
		-- if not explrmgr_chapfin then
			-- exani_player_manager.SetExaniAttribute(play_manager,'ChapterFinished',1,66,LAYER_TOP,'world',1,1,false) 
			-- explrmgr_chapfin=true 
		-- end
	end
	if self.timer==120 then Del(self) end
end

function ChapFin:render()
	-- if self.timer<=30 then
		-- self.hscale=self.hscale-1/30
		-- self.vscale=self.vscale-1/30
		-- SetImageState('chapFin','',Color((self.timer*255/30),255,255,255))
	-- end
	-- if self.timer>=90 and self.timer<120 then
		-- SetImageState('chapFin','',Color(((120-self.timer)*255/30),255,255,255))
	-- end
	-- Render('chapFin',self.x,self.y,0,self.hscale)
end

function ClearAllEnemyAndBullet()
	for _,unit in ObjList(GROUP_ENEMY) do
		if not unit._bosssys then --靠有无挂载boss系统来判断是不是boss
			unit.drop=false
			Kill(unit)
		end
	end
	for _,unit in ObjList(GROUP_ENEMY_BULLET) do
		Del(unit)
	end
end