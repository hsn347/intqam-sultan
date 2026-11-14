local _ENV, npcTipDataModuleAPI
function npcTipDataModuleAPI:reqGetReward(bid, blv)
	self:getModuleCtrl():reqGetNPCTipReward(bid, blv)
end
function npcTipDataModuleAPI:isRewardTimesLimitToday()
	return self:getModuleCtrl():isDailyRewardTimesLimit()
end
function npcTipDataModuleAPI:getModuleCtrl()
	local gametop = gModuleMgr.getObject("gametop")
	return gametop.playertop_:getModule("npcTipCtrl")
end
return npcTipDataModuleAPI
