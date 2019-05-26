lstg.systems={}
function RunSystem(sysname,...)
	local i
	for i=1,#lstg.systems do
		local s = lstg.systems[i]
		if s and s[sysname] then
			s[sysname](...)
		end
	end	
end


local system={}
system.name="drunker"
function system.on_game_start(stagename,diff,players)
	lstg.var.drunk=0
	lstg.var.chargetime=0
end
function system.on_stage_init(stage_object)
	
end
function system.on_player_init(player)

end
function system.on_player_frame(player)
	if not player.dialog then
		if lstg.var.chargetime>0 then
			lstg.var.chargetime = lstg.var.chargetime-1
		end
		if lstg.var.chargetime==0 then
			if lstg.var.drunk>0 then
				lstg.var.drunk=lstg.var.drunk-1
			end
		end
		if KeyIsDown'special' and lstg.var.chargetime==0 then
			New(bomb_bullet_killer,0,0,640,640,false)
			lstg.var.chargetime = 60
			PlaySound('select00',0.5)
			if player.protect < 60 then
				player.protect = 60
			end
			lstg.var.drunk = lstg.var.drunk+300
			if lstg.var.drunk>1000 then lstg.var.drunk=1000 end
		end
	end
end
function system.on_player_charge(player)

end
function system.on_stage_frame(stage_object)
	
end
function system.on_stage_render()
	SetViewMode'ui'
	SetFontState('bonus','',Color(255,255,255,255))
	RenderText('bonus','Drunk: '..lstg.var.drunk..'/1000',100,100,0.5,'left')
	--RenderTTF('sc_pr','Drunk: '..lstg.var.drunk..'/1000' ,32,128,420,450,Color(255,255,255,255),'centerpoint')
end



local function test_findfiles(path)
	local r=FindFiles(path,'lua')
	for i,v in pairs(r) do
		local filename=v[1]
		local packname=v[2]
		Print('File:'..filename,packname)
	end
end
--test_findfiles('ex\\')
--test_findfiles('data\\ex\\')
