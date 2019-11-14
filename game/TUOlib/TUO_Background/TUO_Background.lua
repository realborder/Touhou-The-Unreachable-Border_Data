local m = {}
tuolib.BGHandler = m
local PATH = "TUOlib/TUO_Background/"

------------------------------------
---卸载某个资源
---@param texname string
---@return boolean
function UnLoadImageAndTex(texname)
    local pool = CheckRes("tex", texname)
    if pool then
        RemoveResource(pool, 1, texname)
        RemoveResource(pool, 2, texname)
        return true
    end
    return false
end

------------------------------------
---背景初始化
function m:init()
    self.list = {}
    self:LoadAllBG()
    --为了模拟震动效果留的，因为计算涉及三维向量，暂且偷个懒
    self.camera_offset=0
end

------------------------------------
---模块专用DoFile
function m:DoFile(path, arch)
    local r, err = xpcall(lstg.DoFile, debug.traceback, path, arch)
    if r then
        Print("成功读取背景脚本：" .. path, 2)
        return true
    else
        Print("读取脚本：" .. path .. " 的时候发生错误\n\t错误详细信息:\n\t\t" .. err, 1)
        if TUO_Developer_Flow then
            TUO_Developer_Flow:ErrorWindow(err)
        end
        return r, err
    end
end

function m.LoadSingleBG(name)
    m:DoFile(m.list[name])
    InitSingleClass(_G[name])
end




------------------------------------
---载入背景库中的背景
function m:LoadAllBG()
    local folder = lstg.FileManager.EnumFilesEx(PATH)
    for i, v in ipairs(folder) do
        local name, isfolder = v[1], v[2]
        if isfolder then
            local flag = false
            for _, _v in pairs(m.list) do
                if _v == name then
                    flag = true
                    break
                end
            end
            local v1, v2 = string.find(name, PATH)
            local v3 = string.find(name, "/", v2 + 1)
            local objname = string.sub(name, v2 + 1, v3 - 1)
            local path = name .. objname .. ".lua"
            if not flag then
                m.list[objname] = path
            end
            m:DoFile(path)
        end
    end
    InitAllClass()
end

-----------------------
---常用的补间函数
---分别为：线性，加速减速，加速，减速，惯性，惯性加速，惯性减速
local K_INERTIA = 1.09
m.itpl = {
    ["LINEAR"] = function(v1, v2, t)
        return v1 + (v2 - v1) * t
    end,
    ["ACC_DEC"] = function(v1, v2, t)
        return v1 + (v2 - v1) * ((-cos(180 * t)) + 1) / 2
    end,
    ["ACC"] = function(v1, v2, t)
        return v1 + (v2 - v1) * sin(90 * t)
    end,
    ["DEC"] = function(v1, v2, t)
        return v1 + (v2 - v1) * (1 - cos(90 * t))
    end,
    ["INERTIA"] = function(v1, v2, t)
        return v1 + (v2 - v1) * ((sin(K_INERTIA * 180 * (t - 0.5))) / (2 * sin(K_INERTIA * 0.5 * 180)) + 0.5)
    end,
    ["INERTIA_DEC"] = function(v1, v2, t)
        return v1 + (v2 - v1) * (sin(K_INERTIA * 90 * t)) / (sin(K_INERTIA * 90))
    end,
    ["INERTIA_ACC"] = function(v1, v2, t)
        return v1 + (v2 - v1) * (1 - (sin(K_INERTIA * 90 * (1 - t))) / (sin(K_INERTIA * 90)))
    end
}

----------------------------
---切换phase的操作
---让背景完全由timer来控制，如此一来调试和控制来说会非常方便
---@param self table
function m.DoPhaseLogic(self, InitPhase)
    local ph = self.phaseinfo
    --初始化
    if InitPhase then
        self.stt = sp.copy(ph[InitPhase], true)
        self.cur = sp.copy(ph[InitPhase], true)
    -- Print(string.format('eye:%.2f ,%.2f %.2f',self.cur.eye[1],self.cur.eye[2],self.cur.eye[3]))
    end
    --phase切换逻辑+3d参数补间
    --触发条件是当前的timer正好为phaseinfo里写的time，这时会重新设置stt
    --过渡段也是靠timer直接算的
    --变换完成后才会执行视角摇晃等操作（暂定）
    for i, v in pairs(ph) do
        if self.timer == v.time then
            --把当前状态作为起始状态
            self.stt = sp.copy(self.cur, true)
        end
        ---timer落入duration内
        if self.timer >= v.time and self.timer <= v.time + v.duration then
            local t = (self.timer - v.time) / v.duration
            local itpl = m.itpl[v.itpl] or m.itpl["ACC_DEC"] --指定补间模式
            for name, para in pairs(self.cur) do
                if type(para) == "table" then --避开time和duration两个项
                    for _i, _v in ipairs(para) do
                        self.cur[name][_i] = itpl(self.stt[name][_i], self.phaseinfo[i][name][_i], t)
                    end
                end
            end
        else --timer没落入duration内但是……这个再说吧，可能用不上呢
        end
    end

end

function m.Apply3DParamater(self)
        --应用参数
        -- Print(string.format("eye:%.2f ,%.2f %.2f", self.cur.eye[1], self.cur.eye[2], self.cur.eye[3]))
        -- Print(string.format("eye:%.2f ,%.2f %.2f", self.cur.at[1], self.cur.at[2], self.cur.at[3]))
    
        local cur = self.cur
        Set3D("eye", cur.eye[1], cur.eye[2], cur.eye[3])
        Set3D("at", cur.at[1], cur.at[2], cur.at[3])
        Set3D("up", cur.up[1], cur.up[2], cur.up[3])
        Set3D("fog", cur.fogdist[1], cur.fogdist[2], Color(255, cur.fogc[1], cur.fogc[2], cur.fogc[3]))
        Set3D("z", cur.z[1], cur.z[2])
        Set3D("fovy", cur.fovy[1])
end    

----------------------------------
---获背景当前的阶段索引
---@param self table
function m.GetCurPhase(self)
    if not IsValid(self) then return end
    if not self.phaseinfo then return end
    for i, v in ipairs(self.phaseinfo) do
        if self.timer < v.time then
            return max(1,i-1)
        end
    end
    return #self.phaseinfo
end
----------------------------------
---获取背景脚本某个阶段的信息
function m.GetPhaseInfo(self, phase)
    phase = phase or 1
    return self.phaseinfo[phase]
end
local tbl = [[
    return {
%s
}]]
local p1 =
    [[
    {
        time=%d,
        duration=%d,
        itpl="%s",
        eye={%.3f,%.3f,%.3f},
        at={%.3f,%.3f,%.3f},
        up={%.3f,%.3f,%.3f},
]]
local p2 =
    [[
        fogdist={%.3f,%.3f},
        fogc={%d,%d,%d},
        z={%.3f,%.3f},
        fovy={%.3f}
    },
]]

function m.SavePhaseInfo(self, name)
    local strtmp={}
    local ret=''
    for i,v in ipairs(self.phaseinfo) do
        table.insert(strtmp,
            string.format('%s%s',
                string.format(p1,v.time,v.duration,v.itpl,v.eye[1],v.eye[2],v.eye[3],v.at[1],v.at[2],v.at[3],v.up[1],v.up[2],v.up[3]),
                string.format(p2,v.fogdist[1],v.fogdist[2],v.fogc[1],v.fogc[2],v.fogc[3],v.z[1],v.z[2],v.fovy[1])
            )
        )
    end
    for i,v in ipairs(strtmp) do
        ret=ret..v
    end
    ret=string.format(tbl,ret)
    local f,msg
	f,msg=io.open(PATH..name..'/_phase_info.lua','w')
    if f==nil then
        TUO_Developer_Flow:ErrorWindow(msg)
	else
		f:write(ret)
		f:close()
	end
end

m:init()
