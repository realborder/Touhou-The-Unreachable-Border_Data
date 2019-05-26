-- luastg+ 专用强化脚本库
-- 该脚本库完全独立于lstg的老lua代码
-- 所有功能函数暴露在全局plus表中
-- by CHU

plus = {}

lstg.DoFile("plus\\Utility.lua")
lstg.DoFile("plus\\NativeAPI.lua")
lstg.DoFile("plus\\IO.lua")
lstg.DoFile("plus\\Replay.lua")
lstg.DoFile("plus\\WalkImageSystem.lua")