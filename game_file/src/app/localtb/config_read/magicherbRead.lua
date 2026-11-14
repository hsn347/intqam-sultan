local magicherbRead = include("aAReadClass").new()
function magicherbRead.init()
	_UPVALUE2_ = nil
	;(nil)[1] = "magicherb_alliance_award"
	;(nil)[2] = true
	magicherbRead:defineValue("awardCfg", nil)
	magicherbRead.rechargeID = 14476
	magicherbRead:defineValue("rechargeCfg", function()
		magicherbRead.rechargeCfg, magicherbRead = nil, nil
		local recharge_cfg = require_once("app." .. LocalTblPath .. ".config_server.magicherb_recharge")
		for k, v in pairs(recharge_cfg) do
			magicherbRead.rechargeCfg[v.rechargeID] = v
		end
		return magicherbRead.rechargeCfg
	end)
end
function magicherbRead.getRechargePrice(rid)
	local rid = rid or magicherbRead.rechargeID
	return magicherbRead.rechargeCfg[rid].price
end
function magicherbRead.getAward()
	return magicherbRead.awardCfg
end
function magicherbRead.getMaxPlan()
	return magicherbRead.awardCfg[#magicherbRead.awardCfg].plan
end
function magicherbRead.getPlanByIndex(index)
	return magicherbRead.awardCfg[index].plan
end
function magicherbRead.getLvByPlan(plan)
	local lv = 1
	for i = #magicherbRead.awardCfg, 1, -1 do
		if plan >= magicherbRead.awardCfg[i].plan then
			lv = magicherbRead.awardCfg[i].index
			break
		end
	end
	return lv
end
function magicherbRead.getNextLvInfo(plan)
	local nextLv = 0
	local nextPlan = 0
	for k, v in ipairs(magicherbRead.awardCfg) do
		nextPlan = v.plan
		if plan < nextPlan then
			nextLv = v.index
			break
		end
	end
	return nextLv, nextPlan
end
magicherbRead.init()
return magicherbRead
