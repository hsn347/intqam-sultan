local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local pickLightCtrl = class("pickLightCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
function pickLightCtrl:ctor(properties)
	pickLightCtrl.super.ctor(self, properties)
	self.dataTable, pickLightCtrl = pickLightCtrl.super.ctor, pickLightCtrl.super.ctor
end
function pickLightCtrl:getPickLightData()
	return self.dataTable
end
function pickLightCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_PICKLIGHT_MODULE, gCmd.REQ_PICKLIGHT_REWARD, handler(self, self.getRewardRsp))
end
function pickLightCtrl:sendReward(mID)
	if 0 ~= mID then
		_ENV = nil
		;(nil).cmd = gCmd.CMD_PICKLIGHT_MODULE
		_ENV, (nil).subcmd = gCmd.REQ_PICKLIGHT_REWARD, gCmd.REQ_PICKLIGHT_REWARD
		;(nil).data, gCmd.REQ_PICKLIGHT_REWARD.id = gCmd.REQ_PICKLIGHT_REWARD, mID
		local msg
		serverproxy:SendMsg(msg)
	end
end
function pickLightCtrl:resetData()
	self.dataTable, _UPVALUE0_ = nil, nil
end
function pickLightCtrl:Logout()
	pickLightCtrl.super.Logout(self)
	self:resetData()
end
function pickLightCtrl:getRewardRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
		_ENV = content.err
		_ENV, content.err.msg = nil, "MESSAGE_SERVER_EVENTCENTER_STARLAMP_REFRESH"
		;(nil).id = content.data.id
		content.err.redata, (nil).reward = nil, content.result
		SoraDSendMessage(content.err)
	else
		_ENV = content.err
		content.err.msg = "MESSAGE_SERVER_EVENTCENTER_STARLAMP_REFRESH"
		content.err.err = content.err
		SoraDSendMessage(content.err)
	end
end
return pickLightCtrl
