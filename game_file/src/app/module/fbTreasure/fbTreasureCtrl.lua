local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local fbTreasureCtrl = class("fbTreasureCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
function fbTreasureCtrl:ctor(properties)
	fbTreasureCtrl.super.ctor(self, properties)
	self.dataTable, fbTreasureCtrl = fbTreasureCtrl.super.ctor, fbTreasureCtrl.super.ctor
end
function fbTreasureCtrl:getData()
	return self.dataTable
end
function fbTreasureCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_FACEBOOK_TREASURE, gCmd.REQ_GET_REWARD, handler(self, self.getRewardRsp))
	msgCtrl.register(gCmd.CMD_FACEBOOK_TREASURE, gCmd.REQ_SEND_HELP, handler(self, self.getHelpRsp))
	msgCtrl.register(gCmd.CMD_FACEBOOK_TREASURE, gCmd.REQ_LOAD_PAGE, handler(self, self.getOpenPageRsp))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.FACEBOOK_TREASURE, handler(self, self.notifyFBTreasureData))
end
function fbTreasureCtrl:sendGetReward()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_FACEBOOK_TREASURE
	local (nil).subcmd, msg = gCmd.REQ_GET_REWARD, nil
	serverproxy:SendMsg(msg)
end
function fbTreasureCtrl:sendHelp(helpedUID, helpedKID)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_FACEBOOK_TREASURE
	_ENV, (nil).subcmd = gCmd.REQ_SEND_HELP, gCmd.REQ_SEND_HELP
	gCmd.REQ_SEND_HELP.helpedUID = helpedUID
	;(nil).data, gCmd.REQ_SEND_HELP.helpedKID = gCmd.REQ_SEND_HELP, helpedKID
	local msg
	serverproxy:SendMsg(msg)
end
function fbTreasureCtrl:sendOpenPage()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_FACEBOOK_TREASURE
	local (nil).subcmd, msg = gCmd.REQ_LOAD_PAGE, nil
	serverproxy:SendMsg(msg)
	print("====================fbTreasureCtrl:sendOpenPage=====")
end
function fbTreasureCtrl:resetData()
	self.dataTable, _UPVALUE0_ = nil, nil
end
function fbTreasureCtrl:Logout()
	fbTreasureCtrl.super.Logout(self)
	self:resetData()
end
function fbTreasureCtrl:notifyFBTreasureData(response)
	local content = response.data[1]
	if content then
		self.dataTable = content
		_ENV = nil
		;(nil).msg = "MESSAGE_FACEBOOK_FLAGBACK_REFRESHVIEWDATA"
		;(nil).retdate = content
		SoraDSendMessage(nil)
	else
	end
end
function fbTreasureCtrl:getRewardRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
		local rewards = content.rewards
		_ENV = nil
		;(nil).msg = "MESSAGE_FACEBOOK_FLAGBACK_REFRESHVIEWDATA"
		;(nil).retdate = content.result
		;(nil).getReward = rewards
		SoraDSendMessage(nil)
	else
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_FACEBOOK_FLAGBACK_TREASUREERROR"
		SoraDSendMessage.err = content.err
		SoraDSendMessage(SoraDSendMessage)
	end
end
function fbTreasureCtrl:getHelpRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
		_ENV = content.err
		content.err.msg = "MESSAGE_FACEBOOK_FLAGBACK_REFRESHVIEWDATA"
		content.err.retdate = content.result
		SoraDSendMessage(content.err)
		SoraDShowMsgTip(i18n("common_text_2256"))
	else
		_ENV = i18n("common_text_2256")
		i18n("common_text_2256").msg = "MESSAGE_FACEBOOK_FLAGBACK_TREASUREERROR"
		i18n("common_text_2256").err = content.err
		SoraDSendMessage(i18n("common_text_2256"))
	end
end
function fbTreasureCtrl:getOpenPageRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
		_ENV = content.err
		content.err.msg = "MESSAGE_FACEBOOK_FLAGBACK_OPENVIEWDATA"
		content.err.retdate = content.result
		SoraDSendMessage(content.err)
	else
		_ENV = content.err
		content.err.msg = "MESSAGE_FACEBOOK_FLAGBACK_TREASUREERROR"
		content.err.err = content.err
		SoraDSendMessage(content.err)
	end
end
return fbTreasureCtrl
