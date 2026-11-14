local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local exchangeMallCtrl = class("exchangeMallCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
function exchangeMallCtrl:ctor(properties)
	exchangeMallCtrl.super.ctor(self, properties)
end
function exchangeMallCtrl:Logout()
	exchangeMallCtrl.super.Logout(self)
	self:resetData()
end
function exchangeMallCtrl:resetData()
	self.costIDArray, _UPVALUE0_, self.exchangeData, _UPVALUE0_, self.handle_notify = nil, nil, nil, nil, nil
end
function exchangeMallCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_EXCHANGEMALL_MODULE, gCmd.REQ_EXCHANGE_GOOD, handler(self, self.getExchangeRsp))
	msgCtrl.register(gCmd.CMD_EXCHANGEMALL_MODULE, gCmd.REQ_EXCHANGE_REMIND, handler(self, self.getExchangeRemindRsp))
end
function exchangeMallCtrl:initClientData(data)
	if nil == data then
		return
	end
	self:initExchangeData(data)
	self:registerNotify()
end
function exchangeMallCtrl:initExchangeData(data)
	dump(data, "initExchangeData===", 10)
	if data and data.exchangeData then
		self.exchangeData = data.exchangeData
	end
	if data and data.costIDArray then
		self.costIDArray = data.costIDArray
	end
end
function exchangeMallCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.EXCHANGE_MALL, handler(self, self.notifyHandler))
end
function exchangeMallCtrl:notifyHandler(event)
	for _, content in ipairs(event.data) do
		self:initExchangeData(content)
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_SERVER_EXCHANGEMALL_EX_REFRESH"
	ipairs(event.data).notify = true
	SoraDSendMessage(ipairs(event.data))
end
function exchangeMallCtrl:getConfigByActivityID(activityID)
	if self.exchangeData and self.exchangeData[tostring(activityID)] then
		return self.exchangeData[tostring(activityID)]
	end
end
function exchangeMallCtrl:getCostIDByActivityID(activityID)
	local costIDArray
	if self.costIDArray and self.costIDArray[tostring(activityID)] then
		costIDArray = self.costIDArray[tostring(activityID)]
	end
	return costIDArray
end
function exchangeMallCtrl:sendExchange(itemID, itemCount, activityID, costItemID)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_EXCHANGEMALL_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_EXCHANGE_GOOD, gCmd.REQ_EXCHANGE_GOOD
	gCmd.REQ_EXCHANGE_GOOD.itemID = itemID
	gCmd.REQ_EXCHANGE_GOOD.itemCount = itemCount
	gCmd.REQ_EXCHANGE_GOOD.activityID = activityID
	;(nil).data, gCmd.REQ_EXCHANGE_GOOD.costItemID = gCmd.REQ_EXCHANGE_GOOD, costItemID
	local msg
	serverproxy:SendMsg(msg)
end
function exchangeMallCtrl:sendExchangeRemind(itemID, remindStatus, activityID, costItemID)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_EXCHANGEMALL_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_EXCHANGE_REMIND, gCmd.REQ_EXCHANGE_REMIND
	gCmd.REQ_EXCHANGE_REMIND.itemID = itemID
	gCmd.REQ_EXCHANGE_REMIND.remindStatus = remindStatus
	gCmd.REQ_EXCHANGE_REMIND.activityID = activityID
	;(nil).data, gCmd.REQ_EXCHANGE_REMIND.costItemID = gCmd.REQ_EXCHANGE_REMIND, costItemID
	local msg
	serverproxy:SendMsg(msg)
end
function exchangeMallCtrl:getExchangeRsp(content)
	dump(content, "exchangeMallCtrl:getExchangeRsp", 5)
	if not content.rspdata then
		local _ENV, rspdata = content.rspdata, content.rspdata
	end
	if not rspdata.reward then
		local _ENV, reward = rspdata.reward, rspdata.reward
	end
	if gErrDef.Err_None == content.err then
		self:initExchangeData(rspdata.exchangeMallData)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EXCHANGEMALL_EX_REFRESH"
		SoraDSendMessage(self)
		local _ENV, rewardList = SoraDSendMessage, SoraDSendMessage
		for key, value in pairs(reward) do
			rewardList[value.id] = value.count
		end
		SoraDMailGainItems(rewardList)
	end
	_ENV = SoraDMailGainItems
	SoraDMailGainItems.msg = "MESSAGE_SERVER_EVENTCENTER_EXCHANGE_REFRESH"
	SoraDSendMessage(SoraDMailGainItems)
	_ENV = SoraDMailGainItems
	SoraDMailGainItems.msg = "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING"
	SoraDSendMessage(SoraDMailGainItems)
end
function exchangeMallCtrl:getExchangeRemindRsp(content)
	dump(content, "exchangeMallCtrl:getExchangeRemindRsp", 5)
	if gErrDef.Err_None == content.err then
		if not content.rspdata then
			local _ENV, rspdata = content.rspdata, content.rspdata
		end
		self:initExchangeData(rspdata.exchangeMallData)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EXCHANGEMALL_SET_REFRESH"
		self.remindStatus = rspdata.remindStatus
		self.itemID = rspdata.itemID
		SoraDSendMessage(self)
	elseif gErrDef.Err_ACTIVITY_UNFOUND == content.err then
	end
end
return exchangeMallCtrl
