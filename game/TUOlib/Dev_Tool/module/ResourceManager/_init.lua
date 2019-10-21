local ResourceManager=TUO_Developer_UI:NewModule()

function ResourceManager:init()
    self.name='游戏资源管理'
    
end
local res_type_t={"[1]纹理","[2]图像","[3]动画","[4]音乐","[5]音效","[6]粒子","[7]纹理字体","[8]TTF字体","[9]shader"}
local st={}
for i=1,#res_type_t do
    st[i]=TUO_Developer_UI:NewPanel()
    local set=st[i]
    function set:init()
        local l1,l2
        local search=''    
        self.name=res_type_t[i]
        TDU_New_title(self).text='全局池'
        TDU_New_value_displayer(self).monitoring_value=function()
            return {{name='数量',v=#(l1.display_value)}}
        end
        l1=TDU_New_list_box(self)
        l1.sortfunc=function(v1,v2)  return v1.v<v2.v end
        l1.monitoring_value=function()
            local t1,t2=lstg.EnumRes(i)
            local  out={}
            for k,v in pairs(t1) do
                if search=='' or search==nil then
                    table.insert(out,{name='',v=v})
                else
                    if string.find(v,search)~=nil then
                        table.insert(out,{name='',v=v})
                    end
                end
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
                if search=='' or search==nil then
                    table.insert(out,{name='',v=v})
                else
                    if string.find(v,search)~=nil then
                        table.insert(out,{name='',v=v})
                    end
                end
            end
            return out
        end

        TDU_New_title(self,'slot2').text='操作'
        local totop=TDU_New_button(self,'slot2')
        totop.text='回到顶部'
        totop._event_mouseclick=function(self) set.y_offset_aim=0 end
        local preview=TDU_New_button(self,'slot2')
        preview.text='预览'
        preview._event_mouseclick=function(self) set.y_offset_aim=0 end
        local toglobal=TDU_New_button(self,'slot2')
        toglobal.text='切换到关卡池'
        toglobal.mode=0
        toglobal._event_mouseclick=function(self)
            if self.mode==0 then
                toglobal.text='切换到全局池'
                self.mode=1
                l1.visiable=false
                -- l2.visiable=true
            else
                toglobal.text='切换到关卡池'
                self.mode=0
                l1.visiable=true
                -- l2.visiable=false
            end
        end
        local txt2=TDU_New_text_displayer(self,'slot2')
        txt2.text='输入文字以筛选'
        txt2.gap_t=12
        local txt=TDU_New_inputer(self,'slot2')
        txt.text=''
        txt.width=120
        txt._event_textchange=function(self)
            search=self.text
        end
        local btnclr=TDU_New_button(self,'slot2')
        btnclr.text='清除'
        btnclr.width=64
        btnclr._event_mouseclick=function(self)
            txt.text=''
            search=nil
        end

    end



    
end
local preview=TUO_Developer_UI:NewPanel()
function preview:init()
    self.name='预览'

end