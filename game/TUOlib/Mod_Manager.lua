tuolib.mod_manager={}
local m=tuolib.mod_manager
local self=m
local PATH='mod'
function m:init(load_now)
    self.modlist=self.modlist or {} 
    self:RefreshModList()
    self.protect_mode=true
    if load_now then
        local result,ret = self:LoadAllStageMod() 
        if not result then
            for k,v in pairs(ret) do
                if not v.ret then
                    Print('Mod出错'..v.err)
                end
            end
        end    
    end
end
function m:DoFile(path,arch)
    if self.protect_mode then
        local r,err=xpcall(lstg.DoFile,debug.traceback,path,arch)
        if r then 
            Print('成功重载脚本：'..path..arch,2)
            return true
        else
            Print('重载脚本：'..path..' 的时候发生错误\n\t错误详细信息:\n\t\t'..err,1)
            return r,err
        end
    else
        lstg.DoFile(path,arch)
        return true
    end
end


---RefreshModList
---刷新mod列表，
function m:RefreshModList()
    if lfs.attributes(PATH)==nil then return false end 
    local old_mod_list=self.modlist
    self.modlist={}
    local mods=plus.EnumFiles(PATH)
	for i,v in pairs(mods) do
        local flag
        flag=not v.isDirectory
        flag=flag and (string.find(v.name,'.zip',1,true) or string.find(v.name,'.pack',1,true))
        if flag then
            self.modlist[PATH..'\\'..v.name]=false
            if old_mod_list[PATH..'\\'..v.name] then self.modlist[PATH..'\\'..v.name]=true end
        end
    end
    return true
end

function m:GetModList()
    return self.modlist
end
function m.LoadMod(arch)
    local hasPassWord=string.find(arch,'pw',1,true)
    if hasPassWord then lstg.LoadPackSub(arch) else lstg.LoadPack(arch) end
    local r,err=self:DoFile("_editor_output.lua",arch)
    if r then
        self.modlist[arch]=true
    else
        self.UnloadMod(arch)
        self.modlist[arch]=false
    end
    InitAllClass()
    return r,err
end
function m.UnloadMod(arch)
    UnloadPack(arch)
    self.modlist[arch]=false
end
function m.LoadAllStageMod()
    local ret={}
    local result=true
    local target={"1","2","3","4","5","6A","6B","EX"}
    local tmp_k={}
    for k,v in pairs(self.modlist) do
        for i=1,#target do
            if not tmp_k[i] then
                if string.find(k,'STAGE'..target[i],1,true)~=nil then
                    tmp_k[target[i]]=k
                end
            end
        end
    end
    for i,v in ipairs(target)  do
        if tmp_k[v] then
            --local hasPassWord=string.find(tmp_k[v],'pw',1,true)
            local r,e=self.LoadMod(tmp_k[v])
            table.insert(ret,{ret=r,err=e})
            result=result and r
        end
    end
    return result,ret
end
m:init()