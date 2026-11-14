local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local bubbleActivityCtrl = class("bubbleActivityCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function bubbleActivityCtrl:ctor(properties)
	bubbleActivityCtrl.super.ctor(self, properties)
	self:resetData()
end
function bubbleActivityCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_BUBBLE_REWARD_MODULE, gCmd.REQ_BUBBLE_REWARD_INIT, handler(self, self.reqBubbleRewardInitRsp))
	msgCtrl.register(gCmd.CMD_BUBBLE_REWARD_MODULE, gCmd.REQ_BUBBLE_REWARD_RECEIVE, handler(self, self.reqBubbleRewardReceiveRsp))
	self:registerNotify()
	self:reqBubbleRewardInit()
end
function bubbleActivityCtrl:Logout()
	bubbleActivityCtrl.super.Logout(self)
	self:resetData()
end
function bubbleActivityCtrl:resetData()
	self.bubbleRewardData, _UPVALUE0_ = nil, nil
end
function bubbleActivityCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.BUBBLE_REWARD, handler(self, self.notifyHandler))
end
function bubbleActivityCtrl:notifyHandler(event)
	for k, v in ipairs(event.data) do
		self.bubbleRewardData = v.bubbleRewardData
		_ENV = nil
		;(nil).msg = "MESSAGE_BUBBLE_ACTIVITY_REFRESH"
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		SoraDSendMessage(nil)
	end
end
function bubbleActivityCtrl:reqBubbleRewardInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_BUBBLE_REWARD_MODULE, gCmd.REQ_BUBBLE_REWARD_INIT, nil)
end
function bubbleActivityCtrl:reqBubbleRewardReceive()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_BUBBLE_REWARD_MODULE, gCmd.REQ_BUBBLE_REWARD_RECEIVE, nil)
end
function bubbleActivityCtrl:reqBubbleRewardInitRsp(content)
	if content.err == gErrDef.Err_None then
		self.bubbleRewardData = content.rspdata.bubbleRewardData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_BUBBLE_ACTIVITY_REFRESH"
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function bubbleActivityCtrl:reqBubbleRewardReceiveRsp(content)
	if content.err == gErrDef.Err_None then
		self.bubbleRewardData = content.rspdata.bubbleRewardData
		SoraDMailGainItems(self.bubbleRewardData.reward, true)
		_ENV = self.bubbleRewardData.reward
		self.bubbleRewardData.reward.msg = "MESSAGE_BUBBLE_ACTIVITY_REFRESH"
		SoraDSendMessage(self.bubbleRewardData.reward)
		_ENV = self.bubbleRewardData.reward
		self.bubbleRewardData.reward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		SoraDSendMessage(self.bubbleRewardData.reward)
	end
end
function bubbleActivityCtrl:getSkinIndex()
	return self.bubbleRewardData.classtype
end
function bubbleActivityCtrl:isCanReceive()
	return self.bubbleRewardData.isCanReceive
end
function bubbleActivityCtrl:getRewardList()
	return self.bubbleRewardData.reward
end
function bubbleActivityCtrl:getReceiveStatusAndNum(activityID)
	return self.bubbleRewardData.isCanReceive, 1
end
return bubbleActivityCtrl
