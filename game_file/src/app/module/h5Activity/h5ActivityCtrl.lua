local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local h5ActivityCtrl = class("h5ActivityCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function h5ActivityCtrl:ctor(properties)
	h5ActivityCtrl.super.ctor(self, properties)
	self:resetData()
end
function h5ActivityCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_H5_ACTIVITY_MODULE, gCmd.H5_ACTIVITY_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_H5_ACTIVITY_MODULE, gCmd.H5_ACTIVITY_OPEN_PAGE, handler(self, self.reqOpenPageRsp))
	msgCtrl.register(gCmd.CMD_H5_ACTIVITY_MODULE, gCmd.H5_ACTIVITY_RECEIVE_REWARD, handler(self, self.reqReceiveRewardRsp))
	msgCtrl.register(gCmd.CMD_H5_ACTIVITY_MODULE, gCmd.H5_ACTIVITY_CLEAR_NEW, handler(self, self.reqClearNewRsp))
	msgCtrl.register(gCmd.CMD_H5_ACTIVITY_MODULE, gCmd.H5_ACTIVITY_CLEAR_MARK, handler(self, self.reqClearMarkRsp))
end
function h5ActivityCtrl:Logout()
	h5ActivityCtrl.super.Logout(self)
	self:resetData()
end
function h5ActivityCtrl:resetData()
	self.communityData, _UPVALUE0_, self.h5ActivityData, _UPVALUE0_ = nil, nil, nil, nil
end
function h5ActivityCtrl:initClientData(data)
	if not data then
		return
	end
	dump(data, "==h5ActivityCtrl:initClientData==")
	self:setData(data)
	if data.communityCenterData then
		self.communityData = data.communityCenterData
	end
end
function h5ActivityCtrl:setData(data)
	if not data then
		return
	end
	self.h5ActivityData = data
end
function h5ActivityCtrl:reqInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_H5_ACTIVITY_MODULE, gCmd.H5_ACTIVITY_INIT, nil)
end
function h5ActivityCtrl:reqOpenPage(activityID)
	if self:checkOpenPage(activityID) then
		return
	end
	serverproxy = nil
	;(nil).activityID = activityID
	serverproxy:Request(gCmd.CMD_H5_ACTIVITY_MODULE, gCmd.H5_ACTIVITY_OPEN_PAGE, nil)
end
function h5ActivityCtrl:reqReceiveReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_H5_ACTIVITY_MODULE, gCmd.H5_ACTIVITY_RECEIVE_REWARD, nil)
end
function h5ActivityCtrl:reqClearNew(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_H5_ACTIVITY_MODULE, gCmd.H5_ACTIVITY_CLEAR_NEW, nil)
end
function h5ActivityCtrl:reqClearMark(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_H5_ACTIVITY_MODULE, gCmd.H5_ACTIVITY_CLEAR_MARK, nil)
end
function h5ActivityCtrl:reqInitRsp(content)
	dump(content, "h5ActivityCtrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.h5ActivityData)
		self.communityData = content.rspdata.h5ActivityData.communityCenterData
		_ENV = self
		self.msg = "MESSAGE_H5ACTIVITY_REFRESH"
		SoraDSendMessage(self)
	end
end
function h5ActivityCtrl:reqOpenPageRsp(content)
	dump(content, "h5ActivityCtrl:reqOpenPageRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.h5ActivityData)
		_ENV = self
		self.msg = "MESSAGE_H5ACTIVITY_REFRESH"
		SoraDSendMessage(self)
	end
end
function h5ActivityCtrl:reqReceiveRewardRsp(content)
	dump(content, "h5ActivityCtrl:reqReceiveRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.h5ActivityData)
		_ENV = self
		self.msg = "MESSAGE_H5ACTIVITY_REFRESH"
		SoraDSendMessage(self)
		local reward = content.rspdata.reward
		SoraDMailGainItems(reward, true)
	end
end
function h5ActivityCtrl:reqClearNewRsp(content)
	dump(content, "h5ActivityCtrl:reqClearNewRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.communityData = content.rspdata.h5ActivityData.communityCenterData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_H5ACTIVITY_NEW_CLEAR_REFRESH"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function h5ActivityCtrl:reqClearMarkRsp(content)
	dump(content, "h5ActivityCtrl:reqClearMarkRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.communityData = content.rspdata.h5ActivityData.communityCenterData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_H5ACTIVITY_MARK_CLEAR_REFRESH"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function h5ActivityCtrl:checkOpenPage(activityID)
	if activityID then
		return self.h5ActivityData.checkInfo[tostring(activityID)]
	end
end
function h5ActivityCtrl:checkCanReceive(...)
	return self.h5ActivityData.isCanReceive
end
function h5ActivityCtrl:checkAlreadyReceive(...)
	return self.h5ActivityData.isAlreadyReceive
end
function h5ActivityCtrl:checkCanPlayVideo(...)
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ANNIVERSARY_CG_ACTIVITY_ROS) then
		return true
	end
	return false
end
function h5ActivityCtrl:getReceiveStatusAndNum(activityID)
	if self:checkCanReceive() and not self:checkAlreadyReceive() then
		return true, -1
	end
	return false, 0
end
function h5ActivityCtrl:getRewards(...)
	if not self.rewards then
		local activity_h5_reward = require_data("activity_h5_reward", true).data
		for k, v in pairs(activity_h5_reward) do
			if v.type == 9 then
				_UPVALUE2_ = nil
				;(nil)[1] = "id"
				;(nil)[2] = "count"
				self.rewards = serviceFunctions.tableFormat(v.reward, nil)
				break
			end
		end
	end
	if not self.rewards then
		_ENV = self.rewards
	end
	return self.rewards
end
function h5ActivityCtrl:getCommunityCenterData()
	return self.communityData
end
return h5ActivityCtrl
