local decryptionRead = include("aAReadClass").new()
_UPVALUE1_ = nil
;(nil)[1] = "anniversaryuncover_task_des"
decryptionRead:defineValue("ATD", nil)
_UPVALUE2_ = nil
;(nil)[1] = "anniversaryuncover_reward"
;(nil)[2] = true
decryptionRead:defineValue("AR", nil)
function decryptionRead.getTaskDes(tasktypeid)
	local config = decryptionRead.ATD[tasktypeid]
	if config and config.Describe then
		if config.num then
			_UPVALUE1_ = config.num
			config.num.num = config.num
			config.num[1] = config.Describe
			return config.num
		else
			return config.Describe
		end
	end
	return "NA"
end
function decryptionRead.getGuideId(tasktypeid)
	if decryptionRead.ATD[tasktypeid] then
		return decryptionRead.ATD[tasktypeid].Guideid
	end
end
function decryptionRead.getBoxReward(Index)
	if decryptionRead.AR[Index] then
		return decryptionRead.AR[Index].Reward
	end
end
return decryptionRead
