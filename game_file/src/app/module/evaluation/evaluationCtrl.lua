local GameModule = include("GameModule")
local evaluationCtrl = class("evaluationCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function evaluationCtrl:ctor(properties)
	evaluationCtrl.super.ctor(self, properties)
end
function evaluationCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_EVALUATION_OF_STARS_MODULE, gCmd.REQ_GET_EVALUATION_INIT, handler(self, self.getInitResp))
	msgCtrl.register(gCmd.CMD_EVALUATION_OF_STARS_MODULE, gCmd.REQ_SEND_STARS_TYPE, handler(self, self.getSendStarsResp))
	msgCtrl = gCmd.REQ_SEND_STARS_TYPE
	gCmd.REQ_SEND_STARS_TYPE.name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(gCmd.REQ_SEND_STARS_TYPE)
	self:resetData()
end
function evaluationCtrl:initClientData(data)
	if not data then
		return
	end
	self.isAutoPop = data.isAutoPop
	self.isForcePop = data.isForcePop
	self:registerNotify()
end
function evaluationCtrl:resetData()
	self.isAutoPop = nil
	self.isForcePop = nil
	self.handle_notify = nil
end
function evaluationCtrl:Logout()
	self:resetData()
	evaluationCtrl.super.Logout(self)
end
function evaluationCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.EVALUATION_OF_STARS, handler(self, self.notifyHandler))
end
function evaluationCtrl:notifyHandler(event)
	local content = event.data[1]
	if content then
		self.isAutoPop = content.isAutoPop
		_ENV = nil
		;(nil).msg = "MESSAGE_EVALUATION_NOTIFY"
		;(nil).redata = true
		SoraDSendMessage(nil)
	end
end
function evaluationCtrl:getInitResp(ret)
end
function evaluationCtrl:getSendStarsResp(content)
	if content and content.data then
		self.isAutoPop = false
		self.isForcePop = false
		local nType = content.data.nType
		if nType == gEvaluationOfStars.NOT_GREATE then
		elseif nType == gEvaluationOfStars.VERY_GREATE then
		elseif nType == gEvaluationOfStars.DIREDCT_CLOSE then
		end
	end
end
function evaluationCtrl:sendInitMsg()
end
function evaluationCtrl:sendStarsType(nType)
	local serverproxy, data
	data.nType = nType
	serverproxy:Request(gCmd.CMD_EVALUATION_OF_STARS_MODULE, gCmd.REQ_SEND_STARS_TYPE, data)
end
function evaluationCtrl:getIsPopFrame()
	if self.isAutoPop == true then
		return true
	end
	if self.isForcePop == true then
		return true
	end
	return false
end
return evaluationCtrl
