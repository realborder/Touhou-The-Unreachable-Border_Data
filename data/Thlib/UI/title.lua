stage_init=stage.New('init',true,true)
function stage_init:init()
    New(mask_fader,'open')
    jstg.enable_player=true
end
function stage_init:frame()
    if self.timer>=30 then stage.Set('none', 'menu') end
end
function stage_init:render()
    ui.DrawMenuBG()
end

stage_menu=stage.New('menu',false,true)

function stage_menu:update()
    local content=self.content
    for i=1,#content do if content[i][1]~='exit' then self.text[i]=content[i][1] self.func[i]=content[i][2] end end
end
local function getdelay(d)
    if d==-1 then return 'Auto' end
    return ''..d
end
function stage_menu:init()
    local menu_title,menu_player_select,menu_difficulty_select,menu_replay_loader,menu_replay_saver,menu_items,menu_sc_pr
    local menu_network
    local menu_player_select2,menu_player_select1,menu_playercount
    local menu_list={}
    local reset_pos=function()--重置菜单pos至1号位
        for _,m in pairs(menu_list) do
            if IsValid(m) then m.pos=1 end
        end
    end
    stage_menu.reset_pos = reset_pos
    local p1ok=1
    local p2ok=1
    jstg.enable_player=true
    if _title_flag==nil then _title_flag=true else New(mask_fader,'open') end
    --
    local function ExitGame()
    task.New(stage_menu,function()
        for i=1,60 do SetBGMVolume('menu',1-i/60) task.Wait() end
            end)
        task.New(stage_menu,function()
            menu.FlyOut(menu_title,'right')
            task.Wait(60)
            stage.QuitGame()
        end)
    end
    --
    menu_items={{'Start Game',function() practice=nil menu.FlyIn(menu_difficulty_select,'right') menu.FlyOut(menu_title,'left') end}}
    if _allow_practice then table.insert(menu_items,{'Stage Practice',function() practice='stage' menu.FlyIn(menu_difficulty_select_pr,'right') menu.FlyOut(menu_title,'left') end}) end
    if _allow_sc_practice then table.insert(menu_items,{'Spell Practice',function() practice='spell' menu.FlyIn(menu_sc_pr,'right') menu.FlyOut(menu_title,'left') end}) end
    table.insert(menu_items,{'View Replay',function()
    replay_loader.Refresh(menu_replay_loader)
        menu.FadeIn(menu_replay_loader,'right')
        menu.FadeOut(menu_title,'left')
    end})
    local net1

    net1={'Network',function () 
        if jstg.network.status>1 then
            jstg.CreateConnect(0)
            net1[1]='Network'
            stage_menu.update(menu_title)
        else
            menu.FlyIn(menu_network,'right') menu.FlyOut(menu_title,'left') 
        end
    end}
    if jstg.network.status>1 then
        net1[1]='Disconnect'
    end
    jstg.nettitle=net1
    table.insert(menu_items,net1)

    table.insert(menu_items,{'Exit Game',ExitGame})
    table.insert(menu_items,{'exit',function() if menu_title.pos==#menu_title.text then ExitGame() else menu_title.pos=#menu_title.text end end})
    menu_title=New(simple_menu,'',menu_items)
    --
    local host_ip_item
    local delay_item
    host_ip_item={'Host '..network.server..':'..network.port,function() 
        loadNetwork()
        host_ip_item[1]='Host '..network.server..':'..network.port 
        stage_menu.update(jstg.menu_network) end
    }
    
    delay_item={'Delay '..getdelay(network.delay),function() 
        loadNetwork()
        delay_item[1]='Delay '..getdelay(network.delay)
    stage_menu.update(jstg.menu_network) end}
    menu_items={host_ip_item,delay_item}
    table.insert(menu_items,{'Connect Multi Player',function () jstg.CreateConnect(3) end})
    table.insert(menu_items,{'Connect Single Player',function () jstg.CreateConnect(1) end})
    table.insert(menu_items,{'Connect Coop Single Player',function () jstg.CreateConnect(2) end})
    table.insert(menu_items,{'exit',function()
        jstg.SinglePlayer()
        menu.FlyIn(menu_title,'left')
        menu.FlyOut(menu_network,'right')
    end})
    menu_network=New(simple_menu,'Network',menu_items)
    
    --
    menu_items={}
    local difficulty_pos=1
    for _,name in ipairs(stage.groups) do
        if name~='Spell Practice' then
            table.insert(menu_items,{name,function() scoredata.difficulty_select=difficulty_pos menu.FlyOut(menu_difficulty_select,'left') last_menu=menu_difficulty_select last_menu.group_name=name 
            local p=stage.groups[name].info
            if not p then p={players={1,2}} end
            
            if p.players[1]==p.players[2] then
                if p.players[1]==1 then
                    menu.FlyIn(menu_player_select,'right') 
                    lstg.var.player_name2=nil
                    lstg.var.rep_player2=nil
                else
                    jstg.CreateInput(2)
                    menu.FlyIn(menu_player_select1,'right') 
                    menu.FlyIn(menu_player_select2,'right') 
                --    Print('inputcount',jstg.inputcount)
                    p1ok=1
                    p2ok=1
                end
                return
            end
            menu.FlyIn(menu_playercount,'right') 
            --menu.FlyIn(menu_player_select,'right') 
            --menu.FlyIn(menu_player_select1,'right') 
            --menu.FlyIn(menu_player_select2,'right') 
            --    Print('inputcount',jstg.inputcount)
            --    p1ok=1
            --    p2ok=1
            end})
            difficulty_pos=difficulty_pos+1
        end
    end
    table.insert(menu_items,{'exit',function() menu.FlyIn(menu_title,'left') menu.FlyOut(menu_difficulty_select,'right') end})
    menu_difficulty_select=New(simple_menu,'Select Difficulty',menu_items)
    menu_difficulty_select.pos=scoredata.difficulty_select or 1
    --
    menu_items={}
    table.insert(menu_items,{'Single Player',function() 
        menu.FlyIn(menu_player_select,'right') 
        menu.FlyOut(menu_playercount,'left') 
        lstg.var.player_name2=nil
        lstg.var.rep_player2=nil
        end})
    table.insert(menu_items,{'Two Players',function()
        jstg.CreateInput(2)
        menu.FlyIn(menu_player_select1,'right') 
        menu.FlyIn(menu_player_select2,'right') 
        menu.FlyOut(menu_playercount,'left')
            p1ok=1
            p2ok=1
    end})
    table.insert(menu_items,{'exit',function() menu.FlyIn(last_menu,'left') menu.FlyOut(menu_playercount,'right') end})
    menu_playercount=New(simple_menu,'Select Player Mode',menu_items)
    menu_playercount.pos=scoredata.playercount or 1
    --
    menu_items={}
    for i,v in ipairs(player_list) do
        table.insert(menu_items,{player_list[i][1],function()
            scoredata.player_select=i
            menu.FlyOut(menu_player_select,'left')
            lstg.var.player_name=player_list[i][2]
            lstg.var.rep_player=player_list[i][3]
            task.New(stage_menu,function()
        for i=1,60 do SetBGMVolume('menu',1-i/60) task.Wait() end
            end)
            task.New(stage_menu,function()
                task.Wait(30)
                New(mask_fader,'close')
                task.Wait(30)
                if practice=='stage' then
                    RunSystem("on_game_start")
                    stage.group.PracticeStart(last_menu.stage_name[last_menu.pos])
                elseif practice=='spell' then
                    stage.IsSCpractice=true--判定进入符卡练习的flag add by OLC
                    RunSystem("on_game_start")
                    stage.group.PracticeStart('Spell Practice@Spell Practice')
                else
                    RunSystem("on_game_start")
                    stage.group.Start(stage.groups[last_menu.group_name])
                end
            end)
        end})
    end
    table.insert(menu_items,{'exit',function() menu.FlyIn(last_menu,'left') menu.FlyOut(menu_player_select,'right') end})
    menu_player_select=New(simple_menu,'Select Player',menu_items)
    menu_player_select.pos=scoredata.player_select or 1
    --
    menu_items={}
    for i,v in ipairs(player_list) do
        table.insert(menu_items,{player_list[i][1],function()
            if p1ok==2 and p2ok==2 then 
                task.New(stage_menu,function()
                    for i=1,60 do SetBGMVolume('menu',1-i/60) task.Wait() end
                end)
                task.New(stage_menu,function()
                    task.Wait(30)
                    New(mask_fader,'close')
                    task.Wait(30)
                    if practice=='stage' then
                        RunSystem("on_game_start",last_menu.stage_name[last_menu.pos])
                        stage.group.PracticeStart(last_menu.stage_name[last_menu.pos])
                    elseif practice=='spell' then
                        stage.IsSCpractice=true--判定进入符卡练习的flag add by OLC
                        RunSystem("on_game_start")
                        stage.group.PracticeStart('Spell Practice@Spell Practice')
                    else
                        RunSystem("on_game_start",stage.groups[last_menu.group_name])
                        stage.group.Start(stage.groups[last_menu.group_name])
                    end
                end)
            else
                scoredata.player_select=i
                --menu.FlyOut(menu_player_select,'left')
                lstg.var.player_name=player_list[i][2]
                lstg.var.rep_player=player_list[i][3]
                p1ok=2
                menu_player_select1.no_pos_change=true
            end
        end})
    end
    table.insert(menu_items,{'exit',function() 
        if p1ok==1 and p2ok==1 then 
            menu.FlyIn(last_menu,'left') menu.FlyOut(menu_player_select1,'right') menu.FlyOut(menu_player_select2,'right') 
            menu_player_select1.no_pos_change=false
        else
            p1ok=1
            menu_player_select1.no_pos_change=false
        end
    end})
    menu_player_select1=New(simple_menu,'Select 1P',menu_items,1,-100)
    menu_player_select1.pos=scoredata.player_select or 1
    --
    menu_items={}
    for i,v in ipairs(player_list) do
        table.insert(menu_items,{player_list[i][1],function()
            if p1ok==2 and p2ok==2 then 
                task.New(stage_menu,function()
                    for i=1,60 do SetBGMVolume('menu',1-i/60) task.Wait() end
                end)
                task.New(stage_menu,function()
                    task.Wait(30)
                    New(mask_fader,'close')
                    task.Wait(30)
                    
                    if practice=='stage' then
                        RunSystem("on_game_start",last_menu.stage_name[last_menu.pos])
                        stage.group.PracticeStart(last_menu.stage_name[last_menu.pos])
                    elseif practice=='spell' then
                        stage.IsSCpractice=true--判定进入符卡练习的flag add by OLC
                        RunSystem("on_game_start",'Spell Practice@Spell Practice')
                        stage.group.PracticeStart('Spell Practice@Spell Practice')
                    else
                        RunSystem("on_game_start",stage.groups[last_menu.group_name])
                        stage.group.Start(stage.groups[last_menu.group_name])
                    end
                end)
            else
                scoredata.player_select2=i
                --menu.FlyOut(menu_player_select,'left')
                lstg.var.player_name2=player_list[i][2]
                lstg.var.rep_player2=player_list[i][3]
                p2ok=2
                menu_player_select2.no_pos_change=true
            end
        end})
    end
    table.insert(menu_items,{'exit',function() 
        if p1ok==1 and p2ok==1 then 
            menu.FlyIn(last_menu,'left') menu.FlyOut(menu_player_select1,'right') menu.FlyOut(menu_player_select2,'right') 
            menu_player_select1.no_pos_change=false
        else
            menu_player_select2.no_pos_change=false
            p2ok=1
        end
    end})
    menu_player_select2=New(simple_menu,'Select 2P',menu_items,2,100)
    menu_player_select2.pos=scoredata.player_select2 or 1
    --
    menu_items={}
    local counter=0
    for i,name in ipairs(stage.groups) do
        if stage.groups[name].allow_practice then
            table.insert(menu_items,{name,function() menu.FlyOut(menu_difficulty_select_pr,'left') menu.FlyIn(menu_practice[name],'right') end})
        end
    end
    table.insert(menu_items,{'exit',function() menu.FlyIn(menu_title,'left') menu.FlyOut(menu_difficulty_select_pr,'right') end})
    menu_difficulty_select_pr=New(simple_menu,'Select Difficulty',menu_items)
    --
    menu_practice={}
    for _,sg in ipairs(stage.groups) do
        if stage.groups[sg].allow_practice then
            local menu_items={}
            local p=stage.groups[sg].info
            if not p then p={players={1,2}} end
            for _,s in ipairs(stage.groups[sg]) do
                if stage.stages[s].allow_practice then
                    table.insert(menu_items,{string.match(s,"^[%w_][%w_ ]*"),function() menu.FlyOut(menu_practice[sg],'left') last_menu=menu_practice[sg] 
                    
                    if p.players[1]==p.players[2] then
                        if p.players[1]==1 then
                            menu.FlyIn(menu_player_select,'right') 
                            lstg.var.player_name2=nil
                            lstg.var.rep_player2=nil
                        else
                            jstg.CreateInput(2)
                            menu.FlyIn(menu_player_select1,'right') 
                            menu.FlyIn(menu_player_select2,'right') 
                        --    Print('inputcount',jstg.inputcount)
                            p1ok=1
                            p2ok=1
                        end
                        return
                    end
                    menu.FlyIn(menu_playercount,'right') 
                    
                    
                    
                    --menu.FlyIn(menu_player_select,'right') 
                    
                    end})
                end
            end
            table.insert(menu_items,{'exit',function() menu.FlyIn(menu_difficulty_select_pr,'left') menu.FlyOut(menu_practice[sg],'right') end})
            menu_practice[sg]=New(simple_menu,'Select Stage',menu_items)
            menu_practice[sg].stage_name={}
            for _,s in ipairs(stage.groups[sg]) do
                if stage.stages[s].allow_practice then
                    table.insert(menu_practice[sg].stage_name,s)
                end
            end
        end
    end
    --
    menu_sc_pr=New(sc_pr_menu,function(index)
        if index then
            last_menu=menu_sc_pr
            lstg.var.sc_index=index
            menu.FlyIn(menu_player_select,'right')
            menu.FlyOut(menu_sc_pr,'left')
        else
            menu.FlyIn(menu_title,'left')
            menu.FlyOut(menu_sc_pr,'right')
        end
    end)
    --
    menu_replay_loader=New(replay_loader,function(filename, stageName)
        if not filename then
            menu.FlyIn(menu_title,'left')
            menu.FlyOut(menu_replay_loader,'right')
        else
      task.New(stage_menu,function()
        for i=1,60 do SetBGMVolume('menu',1-i/60) task.Wait() end
            end)
            task.New(stage_menu,function()
                menu.FlyOut(menu_replay_loader,'left')
                task.Wait(30)
                New(mask_fader,'close')
                task.Wait(30)
                Print(filename,stageName)
                stage.IsReplay=true--判定进入rep播放的flag add by OLC
                stage.Set('load', filename, stageName)
            end)
        end
    end)
    local task_menu_init=function()
        menu.FlyIn(menu_title,'right')
    end
    local sc_init=function()--by OLC
        menu_sc_pr.pos=lstg.var.sc_index
        menu_sc_pr.page=int(lstg.var.sc_index/ui.menu.sc_pr_line_per_page)+2
        self.pos_changed=ui.menu.shake_time
    end
    
    jstg.menu_network=menu_network
    jstg.menu_title=menu_title
    if stage.IsReplay then--rep播放后返回rep菜单 add by OLC
        stage.IsReplay=nil
        menu.FlyIn(menu_replay_loader,'left')
    elseif stage.IsSCpractice then--符卡练习后返回符卡练习菜单 add by OLC
        stage.IsSCpractice=nil
        if self.save_replay then
            menu_replay_saver=New(replay_saver,self.save_replay,self.finish,function()
                menu.FlyOut(menu_replay_saver,'right')
                menu.FlyIn(menu_sc_pr,'left')
                task.New(menu_sc_pr,sc_init)
            end)
            menu.FlyIn(menu_replay_saver,'left')
        else
            menu.FlyIn(menu_sc_pr,'left')
            task.New(menu_sc_pr,sc_init)
        end
    else
        if self.save_replay then
            menu_replay_saver=New(replay_saver,self.save_replay,self.finish,function()
                menu.FlyOut(menu_replay_saver,'right')
                task.New(stage_menu,function() task.Wait(30) task.New(stage_menu,task_menu_init) end)
            end)
            menu.FlyIn(menu_replay_saver,'left')
        else
            task.New(stage_menu,task_menu_init)
        end
    end
    
    task.New(self,function()--延迟几帧加载bgm避免奇怪的黑块问题--然并乱，草死
        task.Wait(1)
        LoadMusic('menu',music_list.menu[1],music_list.menu[2],music_list.menu[3])
        PlayMusic('menu')
    end)
    
    menu_list={menu_title,menu_player_select,menu_difficulty_select,menu_replay_loader,menu_replay_saver,menu_items,menu_sc_pr,menu_network,menu_player_select2,menu_player_select1,menu_playercount}--设置菜单对象表
end
function stage_menu:render()
    ui.DrawMenuBG()
end
