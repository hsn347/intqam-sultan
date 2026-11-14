local luxuryRebateRead = include("aAReadClass").new()
local LocalTblPath = _G.LocalTblPath
local luxuryRechargeBoxItem
local luxuryRechargeBoxDay = 3
local lazyInitBoxItem = function()
	if not luxuryRechargeBoxItem then
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.luxury_recharge_box")
		if not cfg or not cfg[1] then
			local luxuryRechargeBoxItem, boxCfg = cfg[1], cfg[1]
		end
		if not boxCfg or not boxCfg.award then
			luxuryRechargeBoxItem = boxCfg.award
		end
		LocalTblPath = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		local item = serviceFunctions.tableFormat(boxCfg.award, nil)
		item = {}
	end
end
function luxuryRebateRead.getBoxAwardItem()
	lazyInitBoxItem()
	return luxuryRechargeBoxItem
end
function luxuryRebateRead.getBoxAwardDay()
	lazyInitBoxItem()
	return luxuryRechargeBoxDay
end
local luxuryRechargeGiftID
local luxuryRechargeGiftPrice = 3
local lazyInitGiftID = function()
	if not luxuryRechargeGiftID then
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.luxury_recharge_gift")
		if not (cfg and next(cfg)) or not cfg[next(cfg)] then
			local luxuryRechargeGiftID, giftCfg = cfg[next(cfg)], cfg[next(cfg)]
		end
	end
end
function luxuryRebateRead.getGiftID()
	lazyInitGiftID()
	return luxuryRechargeGiftID
end
function luxuryRebateRead.getGiftPrice()
	lazyInitGiftID()
	return luxuryRechargeGiftPrice
end
local luxuryAwardCfg
local lazyInitAwardItem = function()
	if not luxuryAwardCfg then
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.luxury_recharge_reward")
		local luxuryAwardCfg, award = "app." .. LocalTblPath .. ".config_server.luxury_recharge_reward", "app." .. LocalTblPath .. ".config_server.luxury_recharge_reward"
		for _, v in ipairs(cfg) do
			local awardDay = award[v.day]
			if not awardDay then
				awardDay, luxuryAwardCfg = nil, nil
				award[v.day] = awardDay
			end
			local luxuryAwardCfg, awardItem = v.day, v.day
			awardItem.day = v.day
			awardItem.day_key = tostring(v.day)
			awardItem.class = tostring(v.class)
			awardItem.recharge = v.recharge
			if not v.award1 then
				luxuryAwardCfg = v.award1
			end
			LocalTblPath = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			awardItem.awardNormal = serviceFunctions.tableFormat(v.award1, nil)
			if not v.award2 then
				luxuryAwardCfg = v.award2
			end
			LocalTblPath = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			awardItem.awardGod = serviceFunctions.tableFormat(v.award2, nil)
			awardDay[#awardDay + 1] = awardItem
		end
		award = {}
	end
end
function luxuryRebateRead.getAwardListByDay(day)
	lazyInitAwardItem()
	if not luxuryAwardCfg[day] then
		lazyInitAwardItem = luxuryAwardCfg[day]
	end
	return luxuryAwardCfg[day]
end
return luxuryRebateRead
