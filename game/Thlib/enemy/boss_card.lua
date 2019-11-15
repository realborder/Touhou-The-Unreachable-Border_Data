--======================================
--th style boss card
--======================================

----------------------------------------
--boss card
--~细节：大多数时候只会用到New、init、render和del，其中init、del在编辑器中重载

local ringWidth = 20 --符卡环的宽度
local ringMaxRadius = 180 --符卡环最大半径
local ringMinRadius = 45

boss.card = {}

function boss.card.New(name, t1, t2, t3, hp, drop, is_extra)
    local c = {}
    c.frame = boss.card.frame
    c.render = boss.card.render
    c.init = boss.card.init
    c.del = boss.card.del
    c.name = tostring(name)
    if t1 > t2 or t2 > t3 then
        error('t1<=t2<=t3 must be satisfied.')
    end
    c.t1 = int(t1) * 60
    c.t2 = int(t2) * 60
    c.t3 = int(t3) * 60
    c.hp = hp
    c.is_sc = (name ~= '')
    c.drop = drop
    c.is_extra = is_extra or false
    c.is_combat = true
	
	----速破相关
	c.hploss=0
	c.speed_kill_minus=0
	c.virtualhp=0
	c.hplen=0
	c.takeDmg_inFrame=0
	c.timer=0
	
    return c
end

function boss.card:frame()
	----速破相关
	local c = boss.GetCurrentCard(self)
	c.timer=c.timer+1
	if c.timer>1 then
		c.hploss=self.maxhp-self.hp
        -- c.speed_kill_minus=min(c.hploss,c.speed_kill_minus+max(0,c.takeDmg_inFrame))
        local plr_dist=1-max(0,50-abs(player.x-_boss.x))/50 --如果玩家在boss正下方射击那boss虚血也不会掉
        c.speed_kill_minus=min(c.hploss,c.speed_kill_minus+plr_dist*max(0,10/6-c.takeDmg_inFrame))
        boss_ui.AddHpBarBreak(self,c.takeDmg_inFrame)
		c.takeDmg_inFrame=0
		c.virtualhp=max(0,c.hploss-c.speed_kill_minus)
		c.hplen=c.virtualhp/self.maxhp

	end
	if self.timer >= 90 then --符卡圈的平滑移动
		local dx=self.x-self.ringX
		local dy=self.y-self.ringY
		if abs(dx)<0.5 then self.ringX=self.x else self.ringX=self.ringX+(self.x-self.ringX)*0.07 end --符卡圈每帧都会向boss靠近7%，如果距离只有0.5则直接贴脸
		if abs(dy)<0.5 then self.ringY=self.y else self.ringY=self.ringY+(self.y-self.ringY)*0.07 end
	end
end

function boss.card:render() 
    local c = boss.GetCurrentCard(self)
    local alpha = self.aura_alpha or 255
    local timer = self.timer
    if c and c.is_sc and c.t1 ~= c.t3 then
        for i = 1, 16 do
            SetImageState('bossring1'..i, 'mul+add', Color(alpha, 255, 255, 255))
        end
        if timer < 90 then
            if self.fxr and self.fxg and self.fxb then
                local of = 1 - timer / 180
                for i = 1, 16 do
                    SetImageState('bossring2'..i, 'mul+add', Color(1.9 * alpha, self.fxr * of, self.fxg * of, self.fxb * of))
                end
            else
                for i = 1, 16 do
                    SetImageState('bossring2'..i, 'mul+add', Color(alpha, 255, 255, 255))
                end
            end
            misc.RenderRing('bossring1', self.x, self.y, ringMaxRadius*timer/90 + ringMaxRadius * sin(timer * 2)+ringMinRadius, ringMaxRadius*timer/90 + ringMaxRadius * sin(timer * 2) + ringWidth+ringMinRadius, self.ani * 5, 32, 16)
			timer=90*sin(timer)
            misc.RenderRing('bossring2', self.x, self.y, ringMaxRadius*0.25 + ringMaxRadius*0.75*timer/90+ringMinRadius, -0.5*ringMaxRadius + 1.5*ringMaxRadius*timer/90 - ringWidth+ringMinRadius, -self.ani * 5, 32, 16)
			self.ringX=self.x self.ringY=self.y
        else
            if self.fxr and self.fxg and self.fxb then
                for i = 1, 16 do
                    SetImageState('bossring2'..i, 'mul+add', Color(1.9 * alpha, self.fxr / 2, self.fxg / 2, self.fxb / 2))
                end
            else
                for i = 1, 16 do
                    SetImageState('bossring2'..i, 'mul+add', Color( alpha, 255, 255, 255))
                end
            end
            local t = c.t3
            misc.RenderRing('bossring1', self.ringX, self.ringY, (t - timer) / (t - 90) * ringMaxRadius+ringMinRadius, (t - timer) / (t - 90) * ringMaxRadius + ringWidth+ringMinRadius, self.ani * 5, 32, 16)
            misc.RenderRing('bossring2', self.ringX, self.ringY, (t - timer) / (t - 90) * ringMaxRadius+ringMinRadius, (t - timer) / (t - 90) * ringMaxRadius - ringWidth+ringMinRadius, -self.ani * 5, 32, 16)
        end
    end
end

function boss.card:init()  end

function boss.card:del()
	local c = boss.GetCurrentCard(self)
    -- DR_Pin.pin_shift(-c.hplen)
    tuolib.DRP_Sys.Event_BossCardDelete(boss,c)
	c.timer=0
	c.speed_kill_minus=0
end


