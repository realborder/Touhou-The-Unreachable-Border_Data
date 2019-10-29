local gametest=TUO_Developer_UI:NewModule()

function gametest:init()
    self.name='关卡调试'
    
end
local quickboost=TUO_Developer_UI:NewPanel()
function quickboost:init()
    self.name="快速启动"
    (TDU_New_title(self)).text='关卡列表'

    (TDU_New_value_displayer(self)).monitoring_value=function(self)
        return {{name='stage.current_stage.name',v=stage.current_stage.name}} end
    
    (TDU_New_text_displayer(self)).text='选择难度'
    local diff_list=TDU_New_list_box(self)
    local text_displayer1=TDU_New_text_displayer(self)

    text_displayer1.text='选择关卡'
    local stage_list=TDU_New_list_box(self)
    diff_list._ban_mul_select=true
    stage_list._ban_mul_select=true
    diff_list.refresh=function(self)
        self.display_value={}
        for i,v in ipairs(stage.groups) do
            table.insert(self.display_value,{name=i,v=v})
        end
    end
    diff_list._event_mousepress=function(self)
        local cur
        -- TUO_Developer_Flow:MsgWindow(tostring(#(self.display_value)))
        local i,name,v= TUO_Developer_UI.GetListSingleSel(self)
        if i then cur=i end
        -- for i,v in pairs(self.selection) do
        --     if v then cur=i end break
        -- end
        local d
        if cur then d=self.display_value[cur].v end
        if d then
            stage_list.refresh=function(self)
                self.display_value={}
                for i,v in ipairs(stage.groups[d]) do
                    table.insert(self.display_value,{name=i,v=v})
                end
            end
        end
    end

    (TDU_New_text_displayer(self)).text='选择机体'
    local plr_list=TDU_New_list_box(self)
    plr_list.refresh=function(self)
        self.display_value={}
        for i=1,#player_list do
            table.insert(self.display_value,{name=i,v=player_list[i][1]})
        end
    end

    local start_btn=TDU_New_button(self)
    start_btn.text='快速启动'
    start_btn._event_mouseclick=function(self)
        ----------
            local _stage,plr_index
            local cur
            do
                local i,name,v= TUO_Developer_UI.GetListSingleSel(diff_list)
                if i then 
                    cur=i 
                    -- TUO_Developer_Flow:MsgWindow('关卡'..i)
                else
                    TUO_Developer_Flow:ErrorWindow('无法进入关卡：关卡名错误')
                end
            end

            local d
            if cur then d=diff_list.display_value[cur].v end
            local i,name,v= TUO_Developer_UI.GetListSingleSel(plr_list)
            if i then
                -- TUO_Developer_Flow:MsgWindow('机体'..i)
                plr_index=i
            else
                TUO_Developer_Flow:ErrorWindow('无法进入关卡：机体名错误\n    错误发生位置:  TUOlib\\Dev_Tool\\module\\StageManager\\_init.lua:75') 
            end
        -- if d and plr_index then
            ResetPool()
            if string.find(tostring(stage.current_stage.name),'@',1,true)~=nil then 
                stage.current_stage.task[1]=coroutine.create(function() end)
            end
            
            scoredata.player_select=plr_index
            lstg.var.player_name=player_list[plr_index][2]
            lstg.var.rep_player=player_list[plr_index][3]
            stage.group.Start(stage.groups[d])
        -- end
    end
    local start_btn2=TDU_New_button(self)
    start_btn2.text='单关练习'
    start_btn2._stay_in_this_line=true
    start_btn2._event_mouseclick=function(self)
        local _stage,plr_index
        local cur
        do
            local i,name,v= TUO_Developer_UI.GetListSingleSel(stage_list)
            if i and v then 
                cur=i 
                _stage=v
                -- TUO_Developer_Flow:MsgWindow('关卡'.._stage)
            else
                TUO_Developer_Flow:ErrorWindow('无法进入关卡：关卡名错误')
            end
        end

        local d
        if cur then d=diff_list.display_value[cur].v end
        local i,name,v= TUO_Developer_UI.GetListSingleSel(plr_list)
        if i then
            -- TUO_Developer_Flow:MsgWindow('机体'..i)
            plr_index=i
        else
            TUO_Developer_Flow:ErrorWindow('无法进入关卡：机体名错误\n    错误发生位置:  TUOlib\\Dev_Tool\\module\\StageManager\\_init.lua:75') 
        end
            if string.find(tostring(stage.current_stage.name),'@',1,true)~=nil then 
                stage.current_stage.task[1]=coroutine.create(function() end)
                -- stage.current_stage.task[2]=coroutine.create(function() end)
                stage.group.FinishStage()
            end
            ResetPool()
            scoredata.player_select=plr_index
            lstg.var.player_name=player_list[plr_index][2]
            lstg.var.rep_player=player_list[plr_index][3]
            stage.group.PracticeStart(_stage)
    end


    (TDU_New_value_displayer(self)).monitoring_value='stage.groups'
end
local modmgr=TUO_Developer_UI:NewPanel()
function modmgr:init()
    self.name="mod包管理"



    (TDU_New_title(self)).text='mod包列表'
    (TDU_New_text_displayer(self)).text='以下是所有mod文件夹中有zip后缀名的文件列表，已默认加载文件名中带有\n“STAGE”的文件。\n请注意，安全模式仅保证加载mod时出错不会使游戏报错退出，不保证运行时\n出错退出。'
    
    local list=TDU_New_list_box(self)
    list.refresh=function(self)
        self.display_value={}
        for k,v in pairs(tuolib.mod_manager.modlist) do
            table.insert(self.display_value,{name=k,v=tostring(v)})
        end
    end
    local title2=TDU_New_title(self,'slot2')
    title2.text='操作'

    local swc_reload=TDU_New_switch(self,'slot2')
    swc_reload.text_on='保护模式 开'
    swc_reload.text_off='保护模式 关'
    swc_reload.monitoring_value='tuolib.mod_manager.protect_mode'
    local btn_refresh=TDU_New_button(self,'slot2')
    btn_refresh.text='刷新列表'
    btn_refresh._event_mouseclick=function(self)
        tuolib.mod_manager:RefreshModList()
    end
    local btn_reload=TDU_New_button(self,'slot2')
    btn_reload.text='加载Mod'
    btn_reload._event_mouseclick=function(self)
        for k,v in pairs(list.display_value) do
            if list.selection[k] then
                -- local r=lstg.FindFiles('_editor_output.lua',v.name)
                -- TUO_Developer_Flow:MsgWindow(tostring(r))
                local r,err=tuolib.mod_manager.LoadMod(v.name)
                if not r then TUO_Developer_Flow:ErrorWindow(err) 
                else 
                    TUO_Developer_Flow:MsgWindow('成功加载：'..v.name) 
                    InitAllClass()
                end
            end
        end
    end
    local btn_reloadall=TDU_New_button(self,'slot2')
    btn_reloadall.text='卸载Mod'
    btn_reloadall._event_mouseclick=function(self)
        for k,v in pairs(list.display_value) do
            if list.selection[k] then
                tuolib.mod_manager.UnloadMod(v.name)
                TUO_Developer_Flow:MsgWindow('成功卸载：'..v.name)
            end
        end    end
    local totop=TDU_New_button(self,'slot2')
    totop.text='回到顶部'
    totop.gap_t=12
    totop._event_mouseclick=function(widget) widget.panel.y_offset_aim=0 end
    local rev=TDU_New_button(self,'slot2')
    rev.text='反转逻辑值'
    rev._event_mouseclick=function(widget)  
        for k,v in pairs(list.display_value) do
            if list.selection[k] then
                tuolib.mod_manager.modlist[v.name]=not tuolib.mod_manager.modlist[v.name]
            end
        end
    end
    local revsel=TDU_New_button(self,'slot2')
    revsel.text='反选'
    revsel.gap_t=12
    revsel._event_mouseclick=function(widget) 
        for i=1,#list.display_value do
            list.selection[i]=not list.selection[i]
        end
    end
    local selall=TDU_New_button(self,'slot2')
    selall.text='全选'
    selall._event_mouseclick=function(widget) 
        list.selection={}
        for i=1,#list.display_value do
            list.selection[i]=true
        end
    end
    local diselall=TDU_New_button(self,'slot2')
    diselall.text='全不选'
    diselall._event_mouseclick=function(widget) 
        list.selection={}
    end


end
local steptest=TUO_Developer_UI:NewPanel()
function steptest:init()
    self.name="步进调试"
    self.ban_framefunc_timer=0
    self.left_for_world=true
    -- local world_switch=TDU_New_switch(self,'world')
    -- world_switch._event_switched=function(self,v)
        -- steptest.left_for_world=v end
    TUO_Developer_UI:SetWidgetSlot('world')
    TDU_New'title'(self).text='步进调试'
    local sw1=TDU_New'switch'(self)
    sw1.monitoring_value='TUO_Developer_Tool_kit.ban_framefunc'
    sw1.text_on='已冻结帧函数'
    sw1.text_off='已解冻帧函数'
    local sw2=TDU_New'switch'(self)
    sw2.monitoring_value='TUO_Developer_Tool_kit.ban_renderfunc'
    sw2.text_on='已冻结帧渲染函数'
    sw2.text_off='已解冻帧渲染函数'
    local btn1=TDU_New'button'(self)
    btn1.text='前进一帧'
    btn1._event_mouseclick=function (widget)
        TUO_Developer_Tool_kit.ban_framefunc=false
        steptest.ban_framefunc_timer=1
    end
end
function steptest:frame()
    self.ban_framefunc_timer=self.ban_framefunc_timer-1
    if self.ban_framefunc_timer==0 then TUO_Developer_Tool_kit.ban_framefunc=true end
    
end