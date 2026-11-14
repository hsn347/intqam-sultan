local _ENV, rechargePresentUtil
local rechargePresentRead = include("rechargePresentRead")
_ENV, rechargePresentUtil.activityID = _G.gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT, _G.gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT
_ENV = nil
;(nil).categoryID = _G.gRechargeCenterCategory.RECHARGE_PRESENT
;(nil).modelType = _G.gRechargeActiveModelType.RECHARGE_PRESENT
rechargePresentUtil.config, _G.gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT[rechargePresentUtil.activityID], (nil).resID = _G.gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT, nil, _G.gIDDef.RECHARGE_PRESENT_GOLD
function rechargePresentUtil.getActivityIDByCategory(category)
	for _activityID, v in pairs(rechargePresentUtil.config) do
		if v.categoryID == category then
			return _activityID
		end
	end
end
function rechargePresentUtil.getActivityIDByModelType(modelType)
	for _activityID, v in pairs(rechargePresentUtil.config) do
		if v.modelType == modelType then
			return _activityID
		end
	end
end
function rechargePresentUtil.getResIdByActivityID(activityID)
	for _activityID, v in pairs(rechargePresentUtil.config) do
		if _activityID == activityID then
			return v.resID
		end
	end
end
function rechargePresentUtil.checkActivityOpen(activityID)
	local err = false
	activityID = activityID or rechargePresentUtil.activityID
	if _G.clientEventMgr.judgeIsOpen(activityID) then
		err = true
	end
	return err
end
function rechargePresentUtil.checkActivityFirstStage(activityID)
	local err = false
	activityID = activityID or rechargePresentUtil.activityID
	if _G.clientEventMgr.judgeIsOpen(activityID) then
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local showData = activityShowCtrl:getShowDataByID(activityID)
		if not showData or not (showData.doStage > 0) then
			local stageTime = activityShowCtrl:getEndTimeSession(activityID, 1)
			if stageTime and not (stageTime < serviceFunctions.systemTime()) then
				err = true
			end
		end
	end
	return err
end
local getRecargeGiftNum = function(rechargeID, activityID)
	activityID = activityID or rechargePresentUtil.activityID
	local num = rechargePresentRead.getRecargeGiftNum(rechargeID, activityID)
	if 0 < num then
		return num
	end
	local rechargePresentCtrl = SoraDGetCtrl("rechargePresentCtrl")
	num = rechargePresentCtrl:getRechargePresentGiftNum(rechargeID, activityID) or 0
	return num
end
rechargePresentUtil.getRecargeGiftNum = getRecargeGiftNum
local checkActivityByRecharge = function(rechargeIDList, activityID)
	activityID = activityID or rechargePresentUtil.activityID
	if not rechargePresentUtil.checkActivityFirstStage(activityID) then
		return false
	end
	for _, v in ipairs(rechargeIDList) do
		local num = getRecargeGiftNum(v.rechargeID, activityID)
		if num and 0 < num then
			return true
		end
	end
	return false
end
rechargePresentUtil.checkActivityByRecharge = checkActivityByRecharge
local checkCanOpenViewByRecharge = function(rechargeIDList)
	if not rechargeIDList or table.nums(rechargeIDList) <= 0 then
		return false
	end
	local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
	for _, v in ipairs(rechargeIDList) do
		local rewardList = rechargeActivityCtrl:getRechargeGift(v.rechargeID)
		if next(rewardList) then
			return true
		end
	end
	return false
end
rechargePresentUtil.checkCanOpenViewByRecharge = checkCanOpenViewByRecharge
local hideNode = function(parent, name)
	local node = parent:getChildByName("CCS_" .. name)
	if node then
		node:setVisible(false)
	end
end
local showNode = function(parent, name, rechargeIDList, pos, scale, viewType)
	local nodeNmae = "CCS_" .. name
	local node = parent:getChildByName(nodeNmae)
	if node then
		node:setVisible(true)
		node:initData(rechargeIDList, viewType or 1)
		node:setPosition(pos)
	else
		node = include(name).new()
		node:initData(rechargeIDList, viewType or 1)
		node:addTo(parent, 999)
		node:setCascadeOpacityEnabled(true)
		node:setName(nodeNmae)
		node:setPosition(pos)
	end
	if scale then
		node:setScale(scale)
	end
	return node
end
local checkCanOpenViewGift = function()
	return _G.clientEventMgr.judgeIsOpen(gActivityTimeActivityID.RECHARGE_ACTIVITY_GIFT_ACTIVITY)
end
rechargePresentUtil.checkCanOpenViewGift = checkCanOpenViewGift
function rechargePresentUtil.isShowNode(rechargeIDList)
	local showGift = checkCanOpenViewByRecharge(rechargeIDList) and checkCanOpenViewGift()
	local showPresent = checkActivityByRecharge(rechargeIDList)
	return showGift or showPresent
end
function rechargePresentUtil.openView(rechargeIDList, parent, pos, scale, viewType, offsetX)
	local showGift = checkCanOpenViewByRecharge(rechargeIDList) and checkCanOpenViewGift()
	if showGift then
		showNode(parent, "rechargeGiftNode", rechargeIDList, pos, scale, viewType)
	else
		hideNode(parent, "rechargeGiftNode")
	end
	local showPresent = checkActivityByRecharge(rechargeIDList)
	if showPresent then
		local node = showNode(parent, "rechargePresentNodeTime", rechargeIDList, pos, scale, viewType)
		node:adjustView(showGift, pos, scale, offsetX)
		node:setLocalZOrder(888)
		local activityID = rechargePresentUtil.activityID
		node:setActivityID(activityID)
	else
		hideNode(parent, "rechargePresentNodeTime")
	end
	return showGift or showPresent
end
function rechargePresentUtil.isShowPresentNode(rechargeIDList)
	local showPresent = checkActivityByRecharge(rechargeIDList)
	if showPresent then
		local activityID = rechargePresentUtil.activityID
		local num = 0
		for _, v in ipairs(rechargeIDList) do
			num = rechargePresentUtil.getRecargeGiftNum(v.rechargeID, activityID)
			if num and 0 < num then
				break
			end
		end
		local resId = rechargePresentUtil.getResIdByActivityID(activityID)
		return true, resId, num
	else
		return false
	end
end
function rechargePresentUtil.openPresentView(rechargeIDList, parent, pos, scale, viewType)
	local showPresent = checkActivityByRecharge(rechargeIDList)
	if showPresent then
		local node = showNode(parent, "rechargePresentNodeGold", rechargeIDList, pos, scale, viewType)
		node:setLocalZOrder(888)
		local activityID = rechargePresentUtil.activityID
		node:setActivityID(activityID)
	else
		hideNode(parent, "rechargePresentNodeGold")
	end
	return showPresent
end
function rechargePresentUtil.getRechargePresentNum(rechargeID, activityID)
	activityID = activityID or rechargePresentUtil.activityID
	if not rechargeID then
		return
	end
	if not rechargePresentUtil.checkActivityFirstStage(activityID) then
		return
	end
	local num = getRecargeGiftNum(rechargeID, activityID)
	if not num or num <= 0 then
		return
	end
	rechargePresentUtil = rechargeID
	rechargeID.id = rechargePresentUtil.getResIdByActivityID(activityID)
	rechargeID.num = num
	rechargeID.count = num
	return rechargeID
end
function rechargePresentUtil.fixRechargePresentData(rechargeID, giftData, highlight)
	local isAdd = rechargePresentUtil.getRechargePresentNum(rechargeID)
	if isAdd then
		giftData = clone(giftData)
		table.insert(giftData, 1, isAdd)
		if highlight and type(highlight) == "table" then
			highlight = clone(highlight)
			if tonumber(highlight[1]) ~= 0 then
				for i = 1, #highlight do
					highlight[i] = highlight[i] + 1
				end
				table.insert(highlight, 1, 1)
			else
				highlight[1] = 1
			end
		end
	end
	rechargePresentUtil = table.insert
	table.insert.gift = giftData
	table.insert.highlight = highlight
	table.insert.isAdd = isAdd
	return table.insert
end
function rechargePresentUtil.setInheritGiftSpecialData(giftData, highlight)
	dump(giftData, "rechargePresentUtil.setInheritGiftSpecialData")
	for i, v in pairs(giftData) do
		v.highlight = false
	end
	for i, v in pairs(highlight) do
		giftData[v].highlight = true
	end
	return giftData
end
function rechargePresentUtil.openRechargeView(activityID)
	activityID = activityID or rechargePresentUtil.activityID
	local config = rechargePresentUtil.config[activityID]
	if GLOBAL_GAME_RECHARGE_MODE then
		rechargePresentUtil = nil
		;(nil).toCategory = config.categoryID
		uiManager:show("rechargeView", nil)
	else
		local panel = SoraDSearchPanelFromManagerByName("rechargeView")
		if panel then
			panel:expect2SelectTab(config.categoryID, activityID)
		else
			panel = SoraDCreatePanel("rechargeView")
			panel:expect2SelectTab(config.categoryID, activityID)
			panel:show()
		end
	end
end
function rechargePresentUtil.openRechargeViewLimit(activityID)
	activityID = activityID or rechargePresentUtil.activityID
	if not rechargePresentUtil.checkActivityFirstStage(activityID) then
		if activityID == rechargePresentUtil.activityID then
			SoraDShowMsgTip(i18n("sudanGift_text_08"))
		else
			SoraDShowMsgTip(i18n("NewYear_Gift_11"))
		end
		return
	end
	if GLOBAL_GAME_RECHARGE_MODE then
		if SoraDcheckLimitData() then
			rechargePresentUtil = i18n("NewYear_Gift_11")
			i18n("NewYear_Gift_11").toCategory = _G.gRechargeCenterCategory.LIMITGIFT
			uiManager:show("rechargeView", i18n("NewYear_Gift_11"))
		else
			rechargePresentUtil = i18n("NewYear_Gift_11")
			i18n("NewYear_Gift_11").toCategory = _G.gRechargeCenterCategory.GOLD
			uiManager:show("rechargeView", i18n("NewYear_Gift_11"))
		end
	else
		local panel = SoraDSearchPanelFromManagerByName("rechargeView")
		if panel then
			if panel:checkLimitData() then
				panel:expect2SelectTab(_G.gRechargeCenterCategory.LIMITGIFT)
			else
				panel:expect2SelectTab(_G.gRechargeCenterCategory.GOLD)
			end
		else
			panel = SoraDCreatePanel("rechargeView")
			if panel:checkLimitData() then
				panel:expect2SelectTab(_G.gRechargeCenterCategory.LIMITGIFT)
			else
				panel:expect2SelectTab(_G.gRechargeCenterCategory.GOLD)
			end
			panel:show()
		end
	end
end
function rechargePresentUtil.getActivityLeftTime(activityID)
	activityID = activityID or rechargePresentUtil.activityID
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local leftTime = 0
	if activityShowCtrl:isActivityOpen(activityID) then
		local showData = activityShowCtrl:getShowDataByID(activityID)
		if showData and showData.endtime then
			leftTime = showData.endtime - serviceFunctions.systemTime()
			if leftTime <= 0 then
				leftTime = 0
			end
		end
	end
	return leftTime
end
function rechargePresentUtil.getActivityClassType(activityID)
	activityID = activityID or rechargePresentUtil.activityID
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	return activityShowCtrl:getParamClassType(activityID)
end
function rechargePresentUtil.getRechargePresentExchangeNum(info, activityID)
	activityID = activityID or rechargePresentUtil.activityID
	local num = info.limitNum or 0
	local rechargePresentCtrl = SoraDGetCtrl("rechargePresentCtrl")
	local buyNum = rechargePresentCtrl:getRechargePresentBuyNum(info.rechargeID, activityID)
	if buyNum and 0 < buyNum then
		num = math.max(0, num - buyNum)
	end
	return num
end
function rechargePresentUtil.getInheritGiftNum(info)
	local num = info.limitNum or 0
	local inheritGiftCtrl = SoraDGetCtrl("inheritGiftCtrl")
	dump(info, " rechargePresentUtil.getInheritGiftNu")
	local buyNum = inheritGiftCtrl:getInheritExchangeTimesByRecgargeID(info.rechargeID)
	dump(buyNum, "wrwrwrerer")
	if buyNum and 0 < buyNum then
		num = math.max(0, num - buyNum)
		dump(num, "fskfskflskl")
	end
	return num
end
function rechargePresentUtil.getRechargePresentExchangeGold(info)
	local count = info.exchangeID and info.exchangeID[2] or 0
	return count
end
local showLimitBox = function(info, presentGold, count, activityID)
	activityID = activityID or rechargePresentUtil.activityID
	local panel = SoraDCreatePanel("commonLimitBox")
	panel:setImageTouchEnable()
	local rechargePresentUtil, lockInfo = panel.setImageTouchEnable, panel.setImageTouchEnable
	local resId = rechargePresentUtil.getResIdByActivityID(activityID)
	local resDesRead = include("resDesRead")
	local iconName = resDesRead.getIcon(resId)
	rechargePresentUtil = nil
	;(nil).content = string.format("%s/%s", string.formatnumberthousands(presentGold), string.formatnumberthousands(count))
	;(nil).icon = iconName
	;(nil).btnTitle = i18n("common_text_477")
	;(nil).btnFun = function(target)
		rechargePresentUtil.openRechargeViewLimit(activityID)
		target:close(target, ccui.TouchEventType.ended)
	end
	;(nil).isReach = false
	table.insert(lockInfo, nil)
	if panel:judgeData(lockInfo) then
		panel:initData(lockInfo)
		panel:setTitle(i18n("sudanGift_text_02"))
		panel:show()
	end
end
function rechargePresentUtil.checkPresentExchange(info, activityID)
	local err = false
	activityID = activityID or rechargePresentUtil.activityID
	if rechargePresentUtil.checkActivityOpen(activityID) then
		if rechargePresentUtil.getRechargePresentExchangeNum(info, activityID) <= 0 then
			if info.limitType == gRechargeType.DAY_BUY then
				SoraDShowMsgTip(i18n("common_text_2632"))
			else
				SoraDShowMsgTip(i18n("common_text_4570"))
			end
		else
			local rechargePresentCtrl = SoraDGetCtrl("rechargePresentCtrl")
			local presentGold = rechargePresentCtrl:getRechargePresentGold(activityID)
			local count = rechargePresentUtil.getRechargePresentExchangeGold(info)
			local bDisable = presentGold < count
			if bDisable then
				showLimitBox(info, presentGold, count, activityID)
			else
				err = true
			end
		end
	end
	return err
end
function rechargePresentUtil.isSkipBuyTipsCheck(activityID)
	local configKey = "Game:rechargePresentUtil:saveTime~integer"
	_ENV = nil
	;(nil).byUID = true
	local keepTime = tonumber(SoraDConfigGet(configKey, nil)) or 0
	if keepTime < serviceFunctions.systemTime() then
		return false
	else
		return true
	end
end
function rechargePresentUtil.setSkipBuyTipsCheck(isSkip, activityID)
	local configKey = "Game:rechargePresentUtil:saveTime~integer"
	if isSkip then
		local noticeModule = include("noticeModule")
		local keepTime = noticeModule.reFutureDayTheTime(1, 0, 0, 0) + serviceFunctions.systemTime()
		_ENV = 0
		;(0).byUID = true
		SoraDConfigSet(configKey, keepTime, 0)
	else
		_ENV = configKey
		configKey.byUID = true
		SoraDConfigSet(configKey, 0, configKey)
	end
end
function rechargePresentUtil.sendPresentGiftExchange(info, activityID)
	activityID = activityID or rechargePresentUtil.activityID
	if not rechargePresentUtil.checkPresentExchange(info, activityID) then
		return false
	end
	local buyFunc = function(activityID)
		local rechargePresentCtrl = SoraDGetCtrl("rechargePresentCtrl")
		rechargePresentCtrl:sendPresentGiftExchange(info.rechargeID, activityID)
		return true
	end
	if not rechargePresentUtil.isSkipBuyTipsCheck(activityID) then
		local count = rechargePresentUtil.getRechargePresentExchangeGold(info)
		rechargePresentUtil = nil
		;(nil).num = count
		local tip = i18n("sudanGift_text_13", nil)
		local checkTip = i18n("sudanGift_text_14")
		SoraDShowBuyBox(tip, nil, nil, function(exitType, other)
			if exitType ~= MSGBOX_CALLBACK_YES then
				return
			end
			rechargePresentUtil.setSkipBuyTipsCheck(other.isCheck, activityID)
			buyFunc(activityID)
		end, nil, nil, nil, nil, nil, checkTip, false)
	else
		buyFunc(activityID)
	end
end
function rechargePresentUtil.openActivityView(activityID)
	SoraDCreatePanel("rechargePresentActivity"):show()
end
function rechargePresentUtil.checkShowHighLight(resID)
	for _activityID, v in pairs(rechargePresentUtil.config) do
		if v.resID == resID then
			return true
		end
	end
	return false
end
return rechargePresentUtil
