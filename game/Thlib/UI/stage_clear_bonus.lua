--关卡分数奖励结算
--正作分数参考：
--500w*关卡数（先跟着正作来，之后算分数的时候再细调）

stage_clear_bonus=Class(object)
function stage_clear_bonus:init(bonus)
	if type(bonus)~='number' then error('Need number.') end
    self.img='hint.stageclear'
    self.x=0
    self.y=100
    self.fade=fade
    self.group=GROUP_GHOST
    self.layer=LAYER_TOP
    self.size=size
    self.t=0
    self.bonus=bonus
	self.alpha=0
	lstg.var.point=lstg.var.point+bonus
end

function stage_clear_bonus:frame()
	local timeT={0,30,90,120}
	if self.timer>timeT[1] and self.timer<=timeT[2] then
		self.alpha=min(255,self.alpha+255/timeT[2])
	elseif self.timer>timeT[2] and self.timer<=timeT[3] then
		--nothing
	elseif self.timer>timeT[3] and self.timer<=timeT[4] then
		self.alpha=max(0,self.alpha-255/(timeT[4]-timeT[3]))
	end
end

function stage_clear_bonus:render()
	SetImageState(self.img,'',Color(self.alpha,255,255,255))
	Render(self.img,self.x,self.y,self.rot,self.hscale,self.vscale)
	SetFontState('score3','',Color(self.alpha,255,255,255))
	RenderScore('score3',self.bonus,self.x,self.y-75,0.7*2,'centerpoint')
end