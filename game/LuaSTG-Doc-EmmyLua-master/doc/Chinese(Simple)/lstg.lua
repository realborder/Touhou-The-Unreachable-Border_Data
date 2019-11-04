---=====================================
---luastg 基础用户接口
---lstg 库
---作者:Xiliusha
---邮箱:Xiliusha@outlook.com
---=====================================

---@class lstg @lstg库
lstg = {}

----------------------------------------
---游戏循环流程

--[[
1 > 初始化游戏框架，启动lua虚拟机
2 > 加载launch初始化脚本（可选），此时游戏引擎还没有初始化完成
3 > 完成游戏引擎初始化
4 > 加载core.lua核心脚本，也就是游戏的入口点文件
5 > 执行GameInit，然后开始游戏循环
6 > 按照FrameFunc->RenderFunc->FrameFunc->...的顺序进行游戏循环
7 > 结束游戏循环，然后执行GameExit
8 > 卸载所有资源，关闭游戏引擎，关闭lua虚拟机，销毁游戏框架
--]]

----------------------------------------
---全局回调函数

---游戏循环开始前调用一次
function GameInit()
end

---游戏循环中每帧调用一次，在RenderFunc之前
---@return boolean @返回true时结束游戏循环
function FrameFunc()
	return false
end

---游戏循环中每帧调用一次，在FrameFunc之后
function RenderFunc()
end

---游戏循环结束后，退出前调用一次
function GameExit()
end

---窗口失去焦点的时候被调用
function FocusLoseFunc()
end

---窗口获得焦点的时候被调用
function FocusGainFunc()
end
