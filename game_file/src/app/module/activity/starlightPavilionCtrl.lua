local GameModule = include("GameModule")
local starlightPavilionCtrl = class("starlightPavilionCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function starlightPavilionCtrl:ctor(properties)
	starlightPavilionCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.STARLIGHT_PAVILION_ACTIVITY
end
function starlightPavilionCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_STARLIGHT_PAVILION_MODULE, gCmd.REQ_STARLIGHT_PAVILION_DATA, handler(self, self.reqDataRsp))
	msgCtrl.register(gCmd.CMD_STARLIGHT_PAVILION_MODULE, gCmd.REQ_STARLIGHT_PAVILION_EXCHANGE, handler(self, self.reqExchangeRsp))
	msgCtrl.register(gCmd.CMD_STARLIGHT_PAVILION_MODULE, gCmd.REQ_STARLIGHT_PAVILION_BUY, handler(self, self.reqBuyRsp))
	self:resetData()
	self:registerNotify()
end
function starlightPavilionCtrl:resetData()
	self.giftRecord, _UPVALUE0_, self.exchangeRecord, _UPVALUE0_, self.classType = nil, nil, nil, nil, nil
end
function starlightPavilionCtrl:initClientData(data)
	dump(data, "starlightPavilionCtrl:initClientData====")
end
function starlightPavilionCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.STARLIGHT_PAVILION, handler(self, self.notifyHandler))
end
function starlightPavilionCtrl:notifyHandler(content)
	local notifydata = content.data
	for _, notifyMsg in ipairs(notifydata) do
		if notifyMsg.notifyType == "buyGift" then
			paymentManager.OnemtRechargeSuccess(notifyMsg.notifyData.price)
			paymentManager.loopForFinishTransaction()
			local reward = notifyMsg.notifyData.reward
			local price = notifyMsg.notifyData.price
			local rid = notifyMsg.notifyData.rid
			self.giftRecord[tostring(rid)] = (self.giftRecord[tostring(rid)] or 0) + 1
			_ENV = tostring(rid)
			_ENV, tostring(rid).msg = (self.giftRecord[tostring(rid)] or 0) + 1, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
			;(self.giftRecord[tostring(rid)] or 0) + 1.result = notifyMsg.notifyData.success
			;(self.giftRecord[tostring(rid)] or 0) + 1.rid = rid
			tostring(rid).data, (self.giftRecord[tostring(rid)] or 0) + 1.itemList = (self.giftRecord[tostring(rid)] or 0) + 1, reward
			SoraDSendMessage((tostring(rid)))
			_ENV = tostring(rid)
			tostring(rid).msg = "MESSAGE_ACTIVITY_STARSTOWER_UPDATE"
			SoraDSendMessage((tostring(rid)))
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
function starlightPavilionCtrl:sendData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_STARLIGHT_PAVILION_MODULE, gCmd.REQ_STARLIGHT_PAVILION_DATA, nil)
end
function starlightPavilionCtrl:sendExchange(index, count)
	serverproxy = nil
	;(nil).index = index
	;(nil).count = count or 1
	serverproxy:Request(gCmd.CMD_STARLIGHT_PAVILION_MODULE, gCmd.REQ_STARLIGHT_PAVILION_EXCHANGE, nil)
end
function starlightPavilionCtrl:sendBuyGift(rid)
	serverproxy = nil
	;(nil).rid = rid
	serverproxy:Request(gCmd.CMD_STARLIGHT_PAVILION_MODULE, gCmd.REQ_STARLIGHT_PAVILION_BUY, nil)
end
function starlightPavilionCtrl:reqDataRsp(content)
	dump(content, "==starlightPavilionCtrl:reqDataRsp==", 20)
	if content.err == gErrDef.Err_None then
		self.classType = content.rspdata.classType
		self.exchangeRecord = content.rspdata.exchangeRecord
		self.giftRecord = content.rspdata.giftRecord
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_STARSTOWER_UPDATE"
	SoraDSendMessage(gErrDef.Err_None)
end
function starlightPavilionCtrl:reqExchangeRsp(content)
	dump(content, "==starlightPavilionCtrl:reqExchangeRsp==", 20)
	if content.err == gErrDef.Err_None then
		self.exchangeRecord[tostring(content.data.index)] = (self.exchangeRecord[tostring(content.data.index)] or 0) + content.data.count
		local nebulastoreRead = include("nebulastoreRead")
		local cfg = nebulastoreRead.getItemCfg(content.data.index)
		_ENV, _ENV = content.data.index, content.data.count
		content.data.index.id = cfg.itemID
		content.data.count[1], content.data.index.count = content.data.index, content.data.count * cfg.num
		SoraDMailGainItems(content.data.count, true)
	end
	_ENV = nebulastoreRead.getItemCfg(content.data.index)
	nebulastoreRead.getItemCfg(content.data.index).msg = "MESSAGE_ACTIVITY_STARSTOWER_UPDATE"
	SoraDSendMessage((nebulastoreRead.getItemCfg(content.data.index)))
end
function starlightPavilionCtrl:reqBuyRsp(content)
	dump(content, "==starlightPavilionCtrl:reqBuyRsp==", 20)
	if content.err == gErrDef.Err_None then
		local giftid = content.data.rid
		local orderID = content.rspdata.orderID
		paymentManager.purchase(giftid, orderID)
	else
		SoraDCloseLoading()
		paymentManager.isInRecharging = false
	end
	_ENV = content.rspdata.orderID
	content.rspdata.orderID.msg = "MESSAGE_ACTIVITY_STARSTOWER_UPDATE"
	SoraDSendMessage(content.rspdata.orderID)
end
function starlightPavilionCtrl:getClassType()
	if not self.classType then
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		if not activityShowCtrl:getParamByID(self.activityID) then
			local _ENV, param = activityShowCtrl:getParamByID(self.activityID), activityShowCtrl:getParamByID(self.activityID)
		end
		self.classType = param.classtype or 1
	end
	return self.classType
end
function starlightPavilionCtrl:getExchangeCount(index)
	return self.exchangeRecord[tostring(index)] or 0
end
function starlightPavilionCtrl:getGiftCount(rid)
	return self.giftRecord[tostring(rid)] or 0
end
return starlightPavilionCtrl
