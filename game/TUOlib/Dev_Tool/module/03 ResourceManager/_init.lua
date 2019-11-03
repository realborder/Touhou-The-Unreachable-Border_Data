local ResourceManager=TUO_Developer_UI:NewModule()

function ResourceManager:init()
    self.name='游戏资源管理'
    
end

local preview=TUO_Developer_UI:NewPanel()
function preview:init()
    self.name='[0]脚本'
    local list
    local search=''
    Neww'title'.text='已加载的脚本'
    Neww'text_displayer'.text= '这个列表显示了已经载入的脚本。\n重载游戏会把游戏整个重载掉。\nsave和load按钮可以保存和载入您的选区信息。(没有实装）'
    list=Neww'list_box'
    list.monitoring_value=lstg.included
    list.monitoring_value=function()
        local t1=lstg.included
        local out={}
        for k,v in pairs(t1) do
            if search=='' or search==nil then
                table.insert(out,{name=k,v=v})
            else
                if string.find(k,search)~=nil then
                    table.insert(out,{name=k,v=v})
                end
            end
        end
        return out
    end

    TUO_Developer_UI.SetWidgetSlot'slot2'
    Neww'title'.text='操作'
    local btn1=Neww'button'
    btn1.text='重载 (F10)'
    local func=function(widget)  
        local dis=list.display_value
        local v_tmp={}
        for i,v in pairs(dis) do
            if list.selection[i] then 
                table.insert(v_tmp,v.name) 
            end
            
        end
        local r=TUO_Developer_Tool_kit.ReloadFiles(v_tmp)
        InitAllClass()
        return r
    end
    btn1._event_mouseclick=func
    TUO_Developer_Tool_kit.ReloadSelectedFile=func
    local sw1=Neww'switch'
    sw1.text_on='实时重载 开启'
    sw1.text_off='实时重载 关闭'
    sw1.frame=function(widget)
        if widget.flag then
            local ret=func()
            if not ret then
                widget.flag=false
            end
        end
    end

    local totop=Neww'button'
    totop.text='回到顶部'
    totop.gap_t=10
    totop._event_mouseclick=function(self) preview.y_offset_aim=0 end

    local btn2=Neww'button'
    btn2.text='反转'
    btn2._event_mouseclick=function(widget)  
        local dis=list.display_value
        local v_tmp={}
        for i,v in pairs(dis) do
            if list.selection[i] then 
                lstg.included[v.name]=not lstg.included[v.name]
            end
        end
    end
    -- local btn3=Neww'button'
    -- btn3.text='重载游戏'
    -- btn3._event_mouseclick=function(widget) 
        -- ResetPool()
        -- lstg.included={}
        -- stage.Set('none', 'init') 
        -- lstg.DoFile('core.lua')
    -- end
    local btn4=Neww'button'
	btn4.text='全选'
    btn4._event_mouseclick=function(widget) 
        list.selection={}
        for i=1,#(list.display_value) do
            list.selection[i]=true
        end
    end
    local btn5=Neww'button'
	btn5.text='全不选'
	btn5._event_mouseclick=function(widget) 
        list.selection={}
    end
    
    local txt2=Neww'text_displayer'
    txt2.text='输入文字以筛选'
    txt2.gap_t=12
    local txt=Neww'inputer'
    txt.text=''
    txt.width=120
    txt._event_textchange=function(self)
        search=self.text
    end
    local btnclr=Neww'button'
    btnclr.text='清除'
    btnclr.width=64
    btnclr._event_mouseclick=function(self)
        txt.text=''
        search=nil
    end

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
        Neww'title'.text='全局池'
        Neww'value_displayer'.monitoring_value=function()
            return {{name='数量',v=#(l1.display_value)}}
        end
        l1=Neww'list_box'
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
        Neww'title'.text='关卡池'
        Neww'value_displayer'.monitoring_value=function()
            return {{name='数量',v=#(l2.display_value)}}
        end
        l2=Neww'list_box'
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


        
        TUO_Developer_UI.SetWidgetSlot('slot2')
        Neww'title'.text='操作'
        local totop=Neww'button'
        totop.text='回到顶部'
        totop._event_mouseclick=function(self) set.y_offset_aim=0 end
        local preview=Neww'button'
        preview.text='预览'
        preview._event_mouseclick=function(self) TUO_Developer_Flow:MsgWindow('该功能开发中，下个快照见！') end
        local toglobal=Neww'button'
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
        local txt2=Neww'text_displayer'
        txt2.text='输入文字以筛选'
        txt2.gap_t=12
        local txt=Neww'inputer'
        txt.text=''
        txt.width=120
        txt._event_textchange=function(self)
            search=self.text
        end
        local btnclr=Neww'button'
        btnclr.text='清除'
        btnclr.width=64
        btnclr._event_mouseclick=function(self)
            txt.text=''
            search=nil
        end

    end



    
end
