local exani=TUO_Developer_UI:NewModule()

function exani:init()
    self.name='复杂动画系统'
end

local exani_display=TUO_Developer_UI:NewPanel()
function exani_display:init()
    self.name="exani对象"
	Neww'title'.text='exani列表'
	Neww'text_displayer'.text='全部exani'
	
    local exani_list=Neww'list_box'
	exani_list._ban_mul_select=true
	exani_list.refresh=function(self)
        self.display_value={}
        for i,v in ipairs(play_manager.exanis) do
            table.insert(self.display_value,{name=i,v=v.name})
        end
    end
	
	Neww'text_displayer'.text='活动exani'
	local active_exani_list=Neww'object_list'
	active_exani_list.width=500
	active_exani_list._ban_mul_select=true
	active_exani_list.refresh=function(self)
        self.display_value={}
        for _k,_v in ipairs(play_manager.exanis) do
            if _v.isInPlay then
                table.insert(self.display_value,{name=i,v=_v.name})
			end
        end
    end
end

