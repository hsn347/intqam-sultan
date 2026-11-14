local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001670_Ctrl = class("activity_9001670_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001670_Ctrl:ctor(properties)
	activity_9001670_Ctrl.super.ctor(self, properties)
	self:resetData()
	self.activityID = gActivityTimeActivityID.REBUILD_BUBBLE_LAND
end
function activity_9001670_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_REBUILD_BUBBLE_LAND_MODULE, gCmd.REQ_REBUILD_BUBBLE_LAND_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_REBUILD_BUBBLE_LAND_MODULE, gCmd.REQ_REBUILD_BUBBLE_LAND_QUEST_REWARD, handler(self, self.reqQuestRewardRsp))
	msgCtrl.register(gCmd.CMD_REBUILD_BUBBLE_LAND_MODULE, gCmd.REQ_REBUILD_BUBBLE_LAND_STAGE_REWARD, handler(self, self.reqStageRewardRsp))
	msgCtrl.register(gCmd.CMD_REBUILD_BUBBLE_LAND_MODULE, gCmd.REQ_REBUILD_BUBBLE_LAND_MEMBER_SCORE, handler(self, self.reqMemberScoreRsp))
	msgCtrl.register(gCmd.CMD_REBUILD_BUBBLE_LAND_MODULE, gCmd.REQ_REBUILD_BUBBLE_LAND_CONVENE_PARTY, handler(self, self.reqConvenePartyRsp))
	msgCtrl.register(gCmd.CMD_REBUILD_BUBBLE_LAND_MODULE, gCmd.REQ_REBUILD_BUBBLE_LAND_GIFT_RECORD, handler(self, self.reqGiftRecordRsp))
	self:registerNotify()
end
function activity_9001670_Ctrl:Logout()
	activity_9001670_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001670_Ctrl:resetData()
	_UPVALUE0_ = nil
	;(nil).round = 0
	;(nil).questData, _UPVALUE0_, (nil).exp = nil, nil, 0
	;(nil).normalRewardLv = 0
	;(nil).advanceRewardLv = 0
	;(nil).seniorRewardLv = 0
	;(nil).isAdvanceRewardUnlock = false
	_UPVALUE0_, self.initData, (nil).getedPartyGift, _UPVALUE0_, (nil).isSeniorRewardUnlock = nil, nil, nil, nil, false
	self.allianceData, (nil).partyInfo, _UPVALUE0_, (nil).totalScore = nil, nil, nil, 0
end
function activity_9001670_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.REBUILD_BUBBLE_LAND, handler(self, self.notifyHandler))
end
function activity_9001670_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001670_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		local notifyType = v.notifyType
		local notifyData = v.notifyData
		if notifyType == "refreshData" then
			self:initClientData(notifyData)
			_ENV = self
			self.msg = "MESSAGE_ACTIVITY_9001670_UPDATE"
			self.subMsg = "initData"
			SoraDSendMessage(self)
		elseif notifyType == "buyGift" then
			if notifyData.success then
				if not notifyData.initData then
					_ENV = notifyData.initData
				end
				self.initData = notifyData.initData
				_ENV = self
				self.msg = "MESSAGE_ACTIVITY_9001670_UPDATE"
				self.subMsg = "buyGift"
				SoraDSendMessage(self)
			end
		elseif notifyType == "getedPartyGift" then
			self.initData.getedPartyGift = notifyData
			_ENV = self
			self.msg = "MESSAGE_ACTIVITY_9001670_UPDATE"
			self.subMsg = "getedPartyGift"
			SoraDSendMessage(self)
		end
	end
end
function activity_9001670_Ctrl:initClientData(initData)
