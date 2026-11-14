local activity_900xxxx_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "daily_salute_reward"
;(nil)[2] = true
activity_900xxxx_Read:defineValue("daily_salute_reward1", nil)
activity_900xxxx_Read:defineValue("daily_salute_reward2", function()
	local config = require_data("daily_salute_reward", true, true).data
	return activity_900xxxx_Read.getClassTypeConfig(config, "classType")
end)
return activity_900xxxx_Read
