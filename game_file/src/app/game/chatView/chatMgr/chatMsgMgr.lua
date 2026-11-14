local chatBaseMgr = include("chatBaseMgr")
local chatMsgMgr = class("chatMsgMgr", chatBaseMgr)
local gametop = gModuleMgr.getObject("gametop")
local chatCtrl = gametop.playertop_:getModule("chatCtrl")
local constantRead = include("constantRead")
function chatMsgMgr:init()
	self.chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
	self:reset()
end
function chatMsgMgr:reset()
end
function chatMsgMgr:clean()
	self:reset()
end
function chatMsgMgr:removeMessageListener()
	SoraDRemoveMessageByTarget(self)
end
function chatMsgMgr:registerMessageListener()
	self:removeMessageListener()
	SoraDAddMessage(self, "MESSAGE_CHAT_SHIELD_USER", handler(self, self.onShieldUser))
	SoraDAddMessage(self, "MESSAGE_CHAT_UNSHIELD_USER", handler(self, self.onUnShieldUser))
	SoraDAddMessage(self, "MESSAGE_CHAT_FORBID_LORD", handler(self, self.msgRequesForbidUser))
	SoraDAddMessage(self, "MESSAGE_CHAT_REQUEST_LORD_INFO", handler(self, self.requestLordData))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.sMsgLordData))
	SoraDAddMessage(self, "MESSAGE_CHAT_REQUEST_SHIELD_USER", handler(self, self.msgRequesShieldUser))
	SoraDAddMessage(self, "MESSAGE_CHAT_REQUEST_UNSHIELD_USER", handler(self, self.msgRequestUnShieldUser))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqAllianceInfoBack))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_BE_KICKED", handler(self, self.sMsgAllianceBeKicked))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_QUIT_SUCCESS", handler(self, self.sMsgAllianceQuitSuccess))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_DISMISS_SUCCESS", handler(self, self.sMsgAllianceDismissSuccess))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_OPERATE_SHIELD_LIST", handler(self, self.msgReqOperateShieldList))
	SoraDAddMessage(self, "MESSAGE_CHAT_SERVER_SDK_VOICE_INVITATION", handler(self, self.sMsgVoiceInvitation))
end
function chatMsgMgr:onShieldUser(target, data)
	local data = data.data
	print("屏蔽用户成功")
	_ENV = nil
	;(nil).name = data.nickName or "null"
	local strTipMsg = i18n("common_text_511", nil)
	SoraDShowMsgTip(strTipMsg)
	print("todo:在当前频道插入一个tag meessage onShieldUser")
end
function chatMsgMgr:onUnShieldUser(target, data)
	local data = data.data
	_ENV = nil
	;(nil).name = data.nickName or "null"
	local strTipMsg = i18n("common_text_513", nil)
	SoraDShowMsgTip(strTipMsg)
	print("todo:在当前频道插入一个tag meessage onUnShieldUser")
end
function chatMsgMgr:requestLordData(target, data)
	local playerID = data.playerID
	if playerID == 1000 then
		return
	end
	SoraDShowLoading()
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	_ENV = nil
	;(nil).isFromChat = true
	;(nil).isFromChatSDK = data.isFromChatSDK
	;(nil).SDKSource = data.SDKSource
	;(nil).targetName = self.__cname
	;(nil).isKingdomBattle = data.isKingdomBattle
	lordInfoCtrl:getLordInfoByUid(playerID, nil, nil)
end
function chatMsgMgr:sMsgLordData(target, data)
	SoraDCloseLoading()
	if data.err ~= gErrDef.Err_None then
		return
	end
	if data.clientData and data.lord then
		local isFromChat = data.clientData.isFromChat
		if isFromChat == true then
			SoraDOpenLordView(data.lord)
		end
	end
end
function chatMsgMgr:msgRequesShieldUser(target, data)
	local playerId = data.playerId
	local nickName = data.nickName
	self.currentShieldPlayerId = playerId
	self.currentShieldNickName = nickName
	if not chatCtrl:getShieldList() then
		local chatCtrl, trainList = chatCtrl:getShieldList(), chatCtrl:getShieldList()
	end
	local limitValue = constantRead.getConstValue("BLACKLIST_LIMIT_MAX_MEMBER_NUM")
	chatCtrl = nil
	;(nil).name = nickName
	local strMsg = i18n("common_text_512", nil)
	self.strMsg = strMsg
	if limitValue <= #trainList and IS_BLOCK_USERS_CHAT then
		SoraDShowBuyBox(i18n("block_list_tips_02"), nil, i18n("common_text_204"), handler(self, self.blockNow), nil, nil, nil, nil, nil, i18n("build_gold_lvup_tips_name"), true, false, "chatMsgMgr")
	else
		SoraDShowMsgBox(strMsg, i18n("common_text_054"), i18n("common_text_185"), handler(self, self.confirmShiledUser))
	end
end
function chatMsgMgr:blockNow(eventType)
	if eventType == MSGBOX_CALLBACK_YES then
		SoraDShowMsgBox(self.strMsg, i18n("common_text_054"), i18n("common_text_185"), handler(self, self.confirmShiledUser))
	else
		IS_BLOCK_USERS_CHAT = true
	end
end
function chatMsgMgr:confirmShiledUser(eventType)
	if eventType == MSGBOX_CALLBACK_YES then
		local playerId = self.currentShieldPlayerId
		chatCtrl:shieldUser(playerId)
	end
end
function chatMsgMgr:msgRequestUnShieldUser(target, data)
	local playerId = data.playerId
	local nickName = data.nickName
	chatCtrl:unShieldUser(playerId)
end
function chatMsgMgr:msgRequesForbidUser(target, data)
	local nickName = data.nickName
	self.opType = data.opType
	self.opList = data.opList
	_ENV = nil
	;(nil).name = nickName
	local strMsg = i18n("common_text_1881", nil)
	SoraDShowMsgBox(strMsg, i18n("common_text_054"), i18n("common_text_185"), handler(self, self.confirmForbidUser))
end
function chatMsgMgr:confirmForbidUser(eventType)
	if eventType == MSGBOX_CALLBACK_YES then
		local gametop = gModuleMgr.getObject("gametop")
		local allianceMsg = gametop.playertop_:getModule("allianceMsg")
		allianceMsg:reqOperateShieldList(self.opType, self.opList)
	end
end
function chatMsgMgr:sMsgReqAllianceInfoBack(target, data)
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "chat" then
			SoraDOpenAllianceInfoView(alliance)
		end
	end
end
function chatMsgMgr:sMsgAllianceBeKicked(target, data)
	self.chatDataMgr:cleanAllianceData()
	_ENV = self.chatDataMgr
	self.chatDataMgr.msg = "MESSAGE_ALLIACNE_BE_KICKED_UI"
	SoraDSendMessage(self.chatDataMgr)
	_ENV = self.chatDataMgr
	self.chatDataMgr.msg = "MESSAGE_CHAT_UPDATE_CHAT_BOX"
	self.chatDataMgr.chatChannel = gChatChannel.ALLIANCE
	self.chatDataMgr.chatSet = gChatSet.TOTAL
	SoraDSendMessage(self.chatDataMgr)
end
function chatMsgMgr:sMsgAllianceQuitSuccess(target, data)
	self.chatDataMgr:cleanAllianceData()
	_ENV = self.chatDataMgr
	self.chatDataMgr.msg = "MESSAGE_CHAT_UPDATE_CHAT_BOX"
	self.chatDataMgr.chatChannel = gChatChannel.ALLIANCE
	self.chatDataMgr.chatSet = gChatSet.TOTAL
	SoraDSendMessage(self.chatDataMgr)
	self.chatDataMgr:setGChatChannel(gChatChannel.KINGDOM)
	self.chatDataMgr:saveGChatChannel()
	_ENV = self.chatDataMgr
	self.chatDataMgr.msg = "MESSAGE_CHAT_GO_TO_CHANNEL"
	self.chatDataMgr.channel = gChatChannel.KINGDOM
	SoraDSendMessage(self.chatDataMgr)
end
function chatMsgMgr:sMsgAllianceDismissSuccess(target, data)
	self.chatDataMgr:cleanAllianceData()
	_ENV = self.chatDataMgr
	self.chatDataMgr.msg = "MESSAGE_CHAT_UPDATE_CHAT_BOX"
	self.chatDataMgr.chatChannel = gChatChannel.ALLIANCE
	self.chatDataMgr.chatSet = gChatSet.TOTAL
	SoraDSendMessage(self.chatDataMgr)
	self.chatDataMgr:setGChatChannel(gChatChannel.KINGDOM)
	self.chatDataMgr:saveGChatChannel()
	_ENV = self.chatDataMgr
	self.chatDataMgr.msg = "MESSAGE_CHAT_GO_TO_CHANNEL"
	self.chatDataMgr.channel = gChatChannel.KINGDOM
	SoraDSendMessage(self.chatDataMgr)
end
function chatMsgMgr:msgReqOperateShieldList(target, data)
	self.opType = data.opType
	self.opList = data.opList
	self.targetNickName = data.nickName
	self.targetAbbr = data.abbr
	self.msgID = data.msgID
	local strMsg
	if self.opType == gAShieldListOperate.add then
		if self.opList.aid ~= nil then
			_ENV = nil
			;(nil).name = self.targetAbbr
			strMsg = i18n("common_text_538", nil)
			SoraDShowMsgBox(strMsg, i18n("common_text_054"), i18n("common_text_185"), handler(self, self.confirmOperateShiledListCallBack))
		elseif self.opList.uid ~= nil then
			_ENV = i18n("common_text_054")
			i18n("common_text_054").name = self.targetNickName
			strMsg = i18n("common_text_1881", (i18n("common_text_054")))
			SoraDShowMsgBox(strMsg, i18n("common_text_054"), i18n("common_text_185"), handler(self, self.confirmOperateShiledListCallBack))
		end
	elseif data.opId == chatConst.OpId.OpDeleteMsg then
		strMsg = i18n("alliance_text_50")
		SoraDShowMsgBox(strMsg, i18n("common_text_054"), i18n("common_text_185"), handler(self, self.confirmOperateDeleteMsgCallBack))
	else
		self:confirmOperateShiledListCallBack(MSGBOX_CALLBACK_YES)
	end
end
function chatMsgMgr:confirmOperateShiledListCallBack(eventType)
	if eventType == MSGBOX_CALLBACK_YES then
		local gametop = gModuleMgr.getObject("gametop")
		local allianceMsg = gametop.playertop_:getModule("allianceMsg")
		allianceMsg:reqOperateShieldList(self.opType, self.opList)
	end
end
function chatMsgMgr:confirmOperateDeleteMsgCallBack(eventType)
	if eventType == MSGBOX_CALLBACK_YES then
		local gametop = gModuleMgr.getObject("gametop")
		local allianceMsg = gametop.playertop_:getModule("allianceMsg")
		allianceMsg:reqDeleteAllianceMsg(self.msgID)
	end
end
function chatMsgMgr:sMsgVoiceInvitation(target, data)
	_ENV = nil
	;(nil).msg = "MESSAGE_VOICECHAT_SERVER_NOTICE_INVITEMSG"
	;(nil).redata = data.data
	SoraDSendMessage(nil)
end
return chatMsgMgr
