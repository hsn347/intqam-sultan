local migrationRewardRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "migration_reward"
	;(nil)[2] = true
	migrationRewardRead:defineValue("migration_reward", nil)
end
function migrationRewardRead.getReward()
	init()
	return migrationRewardRead.migration_reward[1].reward
end
return migrationRewardRead
