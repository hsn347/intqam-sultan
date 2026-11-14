local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001702_Ctrl = class("activity_9001702_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local activity_9001702_Read = include("activity_9001702_Read")
function activity_9001702_Ctrl:ctor(properties)
	activity_9001702_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001702
	self:resetData()
end
function activity_9001702_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EID_CELEBRATION_2025_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EID_CELEBRATION_2025_MERGE, handler(self, self.reqMergeRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EID_CELEBRATION_2025_SEND, handler(self, self.reqSendRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EID_CELEBRATION_2025_RECEIVE, handler(self, self.reqReceiveRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EID_CELEBRATION_2025_DRAW, handler(self, self.reqDrawRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EID_CELEBRATION_2025_BYSEND_RECORD, handler(self, self.reqBysendRecordRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EID_CELEBRATION_2025_WINNER_RECORD, handler(self, self.reqWinnerRecordRsp))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.onMsgUpdateModuleData))
	activity_9001702_Read = SoraDAddMessage
	SoraDAddMessage[1] = activity_9001702_Read.getCostItemID()
	SoraDAddMessage[2] = activity_9001702_Read.getGiftItemID()
	SoraDAddMessage[3] = activity_9001702_Read.getDrawItemID()
	SoraDAddMessage[4] = activity_9001702_Read.getDrawItemID()
	SoraDAddMessage[5] = activity_9001702_Read.getDrawItemID()
	SoraDAddMessage[6] = activity_9001702_Read.getDrawItemID()
	SoraDAddMessage[7] = activity_9001702_Read.getDrawItemID()
	SoraDAddMessage[8] = activity_9001702_Read.getDrawItemID()
	SoraDAddMessage[9] = activity_9001702_Read.getDrawItemID()
	SoraDAddMessage[10] = activity_9001702_Read.getDrawItemID()
	SoraDAddMessage[11] = activity_9001702_Read.getDrawItemID()
	SoraDAddMessage[12] = activity_9001702_Read.getDrawItemID()
	local SoraDAddMessage[13], config = activity_9001702_Read.getDrawItemID()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	for __, itemID in ipairs(config) do
		backpackCtrl:addItemChangeEvent(itemID, handlerEx(self, self.notifyItemCount, itemID))
	end
	self.itemMerge = activity_9001702_Read.getItemMerge()
	self.giftItemID = activity_9001702_Read.getGiftItemID()
	self.drawItemID = activity_9001702_Read.getDrawItemID()
end
function activity_9001702_Ctrl:Logout()
	activity_9001702_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001702_Ctrl:resetData()
	_UPVALUE0_ = nil
	;(nil).canReceiveItemCount = 0
	self.initData, (nil).drawRecords, _UPVALUE0_, (nil).bySendDrawItemCount = nil, nil, nil, 0
end
function activity_9001702_Ctrl:updateInitData(rspdata)
	if rspdata.canReceiveItemCount then
		self.initData.canReceiveItemCount = rspdata.canReceiveItemCount
	end
	if rspdata.bySendDrawItemCount then
		self.initData.bySendDrawItemCount = rspdata.bySendDrawItemCount
	end
	if rspdata.drawRecords then
		self.initData.drawRecords = rspdata.drawRecords
	end
end
function activity_9001702_Ctrl:initClientData(userActivityModule)
	if not userActivityModule then
		return
	end
	local activityData = userActivityModule[tostring(self.activityID)]
	dump(activityData, "==activity_9001702_Ctrl:initClientData==", 10)
	if not activityData then
		return
	end
	self:updateInitData(activityData)
end
function activity_9001702_Ctrl:notifyItemCount(itemID)
	print("==activity_9001702_Ctrl:notifyItemCount==", itemID)
	_ENV = "==activity_9001702_Ctrl:notifyItemCount=="
	;("==activity_9001702_Ctrl:notifyItemCount==").msg = "MESSAGE_ACTIVITY_9001702_UPDATE"
	;("==activity_9001702_Ctrl:notifyItemCount==").subMsg = "itemCount"
	;("==activity_9001702_Ctrl:notifyItemCount==").itemID = itemID
	SoraDSendMessage("==activity_9001702_Ctrl:notifyItemCount==")
end
function activity_9001702_Ctrl:onMsgUpdateModuleData(target, event)
	if event.activityID == self.activityID then
		self:updateInitData(event.initData)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001702_UPDATE"
		self.subMsg = "init"
		SoraDSendMessage(self)
	end
end
function activity_9001702_Ctrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EID_CELEBRATION_2025_INIT, nil)
end
function activity_9001702_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001702_Ctrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:updateInitData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001702_UPDATE"
		self.subMsg = "init"
		SoraDSendMessage(self)
	end
end
function activity_9001702_Ctrl:reqMerge()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EID_CELEBRATION_2025_MERGE, nil)
end
function activity_9001702_Ctrl:reqMergeRsp(content)
	dump(content, "activity_9001702_Ctrl:reqMergeRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDMailGainItems(content.rspdata.rewards, true)
		SoraDShowMsgTip(i18n("Eidal_celebration_text_15"))
		_ENV = i18n("Eidal_celebration_text_15")
		i18n("Eidal_celebration_text_15").msg = "MESSAGE_ACTIVITY_9001702_UPDATE"
		i18n("Eidal_celebration_text_15").subMsg = "merge"
		SoraDSendMessage(i18n("Eidal_celebration_text_15"))
	end
end
function activity_9001702_Ctrl:reqSend(uid, count, isCheck)
	serverproxy = nil
	;(nil).uid = uid
	;(nil).count = count
	;(nil).isCheck = isCheck or false
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EID_CELEBRATION_2025_SEND, nil)
end
function activity_9001702_Ctrl:reqSendRsp(content)
	dump(content, "activity_9001702_Ctrl:reqSendRsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		if not content.rspdata.rewards then
			local _ENV, rewards = content.rspdata.rewards, content.rspdata.rewards
		end
		SoraDMailGainItems(rewards, true)
		SoraDShowMsgTip(i18n("NebulaAllstar_211"))
		_ENV = i18n("NebulaAllstar_211")
		i18n("NebulaAllstar_211").msg = "MESSAGE_ACTIVITY_9001702_UPDATE"
		i18n("NebulaAllstar_211").subMsg = "send"
		i18n("NebulaAllstar_211").uid = content.data.uid
		SoraDSendMessage(i18n("NebulaAllstar_211"))
	elseif content.err == gErrDef.Err_EID_CELEBRATION_SEND_CHECK then
		local overflowValue = content.rspdata.overflowValue or 0
		local receiveGift = activity_9001702_Read.getReceiveGift()
		local overCount = math.floor(overflowValue / receiveGift.count)
		local uid = content.data.uid or 0
		local count = content.data.count or 0
		local remainCount = math.max(0, count - overCount)
		local msgStr = ""
		if 0 < remainCount then
			_ENV = i18n("NebulaAllstar_211")
			i18n("NebulaAllstar_211").num = remainCount * receiveGift.count
			msgStr = i18n("Eidal_celebration_text_34", i18n("NebulaAllstar_211"))
		else
			msgStr = i18n("Eidal_celebration_text_33")
		end
		_ENV = remainCount * receiveGift.count
		;(remainCount * receiveGift.count).content = msgStr
		;(remainCount * receiveGift.count).cancel = true
		;(remainCount * receiveGift.count).confirmFunc = function()
			self:reqSend(uid, count, false)
		end
		;(remainCount * receiveGift.count).remindString = i18n("Eidal_celebration_text_35")
		;(remainCount * receiveGift.count).remindFunc = function(value)
			if value then
				local dailyRemindManager = include("dailyRemindManager")
				local rType = dailyRemindManager.REMIND_TYPE.activity_9001702_2
				dailyRemindManager.addRemindToManager(rType)
			end
		end
		uiManager:show("MessageBox", remainCount * receiveGift.count)
	else
		SoraDShowMsgTip(i18n("Ramadan_League_text_13"))
	end
end
function activity_9001702_Ctrl:reqReceive()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EID_CELEBRATION_2025_RECEIVE, nil)
end
function activity_9001702_Ctrl:reqReceiveRsp(content)
	dump(content, "activity_9001702_Ctrl:reqReceiveRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:updateInitData(content.rspdata)
		if not content.rspdata.rewards then
			local _ENV, rewards = content.rspdata.rewards, content.rspdata.rewards
		end
		SoraDMailGainItems(rewards, true)
		_ENV = rewards
		rewards.msg = "MESSAGE_ACTIVITY_9001702_UPDATE"
		rewards.subMsg = "receive"
		SoraDSendMessage(rewards)
	end
end
function activity_9001702_Ctrl:reqDraw(drawCount)
	serverproxy = nil
	;(nil).drawCount = drawCount
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EID_CELEBRATION_2025_DRAW, nil)
end
function activity_9001702_Ctrl:reqDrawRsp(content)
	dump(content, "activity_9001702_Ctrl:reqDrawRsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		self:updateInitData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001702_UPDATE"
		self.subMsg = "draw"
		self.rspdata = content.rspdata
		SoraDSendMessage(self)
	end
end
function activity_9001702_Ctrl:reqBysendRecord()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EID_CELEBRATION_2025_BYSEND_RECORD, nil)
end
function activity_9001702_Ctrl:reqBysendRecordRsp(content)
	dump(content, "activity_9001702_Ctrl:reqBysendRecordRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001702_UPDATE"
		gErrDef.Err_None.subMsg = "bysendRecord"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001702_Ctrl:reqWinnerRecord()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EID_CELEBRATION_2025_WINNER_RECORD, nil)
end
function activity_9001702_Ctrl:reqWinnerRecordRsp(content)
	dump(content, "activity_9001702_Ctrl:reqWinnerRecordRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001702_UPDATE"
		gErrDef.Err_None.subMsg = "winnerRecord"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001702_Ctrl:getCanReceiveItemCount()
	return self.initData.canReceiveItemCount or 0
end
function activity_9001702_Ctrl:getBySendDrawItemCount()
	return self.initData.bySendDrawItemCount or 0
end
function activity_9001702_Ctrl:getDrawRecords()
	if not self.initData.drawRecords then
		_UPVALUE0_ = self.initData.drawRecords
	end
	return self.initData.drawRecords
end
function activity_9001702_Ctrl:getTodayDrawRecord()
	local drawRecords = self:getDrawRecords()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local day = activityShowCtrl:getCurOpenDay(self.activityID)
	if not drawRecords[tostring(day)] then
		_ENV = drawRecords[tostring(day)]
	end
	return drawRecords[tostring(day)]
end
function activity_9001702_Ctrl:getTodayFirstPrizeCount()
	local drawRecord = self:getTodayDrawRecord()
	return drawRecord["1"] and drawRecord["1"].count or 0
end
function activity_9001702_Ctrl:checkItemCount(itemID, itemNeed, noMsgTip)
	itemNeed = itemNeed or 1
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local itemCount = backpackCtrl:getItemCount(itemID)
	if itemNeed <= itemCount then
		return true
	else
		if not noMsgTip then
			local publicRead = include("publicRead")
			local itemName = publicRead.getName(itemID)
			_ENV = nil
			;(nil).item = itemName
			SoraDShowMsgTip(i18n("common_text_1806", nil))
		end
		return false
	end
end
function activity_9001702_Ctrl:getReceiveStatusAndNum()
	local retNum = 0
	local _red, _redNum = self:getPage1RedNum()
	if _red then
		retNum = retNum + _redNum
	end
	local _red, _redNum = self:getPage2RedNum()
	if _red then
		retNum = retNum + _redNum
	end
	return 0 < retNum, retNum
end
function activity_9001702_Ctrl:getPage1RedNum()
	if not self:checkDoStage0() then
		return false, 0
	end
	local retNum = 0
	if self:checkItemCount(self.itemMerge.id, self.itemMerge.count, true) then
		retNum = retNum + 1
	end
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local itemCount = backpackCtrl:getItemCount(self.giftItemID)
	if 0 < itemCount then
		retNum = retNum + itemCount
	end
	return 0 < retNum, retNum
end
function activity_9001702_Ctrl:getPage2RedNum()
	if not self:checkDoStage0() then
		return false, 0
	end
	local retNum = 0
	if 0 < self:getCanReceiveItemCount() then
		retNum = retNum + 1
	end
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local itemCount = backpackCtrl:getItemCount(self.drawItemID)
	if 0 < itemCount then
		retNum = retNum + itemCount
	end
	return 0 < retNum, retNum
end
function activity_9001702_Ctrl:checkDoStage0()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local doStage = activityShowCtrl:getDoStageByID(self.activityID)
	return doStage == 0
end
return activity_9001702_Ctrl
