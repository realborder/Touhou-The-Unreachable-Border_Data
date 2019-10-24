local m=TUO_Developer_UI:NewModule()

function m:init()
    self.name='武汉高校东方例会专栏'
end

local function format_json(str)
	local ret = ''
	local indent = '	'
	local level = 0
	local in_string = false
	for i = 1, #str do
		local s = string.sub(str, i, i)
		if s == '{' and (not in_string) then
			level = level + 1
			ret = ret .. '{\n' .. string.rep(indent, level)
		elseif s == '}' and (not in_string) then
			level = level - 1
			ret = string.format(
					'%s\n%s}', ret, string.rep(indent, level))
		elseif s == '"' then
			in_string = not in_string
			ret = ret .. '"'
		elseif s == ':' and (not in_string) then
			ret = ret .. ': '
		elseif s == ',' and (not in_string) then
			ret = ret .. ',\n'
			ret = ret .. string.rep(indent, level)
		elseif s == '[' and (not in_string) then
			level = level + 1
			ret = ret .. '[\n' .. string.rep(indent, level)
		elseif s == ']' and (not in_string) then
			level = level - 1
			ret = string.format(
					'%s\n%s]', ret, string.rep(indent, level))
		else
			ret = ret .. s
		end
	end
	return ret
end

local PATH='TUOlib\\Dev_Tool\\module\\WuHan\\ScoreRecord.dat'
local player_score_list={}
local cur_player_email
local cur_player_name
local default_score={
    {name='',score=1000000},
    {name='',score=900000},
    {name='',score=800000},
    {name='',score=700000},
    {name='',score=600000},
    {name='',score=500000},
    {name='',score=400000},
    {name='',score=300000},
    {name='',score=200000},
    {name='',score=100000},
}
local function LoadScore()
	local f,msg
	f,msg=io.open(PATH,'r')
	if f==nil then
        TUO_Developer_Flow:MsgWindow('玩家分数数据文件不存在，已重新创建。')
        player_score_list=DeSerialize(Serialize(default_score))
	else
		player_score_list=DeSerialize(f:read('*a'))
		f:close()
    end
end
local function SaveScore()
	local f,msg
	f,msg=io.open(PATH,'w')
    if f==nil then
        TUO_Developer_Flow:ErrorWindow(msg)
	else
		f:write(format_json(Serialize(player_score_list)))
		f:close()
	end
    
end

--检测输入的是否是邮箱的函数
function CheckEmail(string)
    if not string then return false end
    if type(string)~='string' then return false end
    if (string:match("[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?")) then return true
    else return false end
end

local rule=
[[
感谢游玩「东方梦无垠 ~ the Unreachable Oneiroborder.体验版」。
在本次活动中我们把游戏精简为 BossRush 来让更多人有游玩的机会。
现在他是一个刷分游戏。

符卡系统与原作差别不小，可以分段释放也可以 一 直 按X一口气放完。
擦弹擦够50个子弹就能放必杀技消弹（按C键释放）。
消弹和擦弹增加最大得点和资源增长量，但专心避弹可以提高火力（最高6p
和得分倍率（最高五倍）。

本次活动得分最高者可以在游戏发售后获得正式版 SteamKey 一份！
想办法把分数刷最高就对了！]]

local rule2=[[
确认你已经了解规则以后可以点击下方的按钮来输入你的邮箱。
当然你也可以选择阅读下方的更详细的提示。
之后你可以进行游玩，游戏结束后会自动登记分数。]]

local rule3=[[
自机符卡：按X宣卡，伤害高，时间长，但是释放次数有限，被弹一次之后自
    机符卡槽会被填满。
    * 注意：本作符卡基础无敌时间只有宣卡时的1.5秒，但最靠前的符卡会
           提供额外的长时间无敌。
           自机周围的符卡耐久槽耗尽前可以继续释放符卡攻击，持续按住
            X可以加强符卡攻击。

必杀技：按C消耗灵力来释放，伤害低，时间短，但擦弹就可以充能。
    擦够50个子弹即可释放，擦到125个之后消耗灵力会最少。

梦现指针：位于屏幕左侧，用以指示玩家行为是偏向混关还是偏向避弹。
    宣卡和释放必杀会使其偏向梦境侧，资源和最大得点↑，火力和分数倍率↓
    专心避弹会使其偏向现实侧，资源和最大得点↓，但火力和分数倍率↑
    指针值在大于一格的时候资源会自动上涨，在击败一个boss之后才会结算。

炸，你能拿到最大得点，扭，你能获得分数倍率，到底该咋办呢？]]

local tip1=[[
请在下方的输入框里输入你的邮箱，这是我们发送 SteamKey 的唯一依据。
请务必确认你输入了正确的邮箱。由于引擎限制，游戏中右SHIFT不可用。
推荐使用QQ邮箱，以防意外发生时方便联系。]]

local textbox,textbox2,listbox

local wuhan1=TUO_Developer_UI:NewPanel()
function wuhan1:init()
    self.name="活动规则"
    TDU_New_title(self).text='活动简介'
    TDU_New_text_displayer(self).text=rule
    TDU_New_title(self).text='开始游戏'
    TDU_New_text_displayer(self).text=rule2
    local btn=TDU_New_button(self)
    btn.text='开始游戏'
    btn._event_mouseclick=function(widget)
        m.cur=2
        btn.enable=false
        local r,err= tuolib.mod_manager.LoadMod('mod\\TUO_BossRush_WuHanOnly.zip')
        if r then
            InitAllClass()
            TUO_Developer_Flow:MsgWindow('武汉高校东方例会所用模块已成功加载。')
        else
            TUO_Developer_Flow:ErrorWindow('武汉高校东方例会所用模块加载失败。请截屏并联系云绝万里。\n'..err)
        end
    end
    TDU_New_title(self).text='游戏系统详细介绍'
    TDU_New_text_displayer(self).text=rule3
end
local wuhan2=TUO_Developer_UI:NewPanel()
function wuhan2:init()
    self.name="玩家信息登记"
    TDU_New_title(self).text='玩家信息登记'
    TDU_New_text_displayer(self).text=tip1
    textbox=TDU_New_inputer(self)
    textbox.width=196
    local tiper=TDU_New'text_displayer'(self)
    local tiper2=TDU_New'text_displayer'(self)
    tiper2.text='你的机签，不填写会置为\"unknown\"'
    tiper2.visiable=false
    textbox2=TDU_New'inputer'(self)
    textbox2.visiable=false
    textbox2.width=96
    local list=TDU_New'list_box'(self)
    local btn=TDU_New'button'(self)
    tiper.text='邮箱格式错误'
    tiper.visiable=false
    textbox._event_textchange=function(widget)
        btn.visiable=true
        if string.len(textbox.text)<5 then 
            tiper.visiable=false
            btn.enable=false
            list.visiable=false
            tiper2.visiable=false
            textbox2.visiable=false
        else
            if CheckEmail(textbox.text) then 
                tiper.visiable=false 
                btn.enable=true
                list.visiable=true
                tiper2.visiable=true
                textbox2.visiable=true
            else 
                tiper.visiable=true 
                btn.enable=false
                list.visiable=false
                tiper2.visiable=false
                textbox2.visiable=false
            end
        end
    end
    list.keep_refresh=false
    list.width=96
    list.visiable=false
    list.selection={false,true,false,false}
    list._ban_mul_select=true
    list.display_value={'Easy','Normal','Hard','Lunatic'}
    btn.text='确认'
    btn.enable=false
    btn._event_mouseclick=function(widget)
        local player_email=textbox.text
        local diff
        for i=1,4 do
            if list.selection[i] then diff=list.display_value[i] end
        end
        -- TUO_Developer_Flow:MsgWindow('新的玩家：'..textbox2.text..'\nEmail:'..player_email..'\n难度: '..diff)
        m.cur=3
        ResetPool()
        scoredata.player_select=1
        lstg.var.player_name=player_list[1][2]
        lstg.var.rep_player=player_list[1][3]
        stage.group.PracticeStart('BossRush@'..diff)

        TUO_Developer_UI.visiable=false
        cur_player_email=player_email
        if string.len(textbox2.text)>0 then 
            cur_player_name=textbox2.text end
        textbox.text=''
        textbox2.text=''
        list.visiable=false
        btn.visiable=false
        tiper2.visiable=false
        textbox2.visiable=false
    end


end
local wuhan3=TUO_Developer_UI:NewPanel()
function wuhan3:init()
    LoadScore()
    SaveScore()
    self.name="分数排行榜"
    -- TDU_New'title'(self).text='当前玩家信息'
    -- TDU_New'value_displayer'(self).monitoring_value=
    --     function(widget) 
    --         return {{name='玩家名',v=cur_player_name},{name='邮箱',v=cur_player_email}} 
    --     end    

    TDU_New'title'(self).text='分数排行榜'
    local btn=TDU_New'button'(self)
    btn.text='返回'
    btn._event_mouseclick=function(self)
        m.cur=2
    end
    listbox=TDU_New'list_box'(self)
    listbox.monitoring_value=function(widget)
        local t={}
        for k,v in pairs(player_score_list) do
            -- local name=v.name or v.email
            table.insert(t,{name=v.score,v=v.name})
        end
        return t
    end
    listbox.sortfunc=function(v1,v2)  return v1.name>v2.name end

end


local old_ReturnToTitle=stage.group.ReturnToTitle
function stage.group.ReturnToTitle(save_rep,finish)
    old_ReturnToTitle(save_rep,finish)
    if cur_player_email and cur_player_name then
        table.insert(player_score_list,{email=cur_player_email,score=lstg.var.score,name=cur_player_name})
        cur_player_email=nil
        SaveScore()
        TUO_Developer_UI.visiable=true
    elseif cur_player_email then
        table.insert(player_score_list,{email=cur_player_email,score=lstg.var.score,name='unknown'})
        cur_player_email=nil
        TUO_Developer_UI.visiable=true
        SaveScore()
    end
end