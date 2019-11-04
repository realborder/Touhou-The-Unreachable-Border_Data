TUO_Developer_Flow={
    flow={},
    template={}

}
local UI_L=-107
local UI_R=640-UI_L

function TUO_Developer_Flow:NewFlow(template_name,initfunc)
    local tpl=self.template[template_name]
    local tmp={
        alive=true,
        timer=0,
        core=self,
        hitbox={l=UI_L,r=UI_R,b=240-80,t=240+80},
        _tpl_frame=tpl.frame,
        _tpl_render=tpl.render,
        _event_mouseclicked_outside=function(self) self.alive=false end,
        ban_black_bg=false,
        ban_UI_lock=false
    }
    if tpl.init then tpl.init(tmp) end
    if initfunc then initfunc(tmp) end
    self.flow[#(self.flow)+1]=tmp
    return tmp
end


---计划在列的浮动窗口
---对话框（提示（无按钮）、选择、是否保存、警告、错误）




function TUO_Developer_Flow:SetRenderRect(l,r,b,t)
    SetRenderRect(l, r, b, t, l, r, b, t)
end
function TUO_Developer_Flow:ResetRenderRect()
    SetViewMode'ui'
end

function TUO_Developer_Flow:init()
    self.ban_UI_frame=false
    self.core=TUO_Developer_Tool_kit
    self.bgtimer=0
    self.timer=0
end

function TUO_Developer_Flow:frame()
    self.timer=self.timer+1
    if #(self.flow)>0 then
        local flow=self.flow[#(self.flow)]
        -- Print(self.timer..': '..#(self.flow))
        local ux,uy=MouseState.x_in_UI,MouseState.y_in_UI
        if flow.alive then
            flow.timer=flow.timer+(1-flow.timer)*0.29
            if flow.timer>0.99 then flow.timer=1 end
            if flow._tpl_frame then flow:_tpl_frame() end
            if flow.frame then flow:frame() end
        else
            flow.timer=flow.timer+(0-flow.timer)*0.35
            if flow.timer<0.1 then self.flow[#(self.flow)]=nil end
        end
        local l=flow.hitbox.l
        local r=flow.hitbox.r
        local b=flow.hitbox.b
        local t=flow.hitbox.t
        if MouseTrigger(0) then
            if ux>l and ux<r and uy>b and uy<t then

            else
            if flow._event_mouseclicked_outside then Print(self.timer..': '..#(self.flow)) flow:_event_mouseclicked_outside()  end
            end
        end
        if not flow.ban_black_bg then
            self.bgtimer=min(1,self.bgtimer+0.02)
        end
        if not flow.ban_UI_lock then
            self.ban_UI_frame=true
        else
            self.ban_UI_frame=false
        end
    else
        self.bgtimer=max(0,self.bgtimer-0.05)
        self.ban_UI_frame=false
    end
end

function TUO_Developer_Flow:render()
    SetImageState('white','',Color(150*self.bgtimer,0,0,0))
    RenderRect('white',-200,840,0,480)
    for _,flow in pairs(self.flow) do
        local l=flow.hitbox.l
        local r=flow.hitbox.r
        local b=flow.hitbox.b
        local t=flow.hitbox.t
        local m=(b+t)/2
        local dh=(t-b)/2
        b=m-dh*flow.timer
        t=m+dh*flow.timer
        local alpha=flow.timer
        if flow._tpl_render then flow:_tpl_render(alpha,l,r,b,t) end
        if flow.render then flow:render(alpha,l,r,b,t) end
    end
end

