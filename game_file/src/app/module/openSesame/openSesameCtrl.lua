local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local openSesameCtrl = class("openSesameCtrl", GameModule)
local newLotteryRead = include("newLotteryRead")
function openSesameCtrl:ctor(properties)
	openSesameCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.LOTTERY_ACTIVITY_9001546
	self.itemID = newLotteryRead.getCostItemIDByActivityID(self.activityID)
end
function openSesameCtrl:EnterGame()
	print("openSesameCtrl:EnterGame")
	msgCtrl.register(gCmd.CMD_COMMON_LOTTERY_9001546_MODULE, gCmd.CMD_COMMON_LOTTERY_9001546_INIT, handler(self, self.sendReqInitRsp))
	msgCtrl.register(gCmd.CMD_COMMON_LOTTERY_9001546_MODULE, gCmd.CMD_COMMON_LOTTERY_9001546_LOTTERY, handler(self, self.sendLotteryRsp))
	self:resetData()
end
function openSesameCtrl:onLoginFinish()
	if clientEventMgr.judgeIsOpen(self.activityID) then
		self:sendReqInitDataMsg()
	end
end
function openSesameCtrl:initClientData(data)
	dump(data, "openSesameCtrl:initClientData", 10)
	if data then
		self:setData(data)
	end
end
function openSesameCtrl:Logout()
	self:resetData()
	openSesameCtrl.super.Logout(self)
end
function openSesameCtrl:resetData()
	self.isFree = false
end
function openSesameCtrl:setData(data)
	self.isFree = data.isFree == 1
end
function openSesameCtrl:sendReqInitDataMsg()
	print("openSesameCtrl:sendReqInitDataMsg")
	serverproxy:Request(gCmd.CMD_COMMON_LOTTERY_9001546_MODULE, gCmd.CMD_COMMON_LOTTERY_9001546_INIT)
end
function openSesameCtrl:sendLottery(count)
	SoraDShowLoading()
	_ENV = nil
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_COMMON_LOTTERY_9001546_MODULE, gCmd.CMD_COMMON_LOTTERY_9001546_LOTTERY, nil)
end
function openSesameCtrl:sendReqInitRsp(content)
	dump(content, "openSesameCtrl:sendReqInfoRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_LOTTERY_9001546"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = self.activityID
		SoraDSendMessage(self)
		return
	end
end
function openSesameCtrl:sendLotteryRsp(content)
	SoraDCloseLoading()
	dump(content, "==sendLotteryRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(content.rspdata.initData)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = self.activityID
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_LOTTERY_9001546"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_LOTTERY_9001546_REWARD"
		self.rewards = data.rewards
		SoraDSendMessage(self)
		return
	end
end
function openSesameCtrl:getItemID()
	return self.itemID
end
function openSesameCtrl:getIsFree()
	return self.isFree
end
function openSesameCtrl:getPreRewards()
	return newLotteryRead.getPreAwardByActivityID(self.activityID, self:getGroup())[1].reward
end
function openSesameCtrl:getGroup()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(self.activityID)
	local _classtype = param.classtype and param.classtype or 1
	return _classtype
end
function openSesameCtrl:getReceiveStatusAndNum()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local num = backpackCtrl:getItemCount(self.itemID)
	return 0 < num or self.isFree, -1
end
return openSesameCtrl
