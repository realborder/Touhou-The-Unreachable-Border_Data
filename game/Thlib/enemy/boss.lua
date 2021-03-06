---=====================================
---th style boss
---=====================================

----------------------------------------
---boss base

---@class boss @东方风boss
boss = Class(enemybase)

function boss:init(x, y, name, cards, bg, diff)
    enemybase.init(self,999999999)
    self.x = x
    self.y = y
    self.img = 'undefined'
	self.ringX=self.x
    self.ringY=self.y
    --boss魔法阵
    self.aura_alpha = 255 --法阵透明度
    self.aura_alpha_d = 4 --法阵透明度单帧变化值
    self.aura_scale = 1 --法阵大小比例
    --boss系统
    self._bosssys = BossSystem(self, name, cards, bg, diff)
    --boss行走图系统
    self._wisys = BossWalkImageSystem(self)
    --boss ex
    if self.ex == nil then
        Kill(self) --开始执行通常符卡系统
    end
    ex.AddBoss(self) --加入ex的boss表中
    lstg.tmpvar.boss = self
end

function boss:frame()
    --出屏判定关闭
    SetAttr(self, 'colli', BoxCheck(self, lstg.world.boundl, lstg.world.boundr, lstg.world.boundb, lstg.world.boundt) and self._colli)
    --血量下限
    self.hp = max(0, self.hp)
    --符卡系统检查hp
    self._bosssys:CheckHP()
    --执行自身task
    self._bosssys:DoTask()
    --行走图系统帧逻辑
    self._wisys:frame()
    --受击闪烁
    if self.dmgt then
        self.dmgt = max(0, self.dmgt - 1)
    end
    --boss系统帧逻辑
    self._bosssys:frame()
    --魔法阵透明度更新
    self.aura_alpha = self.aura_alpha + self.aura_alpha_d
    self.aura_alpha = min(max(0, self.aura_alpha), 128)
end

function boss:render()
    for i=1,25 do
        SetImageState('boss_aura_3D'..i, 'mul+add', Color(self.aura_alpha, 255, 255, 255))
    end
    Render('boss_aura_3D'..self.ani % 25 + 1, self.x, self.y, self.ani * 0.75, 0.92 * self.aura_scale*2, (0.8 + 0.12 * cos(self.ani * 0.75)) * self.aura_scale*2)
    self._bosssys:render()
    self._wisys:render(self.dmgt, self.dmgmaxt) --by OLC，行走图系统
end

function boss:kill()
    _kill_servants(self)
    self._bosssys:kill()
    --boss行为更新
    if self.ex then --执行boss ex逻辑时不执行boss逻辑
        do return end
    elseif self._bosssys:next() then --切换到下一个行为
        PreserveObject(self)
    else --没有下一个行为了，清除自身和附属的组件
        boss.del(self)
    end
end

function boss:del()
    self._bosssys:del()
    if self.class.defeat then self.class.defeat(self) end
    ex.RemoveBoss(self)
end

----------------------------------------
---boss函数库和资源

local patch="THlib\\enemy\\"

LoadTexture('boss',patch..'boss.png')
LoadImageGroup('bossring1','boss',80*4,0,16*4,8*4,1,16)
for i=1,16 do SetImageState('bossring1'..i,'mul+add',Color(0x80FFFFFF)) end
LoadImageGroup('bossring2','boss',48*4,0,16*4,8*4,1,16)
for i=1,16 do SetImageState('bossring2'..i,'mul+add',Color(0x80FFFFFF)) end
LoadImage('spell_card_ef','boss',96*4,0,16*4,128*4)
LoadImage('hpbar','boss',116*4,0,8*4,128*4)
--LoadImage('hpbar1','boss',116,0,2,2)
LoadImage('hpbar2','boss',116*4,0,2*4,2*4)
SetImageCenter('hpbar',0,0)
LoadTexture('undefined',patch..'undefined.png')
LoadImage('undefined','undefined',0,0,128,128,32,32)
SetImageState('undefined','mul+add',Color(0x80FFFFFF))
LoadImageFromFile('base_hp',patch..'ring00.png')
SetImageState('base_hp','',Color(0xFFFFFFFF))
LoadImageFromFile('base_hp2',patch..'ring01.png')
SetImageState('base_hp2','mul+add',Color(0xFFFFFFFF))
LoadTexture('lifebar',patch..'lifebar.png')
LoadImage('life_node','lifebar',20,0,12,16)
LoadImage('hpbar1','lifebar',4,0,2,2)
SetImageState('hpbar1','',Color(0xFFFFFFFF))
SetImageState('hpbar2','',Color(0x77D5CFFF))
LoadImage('hpbar3','lifebar',4,0,2,2)
SetImageState('hpbar3','',Color(255,200,0,0))
LoadImage('hpbar4','lifebar',4,0,2,2)
SetImageState('hpbar4','',Color(255,0,0,200))

LoadTexture('magicsquare',patch..'eff_magicsquare.png')

LoadImageGroup('boss_aura_3D','magicsquare',0,0,256,256,5,5)
LoadImageFromFile('dialog_box',patch..'dialog_box.png')

------对话气泡，来自olc
LoadTexture("dialog_balloon", patch .. "dialog_balloon.png")
local _head = {
    { 108, 0, 90, 96 },
    { 108, 96, 90, 112 },
    { 108, 231, 90, 96 },
    { 108, 343, 90, 96 },
    { 108, 448, 90, 128 },
    { 108, 576, 90, 144 },
    { 108, 743, 90, 128 },
    { 108, 887, 90, 128 }
}
--1-4用于单行文字，5-8用于多行文字（2行）
for i = 1, 4 do
    LoadImage("balloonHead" .. i, "dialog_balloon", --40
            _head[i][1], _head[i][2], 90, _head[i][4])

    LoadImage("balloonBody" .. i, "dialog_balloon", --32
            0, _head[i][2], 32, _head[i][4])

    LoadImage("balloonTail" .. i, "dialog_balloon", --4
            32, _head[i][2], 64, _head[i][4])
    local yy = 0
    if i > 2 then
        yy = -7
    end
    SetImageCenter("balloonHead" .. i, 36, yy)
    SetImageCenter("balloonBody" .. i, 0, yy)
    SetImageCenter("balloonTail" .. i, 0, yy)
end
for i = 5, 8 do
    LoadImage("balloonHead" .. i, "dialog_balloon",
            _head[i][1], _head[i][2], 90, _head[i][4])

    LoadImage("balloonBody" .. i, "dialog_balloon",
            0, _head[i][2], 32, _head[i][4])

    LoadImage("balloonTail" .. i, "dialog_balloon",
            32, _head[i][2], 64, _head[i][4])
    local yy = 0
    if i > 6 then
        yy = -7
    end
    SetImageCenter("balloonHead" .. i, 36, yy)
    SetImageCenter("balloonBody" .. i, 0, yy)
    SetImageCenter("balloonTail" .. i, 0, yy)
end
LoadTTF("balloon_font", patch .. "balloon_font.ttf", 32)
---------



Include(patch.."boss_system.lua")--boss行为逻辑
Include(patch.."boss_function.lua")--boss额外函数
Include(patch.."boss_card.lua")--boss非符、符卡
Include(patch.."boss_dialog.lua")--boss对话
Include(patch.."boss_other.lua")--杂项、boss移动、特效
Include(patch.."boss_ui.lua")--boss ui
