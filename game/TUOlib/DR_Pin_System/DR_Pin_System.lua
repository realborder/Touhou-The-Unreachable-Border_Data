----------------------------------
---梦现指针系统
---code by janrilw
---说明：原先这个系统是以OBJ的形式写的，年代久远杂乱无章，现整理到TUOlib中
----------------------------------
local m = {}
tuolib.DRP_Sys = m

function m.load_res()
    LoadImageFromFile("UI_gaming_item_collect_word", "THlib\\UI\\UI_gaming_item_collect_word.png")
    LoadImageFromFile("UI_gaming_item_collect_line", "THlib\\UI\\UI_gaming_item_collect_line.png")
    LoadTTF("sc_card", "THlib\\UI\\ttf\\ysszt.ttf", 40)
end
m.load_res()
-----------------------------------------
---重设系统核心变量
function m:ResetSystemVariable()
    if not lstg.var.dr then
        lstg.var.dr = 0.01
    end
    --梦(dream)现(reality)指针值
    lstg.var.cp = 0.0
    --combo_point 连击点数，用来控制dr的减少
    lstg.tmpvar.bonus_count = 0
end

--------------------------------------
---重设系统各项常数（其实是可变的
function m:ResetSystemParameter()
    C_BOUNS_LIMIT_IN_CHAPTER = 2500
    K_dr = 0.003
    --用于控制dr的增长，每个chapter可能都要微调，所以记在lstg.var里了

    K_dr_ccced = 1.0 --释放灵击时梦现指针的增加量
    K_dr_item = 1.0 --遗漏道具梦现指针变化系数
    K_dr_enemy = 1.0 --遗漏敌机梦现指针变化系数
    K_graze_c_max = 125 --擦弹计数上限
    K_graze_c_min = 50 --擦弹计数下限
    K_dr_graze_c = 0.2 --擦弹系数
    K_graze_c_k = (-0.75) / (K_graze_c_max - K_graze_c_min) --释放灵击POWWER减少比例
    K_dr_collectline = 22.4 --梦现指针指向现实侧时收点线降低系数
    K_dr_dist = 0.2 --梦现指针指向现实侧时道具吸收范围变大系数
    K_dr_SpellDmg = 0.02 --梦现指针对符卡伤害影响系数
    K_dr_SlowSpell = 1.25 + K_dr_SpellDmg * lstg.var.dr --低速符卡伤害
    K_dr_HighSpell = 1.0 + K_dr_SpellDmg * lstg.var.dr --高速符卡伤害
    K_dr_BonusLimit = 1.0 --获得奖残奖雷所需的最低指针绝对值

    K_MaxSpell = 60 --符卡槽耐久最大值基础值
    K_dr_SpellHp = 3 --梦现指针对符卡槽耐久最大值的影响系数
    K_SpellCost = 20 --单次符卡攻击消耗的符卡槽耐久
    K_SpellDecay = 0.1 --每帧符卡槽耐久衰减系数

    K_BossSpeedKill = 1 --Boss速破奖励系数

    K_cp = 0.2
    K_dr_reduce = 0.002
end

-----------------------------------------
---重设收点线数据
function m:ResetCollectline()
    self.collectline_a = 255 --收点线α值
    self.k_a = (255 - 100) / (K_dr_collectline * 5) --α值改变系数
    self.collectline_y = 112
    self.collectline_dy = 112
end

---------------------------------
---梦现指针系统初始化，目前写在player的init方法中
function m:init()
    --计时器
    self.timer = 0
    --梦现指针系统变量设置
    self:ResetSystemVariable()
    --设置系统参数
    self:ResetSystemParameter()
    --设置收点线
    self:ResetCollectline()
    --召唤收点线
    if not IsValid(self.collect_line) then
        self.collect_line = New(collect_line)
    end
end

----------------------------------------
---增加连击点数，连击点数的增加会让梦现指针往当前方向偏
function m.add(v)
    local var = lstg.var
    v = abs(v)
    var.cp = var.cp + v * K_cp
    if (abs(var.dr) <= 5.0 - v * K_dr) then
        var.dr = (abs(var.dr) + v * K_dr) * sign(var.dr)
    else
        var.dr = sign(var.dr) * 5.0
    end --控制dr的增长体现在这里
end

function m.reduce(v)
    local var = lstg.var
    var.dr = max(0.01, abs(var.dr) - v) * sign(var.dr)
end

----------------------------------------
---关卡结算点固定会调用的函数
function m.reset()
    local var = lstg.var
    local tmpv = lstg.tmpvar
    lstg.var.cp = 1.0
    --重置连击点数
    lstg.tmpvar.bonus_count = 0
    --重置奖残奖雷计数！！！！！

    if not var.spelled_in_chapter and not var.ccced_in_chapter then --一心一意想扭的人是会把x键抠掉的，所以即使单chapterMiss了也给一定偏移
        m.pin_shift(-0.15)
        if not var.missed_in_chapter then
            m.pin_shift(-0.8)
        end
    end
    var.missed_in_chapter = false
    var.spelled_in_chapter = false
    var.ccced_in_chapter = false
end

----------------------------------
---指针数值偏移
function m.pin_shift(v)
    local var = lstg.var
    if abs(var.dr + v) <= 5.0 then
        var.dr = var.dr + v
    else
        var.dr = sign(var.dr) * 5.0
    end
end

------------------------------------
---指针系统帧逻辑
function m:frame()
    self.timer = self.timer + 1
    local var = lstg.var
    local tmpv = lstg.tmpvar
    tmpv.bonus_rate = 0
    --这个是具体的奖残奖雷量

    if not player.dialog then
        --这段是cp减少的代码
        if (var.cp <= 15.0 and var.cp > 5.0) then
            var.cp = var.cp - 0.2
        elseif (var.cp <= 5.0 and var.cp > 1.8) then
            var.cp = var.cp - 0.04
        elseif (var.cp <= 1.8 and var.cp >= 0.008) then
            --经历125帧cp归零
            var.cp = var.cp - 0.008
        else
            var.cp = 0.0
        end
        local drReduce = K_dr_reduce
        if IsValid(_boss) then
            drReduce = K_dr_reduce / 2
        else
            drReduce = K_dr_reduce
        end
        if (var.cp <= 1 and abs(var.dr) > 1 - (1 - var.cp) * drReduce) then --combo_point小于1且dr大于1的情况下d才会渐渐减小，且越接近1减少越慢
            var.dr = (abs(var.dr) - (1 - var.cp) * drReduce) * sign(var.dr)
        end --ddr为0时，dr减的最快

        --这段是给资源的代码
        --设置了单章节最大资源计数值，实际的上限会随着指针而改变
        if abs(var.dr) >= K_dr_BonusLimit then
            tmpv.bonus_count = tmpv.bonus_count + (abs(var.dr) - K_dr_BonusLimit)
            --指针绝对值多出奖残奖雷阈值的部分会直接加到这个计数变量里
            --具体奖励数量在(2,4)这个区间内分布，偏梦境侧则大于3，偏现实侧则小于3，具体偏移量由指针值定。
            --在此基础上乘一个系数用来控制增长，系数是这个：
            --( C_BOUNS_LIMIT_IN_CHAPTER   -   tmpv.bonus_count )   /   C_BOUNS_LIMIT_IN_CHAPTER
            --也就是一个[0,1]内的系数，bonus_count越高这个系数越小，到最后几乎为0
            --下一行代码很长……但是思路列在上面应该能看明白
            if tmpv.bonus_count > C_BOUNS_LIMIT_IN_CHAPTER then
                tmpv.bonus_count = C_BOUNS_LIMIT_IN_CHAPTER
            end
            tmpv.bonus_rate =
                (3.0 + sign(var.dr) * (abs(var.dr) - K_dr_BonusLimit) / (5 - K_dr_BonusLimit)) *
                (C_BOUNS_LIMIT_IN_CHAPTER - tmpv.bonus_count) /
                C_BOUNS_LIMIT_IN_CHAPTER

            var.chip = var.chip + tmpv.bonus_rate * 0.01 * (1 + min(0, sign(var.dr)) * -1.5)
            var.bombchip = var.bombchip + tmpv.bonus_rate * 0.01 * (1 + max(0, sign(var.dr)) * 0.5)
        --这一段，若偏向现实侧则残机奖励会2.5倍，若偏向梦境侧则符卡奖励多1.5倍
        end
        --这段是加灵力的代码
        if abs(var.dr) >= 1.0 then
            -- DR_Pin.GetPower(min((abs(var.dr)-1.0),2.0) * (-2 + sign(var.dr)) / -10 * 0.25)
            tuolib.DRP_Sys.GetPower(min((abs(var.dr) - 1.0), 2.0) * (-2 + sign(var.dr)) / -10 * 0.25)
        end
    end
end

------------------------------------
---原渲染函数
function m:render() --左下角字体渲染
    local var = lstg.var
    local x, y = -182, -204

    --------收点线文字
    if self.timer < 60 and self.timer % 20 == 0 then
        SetImageState("UI_gaming_item_collect_word", "", Color(255, 255, 255, 255))
    elseif self.timer < 60 and (self.timer + 10) % 20 == 0 then
        SetImageState("UI_gaming_item_collect_word", "", Color(155, 255, 255, 255))
    elseif self.timer >= 60 and self.timer <= 120 then
        SetImageState("UI_gaming_item_collect_word", "", Color(255 - int((self.timer - 60) / 60 * 255), 255, 255, 255))
        Render("UI_gaming_item_collect_word", 0, player.collect_line + 22)
    end
    --------------------收点线只要有变动就会往不透明变，否则慢慢变回透明
    local y = min(112, player.collect_line + lstg.var.dr * K_dr_collectline)
    self.collectline_y = self.collectline_y + (y - self.collectline_y) * 0.25
    --平滑处理
    self.collectline_a = max(20, min(200, self.collectline_a - 3 + abs(self.collectline_dy - self.collectline_y) * 100)) --alpha限制在20到200
    self.collectline_dy = self.collectline_y
    SetImageState("UI_gaming_item_collect_line", "", Color(self.collectline_a, 255, 255, 255))
    Render("UI_gaming_item_collect_line", 0, self.collectline_y)

    if player.SC_name ~= "" then
        SetImageState("boss_spell_name_bg", "", Color(255, 255, 255, 255))
        if player.SpellTimer1 <= 90 then
            Render("boss_spell_name_bg", -51, -100 - player.SpellTimer1, 0, 1.5)
            RenderTTF(
                "sc_card",
                player.SC_name,
                -80,
                -80,
                -110 - player.SpellTimer1,
                -110 - player.SpellTimer1,
                Color(255, 0, 0, 0),
                "right",
                "noclip"
            )
            RenderTTF(
                "sc_card",
                player.SC_name,
                -81,
                -81,
                -109 - player.SpellTimer1,
                -109 - player.SpellTimer1,
                Color(255, 255, 255, 255),
                "right",
                "noclip"
            )
        else
            Render("boss_spell_name_bg", -51, -190, 0, 1.5)
            RenderTTF("sc_card", player.SC_name, -80, -80, -200, -200, Color(255, 0, 0, 0), "right", "noclip")
            RenderTTF("sc_card", player.SC_name, -81, -81, -199, -199, Color(255, 255, 255, 255), "right", "noclip")
        end
    end
end

----------------------------------------
---新的获得power函数
function m.GetPower(v)
    local before = int(lstg.var.power / 100)
    lstg.var.power = min(player.maxPower, lstg.var.power + v)
    local after = int(lstg.var.power / 100)
    if after > before then
        PlaySound("powerup1", 0.5)
    end
end
----------------------------------
---用于渲染收点线的obj
collect_line = Class(object)
function collect_line:init()
    self.group = GROUP_GHOST
    self.layer = LAYER_TOP
end
function collect_line:render()
    m:render()
end
