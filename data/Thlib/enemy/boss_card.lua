--======================================
--th style boss card
--======================================

----------------------------------------
--boss card
--~细节：大多数时候只会用到New、init、render和del，其中init、del在编辑器中重载

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
    return c
end

function boss.card:frame() end

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
            misc.RenderRing('bossring1', self.x, self.y, timer * 2 + 270 * sin(timer * 2), timer * 2 + 270 * sin(timer * 2) + 16, self.ani * 3, 32, 16)
            misc.RenderRing('bossring2', self.x, self.y, 90 + timer * 1, -180 + timer * 4 - 16, -self.ani * 3, 32, 16)
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
            misc.RenderRing('bossring1', self.x, self.y, (t - timer) / (t - 90) * 180, (t - timer) / (t - 90) * 180 + 16, self.ani * 3, 32, 16)
            misc.RenderRing('bossring2', self.x, self.y, (t - timer) / (t - 90) * 180, (t - timer) / (t - 90) * 180 - 16, -self.ani * 3, 32, 16)
        end
    end
end

function boss.card:init() end

function boss.card:del() end
