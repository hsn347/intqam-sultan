local GameModule = include("GameModule")
local salesRoomAgCtrl = class("salesRoomAgCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function salesRoomAgCtrl:ctor(properties)
	salesRoomAgCtrl.super.ctor(self, properties)
end
function salesRoomAgCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_SALES_ROOM_MODULE, gCmd.REQ_SALES_ROOM_INIT, handler(self, self.salesRoomInitResp))
	msgCtrl.register(gCmd.CMD_SALES_ROOM_MODULE, gCmd.REQ_SALES_ROOM_ADD_PLUS, handler(self, self.salesRoomAddPlusResp))
	msgCtrl.register(gCmd.CMD_SALES_ROOM_MODULE, gCmd.REQ_SALES_ROOM_CLEAR_LOG, handler(self, self.getClearLogResp))
	msgCtrl.register(gCmd.CMD_SALES_ROOM_MODULE, gCmd.REQ_SALES_ROOM_GET_LOG, handler(self, self.getSalesRoomLogResp))
	msgCtrl.register(gCmd.CMD_SALES_ROOM_MODULE, gCmd.REQ_SALES_ROOM_RECEIVE_GOLD, handler(self, self.getReceiveGoldResp))
	msgCtrl.register(gCmd.CMD_SALES_ROOM_MODULE, gCmd.REQ_SALES_ROOM_GET_GOLD_LOG, handler(self, self.getReceiveGoldLogResp))
	msgCtrl.register(gCmd.CMD_SALES_ROOM_MODULE, gCmd.REQ_SALES_ROOM_RECEIVE_ONE_GOLD, handler(self, self.getReceivOneGoldResp))
	msgCtrl.register(gCmd.CMD_SALES_ROOM_MODULE, gCmd.REQ_NEW_SALES_ROOM_INIT, handler(self, self.newSalesRoomInitResp))
	msgCtrl.register(gCmd.CMD_SALES_ROOM_MODULE, gCmd.REQ_NEW_SALES_ROOM_ADD_PLUS, handler(self, self.newSalesRoomAddPlusResp))
	msgCtrl.register(gCmd.CMD_SALES_ROOM_MODULE, gCmd.REQ_NEW_SALES_ROOM_GET_LOG, handler(self, self.getNewSalesRoomLogResp))
	msgCtrl.register(gCmd.CMD_SALES_ROOM_MODULE, gCmd.REQ_NEW_SALES_ROOM_SUCCESS_LOG, handler(self, self.getSuccessLogResp))
	msgCtrl.register(gCmd.CMD_SALES_ROOM_MODULE, gCmd.REQ_NEW_SALES_ROOM_CLEAR_HINT, handler(self, self.clearHintResp))
	self:resetData()
	self:sendInitMsg()
end
function salesRoomAgCtrl:resetData()
	self.notReceiveGold = nil
	self.timeAndStatus = nil
	self.itemsInfo = nil
	self.salesRoomLog = nil
	self.handle_notify = nil
	self.handle_notify2 = nil
	self.salesRoomGoldLog = nil
	self.salesRoomData = nil
	self.successInfo, _UPVALUE0_, self.boreNum = nil, nil, 0
	self.hint = false
end
function salesRoomAgCtrl:Logout()
	self:resetData()
	salesRoomAgCtrl.super.Logout(self)
end
function salesRoomAgCtrl:initClientData(data)
	if not data then
		return
	end
	self:registerNotify()
	if data.hint ~= nil then
		self.hint = data.hint
	end
end
function salesRoomAgCtrl:dump()
end
function salesRoomAgCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.SALESROOM, handler(self, self.notifyHandler))
	self.handle_notify2 = notifyCtrl:register(gNotifyID.NEW_SALESROOM, handler(self, self.notifyHandler2))
end
function salesRoomAgCtrl:notifyHandler2(event)
	if type(event) == "table" and event.data then
		for _, content in ipairs(event.data) do
			dump(content, "salesRoomAgCtrl:notifyHandler2")
			if content.version == 2 then
				self.salesRoomData = content.salesRoomData
				_ENV = content
				content.msg = "MESSAGE_MARKET_NEW_TRADEBOARDRETURN"
				SoraDSendMessage(content)
			end
			if content.boreNum then
				self.boreNum = content.boreNum
				_ENV = content
				content.msg = "MESSAGE_MARKET_NEW_TRADEBOARDRETURN"
				content.name = "bore"
				SoraDSendMessage(content)
			end
			if content.itemInfo then
				local item = content.itemInfo.item
				local num = content.itemInfo.num
				if item and num then
					_ENV = nil
					_ENV, (nil).msg = nil, "MESSAGE_MARKET_TRADEBOARDRETURN_MSGGETTIP"
					;(nil)._item = item
					;(nil).info, (nil)._num = nil, num
					;(nil).showType = "newTradeBoard"
					SoraDSendMessage(nil)
				end
			end
			if content.hint ~= nil then
				self.hint = content.hint
				self:refreshHint()
			end
		end
		_ENV = ipairs(event.data)
		ipairs(event.data).msg = "MESSAGE_MARKET_NEW_TRADEBOARD_UI"
		SoraDSendMessage(ipairs(event.data))
	end
end
function salesRoomAgCtrl:notifyHandler(event)
	local content = event.data[1]
	if content and (content.itemsInfo or content.notReceiveGold) then
		if content.itemsInfo then
			self.itemsInfo = content.itemsInfo
		end
		if content.notReceiveGold then
			self.notReceiveGold = content.notReceiveGold
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITY_VIEW_UPDATE_MARKET_AUCTION"
			SoraDSendMessage(nil)
		end
		if content.timeAndStatus then
			self.timeAndStatus = content.timeAndStatus
		end
		if content.itemInfo then
			local item = content.itemInfo.item
			local num = content.itemInfo.num
			if item and num then
				_ENV = nil
				_ENV, (nil).msg = nil, "MESSAGE_MARKET_TRADEBOARDRETURN_MSGGETTIP"
				;(nil)._item = item
				;(nil).info, (nil)._num = nil, num
				SoraDSendMessage(nil)
			end
		end
		_ENV = content.itemInfo.num
		content.itemInfo.num.msg = "MESSAGE_MARKET_TRADEBOARDRETURN"
		SoraDSendMessage(content.itemInfo.num)
	end
end
function salesRoomAgCtrl:sendInitMsg()
	serverproxy:Request(gCmd.CMD_SALES_ROOM_MODULE, gCmd.REQ_SALES_ROOM_INIT)
end
function salesRoomAgCtrl:sendAddPlusMsg(shopID, gold)
	local serverproxy, data
	data.shopID = shopID
	data.gold = gold
	serverproxy:Request(gCmd.CMD_SALES_ROOM_MODULE, gCmd.REQ_SALES_ROOM_ADD_PLUS, data)
end
function salesRoomAgCtrl:sendReceiveGold()
	serverproxy:Request(gCmd.CMD_SALES_ROOM_MODULE, gCmd.REQ_SALES_ROOM_RECEIVE_GOLD)
end
function salesRoomAgCtrl:sendLogMsg(startIndex)
	local serverproxy, data
	data.startIndex = startIndex
	serverproxy:Request(gCmd.CMD_SALES_ROOM_MODULE, gCmd.REQ_SALES_ROOM_GET_LOG, data)
end
function salesRoomAgCtrl:sendGoldLogMsg(startIndex)
	local serverproxy, data
	data.startIndex = startIndex
	serverproxy:Request(gCmd.CMD_SALES_ROOM_MODULE, gCmd.REQ_SALES_ROOM_GET_GOLD_LOG, data)
end
function salesRoomAgCtrl:sendReceiveOneGold(info)
	local serverproxy, data
	data.info = info
	serverproxy:Request(gCmd.CMD_SALES_ROOM_MODULE, gCmd.REQ_SALES_ROOM_RECEIVE_ONE_GOLD, data)
end
function salesRoomAgCtrl:salesRoomInitResp(ret)
	if ret and ret.data then
		if ret.err == gErrDef.Err_SALES_ROOM_NO_MARKET then
			_ENV = gErrDef.Err_SALES_ROOM_NO_MARKET
			gErrDef.Err_SALES_ROOM_NO_MARKET.msg = "MESSAGE_MARKET_TRADEBOARDRETURN_CLOSE"
			SoraDSendMessage(gErrDef.Err_SALES_ROOM_NO_MARKET)
		elseif ret.err == gErrDef.Err_None then
			self.itemsInfo = ret.data.itemsInfo
			self.notReceiveGold = ret.data.notReceiveGold
			self.timeAndStatus = ret.data.timeAndStatus
			_ENV = gErrDef.Err_None
			gErrDef.Err_None.msg = "MESSAGE_MARKET_TRADEBOARDRETURN"
			SoraDSendMessage(gErrDef.Err_None)
			_ENV = gErrDef.Err_None
			gErrDef.Err_None.msg = "MESSAGE_MAINCITY_VIEW_UPDATE_MARKET_AUCTION"
			SoraDSendMessage(gErrDef.Err_None)
		end
	end
end
function salesRoomAgCtrl:salesRoomAddPlusResp(ret)
	if ret and ret.data then
		if ret.err == gErrDef.Err_SALES_ROOM_NO_MARKET then
			_ENV = gErrDef.Err_SALES_ROOM_NO_MARKET
			gErrDef.Err_SALES_ROOM_NO_MARKET.msg = "MESSAGE_MARKET_TRADEBOARDRETURN_CLOSE"
			SoraDSendMessage(gErrDef.Err_SALES_ROOM_NO_MARKET)
		elseif ret.err == gErrDef.Err_None then
			SoraDShowMsgTip(i18n("common_text_2833"))
		end
		_ENV = i18n("common_text_2833")
		i18n("common_text_2833").msg = "MESSAGE_MARKET_TRADEBOARDRETURN_CLOSELOADING"
		SoraDSendMessage(i18n("common_text_2833"))
	end
end
function salesRoomAgCtrl:getClearLogResp(ret)
	if ret then
	end
end
function salesRoomAgCtrl:getSalesRoomLogResp(ret)
	if ret and ret.data and ret.err == gErrDef.Err_None then
		if not self.salesRoomLog then
			self.salesRoomLog, _ENV = self.salesRoomLog, self.salesRoomLog
		end
		if type(ret.data.selfLog) == "table" then
			for index, value in pairs(ret.data.selfLog) do
				self.salesRoomLog[tonumber(index)] = value
			end
		end
		local newStartIndex = ret.data.newStartIndex
		local bCanContinueGet = ret.data.bCanContinueGet
		_ENV = nil
		;(nil).msg = "MESSAGE_MARKET_TRADEBOARDRETURN_RECORD"
		;(nil).datalog = self.salesRoomLog
		;(nil).idx = newStartIndex
		;(nil).wget = bCanContinueGet
		SoraDSendMessage(nil)
	end
end
function salesRoomAgCtrl:getReceiveGoldResp(ret)
	if not (ret and ret.data) or ret.err == gErrDef.Err_SALES_ROOM_NO_GOLD_RECEIVE then
	elseif ret.err == gErrDef.Err_None then
		local receiveGold = ret.data.receiveGold
		self.notReceiveGold = 0
		_ENV = nil
		;(nil).num = tostring(receiveGold)
		SoraDShowMsgTip(i18n("common_text_2857", nil))
		SoraDPopGainItem(gIDDef.GOLD, receiveGold)
		_ENV = gIDDef.GOLD
		gIDDef.GOLD.msg = "MESSAGE_MARKET_TRADEBOARDRETURN"
		SoraDSendMessage(gIDDef.GOLD)
		local newStartIndex = 1
		local bCanContinueGet = false
		self.salesRoomGoldLog, _ENV = receiveGold, receiveGold
		_ENV = i18n("common_text_2857", nil)
		i18n("common_text_2857", nil).msg = "MESSAGE_MARKET_TRADEBOARDRETURN_GOLDRECORD"
		i18n("common_text_2857", nil).datalog = self.salesRoomGoldLog
		i18n("common_text_2857", nil).idx = newStartIndex
		i18n("common_text_2857", nil).wget = bCanContinueGet
		SoraDSendMessage(i18n("common_text_2857", nil))
		_ENV = i18n("common_text_2857", nil)
		i18n("common_text_2857", nil).msg = "MESSAGE_MAINCITY_VIEW_UPDATE_MARKET_AUCTION"
		SoraDSendMessage(i18n("common_text_2857", nil))
	end
end
function salesRoomAgCtrl:getReceiveGoldLogResp(ret)
	if ret and ret.data and ret.err == gErrDef.Err_None then
		local startIndex = ret.data.startIndex
		if self.salesRoomGoldLog and tonumber(startIndex) == 1 then
			self.salesRoomGoldLog = nil
		end
		if not self.salesRoomGoldLog then
			self.salesRoomGoldLog, _ENV = self.salesRoomGoldLog, self.salesRoomGoldLog
		end
		if type(ret.data.selfLog) == "table" then
			for index, value in pairs(ret.data.selfLog) do
				value.show = true
				self.salesRoomGoldLog[tonumber(index)] = value
			end
		end
		local newStartIndex = ret.data.newStartIndex
		self.newStartIndex = newStartIndex
		local bCanContinueGet = ret.data.bCanContinueGet
		self.bCanContinueGet = bCanContinueGet
		_ENV = nil
		;(nil).msg = "MESSAGE_MARKET_TRADEBOARDRETURN_GOLDRECORD"
		;(nil).datalog = self.salesRoomGoldLog
		;(nil).idx = newStartIndex
		;(nil).wget = bCanContinueGet
		SoraDSendMessage(nil)
	end
end
function salesRoomAgCtrl:getReceivOneGoldResp(ret)
	if ret and ret.data and ret.err == gErrDef.Err_None then
		local info = ret.data.info
		if type(self.salesRoomGoldLog) == "table" then
			for key, value in pairs(self.salesRoomGoldLog) do
				if value.group == info.group and value.position == info.position and value.sequence == info.sequence and value.time == info.time and value.gold == info.gold then
					value.show = false
					self.salesRoomGoldLog[key] = value
					break
				end
			end
		end
		local newStartIndex = self.newStartIndex or 1
		local bCanContinueGet = self.bCanContinueGet or true
		local receiveGold = ret.data.receiveGold
		self.notReceiveGold = self.notReceiveGold - receiveGold
		if self.notReceiveGold <= 0 then
			self.notReceiveGold = 0
		end
		_ENV = info.gold
		info.gold.num = tostring(receiveGold)
		SoraDShowMsgTip(i18n("common_text_2857", info.gold))
		SoraDPopGainItem(gIDDef.GOLD, receiveGold)
		_ENV = gIDDef.GOLD
		gIDDef.GOLD.msg = "MESSAGE_MARKET_TRADEBOARDRETURN"
		SoraDSendMessage(gIDDef.GOLD)
		_ENV = gIDDef.GOLD
		gIDDef.GOLD.msg = "MESSAGE_MARKET_TRADEBOARDRETURN_GOLDRECORD"
		if not self.salesRoomGoldLog then
			_ENV = self.salesRoomGoldLog
		end
		gIDDef.GOLD.datalog = self.salesRoomGoldLog
		gIDDef.GOLD.idx = newStartIndex
		gIDDef.GOLD.wget = bCanContinueGet
		SoraDSendMessage(gIDDef.GOLD)
		_ENV = gIDDef.GOLD
		gIDDef.GOLD.msg = "MESSAGE_MAINCITY_VIEW_UPDATE_MARKET_AUCTION"
		SoraDSendMessage(gIDDef.GOLD)
	end
end
function salesRoomAgCtrl:getAllItemsInfo()
	if not self.itemsInfo then
		_ENV = self.itemsInfo
	end
	self.itemsInfo = self.itemsInfo
	local _ENV, ret = self.itemsInfo, self.itemsInfo
	for key, value in pairs(self.itemsInfo) do
		table.insert(ret, value)
	end
	table.sort(ret, function(a, b)
		if a.putawayTime == b.putawayTime then
			return a.position < b.position
		else
			return a.putawayTime < b.putawayTime
		end
	end)
	return ret
end
function salesRoomAgCtrl:getTimeAndStatus()
	return self.timeAndStatus
end
function salesRoomAgCtrl:getNotReceiveGold()
	return self.notReceiveGold
end
function salesRoomAgCtrl:getSaleRoomLog()
	return self.salesRoomLog
end
function salesRoomAgCtrl:checkOpenCond(isNoTip)
	local isNoTip = isNoTip or false
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local worldMapDefine = include("worldMapDefine")
	if worldMapDefine.isInWar() then
		if not isNoTip then
			SoraDShowMsgTip(i18n("common_text_3302"))
		end
	elseif worldMapDefine.isInKingdomBattle() then
		if not isNoTip then
			SoraDShowMsgTip(i18n("common_text_2836"))
		end
	elseif SoraDGetCtrl("cityCtrl"):getBuildCell(BUILDID.MARKET, 0) == nil then
		if not isNoTip then
			_ENV = 0
			;(0).name = i18n("buildDes_name_112")
			SoraDShowMsgTip(i18n("lordskill_text_08", 0))
		end
	else
		local gametop = gModuleMgr.getObject("gametop")
		local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
		if kingdomCtrl:getCanMoveOut(gametop.playertop_:getKingdomID()) then
			if not isNoTip then
				SoraDShowMsgTip(i18n("migrate_notice_05"))
			end
		else
			return true
		end
	end
	return false
end
function salesRoomAgCtrl:sendNewInitMsg()
	serverproxy:Request(gCmd.CMD_SALES_ROOM_MODULE, gCmd.REQ_NEW_SALES_ROOM_INIT)
end
function salesRoomAgCtrl:sendNewAddPlusMsg(shopID, cost)
	local serverproxy, data
	data.shopID = shopID
	data.cost = cost
	serverproxy:Request(gCmd.CMD_SALES_ROOM_MODULE, gCmd.REQ_NEW_SALES_ROOM_ADD_PLUS, data)
end
function salesRoomAgCtrl:sendNewLogMsg(shopID)
	local serverproxy, data
	data.shopID = shopID
	serverproxy:Request(gCmd.CMD_SALES_ROOM_MODULE, gCmd.REQ_NEW_SALES_ROOM_GET_LOG, data)
end
function salesRoomAgCtrl:sendNewSuccessLogMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SALES_ROOM_MODULE, gCmd.REQ_NEW_SALES_ROOM_SUCCESS_LOG, nil)
end
function salesRoomAgCtrl:sendClearHintMsg()
	serverproxy:Request(gCmd.CMD_SALES_ROOM_MODULE, gCmd.REQ_NEW_SALES_ROOM_CLEAR_HINT)
end
function salesRoomAgCtrl:newSalesRoomInitResp(ret)
	dump(ret, "salesRoomAgCtrl:newSalesRoomInitResp", 10)
	if ret.err == gErrDef.Err_None or ret.err == gErrDef.Err_SALES_ROOM_ACTIVITY_NOT_OPEN then
		self.boreNum = ret.rspdata.boreNum
		self.salesRoomData = ret.rspdata.salesRoomData
		_ENV = gErrDef.Err_SALES_ROOM_ACTIVITY_NOT_OPEN
		gErrDef.Err_SALES_ROOM_ACTIVITY_NOT_OPEN.msg = "MESSAGE_MARKET_NEW_TRADEBOARDRETURN"
		SoraDSendMessage(gErrDef.Err_SALES_ROOM_ACTIVITY_NOT_OPEN)
	end
end
function salesRoomAgCtrl:newSalesRoomAddPlusResp(ret)
	dump(ret, "salesRoomAgCtrl:newSalesRoomAddPlusResp", 10)
	if ret and ret.err == gErrDef.Err_None then
		self.boreNum = ret.rspdata.boreNum
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_MARKET_NEW_TRADEBOARDRETURN"
		gErrDef.Err_None.name = "bore"
		SoraDSendMessage(gErrDef.Err_None)
		local retItem = ret.rspdata.retItem
		if retItem._curprice == retItem.fixedPrice then
			SoraDShowMsgTip(i18n("auction_text_15"))
		else
			SoraDShowMsgTip(i18n("common_text_2833"))
		end
		local shopID = retItem.shopID
		if self.salesRoomData and self.salesRoomData[shopID] then
			self.salesRoomData[shopID] = retItem
		end
	end
end
function salesRoomAgCtrl:getNewSalesRoomLogResp(ret)
	dump(ret, "salesRoomAgCtrl:getNewSalesRoomLogResp", 10)
	if ret and ret.err == gErrDef.Err_None then
		local logInfo = ret.rspdata.logInfo
		local _ENV, retTab = gErrDef.Err_None, gErrDef.Err_None
		local selfUid = gametop.playertop_:getPlayerID()
		for i, v in ipairs(logInfo) do
			table.insert(retTab, v)
			if v.uid1 and v.uid1 == selfUid then
				local temp = clone(v)
				temp.logType = gSalesRoomLogType.MORE_THAN_MY_PRICE
				if v.uid2 and v.uid1 ~= v.uid2 then
					table.insert(retTab, temp)
				end
			end
		end
		_ENV = ipairs(logInfo)
		ipairs(logInfo).msg = "MESSAGE_MARKET_NEW_TRADEBOARDRETURN_RECORD"
		ipairs(logInfo).logInfo = retTab
		SoraDSendMessage(ipairs(logInfo))
	end
end
function salesRoomAgCtrl:getSuccessLogResp(ret)
	dump(ret, "salesRoomAgCtrl:getSuccessLogResp", 10)
	if ret and ret.err == gErrDef.Err_None then
		self.successInfo = ret.rspdata.successInfo or self.successInfo
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_MARKET_NEW_TRADEBOARD_SELFRECORD"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function salesRoomAgCtrl:clearHintResp(ret)
	dump(ret, "salesRoomAgCtrl:clearHintResp", 10)
	if ret and ret.err == gErrDef.Err_None then
		self.hint = false
		self:refreshHint()
	end
end
function salesRoomAgCtrl:refreshHint()
	_ENV = nil
	;(nil).msg = "MESSAGE_MARKET_NEW_TRADEBOARD_CLEARHINT"
	SoraDSendMessage(nil)
	local cityBuildMgr = include("cityBuildMgr")
	local buildEntity = cityBuildMgr:getBuildByBid(BUILDID.MARKET)
	if buildEntity then
		buildEntity:checkMarketAuction()
	end
	_ENV = buildEntity
	buildEntity.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	SoraDSendMessage(buildEntity)
end
function salesRoomAgCtrl:getSuccessInfo(...)
	return self.successInfo
end
function salesRoomAgCtrl:getBoreNum(...)
	return self.boreNum
end
function salesRoomAgCtrl:getSalesRoomData(...)
	if not self.salesRoomData then
		_ENV = self.salesRoomData
	end
	self.salesRoomData = self.salesRoomData
	local _ENV, ret = self.salesRoomData, self.salesRoomData
	for key, value in pairs(self.salesRoomData) do
		table.insert(ret, value)
	end
	table.sort(ret, function(a, b)
		if a._btime == b._btime then
			return a.position < b.position
		else
			return a._btime < b._btime
		end
	end)
	return ret
end
function salesRoomAgCtrl:checkEnoughBore(needBore)
	return needBore <= self.boreNum
end
function salesRoomAgCtrl:checkEnoughRes(needRes, resType)
	if resType and resType == gIDDef.BORE then
		if self:checkEnoughBore(needRes) then
			return true
		end
	elseif SoraDEnoughGold(needRes, true) then
		return true
	end
	return false
end
function salesRoomAgCtrl:getHint(...)
	return self.hint
end
function salesRoomAgCtrl:getReceiveStatusAndNum(...)
	if self.hint then
		return true, -1
	else
		return false, 0
	end
end
return salesRoomAgCtrl
