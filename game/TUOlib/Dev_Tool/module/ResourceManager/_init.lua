local ResourceManager=TUO_Developer_UI:NewModule()

function ResourceManager:init()
    self.name='游戏资源管理'
    
end
local res_type_t={"[1]纹理","[2]图像","[3]动画","[4]音乐","[5]音效","[6]粒子","[7]纹理字体","[8]TTF字体","[9]shader"}
local st={}
for i=1,#res_type_t do
    st[i]=TUO_Developer_UI:NewPanel()
    local setting=st[i]
    function setting:init()
        self.name=res_type_t[i]
        TDU_New_title(self).text='全局池'
        local l1,l2
        TDU_New_value_displayer(self).monitoring_value=function()
            return {{name='数量',v=#(l1.display_value)}}
        end
        l1=TDU_New_list_box(self)
        l1.sortfunc=function(v1,v2)  return v1.v<v2.v end
        l1.monitoring_value=function()
            local t1,t2=lstg.EnumRes(i)
            local  out={}
            for k,v in pairs(t1) do
                table.insert(out,{name='',v=v})
            end
            return out
        end
        TDU_New_title(self).text='关卡池'
        TDU_New_value_displayer(self).monitoring_value=function()
            return {{name='数量',v=#(l2.display_value)}}
        end
        l2=TDU_New_list_box(self)
        l2.sortfunc=function(v1,v2)  return v1.v<v2.v end
        l2.monitoring_value=function()
            local t1,t2=lstg.EnumRes(i)
            local  out={}
            for k,v in pairs(t2) do
                table.insert(out,{name='',v=v})
            end
            return out
        end
    end
end