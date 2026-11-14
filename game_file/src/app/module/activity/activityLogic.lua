local activityltCtrl = include("activityltCtrl")
local gametop = gModuleMgr.getObject("gametop")
local activityCtrl = gametop.playertop_:getModule("activityCtrl")
local _ENV, activityLogic = gametop.playertop_, gametop.playertop_
function activityLogic.getPointReward(activityID)
	local stageCityLv = activityCtrl.stageCityLv
	local serverLv = activityCtrl.serverLv
	local pointreward = clone(activityltCtrl.getPointReward(activityID, serverLv))
	for k, v in pairs(pointreward) do
		local activityCtrl, tempreward = activityltCtrl.getPointReward(activityID, serverLv)
		for i = 1, #v.reward / 2 do
			local id = v.reward[2 * i - 1]
			local count = v.reward[2 * i]
			if id == gIDDef.GOLD then
				count = GetPointRewardGold(stageCityLv, count, activityID)
			end
			table.insert(tempreward, id)
			table.insert(tempreward, count)
		end
		v.reward = tempreward
		v.needPoint = GetPointRewardNeedPoint(stageCityLv, v.needPoint)
	end
	return pointreward
end
return activityLogic
