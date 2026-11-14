local wiseTutorRead = include("wiseTutorRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001629_Ctrl = class("activity_9001629_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local constantRead = include("constantRead")
function activity_9001629_Ctrl:ctor(properties)
	activity_9001629_Ctrl.super.ctor(self, properties)
	self:resetData()
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001629
	self.refreshCD = constantRead.getConstValue("STARS_BATTLE_REFRESH_CD", 1)
end
function activity_9001629_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_STARS_WISHING_MODULE, gCmd.REQ_STARS_WISHING_DATA, handler(self, self.reqInitDataRsp))
	msgCtrl.register(gCmd.CMD_STARS_WISHING_MODULE, gCmd.REQ_STARS_WISHING_REFRESH_DATA, handler(self, self.reqRefreshRsp))
	msgCtrl.register(gCmd.CMD_STARS_WISHING_MODULE, gCmd.REQ_STARS_WISHING_PLAYER_DATA, handler(self, self.reqPlayerRsp))
	msgCtrl.register(gCmd.CMD_STARS_WISHING_MODULE, gCmd.REQ_STARS_WISHING, handler(self, self.reqWishRsp))
	msgCtrl.register(gCmd.CMD_STARS_WISHING_MODULE, gCmd.REQ_STARS_WISHING_LIKE, handler(self, self.reqLikeRsp))
	msgCtrl.register(gCmd.CMD_STARS_WISHING_MODULE, gCmd.REQ_STARS_WISHING_READ_RECV, handler(self, self.reqReadRsp))
	msgCtrl.register(gCmd.CMD_STARS_WISHING_MODULE, gCmd.REQ_STARS_WISHING_TASK_DATA, handler(self, self.reqTaskRsp))
	msgCtrl.register(gCmd.CMD_STARS_WISHING_MODULE, gCmd.REQ_STARS_WISHING_TASK_REWARD, handler(self, self.reqTaskRewardRsp))
	self:registerNotify()
end
function activity_9001629_Ctrl:Logout()
	activity_9001629_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001629_Ctrl:resetData()
	self.data, _UPVALUE0_ = nil, nil
	self.recvWishes, _UPVALUE0_, self.beLikedCount = nil, nil, 0
	self.questComponent = nil
	self.changeCDTime = 0
end
function activity_9001629_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.STARS_WISHING, handler(self, self.notifyHandler))
end
function activity_9001629_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001629_Ctrl:notifyHandler", 10)
	for _, v in pairs(event.data) do
		local notifyType = v.notifyType
		local notifyData = v.notifyData
		if notifyType == "recvWishing" then
			local dailyRemindManager = include("dailyRemindManager")
			if dailyRemindManager.checkNeedRemind(dailyRemindManager.REMIND_TYPE.activity_9001629) then
				self.recvWishes[notifyData.uid] = notifyData
				_ENV = notifyData.uid
				notifyData.uid.msg = "MESSAGE_ACTIVITY_9001629_UPDATE"
				SoraDSendMessage(notifyData.uid)
			else
				self:reqRead()
			end
		elseif notifyType == "beLiked" then
			self.beLikedCount = notifyData.beLikedCount
			_ENV = self.reqRead
			self.reqRead.msg = "MESSAGE_ACTIVITY_9001629_UPDATE"
			SoraDSendMessage(self.reqRead)
		elseif notifyType == "taskNewLevel" then
			self.data.globalCount = notifyData.globalCount
			_ENV = notifyData.globalCount
			notifyData.globalCount.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			notifyData.globalCount.activityID = self.activityID
			SoraDSendMessage(notifyData.globalCount)
			_ENV = notifyData.globalCount
			notifyData.globalCount.msg = "MESSAGE_ACTIVITY_9001629_TASK"
			SoraDSendMessage(notifyData.globalCount)
		end
	end
end
function activity_9001629_Ctrl:initClientData(data)
	dump(data, "activity_9001629_Ctrl:initClientData")
	if data then
		if data.wishes then
			_ENV, _UPVALUE1_ = "activity_9001629_Ctrl:initClientData", data.wishes
			;("activity_9001629_Ctrl:initClientData").uid = data.wishes[1] or 0
			data.wishes[1] = "activity_9001629_Ctrl:initClientData"
			if data.wishes then
				goto lbl_23
			end
		end
		::lbl_23::
		self.data.wishes = nil
		self.beLikedCount = data.beLikedCount or 0
		self.data.globalCount = data.globalCount or 0
		self.haveRecvWishes = data.recvWishMap and 0 < #data.recvWishMap or false
		local recordLikeNum = self:getRecordLikeNum()
		if recordLikeNum < self.beLikedCount then
			self:setRecordLikeNum(self.beLikedCount)
		end
	end
end
function activity_9001629_Ctrl:updateData(data, isInit)
