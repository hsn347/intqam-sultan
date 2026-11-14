local wiseTutorRead = include("wiseTutorRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001624_Ctrl = class("activity_9001624_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001624_Ctrl:ctor(properties)
	activity_9001624_Ctrl.super.ctor(self, properties)
	self:resetData()
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001624
end
function activity_9001624_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_END_OF_RAMADAN_MARKET_MODULE, gCmd.REQ_END_OF_RAMADAN_MARKET_INIT, handler(self, self.reqInitDataRsp))
	msgCtrl.register(gCmd.CMD_END_OF_RAMADAN_MARKET_MODULE, gCmd.REQ_END_OF_RAMADAN_MARKET_BUY_GIFT, handler(self, self.reqBuyGiftRsp))
	msgCtrl.register(gCmd.CMD_END_OF_RAMADAN_MARKET_MODULE, gCmd.REQ_END_OF_RAMADAN_MARKET_QUEST_REWARD, handler(self, self.reqRewardRsp))
	msgCtrl.register(gCmd.CMD_END_OF_RAMADAN_MARKET_MODULE, gCmd.REQ_END_OF_RAMADAN_MARKET_STAGE_REWARD, handler(self, self.reqStageRewardRsp))
	self:registerNotify()
end
function activity_9001624_Ctrl:Logout()
	activity_9001624_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001624_Ctrl:resetData()
	self.allianceData, _UPVALUE0_, self.data, _UPVALUE0_ = nil, nil, nil, nil
	self.allianceData.tasks, _UPVALUE0_ = nil, nil
	self.questComponent = nil
end
function activity_9001624_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.END_OF_RAMADAN_MARKET, handler(self, self.notifyHandler))
end
function activity_9001624_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001624_Ctrl:notifyHandler", 10)
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
function activity_9001624_Ctrl:initClientData(data)
	dump(data, "activity_9001624_Ctrl:initClientData")
	self:updateClientData(data, true)
end
function activity_9001624_Ctrl:updateClientData(data, isInit)
