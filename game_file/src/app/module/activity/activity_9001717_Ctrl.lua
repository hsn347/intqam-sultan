local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001717_Ctrl = class("activity_9001717_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local activity_9001717_Read = include("activity_9001717_Read")
function activity_9001717_Ctrl:ctor(properties)
	activity_9001717_Ctrl.super.ctor(self, properties)
	self:resetData()
	self.activityID = gActivityTimeActivityID.FANTASY_LAND
end
function activity_9001717_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_FANTASY_LAND_MODULE, gCmd.REQ_FANTASY_LAND_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_FANTASY_LAND_MODULE, gCmd.REQ_FANTASY_LAND_QUEST_REWARD, handler(self, self.reqQuestRewardRsp))
	msgCtrl.register(gCmd.CMD_FANTASY_LAND_MODULE, gCmd.REQ_FANTASY_LAND_STAGE_REWARD, handler(self, self.reqStageRewardRsp))
	msgCtrl.register(gCmd.CMD_FANTASY_LAND_MODULE, gCmd.REQ_FANTASY_LAND_MEMBER_SCORE, handler(self, self.reqMemberScoreRsp))
	msgCtrl.register(gCmd.CMD_FANTASY_LAND_MODULE, gCmd.REQ_FANTASY_LAND_CONVENE_PARTY, handler(self, self.reqConvenePartyRsp))
	msgCtrl.register(gCmd.CMD_FANTASY_LAND_MODULE, gCmd.REQ_FANTASY_LAND_GIFT_RECORD, handler(self, self.reqGiftRecordRsp))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_MEMBER_UPDATE", handler(self, self.onMsgUpdateAlliance))
	self:registerNotify()
end
function activity_9001717_Ctrl:onMsgUpdateAlliance(target, event)
	if clientEventMgr.judgeIsOpen(self.activityID) then
		self:sendReqInitDataMsg()
	end
end
function activity_9001717_Ctrl:Logout()
	activity_9001717_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001717_Ctrl:resetData()
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
function activity_9001717_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.FANTASY_LAND, handler(self, self.notifyHandler))
end
function activity_9001717_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001717_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		local notifyType = v.notifyType
		local notifyData = v.notifyData
		if notifyType == "refreshData" then
			self:initClientData(notifyData)
			_ENV = self
			self.msg = "MESSAGE_ACTIVITY_9001717_UPDATE"
			self.subMsg = "initData"
			SoraDSendMessage(self)
		elseif notifyType == "buyGift" then
			if notifyData.success then
				if not notifyData.initData then
					_ENV = notifyData.initData
				end
				self.initData = notifyData.initData
				_ENV = self
				self.msg = "MESSAGE_ACTIVITY_9001717_UPDATE"
				self.subMsg = "buyGift"
				SoraDSendMessage(self)
			end
		elseif notifyType == "getedPartyGift" then
			self.initData.getedPartyGift = notifyData
			_ENV = self
			self.msg = "MESSAGE_ACTIVITY_9001717_UPDATE"
			self.subMsg = "getedPartyGift"
			SoraDSendMessage(self)
		end
	end
end
function activity_9001717_Ctrl:initClientData(initData)
