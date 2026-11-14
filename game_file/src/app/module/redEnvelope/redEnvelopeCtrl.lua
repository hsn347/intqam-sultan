local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local redEnvelopeCtrl = class("redEnvelopeCtrl", GameModule)
function redEnvelopeCtrl:ctor(properties)
	redEnvelopeCtrl.super.ctor(self, properties)
end
function redEnvelopeCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_PSD_RED_PACKAGE_MODULE, gCmd.REQ_PSD_RED_PACKAGE_INIT, handler(self, self.sendReqInfoInitRsp))
	msgCtrl.register(gCmd.CMD_PSD_RED_PACKAGE_MODULE, gCmd.REQ_PSD_RED_PACKAGE_INPUT, handler(self, self.sendReqInfoInputRsp))
	msgCtrl.register(gCmd.CMD_PSD_RED_PACKAGE_MODULE, gCmd.REQ_PSD_RED_PACKAGE_RANK, handler(self, self.sendReqInfoRankRsp))
	msgCtrl.register(gCmd.CMD_PSD_RED_PACKAGE_MODULE, gCmd.REQ_PSD_RED_PACKAGE_HISTORY, handler(self, self.sendReqInfoHistoryRsp))
	self:resetData()
	self:registerNotify()
end
function redEnvelopeCtrl:resetData()
	self.totalGold = 0
	self.groupStatus = 1
	self.isActivityOpen = 1
	self.leftRedPackageCount = 0
	self.isAlreadyReceive = false
	self.beginstamp = 0
	self.endstamp = 0
	self.clientInput = nil
end
function redEnvelopeCtrl:Logout()
	self:resetData()
	redEnvelopeCtrl.super.Logout(self)
end
function redEnvelopeCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.PSD_RED_PACKAGE, handler(self, self.notifyHandler))
end
function redEnvelopeCtrl:notifyHandler(content)
	local data = content.data[1]
	data = data.psdRedPackageClientInfo
	self.groupStatus = data.groupStatus
	self.isActivityOpen = data.isActivityOpen
	self.leftRedPackageCount = data.leftRedPackageCount
	self.isAlreadyReceive = data.isAlreadyReceive
	self.beginstamp = data.beginstamp or 0
	self.endstamp = data.endstamp or 0
	if not self.isActivityOpen then
		self.clientInput = nil
	end
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_REDENVELOPE_UPDATE"
	SoraDSendMessage(nil)
end
function redEnvelopeCtrl:sendReqInitInfo()
	serverproxy:Request(gCmd.CMD_PSD_RED_PACKAGE_MODULE, gCmd.REQ_PSD_RED_PACKAGE_INIT)
end
function redEnvelopeCtrl:sendReqInput(data)
	serverproxy:Request(gCmd.CMD_PSD_RED_PACKAGE_MODULE, gCmd.REQ_PSD_RED_PACKAGE_INPUT, data)
end
function redEnvelopeCtrl:sendReqInfoRank(data)
	serverproxy:Request(gCmd.CMD_PSD_RED_PACKAGE_MODULE, gCmd.REQ_PSD_RED_PACKAGE_RANK, data)
end
function redEnvelopeCtrl:sendReqInfoHistory(data)
	serverproxy:Request(gCmd.CMD_PSD_RED_PACKAGE_MODULE, gCmd.REQ_PSD_RED_PACKAGE_HISTORY, data)
end
function redEnvelopeCtrl:getGroupStatu()
	return tonumber(self.groupStatus)
end
function redEnvelopeCtrl:getLeftTime()
	if self.groupStatus == gActivityState.PREPARE then
		return self.beginstamp - serviceFunctions.systemTime()
	elseif self.groupStatus == gActivityState.OPEN then
		return self.endstamp - serviceFunctions.systemTime()
	end
end
function redEnvelopeCtrl:alreadyReceive()
	return self.isAlreadyReceive or false
end
function redEnvelopeCtrl:getLeftEnvelope()
	return self.leftRedPackageCount or 0
end
function redEnvelopeCtrl:getTotalGold(...)
	return self.totalGold or 0
end
function redEnvelopeCtrl:getIsOPen(...)
	return self.isActivityOpen
end
function redEnvelopeCtrl:getLastInput(...)
	return self.clientInput
end
function redEnvelopeCtrl:setLastInput(psd)
	self.clientInput = psd
end
function redEnvelopeCtrl:sendReqInfoInitRsp(content)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self.groupStatus = data.groupStatus
		self.isActivityOpen = data.isActivityOpen
		self.leftRedPackageCount = data.leftRedPackageCount
		self.isAlreadyReceive = data.isAlreadyReceive
		self.beginstamp = data.beginstamp
		self.endstamp = data.endstamp
		self.totalGold = data.totalGold
		if not self.isActivityOpen then
			self.clientInput = nil
		end
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_REDENVELOPE_UPDATE"
		SoraDSendMessage(nil)
	end
end
function redEnvelopeCtrl:sendReqInfoInputRsp(content)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self.totalGold = data.gold + self.totalGold
		self.groupStatus = data.groupStatus
		self.isActivityOpen = data.isActivityOpen
		self.leftRedPackageCount = data.leftRedPackageCount
		self.isAlreadyReceive = data.isAlreadyReceive
		self.beginstamp = data.beginstamp
		self.endstamp = data.endstamp
		_ENV = nil
		;(nil).num = data.gold
		SoraDShowMsgTip(i18n("rebag_text_11", nil))
		_ENV = i18n("rebag_text_11", nil)
		i18n("rebag_text_11", nil).msg = "MESSAGE_SERVER_REDENVELOPE_UPDATE"
		SoraDSendMessage(i18n("rebag_text_11", nil))
	elseif gErrDef.Err_PSD_RED_PACKAGE_NOT_OPEN == content.err then
		SoraDShowMsgTip(i18n("rebag_text_05"))
	elseif gErrDef.Err_PSD_RED_PACKAGE_ERROR_PSD == content.err then
		SoraDShowMsgTip(i18n("rebag_text_07"))
	elseif gErrDef.Err_PSD_RED_PACKAGE_ALREADY_RECEIVE == content.err then
		SoraDShowMsgTip(i18n("rebag_text_08"))
	elseif gErrDef.Err_PSD_RED_PACKAGE_RECEIVE_END == content.err then
		SoraDShowMsgTip(i18n("rebag_text_06"))
	end
end
function redEnvelopeCtrl:sendReqInfoRankRsp(content)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_REDENVELOPE_GETINFO"
		;(nil).data = data.retInfo
		;(nil).bCanContinueGet = data.bCanContinueGet
		SoraDSendMessage(nil)
	end
end
function redEnvelopeCtrl:sendReqInfoHistoryRsp(content)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_REDENVELOPE_GETINFO"
		;(nil).data = data.retInfo
		;(nil).bCanContinueGet = data.bCanContinueGet
		SoraDSendMessage(nil)
	end
end
return redEnvelopeCtrl
