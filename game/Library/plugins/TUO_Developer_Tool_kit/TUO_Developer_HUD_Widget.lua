
---@type TemplateWidget table
TUO_Developer_HUD.TemplateWidget={
    ['_GENERAL']={
        --鼠标是否停留
        _mouse_stay=false,
        --点燃计时器，鼠标停留在控件上就会使其处于点燃状态
        _ignite_timer=0,
        _focus=false,
        _focus_timer=0,
        _getfocus=function(self)
        end,
        _lostfocus=function(self)
        end,
        l=0,r=0,b=0,t=0
    },
    ['value_displayer']={
        initfunc=function(self)
        end,
        framefunc=function(self)
        end,
        renderfunc=function(self)
        end,
        monitoring_value=nil,
        display_value={},
        value_pre={},
        value_change={}
    },
    ['button']={
        initfunc=function(self)
        end,
        framefunc=function(self)
        end,
        renderfunc=function(self)
        end,
        event_click=function(self,mouse_key)
        end,
    },
    ['text_displayer']={
        initfunc=function(self)
        end,
        framefunc=function(self)
        end,
        renderfunc=function(self)
        end
    },
    ['value_gauge']={
        initfunc=function(self)
        end,
        framefunc=function(self)
        end,
        renderfunc=function(self)
        end
    },
    ['value_slider']={
        initfunc=function(self)
        end,
        framefunc=function(self)
        end,
        renderfunc=function(self)
        end,
        event_change=function(self,value)
        end
    },
    ['list']={
        initfunc=function(self)
        end,
        framefunc=function(self)
        end,
        renderfunc=function(self)
        end,
        event_click=function(self,mouse_key)
        end,
    },
    ['texture_diaplayer']={
        initfunc=function(self)
        end,
        framefunc=function(self)
        end,
        renderfunc=function(self)
        end
    },
    ['inputer']={
        initfunc=function(self)
        end,
        framefunc=function(self)
        end,
        renderfunc=function(self)
        end,
        event_text_change=function(self)
        end
    },


}


function TUO_Developer_HUD:AddWidgetTemplate(name,initfunc,framefunc,renderfunc)
        self.TemplateWidget[name]={
            initfunc=initfunc,
            framefunc=framefunc,
            renderfunc=renderfunc
        }
end


------------------------------------------------------
---以模板新建控件
---@param panel panel 
---@param x_pos number
---@param template TemplateWidget
---@param para table
function TUO_Developer_HUD:NewWidget(panel,x_pos,template,para)
    local tpl=self.TemplateWidget[template]
    local tmp_widget={
        _x_pos=x_pos
    }
    if not tpl then return error('Template \"'..template..'\" dosen\'t exist!') end
    local tmpfunc
    --迁移参数混合函数到控件内部
    for k,v in pairs(para) do
        if k=='initfunc' or k=='framefunc' or k=='renderfunc' then
            local tmpfunc=tpl[k]
            if type(para[k])=='function' then tmpfunc=function(self) tmpfunc(self) para[k](self) end end
            tmp_widget[k]=tmpfunc
        else
            tmp_widget[k]=v end end
    self.WidgetList[#self.WidgetList+1]=tmp_widget
    table.insert(panel.WidgetList,tmp_widget)
end

