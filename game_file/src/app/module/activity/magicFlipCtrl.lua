local magicFlipRead = include("magicFlipRead")
local constantRead = include("constantRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local magicFlipCtrl = class("magicFlipCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function magicFlipCtrl:ctor(properties)
	magicFlipCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.MAGIC_FLIP_ACTIVITY
	self.itemID = constantRead.getConstValue("USE_ITEM_9001498", 860901)
	self:resetData()
end
function magicFlipCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_MAGIC_FLIP_MODULE, gCmd.REQ_MAGIC_FLIP_INIT, handler(self, self.reqMagicFlipInitRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_FLIP_MODULE, gCmd.REQ_MAGIC_FLIP_OPEN_ONE, handler(self, self.reqMagicFlipOpenOneRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_FLIP_MODULE, gCmd.REQ_MAGIC_FLIP_OPEN_TEN, handler(self, self.reqMagicFlipOpenTenRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_FLIP_MODULE, gCmd.REQ_MAGIC_FLIP_STAGE_REWARD, handler(self, self.reqMagicFlipStageRewardRsp))
	self:registerNotify()
end
function magicFlipCtrl:Logout()
	magicFlipCtrl.super.Logout(self)
	self:resetData()
end
function magicFlipCtrl:resetData()
	self.initData, _UPVALUE0_ = nil, nil
end
function magicFlipCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.MAGIC_FLIP, handler(self, self.notifyHandler))
end
function magicFlipCtrl:notifyHandler(event)
	dump(event.data, "magicFlipCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self.initData = v.initData
		_ENV = nil
		;(nil).msg = "MESSAGE_ACTIVITY_9001498_UPDATE"
		;(nil).subMsg = "init"
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;(nil).eventID = self.activityID
		SoraDSendMessage(nil)
	end
end
function magicFlipCtrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_MAGIC_FLIP_MODULE, gCmd.REQ_MAGIC_FLIP_INIT, nil)
end
function magicFlipCtrl:reqMagicFlipInitRsp(content)
	dump(content, "magicFlipCtrl:reqMagicFlipInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001498_UPDATE"
		gErrDef.Err_None.subMsg = "init"
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		gErrDef.Err_None.eventID = self.activityID
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function magicFlipCtrl:reqMagicFlipOpenOne()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_MAGIC_FLIP_MODULE, gCmd.REQ_MAGIC_FLIP_OPEN_ONE, nil)
end
function magicFlipCtrl:reqMagicFlipOpenOneRsp(content)
	dump(content, "magicFlipCtrl:reqMagicFlipOpenOneRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001498_UPDATE"
		gErrDef.Err_None.subMsg = "one"
		gErrDef.Err_None.reward = content.rspdata.retRandomCards[1].reward
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		gErrDef.Err_None.eventID = self.activityID
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function magicFlipCtrl:reqMagicFlipOpenTen()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_MAGIC_FLIP_MODULE, gCmd.REQ_MAGIC_FLIP_OPEN_TEN, nil)
end
function magicFlipCtrl:reqMagicFlipOpenTenRsp(content)
	dump(content, "magicFlipCtrl:reqMagicFlipOpenTenRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		_ENV = 10
		;(10).retRandomCards = content.rspdata.retRandomCards
		uiManager:show("MagicLampGainTen", 10)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_ACTIVITY_9001498_UPDATE"
		uiManager.subMsg = "ten"
		SoraDSendMessage(uiManager)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		uiManager.eventID = self.activityID
		SoraDSendMessage(uiManager)
	end
end
function magicFlipCtrl:reqMagicFlipStageReward(stage)
	serverproxy = nil
	;(nil).stage = stage
	serverproxy:Request(gCmd.CMD_MAGIC_FLIP_MODULE, gCmd.REQ_MAGIC_FLIP_STAGE_REWARD, nil)
end
function magicFlipCtrl:reqMagicFlipStageRewardRsp(content)
	dump(content, "magicFlipCtrl:reqMagicFlipStageRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData.stageRecord = content.rspdata.stageRecord
		SoraDMailGainItems(content.rspdata.reward, true)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_ACTIVITY_9001498_UPDATE"
		content.rspdata.reward.subMsg = "stage"
		SoraDSendMessage(content.rspdata.reward)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.reward.eventID = self.activityID
		SoraDSendMessage(content.rspdata.reward)
	end
end
function magicFlipCtrl:getFlipLog()
	if not self.initData.flipRecord then
		_UPVALUE0_ = self.initData.flipRecord
	end
	return self.initData.flipRecord
end
function magicFlipCtrl:getNewCardRecord()
	if self.initData.flipRecord and next(self.initData.flipRecord) then
		return self.initData.flipRecord[#self.initData.flipRecord].cards
	end
end
function magicFlipCtrl:getFlipCount()
	return self.initData.count or 0
end
function magicFlipCtrl:getIsDouble()
	return self.initData.double or false
end
function magicFlipCtrl:getStageStatues(index, num)
	local ret = 0
	if self.initData.stageRecord then
		ret = self.initData.stageRecord[tostring(index)] or 0
	end
	return ret
end
function magicFlipCtrl:getStageBoxStatues(...)
	local state = self:getStageStatues(...)
	_ENV = self
	self[gMmagicFlipStatus.CAN_RECEIVE] = gBtnTargetStatusDef.GET
	local self[gMmagicFlipStatus.ALREADY_RECEIVE], state2status = gBtnTargetStatusDef.GOT, self
	return state2status[state] or gBtnTargetStatusDef.GO
end
function magicFlipCtrl:getReceiveStatusAndNum()
	local ret = 0
	if 0 < SoraDGetCtrl("backpackCtrl"):getItemCount(self.itemID) then
		ret = ret + 1
	end
	ret = self:getStageRedNum() + ret
	return 0 < ret, -1
end
function magicFlipCtrl:getStageRedNum()
	local ret = 0
	if self.initData.stageRecord then
		for i, v in pairs(self.initData.stageRecord) do
			if v == gMmagicFlipStatus.CAN_RECEIVE then
				ret = ret + 1
			end
		end
	end
	return ret
end
return magicFlipCtrl
