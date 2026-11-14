local GameModule = include("GameModule")
local dailySpecialCtrl = class("dailySpecialCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function dailySpecialCtrl:ctor(properties)
	dailySpecialCtrl.super.ctor(self, properties)
end
function dailySpecialCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	self:resetData()
end
function dailySpecialCtrl:initClientData(data)
	if not data then
		return
	end
	self.dailySpecialData = data
	self:registerNotify()
end
function dailySpecialCtrl:resetData()
	self.handle_notify = nil
	self.dailySpecialData = nil
end
function dailySpecialCtrl:Logout()
	self:resetData()
	dailySpecialCtrl.super.Logout(self)
end
function dailySpecialCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.DAILY_DISCOUNT_GIFT, handler(self, self.notifyHandler))
end
function dailySpecialCtrl:notifyHandler(event)
	dump(event.data, "dailySpecialCtrl:notifyHandler event.data", 10)
	for _, content in pairs(event.data) do
		if content then
			local info = content.data
			local giftType = content.type
			if "buyGift" == giftType then
				self.dailySpecialData.buyGiftList = info.buyGiftList
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
				info.mailid.msg = "MESSAGE_DAILY_SPECIAL_BUY_BACK"
				SoraDSendMessage(info.mailid)
			elseif "refreshData" == giftType then
				self.dailySpecialData = content.data
				_ENV = info.mailid
				info.mailid.msg = "MESSAGE_DAILY_SPECIAL_BUY_BACK"
				SoraDSendMessage(info.mailid)
			end
		end
	end
end
function dailySpecialCtrl:sendBuyPackageMsg(rechargeID)
	serverproxy = nil
	local (nil).rechargeID, data = rechargeID, nil
	serverproxy:Request(gCmd.CMD_DAILY_DISCOUNT_MODULE, gCmd.REQ_BUY_DAILY_DISCOUNT_GIFT, data)
end
function dailySpecialCtrl:sendReceiveFreeGiftMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_DAILY_DISCOUNT_MODULE, gCmd.REQ_RECEIVE_FREE_GIFT, data)
end
function dailySpecialCtrl:sendReceiveSpecialGiftMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_DAILY_DISCOUNT_MODULE, gCmd.REQ_RECEIVE_SPECIAL_GIFT, data)
end
function dailySpecialCtrl:buyDiscountRsp(ret)
	dump(ret, "dailySpecialCtrl:buyDiscountRsp", 10)
	if ret and ret.err == gErrDef.Err_None then
		local orderID = ret.rspdata.orderID
		paymentManager.purchase(ret.data.rechargeID, orderID)
	end
end
function dailySpecialCtrl:receiveFreeGiftRsp(ret)
	dump(ret, "dailySpecialCtrl:receiveFreeGiftRsp", 10)
	if ret and ret.rspdata and ret.err == gErrDef.Err_None then
		self.dailySpecialData.freeGiftTime = ret.rspdata.freeGiftTime
		local _ENV, tTbl = self.dailySpecialData, self.dailySpecialData
		for i, v in ipairs(ret.rspdata.rewardItem) do
			tTbl[v.id] = v.count
		end
		SoraDMailGainItems(tTbl)
		_ENV = tTbl
		tTbl.msg = "MESSAGE_DAILY_SPECIAL_GET_REWARD_BACK"
		SoraDSendMessage(tTbl)
	end
end
function dailySpecialCtrl:receiveSpecialGiftRsp(ret)
	dump(ret, "dailySpecialCtrl:receiveSpecialGiftRsp", 10)
	if ret and ret.rspdata and ret.err == gErrDef.Err_None then
		self.dailySpecialData.rewardGiftTime = ret.rspdata.rewardGiftTime
		local _ENV, tTbl = self.dailySpecialData, self.dailySpecialData
		for i, v in ipairs(ret.rspdata.rewardItem) do
			tTbl[v.id] = v.count
		end
		SoraDMailGainItems(tTbl)
		_ENV = tTbl
		tTbl.msg = "MESSAGE_DAILY_SPECIAL_GET_REWARD_BACK"
		SoraDSendMessage(tTbl)
	end
end
function dailySpecialCtrl:getPackageList()
	local _ENV, list
	for k, v in pairs(self.dailySpecialData.giftData) do
		table.insert(list, v)
	end
	table.sort(list, function(l, r)
		return l.ID < r.ID
	end)
	return list
end
function dailySpecialCtrl:getPackageRewardList(packageID)
	local _ENV, rewardList
	if self.dailySpecialData.giftData[tostring(packageID)] then
		_UPVALUE2_ = tostring(packageID)
		tostring(packageID)[1] = "rewardId"
		tostring(packageID)[2] = "rewardNum"
		rewardList = serviceFunctions.tableFormat(self.dailySpecialData.giftData[tostring(packageID)].gift, (tostring(packageID)))
	end
	return rewardList
end
function dailySpecialCtrl:getPackageSettingCover()
	if self.dailySpecialData.rewardGroup then
		return self.dailySpecialData.rewardGroup
	end
	return 1
end
function dailySpecialCtrl:getAlreadyBuyPackageNum()
	local num = 0
	for k, v in pairs(self.dailySpecialData.buyGiftList) do
		num = num + 1
	end
	return num
end
function dailySpecialCtrl:isPackageAlreadyBuy(packageID)
	if self.dailySpecialData.buyGiftList[tostring(packageID)] then
		return true
	end
	return false
end
function dailySpecialCtrl:getFreeGiftTime()
	return self.dailySpecialData.freeGiftTime
end
function dailySpecialCtrl:getSpecialGiftTime()
	return self.dailySpecialData.rewardGiftTime
end
function dailySpecialCtrl:getSpecialTodayRemainTime()
	return self.dailySpecialData.nextRefreshTime - serviceFunctions.systemTime()
end
return dailySpecialCtrl
