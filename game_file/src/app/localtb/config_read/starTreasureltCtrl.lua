local starTreasureltCtrl = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "ramadan_map"
;(nil)[2] = true
starTreasureltCtrl:defineValue("ramadanMap", nil)
function starTreasureltCtrl.getMustRewardByClassType(classType)
	return starTreasureltCtrl.ramadanMap[classType].reward
end
function starTreasureltCtrl.getRandomRewardByClassType(classType)
	return starTreasureltCtrl.ramadanMap[classType].probabilityReward
end
return starTreasureltCtrl
