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

m:init()