local m={}
tuolib.BGHandler=m
local PATH='TUOlib/TUO_Background/'

------------------------------------
---卸载某个资源
---@param texname string
---@return boolean
function UnLoadImageAndTex(texname)
    local pool=CheckRes('tex',texname)
    if pool then
        RemoveResource(pool,1,texname)
        RemoveResource(pool,2,texname)
        return true
    end
    return false
end 

------------------------------------
---背景初始化
function m:init()
    self.list={}
    self:LoadAllBG()
end

function m:DoFile(path,arch)
    local r,err=xpcall(lstg.DoFile,debug.traceback,path,arch)
    if r then 
        Print('成功读取背景脚本：'..path,2)
        return true
    else
        Print('读取脚本：'..path..' 的时候发生错误\n\t错误详细信息:\n\t\t'..err,1)
        if TUO_Developer_Flow then TUO_Developer_Flow:ErrorWindow(err) end
        return r,err
    end
end



------------------------------------
---载入背景库中的背景
function m:LoadAllBG()
    local folder=lstg.FileManager.EnumFilesEx(PATH)
    for i,v in ipairs(folder) do
        local name,isfolder=v[1],v[2]
        if isfolder then
            local flag=false
            for _,_v in pairs(m.list) do
                if _v==name then flag=true break end
            end
            local v1,v2=string.find(name,PATH)
            local v3=string.find(name,'/',v2+1)
            local objname=string.sub(name,v2+1,v3-1)
            local path=name..objname..'.lua'
            if not flag then m.list[objname]=path end
            m:DoFile(path)
        end
    end
    InitAllClass()
end

-----------------------
---默认的补间函数
local function itpl(v1,v2,t)
    return v1+(v2-v1)*(-cos(180*t)+1)/2
end


----------------------------
---切换phase的操作
---让背景完全由timer来控制，如此一来调试和控制来说会非常方便
---@param self table
function m.DoPhaseLogic(self,InitPhase)
    local ph=self.phaseinfo
    --初始化
    if InitPhase then
        self.stt=sp.copy(ph[InitPhase],true)
        self.cur=sp.copy(ph[InitPhase],true)
        -- Print(string.format('eye:%.2f ,%.2f %.2f',self.cur.eye[1],self.cur.eye[2],self.cur.eye[3]))
    end
    --phase切换逻辑+3d参数补间
        --触发条件是当前的timer正好为phaseinfo里写的time，这时会重新设置stt
        --过渡段也是靠timer直接算的
        --变换完成后才会执行视角摇晃等操作（暂定）
        for i,v in pairs(ph) do
            if self.timer==v.time then
                --把当前状态作为起始状态
                self.stt=sp.copy(self.cur,true)
            end
            ---timer落入duration内
            if self.timer>=v.time and self.timer<=v.time+v.duration then
                local t=(self.timer-v.time)/v.duration
                local itpl = v.itpl or itpl --使用默认的补间函数或者指定的
                for name,para in pairs(self.cur) do
                    if type(para)=='table' then --避开time和duration两个项
                        for _i,_v in ipairs(para) do
                            self.cur[name][_i]=itpl(self.stt[name][_i],self.phaseinfo[i][name][_i],t)
                        end
                    end
                end
            else --timer没落入duration内但是……这个再说吧，可能用不上呢

            end
        end

    --应用参数
    Print(string.format('eye:%.2f ,%.2f %.2f',self.cur.eye[1],self.cur.eye[2],self.cur.eye[3]))
    Print(string.format('eye:%.2f ,%.2f %.2f',self.cur.at[1],self.cur.at[2],self.cur.at[3]))

    local cur=self.cur
    Set3D('eye',cur.eye[1],cur.eye[2],cur.eye[3])
    Set3D('at',cur.at[1],cur.at[2],cur.at[3])
    Set3D('up',cur.up[1],cur.up[2],cur.up[3])
    Set3D('fog',cur.fogdist[1],cur.fogdist[2],Color(255,cur.fogc[1],cur.fogc[2],cur.fogc[3]))
    Set3D('z',cur.z[1],cur.z[2])
    Set3D('fovy',cur.fovy[1])
end

function m.GetCurPhase(self)
    for i,v in ipairs(self.cur) do
        if self.timer>v.time then
            return i
        end
    end
    return 0
end


m:init()