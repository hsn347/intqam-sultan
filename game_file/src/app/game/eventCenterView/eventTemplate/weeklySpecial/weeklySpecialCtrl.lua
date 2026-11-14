local GameModule = include("GameModule")
local weeklySpecialCtrl = class("weeklySpecialCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function weeklySpecialCtrl:ctor(properties)
	weeklySpecialCtrl.super.ctor(self, properties)
end
function weeklySpecialCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_WEEKLY_DISCOUNT_MODULE, gCmd.REQ_BUY_DISCOUNT_GIFT, handler(self, self.buyDiscountRsp))
	msgCtrl.register(gCmd.CMD_WEEKLY_DISCOUNT_MODULE, gCmd.REQ_RECEIVE_FREE_GIFT, handler(self, self.receiveFreeGiftRsp))
	msgCtrl.register(gCmd.CMD_WEEKLY_DISCOUNT_MODULE, gCmd.REQ_RECEIVE_SPECIAL_GIFT, handler(self, self.receiveSpecialGiftRsp))
	self:resetData()
end
function weeklySpecialCtrl:initClientData(data)
	if not data then
		return
	end
	self.weeklySpecialData = data
	self:registerNotify()
end
function weeklySpecialCtrl:resetData()
	self.handle_notify = nil
	self.weeklySpecialData = nil
end
function weeklySpecialCtrl:Logout()
	self:resetData()
	weeklySpecialCtrl.super.Logout(self)
end
function weeklySpecialCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.WEEKLY_DISCOUNT_GIFT, handler(self, self.notifyHandler))
end
function weeklySpecialCtrl:notifyHandler(event)
	dump(event.data, "weeklySpecialCtrl:notifyHandler event.data", 10)
	for _, content in pairs(event.data) do
		if content then
			local info = content.data
			local giftType = content.type
			if "buyGift" == giftType then
				self.weeklySpecialData.buyGiftList = info.buyGiftList
				if info.success == true then
					paymentManager.loopForFinishTransaction()
					local reward = info.reward
					local mailid = info.mailid
					local rid = info.rid
					_ENV = nil
					_ENV, (nil).msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
					;(nil).result = true
					;(nil).rid = rid
					;(nil).itemList = reward
					;(nil).data, (nil).mailID = nil, mailid
					SoraDSendMessage(nil)
				end
				_ENV = info.mailid
				info.mailid.msg = "MESSAGE_WEEKLY_SPECIAL_BUY_BACK"
				SoraDSendMessage(info.mailid)
			elseif "refreshData" == giftType then
				self.weeklySpecialData = content.data
				_ENV = info.mailid
				info.mailid.msg = "MESSAGE_WEEKLY_SPECIAL_BUY_BACK"
				SoraDSendMessage(info.mailid)
			end
		end
	end
end
function weeklySpecialCtrl:sendBuyPackageMsg(rechargeID)
	serverproxy = nil
	local (nil).rechargeID, data = rechargeID, nil
	serverproxy:Request(gCmd.CMD_WEEKLY_DISCOUNT_MODULE, gCmd.REQ_BUY_DISCOUNT_GIFT, data)
end
function weeklySpecialCtrl:sendReceiveFreeGiftMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_WEEKLY_DISCOUNT_MODULE, gCmd.REQ_RECEIVE_FREE_GIFT, data)
end
function weeklySpecialCtrl:sendReceiveSpecialGiftMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_WEEKLY_DISCOUNT_MODULE, gCmd.REQ_RECEIVE_SPECIAL_GIFT, data)
end
function weeklySpecialCtrl:buyDiscountRsp(ret)
	if ret and ret.err == gErrDef.Err_None then
		local orderID = ret.rspdata.orderID
		paymentManager.purchase(ret.data.rechargeID, orderID)
	end
end
function weeklySpecialCtrl:receiveFreeGiftRsp(ret)
	dump(ret, "weeklySpecialCtrl:receiveFreeGiftRsp", 10)
	if ret and ret.rspdata and ret.err == gErrDef.Err_None then
		self.weeklySpecialData.freeGiftTime = ret.rspdata.freeGiftTime
		local _ENV, tTbl = self.weeklySpecialData, self.weeklySpecialData
		for i, v in ipairs(ret.rspdata.rewardItem) do
			tTbl[v.id] = v.count
		end
		SoraDMailGainItems(tTbl)
		_ENV = tTbl
		tTbl.msg = "MESSAGE_WEEKLY_SPECIAL_GET_REWARD_BACK"
		SoraDSendMessage(tTbl)
	end
end
function weeklySpecialCtrl:receiveSpecialGiftRsp(ret)
	dump(ret, "weeklySpecialCtrl:receiveSpecialGiftRsp", 10)
	if ret and ret.rspdata and ret.err == gErrDef.Err_None then
		self.weeklySpecialData.rewardGiftTime = ret.rspdata.rewardGiftTime
		local _ENV, tTbl = self.weeklySpecialData, self.weeklySpecialData
		for i, v in ipairs(ret.rspdata.rewardItem) do
			tTbl[v.id] = v.count
		end
		SoraDMailGainItems(tTbl)
		_ENV = tTbl
		tTbl.msg = "MESSAGE_WEEKLY_SPECIAL_GET_REWARD_BACK"
		SoraDSendMessage(tTbl)
	end
end
function weeklySpecialCtrl:getPackageList()
	local _ENV, list
	for k, v in pairs(self.weeklySpecialData.giftData) do
		table.insert(list, v)
	end
	table.sort(list, function(l, r)
		return l.ID < r.ID
	end)
	return list
end
function weeklySpecialCtrl:getPackageRewardList(packageID)
	local _ENV, rewardList
	if self.weeklySpecialData.giftData[tostring(packageID)] then
		_UPVALUE2_ = tostring(packageID)
		tostring(packageID)[1] = "rewardId"
		tostring(packageID)[2] = "rewardNum"
		rewardList = serviceFunctions.tableFormat(self.weeklySpecialData.giftData[tostring(packageID)].gift, (tostring(packageID)))
	end
	return rewardList
end
function weeklySpecialCtrl:getPackageSettingCover()
	if self.weeklySpecialData.rewardGroup then
		return self.weeklySpecialData.rewardGroup
	end
	return 1
end
function weeklySpecialCtrl:getAlreadyBuyPackageNum()
	local num = 0
	for k, v in pairs(self.weeklySpecialData.buyGiftList) do
		num = num + 1
	end
	return num
end
function weeklySpecialCtrl:isPackageAlreadyBuy(packageID)
	if self.weeklySpecialData.buyGiftList[tostring(packageID)] then
		return true
	end
	return false
end
function weeklySpecialCtrl:getFreeGiftTime()
	return self.weeklySpecialData.freeGiftTime
end
function weeklySpecialCtrl:getSpecialGiftTime()
	return self.weeklySpecialData.rewardGiftTime
end
function weeklySpecialCtrl:getSpecialTodayRemainTime()
	if not self.weeklySpecialData then
		return 0
	end
	return self.weeklySpecialData.nextRefreshTime - serviceFunctions.systemTime()
end
return weeklySpecialCtrl
