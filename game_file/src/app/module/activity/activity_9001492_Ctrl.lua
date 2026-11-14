local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001492_Ctrl = class("activity_9001492_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001492_Ctrl:ctor(properties)
	activity_9001492_Ctrl.super.ctor(self, properties)
	self:resetData()
end
function activity_9001492_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_STAR_LIGHT_LAMP_MODULE, gCmd.REQ_STAR_LIGHT_LAMP_DATA, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_STAR_LIGHT_LAMP_MODULE, gCmd.REQ_STAR_LIGHT_LAMP_REWARD, handler(self, self.reqRewardRsp))
end
function activity_9001492_Ctrl:Logout()
	activity_9001492_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001492_Ctrl:resetData()
	_UPVALUE0_ = nil
	;(nil).bClaim = false
	self.initData, (nil).classType = nil, 1
end
function activity_9001492_Ctrl:initClientData(data)
	if not data then
		return
	end
	dump(data, "==activity_9001492_Ctrl:initClientData==")
	self.initData = data
end
function activity_9001492_Ctrl:sendReqInitDataMsg()
	self:reqInit()
end
function activity_9001492_Ctrl:reqInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_STAR_LIGHT_LAMP_MODULE, gCmd.REQ_STAR_LIGHT_LAMP_DATA, nil)
end
function activity_9001492_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001492_Ctrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata
	end
end
function activity_9001492_Ctrl:reqReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_STAR_LIGHT_LAMP_MODULE, gCmd.REQ_STAR_LIGHT_LAMP_REWARD, nil)
end
function activity_9001492_Ctrl:reqRewardRsp(content)
	dump(content, "activity_9001492_Ctrl:reqRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local reward = content.rspdata.reward
		SoraDMailGainItems(reward, true)
		self.initData.bClaim = true
		_ENV = reward
		reward.msg = "MESSAGE_ACTIVITY_9001492_UPDATE"
		SoraDSendMessage(reward)
	end
end
function activity_9001492_Ctrl:getClassType(...)
	return self.initData.classType
end
function activity_9001492_Ctrl:getHasReceived(...)
	return self.initData.bClaim
end
function activity_9001492_Ctrl:getReceiveStatusAndNum(...)
	if self:getHasReceived() then
		return false
	else
		return true, -1
	end
end
return activity_9001492_Ctrl
