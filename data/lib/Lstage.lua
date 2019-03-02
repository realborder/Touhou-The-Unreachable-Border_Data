--======================================
--luastg stage
--======================================

----------------------------------------
--单关卡

stage={stages={}}

function stage.init(self) end
function stage.frame(self) end
function stage.render(self) end
function stage.del(self) end

function stage.New(stage_name,as_entrance,is_menu)
	local result={init=stage.init,
			del=stage.del,
			render=stage.render,
			frame=stage.frame,
			}
	if as_entrance then stage.next_stage=result end
	result.is_menu=is_menu
	result.stage_name=tostring(stage_name)
	stage.stages[stage_name]=result
	return result
end

function stage.Set(stage_name)--于ext中重载
	stage.next_stage=stage.stages[stage_name]
	KeyStatePre={}
end

function stage.SetTimer(t)
	stage.current_stage.timer=t-1
end

function stage.QuitGame()
	lstg.quit_flag=true
end
