local activity_9001723_Read = include("aAReadClass").new()
activity_9001723_Read:defineValue("anniversary_mainui_jump", function()
	local _ENV, jumps
	local _jumps = require_data("anniversary_mainui_jump", false, true).data
	for k, v in pairs(_jumps) do
		_ENV = nil
		;(nil).index = v.index
		;(nil).activityId = v.activityId
		;(nil).activityName = v.activityName or ""
		;(nil).default_startTime = v.time[1]
		;(nil).default_endTime = v.time[2]
		table.insert(jumps, nil)
	end
	activity_9001723_Read.jumps = jumps
	return activity_9001723_Read.jumps
end)
function activity_9001723_Read:getJumps()
	if not self.jumps then
		return self.anniversary_mainui_jump
	end
	return self.jumps
end
return activity_9001723_Read
