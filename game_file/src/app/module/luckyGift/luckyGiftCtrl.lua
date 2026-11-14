local GameModule = include("GameModule")
local luckyGiftCtrl = class("luckyGiftCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function luckyGiftCtrl:ctor(properties)
	luckyGiftCtrl.super.ctor(self, properties)
end
function luckyGiftCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_LUCKYGIFT_MODULE, gCmd.REQ_LUCKYGIFT_INIT_DATA, handler(self, self.getInitLuckyGift))
	msgCtrl.register(gCmd.CMD_LUCKYGIFT_MODULE, gCmd.REQ_LUCKYGIFT_RECEIVE_OR_BUY, handler(self, self.getReceiveLuckyGift))
	msgCtrl.register(gCmd.CMD_LUCKYGIFT_MODULE, gCmd.REQ_LUCKYGIFT_CHECK_NEW, handler(self, self.getCheckNewResp))
	self:resetData()
	self:registerNotify()
end
function luckyGiftCtrl:resetData()
	self.luckyGiftData, _UPVALUE0_ = nil, nil
	self.handle_notify = nil
end
function luckyGiftCtrl:Logout()
	luckyGiftCtrl.super.Logout(self)
	self:resetData()
end
function luckyGiftCtrl:initClientData()
	self:sendInitData()
end
function luckyGiftCtrl:isNewLuckyGift()
	if type(self.luckyGiftData) == "table" and next(self.luckyGiftData) then
		for key, value in pairs(self.luckyGiftData) do
			if value.isNew == true then
				return true
			end
		end
	end
end
function luckyGiftCtrl:dealExtraRechargeData()
	if type(self.luckyGiftData) == "table" then
		for k, v in pairs(self.luckyGiftData) do
			if v.luckyGiftID and v.luckyGiftID >= gExtraGiftIDDef.LUCKY_GIFT_BEGIN and v.luckyGiftID <= gExtraGiftIDDef.LUCKY_GIFT_END then
				gModuleMgr.sharedMgr("rechargeExtraltCtrl"):addExtraData(clone(v))
			end
		end
	end
end
function luckyGiftCtrl:getInitLuckyGift(content)
	self.luckyGiftData = content.rspdata and content.rspdata.newLuckyGiftData
	dump(self.luckyGiftData, "luckyGiftCtrl:getInitLuckyGift", 10)
	self:dealExtraRechargeData()
	_ENV = self
	self.msg = "MESSAGE_SERVER_RECHARGECENTER_LUCKYGIFTREFRESH"
	self.pushNew = self:isNewLuckyGift()
	SoraDSendMessage(self)
	_ENV = self
	self.msg = "MESSAGE_SERVER_RECHARGECENTER_LUCKYGIFTCHOICEREFRESH"
	self.pushNew = self:isNewLuckyGift()
	SoraDSendMessage(self)
end
function luckyGiftCtrl:getReceiveLuckyGift(content)
	dump(content, "luckyGiftCtrl:getReceiveLuckyGift", 10)
	if content.err == gErrDef.Err_None then
		local rechargeID = content.rspdata.rechargeID
		local price = content.rspdata.price
		if price == 0 then
			_ENV = 10
			_ENV, (10).msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
			;(nil).result = true
			;(10).data, (nil).rid = nil, rechargeID
			SoraDSendMessage(10)
			paymentManager.isInRecharging = false
		else
			local orderID = content.rspdata.orderID
			local pushID = content.rspdata.pushid
			paymentManager.purchase(rechargeID, orderID, pushID)
		end
	else
		paymentManager.isInRecharging = false
	end
end
function luckyGiftCtrl:getCheckNewResp(content)
	if not content.rspdata then
		return
	end
	local bChange = false
	if content.rspdata.newLuckyGiftData and self.luckyGiftData and #self.luckyGiftData ~= #content.rspdata.newLuckyGiftData then
		bChange = true
	end
	self.luckyGiftData = content.rspdata.newLuckyGiftData
	dump(self.luckyGiftData, "luckyGiftCtrl:getCheckNewResp", 10)
	if bChange then
		_ENV = self.luckyGiftData
		self.luckyGiftData.msg = "MESSAGE_SERVER_RECHARGECENTER_LUCKYGIFTREFRESH"
		SoraDSendMessage(self.luckyGiftData)
		_ENV = self.luckyGiftData
		self.luckyGiftData.msg = "MESSAGE_SERVER_RECHARGECENTER_LUCKYGIFTCHOICEREFRESH"
		SoraDSendMessage(self.luckyGiftData)
	end
end
function luckyGiftCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.LUCKYGIFT, handler(self, self.notifyLuckyGift))
end
function luckyGiftCtrl:notifyLuckyGift(event, bFirst)
	dump(event.data, "luckyGiftCtrl:notifyLuckyGift", 10)
	for _, content in ipairs(event.data) do
		self.luckyGiftData = content.newLuckyGiftData
		self:dealExtraRechargeData()
		local price = content.price
		local rechargeID = content.rechargeID
		local reward = content.reward
		local mailid = content.mailid
		if price then
			paymentManager.OnemtRechargeSuccess(price)
			paymentManager.loopForFinishTransaction()
			_ENV = price
			_ENV, price.msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
			;(nil).result = true
			;(nil).rid = rechargeID
			;(nil).itemList = reward
			price.data, (nil).mailID = nil, mailid
			SoraDSendMessage(price)
		end
		_ENV = price
		price.msg = "MESSAGE_SERVER_RECHARGECENTER_LUCKYGIFTREFRESH"
		price.pushNew = self:isNewLuckyGift()
		SoraDSendMessage(price)
		_ENV = price
		price.msg = "MESSAGE_SERVER_RECHARGECENTER_LUCKYGIFTCHOICEREFRESH"
		price.pushNew = self:isNewLuckyGift()
		SoraDSendMessage(price)
	end
end
function luckyGiftCtrl:sendInitData()
	serverproxy:Request(gCmd.CMD_LUCKYGIFT_MODULE, gCmd.REQ_LUCKYGIFT_INIT_DATA)
end
function luckyGiftCtrl:sendReceiveReward(luckyGiftID)
	serverproxy = nil
	;(nil).luckyGiftID = luckyGiftID
	serverproxy:Request(gCmd.CMD_LUCKYGIFT_MODULE, gCmd.REQ_LUCKYGIFT_RECEIVE_OR_BUY, nil)
end
function luckyGiftCtrl:sendCheckNewGift(luckyGiftID)
	serverproxy = nil
	;(nil).luckyGiftID = luckyGiftID
	serverproxy:Request(gCmd.CMD_LUCKYGIFT_MODULE, gCmd.REQ_LUCKYGIFT_CHECK_NEW, nil)
end
function luckyGiftCtrl:getLuckyGiftTime(luckyGiftID)
	local time = 0
	for key, value in pairs(self.luckyGiftData) do
		if value.luckyGiftID == luckyGiftID then
			return math.max(0, value.endTime - serviceFunctions.systemTime())
		end
	end
	return time
end
function luckyGiftCtrl:getLuckyGiftData(bSortByTime)
	local _ENV, data
	if type(self.luckyGiftData) == "table" then
		for key, value in pairs(self.luckyGiftData) do
			value.lastTime = value.endTime - serviceFunctions.systemTime()
			if value.lastTime > 0 and value.type ~= gLuckyPackageType.LUCKY_PACKAGE_CHOICE then
				table.insert(data, value)
			end
		end
	end
	if bSortByTime == true then
		table.sort(data, function(a, b)
			if a.display_order == b.display_order then
				if a.beginTime and b.beginTime then
					return a.beginTime > b.beginTime
				end
			else
				return a.display_order < b.display_order
			end
		end)
	end
	return data
end
function luckyGiftCtrl:getChoiceLuckyGiftData(bSortByTime)
	local _ENV, data
	if type(self.luckyGiftData) == "table" then
		for key, value in pairs(self.luckyGiftData) do
			value.lastTime = value.endTime - serviceFunctions.systemTime()
			if value.lastTime > 0 and value.type == gLuckyPackageType.LUCKY_PACKAGE_CHOICE then
				table.insert(data, value)
			end
		end
	end
	if bSortByTime == true then
		table.sort(data, function(a, b)
			if a.display_order == b.display_order then
				if a.beginTime and b.beginTime then
					return a.beginTime > b.beginTime
				end
			else
				return a.display_order < b.display_order
			end
		end)
	end
	return data
end
function luckyGiftCtrl:getNewLuckyGiftData(isChoiceGift)
	local rechargeRead = include("rechargeRead")
	local data
	if isChoiceGift then
		data = self:getChoiceLuckyGiftData(true)
	else
		data = self:getLuckyGiftData(true)
	end
	if data and table.nums(data) > 0 then
		for i = 1, table.nums(data) do
			local _rid = data[i].luckyGiftID
			if rechargeRead.hasRechargeItem(_rid) then
				return data[i]
			end
		end
	end
	return data
end
function luckyGiftCtrl:getBirthdayLadderGiftData()
	local rechargeRead = include("rechargeRead")
	local _ENV, ladderData = "rechargeRead", "rechargeRead"
	if not self:getLuckyGiftData(true) then
		local _ENV, data = self:getLuckyGiftData(true), self:getLuckyGiftData(true)
	end
	local _ENV, birthdayData = self, self
	for k, v in ipairs(data) do
		if rechargeRead.hasRechargeItem(v.luckyGiftID) and v.type == gLuckyPackageType.LUCKY_PACKAGE_BIRTHDAY and #v.extraData > 0 then
			table.insert(birthdayData, v)
		end
	end
	table.sort(birthdayData, function(a, b)
		return a.luckyGiftID < b.luckyGiftID
	end)
	if 0 < #birthdayData then
		ladderData = birthdayData[1]
		ladderData.ID = ladderData.luckyGiftID
		ladderData.rType = gRechargeActiveModelType.BIRTHDAY_LADDER
		ladderData.giftStyle = rechargeRead.getPageViewData(ladderData.luckyGiftID)
		local _ENV, nextLadderList = rechargeRead.getPageViewData(ladderData.luckyGiftID), rechargeRead.getPageViewData(ladderData.luckyGiftID)
		for i = 2, #birthdayData do
			birthdayData[i].ID = birthdayData[i].luckyGiftID
			birthdayData[i].giftStyle = rechargeRead.getPageViewData(birthdayData[i].luckyGiftID)
			birthdayData[i].rType = gRechargeActiveModelType.BIRTHDAY_LADDER
			table.insert(nextLadderList, birthdayData[i])
		end
		ladderData.nextLadderList = nextLadderList
	end
	return ladderData
end
function luckyGiftCtrl:getRedPointNum()
	local redPointNum = 0
	if "table" == type(self.luckyGiftData) and next(self.luckyGiftData) then
		for k, v in pairs(self.luckyGiftData) do
			if false == v.isCheck then
				redPointNum = redPointNum + 1
			end
		end
	end
	return redPointNum
end
function luckyGiftCtrl:getChoicePackagesRedPointNum()
	local redPointNum = 0
	if "table" == type(self.luckyGiftData) and next(self.luckyGiftData) then
		for k, v in pairs(self.luckyGiftData) do
			if false == v.isCheck and v.type == gLuckyPackageType.LUCKY_PACKAGE_CHOICE then
				redPointNum = redPointNum + 1
			end
		end
	end
	return redPointNum
end
function luckyGiftCtrl:clickGift(luckyGiftID, isChoiceGift)
	if isChoiceGift then
		if self:getChoicePackagesRedPointNum() > 0 then
			self:sendCheckNewGift(luckyGiftID)
			_ENV = self
			self.msg = "MESSAGE_CLIENT_RECHARGECENTER_LUCKYGIFTCHOICEPOINTREFRESH"
			SoraDSendMessage(self)
		end
	elseif 0 < self:getRedPointNum() then
		self:sendCheckNewGift(luckyGiftID)
	end
end
function luckyGiftCtrl:getLuckyGift(id)
	local ret
	if "table" == type(self.luckyGiftData) and next(self.luckyGiftData) then
		for k, v in pairs(self.luckyGiftData) do
			if tonumber(v.rid) == tonumber(id) then
				ret = v
				break
			end
		end
	end
	return ret
end
return luckyGiftCtrl
