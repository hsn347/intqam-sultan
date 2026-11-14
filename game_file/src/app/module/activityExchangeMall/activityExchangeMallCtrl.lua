local activityExchangeMallRead = include("activityExchangeMallRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activityExchangeMallCtrl = class("activityExchangeMallCtrl", gamemodulec)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
function activityExchangeMallCtrl:getExchangeItemNum(itemID)
	local num = 0
	if itemID == gIDType.PETRA_UNLOCKED_LUCKY_COIN then
		local petraRareTreasureCtrl = gametop.playertop_:getModule("petraRareTreasureCtrl")
		num = petraRareTreasureCtrl:getUnLockLuckyCoin()
	else
		local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
		local haveItem, itemNum = backpackCtrl:isThereTheItem(itemID)
		if haveItem then
			num = itemNum
		end
	end
	return num
end
function activityExchangeMallCtrl:getExchangeNum(activityID, shopItemID)
	local exchangeActivity = self.exchangeMap[tostring(activityID)]
	if exchangeActivity then
		local exchangeInfo = exchangeActivity.exchangeInfo
		if exchangeInfo then
			return exchangeInfo[tostring(shopItemID)] or 0
		end
	end
	return 0
end
function activityExchangeMallCtrl:getConfigByActivityID(activityID, classType)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = classType or activityShowCtrl:getParamClassType(activityID)
	if not activityExchangeMallRead:getShopItemList(activityID, classType) then
		local _ENV, cfg = activityExchangeMallRead:getShopItemList(activityID, classType), activityExchangeMallRead:getShopItemList(activityID, classType)
	end
	for i, v in ipairs(cfg) do
		v.remindStatus = self:getRemindStatus(activityID, v.shopItemID)
		v.curExchangeNum = self:getExchangeNum(activityID, v.shopItemID)
	end
	return cfg
end
function activityExchangeMallCtrl:reqActivityExchange(shopItemId, count, extraData)
	print("activityExchangeMallCtrl:reqActivityExchange", shopItemId, count)
	_ENV = nil
	;(nil).shopItemId = shopItemId
	;(nil).count = count
	;(nil).extraData = extraData
	serverproxy:Request(gCmd.CMD_ACTIVITY_EXCHANGE_MALL_MODULE, gCmd.REQ_ACTIVITY_EXCHANGE, nil)
end
function activityExchangeMallCtrl:reqExchangeRemind(shopItemId, remindStatus)
	serverproxy = nil
	;(nil).shopItemId = shopItemId
	;(nil).remindStatus = remindStatus
	serverproxy:Request(gCmd.CMD_ACTIVITY_EXCHANGE_MALL_MODULE, gCmd.REQ_ACTIVITY_EXCHANGE_REMIND, nil)
end
function activityExchangeMallCtrl:getRemindStatus(activityID, shopItemID)
	local exchangeActivity = self.exchangeMap[tostring(activityID)]
	if exchangeActivity then
		local remindArray = exchangeActivity.remindArray
		if remindArray then
			return remindArray[tostring(shopItemID)] or 1
		end
	end
	return 1
end
function activityExchangeMallCtrl:getPurpleAgateNum()
	local exchangeActivity = self.exchangeMap["9001366"]
	if exchangeActivity then
		local purpleAgate = exchangeActivity.purpleAgate
		return purpleAgate or 0
	end
	return 0
end
function activityExchangeMallCtrl:getReceiveStatusAndNum(activityID, shopType)
	if not activityID then
		return false, 0
	end
	local activityExchangeMallRead = include("activityExchangeMallRead")
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	_ENV = "activityShowCtrl"
	;("activityShowCtrl")[gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010002] = true
	local ("activityShowCtrl")[gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010003], config = true, "activityShowCtrl"
	if not shopType and config[activityID] then
		shopType = activityShowCtrl:getParamClassType(activityID)
	end
	local shopItemList = activityExchangeMallRead:getShopItemList(activityID, shopType)
	if activityID == gActivityTimeActivityID.EXCHANGE_MALL_ARENA then
		shopItemList = activityExchangeMallRead:getShopItemListByRegionId(activityID)
	end
	if shopItemList and shopItemList[1] and shopItemList[1].ignoreCheckOpen ~= 1 and not activityShowCtrl:isActivityOpen(activityID) then
		return false, 0
	end
	local getOwnCountFunc, otherNeedFunc
	_UPVALUE6_ = activityID
	activityID[1] = gActivityTimeActivityID.LEGEND_HEGEMON_1
	activityID[2] = gActivityTimeActivityID.LEGEND_HEGEMON_2
	activityID[3] = gActivityTimeActivityID.LEGEND_HEGEMON_3
	activityID[4] = gActivityTimeActivityID.LEGEND_HEGEMON_4
	activityID[5] = gActivityTimeActivityID.LEGEND_HEGEMON_5
	local activityID[6], hegemonActivityArray = gActivityTimeActivityID.LEGEND_HEGEMON_6, activityID
	if activityID == gActivityTimeActivityID.WRATH_BEAST_ACTIVITY then
		local wrathBeastCtrl = SoraDGetCtrl("wrathBeastCtrl")
		function getOwnCountFunc()
			return wrathBeastCtrl:getActivityData("godBeastGem")
		end
	elseif activityID == gActivityTimeActivityID.EXCHANGE_MALL_ARENA then
		function getOwnCountFunc()
			local arenaCtrl = SoraDGetCtrl("arenaCtrl")
			return arenaCtrl:getArenaTicketNums()
		end
	elseif activityID == gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY then
		function getOwnCountFunc(costItemID)
			local radianceActivityCtrl = SoraDGetCtrl("radianceActivityCtrl")
			return radianceActivityCtrl:getExchangeNum(costItemID)
		end
	elseif activityID == gActivityTimeActivityID.ANCIENT_REEL_ACTIVITY then
		function getOwnCountFunc(costItemID)
			local ancientReelCtrl = SoraDGetCtrl("ancientReelCtrl")
			return ancientReelCtrl:getKingTokenNum()
		end
	elseif activityID == gActivityTimeActivityID.LEGEND_LORD then
		function getOwnCountFunc(costItemID)
			local legendPointsCtrl = SoraDGetCtrl("legendPointsCtrl")
			return legendPointsCtrl:getLegenPoint()
		end
		function otherNeedFunc(shopitem)
			if shopitem == 311301 then
				local param = activityShowCtrl:getParamByID(activityID)
				if param.curState == ACTIVITY_STATE.ACTIVE then
					local endTime = param.timeConfig.settleTime
					local leftTime = endTime - serviceFunctions.systemTime()
					if 0 < leftTime then
						return true
					else
						return false
					end
				elseif param.curState == ACTIVITY_STATE.SETTLE then
					return false
				end
				return false
			end
			return true
		end
	elseif activityID == gActivityTimeActivityID.KING_STAR_BATTLE then
		function getOwnCountFunc(costItemID)
			local legendPointsCtrl = SoraDGetCtrl("legendPointsCtrl")
			return legendPointsCtrl:getKingStarPoint()
		end
		function otherNeedFunc(shopitem)
			if shopitem == 311302 then
				local param = activityShowCtrl:getParamByID(activityID)
				if param.curState == ACTIVITY_STATE.ACTIVE then
					local endTime = param.timeConfig.settleTime
					local leftTime = endTime - serviceFunctions.systemTime()
					if 0 < leftTime then
						return true
					else
						return false
					end
				elseif param.curState == ACTIVITY_STATE.SETTLE then
					return false
				end
				return false
			end
			return true
		end
	elseif SoraDisInList(activityID, hegemonActivityArray) then
		function getOwnCountFunc(costItemID)
			local legendPointsCtrl = SoraDGetCtrl("legendPointsCtrl")
			return legendPointsCtrl:getHegemonPoint()
		end
	elseif activityID == gActivityTimeActivityID.ATLANTIS_WAR_ACTIVITY then
		function getOwnCountFunc(costItemID)
			return self:getPurpleAgateNum()
		end
	elseif activityID == gActivityTimeActivityID.EXCHANGE_MALL_ACTIVITY_9010001 then
		function getOwnCountFunc(costItemID)
			local cityCtrl = SoraDGetCtrl("cityCtrl")
			return cityCtrl:getItemRecycleToken(costItemID)
		end
	elseif activityID == gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010011 then
		function getOwnCountFunc(costItemID)
			local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
			return magicLampSkillCtrl:getExchangeSkillCount(costItemID)
		end
	else
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		function getOwnCountFunc(costItemID)
			return backpackCtrl:getItemCount(costItemID)
		end
	end
	local ret, num = false, 0
	for i, v in ipairs(shopItemList) do
		local remindStatus = self:getRemindStatus(activityID, v.shopItemID)
		if remindStatus == 1 and (v.limitType == 0 or v.limitnum == nil or v.limitnum == 0 or self:getExchangeNum(activityID, v.shopItemID) < v.limitnum) then
			local costItemID = v.exchangeitem
			local costItemNum = v.exchangenum
			local ownCont = getOwnCountFunc(costItemID)
			local exchangeTwo = true
			if v.exchangeitem2 then
				exchangeTwo = getOwnCountFunc(v.exchangeitem2) >= v.exchangenum2
			end
			local otherNeedEnough = true
			if exchangeTwo and otherNeedFunc then
				otherNeedEnough = otherNeedFunc(v.shopitem)
			end
			if costItemNum <= ownCont and exchangeTwo and otherNeedEnough then
				ret = true
				num = num + 1
			end
		end
	end
	return ret and 0 < num, num
end
function activityExchangeMallCtrl:ctor(properties)
	activityExchangeMallCtrl.super.ctor(self, properties)
end
function activityExchangeMallCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ACTIVITY_EXCHANGE_MALL_MODULE, gCmd.REQ_ACTIVITY_EXCHANGE, handler(self, self.activityExchangeRSP))
	msgCtrl.register(gCmd.CMD_ACTIVITY_EXCHANGE_MALL_MODULE, gCmd.REQ_ACTIVITY_EXCHANGE_REMIND, handler(self, self.exchangeRemindRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.ACTIVITY_EXCHANGE_MALL, handler(self, self.onMsg))
	self:resetData()
end
function activityExchangeMallCtrl:resetData()
	self.exchangeMap, _UPVALUE0_ = nil, nil
end
function activityExchangeMallCtrl:Logout()
	activityExchangeMallCtrl.super.Logout(self)
	self:resetData()
end
function activityExchangeMallCtrl:initClientData(data)
