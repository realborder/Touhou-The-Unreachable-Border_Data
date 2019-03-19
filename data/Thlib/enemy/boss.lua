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
	self.ringX=self.x
	self.ringY=self.y
    self.img = 'undefined'
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
    Render('boss_aura_3D'..self.ani % 25 + 1, self.x, self.y, self.ani * 0.75, 0.92 * self.aura_scale*2, (0.8 + 0.12 * cos(self.ani * 0.75)) * self.aura_scale*2) -- 渲染时*2修改标记
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

local patch="Thlib\\enemy\\"

LoadTexture('boss',patch..'boss.png')
LoadImageGroup('bossring1','boss',80,0,16,8,1,16)
for i=1,16 do SetImageState('bossring1'..i,'mul+add',Color(0x80FFFFFF)) end
LoadImageGroup('bossring2','boss',48,0,16,8,1,16)
for i=1,16 do SetImageState('bossring2'..i,'mul+add',Color(0x80FFFFFF)) end
LoadImage('spell_card_ef','boss',96,0,16,128)
LoadImage('hpbar','boss',116,0,8,128)
--LoadImage('hpbar1','boss',116,0,2,2)
LoadImage('hpbar2','boss',116,0,2,2)
SetImageCenter('hpbar',0,0)
LoadTexture('undefined',patch..'undefined.png')
LoadImage('undefined','undefined',0,0,128,128,16,16)
SetImageState('undefined','mul+add',Color(0x80FFFFFF))
LoadImageFromFile('base_hp',patch..'ring00.png')
SetImageState('base_hp','',Color(0xFFFF0000))
LoadTexture('lifebar',patch..'lifebar.png')
LoadImage('life_node','lifebar',20,0,12,16)
LoadImage('hpbar1','lifebar',4,0,2,2)
SetImageState('hpbar1','',Color(0xFFFFFFFF))
SetImageState('hpbar2','',Color(0x77D5CFFF))
LoadTexture('magicsquare',patch..'eff_magicsquare.png')
LoadImageGroup('boss_aura_3D','magicsquare',0,0,256,256,5,5)
LoadImageFromFile('dialog_box',patch..'dialog_box.png')

Include(patch.."boss_system.lua")--boss行为逻辑
Include(patch.."boss_function.lua")--boss额外函数
Include(patch.."boss_card.lua")--boss非符、符卡
Include(patch.."boss_dialog.lua")--boss对话
Include(patch.."boss_other.lua")--杂项、boss移动、特效
Include(patch.."boss_ui.lua")--boss ui
