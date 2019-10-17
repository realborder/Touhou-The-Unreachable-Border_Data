local gametest=TUO_Developer_UI:NewModule()

function gametest:init()
    self.name='关卡调试'
    
end
local quickboost=TUO_Developer_UI:NewPanel()
function quickboost:init()
    self.name="快速启动"
end
local modmgr=TUO_Developer_UI:NewPanel()
function modmgr:init()
    self.name="mod包管理"
end
local steptest=TUO_Developer_UI:NewPanel()
function steptest:init()
    self.name="步进调试"
end