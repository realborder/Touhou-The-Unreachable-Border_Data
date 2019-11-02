local m={}
tuolib.BGHandler=m


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
function m.init()

end



------------------------------------
---载入背景库中的背景
function m.LoadAllBG()


end