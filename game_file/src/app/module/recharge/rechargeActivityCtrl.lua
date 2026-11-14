local gamemodulec = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local timerList = gModuleMgr.getObject("timerList")
local rechargeActivityCtrl = class("rechargeActivityCtrl", gamemodulec)
local RECHARGE_ACTIVITY_EVENT_NAME = "RECHARGE_ACTIVITY_EVENT_NAME"
function rechargeActivityCtrl:ctor(properties)
	rechargeActivityCtrl.super.ctor(self, properties)
	self:resetData()
end
function rechargeActivityCtrl:EnterGame()
	self:addEventListener(RECHARGE_ACTIVITY_EVENT_NAME, handler(self, self.activityTimeOver))
	msgCtrl.register(gCmd.CMD_RECHARGE_MODULE, gCmd.REQ_RECHARGE_ACTIVITY_INFO, handler(self, self.getRechargeActivityInfoRsp))
	msgCtrl.register(gCmd.CMD_RECHARGE_MODULE, gCmd.REQ_RECHARGE_ACTIVITY_CHECK, handler(self, self.rechargeActivityCheckRsp))
	msgCtrl.register(gCmd.CMD_RECHARGE_MODULE, gCmd.REQ_RECHARGE_GET_MONTH_AWARD, handler(self, self.getMonthAwardRsp))
	msgCtrl.register(gCmd.CMD_RECHARGE_MODULE, gCmd.REQ_RECHARGE_ACTIVITY_REWARD_IN_REDIS, handler(self, self.getRechargeExtraAwardRsp))
	msgCtrl.register(gCmd.CMD_RECAHRGE_SERVER_MODULE, gCmd.REQ_RECHARGE_ACTIVITY_VERIFY, handler(self, self.rechargeVerifyRsp))
end
function rechargeActivityCtrl:Logout()
	rechargeActivityCtrl.super.Logout(self)
	self:resetData()
end
function rechargeActivityCtrl:resetData()
	self.queue, _UPVALUE0_, self.hadFreeSubed, _UPVALUE0_, self.first, _UPVALUE0_, self.subscription, _UPVALUE0_, self.monthAward, _UPVALUE0_, self.rechargeActivityList, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	self.rechargebuff, _UPVALUE0_, self.rechargeExtraAward, _UPVALUE0_, self.activityRechargeLog, _UPVALUE0_, self.handle_notify = nil, nil, nil, nil, nil, nil, nil
end
function rechargeActivityCtrl:addTransData(orderID, data)
	if not self.transData then
		self.transData, _UPVALUE0_ = self.transData, self.transData
	end
	if orderID then
		self.transData[orderID] = data
	else
		self.nowTransaction = data
	end
end
function rechargeActivityCtrl:getTransData(orderID)
	if self.transData and orderID then
		return self.transData[orderID]
	end
	return self.nowTransaction
end
function rechargeActivityCtrl:activityTimeOver(event)
	local data = event.data
	if data then
		local activityID = data.activityID
		print("rechargeActivityCtrl:activityTimeOver", activityID)
		self:getRechargeActivityInfoReq()
		_ENV = self
		_ENV, self.msg = activityID, "MESSAGE_SERVER_RECHARGECENTER_ACTIVETIMEOUT"
		activityID.refresh = true
		self.redata, activityID.rid = activityID, activityID
		SoraDSendMessage(self)
	end
end
function rechargeActivityCtrl:getRechargeLeftTime(activityID)
	local lefttime = 0
	local queue = self:queryQueue(activityID)
	if queue then
		lefttime = queue.timerNode.timer:getRemainTime()
	end
	return lefttime
end
function rechargeActivityCtrl:addQueue(activityID, starttime, totaltime, lefttime)
	local curqueue = self:queryQueue(activityID)
	if curqueue then
		self:removeQueue(activityID)
	end
	local dispatchQueueEvent = function()
		RECHARGE_ACTIVITY_EVENT_NAME = nil
		RECHARGE_ACTIVITY_EVENT_NAME, (nil).name = RECHARGE_ACTIVITY_EVENT_NAME, RECHARGE_ACTIVITY_EVENT_NAME
		;(nil).data, RECHARGE_ACTIVITY_EVENT_NAME.activityID = RECHARGE_ACTIVITY_EVENT_NAME, activityID
		local event
		self.queue[tostring(activityID)] = nil
		self.rechargeActivityList[tostring(activityID)] = nil
		self:dispatchEvent(event)
	end
	local RECHARGE_ACTIVITY_EVENT_NAME, queue = self, self
	queue.starttime = starttime
	queue.totaltime = totaltime
	local ok, node = timerList:createTimer(lefttime, timerHandler(dispatchQueueEvent))
	if ok then
		queue.timerNode = node
		self.queue[tostring(activityID)] = queue
	end
end
function rechargeActivityCtrl:queryQueue(activityID)
	local ret = self.queue[tostring(activityID)]
	if ret then
		return ret
	end
end
function rechargeActivityCtrl:removeQueue(activityID)
	local queue = self:queryQueue(activityID)
	if queue then
		timerList:cancelTimer(queue.timerNode)
		self.queue[tostring(activityID)] = nil
	end
end
function rechargeActivityCtrl:getRecommendActivityList(recommendType)
	local _ENV, ret
	for activityid, v in pairs(self.rechargeActivityList) do
		local menuid = v.menuid
		if menuid and type(menuid) == "string" then
			local menutb = serviceFunctions.formatStr2Table(menuid)
			for _, id in pairs(menutb) do
				local id = tonumber(id)
				if recommendType == id then
					ret[tostring(activityid)] = v
				end
			end
		end
	end
	return ret
end
function rechargeActivityCtrl:refreshRechargeActivityList(data)
	local curtime = serviceFunctions.systemTime()
	self.rechargeActivityList = data.rechrgeactivitylist
	for k, v in pairs(self.rechargeActivityList) do
		local activityID = v.ID
		local starttime = v.starttime
		local endtime = v.endtime
		local totaltime = endtime - starttime
		local lefttime = endtime - curtime
		if 0 < lefttime then
			self:addQueue(activityID, starttime, totaltime, lefttime)
			if activityID and activityID >= gExtraGiftIDDef.LADDER_GIFT_BEGIN and activityID <= gExtraGiftIDDef.NORMAL_GIFT_END then
				gModuleMgr.sharedMgr("rechargeExtraltCtrl"):addExtraData(clone(v))
				if activityID >= gExtraGiftIDDef.LADDER_GIFT_BEGIN and activityID <= gExtraGiftIDDef.LADDER_GIFT_END then
					local nextLadderList = v.nextLadderList
					if type(nextLadderList) == "table" and next(nextLadderList) then
						for k1, v1 in pairs(nextLadderList) do
							gModuleMgr.sharedMgr("rechargeExtraltCtrl"):addExtraData(clone(v1))
						end
					end
				end
			end
		else
			self.rechargeActivityList[k] = nil
		end
	end
	self.monthAward = data.monthAward
	for k, v in pairs(self.monthAward) do
		local activityID = v.ID
		local starttime = v.starttime
		local totalday = v.totalday
		if activityID and starttime and totalday then
			local totaltime = totalday * 24 * 3600
			local lasttime = curtime - starttime
			local lefttime = totaltime - lasttime
			self:addQueue(activityID, starttime, totaltime, lefttime)
		end
	end
	self.subscription = data.subscription
	if self.subscription then
		for k, v in pairs(self.subscription) do
			local activityID = v.ID
			local starttime = v.starttime
			local endtime = v.endtime
			local totaltime = endtime - starttime
			local lefttime = endtime - curtime
			if 0 < lefttime then
				self:addQueue(activityID, starttime, totaltime, lefttime)
			else
				self.subscription[k] = nil
			end
		end
	end
	if data.hadFreeSubed then
		self.hadFreeSubed = data.hadFreeSubed
	end
	if data.first then
		self.first = data.first
	end
	self.recharge_ability = data.recharge_ability or 0.99
	print("recharge_ability is ", self.recharge_ability)
	if data.recharge_ability then
		self.recharge_ability = data.recharge_ability
	end
	if data.activity then
		self.activityRechargeLog = data.activity
	end
end
function rechargeActivityCtrl:getLogByID(ID)
	if not self.activityRechargeLog[tostring(ID)] then
		_ENV = self.activityRechargeLog[tostring(ID)]
	end
	return self.activityRechargeLog[tostring(ID)]
end
function rechargeActivityCtrl:getAnniversaryPackageList()
	local _ENV, ret
	for activityID, v in pairs(self.rechargeActivityList) do
		if v.activityType and v.activityType == gRechargeActivityType.ANNIVERSARY then
			table.insert(ret, clone(v))
		end
	end
	table.sort(ret, function(a, b)
		return a.ID < b.ID
	end)
	return ret
end
function rechargeActivityCtrl:getTakeActivityList()
	local _ENV, ret
	for activityID, v in pairs(self.monthAward) do
		if v.activityType and v.activityType == gRechargeActivityType.SUBSCRIPTION then
			ret = clone(v)
			ret.isbuy = true
		end
	end
	if not userSDKManager.isKO() then
		for activityID, v in pairs(self.rechargeActivityList) do
			if v.activityType == gRechargeActivityType.SUBSCRIPTION then
				ret = clone(v)
				ret.isbuy = false
			end
		end
	end
	return ret
end
function rechargeActivityCtrl:isTakeFree(rid)
	local key = paymentManager.rid2Pid(rid)
	return self.hadFreeSubed[key] ~= true
end
function rechargeActivityCtrl:getMonthActivityList()
	local _ENV, ret
	for activityID, v in pairs(self.monthAward) do
		if v.activityType and v.activityType == gRechargeActivityType.MONTH_GIFT then
			ret[tostring(activityID)] = clone(v)
			ret[tostring(activityID)].isbuy = true
		end
	end
	for activityID, v in pairs(self.rechargeActivityList) do
		if v.activityType == gRechargeActivityType.MONTH_GIFT then
			ret[tostring(activityID)] = clone(v)
			ret[tostring(activityID)].isbuy = false
		end
	end
	return ret
end
function rechargeActivityCtrl:getWeekActivityList()
	local _ENV, ret
	for activityID, v in pairs(self.monthAward) do
		if v.activityType and v.activityType == gRechargeActivityType.WEEK_GIFT then
			ret[tostring(activityID)] = clone(v)
			ret[tostring(activityID)].isbuy = true
			if not self:checkCastleLvCond(v.castlelv) and v.canRenew then
				ret[tostring(activityID)].canRenew = false
			end
		end
		if not v.activityType then
			ret[tostring(activityID)] = clone(v)
			ret[tostring(activityID)].isbuy = true
		end
	end
	for activityID, v in pairs(self.rechargeActivityList) do
		if v.activityType == gRechargeActivityType.WEEK_GIFT and self:checkCastleLvCond(v.castlelv) then
			ret[tostring(activityID)] = clone(v)
			ret[tostring(activityID)].isbuy = false
		end
	end
	return ret
end
function rechargeActivityCtrl:checkCastleLvCond(lvCond)
	if lvCond and next(lvCond) then
		local kingdomSettingAPI = include("kingdomSettingAPI")
		local curLv = kingdomSettingAPI:getCastleLevel()
		local lvMin, lvMax = lvCond[1], lvCond[2]
		if lvMin and lvMin ~= 0 and curLv < lvMin then
			return false
		end
		if lvMax and lvMax ~= 0 and curLv > lvMax then
			return false
		end
	end
	return true
end
function rechargeActivityCtrl:getHotActivityList()
	local _ENV, ret
	local rechargeRead = include("rechargeRead")
	for activityID, v in pairs(self.rechargeActivityList) do
		if (v.activityType == gRechargeActivityType.NORMAL or v.activityType == gRechargeActivityType.ALLIANCE or v.activityType == gRechargeActivityType.THIRD_RECHARGE) and v.payType ~= gRechargeActivityBuyType.LADDER then
			ret[tostring(activityID)] = clone(v)
		elseif rechargeRead.isActivityTypeShow(tonumber(activityID)) then
			ret[tostring(activityID)] = clone(v)
		elseif clientEventMgr.judgeIsOpen(gActivityTimeActivityID.LUCKY_FALCON) and tonumber(activityID) >= 14234 and tonumber(activityID) <= 14237 and tonumber(v.extraData) > 0 then
			ret[tostring(activityID)] = clone(v)
		end
	end
	return ret
end
function rechargeActivityCtrl:getLadderActivityList()
	local _ENV, ret
	for activityID, v in pairs(self.rechargeActivityList) do
		if v.payType == gRechargeActivityBuyType.LADDER and v.nextLadderList then
			table.insert(ret, clone(v))
		end
	end
	local ladderGiftCtrl = gametop.playertop_:getModule("ladderGiftCtrl")
	local ruiruiLadder = ladderGiftCtrl:trasnMyLadderData()
	for _, v in pairs(ruiruiLadder) do
		if v.nextLadderList then
			table.insert(ret, v)
		end
	end
	return ret
end
function rechargeActivityCtrl:getNormalAndAllianceRechargeActivityList()
	local _ENV, ret
	local rechargeRead = include("rechargeRead")
	for activityID, v in pairs(self.rechargeActivityList) do
		if not rechargeRead.getSpecialRechargeCfg(tonumber(activityID)) then
			if rechargeRead.isActivityTypeShow(tonumber(activityID)) then
				ret[tostring(activityID)] = clone(v)
			end
			if v.activityType == gRechargeActivityType.NORMAL or v.activityType == gRechargeActivityType.ALLIANCE then
				ret[tostring(activityID)] = clone(v)
			end
		end
	end
	return ret
end
function rechargeActivityCtrl:getRechargeActivityListByType(activityType)
	local _ENV, ret
	for activityID, v in pairs(self.rechargeActivityList) do
		if v.activityType == activityType then
			table.insert(ret, clone(v))
		end
	end
	return ret
end
function rechargeActivityCtrl:filterBuyRankData(tbl)
	local _ENV, ret
	local rechargeRead = include("rechargeRead")
	for activityID, v in pairs(tbl) do
		if not rechargeRead.getSpecialRechargeCfg(tonumber(activityID)) then
			if v.hot and v.hot > 0 then
				ret[tostring(activityID)] = clone(v)
			elseif v.hot and v.hot <= 0 and rechargeRead.getRankHideListByID(v.label) then
				ret[tostring(activityID)] = clone(v)
			elseif not v.hot then
				ret[tostring(activityID)] = clone(v)
			end
		end
	end
	return ret
end
function rechargeActivityCtrl:getMonthAwardList(activityID)
	local _ENV, ret
	local monthInfo = self.monthAward[tostring(activityID)]
	if monthInfo then
		local _ENV, tmpList = tostring(activityID), tostring(activityID)
		if not monthInfo.award then
			local _ENV, disList = monthInfo.award, monthInfo.award
		end
		if next(disList) then
			for k, v in pairs(disList) do
				if v.count ~= 0 then
					table.insert(tmpList, v)
				end
			end
		end
		ret = tmpList
	else
		local info = self.rechargeActivityList[tostring(activityID)]
		if info then
			if info.activityType ~= gRechargeActivityType.WEEK_GIFT then
				local goldcount = info.gold or 0
				if 0 < goldcount then
					_ENV = pairs(disList)
					pairs(disList).id = 1001
					pairs(disList).count = goldcount
					table.insert(ret, pairs(disList))
				end
			end
			if not info.gift then
				_ENV = info.gift
			end
			local tmpList = SoraDStringSplit(info.gift, ",")
			for i = 1, #tmpList / 2 do
				local id = tmpList[2 * i - 1]
				local count = tmpList[2 * i]
				_ENV = nil
				;(nil).id = id
				;(nil).count = count
				table.insert(ret, nil)
			end
		end
	end
	return ret
end
function rechargeActivityCtrl:getRechargeActivityData(id)
	return self.rechargeActivityList[tostring(id)]
end
function rechargeActivityCtrl:getIsAccountFirstRecharge()
	print("rechargeActivityCtrl:getIsAccountFirstRecharge", self.first.account)
	return self.first.account
end
function rechargeActivityCtrl:getIsDayFirstRecharge()
	print("rechargeActivityCtrl:getIsDayFirstRecharge", self.first.day.result)
	return self.first.day.result
end
function rechargeActivityCtrl:getIsPresentGift()
	print("rechargeActivityCtrl:getIsPresentGift", self.first.present.result)
	return self.first.present.result
end
function rechargeActivityCtrl:getMonthGiftStatus()
	local ret = self:getMonthActivityList()
	for k, v in pairs(ret) do
		if v.activityType == gRechargeActivityType.MONTH_GIFT then
			return v.canRenew
		end
	end
	return false
end
function rechargeActivityCtrl:getNewWeekcardData(...)
	if not self:getWeekActivityList() then
		local _UPVALUE0_, weeklyData = self:getWeekActivityList(), self:getWeekActivityList()
	end
	local weekcardData = weeklyData["12904"]
	return weekcardData
end
function rechargeActivityCtrl:checkCanbuyNewWeekcard(...)
	local weekcardData = self:getNewWeekcardData()
	if weekcardData and not weekcardData.isbuy then
		return true
	end
end
function rechargeActivityCtrl:checkHasbuyNewWeekcard(...)
	local weekcardData = self:getNewWeekcardData()
	if weekcardData and weekcardData.isbuy then
		return true
	end
end
function rechargeActivityCtrl:getRechargeGift(rid)
	local rechargeGiftRead = gModuleMgr.sharedMgr("rechargeGiftRead")
	if self.rechargeExtraAward[tostring(rid)] then
		return self.rechargeExtraAward[tostring(rid)]
	else
		local rewardList = rechargeGiftRead:getProperty(rid, "vatGift")
		_UPVALUE2_ = "vatGift"
		;("vatGift")[1] = "id"
		;("vatGift")[2] = "count"
		return serviceFunctions.tableFormat(rewardList, "vatGift")
	end
end
function rechargeActivityCtrl:getRechargeBuff()
	return self.rechargebuff
end
function rechargeActivityCtrl:isActiviteBuff(buffID)
	local ret = false
	if self.rechargebuff and next(self.rechargebuff) then
		local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
		local _ENV, buffList = "buffltCtrl", "buffltCtrl"
		for buffID, endTime in pairs(self.rechargebuff) do
			local leftTime = endTime - serviceFunctions.systemTime()
			if 0 < leftTime then
				local buffValue, buffMode = buffltCtrl:getEffect(tonumber(buffID))
				local buffType = buffltCtrl:getEffectType(tonumber(buffID))
				_ENV = tonumber(buffID)
				tonumber(buffID).buffID = tonumber(buffID)
				tonumber(buffID).endTime = endTime
				tonumber(buffID).buffType = buffType
				tonumber(buffID).buffValue = buffValue
				table.insert(buffList, tonumber(buffID))
			end
		end
		table.sort(buffList, function(a, b)
			if a.buffType == b.buffType then
				return a.buffValue > b.buffValue
			else
				return a.buffType < b.buffType
			end
		end)
		local _ENV, showList = table.sort, table.sort
		local _ENV, mapList = buffList, buffList
		for k, v in ipairs(buffList) do
			if not mapList[v.buffType] then
				table.insert(showList, v)
				mapList[v.buffType] = 1
			end
		end
		for k, v in ipairs(showList) do
			if v.buffID == tonumber(buffID) then
				ret = true
				break
			end
		end
	end
	return ret
end
function rechargeActivityCtrl:isRechargeBuffActive(buffID)
	local ret = false
	local rechargeRead = include("rechargeRead")
	local endTime = self.rechargebuff[tostring(buffID)]
	if endTime and endTime > serviceFunctions.systemTime() then
		local buffCfg = rechargeRead.getBuffCfg(tonumber(buffID))
		if buffCfg then
			if buffCfg.castleLv[1] == 1 then
				ret = SoraDGetCastleLv() >= buffCfg.castleLv[2] and SoraDGetCastleLv() <= buffCfg.castleLv[3]
			elseif buffCfg.castleLv[1] == 2 then
				ret = SoraDGetBuildStarLv() >= buffCfg.castleLv[2] and SoraDGetBuildStarLv() <= buffCfg.castleLv[3]
			elseif buffCfg.castleLv[1] == 3 then
				local quality, lv, starLv = SoraDGetBuildQuality()
				ret = lv >= buffCfg.castleLv[2] and lv <= buffCfg.castleLv[3]
			elseif buffCfg.castleLv[1] == 4 then
				local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
				local jinn1Lv = magicLampCtrl:getJinnLv(gJinnType.JINN_ONE)
				ret = jinn1Lv >= buffCfg.castleLv[2] and jinn1Lv <= buffCfg.castleLv[3]
			elseif buffCfg.castleLv[1] == 5 then
				local magicLampHatchCtrl = SoraDGetCtrl("magicLampHatchCtrl")
				local hatchLv = magicLampHatchCtrl:getHatchLv()
				ret = hatchLv >= buffCfg.castleLv[2] and hatchLv <= buffCfg.castleLv[3]
			elseif buffCfg.castleLv[1] == 6 then
				local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
				local jinn2Lv = magicLampCtrl:getJinnLv(gJinnType.JINN_TWO)
				ret = jinn2Lv >= buffCfg.castleLv[2] and jinn2Lv <= buffCfg.castleLv[3]
			end
		end
	end
	return ret
end
function rechargeActivityCtrl:getRechargeBuffValue(effect)
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	local buffList = buffltCtrl:getBuffID(effect)
	local subPercent = 0
	for k, v in ipairs(buffList) do
		local ret = self:isRechargeBuffActive(v)
		if ret and self:isActiviteBuff(v) then
			local buffValue, buffType = buffltCtrl:getEffect(v)
			subPercent = subPercent + buffValue
		end
	end
	return subPercent
end
function rechargeActivityCtrl:getRechargeActivityInfoReq(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_RECHARGE_MODULE, gCmd.REQ_RECHARGE_ACTIVITY_INFO, nil, ...)
end
function rechargeActivityCtrl:getRechargeActivityInfoRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local data = content.data.retdata
		self:refreshRechargeActivityList(data)
		_ENV = self
		self.msg = "MESSAGE_SERVER_RECHARGECENTER_TAKE_REFRESH"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_RECHARGECENTER_WEEKLY_REFRESH"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_RECHARGECENTER_MONTHLY_REFRESH"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_RECHARGECENTER_RUIRUILADDER_REFRESH"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_MONTHLY_CARD_REFRESH_BACK"
		SoraDSendMessage(self)
	else
		print("getRechargeActivityInfoRsp err", err)
	end
end
function rechargeActivityCtrl:rechargeCheckReq(activityID, ...)
	local platform = gRechargePlatform.IOS
	if device.platform == "android" then
		platform = gRechargePlatform.ANDROID
	end
	_ENV = nil
	;(nil).activityID = activityID
	;(nil).platform = platform
	serverproxy:Request(gCmd.CMD_RECHARGE_MODULE, gCmd.REQ_RECHARGE_ACTIVITY_CHECK, nil, ...)
end
function rechargeActivityCtrl:rechargeActivityCheckRsp(content)
	dump(content, "rechargeActivityCheckRsp")
	local err = content.err
	if err == gErrDef.Err_None then
		local activityID = content.data.activityID
		local orderID = content.data.orderID
		paymentManager.purchase(activityID, orderID)
	else
		print("rechargeActivityCheckRsp err", err)
		if content.data.retdata then
			self:refreshRechargeActivityList(content.data.retdata)
		end
		_ENV = self
		self.msg = "MESSAGE_CLIENT_RECHARGECENTER_POPVIEWCLOSE"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIEWREFRESH"
		SoraDSendMessage(self)
		SoraDCloseLoading()
		paymentManager.isInRecharging = false
	end
end
function rechargeActivityCtrl:getMonthAwardReq(activityID, ...)
	serverproxy = nil
	;(nil).activityID = activityID
	serverproxy:Request(gCmd.CMD_RECHARGE_MODULE, gCmd.REQ_RECHARGE_GET_MONTH_AWARD, nil, ...)
end
function rechargeActivityCtrl:getMonthAwardRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local activityID = content.data.activityID
		self.monthAward[tostring(activityID)] = content.data.retdata
		if content.data.rechrgeactivitylist and content.data.monthAward then
			self:refreshRechargeActivityList(content.data)
		end
		if not content.data.award then
			local _ENV, award = content.data.award, content.data.award
		end
		local _ENV, iList = self, self
		for k, v in pairs(award) do
			if v.count > 0 then
				iList[v.id] = v.count
			end
		end
		SoraDMailGainItems(iList)
		_ENV = iList
		iList.msg = "MESSAGE_SERVER_RECHARGECENTER_WEEKLY_REFRESH"
		SoraDSendMessage(iList)
		_ENV = iList
		iList.msg = "MESSAGE_SERVER_RECHARGECENTER_MONTHLY_REFRESH"
		SoraDSendMessage(iList)
		_ENV = iList
		iList.msg = "MESSAGE_SERVER_RECHARGECENTER_TAKE_REFRESH"
		SoraDSendMessage(iList)
		_ENV = iList
		iList.msg = "MESSAGE_MAINCITYVIEW_UPDATE_BOAT_TIP"
		SoraDSendMessage(iList)
	else
		print("getMonthAwardRsp err", err)
		_ENV = "getMonthAwardRsp err"
		;("getMonthAwardRsp err").msg = "MESSAGE_SERVER_RECHARGECENTER_WEEKLY_REFRESH"
		SoraDSendMessage("getMonthAwardRsp err")
		_ENV = "getMonthAwardRsp err"
		;("getMonthAwardRsp err").msg = "MESSAGE_SERVER_RECHARGECENTER_MONTHLY_REFRESH"
		SoraDSendMessage("getMonthAwardRsp err")
		_ENV = "getMonthAwardRsp err"
		;("getMonthAwardRsp err").msg = "MESSAGE_SERVER_RECHARGECENTER_TAKE_REFRESH"
		SoraDSendMessage("getMonthAwardRsp err")
	end
end
function rechargeActivityCtrl:rechargeIOSVerify(rid, receipt, currency, transaction, orderID, pushID, ...)
	print("rechargeActivityCtrl:rechargeIOSVerify rid = ", rid)
	self:addTransData(orderID, transaction)
	local rChannel = gRechargeChannel.APPLE
	if userSDKManager.getChannel() == "ko_ios" then
		rChannel = gRechargeChannel.KO_IOS
	end
	local realPrice, isGetPrice, log = paymentManager.getRealPriceLog(rid, 0, receipt)
	local crypt = require("crypt")
	_ENV, receipt = crypt.base64encode(receipt), crypt.base64encode(receipt)
	crypt.base64encode(receipt).rid = rid
	crypt.base64encode(receipt).rChannel = rChannel
	crypt.base64encode(receipt).receipt = receipt
	crypt.base64encode(receipt).currency = currency
	crypt.base64encode(receipt).orderID = orderID
	crypt.base64encode(receipt).clientVersion = GAME_VERSION
	crypt.base64encode(receipt).pushid = pushID
	crypt.base64encode(receipt).realPrice = realPrice
	local crypt.base64encode(receipt).log, data = log, crypt.base64encode(receipt)
	serverproxy:Request(gCmd.CMD_RECAHRGE_SERVER_MODULE, gCmd.REQ_RECHARGE_ACTIVITY_VERIFY, data, ...)
end
function rechargeActivityCtrl:rechargeGooglePlayVerify(rid, originalJson, signature, currency, androidRedata, orderID, pushID, ...)
	print("rechargeActivityCtrl:rechargeGooglePlayVerify rid = ", rid)
	self.androidRedata = androidRedata
	local rChannel = paymentManager.getStoreChannel()
	local realPrice, isGetPrice, log = paymentManager.getRealPriceLog(rid, 0, originalJson)
	_ENV = originalJson
	originalJson.rid = rid
	originalJson.rChannel = rChannel
	originalJson.originalJson = originalJson
	originalJson.signature = signature
	originalJson.currency = currency
	originalJson.orderID = orderID
	originalJson.clientVersion = GAME_VERSION
	originalJson.pushid = pushID
	originalJson.realPrice = realPrice
	local originalJson.log, data = log, originalJson
	serverproxy:Request(gCmd.CMD_RECAHRGE_SERVER_MODULE, gCmd.REQ_RECHARGE_ACTIVITY_VERIFY, data, ...)
end
function rechargeActivityCtrl:rechargeVerifyRsp(content)
	dump(content, "rechargeActivityCtrl:rechargeVerifyRsp")
	local orderID = content.data.orderID
	local rid = content.data.rid
	if content.data.rChannel == gRechargeChannel.GOOGLE_PLAY or content.data.rChannel == gRechargeChannel.KO_ANDROID or content.data.rChannel == gRechargeChannel.KO_ONESTORE then
		if self.androidRedata then
			paymentManager.finishTransaction(self.androidRedata, rid, orderID)
			paymentManager.OnemtPost2ServerSuccess(rid, self.androidRedata)
		end
	elseif content.data.rChannel == gRechargeChannel.APPLE or content.data.rChannel == gRechargeChannel.KO_IOS then
		local nowTransaction = self:getTransData(orderID)
		if nowTransaction then
			paymentManager.finishTransaction(nowTransaction, rid, orderID)
			paymentManager.OnemtPost2ServerSuccess(rid, nowTransaction)
		end
	elseif content.data.rChannel == gRechargeChannel.BAZAAR then
		if self.androidRedata then
			paymentManager.finishTransaction(self.androidRedata, rid, orderID)
		end
	elseif content.data.rChannel == gRechargeChannel.AMAZON then
		if self.androidRedata then
			paymentManager.finishTransaction(self.androidRedata, rid, orderID)
			paymentManager.OnemtPost2ServerSuccess(rid, self.androidRedata)
		end
	elseif content.data.rChannel == gRechargeChannel.HUAWEI and self.androidRedata then
		paymentManager.finishTransaction(self.androidRedata, rid, orderID)
		paymentManager.OnemtPost2ServerSuccess(rid, self.androidRedata)
	end
	paymentManager.loopForFinishTransaction()
end
function rechargeActivityCtrl:getRechargeExtraAwardReq(data)
	serverproxy:Request(gCmd.CMD_RECHARGE_MODULE, gCmd.REQ_RECHARGE_ACTIVITY_REWARD_IN_REDIS, data)
end
function rechargeActivityCtrl:getRechargeExtraAwardRsp(content)
	if content.err == gErrDef.Err_None then
		local backList = content.rspData.rewardInfo
		if table.nums(backList) == 1 then
			_ENV = backList
			backList.msg = "MESSAGE_RECHARGE_EXTRA_GIFT_REFRESH"
			backList.rewardInfo = backList
			SoraDSendMessage(backList)
		else
			self.rechargeExtraAward = backList
		end
	end
end
function rechargeActivityCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.RECHARGE_ACTIVITY, handler(self, self.notifyRechargeActivity))
	notifyCtrl:register(gNotifyID.RECHARGE_ACTIVIT_GIFT, handler(self, self.notifyUpdate))
end
function rechargeActivityCtrl:notifyRechargeActivity(event)
	for k, v in pairs(event.data) do
		local activityID = v.activityID
		local price = v.price
		local result = v.result
		local retdata = v.retdata
		if not v.sendgood then
			local _ENV, sendgood = v.sendgood, v.sendgood
		end
		local mailid = v.mailid or 0
		local isfirst = v.isfirst or false
		local nowGetGold = v.nowGetGold
		if not v.rechargebuff then
			_ENV = v.rechargebuff
		end
		self.rechargebuff = v.rechargebuff
		self:refreshRechargeActivityList(retdata)
		if result then
			paymentManager.OnemtRechargeSuccess(price)
		end
		print("rechargeActivityCtrlnotifyRechargeActivity", activityID)
		_ENV = "rechargeActivityCtrlnotifyRechargeActivity"
		_ENV, ("rechargeActivityCtrlnotifyRechargeActivity").msg = activityID, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
		activityID.result = result
		activityID.rid = activityID
		activityID.itemList = sendgood
		;("rechargeActivityCtrlnotifyRechargeActivity").data, activityID.mailID = activityID, mailid
		SoraDSendMessage("rechargeActivityCtrlnotifyRechargeActivity")
		_ENV = "rechargeActivityCtrlnotifyRechargeActivity"
		;("rechargeActivityCtrlnotifyRechargeActivity").msg = "MESSAGE_MONTHLY_CARD_REFRESH_BACK"
		SoraDSendMessage("rechargeActivityCtrlnotifyRechargeActivity")
		if nowGetGold and 0 < nowGetGold then
			SoraDPopGainItem(gIDDef.GOLD, nowGetGold)
		end
		if isfirst then
			SoraDShowMsgTip(i18n("common_text_2770"))
		end
	end
end
function rechargeActivityCtrl:sendMoneyData()
	local moneyData = serviceFunctions.table_copy_table(paymentManager.products)
	local deviceType = device.platform
	_ENV = nil
	;(nil).moneyData = moneyData
	;(nil).shopType = deviceType
	serverproxy:Request(gCmd.CMD_RECHARGE_MODULE, gCmd.REQ_RECHARGE_SEND_MONEY_DATA, nil)
end
function rechargeActivityCtrl:notifyUpdate(event)
	for k, v in pairs(event.data) do
		if v.first then
			self.first = v.first
			if v.isday then
				SoraDShowMsgTip(i18n("common_text_3769"))
			end
			_ENV = i18n("common_text_3769")
			i18n("common_text_3769").msg = "MESSAGE_CLIENT_RECHARGECENTER_DAYFIRST"
			SoraDSendMessage(i18n("common_text_3769"))
		end
		if v.initdata then
			self:refreshRechargeActivityList(v.initdata)
		end
		if v.newDay then
			self:getRechargeActivityInfoReq()
		end
		if v.recharge_ability then
			self.recharge_ability = v.recharge_ability
		end
		if v.sendMoneyData then
			self:sendMoneyData()
		end
		if v.rechargebuff then
			self.rechargebuff = v.rechargebuff
		end
	end
	_ENV = pairs(event.data)
	pairs(event.data).msg = "MESSAGE_CLIENT_RECHARGECENTER_GIFTCART"
	SoraDSendMessage(pairs(event.data))
end
function rechargeActivityCtrl:sendSelfMonetyType(moneyType)
	print("rechargeActivityCtrl:sendSelfMonetyType(moneyType)", moneyType)
	local moneyType = moneyType or ""
	_ENV = nil
	;(nil).moneyType = moneyType
	serverproxy:Request(gCmd.CMD_RECHARGE_MODULE, gCmd.REQ_RECHARGE_SET_MONEY_TYPE, nil)
end
function rechargeActivityCtrl:getRechargeAbility()
	return self.recharge_ability
end
function rechargeActivityCtrl:initClientData(data)
	dump(data, "rechargeActivityCtrl", 10)
	self:refreshRechargeActivityList(data)
	self:registerNotify()
	self:getRechargeActivityInfoReq()
	self:getRechargeExtraAwardReq()
	if not data.rechargebuff then
		_ENV = data.rechargebuff
	end
	self.rechargebuff = data.rechargebuff
end
function rechargeActivityCtrl:getMonthlyCard()
	local monthData = self:getMonthActivityList()
	local weeklyData = self:getWeekActivityList()
	local takeData = self:getTakeActivityList()
	local hasGift = false
	local hasBuy = false
	local hasGot = false
	if next(monthData) or next(weeklyData) or next(takeData) then
		hasGift = true
	end
	if takeData and next(takeData) then
		if takeData.isbuy then
			hasBuy = true
		end
		if takeData.isbuy and takeData.isdayget then
			hasGot = true
		end
	end
	if weeklyData and next(weeklyData) then
		for k, v in pairs(weeklyData) do
			if v.isbuy then
				hasBuy = true
			end
			if v.isbuy and v.isdayget then
				hasGot = true
			end
		end
	end
	if monthData and next(monthData) then
		for k, v in pairs(monthData) do
			if v.isbuy then
				hasBuy = true
			end
			if v.isbuy and v.isdayget then
				hasGot = true
			end
		end
	end
	return hasGift, hasBuy, hasGot
end
return rechargeActivityCtrl
