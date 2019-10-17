local ResourceManager=TUO_Developer_UI:NewModule()

function ResourceManager:init()
    self.name='游戏资源管理'
    
end
local setting=TUO_Developer_UI:NewPanel()
function setting:init()
    self.name="[1]纹理"
end
local setting=TUO_Developer_UI:NewPanel()
function setting:init()
    self.name="[2]图像"
end
local setting=TUO_Developer_UI:NewPanel()
function setting:init()
    self.name="[3]动画"
end
local setting=TUO_Developer_UI:NewPanel()
function setting:init()
    self.name="[4]音乐"
end
local setting=TUO_Developer_UI:NewPanel()
function setting:init()
    self.name="[5]音效"
end
local setting=TUO_Developer_UI:NewPanel()
function setting:init()
    self.name="[6]粒子"
end
local setting=TUO_Developer_UI:NewPanel()
function setting:init()
    self.name="[7]纹理字体"
end
local setting=TUO_Developer_UI:NewPanel()
function setting:init()
    self.name="[8]TTF字体"
end
local setting=TUO_Developer_UI:NewPanel()
function setting:init()
    self.name="[9]shader"
end