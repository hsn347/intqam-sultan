local GameModule = include("GameModule")
local activationCodeCtrl = class("activationCodeCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function activationCodeCtrl:ctor(properties)
	activationCodeCtrl.super.ctor(self, properties)
end
function activationCodeCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ACTIVATION_MODULE, gCmd.REQ_ACTIVATION_RECEIVE, handler(self, self.getReceiveReward))
	self:initData()
end
function activationCodeCtrl:initData()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
end
function activationCodeCtrl:resetData()
end
function activationCodeCtrl:Logout()
	activationCodeCtrl.super.Logout(self)
end
function activationCodeCtrl:getReceiveReward(content)
	dump(content, "activationCodeCtrl:getReceiveReward", 10)
	if gErrDef.Err_None == content.err then
		SoraDShowMsgTip(i18n("common_text_1244"))
		_ENV = i18n("common_text_1244")
		i18n("common_text_1244").msg = "MESSAGE_SERVER_OPTION_ACTIVECODESUCCESS"
		SoraDSendMessage(i18n("common_text_1244"))
	else
		SoraDShowMsgTip(content.err)
	end
end
function activationCodeCtrl:sendReceiveReward(code)
	local serverproxy, data
	data.code = code
	serverproxy:Request(gCmd.CMD_ACTIVATION_MODULE, gCmd.REQ_ACTIVATION_RECEIVE, data)
end
return activationCodeCtrl
