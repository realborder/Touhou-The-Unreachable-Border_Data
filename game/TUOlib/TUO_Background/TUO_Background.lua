tuolib.BGHandler={}


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