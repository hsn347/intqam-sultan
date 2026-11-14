local GameModule = include("GameModule")
local footballElfCtrl = class("footballElfCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function footballElfCtrl:ctor(properties)
	footballElfCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.FOOTBALL_ELF_ACTIVITY
end
function footballElfCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_FOOTBALL_ELF_BUY_GIFT, handler(self, self.reqBuyGiftRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_FOOTBALL_ELF_RECEIVE, handler(self, self.reqReceiveRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_FOOTBALL_ELF_USE_PROP, handler(self, self.reqUseRropRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_FOOTBALL_ELF_RANK, handler(self, self.reqRankRsp))
	self:resetData()
	self:registerNotify()
end
function footballElfCtrl:resetData()
	self.exp = 0
	_UPVALUE0_, self.isUnLock = nil, false
	;(nil)[1] = 0
	self.receiveRecord, (nil)[2] = nil, 0
end
function footballElfCtrl:initClientData(data)
	if data and data[tostring(self.activityID)] then
		self:setActivityData(data[tostring(self.activityID)])
	end
end
function footballElfCtrl:setActivityData(data)
	dump(data, "footballElfCtrl:setActivityData data===")
	self.exp = data.exp
	self.isUnLock = data.isUnLock
	self.receiveRecord = data.receiveRecord
end
function footballElfCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.FOOTBALL_ELF, handler(self, self.notifyHandler))
end
function footballElfCtrl:notifyHandler(content)
	dump(content, "footballElfCtrl:notifyHandler=====", 10)
	local notifydata = content.data
	for _, notifyMsg in ipairs(notifydata) do
		if notifyMsg.type == "buyGift" then
			self.isUnLock = notifyMsg.info.success
			paymentManager.OnemtRechargeSuccess(notifyMsg.info.price)
			paymentManager.loopForFinishTransaction()
			local reward = notifyMsg.info.reward
			local price = notifyMsg.info.price
			local rid = notifyMsg.info.rid
			_ENV = nil
			_ENV, (nil).msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
			;(nil).result = notifyMsg.info.success
			;(nil).rid = rid
			;(nil).data, (nil).itemList = nil, reward
			SoraDSendMessage(nil)
			_ENV = nil
			;(nil).msg = "MESSAGE_FOOTBALL_ELF_UPDATE"
			;(nil).isUnlock = self.isUnLock
			SoraDSendMessage(nil)
		end
	end
	_ENV = ipairs(notifydata)
	ipairs(notifydata).msg = "MESSAGE_ACTIVITY_MODULE_UPDATE_VIEW"
	ipairs(notifydata).eventID = self.activityID
	SoraDSendMessage(ipairs(notifydata))
	_ENV = ipairs(notifydata)
	ipairs(notifydata).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	ipairs(notifydata).eventID = self.activityID
	SoraDSendMessage(ipairs(notifydata))
end
function footballElfCtrl:sendBuyGift(rid)
	serverproxy = nil
	;(nil).rid = rid
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_FOOTBALL_ELF_BUY_GIFT, nil)
end
function footballElfCtrl:sendReceive()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_FOOTBALL_ELF_RECEIVE, nil)
end
function footballElfCtrl:sendUseProp(count)
	serverproxy = nil
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_FOOTBALL_ELF_USE_PROP, nil)
end
function footballElfCtrl:sendRank()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_FOOTBALL_ELF_RANK, nil)
end
function footballElfCtrl:reqBuyGiftRsp(content)
	dump(content, "==footballElfCtrl:reqBuyGiftRsp==", 20)
	if content.err == gErrDef.Err_None then
		local giftid = content.data.rid
		local orderID = content.rspdata.orderID
		paymentManager.purchase(giftid, orderID)
	else
		SoraDCloseLoading()
		paymentManager.isInRecharging = false
	end
	_ENV = content.rspdata.orderID
	content.rspdata.orderID.msg = "MESSAGE_FOOTBALL_ELF_UPDATE"
	SoraDSendMessage(content.rspdata.orderID)
end
function footballElfCtrl:reqReceiveRsp(content)
	dump(content, "==footballElfCtrl:reqReceiveRsp==", 20)
	if content.err == gErrDef.Err_None then
		self.exp = content.rspdata.exp
		self.isUnLock = content.rspdata.isUnLock
		self.receiveRecord = content.rspdata.receiveRecord
		local rewards = content.rspdata.rewards
		SoraDMailGainItems(rewards, true)
	end
	_ENV = SoraDMailGainItems
	SoraDMailGainItems.msg = "MESSAGE_FOOTBALL_ELF_UPDATE"
	SoraDSendMessage(SoraDMailGainItems)
end
function footballElfCtrl:reqUseRropRsp(content)
	dump(content, "==footballElfCtrl:reqUseRropRsp==", 20)
	if content.err == gErrDef.Err_None then
		self.exp = content.rspdata.exp
		self.isUnLock = content.rspdata.isUnLock
		self.receiveRecord = content.rspdata.receiveRecord
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_FOOTBALL_ELF_UPDATE"
	SoraDSendMessage(gErrDef.Err_None)
end
function footballElfCtrl:reqRankRsp(content)
	dump(content, "==footballElfCtrl:reqRankRsp==", 20)
	local _ENV, rankList = dump, dump
	local selfRank = 0
	if content.err == gErrDef.Err_None then
		rankList = content.rspdata.rankList
		selfRank = content.rspdata.selfRank
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_FOOTBALL_ELF_RANK"
	gErrDef.Err_None.selfRank = selfRank
	gErrDef.Err_None.rankList = rankList
	SoraDSendMessage(gErrDef.Err_None)
end
function footballElfCtrl:getReceiveStatusAndNum()
	local ret = false
	local num = 0
	local footballElfRead = include("footballElfRead")
	local lv = footballElfRead.getExpLv(self.exp, self:getClassType())
	if self.isUnLock then
		ret = lv > self.receiveRecord[1] or lv > self.receiveRecord[2]
	else
		ret = lv > self.receiveRecord[1]
	end
	return ret, -1
end
function footballElfCtrl:getClassType()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(self.activityID)
	local classType = param.classtype or 1
	return classType
end
function footballElfCtrl:getExp()
	return self.exp
end
function footballElfCtrl:getCurLv()
	local footballElfRead = include("footballElfRead")
	return footballElfRead.getExpLv(self.exp, self:getClassType())
end
function footballElfCtrl:getIsUnlock()
	return self.isUnLock
end
function footballElfCtrl:getReceiveRecord(isSenior)
	return self.receiveRecord[isSenior and 2 or 1]
end
return footballElfCtrl
