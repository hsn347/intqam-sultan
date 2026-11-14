local gametop = gModuleMgr.getObject("gametop")
local sultansBackCtrl = gametop.playertop_:getModule("sultansBackCtrl")
local sultansBackRead = include("sultansBackRead")
local buffDesRead = include("buffDesRead")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local _ENV, _ENV, sultansBackRebateUtil = nil, "buffltCtrl", "buffltCtrl"
;(nil).AWARD_STATUES_NORMAL = 1
;(nil).AWARD_STATUES_COMPLETE = 2
local (nil).AWARD_STATUES_GET, AWARD_STATUES = 3, nil
sultansBackRebateUtil.AWARD_STATUES = AWARD_STATUES
function sultansBackRebateUtil.getRoundStatues(info)
	if sultansBackCtrl:isRoundReceive(info.score) then
		return AWARD_STATUES.AWARD_STATUES_GET
	end
	local contributeValue = sultansBackCtrl:getCurPrice()
	if contributeValue >= info.score then
		return AWARD_STATUES.AWARD_STATUES_COMPLETE
	end
	return AWARD_STATUES.AWARD_STATUES_NORMAL
end
function sultansBackRebateUtil.getAwardNum()
	local num = 0
	local boxData = sultansBackRead.getBackRechargeCfg()
	for _, v in ipairs(boxData) do
		local statues = sultansBackRebateUtil.getRoundStatues(v)
		if statues == AWARD_STATUES.AWARD_STATUES_COMPLETE then
			num = num + 1
		end
	end
	return num
end
_ENV, sultansBackRebateUtil.getBuffEffect = function(effectType)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SULTAN_BACK_REBATE_ACTIVITY) then
		return
	end
	local boxData = sultansBackRead.getBackRechargeCfg()
	for _, info in ipairs(boxData) do
		local buff = info.buff
		local buffType = buffltCtrl:getEffectType(buff)
		if buffType == effectType then
			local buffValue = buffltCtrl:getEffect(buff)
			local statues = sultansBackRebateUtil.getRoundStatues(info)
			if statues == AWARD_STATUES.AWARD_STATUES_GET then
				return buffValue
			end
		end
	end
end, function(effectType)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SULTAN_BACK_REBATE_ACTIVITY) then
		return
	end
	local boxData = sultansBackRead.getBackRechargeCfg()
	for _, info in ipairs(boxData) do
		local buff = info.buff
		local buffType = buffltCtrl:getEffectType(buff)
		if buffType == effectType then
			local buffValue = buffltCtrl:getEffect(buff)
			local statues = sultansBackRebateUtil.getRoundStatues(info)
			if statues == AWARD_STATUES.AWARD_STATUES_GET then
				return buffValue
			end
		end
	end
end
;(function(effectType)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SULTAN_BACK_REBATE_ACTIVITY) then
		return
	end
	local boxData = sultansBackRead.getBackRechargeCfg()
	for _, info in ipairs(boxData) do
		local buff = info.buff
		local buffType = buffltCtrl:getEffectType(buff)
		if buffType == effectType then
			local buffValue = buffltCtrl:getEffect(buff)
			local statues = sultansBackRebateUtil.getRoundStatues(info)
			if statues == AWARD_STATUES.AWARD_STATUES_GET then
				return buffValue
			end
		end
	end
end).RECHARGE_GIFT_STATUES_COMPLETE = 1
;(function(effectType)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SULTAN_BACK_REBATE_ACTIVITY) then
		return
	end
	local boxData = sultansBackRead.getBackRechargeCfg()
	for _, info in ipairs(boxData) do
		local buff = info.buff
		local buffType = buffltCtrl:getEffectType(buff)
		if buffType == effectType then
			local buffValue = buffltCtrl:getEffect(buff)
			local statues = sultansBackRebateUtil.getRoundStatues(info)
			if statues == AWARD_STATUES.AWARD_STATUES_GET then
				return buffValue
			end
		end
	end
end).RECHARGE_GIFT_STATUES_NORMAL = 2
local (function(effectType)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SULTAN_BACK_REBATE_ACTIVITY) then
		return
	end
	local boxData = sultansBackRead.getBackRechargeCfg()
	for _, info in ipairs(boxData) do
		local buff = info.buff
		local buffType = buffltCtrl:getEffectType(buff)
		if buffType == effectType then
			local buffValue = buffltCtrl:getEffect(buff)
			local statues = sultansBackRebateUtil.getRoundStatues(info)
			if statues == AWARD_STATUES.AWARD_STATUES_GET then
				return buffValue
			end
		end
	end
end).RECHARGE_GIFT_STATUES_FORBID_NUM, RECHARGE_GIFT_STATUES = 3, function(effectType)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SULTAN_BACK_REBATE_ACTIVITY) then
		return
	end
	local boxData = sultansBackRead.getBackRechargeCfg()
	for _, info in ipairs(boxData) do
		local buff = info.buff
		local buffType = buffltCtrl:getEffectType(buff)
		if buffType == effectType then
			local buffValue = buffltCtrl:getEffect(buff)
			local statues = sultansBackRebateUtil.getRoundStatues(info)
			if statues == AWARD_STATUES.AWARD_STATUES_GET then
				return buffValue
			end
		end
	end
end
sultansBackRebateUtil.RECHARGE_GIFT_STATUES = RECHARGE_GIFT_STATUES
function sultansBackRebateUtil.getRechargeStatues(info)
	local contributeValue = sultansBackCtrl:getCurPrice()
	local extralimit = info.extralimit or 0
	if contributeValue >= extralimit then
		local num = sultansBackCtrl:getRechargeBuyNum(info.rechargeID)
		if 0 < info.extraData and num >= info.extraData then
			return RECHARGE_GIFT_STATUES.RECHARGE_GIFT_STATUES_FORBID_NUM
		end
		return RECHARGE_GIFT_STATUES.RECHARGE_GIFT_STATUES_COMPLETE
	end
	return RECHARGE_GIFT_STATUES.RECHARGE_GIFT_STATUES_NORMAL
end
_ENV, _ENV, sultansBackRebateUtil.getRechargeRedNum = nil, function()
	local num = 0
	local privilegeGiftRead = include("privilegeGiftRead")
	local giftInfo = privilegeGiftRead.getRechargeSultansBack()
	for _, v in ipairs(giftInfo) do
		local statues = sultansBackRebateUtil.getRechargeStatues(v)
		if statues == RECHARGE_GIFT_STATUES.RECHARGE_GIFT_STATUES_COMPLETE then
			num = num + 1
		end
	end
	return num
end, function()
	local num = 0
	local privilegeGiftRead = include("privilegeGiftRead")
	local giftInfo = privilegeGiftRead.getRechargeSultansBack()
	for _, v in ipairs(giftInfo) do
		local statues = sultansBackRebateUtil.getRechargeStatues(v)
		if statues == RECHARGE_GIFT_STATUES.RECHARGE_GIFT_STATUES_COMPLETE then
			num = num + 1
		end
	end
	return num
end
_ENV, (function()
	local num = 0
	local privilegeGiftRead = include("privilegeGiftRead")
	local giftInfo = privilegeGiftRead.getRechargeSultansBack()
	for _, v in ipairs(giftInfo) do
		local statues = sultansBackRebateUtil.getRechargeStatues(v)
		if statues == RECHARGE_GIFT_STATUES.RECHARGE_GIFT_STATUES_COMPLETE then
			num = num + 1
		end
	end
	return num
end)[1], (nil).imgBox = nil, nil, "zsjdh_box1.png"
_ENV, (function()
	local num = 0
	local privilegeGiftRead = include("privilegeGiftRead")
	local giftInfo = privilegeGiftRead.getRechargeSultansBack()
	for _, v in ipairs(giftInfo) do
		local statues = sultansBackRebateUtil.getRechargeStatues(v)
		if statues == RECHARGE_GIFT_STATUES.RECHARGE_GIFT_STATUES_COMPLETE then
			num = num + 1
		end
	end
	return num
end)[2], (nil).imgBox = nil, nil, "zsjdh_box2.png"
_ENV, (function()
	local num = 0
	local privilegeGiftRead = include("privilegeGiftRead")
	local giftInfo = privilegeGiftRead.getRechargeSultansBack()
	for _, v in ipairs(giftInfo) do
		local statues = sultansBackRebateUtil.getRechargeStatues(v)
		if statues == RECHARGE_GIFT_STATUES.RECHARGE_GIFT_STATUES_COMPLETE then
			num = num + 1
		end
	end
	return num
end)[3], (nil).imgBox = nil, nil, "zsjdh_box3.png"
_ENV, (function()
	local num = 0
	local privilegeGiftRead = include("privilegeGiftRead")
	local giftInfo = privilegeGiftRead.getRechargeSultansBack()
	for _, v in ipairs(giftInfo) do
		local statues = sultansBackRebateUtil.getRechargeStatues(v)
		if statues == RECHARGE_GIFT_STATUES.RECHARGE_GIFT_STATUES_COMPLETE then
			num = num + 1
		end
	end
	return num
end)[4], (nil).imgBox = nil, nil, "zsjdh_box4.png"
;(function()
	local num = 0
	local privilegeGiftRead = include("privilegeGiftRead")
	local giftInfo = privilegeGiftRead.getRechargeSultansBack()
	for _, v in ipairs(giftInfo) do
		local statues = sultansBackRebateUtil.getRechargeStatues(v)
		if statues == RECHARGE_GIFT_STATUES.RECHARGE_GIFT_STATUES_COMPLETE then
			num = num + 1
		end
	end
	return num
end)[5], (nil).imgBox = nil, "zsjdh_box5.png"
local function rechargePhasesCfg()
	local num = 0
	local privilegeGiftRead = include("privilegeGiftRead")
	local giftInfo = privilegeGiftRead.getRechargeSultansBack()
	for _, v in ipairs(giftInfo) do
		local statues = sultansBackRebateUtil.getRechargeStatues(v)
		if statues == RECHARGE_GIFT_STATUES.RECHARGE_GIFT_STATUES_COMPLETE then
			num = num + 1
		end
	end
	return num
end
local getRechargePhasesViewCfg = function(round)
	return rechargePhasesCfg[round] or rechargePhasesCfg[1]
end
_ENV, _ENV, sultansBackRebateUtil.getBoxImg = nil, function(round)
	return getRechargePhasesViewCfg(round).imgBox
end, function(round)
	return getRechargePhasesViewCfg(round).imgBox
end
;(nil).imgBox = "icon_hgfl_buff_2_01.png"
_ENV, (function(round)
	return getRechargePhasesViewCfg(round).imgBox
end)[5463], (nil).imgAward = nil, nil, "icon_hgfl_buff_01.png"
;(nil).imgBox = "icon_hgfl_buff_2_02.png"
_ENV, (function(round)
	return getRechargePhasesViewCfg(round).imgBox
end)[5464], (nil).imgAward = nil, nil, "icon_hgfl_buff_02.png"
;(nil).imgBox = "icon_hgfl_buff_2_03.png"
_ENV, (function(round)
	return getRechargePhasesViewCfg(round).imgBox
end)[5465], (nil).imgAward = nil, nil, "icon_hgfl_buff_03.png"
;(nil).imgBox = "icon_hgfl_buff_2_04.png"
_ENV, (function(round)
	return getRechargePhasesViewCfg(round).imgBox
end)[5466], (nil).imgAward = nil, nil, "icon_hgfl_buff_04.png"
;(nil).imgBox = "icon_hgfl_buff_2_05.png"
;(function(round)
	return getRechargePhasesViewCfg(round).imgBox
end)[5467], (nil).imgAward = nil, "icon_hgfl_buff_05.png"
local function rechargeBuffCfg(round)
	return getRechargePhasesViewCfg(round).imgBox
end
local getBuffCfg = function(round)
	return rechargeBuffCfg[round] or rechargeBuffCfg[1]
end
function sultansBackRebateUtil.getBuffImg(round, isBox)
	local cfg = getBuffCfg(round)
	return isBox and cfg.imgBox or cfg.imgAward
end
return sultansBackRebateUtil
