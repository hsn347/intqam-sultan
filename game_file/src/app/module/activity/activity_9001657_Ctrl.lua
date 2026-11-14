local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001657_Ctrl = class("activity_9001657_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001657_Ctrl:ctor(properties)
	activity_9001657_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.MERGE_SERVER_ACTIVITY
	self:resetData()
end
function activity_9001657_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_NEW_MERGE_SERVER_MODULE, gCmd.REQ_NEW_MERGE_SERVER_INIT, handler(self, self.reqInitDataRsp))
	msgCtrl.register(gCmd.CMD_NEW_MERGE_SERVER_MODULE, gCmd.REQ_NMS_MOVEIN_KINGDOM_INFO, handler(self, self.reqMoveInKingdomInfoRsp))
	msgCtrl.register(gCmd.CMD_NEW_MERGE_SERVER_MODULE, gCmd.REQ_NMS_APPLY_USER_LIST, handler(self, self.reqApplyUserListRsp))
	msgCtrl.register(gCmd.CMD_NEW_MERGE_SERVER_MODULE, gCmd.REQ_NMS_APPLY_MOVEIN, handler(self, self.reqApplyMoveInRsp))
	msgCtrl.register(gCmd.CMD_NEW_MERGE_SERVER_MODULE, gCmd.REQ_NMS_AGREE_APPLY, handler(self, self.reqAgreeApplyRsp))
	msgCtrl.register(gCmd.CMD_NEW_MERGE_SERVER_MODULE, gCmd.REQ_NMS_UNBIND, handler(self, self.reqUnbindRsp))
	msgCtrl.register(gCmd.CMD_NEW_MERGE_SERVER_MODULE, gCmd.REQ_NMS_REJECT_APPLY, handler(self, self.reqRejectApplyRsp))
	msgCtrl.register(gCmd.CMD_NEW_MERGE_SERVER_USER_MODULE, gCmd.REQ_NMS_USER_INIT, handler(self, self.reqUserInitRsp))
	msgCtrl.register(gCmd.CMD_NEW_MERGE_SERVER_USER_MODULE, gCmd.CMD_NMS_ENTER_CHAT_ROOM, handler(self, self.reqEnterChatRoomRsp))
	self:registerNotify()
end
function activity_9001657_Ctrl:Logout()
	activity_9001657_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001657_Ctrl:resetData()
	self.initData, _UPVALUE0_ = nil, nil
	self.isEnterChatRoom = false
	;(nil).userApplyInfo, _UPVALUE0_, (nil).moveInKingdomInfo, _UPVALUE0_, _UPVALUE0_, self.channelID = nil, nil, nil, nil, nil, 0
	self.kingdomInfo, (nil).unbindTimes = nil, 0
end
function activity_9001657_Ctrl:initClientData(data)
	if not data then
		return
	end
	dump(data, "==activity_9001657_Ctrl:initClientData==", 10)
	self.initData = data
	if clientEventMgr.judgeIsOpen(self.activityID) then
		self:reqUserInit()
	end
end
function activity_9001657_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.MERGE_SERVER, handler(self, self.notifyHandler))
end
function activity_9001657_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001657_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		local notifyType = v.notifyType
		local notifydata = v.notifydata
		if notifyType == "userApplyInfo" then
			self.kingdomInfo.userApplyInfo = notifydata
			_ENV = nil
			;(nil).msg = "MESSAGE_ACTIVITY_9001657_KINGDOM_LIST"
			;(nil).subMsg = "userApplyInfo"
			SoraDSendMessage(nil)
		elseif notifyType == "hasNotAgreedUser" then
			self.initData.hasNotAgreedUser = notifydata.hasNotAgreedUser
			_ENV = notifydata.hasNotAgreedUser
			notifydata.hasNotAgreedUser.msg = "MESSAGE_ACTIVITY_9001657_MAIN"
			notifydata.hasNotAgreedUser.subMsg = "hasNotAgreedUser"
			SoraDSendMessage(notifydata.hasNotAgreedUser)
		elseif notifyType == "agreedUserNum" then
			self.initData.agreedUserNum = notifydata.agreedUserNum
			_ENV = notifydata.agreedUserNum
			notifydata.agreedUserNum.msg = "MESSAGE_ACTIVITY_9001657_APPLY_LIST"
			notifydata.agreedUserNum.subMsg = "agreedUserNum"
			SoraDSendMessage(notifydata.agreedUserNum)
		elseif notifyType == "bindkid" then
			local bindKid = self:getUserBindKid()
			bindKid = bindKid or notifydata.bindkid
			_ENV = nil
			;(nil).var1 = bindKid
			local showMsg = i18n("kingdom_merger_text30", nil)
			_ENV = nil
			;(nil).content = showMsg
			;(nil).cancel = true
			;(nil).confirmFunc = function()
				gametop:Logout()
				SoraDShowLoginView()
			end
			uiManager:show("MessageBox", nil)
		end
	end
end
function activity_9001657_Ctrl:sendReqInitDataMsg(...)
	self:reqInitData()
end
function activity_9001657_Ctrl:reqInitData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_NEW_MERGE_SERVER_MODULE, gCmd.REQ_NEW_MERGE_SERVER_INIT, nil)
end
function activity_9001657_Ctrl:reqInitDataRsp(content)
	dump(content, "activity_9001657_Ctrl:reqInitDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata then
			_ENV = content.rspdata
		end
		self.initData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001657_APPLY_LIST"
		gErrDef.Err_None.subMsg = "agreedUserNum"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001657_Ctrl:reqMoveInKingdomInfo()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_NEW_MERGE_SERVER_MODULE, gCmd.REQ_NMS_MOVEIN_KINGDOM_INFO, nil)
end
function activity_9001657_Ctrl:reqMoveInKingdomInfoRsp(content)
	dump(content, "activity_9001657_Ctrl:reqMoveInKingdomInfoRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata then
			_ENV = content.rspdata
		end
		self.kingdomInfo = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001657_KINGDOM_LIST"
		gErrDef.Err_None.subMsg = "init"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001657_Ctrl:reqApplyUserList()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_NEW_MERGE_SERVER_MODULE, gCmd.REQ_NMS_APPLY_USER_LIST, nil)
end
function activity_9001657_Ctrl:reqApplyUserListRsp(content)
	dump(content, "activity_9001657_Ctrl:reqApplyUserListRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.applyUserList = content.rspdata
		self:updateHasNotAgreedUser()
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001657_APPLY_LIST"
		self.subMsg = "applyUserList"
		SoraDSendMessage(self)
	end
end
function activity_9001657_Ctrl:reqApplyMoveIn(kid)
	serverproxy = nil
	;(nil).kid = kid
	serverproxy:Request(gCmd.CMD_NEW_MERGE_SERVER_MODULE, gCmd.REQ_NMS_APPLY_MOVEIN, nil)
end
function activity_9001657_Ctrl:reqApplyMoveInRsp(content)
	dump(content, "activity_9001657_Ctrl:reqApplyMoveInRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("nebula_war_text_0318"))
		self.kingdomInfo.userApplyInfo = content.rspdata
		_ENV = content.rspdata
		content.rspdata.msg = "MESSAGE_ACTIVITY_9001657_KINGDOM_LIST"
		content.rspdata.subMsg = "applyMovein"
		SoraDSendMessage(content.rspdata)
	elseif content.err == gErrDef.Err_MERGE_SERVER_AGREED_MAX_NUM then
		SoraDShowMsgTip(i18n("kingdom_merger_text16"))
		_ENV = i18n("kingdom_merger_text16")
		i18n("kingdom_merger_text16").msg = "MESSAGE_ACTIVITY_9001657_KINGDOM_LIST"
		i18n("kingdom_merger_text16").errCode = content.err
		SoraDSendMessage(i18n("kingdom_merger_text16"))
	end
end
function activity_9001657_Ctrl:reqAgreeApply(uid)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_NEW_MERGE_SERVER_MODULE, gCmd.REQ_NMS_AGREE_APPLY, nil)
end
function activity_9001657_Ctrl:reqAgreeApplyRsp(content)
	dump(content, "activity_9001657_Ctrl:reqAgreeApplyRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData.agreedUserNum = content.rspdata.agreedUserNum
		local uid = content.data.uid
		local userInfo = self:getApplyUserInfo(uid)
		if userInfo then
			userInfo.state = gMergeServerApplyState.AGREED
		end
		self:updateHasNotAgreedUser()
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001657_APPLY_LIST"
		SoraDSendMessage(self)
	else
		SoraDShowMsgTip(i18n("notice_0026"))
		self:reqApplyUserList()
	end
end
function activity_9001657_Ctrl:reqUnbind(kid)
	serverproxy = nil
	;(nil).kid = kid
	serverproxy:Request(gCmd.CMD_NEW_MERGE_SERVER_MODULE, gCmd.REQ_NMS_UNBIND, nil)
end
function activity_9001657_Ctrl:reqUnbindRsp(content)
	dump(content, "activity_9001657_Ctrl:reqUnbindRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("kingdom_merger_text34"))
		local unbindTimes = self:getUnbindTimes()
		self.kingdomInfo.unbindTimes = unbindTimes + 1
		local kid = content.data.kid
		local userApplyInfo = self:getUserApplyInfo()
		userApplyInfo[tostring(kid)] = nil
		local agreedUserNum = content.rspdata.agreedUserNum or 0
		local kingdomInfo = self:getKingdomInfoByKid(kid)
		if kingdomInfo then
			kingdomInfo.agreedUserNum = agreedUserNum
		end
		_ENV = kid
		kid.msg = "MESSAGE_ACTIVITY_9001657_KINGDOM_LIST"
		kid.subMsg = "unbind"
		SoraDSendMessage(kid)
	end
end
function activity_9001657_Ctrl:reqRejectApply(uid)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_NEW_MERGE_SERVER_MODULE, gCmd.REQ_NMS_REJECT_APPLY, nil)
end
function activity_9001657_Ctrl:reqRejectApplyRsp(content)
	dump(content, "activity_9001657_Ctrl:reqRejectApplyRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local uid = content.data.uid
		if self.applyUserList then
			self.applyUserList[tostring(uid)] = nil
		end
		self:updateHasNotAgreedUser()
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001657_APPLY_LIST"
		self.subMsg = "applyUserList"
		SoraDSendMessage(self)
	else
		SoraDShowMsgTip(i18n("notice_0026"))
		self:reqApplyUserList()
	end
end
function activity_9001657_Ctrl:reqUserInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_NEW_MERGE_SERVER_USER_MODULE, gCmd.REQ_NMS_USER_INIT, nil)
end
function activity_9001657_Ctrl:reqUserInitRsp(content)
	dump(content, "activity_9001657_Ctrl:reqUserInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.isEnterChatRoom = content.rspdata.isEnterChatRoom
	end
end
function activity_9001657_Ctrl:reqEnterChatRoom()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_NEW_MERGE_SERVER_USER_MODULE, gCmd.CMD_NMS_ENTER_CHAT_ROOM, nil)
end
function activity_9001657_Ctrl:reqEnterChatRoomRsp(content)
	dump(content, "activity_9001657_Ctrl:reqEnterChatRoomRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.channelID = content.rspdata.channelID
		self.isEnterChatRoom = true
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001657_ENTER_CHATROOM"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001657_Ctrl:getIsMoveInKingdom(...)
	return self.initData.isMoveInKingdom
end
function activity_9001657_Ctrl:getAgreedUserNum(...)
	return self.initData.agreedUserNum or 0
end
function activity_9001657_Ctrl:checkAgreedUserNum(...)
	local constantRead = include("constantRead")
	local numMax = constantRead.getConstValue("KINGDOM_MERGER_PEOPLE_NUMBER", 0)
	local userNum = self:getAgreedUserNum()
	return numMax > userNum
end
function activity_9001657_Ctrl:getHasNotAgreedUser(...)
	return self.initData.hasNotAgreedUser or false
end
function activity_9001657_Ctrl:updateHasNotAgreedUser(...)
	if self:getHasNotAgreedUser() then
		for __, v in pairs(self.applyUserList) do
			if v.state == gMergeServerApplyState.APPLIED then
				return
			end
		end
		self.initData.hasNotAgreedUser = false
	else
		for __, v in pairs(self.applyUserList) do
			if v.state == gMergeServerApplyState.APPLIED then
				self.initData.hasNotAgreedUser = true
				return
			end
		end
	end
end
function activity_9001657_Ctrl:getMoveInKingdomInfo(...)
	if not self.kingdomInfo.moveInKingdomInfo then
		_UPVALUE0_ = self.kingdomInfo.moveInKingdomInfo
	end
	return self.kingdomInfo.moveInKingdomInfo
end
function activity_9001657_Ctrl:getKingdomInfoByKid(kid)
	local moveInKingdomInfo = self:getMoveInKingdomInfo()
	for __, v in ipairs(moveInKingdomInfo) do
		if v.kid == kid then
			return v
		end
	end
end
function activity_9001657_Ctrl:getUserApplyInfo(...)
	if not self.kingdomInfo.userApplyInfo then
		_UPVALUE0_ = self.kingdomInfo.userApplyInfo
	end
	return self.kingdomInfo.userApplyInfo
end
function activity_9001657_Ctrl:getApplyState(kid)
	local userApplyInfo = self:getUserApplyInfo()
	return userApplyInfo[tostring(kid)]
end
function activity_9001657_Ctrl:checkOtherBind(...)
	local bindKid = self:getUserBindKid()
	return bindKid ~= nil
end
function activity_9001657_Ctrl:getUserBindKid(...)
	local userApplyInfo = self:getUserApplyInfo()
	for k, v in pairs(userApplyInfo) do
		if v == gMergeServerApplyState.AGREED or v == gMergeServerApplyState.AUTO_AGREED then
			return tonumber(k)
		end
	end
end
function activity_9001657_Ctrl:getUnbindTimes(...)
	return self.kingdomInfo.unbindTimes or 0
end
function activity_9001657_Ctrl:getChannelID(...)
	return self.channelID or 0
end
function activity_9001657_Ctrl:getIsEnterChatRoom(...)
	return self.isEnterChatRoom
end
function activity_9001657_Ctrl:getApplyUserList(...)
	if not self.applyUserList then
		_UPVALUE0_ = self.applyUserList
	end
	return self.applyUserList
end
function activity_9001657_Ctrl:getApplyUserInfo(uid)
	if self.applyUserList then
		return self.applyUserList[tostring(uid)]
	end
end
function activity_9001657_Ctrl:checkSelfIsKing(...)
	local lastKingUid = worldMapDefine.lastKingUid
	if lastKingUid then
		local selfPlayerID = gametop.playertop_:getPlayerID()
		return lastKingUid == selfPlayerID
	end
end
function activity_9001657_Ctrl:getReceiveStatusAndNum(...)
	if not self:getIsMoveInKingdom() then
		return false
	end
	if not self:checkSelfIsKing() then
		return false
	end
	if self:getHasNotAgreedUser() then
		return true, -1
	else
		return false
	end
end
function activity_9001657_Ctrl:showFAQ()
	local constantRead = include("constantRead")
	local buildLogic = include("buildLogic")
	local castleLv = constantRead.getConstValue("KINGDOM_MERGER_CASTLE_LV", 60)
	local castleLvStr = buildLogic.getBuildLvStr(castleLv)
	_ENV = nil
	;(nil).var1 = castleLvStr
	local rule1 = i18n("kingdom_merger_rule1", nil)
	local numLimit = constantRead.getConstValue("KINGDOM_MERGER_PEOPLE_NUMBER", 0)
	local powerLimit = constantRead.getConstValue("KINGDOM_MERGER_POWER", 0)
	_ENV = nil
	;(nil).var1 = castleLvStr
	;(nil).var2 = numLimit
	;(nil).var3 = SoraDConvertNumberWithUnit(powerLimit)
	local rule2 = i18n("kingdom_merger_rule2", nil)
	local cancelLimit = constantRead.getConstValue("KINGDOM_MERGER_CANCELLATIONS", 0)
	_ENV = powerLimit
	powerLimit.var4 = cancelLimit
	local rule3 = i18n("kingdom_merger_rule3", powerLimit)
	local content = rule1 .. [[


]] .. rule2 .. [[


]] .. rule3
	_ENV = rule3
	rule3.title = i18n("Payment_activity_optimization_text_09")
	rule3.content = content
	uiManager:show("RuleView", rule3)
end
return activity_9001657_Ctrl
