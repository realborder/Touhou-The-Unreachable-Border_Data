LoadImageFromFile('chapFin','THlib\\chapFin.png')
--用于结算点的obj，奖励chapter分数，结算残机和符卡，以及重置计数
ChapFin=Class(object)
function ChapFin:init(isInboss)
	self.x=0
	self.y=75
	self.img='chapFin'
	self.layer=LAYER_TOP
	self.group=GROUP_GHOST
	self.hscale=1
	self.vscale=1
	self.hide=false
	self.bound=false
	self.colli=false
	self.flag=isInboss
end

function ChapFin:frame()
	if self.timer==1 then
		DR_Pin.reset()
		ClearAllEnemyAndBullet()
		--残机结算
		if lstg.var.chip>=100 and not self.flag then
			lstg.var.lifeleft,lstg.var.chip=lstg.var.lifeleft+math.modf(lstg.var.chip),lstg.var.chip%100--这里的modf会返回参数的整数和小数部分，我就当fix()用了
			PlaySound('extend',0.5)
			New(hinter,'hint.extend',0.6,0,112,15,120)
		end
		--符卡结算
		if lstg.var.bombchip>=100 and not self.flag then
			lstg.var.bomb,lstg.var.bombchip=lstg.var.bomb+math.modf(lstg.var.bombchip),lstg.var.bombchip%100
			if lstg.var.bomb==3 then lstg.var.bombchip=0 end
			PlaySound('cardget',0.8)
		end 
	end
	if self.timer==120 then Del(self) end
end

function ChapFin:render()
	if self.timer<=30 then
		self.hscale=self.hscale-1/60
		self.vscale=self.vscale-1/60
		SetImageState('chapFin','',Color(self.timer*255/30),255,255,255)
	end
	Render('chapFin',self.x,self.y,0,self.hscale)
end

function ClearAllEnemyAndBullet()
	for _,unit in ObjList(GROUP_ENEMY) do
		if unit~=_boss then
			unit.drop=false
			Kill(unit)
		end
	end
	for _,unit in ObjList(GROUP_ENEMY_BULLET) do
		Kill(unit)
	end
end
