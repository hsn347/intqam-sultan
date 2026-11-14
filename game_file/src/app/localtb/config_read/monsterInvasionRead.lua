local monsterInvasionRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "monsterinvade_reward"
;(nil)[2] = true
monsterInvasionRead:defineValue("monsterinvade_reward", nil)
monsterInvasionRead:defineValue("monsterinvadeConfig", function()
	return monsterInvasionRead.getClassTypeConfig(monsterInvasionRead.monsterinvade_reward, "groupType")
end)
function monsterInvasionRead.getRewardCfg()
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	local retType, rId = nebulaActivityCtrl:getKingdomRegionType()
	return monsterInvasionRead.monsterinvadeConfig[rId]
end
return monsterInvasionRead
