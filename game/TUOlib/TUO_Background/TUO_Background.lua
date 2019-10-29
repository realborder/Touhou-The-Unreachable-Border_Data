tuolib.BGHandler={}



function UnLoadImageAndTex(texname)
    local pool=CheckRes('tex',texname)
    if pool then
        RemoveResource(pool,1,texname)
        RemoveResource(pool,2,texname)
    end
end 