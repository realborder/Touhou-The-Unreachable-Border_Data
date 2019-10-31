local exani=TUO_Developer_UI:NewModule()

function exani:init()
    self.name='复杂动画系统'
end

local exani_display=TUO_Developer_UI:NewPanel()
function exani_display:init()
    self.name="exani对象"
	TDU_New_title(self).text='exani列表'
	TDU_New_text_displayer(self).text='全部exani'
	
    local exani_list=TDU_New_list_box(self)
	exani_list._ban_mul_select=true
	exani_list.refresh=function(self)
        self.display_value={}
        for i,v in ipairs(play_manager.exanis) do
            table.insert(self.display_value,{name=i,v=v.name})
        end
    end
	
	TDU_New_text_displayer(self).text='活动exani'
	local active_exani_list=TDU_New_object_list(self)
	active_exani_list.width=500
	active_exani_list._ban_mul_select=true
	active_exani_list.refresh=function(self)
        self.display_value={}
        for _k,_v in ipairs(play_manager.exanis) do
            if _v.isInPlay then
				--local _v_string="viewmode:".._v.viewmode.."	layer:".._v.layer.."	current_frame:".._v.current_frame.."	start_frame:".._v.start_frame..
				--				"	end_frame:".._v.end_frame.."	replay_round:".._v.replay_round.."	play_interval:".._v.play_interval
				table.insert(self.display_value,{name=_v.name,v={viewmode=_v.viewmode,layer=_v.layer,isStop=_v.isStop,current_frame=_v.current_frame,start_frame=_v.start_frame,
													end_frame=_v.end_frame,replay_round=_v.replay_round,play_interval=_v.play_interval}})
			end
        end
    end
end

