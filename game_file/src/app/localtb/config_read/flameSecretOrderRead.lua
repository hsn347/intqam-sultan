local flameSecretOrderRead = include("aAReadClass").new()
function flameSecretOrderRead.init()
	_UPVALUE2_ = nil
	;(nil)[1] = "fire_secret_reward"
	;(nil)[2] = true
	flameSecretOrderRead:defineValue("fsr", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "desert_dungeons_reward"
	;(nil)[2] = true
	flameSecretOrderRead:defineValue("ddr", nil)
end
function flameSecretOrderRead.getBaseRewardsByFloor(floor, isNew)
	if isNew then
		return flameSecretOrderRead.ddr[floor].baseReward
	else
		return flameSecretOrderRead.fsr[floor].baseReward
	end
end
function flameSecretOrderRead.getGreatRewardsByFloor(floor, isNew)
	if isNew then
		return flameSecretOrderRead.ddr[floor].greatReward
	else
		return flameSecretOrderRead.fsr[floor].greatReward
	end
end
function flameSecretOrderRead.getItemInfoByFloor(floor, isNew)
	if isNew then
		return flameSecretOrderRead.ddr[floor].item
	else
		return flameSecretOrderRead.fsr[floor].item
	end
end
function flameSecretOrderRead.getTotalFloorNum(isNew)
	if isNew then
		return #flameSecretOrderRead.ddr
	else
		return #flameSecretOrderRead.fsr
	end
end
function flameSecretOrderRead.getFloorType(floor, isNew)
	return flameSecretOrderRead.ddr[floor].type or 1
end
function flameSecretOrderRead.getNexFloor(floor, isNew)
	for i = floor, #flameSecretOrderRead.ddr do
		if flameSecretOrderRead.ddr[i].type == 2 then
			return i - 1
		end
	end
end
flameSecretOrderRead.init()
return flameSecretOrderRead
