---=====================================
---luastg user global value
---=====================================

local LOG_MODULE_NAME="[lstg][debug]"
local SCALE=1
local REFRESH_INTERVAL=1

---@class lstg.debug
lstg.debug={}

----------------------------------------
---几大函数执行时间计时

---高精度计时器接口
lstg.debug.usTimer=lstg.StopWatch()

local startT={}
local endT={}
local useT={}

local aimtype={"objframe","usersystem","boundcheck","collicheck","updateXY","afterframe","objrender","all"}

local function resetT()
    for _,v in pairs(aimtype) do
        startT[v]=0
        endT[v]=0
        useT[v]=0
    end
    alluseT=0
end resetT()

function lstg.debug.FuncTimeStart(k)
    startT[k]=lstg.debug.usTimer:GetElapsed()
end

function lstg.debug.FuncTimeEnd(k)
    endT[k]=lstg.debug.usTimer:GetElapsed()
    useT[k]=useT[k]+(endT[k]-startT[k])
end

function lstg.debug.GetFuncTimeUse(k)
    return useT[k]
end

----------------------------------------
---debug lib

lstg.debug.timer=0

function lstg.debug.ResetTimer()
    lstg.debug.usTimer:Reset()
    if lstg.debug.timer%REFRESH_INTERVAL==0 then
        resetT()
    end
    lstg.debug.timer=lstg.debug.timer+1
    lstg.debug.FuncTimeStart("all")
end

function lstg.debug.RenderInfo()
    lstg.debug.FuncTimeEnd("all")
    SetViewMode("ui")
    SetImageState("white","",Color(128,0,0,0))
    SetFontState("menu","",Color(0xFFFFFFFF))
    --函数执行时间
    RenderRect("white",0,SCALE*128,screen.height-128*SCALE,screen.height)
    RenderText("menu",'info:\
ObjectFrame\
UserSystemOp...\
BoundCheck\
CollisionCheck\
UpdateXY\
AfterFrame\
ObjectRender\
PerFrame\
',
        4*SCALE,screen.height-4*SCALE,SCALE*0.1125,"left","top")
    RenderText("menu",
        string.format('0.000 ms\
%.3f ms\
%.3f ms\
%.3f ms\
%.3f ms\
%.3f ms\
%.3f ms\
%.3f ms\
%.3f ms\
',
            useT["objframe"]*1000/REFRESH_INTERVAL,
            useT["usersystem"]*1000/REFRESH_INTERVAL,
            useT["boundcheck"]*1000/REFRESH_INTERVAL,
            useT["collicheck"]*1000/REFRESH_INTERVAL,
            useT["updateXY"]*1000/REFRESH_INTERVAL,
            useT["afterframe"]*1000/REFRESH_INTERVAL,
            useT["objrender"]*1000/REFRESH_INTERVAL,
            useT["all"]*1000/REFRESH_INTERVAL
        ),
        124*SCALE,screen.height-4*SCALE,SCALE*0.1125,"right","top")
    
    SetViewMode("world")
end
