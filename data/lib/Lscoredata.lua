--======================================
--luastg scoredata
--======================================

----------------------------------------
--

function new_scoredata_table()
	t={}
	setmetatable(t,{__newindex=scoredata_mt_newindex,__index=scoredata_mt_index,data={}})
	return t
end

function scoredata_mt_newindex(t,k,v)
	if type(k)~='string' and type(k)~='number' then error('Invalid key type \''..type(k)..'\'') end
	if type(v)=='function' or type(v)=='userdata' or type(v)=='thread' then error('Invalid value type \''..type(v)..'\'') end
	if type(v)=='table' then
		make_scoredata_table(v)
	end
	getmetatable(t).data[k]=v
	SaveScoreData()
end

function scoredata_mt_index(t,k)
	return getmetatable(t).data[k]
end

function make_scoredata_table(t)
	if type(t)~='table' then error('t must be a table') end
	Serialize(t)
	setmetatable(t,{__newindex=scoredata_mt_newindex,__index=scoredata_mt_index,data={}})
	for k,v in pairs(t) do
		if type(v)=='table' then
			make_scoredata_table(v)
		end
		getmetatable(t).data[k]=v
		t[k]=nil
	end
end

function DefineDefaultScoreData(t)
	scoredata=t
end

function SaveScoreData()
	local score_data_file=assert(io.open('score\\'..setting.mod..'\\'..setting.username..'.dat','w'))
	local s=Serialize(scoredata)
	score_data_file:write(s)
	score_data_file:close()
end

function InitScoreData()
	lfs.mkdir('score\\'..setting.mod)
	if not FileExist('score\\'..setting.mod..'\\'..setting.username..'.dat') then
		if scoredata==nil then scoredata={} end
		if type(scoredata)~='table' then error('scoredata must be a Lua table.') end
	else
		local scoredata_file=assert(io.open('score\\'..setting.mod..'\\'..setting.username..'.dat','r'))
		scoredata=DeSerialize(scoredata_file:read('*a'))
		scoredata_file:close()
		scoredata_file=nil
	end
	make_scoredata_table(scoredata)
end
