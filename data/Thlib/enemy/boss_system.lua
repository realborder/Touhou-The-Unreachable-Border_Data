--======================================
--th style boss system
--======================================

----------------------------------------
--boss system
--!警告：原boss逻辑和boss ex逻辑混杂在一起，可能导致无法预知的bug

BossSystem = plus.Class()

---@param boss object @要执行符卡组的boss
---@param name string @ui显示的boss名称
---@param cards table @符卡表
---@param bg object @boss符卡背景
---@param diff string @boss难度
function BossSystem:init(boss, name, cards, bg, diff)
    self.boss = boss
    local b = self.boss
    b.difficulty = diff or 'All' --boss难度
    --boss ui
    b.ui = New(boss_ui, b)
    b.ui.name = name or '' --显示的符卡名
    b.ui.sc_left = 0 --ui显示的符卡星星数
    b.lifepoint = 160 --血条分割点
    b.hp_flag = 0 --自机靠近boss时血条透明度降低
    b.sp_point = {} --血条阶段点
    --伤害相关
    b.dmg_factor = 0 --伤害比率
    b.sc_pro = 0 --符卡spell剩余保护时间
    --boss卡背
    if bg then b.bg = bg end
    b.spell_damage = 0 --符卡中受到的伤害值
    --分数与游戏系统相关
    b.sc_bonus_max = item.sc_bonus_max --最大符卡分数
    b.sc_bonus_base = item.sc_bonus_base --基础符卡分数
    b.timeout = 0 --超时判断flag
    b.spell_get = false --是否收取符卡
    b.spell_timeout = false --是否超时
    --常规boss符卡准备
    b.cards = cards --boss符卡表
    b.card_num = 0 --执行到的符卡编号
    b.last_card = 0 --记录的终符编号
    for i = 1, #b.cards do
        if b.cards[i].is_combat then
            b.last_card = i
        end
        if b.cards[i].is_sc then
            b.ui.sc_left = b.ui.sc_left + 1
        end
    end
    --boss ex系统准备
    if b.ex then
        b.ex.lifes = {}
        b.ex.lifesmax = {}
        b.ex.modes = {}
        b.ex.cards = {}
        b.ex.cardcount = 0
        b.ex.nextcard = 0
        b.ex.status = 0
        b.ex.timer = 0
        b.ex.taskself = b
    end
end

---boss系统帧逻辑
function BossSystem:frame()
    local b = self.boss
    --boss高防
    if b.sc_pro > 0 then
        b.sc_pro = b.sc_pro - 1
    end
    --位置指示器更新
    self:UpdatePosition()
    local c = self:GetCurrentCard()
    if c then
        c.frame(b)
        --受击伤害调整
        self:CheckTimer()
        --符卡分数更新
        self:UpdateScore()
        --符卡ui更新
        b.ui.hpbarlen = b.hp / b.maxhp
        b.ui.countdown = (c.t3 - b.timer) / 60
        --player靠近boss时ui透明度更新
        self:UpdateHPflag()
        --卡背透明度和关卡背景更新
        self:UpdateBG()
    end
end

---boss系统渲染逻辑
function BossSystem:render()
    local b = self.boss
    local c = self:GetCurrentCard()
    if c then
        c.render(b)
    end
end

---boss系统结束逻辑
function BossSystem:kill()
    local b = self.boss
    b.sp_point={}
    --boss ex
    if b.ex then
        boss.killex(b)
        return
    end
    local c=self:GetCurrentCard()
    if c then
        c.del(b)
        boss.PopSpellResult(b, c)
        if b.card_num == b.last_card then
            if b.cards[#b.cards].is_move then
                PlaySound('enep01', 0.4, 0)
            else
                New(boss_death_ef, b.x, b.y)
                b.hide = true
                b.colli = false
            end
        end
    end
end

---boss系统删除
function BossSystem:del()
    local b = self.boss
    if b.ex then
        task.Clear(b.ex)
    end
    if b.ui then Del(b.ui) end
    if b.bg then Del(b.bg) b.bg = nil end
    if b.dialog_displayer then Del(b.dialog_displayer) end
    if lstg.tmpvar.bg then lstg.tmpvar.bg.hide = false end
end

----------------------------------------
--frame

---检查血量
function BossSystem:CheckHP()
    local b = self.boss
    if b.hp <= 0 then
        if b.card_num == b.last_card and not(b.no_killeff) and not(b.killed) then
            boss.explode(b)
        else
            if not(b.killed) then
                Kill(b)
            end
        end
    end
    --b ex
    if b.ex then
        if b.hp <= 0 then
            if not(b.killed) then
                Kill(b)
            end
        end
    end
end

---检查计时器
--！警告：潜在的多玩家适配问题
function BossSystem:CheckTimer()
    local b = self.boss
    local c = self:GetCurrentCard()
    if player.nextspell > 0 and b.timer <= 0 then
        b.sc_pro = player.nextspell
    end
    b.timeout = 0
    if b.timer < c.t1 then
        b.dmg_factor = 0
    elseif b.sc_pro > 0 then --修复开卡前bomb的b高防
        b.dmg_factor = 0.1
    elseif b.timer < c.t2 then
        b.dmg_factor = (b.timer - c.t1) / (c.t2 - c.t1)
    elseif b.timer < c.t3 then
            b.dmg_factor = 1
    else
        b.hp = 0
        b.timeout = 1
    end
    local players = Players(b)
    local _flag = false
    for i = 1, #players do
        if IsValid(players[i]) and players[i].nextspell > 0 then
            _flag = true
        end
    end
    if c.is_extra and _flag then
        b.dmg_factor = 0
    end
    if c.t1 == c.t3 then --耐久或者击破
        b.dmg_factor = 0
        b.time_sc = true
    else
        b.time_sc = false
    end
end

---更新位置指示器
function BossSystem:UpdatePosition()
    local b = self.boss
    if b.x > lstg.world.l and b.x < lstg.world.r then
        b.ui.pointer_x = b.x
    else
        b.ui.pointer_x = nil
    end
end

---更新符卡分数
function BossSystem:UpdateScore()
    local b = self.boss
    local c = self:GetCurrentCard()
    if b.sc_bonus and b.sc_bonus > 0 and c.t1 ~= c.t3 and not(b.killed) then
        b.sc_bonus = b.sc_bonus - (b.sc_bonus_max - b.sc_bonus_base) / c.t3
    end
end

---更新血条透明度
function BossSystem:UpdateHPflag()
    local b = self.boss
    local players = Players(b)
    local _flag = false
    for i = 1, #players do
        if IsValid(players[i]) and Dist(players[i], b) <= 70 then
            b.hp_flag = b.hp_flag + 1
            _flag = true
        end
    end
    if not _flag then 
        b.hp_flag = b.hp_flag - 1
    end
    b.hp_flag = min(max(0, b.hp_flag), 18)
end

---更新符卡背景
function BossSystem:UpdateBG()
    local b = self.boss
    local c = self:GetCurrentCard()
    if b.bg then
        if IsValid(b.bg) then
            if c.is_sc then
                b.bg.alpha = min(1, b.bg.alpha + 0.025)
            else
                b.bg.alpha = max(0, b.bg.alpha - 0.025)
            end
        end
        if lstg.tmpvar.bg then
            if IsValid(b.bg) and b.bg.alpha == 1 then
                lstg.tmpvar.bg.hide = true
            else
                lstg.tmpvar.bg.hide = false
            end
        end
    end
end

---执行task
function BossSystem:DoTask()
    local b = self.boss
    if b.ex then
        b.ex.timer = b.ex.timer + 1
        if b.ex.status == 1 then
            if b.ex.finish == 1 then
                b.hp = 0
            end
            b.ex.lifes[b.ex.nextcard] = b.hp
        end
        b.ex.finish = 0
        task.Do(b.ex)
    end
    task.Do(b)
end

----------------------------------------
--card

---获取boss当前符卡
function BossSystem:GetCurrentCard()
    local b = self.boss
    local c = b.current_card or b.cards[self.card_num]
    if b.ex and b.ex.status == 1 then
        c = b.ex.cards[b.ex.nextcard]
    end
    return c
end

---执行通常符卡
---@param card table @通常boss符卡
---@param mode number @血条样式
function BossSystem:DoCard(card, mode)
    local b = self.boss
    b.current_card = card
    if card.is_sc then
        self:CastCard(card)
    elseif not card.fake then
        b.sc_bonus = nil
    end
    self:SetHPBar(mode)
    if card.is_combat then
        item.StartChipBonus(b)
        b.spell_damage = 0
    end
    task.Clear(b)
    task.Clear(b.ui)
    b.ui.countdown = card.t3 / 60
    b.ui.is_combat = card.is_combat
    b.timer = -1
    b.hp = card.hp
    b.maxhp = card.hp
    b.dmg_factor = 0
    card.init(b)
end

---执行下一张符卡
function BossSystem:next()
    local b = self.boss
    b.card_num = b.card_num + 1
    if not(b.cards[b.card_num]) then
        self.is_finish = true
        return false
    end
    local last, now, next, mode
    for n = b.card_num - 1, 1, -1 do
        if b.cards[n] and b.cards[n].is_combat then
            last = b.cards[n]
            break
        end
    end
    now = b.cards[b.card_num]
    for n = b.card_num + 1, #b.cards do
        if b.cards[n] and b.cards[n].is_combat then
            next = b.cards[n]
            break
        end
    end
    if now.is_sc then
        if last and last.is_sc then
            mode = 0
        elseif last and not(last.is_sc) then
            if (last.t1 ~= last.t3) then
                mode = 2
            else
                mode = 0
            end
        elseif not(last) then
            mode = 0
        end
    elseif not(now.is_sc) then
        if next and next.is_sc then
            if (next.t1 ~= next.t3) then
                mode = 1
            else
                mode = 0
            end
        elseif next and not(next.is_sc) then
            mode = 3
        elseif not(next) then
            mode = 3
        end
    end
    if now.t1 == now.t3 then
        mode = -1
    end
    self:DoCard(now, mode)
    return true
end

---设置血条类型
---@param mode number @血条样式(-1无血条，0完整，1非&符中的非，2非&符中的符, 3完整非)
function BossSystem:SetHPBar(mode)
    local b = self.boss
    local color1, color2 = Color(0xFFFF8080), Color(0xFFFFFFFF)
    if mode == -1 then
        b.ui.hpbarcolor1 = nil
        b.ui.hpbarcolor2 = nil
    elseif mode == 0 then
        b.ui.hpbarcolor1 = color1
        b.ui.hpbarcolor2 = nil
    elseif mode == 1 then
        b.ui.hpbarcolor1 = color1
        b.ui.hpbarcolor2 = color2
    elseif mode == 2 then
        b.ui.hpbarcolor1 = color1
        b.ui.hpbarcolor2 = color1
    elseif mode == 3 then
        b.ui.hpbarcolor1 = nil
        b.ui.hpbarcolor2 = color1
    end
end

---宣言符卡
---@param card table @目标符卡
function BossSystem:CastCard(card)
    local b = self.boss
    if not card.fake then
        b.sc_bonus = b.sc_bonus_max
    end
    New(spell_card_ef)
    PlaySound('cat00', 0.5)
    if scoredata.spell_card_hist == nil then
        scoredata.spell_card_hist = {}
    end
    local sc_hist = scoredata.spell_card_hist
    local player = lstg.var.player_name
    local diff = b.difficulty
    local name = card.name
    self:MakeSCHist(player, diff, name)
    b.ui.sc_hist = sc_hist[player][diff][name]
    if name ~= '' then
        b.ui.sc_name = name
        --last = New(boss.sc_name_obj, b, name) --TODO：SB OLC
        --_connect(b, last, 0, true)
    end
end

---建立符卡记录信息
function BossSystem:MakeSCHist(player, diff, name)
    local sc_hist = scoredata.spell_card_hist
    if sc_hist[player] == nil then
        sc_hist[player] = {}
    end
    if sc_hist[player][diff] == nil then
        sc_hist[player][diff] = {}
    end
    if sc_hist[player][diff][name] == nil then
        sc_hist[player][diff][name] = {0, 0}
    end
    if not ext.replay.IsReplay() then
        sc_hist[player][diff][name][2] = sc_hist[player][diff][name][2] + 1
    end
end
