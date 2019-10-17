local gametest=TUO_Developer_UI:NewModule()

function gametest:init()
    self.name='游戏系统调试'
end

local basic=TUO_Developer_UI:NewPanel()
function basic:init()
    self.name="基本系统"
    self.left_for_world=true
end
local drsys=TUO_Developer_UI:NewPanel()
function drsys:init()
    self.name="梦现指针"
    self.left_for_world=true
end