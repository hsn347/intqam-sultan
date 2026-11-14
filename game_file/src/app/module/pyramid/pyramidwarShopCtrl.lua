local GameModule = include("GameModule")
local pyramidwarShopCtrl = class("pyramidwarShopCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function pyramidwarShopCtrl:ctor(properties)
	pyramidwarShopCtrl.super.ctor(self, properties)
end
function pyramidwarShopCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_SHOP_MODULE, gCmd.REQ_PYRAMIDWAR_SHOP_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_SHOP_MODULE, gCmd.REQ_PYRAMIDWAR_SHOP_BUY, handler(self, self.shopBuyRsp))
	msgCtrl.register(gCmd.CMD_PYRAMIDWAR_SHOP_MODULE, gCmd.REQ_PYRAMIDWAR_INFORM_SET, handler(self, self.informSetRsp))
	self:resetData()
	self:registerNotify()
end
function pyramidwarShopCtrl:initPyramid(...)
	self:initData()
end
function pyramidwarShopCtrl:resetData()
	self.pyramidShopData, _UPVALUE0_ = nil, nil
end
function pyramidwarShopCtrl:Logout()
	self:resetData()
	pyramidwarShopCtrl.super.Logout(self)
end
function pyramidwarShopCtrl:initClientData(content)
	if not content then
		return
	end
	self.pyramidShopData = content
	dump(self.pyramidShopData, "pyramidwarShopCtrl:initClientData===")
end
function pyramidwarShopCtrl:reqInitRsp(content)
	dump(content, "pyramidwarShopCtrl:reqInitRsp===", 10)
	if content.err == gErrDef.Err_None then
	end
end
function pyramidwarShopCtrl:shopBuyRsp(content)
	dump(content, "pyramidwarShopCtrl:shopBuyRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.pyramidShopData = content.rspdata.initdata
		if content.rspdata.rewardInfo then
			SoraDMailGainItems(content.rspdata.rewardInfo, true)
		end
		_ENV = content.rspdata.rewardInfo
		content.rspdata.rewardInfo.msg = "MESSAGE_PYRAMID_SHOP_EXCHANGE_REFRESH"
		SoraDSendMessage(content.rspdata.rewardInfo)
		_ENV = content.rspdata.rewardInfo
		content.rspdata.rewardInfo.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.rewardInfo.eventID = gActivityCenterUIEnum.PYRAMID_BATTLE
		SoraDSendMessage(content.rspdata.rewardInfo)
	end
end
function pyramidwarShopCtrl:informSetRsp(content)
	dump(content, "pyramidwarShopCtrl:informSetRsp===", 10)
	if content.err == gErrDef.Err_None then
		if self.pyramidShopData and self.pyramidShopData.ignoreInform then
			self.pyramidShopData.ignoreInform = content.rspdata.ignoreInform
		end
		_ENV = content.rspdata.ignoreInform
		content.rspdata.ignoreInform.msg = "MESSAGE_PYRAMID_SHOP_NOTICE_REFRESH"
		SoraDSendMessage(content.rspdata.ignoreInform)
		_ENV = content.rspdata.ignoreInform
		content.rspdata.ignoreInform.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.ignoreInform.eventID = gActivityCenterUIEnum.PYRAMID_BATTLE
		SoraDSendMessage(content.rspdata.ignoreInform)
	end
end
function pyramidwarShopCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.PYRAMIDWAR_SHOP, handler(self, self.notifyPyramid))
end
function pyramidwarShopCtrl:notifyPyramid(event)
	local content = event.data[1]
	if content then
		if content.type == "init" then
			self.pyramidShopData = content.data
		end
		_ENV = nil
		;(nil).msg = "MESSAGE_PYRAMID_SHOP_COMMON_REFRESH"
		SoraDSendMessage(nil)
	end
end
function pyramidwarShopCtrl:getReceiveStatusAndNum(activityID)
	local show, num = false, -1
	local canExchangeNumRegular = 0
	local canExchangeNumPeak = 0
	if activityID == gActivityCenterUIEnum.PYRAMID_BATTLE then
		local allianceWarltCtrl = include("allianceWarltCtrl")
		local shopInfo1 = allianceWarltCtrl.getShopItemInfo(gSeasonType.REGULAR_SEASON)
		local shopInfo2 = allianceWarltCtrl.getShopItemInfo(gSeasonType.PINNACLE_SEASON)
		local regularScore = self:getRegularScore()
		local peakScore = self:getPeakScore()
		for i, v in ipairs(shopInfo1) do
			local alreadyExchangeTimes = self:getExchangedTimes(gSeasonType.REGULAR_SEASON, v.shopId)
			local remainTimes = v.limit - alreadyExchangeTimes
			local remindTag = self:getNoticeByShopId(v.shopId)
			if 0 < remainTimes and regularScore >= v.point and remindTag then
				canExchangeNumRegular = canExchangeNumRegular + 1
			end
		end
		for i, v in ipairs(shopInfo2) do
			local alreadyExchangeTimes = self:getExchangedTimes(gSeasonType.PINNACLE_SEASON, v.shopId)
			local remainTimes = v.limit - alreadyExchangeTimes
			local remindTag = self:getNoticeByShopId(v.shopId)
			if 0 < remainTimes and peakScore >= v.point and remindTag then
				canExchangeNumPeak = canExchangeNumPeak + 1
			end
		end
		if 0 < canExchangeNumPeak + canExchangeNumRegular then
			show = true
		end
	end
	return show, num, canExchangeNumRegular, canExchangeNumPeak
end
function pyramidwarShopCtrl:getRegularScore()
	local regularScore = 0
	if self.pyramidShopData and self.pyramidShopData.normalShopPoint then
		regularScore = math.floor(self.pyramidShopData.normalShopPoint)
	end
	return regularScore
end
function pyramidwarShopCtrl:getPeakScore()
	local peakScore = 0
	if self.pyramidShopData and self.pyramidShopData.superShopPoint then
		peakScore = math.floor(self.pyramidShopData.superShopPoint)
	end
	return peakScore
end
function pyramidwarShopCtrl:getExchangedTimes(gameType, shopId)
	local alreadyExchangeTimes = 0
	local _ENV, commonChangeTable
	if gameType == gSeasonType.REGULAR_SEASON and self.pyramidShopData and self.pyramidShopData.normalBuyInfo then
		commonChangeTable = self.pyramidShopData.normalBuyInfo
	elseif gameType == gSeasonType.PINNACLE_SEASON and self.pyramidShopData and self.pyramidShopData.superBuyInfo then
		commonChangeTable = self.pyramidShopData.superBuyInfo
	end
	if commonChangeTable[tostring(shopId)] then
		alreadyExchangeTimes = commonChangeTable[tostring(shopId)]
	end
	return alreadyExchangeTimes
end
function pyramidwarShopCtrl:getNoticeByShopId(shopId)
	local isItemIgnore = true
	if self.pyramidShopData and self.pyramidShopData.ignoreInform and self.pyramidShopData.ignoreInform[tostring(shopId)] then
		isItemIgnore = self.pyramidShopData.ignoreInform[tostring(shopId)] == 1
	end
	return isItemIgnore
end
function pyramidwarShopCtrl:getRemainTime()
	local remainTime = serviceFunctions.getNextWeekDayUTC(1, serviceFunctions.systemTime()) - serviceFunctions.systemTime()
	return remainTime
end
function pyramidwarShopCtrl:getScoreDetail(matchType)
	local _ENV, detail
	if matchType == gSeasonType.REGULAR_SEASON then
		detail, _ENV = self.pyramidShopData.normalShopPointInfo, self.pyramidShopData.normalShopPointInfo
		detail = self.pyramidShopData.normalShopPointInfo or nil
	elseif matchType == gSeasonType.PINNACLE_SEASON then
		detail, _ENV = self.pyramidShopData.superShopPointInfo, self.pyramidShopData.superShopPointInfo
		detail = self.pyramidShopData.superShopPointInfo or nil
	end
	return detail
end
function pyramidwarShopCtrl:sendInitData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_PYRAMIDWAR_SHOP_MODULE, gCmd.REQ_PYRAMIDWAR_SHOP_INIT, nil)
end
function pyramidwarShopCtrl:reqShopBuy(shopID, count)
	serverproxy = nil
	;(nil).shopID = shopID
	local (nil).count, data = count, nil
	serverproxy:Request(gCmd.CMD_PYRAMIDWAR_SHOP_MODULE, gCmd.REQ_PYRAMIDWAR_SHOP_BUY, data)
end
function pyramidwarShopCtrl:reqSetNotice(shopID, status)
	serverproxy = nil
	;(nil).shopID = shopID
	local (nil).status, data = status, nil
	serverproxy:Request(gCmd.CMD_PYRAMIDWAR_SHOP_MODULE, gCmd.REQ_PYRAMIDWAR_INFORM_SET, data)
end
return pyramidwarShopCtrl
