BossSpeedKill = plus.Class()

function BossSpeedKill:init(boss, maxhp)
	self.boss=boss
	local b=self.boss
	b.hploss=0
	b.speed_kill_minus=0
end

function BossSpeedKill