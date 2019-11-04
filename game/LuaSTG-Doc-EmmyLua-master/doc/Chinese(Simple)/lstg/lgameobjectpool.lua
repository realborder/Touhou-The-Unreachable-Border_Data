---=====================================
---对象池方法
---作者:Xiliusha
---邮箱:Xiliusha@outlook.com
---=====================================

---@type lstg
local m = lstg

----------------------------------------
---游戏对象池

---获取申请的对象数
---@return number
function m.GetnObj()
	return 0
end

---回收所有对象，并释放绑定的资源
function m.ResetPool()
end

---【禁止在协同程序中调用此方法】
---更新所有游戏对象并触发游戏对象的frame回调函数
function m.ObjFrame()
end

---【禁止在协同程序中调用此方法】
---绘制所有游戏对象并触发游戏对象的render回调函数
function m.ObjRender()
end

---【禁止在协同程序中调用此方法】
---对所有游戏对象进行出界判断，如果离开场景边界，将会触发对象的del回调函数
function m.BoundCheck()
end

---更改场景边界，默认为-100, 100, -100, 100
---@param left number
---@param right number
---@param bottom number
---@param top number
function m.SetBound(left, right, bottom, top)
end

---【禁止在协同程序中调用此方法】
---对两个碰撞组的对象进行碰撞检测，如果发生碰撞则触发groupidA内的对象的colli回调函数，并传入groupidB内的对象作为参数
---@param groupidA number @只能为0到15范围内的整数
---@param groupidB number @只能为0到15范围内的整数
function m.CollisionCheck(groupidA, groupidB)
end

---【禁止在协同程序中调用此方法】
---保存游戏对象的x, y坐标并计算dx, dy
function m.UpdateXY()
end

---【禁止在协同程序中调用此方法】
---增加游戏对象的timer, ani计数器，如果对象被标记为kill或者del，则回收该对象
function m.AfterFrame()
end

----------------------------------------
---游戏对象

---申请游戏对象，并将游戏对象和指定的class绑定，剩余的参数将会传递给init回调函数并执行
---@param class lstg.Class
---@vararg any
---@return lstg.GameObject
function m.New(class, ...)
	---@type lstg.GameObject
	local ret = {}
	return ret
end

---重置指定游戏对象的各项属性为默认值，不重置id、uuid(不可见)、class(class信息会被清除)
---@param unit lstg.GameObject
function m.ResetObject(unit)
end

---触发指定游戏对象的del回调函数，并将该对象标记为del状态，剩余参数将传递给del回调函数
---@param unit lstg.GameObject
---@vararg any
function m.Del(unit, ...)
end

---触发指定游戏对象的kill回调函数，并将该对象标记为kill状态，剩余参数将传递给kill回调函数
---@param unit lstg.GameObject
---@vararg any
function m.Kill(unit, ...)
end

---检查指定游戏对象的引用是否有效，如果返回假，则该对象已经被对象池回收或不是 有效的lstg.GameObject对象；
---unit参数可以是任何值，因此也可以用来判断传入的参数 是否是游戏对象
---@param unit any
---@return boolean
function m.IsValid(unit)
	return false
end

---计算向量的朝向，可以以以下的组合方式填写参数：
---```txt
---lstg.GameObject, lstg.GameObject
---lstg.GameObject, x, y
---x, y, lstg.GameObject
---x1, y1, x2, y2
---```
---@param x1 lstg.GameObject|number
---@param y1 lstg.GameObject|number
---@param x2 lstg.GameObject|number|nil
---@param y2 number|nil
---@return number
function m.Angle(x1, y1, x2, y2)
	return 0
end

---计算向量的模，可以以以下的组合方式填写参数：
---```txt
---lstg.GameObject, lstg.GameObject
---lstg.GameObject, x, y
---x, y, lstg.GameObject
---x1, y1, x2, y2
---```
---@param x1 lstg.GameObject|number
---@param y1 lstg.GameObject|number
---@param x2 lstg.GameObject|number|nil
---@param y2 number|nil
---@return number
function m.Dist(x1, y1, x2, y2)
	return 0
end

---设置绑定在游戏对象上的资源的混合模式和顶点颜色
---@param unit lstg.GameObject
---@param blend string
---@param a number @[0~255]
---@param r number @[0~255]
---@param r number @[0~255]
---@param r number @[0~255]
function m.SetImgState(unit, blend, a, r, g, b)
end

---检查指定对象是否在指定的矩形区域内
---@param unit lstg.GameObject
---@param left number
---@param right number
---@param bottom number
---@param top number
---@return boolean
function m.BoxCheck(unit, left, right, bottom, top)
	return true
end

---检查两个对象是否发生碰撞
---@param unitA lstg.GameObject
---@param unitB lstg.GameObject
---@param ignoreworldmask boolean @如果该参数为true，则忽略world掩码
function m.ColliCheck(unitA, unitB, ignoreworldmask)
	return false
end

---设置游戏对象的速度
---@param unit lstg.GameObject
---@param v number
---@param a number
---@param updaterot boolean @如果该参数为true，则同时设置对象的rot
function m.SetV(unit, v, a, updaterot)
end

---@param unit lstg.GameObject
---@return number, number @速度大小，速度朝向
function m.GetV(unit)
	return 0, 0--v,a
end

---执行对象默认渲染方法
---@param unit lstg.GameObject
function m.DefaultRenderFunc(unit)
end

---碰撞组迭代器，如果填写的碰撞组不是有效的碰撞组，则对所有游戏对象进行迭代
---@param groupid number @[0~15]碰撞组
---@return fun(groupid:number):number, lstg.GameObject @第一个返回值为下一个对象的id，第二个返回值为lstg.GameObject
function m.ObjList(groupid)
end

---更改游戏对象上某些属性的值
---@param t lstg.GameObject
---@param k number|string
---@param v any
function m.SetAttr(t, k, v)
	t[k] = v
end

---获取游戏对象上某些属性的值
---@param t lstg.GameObject
---@param k number|string
function m.GetAttr(t, k)
	return t[k]
end

----------------------------------------
---游戏对象上的粒子池

---设置绑定在游戏对象上的粒子特效的混合模式和顶点颜色
---@param unit lstg.GameObject
---@param blend string
---@param a number @[0~255]
---@param r number @[0~255]
---@param r number @[0~255]
---@param r number @[0~255]
function m.SetParState(unit, blend, a, r, g, b)
end

---停止游戏对象上的粒子发射器
---@param unit lstg.GameObject
function m.ParticleStop(unit)
end

---启动游戏对象上的粒子发射器
---@param unit lstg.GameObject
function m.ParticleFire(unit)
end

---获取游戏对象上的粒子发射器的粒子数量
---@param unit lstg.GameObject
---@return number
function m.ParticleGetn(unit)
	return 0
end

---设置粒子发射器的粒子发射密度
---@param unit lstg.GameObject
---@param emission number @每秒发射的粒子数量
function m.ParticleGetEmission(unit, emission)
end

---获取粒子发射器的粒子发射密度
---@param unit lstg.GameObject
---@return number @每秒发射的粒子数量
function m.ParticleGetEmission(unit)
	return 0
end

----------------------------------------
---游戏对象池更新暂停

--[[
---设置游戏对象池下一帧开始暂停更新的时间（帧）
---@param t number
function m.SetSuperPause(t)
end

---更改游戏对象池下一帧开始暂停更新的时间（帧），等效于GetSuperPause并加上t，然后SetSuperPause
---@param t number
function m.AddSuperPause(t)
end

---获取游戏对象池暂停更新的时间（帧），获取的是下一帧的
---@return number
function m.GetSuperPause()
end

---获取当前帧游戏对象池暂停更新的时间（帧）
function m.GetCurrentSuperPause()
end
--]]

----------------------------------------
---游戏对象world掩码

--[==[
---获取当前激活的world掩码
function m.GetWorldFlag()
	return 1
end

---设置当前激活的world掩码
---@param mask number
function m.SetWorldFlag(mask)
end

---判断两个对象是否在同一个world内，当两个游戏对象的world掩码相同或者按位与不为0时返回true
---@param unitA lstg.GameObject
---@param unitB lstg.GameObject
---@return boolean
function m.IsSameWorld(unitA, unitB)
	return true
end

---设置多world的掩码，最多可支持4个不同的掩码，将会在进行碰撞检测的时候用到
---@param maskA number
---@param maskB number
---@param maskC number
---@param maskD number
function m.ActiveWorlds(maskA, maskB, maskC, maskD)
end

---检查两个对象是否存在于相同的world内，参考ActiveWorlds
---@param unitA lstg.GameObject
---@param unitB lstg.GameObject
---@return boolean
function m.CheckWorlds(unitA, unitB)
end
--]==]
