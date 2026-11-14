local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001656_Ctrl = class("activity_9001656_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001656_Ctrl:ctor(properties)
	activity_9001656_Ctrl.super.ctor(self, properties)
	self:resetData()
	self.activityID = gActivityTimeActivityID.PREPARE_FOR_WAR_ACTIVITY
end
function activity_9001656_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_PREPARE_FOR_WAR_MODULE, gCmd.REQ_PREPARE_FOR_WAR_INIT, handler(self, self.reqInitDataRsp))
	msgCtrl.register(gCmd.CMD_PREPARE_FOR_WAR_MODULE, gCmd.REQ_PREPARE_FOR_WAR_BUY_GIFT, handler(self, self.reqBuyGiftRsp))
	msgCtrl.register(gCmd.CMD_PREPARE_FOR_WAR_MODULE, gCmd.REQ_PREPARE_FOR_WAR_QUEST_REWARD, handler(self, self.reqRewardRsp))
	msgCtrl.register(gCmd.CMD_PREPARE_FOR_WAR_MODULE, gCmd.REQ_PREPARE_FOR_WAR_STAGE_REWARD, handler(self, self.reqStageRewardRsp))
	self:registerNotify()
end
function activity_9001656_Ctrl:Logout()
	activity_9001656_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001656_Ctrl:resetData()
	self.allianceData, _UPVALUE0_, self.data, _UPVALUE0_ = nil, nil, nil, nil
	self.allianceData.tasks, _UPVALUE0_ = nil, nil
	self.questComponent = nil
	self.doStage = 0
end
function activity_9001656_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.PREPARE_FOR_WAR, handler(self, self.notifyHandler))
end
function activity_9001656_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001656_Ctrl:notifyHandler", 10)
	for _, v in pairs(event.data) do
		local notifyType = v.notifyType
		local notifyData = v.notifyData
		if notifyType == "refreshData" then
			self:updateClientData(notifyData)
		elseif notifyType == "buyGift" then
			if notifyData.success then
				paymentManager.loopForFinishTransaction()
				local reward = notifyData.reward
				local rid = notifyData.rid
				local mailID = notifyData.mailID
				_ENV = nil
				;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
				;(nil).eventID = self.activityID
				SoraDSendMessage(nil)
				_ENV = nil
				_UPVALUE1_, (nil).msg = self.activityID, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
				self.activityID.result = true
				self.activityID.itemList = reward
				;(nil).data, self.activityID[1] = self.activityID, mailID
				SoraDSendMessage(nil)
			end
			self:updateClientData(notifyData.initData)
		end
	end
end
function activity_9001656_Ctrl:initClientData(data)
	dump(data, "activity_9001656_Ctrl:initClientData")
	if data ~= nil then
		self:updateClientData(data, true)
	end
end
function activity_9001656_Ctrl:updateClientData(data, isInit)
