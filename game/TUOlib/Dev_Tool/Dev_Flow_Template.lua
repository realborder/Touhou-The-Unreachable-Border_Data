local ttf='f3_word'
local UI_L=-107
local UI_R=640-UI_L

------------------------------
---更快捷的方块渲染
local RenderCube= function(l,r,b,t,ca,cr,cg,cb) 
    if ca and cr and cg and cb then
        SetImageState('white','',Color(ca,cr,cg,cb)) end
    if ca and (not cr) then
        SetImageState('white','',ca) end
    RenderRect('white',l,r,b,t)
end



function TUO_Developer_Flow:NewFlowTemplate(name)
    local t={}
    self.template[name]=t
    return t
end

local infowin=TUO_Developer_Flow:NewFlowTemplate('infowin')
function infowin:init()
    self.title='提示'
    self.text='一条信息'
    self.hitbox={l=UI_L,r=UI_R,b=240-180,t=240+180}
end
function infowin:frame()
    if type(self.text)~='string' then return end
    local i=1
    local flag=string.find(self.text,'\n')
    while flag do
        i=i+1
        flag=string.find(self.text,'\n',flag+1,true)
    end
    self.hitbox.t=240+i*10+40
    self.hitbox.b=240-i*10-40
end
function infowin:render(alpha,l,r,b,t)
    RenderCube(l,r,b,t,255*alpha,255,255,255)
    RenderTTF2(ttf,self.title,l+50,r-50,b,t-16,1.4,Color(255*alpha,0,0,0),'center','top')
    RenderTTF2(ttf,self.text,l+50,r-50,b+40,t-40,1,Color(255*alpha,40,40,40),'left','top')
end
function TUO_Developer_Flow:MsgWindow(msg)
    TUO_Developer_Flow:NewFlow('infowin',function(self) self.text=tostring(msg) end)
end
local errorwin=TUO_Developer_Flow:NewFlowTemplate('errorwin')
function errorwin:init()
    self.title='错误'
    self.text='一条信息'
    self.hitbox={l=UI_L,r=UI_R,b=240-180,t=240+180}
end
function errorwin:frame()
    local i=1
    local flag=string.find(self.text,'\n')
    while flag do
        i=i+1
        flag=string.find(self.text,'\n',flag+1,true)
    end
    self.hitbox.t=240+i*10+40
    self.hitbox.b=240-i*10-40
end
function errorwin:render(alpha,l,r,b,t)
    RenderCube(l,r,b,t,255*alpha,100,18,18)
    RenderTTF2(ttf,self.title,l+50,r-50,b,t-16,1.4,Color(255*alpha,255,255,255),'center','top')
    RenderTTF2(ttf,self.text,l+50,r-50,b,t-40,1,Color(255*alpha,210,210,210),'left','top')
end
function TUO_Developer_Flow:ErrorWindow(err)
    TUO_Developer_Flow:NewFlow('errorwin',function(self) self.text=err end)
end