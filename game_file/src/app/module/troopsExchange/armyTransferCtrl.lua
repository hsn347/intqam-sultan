local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local armyTransferCtrl = class("armyTransferCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function armyTransferCtrl:ctor(properties)
	armyTransferCtrl.super.ctor(self, properties)
	self:resetData()
end
function armyTransferCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ARMY_TRANSFER_MODULE, gCmd.REQ_ARMY_TRANSFER_TRANS, handler(self, self.reqArmyTransferTransRsp))
	msgCtrl.register(gCmd.CMD_ARMY_TRANSFER_MODULE, gCmd.REQ_ARMY_TRANSFER_RECORD, handler(self, self.reqArmyTransferRecordRsp))
	self:registerNotify()
end
function armyTransferCtrl:Logout()
	armyTransferCtrl.super.Logout(self)
	self:resetData()
end
function armyTransferCtrl:resetData()
	self.historysRecord, _UPVALUE0_, self.transferInfo, _UPVALUE0_ = nil, nil, nil, nil
end
function armyTransferCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ARMY_TRANSFER, handler(self, self.notifyHandler))
end
function armyTransferCtrl:notifyHandler(event)
	dump(event.data, "armyTransferCtrl:notifyHandler", 10)
	for _, v in ipairs(event.data) do
		if v.type == "refreshData" then
			self.transferInfo = v.data.transferInfo
		end
	end
end
function armyTransferCtrl:reqArmyTransferTrans(data)
	serverproxy:Request(gCmd.CMD_ARMY_TRANSFER_MODULE, gCmd.REQ_ARMY_TRANSFER_TRANS, data)
end
function armyTransferCtrl:reqArmyTransferRecord()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ARMY_TRANSFER_MODULE, gCmd.REQ_ARMY_TRANSFER_RECORD, nil)
end
function armyTransferCtrl:reqArmyTransferTransRsp(content)
	dump(content, "armyTransferCtrl:reqArmyTransferTransRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = 10
		;(10).title = i18n("armyExchange_text_012")
		uiManager:show("troopsExchangeMsgTips", 10)
		self.transferInfo = content.rspdata.transferInfo
		_ENV = uiManager
		uiManager.msg = "MESSAGE_TROOPS_EXCHANGE_REFRESH"
		uiManager.activityID = gActivityTimeActivityID.ARMY_TRANSFER_ACTIVTY
		SoraDSendMessage(uiManager)
	end
end
function armyTransferCtrl:reqArmyTransferRecordRsp(content)
	dump(content, "armyTransferCtrl:reqArmyTransferRecordRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.historysRecord = content.rspdata
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_TROOPS_EXCHANGE_HISTORY"
	SoraDSendMessage(gErrDef.Err_None)
end
function armyTransferCtrl:getExchangeCount(armyType, armyLevel)
	if self.transferInfo[tostring(armyType)] then
		return self.transferInfo[tostring(armyType)][tostring(armyLevel)]
	else
		return 0
	end
end
function armyTransferCtrl:getHistoryList()
	return self.historysRecord
end
return armyTransferCtrl
