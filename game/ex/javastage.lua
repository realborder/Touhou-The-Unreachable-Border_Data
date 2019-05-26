---=====================================
---javastg multiplayer|network
---=====================================

----------------------------------------
---javastage

---@class jstg @javastage
jstg = {}

local jstgpath="ex\\"

lstg.DoFile(jstgpath.."Jnetwork.lua")--网络连接库
lstg.DoFile(jstgpath.."Jinput.lua")--输入控制库
lstg.DoFile(jstgpath.."Jplayer.lua")--多玩家场地库
--lstg.DoFile(jstgpath.."Jcompatible.lua")

--初始化默认的双输入
jstg.network.slots[1]='local'
jstg.network.slots[2]='local'
jstg.MultiPlayer()
jstg.CreateInput(2)
