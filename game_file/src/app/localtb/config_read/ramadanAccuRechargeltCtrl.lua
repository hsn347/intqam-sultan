local ramadanAccuRechargeltCtrl = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "accumulatedpoints"
;(nil)[2] = true
ramadanAccuRechargeltCtrl:defineValue("accumulatedpoints", nil)
_UPVALUE2_ = nil
;(nil)[1] = "rechangepoints"
;(nil)[2] = true
ramadanAccuRechargeltCtrl:defineValue("rechangepoints", nil)
_UPVALUE2_ = nil
;(nil)[1] = "starry_night_reward"
;(nil)[2] = true
ramadanAccuRechargeltCtrl:defineValue("starry_night_reward", nil)
_UPVALUE2_ = nil
;(nil)[1] = "starry_night_score"
;(nil)[2] = true
ramadanAccuRechargeltCtrl:defineValue("starry_night_score", nil)
function ramadanAccuRechargeltCtrl.getPointRewardDataByClassType(classType)
	local _ENV, data
	local index = 1
	for i, v in ipairs(ramadanAccuRechargeltCtrl.accumulatedpoints) do
		if v.grade == classType then
			data[index] = v
			index = index + 1
		elseif classType < v.grade then
			return data
		end
	end
	return data
end
function ramadanAccuRechargeltCtrl.getRechargeInfoDataByClassType(classType)
	local _ENV, data
	local index = 1
	for i, v in ipairs(ramadanAccuRechargeltCtrl.rechangepoints) do
		if v.grade == classType then
			data[index] = v
			index = index + 1
		elseif classType < v.grade then
			return data
		end
	end
	return data
end
function ramadanAccuRechargeltCtrl.getStarryNightJourneyReward(classType)
	local _ENV, data
	local index = 1
	for i, v in ipairs(ramadanAccuRechargeltCtrl.starry_night_reward) do
		dump(v, "fskdfjsldjfkdjkf")
		if v.group == classType then
			data[index] = v
			index = index + 1
		elseif classType < v.group then
			return data
		end
	end
	return data
end
function ramadanAccuRechargeltCtrl.getStarryNightJourneyScore()
	return ramadanAccuRechargeltCtrl.starry_night_score
end
return ramadanAccuRechargeltCtrl
