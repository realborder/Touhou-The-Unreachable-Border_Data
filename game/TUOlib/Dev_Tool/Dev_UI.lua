TUO_Developer_UI={}
----排版信息
local UI_L=-107
local UI_R=640-UI_L

local self=TUO_Developer_UI
self.core=TUO_Developer_Tool_kit


---------------------------------
---粗糙的补间函数
local itpl = function(vstart,vend,t)  return vstart+(vend-vstart)*(cos(180+180*t)+1)/2 end
------------------------------
---更快捷的方块渲染
local RenderCube= function(l,r,b,t,ca,cr,cg,cb) 
    if ca and cr and cg and cb then
        SetImageState('white','',Color(ca,cr,cg,cb)) end
    if ca and (not cr) then
        SetImageState('white','',ca) end
    RenderRect('white',l,r,b,t)
end



function TUO_Developer_UI:init()
    self.visiable=false
    self.cur=nil
    --展开用timer，范围是0到1
    self.timer=0

    self.mouse_click_list={}

    self.bgalpha=0.9
    self.module={}
    self.scroll_force=0
    self.left_for_world=false

    --模块排版
        --每个模块选项之间的角度差
        self.module_da=25
        --可被选中的模块的角度限制范围
        self.module_angle_limit=45
        --模块选项环绕中心位置和半径
        self.module_cx,self.module_cy=240,230
        self.module_cr=200
        --模块选项自身的默认半径
        self.module_r=32
        --
        self.module_a_offset=0
        self.module_a_offset_aim=0
    --面板排版
        self.topbar_width=32
        self.panel_top_offset=16
        self.panel_left_offset=16
        self.leftbar_width=107+35
        self.panel_bottom_offset=16
        self.panel_left_offset=16
        self.panel_height=32
        self.panel_gap=8
    --

end

function TUO_Developer_UI:frame()
    -----timer变换部分
        if not self.visiable then
            self.timer=self.timer+(0-self.timer)*0.1
            if abs(self.timer)<0.03 then self.timer=0 end
        else 
            if self.cur then
                self.timer=self.timer+(-1-self.timer)*0.1
                if abs(self.timer)>0.9999 then self.timer=-1 end

            else
                self.timer=self.timer+(1-self.timer)*0.1
                if abs(self.timer)>0.97 then self.timer=1 end

            end
        end
        if self.timer==0 then return end
    ------在完全不显示的时候会彻底关掉自身的逻辑
        --鼠标滚轮
        if MouseState.WheelDelta~=0 and self.timer>0 then self.module_a_offset=min(max(0,self.module_a_offset-MouseState.WheelDelta/9),(#self.module-1)*self.module_da) end

        --处理模块的点击逻辑和位置
            for _,module in pairs(self.module) do
                self:DoModuleFrame(module)
            end
end
function TUO_Developer_UI:render()
    SetViewMode'ui'    
    local sis=SetImageState
    local rr=RenderRect
    local rttf=RenderTTF2
    --背景
        if self.timer>0 then
            RenderCube(UI_L,UI_R,0,480,155*self.timer,0,0,0)
        elseif self.timer<0 then
            if self.left_for_world then
                RenderCube(UI_L,lstg.world.scrl,0,480,155*-self.timer,255,255,255)
                RenderCube(lstg.world.scrr,UI_R,0,480)
                RenderCube(lstg.world.scrl,lstg.world.scrr,0,lstg.world.scrb)
                RenderCube(lstg.world.scrl,lstg.world.scrr,lstg.world.scrt,480)
            else
                RenderCube(UI_L,UI_R,0,480,155*-self.timer,255,255,255)
            end
            RenderCube(UI_L,UI_L+self.leftbar_width*-self.timer,0,480,255*-self.timer,255,255,255)

        end
        
    --logo
        if self.timer>0 and not (self.core.no_logo) then
            local offset=itpl(0,10,1-self.timer)
            local l=-31-offset
            local r=-31+512+offset
            local b=-24-offset
            local t=-24+512+offset
            SetImageState('_Dev_UI_Logo','',Color(255*self.timer,255,255,255))
            RenderRect('_Dev_UI_Logo',l,r,b,t)
        end
    --模块
        for _,module in pairs(self.module) do
            self:RenderModule(module)
        end
    --条
    if self.timer<0 then
        RenderCube(UI_L,UI_R,480-self.topbar_width*-self.timer,480,255*-self.timer,30,30,30)
        if self.cur then
            RenderTTF2(self.core.ttf,self.module[self.cur].name,UI_L+32+5,UI_R,480-self.topbar_width*-self.timer,480,1.2,Color(255*-self.timer,255,255,255),'vcenter')
        end
    end


end
