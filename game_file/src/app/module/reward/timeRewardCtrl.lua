local GameModule = include("GameModule")
local timeRewardCtrl = class("timeRewardCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local timeRewardAuxiliary = include("timeRewardAuxiliary")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local cityBuildConstDef = include("cityBuildConstDef")
function timeRewardCtrl:ctor(properties)
	timeRewardCtrl.super.ctor(self, properties)
	self:resetData()
end
function timeRewardCtrl:resetData()
	self.timeRewardAuxiliary = nil
	self.timeRewardAuxiliary = timeRewardAuxiliary.new()
end
function timeRewardCtrl:Logout()
	timeRewardCtrl.super.Logout(self)
	self.handle_reward_notify = nil
	self.handle_time_reward_notify = nil
	self:resetData()
end
function timeRewardCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_TIME_REWARD_MODULE, gCmd.REQ_RECEIVE_TIME_REWARD, handler(self, self.getReceiveRewardRsp))
end
function timeRewardCtrl:updateReward()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_reward_notify = notifyCtrl:register(gNotifyID.REWARD, handler(self, self.notifyRewardData))
	self.handle_time_reward_notify = notifyCtrl:register(gNotifyID.TIME_REWARD, handler(self, self.notifyResetRewardData))
end
function timeRewardCtrl:notifyRewardData(respone)
	if respone and respone.data and respone.data[1] then
		local timeData = respone.data[1].timeData
		if timeData then
			self.timeRewardData = self.timeRewardAuxiliary:handleData(timeData)
			_ENV = self.timeRewardAuxiliary
			self.timeRewardAuxiliary.msg = "MESSAGE_TIME_RECEIVEREWARD_CANRECEIVE"
			self.timeRewardAuxiliary.queueType = gQueueTypeDef.time_reward
			SoraDSendMessage(self.timeRewardAuxiliary)
			return
		end
	end
	self.timeRewardData.isReceive = 2
	_ENV = SoraDSendMessage
	SoraDSendMessage.msg = "MESSAGE_TIME_RECEIVEREWARD_CANRECEIVE"
	SoraDSendMessage(SoraDSendMessage)
	_ENV = SoraDSendMessage
	SoraDSendMessage.msg = "MESSAGE_UI_PANDECT_GOODS"
	SoraDSendMessage.queueType = gQueueTypeDef.time_reward
	SoraDSendMessage(SoraDSendMessage)
end
function timeRewardCtrl:notifyResetRewardData(respone)
	self.timeRewardData.isReceive = 1
	self.timeRewardData.sequence = 1
	self.timeRewardData.isAllReceive = 0
	self.timeRewardData.reward = respone.data[1].data.reward
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local timereward = include("timereward")
	queueCtrl:removeQueue(gQueueTypeDef.time_reward)
	local time = timereward[1].time
	gametop = nil
	queueCtrl:addQueue(gQueueTypeDef.time_reward, serviceFunctions.systemTime(), time, time, nil)
	gametop = queueCtrl
	queueCtrl.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
	queueCtrl.buildIndex = cityBuildConstDef.OtherBuildDef.Gangkou
	SoraDSendMessage(queueCtrl)
	gametop = queueCtrl
	queueCtrl.msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_EFFECT"
	queueCtrl.buildIndex = cityBuildConstDef.OtherBuildDef.Gangkou
	SoraDSendMessage(queueCtrl)
	gametop = queueCtrl
	queueCtrl.msg = "MESSAGE_MAINCITYVIEW_ADD_MATOU_TIP"
	SoraDSendMessage(queueCtrl)
	gametop = queueCtrl
	queueCtrl.msg = "MESSAGE_TIME_RECEIVEREWARD_REFRESH"
	queueCtrl.queueType = gQueueTypeDef.time_reward
	SoraDSendMessage(queueCtrl)
	gametop = queueCtrl
	queueCtrl.msg = "MESSAGE_UI_PANDECT_GOODS"
	queueCtrl.queueType = gQueueTypeDef.time_reward
	SoraDSendMessage(queueCtrl)
end
function timeRewardCtrl:getReceiveRewardRsp(content)
	local err = content.err
	local data = content.data.data
	self.timeRewardData.err = err
	if err == gErrDef.Err_None and data.isReceive == 1 then
		self.timeRewardData = self.timeRewardAuxiliary:handleData(content.data)
		self.timeRewardData.isReceive = data.isReceive
		self.timeRewardData.reward = data.reward
		self.timeRewardData.sequence = data.sequence
		local queueCtrl = gametop.playertop_:getModule("queueCtrl")
		local timereward = include("timereward")
		local time = timereward[data.sequence].time
		_ENV = nil
		queueCtrl:addQueue(gQueueTypeDef.time_reward, data.receiveTime, time, time, nil)
		_ENV = queueCtrl
		queueCtrl.msg = "MESSAGE_TIME_RECEIVEREWARD_SUCCESS"
		queueCtrl.err = err
		queueCtrl.data = self.timeRewardData
		SoraDSendMessage(queueCtrl)
	elseif err == gErrDef.Err_BACKPACK_IS_FULL then
		SoraDShowMsgTip(i18n("notice_0119"))
	elseif err == gErrDef.Err_ALL_RECEIVED_TODAY then
		_ENV = i18n("notice_0119")
		i18n("notice_0119").msg = "MESSAGE_MAINCITYVIEW_DELETE_MATOU_TIP"
		SoraDSendMessage(i18n("notice_0119"))
		_ENV = i18n("notice_0119")
		i18n("notice_0119").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_EFFECT"
		i18n("notice_0119").buildIndex = cityBuildConstDef.OtherBuildDef.Gangkou
		SoraDSendMessage(i18n("notice_0119"))
		_ENV = i18n("notice_0119")
		i18n("notice_0119").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
		i18n("notice_0119").buildIndex = cityBuildConstDef.OtherBuildDef.Gangkou
		SoraDSendMessage(i18n("notice_0119"))
		_ENV = i18n("notice_0119")
		i18n("notice_0119").msg = "MESSAGE_TIME_RECEIVEREWARD_REFRESH"
		i18n("notice_0119").queueType = gQueueTypeDef.time_reward
		SoraDSendMessage(i18n("notice_0119"))
	end
end
function timeRewardCtrl:getTimeRewardData()
	if self.timeRewardData then
		return self.timeRewardData
	end
end
function timeRewardCtrl:receiveReward(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_TIME_REWARD_MODULE, gCmd.REQ_RECEIVE_TIME_REWARD, nil, ...)
end
function timeRewardCtrl:initClientData(data)
	self.timeRewardData = self.timeRewardAuxiliary:handleData(data)
	self:updateReward()
end
return timeRewardCtrl
