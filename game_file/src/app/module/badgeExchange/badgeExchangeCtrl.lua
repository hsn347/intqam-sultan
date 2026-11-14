local GameModule = include("GameModule")
local badgeExchangeCtrl = class("badgeExchangeCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local badgeExchangeRead = include("badgeExchangeRead")
function badgeExchangeCtrl:ctor(properties)
	badgeExchangeCtrl.super.ctor(self, properties)
end
function badgeExchangeCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_BADGE_EXCHANGE_MODULE, gCmd.REQ_BADGE_EXCHANGE_OPEN_PAGE, handler(self, self.getOpenPageResp))
	msgCtrl.register(gCmd.CMD_BADGE_EXCHANGE_MODULE, gCmd.REQ_BADGE_EXCHANGE_SEND, handler(self, self.getBadgeExchangeResp))
	msgCtrl = gCmd.REQ_BADGE_EXCHANGE_SEND
	gCmd.REQ_BADGE_EXCHANGE_SEND.name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(gCmd.REQ_BADGE_EXCHANGE_SEND)
	self:resetData()
end
function badgeExchangeCtrl:resetData()
	self.curExchangeNumMap, _UPVALUE0_ = nil, nil
end
function badgeExchangeCtrl:Logout()
	self:resetData()
	badgeExchangeCtrl.super.Logout(self)
end
function badgeExchangeCtrl:initClientData(data)
	dump(data, "badgeExchangeCtrl")
	if not data then
		return
	end
	if not data.curExchangeNumMap then
		_ENV = data.curExchangeNumMap
	end
	self.curExchangeNumMap = data.curExchangeNumMap
	self:registerNotify()
end
function badgeExchangeCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.BADGE_EXCHANGE, handler(self, self.notifyHandler))
end
function badgeExchangeCtrl:notifyHandler(event)
	if event and event.data then
		for _, content in pairs(event.data) do
			if content and content.curExchangeNumMap then
				self.curExchangeNumMap = content.curExchangeNumMap
			end
		end
		_ENV = pairs(event.data)
		pairs(event.data).msg = "MESSAGE_SERVER_BADGE_DAILY_REFRESH"
		SoraDSendMessage(pairs(event.data))
	end
end
function badgeExchangeCtrl:getOpenPageResp(ret)
	dump(ret, "badgeExchangeCtrl:getOpenPageResp", 10)
	if gErrDef.Err_BADGE_EXCHANGE_LV_NOT_ENOUGH == ret.err then
	elseif gErrDef.Err_None == ret.err then
		self.curExchangeNumMap = ret.data.curExchangeNumMap
	end
end
function badgeExchangeCtrl:getBadgeExchangeResp(ret)
	dump(ret, "badgeExchangeCtrl:getBadgeExchangeResp", 10)
	if gErrDef.Err_None == ret.err then
		self.curExchangeNumMap = ret.data.curExchangeNumMap
		local rewards = ret.data.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
	end
	_ENV = SoraDMailGainItems
	SoraDMailGainItems.msg = "MESSAGE_SERVER_BADGE_EXCHANGE_BACK"
	SoraDMailGainItems.err = ret.err
	SoraDMailGainItems.data = ret.data
	SoraDSendMessage(SoraDMailGainItems)
end
function badgeExchangeCtrl:sendOpenPage(badgeType)
	local serverproxy, data
	data.badgeType = badgeType
	serverproxy:Request(gCmd.CMD_BADGE_EXCHANGE_MODULE, gCmd.REQ_BADGE_EXCHANGE_OPEN_PAGE, data)
end
function badgeExchangeCtrl:sendExchange(nType, exchangeNum, badgeType)
	local serverproxy, data
	data.nType = nType
	data.exchangeNum = exchangeNum
	data.badgeType = badgeType
	serverproxy:Request(gCmd.CMD_BADGE_EXCHANGE_MODULE, gCmd.REQ_BADGE_EXCHANGE_SEND, data)
end
function badgeExchangeCtrl:isOpenBadge(badgeType)
	local badgeType = badgeType or gBadgeExchangeType.COMMON_BADGE_TYPE
	local cfg = badgeExchangeRead.getOpenType(badgeType)
	local tec = badgeExchangeRead.getTecSet(badgeType)
	local ret = false
	local lv = 0
	local unlockTec = false
	if next(tec) then
		local technologyCtrl = SoraDGetCtrl("technologyCtrl")
		for _, tid in ipairs(tec) do
			if technologyCtrl:isActiveTech(tid) then
				unlockTec = true
				break
			end
		end
	else
		unlockTec = true
	end
	if next(cfg) then
		if cfg[1] == 1 then
			local buildLv = SoraDGetBuildLv(cfg[2])
			ret = buildLv >= cfg[3] and buildLv <= cfg[4]
			lv = cfg[3]
		elseif cfg[1] == 2 then
			local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
			local jinnLv = magicLampCtrl:getJinnLv(cfg[2])
			ret = jinnLv >= cfg[3] and jinnLv <= cfg[4]
			lv = cfg[3]
		elseif cfg[1] == 3 then
			local starLv = SoraDGetBuildStarLv(cfg[2])
			ret = starLv >= cfg[3] and starLv <= cfg[4]
			lv = cfg[3]
		elseif cfg[1] == 4 then
			local magicLampHatchCtrl = SoraDGetCtrl("magicLampHatchCtrl")
			local jinnLv = magicLampHatchCtrl:getHatchLv(cfg[2])
			ret = jinnLv >= cfg[3] and jinnLv <= cfg[4]
			lv = cfg[3]
		elseif cfg[1] == 5 then
			local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
			local stepLv = divineBeastCtrl:getStepLv(cfg[2])
			ret = stepLv >= cfg[3] and stepLv <= cfg[4]
			lv = cfg[3]
		end
		if next(tec) then
			ret = ret and unlockTec
		end
	else
		ret = unlockTec
	end
	return ret, lv
end
function badgeExchangeCtrl:getMostLimit(badgeType)
	local badgeType = badgeType or gBadgeExchangeType.COMMON_BADGE_TYPE
	return badgeExchangeRead.getLimitNum(badgeType)
end
function badgeExchangeCtrl:getLeftTime(tabPage)
	local limitType = badgeExchangeRead.getTimeLimitType(tabPage)
	if limitType == 1 then
		return serviceFunctions.getTomorrowZeroHourUTC() - serviceFunctions.systemTime()
	elseif limitType == 2 then
		return serviceFunctions.getNextWeekDayUTC(1) - serviceFunctions.systemTime()
	end
	return 0
end
function badgeExchangeCtrl:getCurExchageNum(badgeType)
	local badgeType = badgeType or gBadgeExchangeType.COMMON_BADGE_TYPE
	return self.curExchangeNumMap[tostring(badgeType)] or 0
end
function badgeExchangeCtrl:getCostByType(nType, exchangeNum, badgeType)
	local curExchangeNum = self:getCurExchageNum(badgeType)
	return badgeExchangeRead.getCostByType(nType, exchangeNum, curExchangeNum, badgeType)
end
function badgeExchangeCtrl:isEnoughResource(nType, exchangeNum, badgeType)
	local nCost = self:getCostByType(nType, exchangeNum, badgeType)
	if nCost then
		local ownCount = self:getOwnCount(nType)
		return nCost <= ownCount, nCost
	end
	return false
end
function badgeExchangeCtrl:getOwnCount(rid)
	local ownCount = 0
	if rid == gIDDef.GOLD then
		local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
		ownCount = lordInfoCtrl:getBaseInfo().gold or 0
	elseif serviceFunctions.isResourceID(rid) then
		local cityCtrl = SoraDGetCtrl("cityCtrl")
		ownCount = cityCtrl:getResCount(rid) or 0
	else
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		ownCount = backpackCtrl:getItemCount(rid) or 0
	end
	return ownCount
end
function badgeExchangeCtrl:getMaxExchangeNum(nType, badgeType)
	local leftCanBuyNum = self:getLeftCanBuyNum(badgeType, nType)
	local ownCount = self:getOwnCount(nType)
	local num = 0
	while true do
		num = num + 1
		if ownCount < self:getCostByType(nType, num, badgeType) then
			return num - 1
		end
		if leftCanBuyNum <= num then
			return leftCanBuyNum
		end
	end
end
function badgeExchangeCtrl:getCostGoldByCount(count, itemID)
	local badgeType = gBadgeExchangeType.COMMON_BADGE_TYPE
	if itemID == gBadgeItemID.ADVANCED_BADGE_ID then
		badgeType = gBadgeExchangeType.ADVANCED_BADGE_TYPE
	end
	return self:getCostByType(gIDDef.GOLD, count, badgeType)
end
function badgeExchangeCtrl:getLeftCanBuyNum(badgeType, nType)
	local leftCanBuyNum = self:getMostLimit(badgeType, nType) - self:getCurExchageNum(badgeType)
	if leftCanBuyNum <= 0 then
		leftCanBuyNum = 0
	end
	return leftCanBuyNum
end
function badgeExchangeCtrl:getCostCfg(badgeTypeList)
