local rechargeltCtrl = include("aAReadClass").new()
function rechargeltCtrl.init()
	_UPVALUE2_ = nil
	;(nil)[1] = "recharge_first_activity"
	;(nil)[2] = true
	rechargeltCtrl:defineValue("recharge_first_activity", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "recharge_day_first_activity"
	;(nil)[2] = true
	rechargeltCtrl:defineValue("recharge_day_first_activity", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "recharge_first_daily_reward"
	;(nil)[2] = true
	rechargeltCtrl:defineValue("recharge_first_daily_reward", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "carnival_septet_integral_table"
	;(nil)[2] = true
	rechargeltCtrl:defineValue("carnival_septet_integral_table", nil)
	rechargeltCtrl:defineValue("hero_recruit_recharge", function()
		rechargeltCtrl.hero_recruit_recharge, rechargeltCtrl = nil, nil
		local hero_recruit_recharge = require_once("app." .. LocalTblPath .. ".config_server.hero_recruit_recharge")
		for i, v in ipairs(hero_recruit_recharge) do
			rechargeltCtrl = nil
			;(nil).giftId = v.giftId
			;(nil).price = v.price
			;(nil).originalPrice = v.originalPrice
			;(nil).gift = v.gift
			rechargeltCtrl.hero_recruit_recharge[v.heroId], (nil).limitNum = nil, v.limitNum
		end
		return rechargeltCtrl.hero_recruit_recharge
	end)
end
function rechargeltCtrl.initCrazyActivity(activityID)
	if activityID == gActivityTimeActivityID.NEW_CRAZY_SEPTET_ACTIVITY then
		rechargeltCtrl.recharge_total_config = require_once("app." .. LocalTblPath .. ".config_server.recharge_total_config_seven_new")
		rechargeltCtrl.crazyTrioSevenGiftConfig = require_once("app." .. LocalTblPath .. ".config_server.recommended_gift_bag_new")
	elseif activityID == gActivityTimeActivityID.CRAZY_SEPTET_ACTIVITY then
		rechargeltCtrl.recharge_total_config = require_once("app." .. LocalTblPath .. ".config_server.recharge_total_config_seven")
		rechargeltCtrl.crazyTrioSevenGiftConfig = require_once("app." .. LocalTblPath .. ".config_server.recommended_gift_bag")
	elseif activityID == gActivityTimeActivityID.CRAZY_TRIO_ACTIVITY then
		rechargeltCtrl.recharge_total_config = require_once("app." .. LocalTblPath .. ".config_server.recharge_total_config")
	end
end
function rechargeltCtrl.getRechargeFirstReward()
	return rechargeltCtrl.recharge_first_activity
end
function rechargeltCtrl.getRechargeDayFirstReward()
	return rechargeltCtrl.recharge_day_first_activity
end
function rechargeltCtrl.getRechargeTotalConfig()
	return rechargeltCtrl.recharge_total_config
end
function rechargeltCtrl.getRechargeTotalConfigSeven(index)
	return rechargeltCtrl.recharge_total_config[index]
end
function rechargeltCtrl.getCrazyTrioSevenGiftConfig(index)
	local _ENV, ret
	for _, giftID in pairs(rechargeltCtrl.recharge_total_config[index].recommendId) do
		local info = serviceFunctions.table_copy_table(rechargeltCtrl.crazyTrioSevenGiftConfig[giftID])
		local ladderGiftCtrl = SoraDGetCtrl("ladderGiftCtrl")
		if info.jumpType == 2 and clientEventMgr.judgeIsOpen(info.activityID) then
			if info.activityID == gActivityTimeActivityID.ORIENT_PRINCE_GIFT then
				local princeGiftCtrl = SoraDGetCtrl("princeGiftCtrl")
				if not princeGiftCtrl:isGiftBuy(giftID) then
					table.insert(ret, info)
				end
			elseif info.activityID == gActivityTimeActivityID.VALUE_REBATE_ACTIVITY then
				local ladderGiftCtrl = SoraDGetCtrl("ladderGiftCtrl")
				print("getCrazyTrioSevenGiftConfig", ladderGiftCtrl:getGrowUpBuyRecord(giftID), giftID)
				if not ladderGiftCtrl:getGrowUpBuyRecord(giftID) then
					table.insert(ret, info)
				end
			else
				table.insert(ret, info)
			end
		elseif info.jumpType == 1 then
			local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
			local giftInfo = rechargeActivityCtrl:getRechargeActivityData(giftID)
			if giftInfo then
				table.insert(ret, info)
			end
		elseif info.jumpType == 3 then
			local privilegeGiftCtrl = SoraDGetCtrl("privilegeGiftCtrl")
			local retValue = privilegeGiftCtrl:getErrByRechargeID(giftID)
			if retValue ~= gErrDef.Err_PRIVILEGE_GIFT_ALREADY_BUY then
				table.insert(ret, info)
			end
		elseif info.jumpType == 4 and clientEventMgr.judgeIsOpen(info.activityID) then
			local princeGiftNewCtrl = SoraDGetCtrl("princeGiftNewCtrl")
			if not princeGiftNewCtrl:getIsBuy() then
				table.insert(ret, info)
			end
		end
	end
	_ENV = pairs(rechargeltCtrl.recharge_total_config[index].recommendId)
	pairs(rechargeltCtrl.recharge_total_config[index].recommendId).recommendPicture = "bg_qcz_img_09.png"
	table.insert(ret, pairs(rechargeltCtrl.recharge_total_config[index].recommendId))
	return ret
end
function rechargeltCtrl.getGiftConfigByIndex(index)
	return rechargeltCtrl.crazyTrioSevenGiftConfig[index]
end
function rechargeltCtrl.getRechargeTotalConfigNum()
	return table.nums(rechargeltCtrl.recharge_total_config)
end
function rechargeltCtrl.getRechargeFirstDailyConfig()
	return rechargeltCtrl.recharge_first_daily_reward
end
function rechargeltCtrl.getHeroRecruitInfo(heroId)
	if heroId then
		return rechargeltCtrl.hero_recruit_recharge[heroId]
	else
		return rechargeltCtrl.hero_recruit_recharge
	end
end
function rechargeltCtrl.getVarTable()
	local _ENV, ret
	local index = 1
	for i, v in ipairs(rechargeltCtrl.carnival_septet_integral_table) do
		ret["var" .. index] = "$" .. v.quota
		ret["var" .. index + 1] = string.formatnumberthousands(v.integral)
		index = index + 2
	end
	return ret
end
rechargeltCtrl.init()
return rechargeltCtrl
