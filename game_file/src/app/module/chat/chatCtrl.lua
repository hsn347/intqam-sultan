local GameModule = include("GameModule")
local chatCtrl = class("chatCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local chatAuxiliary = include("chatAuxiliary")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local chatDesRead = include("chatDesRead")
local chatAtSelfMgr = include("chatAtSelfMgr")
function chatCtrl:ctor(properties)
	chatCtrl.super.ctor(self, properties)
	self:resetData()
end
function chatCtrl:resetData()
	self.chatAuxiliary = nil
	self.chatAuxiliary = chatAuxiliary.new()
	self.chatStatusType = gChatStatusType.normal
	self.chatAtSelfMgr = chatAtSelfMgr.new()
end
function chatCtrl:Logout()
	chatCtrl.super.Logout(self)
	self.handle_chat_notify = nil
	self:resetData()
	local chatMgrs = include("chatMgrs")
	chatMgrs:removeMessageListener()
end
function chatCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_CHAT_MODULE, gCmd.REQ_INIT_NEWLY_CHATDATA, handler(self, self.getNewlyChatDataRsp))
	msgCtrl.register(gCmd.CMD_CHAT_MODULE, gCmd.REQ_SEND_MESSAGE, handler(self, self.getSendMessageRsp))
	msgCtrl.register(gCmd.CMD_CHAT_MODULE, gCmd.REQ_SEND_SERVICE_MESSAGE, handler(self, self.getSendMessageRsp))
	msgCtrl.register(gCmd.CMD_CHAT_MODULE, gCmd.REQ_CHAT_DATA, handler(self, self.getChatDataRsp))
	msgCtrl.register(gCmd.CMD_CHAT_MODULE, gCmd.REQ_SHIELD_USER, handler(self, self.getShieldUserRsp))
	msgCtrl.register(gCmd.CMD_CHAT_MODULE, gCmd.REQ_UNSHIELD_USER, handler(self, self.getUnShieldUserRsp))
	msgCtrl.register(gCmd.CMD_BEHAVIOUR_MODULE, gCmd.REQ_GET_BEHAVIOUR_DATA, handler(self, self.getBehaviourRsp))
	msgCtrl.register(gCmd.CMD_CHAT_MODULE, gCmd.REQ_INIT_SHIELD_DATA_AND_CHAT_STATUS, handler(self, self.getInitShieldDataAndChatStatusRsp))
	msgCtrl.register(gCmd.CMD_CHAT_MODULE, gCmd.REQ_REPORT_ALLIANCE_CHAT_MSG_STATUS, handler(self, self.getReportAllianceChatMsgStatusRsp))
	msgCtrl.register(gCmd.CMD_CHAT_MODULE, gCmd.REQ_CHAT_SET_DATA, handler(self, self.getChatSetDataRsp))
	msgCtrl.register(gCmd.CMD_CHAT_MODULE, gCmd.REQ_READ_CHAT_MSG, handler(self, self.readChatMsgRsp))
	msgCtrl.register(gCmd.CMD_CHAT_MODULE, gCmd.REQ_CHAT_PROMPT_INFO, handler(self, self.getChatPromptInfoRsp))
	msgCtrl.register(gCmd.CMD_CHAT_MODULE, gCmd.REQ_SHARE_MESSAGE, handler(self, self.shareMessageRsp))
	msgCtrl.register(gCmd.CMD_CHAT_MODULE, gCmd.REQ_GET_VOICE_ROOM_INVITE_INFO, handler(self, self.getVoiceRoomInviteInfoRsp))
	msgCtrl.register(gCmd.CMD_CHAT_MODULE, gCmd.REQ_AGREE_VOICE_ROOM_INVITATION, handler(self, self.agreeVoiceRoomInvitationRsp))
	msgCtrl.register(gCmd.CMD_CHAT_MODULE, gCmd.REQ_REJECT_VOICE_ROOM_INVITATION, handler(self, self.rejectVoiceRoomInvitationRsp))
	msgCtrl.register(gCmd.CMD_CHAT_MODULE, gCmd.REQ_INVITE_USERS_JOIN_VOICE_ROOM, handler(self, self.inviteUsersJoinVoiceRoomRsp))
	msgCtrl.register(gCmd.CMD_CHAT_MODULE, gCmd.REQ_CHAT_REPORT_USER, handler(self, self.chatReportUserRsp))
	msgCtrl.register(gCmd.CMD_CHAT_MODULE, gCmd.REQ_SHARE_POS, handler(self, self.chatSharePosRsp))
	msgCtrl.register(gCmd.CMD_CHAT_MODULE, gCmd.REQ_SEND_MSG_TO_CHAT_CHANNEL, handler(self, self.reqSendTeamMsgRSP))
	msgCtrl.register(gCmd.CMD_CHAT_MODULE, gCmd.REQ_GET_CHAT_CHANNEL_DATA, handler(self, self.reqTeamMsgListRSP))
	local chatMgrs = include("chatMgrs")
	chatMgrs:registerMessageListener()
end
function chatCtrl:initClientData(data)
	if data then
		local version = data.version
		self:setVersion(version)
	end
	self.hasInitRspEventSended = false
	self.initRspNum = 0
	self.initRspTotalNum = 3
	self:updateChatData()
	self:initBehaviour()
	self:initNewlyChatData()
	SoraDGetCtrl("mailCtrl"):reqCoverList(nil, 1)
	self:initShieldDataAndChatStatus()
	self:reqVoiceChatRoomInviteInfo()
end
function chatCtrl:onInitRsp()
	self.initRspNum = self.initRspNum + 1
	if self.initRspNum >= self.initRspTotalNum and not self.hasInitRspEventSended then
		self.hasInitRspEventSended = true
	end
end
function chatCtrl:initShieldDataAndChatStatus(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CHAT_MODULE, gCmd.REQ_INIT_SHIELD_DATA_AND_CHAT_STATUS, nil, ...)
end
function chatCtrl:getInitShieldDataAndChatStatusRsp(respone)
	self.shieldData = respone.data.shieldData
	self.chatStatusType = respone.data.chatStatusType
	self.shieldList = respone.data.shieldList
	self:onInitRsp()
end
function chatCtrl:initBehaviour()
	local msg = self.chatAuxiliary:initBehaviour()
	serverproxy:SendMsg(msg)
end
function chatCtrl:getBehaviourRsp(rep)
	self.behaviourData = rep.data
	self:onInitRsp()
end
_ENV, chatCtrl.updateChatData = function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_chat_notify = notifyCtrl:register(gNotifyID.CHAT, handler(self, self.notifyChatData))
	notifyCtrl:register(gNotifyID.CHAT_STATUS, handler(self, self.notifyChatStatus))
	notifyCtrl:register(gNotifyID.NOTIFY_CHAT_CHANNEL, handler(self, self.onTeamMsg))
end, function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_chat_notify = notifyCtrl:register(gNotifyID.CHAT, handler(self, self.notifyChatData))
	notifyCtrl:register(gNotifyID.CHAT_STATUS, handler(self, self.notifyChatStatus))
	notifyCtrl:register(gNotifyID.NOTIFY_CHAT_CHANNEL, handler(self, self.onTeamMsg))
end
;(function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_chat_notify = notifyCtrl:register(gNotifyID.CHAT, handler(self, self.notifyChatData))
	notifyCtrl:register(gNotifyID.CHAT_STATUS, handler(self, self.notifyChatStatus))
	notifyCtrl:register(gNotifyID.NOTIFY_CHAT_CHANNEL, handler(self, self.onTeamMsg))
end)[gSystemNoticeKingdomMsgTypeDef.legendking_attack_build] = "Game:GameOptionsView:legendMarquee~bool"
;(function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_chat_notify = notifyCtrl:register(gNotifyID.CHAT, handler(self, self.notifyChatData))
	notifyCtrl:register(gNotifyID.CHAT_STATUS, handler(self, self.notifyChatStatus))
	notifyCtrl:register(gNotifyID.NOTIFY_CHAT_CHANNEL, handler(self, self.onTeamMsg))
end)[gSystemNoticeKingdomMsgTypeDef.legendking_first_kill] = "Game:GameOptionsView:legendMarquee~bool"
;(function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_chat_notify = notifyCtrl:register(gNotifyID.CHAT, handler(self, self.notifyChatData))
	notifyCtrl:register(gNotifyID.CHAT_STATUS, handler(self, self.notifyChatStatus))
	notifyCtrl:register(gNotifyID.NOTIFY_CHAT_CHANNEL, handler(self, self.onTeamMsg))
end)[gSystemNoticeKingdomMsgTypeDef.legendking_new_king] = "Game:GameOptionsView:legendMarquee~bool"
;(function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_chat_notify = notifyCtrl:register(gNotifyID.CHAT, handler(self, self.notifyChatData))
	notifyCtrl:register(gNotifyID.CHAT_STATUS, handler(self, self.notifyChatStatus))
	notifyCtrl:register(gNotifyID.NOTIFY_CHAT_CHANNEL, handler(self, self.onTeamMsg))
end)[gSystemNoticeKingdomMsgTypeDef.starking_attack_build] = "Game:GameOptionsView:legendMarquee~bool"
;(function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_chat_notify = notifyCtrl:register(gNotifyID.CHAT, handler(self, self.notifyChatData))
	notifyCtrl:register(gNotifyID.CHAT_STATUS, handler(self, self.notifyChatStatus))
	notifyCtrl:register(gNotifyID.NOTIFY_CHAT_CHANNEL, handler(self, self.onTeamMsg))
end)[gSystemNoticeKingdomMsgTypeDef.starking_first_kill] = "Game:GameOptionsView:legendMarquee~bool"
local _ENV, (function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_chat_notify = notifyCtrl:register(gNotifyID.CHAT, handler(self, self.notifyChatData))
	notifyCtrl:register(gNotifyID.CHAT_STATUS, handler(self, self.notifyChatStatus))
	notifyCtrl:register(gNotifyID.NOTIFY_CHAT_CHANNEL, handler(self, self.onTeamMsg))
end)[gSystemNoticeKingdomMsgTypeDef.starking_new_king], checkSettingKingdomMsgTypeConfig = gSystemNoticeKingdomMsgTypeDef.starking_new_king, "Game:GameOptionsView:legendMarquee~bool", function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_chat_notify = notifyCtrl:register(gNotifyID.CHAT, handler(self, self.notifyChatData))
	notifyCtrl:register(gNotifyID.CHAT_STATUS, handler(self, self.notifyChatStatus))
	notifyCtrl:register(gNotifyID.NOTIFY_CHAT_CHANNEL, handler(self, self.onTeamMsg))
end
gSystemNoticeKingdomMsgTypeDef.starking_new_king[gSystemNoticeKingdomMsgTypeDef.nafu_luky_number] = true
local gSystemNoticeKingdomMsgTypeDef.starking_new_king[gSystemNoticeKingdomMsgTypeDef.nafu_gold_pool_reach], noKingdomMsgTypeConfig = true, gSystemNoticeKingdomMsgTypeDef.starking_new_king
function chatCtrl:notifyChatData(rep)
	local data = rep.data
	local chatTypeUI = gChatTypeUI.kingdom
	dump(data, "chatCtrl:notifyChatData", 5)
	local chatDataParser = include("chatDataParser")
	local _ENV, needNotifyData = "chatDataParser", "chatDataParser"
	local _ENV, chatDataList = "chatCtrl:notifyChatData", "chatCtrl:notifyChatData"
	local addChatDataList = function(chatChannel, chatData)
		if not chatChannel then
			return
		end
		if not chatDataList[chatChannel] then
			chatDataList = chatDataList[chatChannel]
		end
		chatDataList[chatChannel] = chatDataList[chatChannel]
		if not chatDataList[chatChannel][gChatSet.TOTAL] then
			chatDataList = chatDataList[chatChannel][gChatSet.TOTAL]
		end
		chatDataList[chatChannel][gChatSet.TOTAL] = chatDataList[chatChannel][gChatSet.TOTAL]
		if self:isTotalMsg(chatData) then
			table.insert(chatDataList[chatChannel][gChatSet.TOTAL], chatData)
		end
		if self:isNoticeMsg(chatData) then
			if not chatDataList[chatChannel][gChatSet.NOTICE] then
				chatDataList = chatDataList[chatChannel][gChatSet.NOTICE]
			end
			chatDataList[chatChannel][gChatSet.NOTICE] = chatDataList[chatChannel][gChatSet.NOTICE]
			table.insert(chatDataList[chatChannel][gChatSet.NOTICE], chatData)
		end
	end
	for i = 1, #data do
		local singleData = data[i]
		local chatChannel = singleData.chatChannel
		local chatType = singleData.chatType
		if data.chatType == gChatTypeDef.chat_alliance_message or data.chatType == gChatTypeDef.chat_alliance_type then
			chatTypeUI = gChatTypeUI.alliance
		elseif data.chatType == gChatTypeDef.chat_team_message or data.chatType == gChatTypeDef.chat_team_type then
			chatTypeUI = gChatTypeUI.team
		end
		if chatType == gChatTypeDef.chat_send_message_prop or chatType == gChatTypeDef.chat_send_message_gold or chatType == gChatTypeDef.chat_camp_horn then
			if not worldMapDefine.isInLegendLord() or not SoraDConfigGet("Game:GameOptionsView:legendMarquee~bool") then
				local mailFunctions = include("mailFunctions")
				local strName = mailFunctions:getWrappedName(singleData.allianceName, singleData.nickName)
				local contentText = chatDataParser.parseChatContentText(singleData.content)
				_ENV, _ENV = singleData.nickName, singleData.content
				singleData.nickName.name = strName
				singleData.content.content, singleData.nickName.content = singleData.nickName, contentText
				singleData.content.sysNoticeType = gSystemNoticeTypeDef.sys_notice_kingdom_all
				local singleData.content.closeable, noticeData = true, singleData.content
				if chatType == gChatTypeDef.chat_camp_horn then
					noticeData.chatType = chatType
				end
				_ENV = nil
				;(nil).msg = "MESSAGE_SYSTEM_NOTICE_UI_SHOW_NOTICE"
				;(nil).data = noticeData
				SoraDSendMessage(nil)
				table.insert(needNotifyData, #needNotifyData + 1, data[i])
			end
			addChatDataList(chatChannel, singleData)
		elseif chatType == gChatTypeDef.chat_content_system_announcement_scroll then
			local contentText = chatDataParser.parseChatContentText(singleData.content)
			_ENV, _ENV = singleData, singleData.content
			singleData.content.content, singleData.content = singleData, contentText
			local singleData.content.sysNoticeType, noticeData = gSystemNoticeTypeDef.sys_notice_server, singleData.content
			_ENV = singleData.content
			singleData.content.msg = "MESSAGE_SYSTEM_NOTICE_UI_SHOW_NOTICE"
			singleData.content.data = noticeData
			SoraDSendMessage(singleData.content)
		elseif chatType == gChatTypeDef.chat_content_system_announcement_with_scroll then
			local noticeData
			local contentText = chatDataParser.parseChatContentText(singleData.content)
			_ENV, _ENV = singleData.content, singleData.content
			singleData.content.content, singleData.content.content = singleData.content, contentText
			noticeData, singleData.content.sysNoticeType = singleData.content, gSystemNoticeTypeDef.sys_notice_server
			_ENV = gSystemNoticeTypeDef.sys_notice_server
			gSystemNoticeTypeDef.sys_notice_server.msg = "MESSAGE_SYSTEM_NOTICE_UI_SHOW_NOTICE"
			gSystemNoticeTypeDef.sys_notice_server.data = noticeData
			SoraDSendMessage(gSystemNoticeTypeDef.sys_notice_server)
			table.insert(needNotifyData, #needNotifyData + 1, data[i])
			addChatDataList(chatChannel, singleData)
		elseif chatType == gChatTypeDef.chat_content_system_king_msg then
			local kingdomMsgType = singleData.content.kingdomMsgType
			local skipNotice = false
			if kingdomMsgType then
				if noKingdomMsgTypeConfig[kingdomMsgType] then
					skipNotice = true
				else
					local settingStr = checkSettingKingdomMsgTypeConfig[kingdomMsgType]
					if settingStr and SoraDConfigGet(settingStr) then
						skipNotice = true
					elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.marshal_online or kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.marshal_offline then
						local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
						local lordInfo = lordInfoCtrl and lordInfoCtrl:getLordInfo()
						local isMarshal = lordInfo and lordInfo.militaryRankInfo and lordInfo.militaryRankInfo.level >= MILITARY_MAX_LV
						if not isMarshal then
							local militaryRankCtrl = SoraDGetCtrl("militaryRankCtrl")
							if militaryRankCtrl and not militaryRankCtrl:getShowMarshalMarquee() then
								skipNotice = true
							end
						end
					end
				end
			end
			if not skipNotice then
				local contentText = chatDataParser.parseChatContentText(singleData.content)
				local weight = 1
				if kingdomMsgType then
					local noticeCfg = chatDesRead.getChatNoticeCfg(kingdomMsgType)
					if noticeCfg then
						weight = noticeCfg.weight and noticeCfg.weight or 1
					end
				end
				_ENV = noticeCfg
				_ENV, chatDesRead.getChatNoticeCfg(kingdomMsgType).sysContent = singleData.content, singleData.content
				singleData.content.weight = weight
				singleData.content.content = contentText
				chatDesRead.getChatNoticeCfg(kingdomMsgType).content, singleData.content.npcImgId = singleData.content, singleData.content.npcImgId
				chatDesRead.getChatNoticeCfg(kingdomMsgType).kingdomMsgType = kingdomMsgType
				local chatDesRead.getChatNoticeCfg(kingdomMsgType).sysNoticeType, noticeData = gSystemNoticeTypeDef.sys_notice_kingdom_msg, chatDesRead.getChatNoticeCfg(kingdomMsgType)
				_ENV = singleData.content.npcImgId
				singleData.content.npcImgId.msg = "MESSAGE_SYSTEM_NOTICE_UI_SHOW_NOTICE"
				singleData.content.npcImgId.data = noticeData
				SoraDSendMessage(singleData.content.npcImgId)
			end
		else
			if self:isTotalMsg(singleData) then
				table.insert(needNotifyData, #needNotifyData + 1, data[i])
			end
			addChatDataList(chatChannel, singleData)
		end
		if worldMapDefine.isInNebulaAllStar(true) and (chatChannel == gChatChannel.VIEWER or chatChannel == gChatChannel.CAMP) then
			local nebulaAllStarUtil = include("nebulaAllStarUtil")
			nebulaAllStarUtil.sendViewerBarrage(chatChannel, singleData)
		end
		for kClass, v in pairs(worldMapDefine.warBarrageCfg) do
			local barrageCfg = worldMapDefine.getBarrageCfg(kClass)
			if SoraDisInList(chatChannel, barrageCfg.channel) and barrageCfg.showCondition() and singleData.chatType == gChatTypeDef.chat_kingDom_message and not SoraDisInList(singleData.contentType, barrageCfg.ignoreContentType) then
				local text = singleData.content and singleData.content.text
				local textType = singleData.content and singleData.content.textType
				if text and textType == gChatTextType.text_plain then
					_ENV = nil
					;(nil).msg = "MESSAGE_WAR_SHOW_BARRAGE"
					;(nil).text = text
					SoraDSendMessage(nil)
				end
			end
		end
	end
	_ENV = 1
	;(1).initSetData = chatDataList
	self:updateUnreadAtSelfMsg(1)
	for chatChannel, v in pairs(chatDataList) do
		for chatSetType, dataList in pairs(v) do
			_ENV = chatDesRead.getChatNoticeCfg(kingdomMsgType)
			chatDesRead.getChatNoticeCfg(kingdomMsgType).msg = "MESSAGE_CHAT_SERVER_NEW_MESSAGE"
			chatDesRead.getChatNoticeCfg(kingdomMsgType).chatChannel = chatChannel
			chatDesRead.getChatNoticeCfg(kingdomMsgType).chatDataSet = chatSetType
			chatDesRead.getChatNoticeCfg(kingdomMsgType).data = dataList
			SoraDSendMessage((chatDesRead.getChatNoticeCfg(kingdomMsgType)))
		end
	end
end
function chatCtrl:notifyChatStatus(event)
	local data = event.data
	if data then
		for _, msg in pairs(data) do
			self.chatStatusType = msg.chatStatusType
			local notifyMsg = msg.notifyMsg
			if notifyMsg then
				local notifyType = notifyMsg.notifyType
				local notifyData = notifyMsg.notifyData
				if "invited" == notifyType then
					local uid = notifyData.uid
					local roomID = notifyData.roomID
					local nickname = notifyData.nickname
					local allianceAbbr = notifyData.allianceAbbr
					if not self.voiceRoomInviteInfo then
						_ENV = self.voiceRoomInviteInfo
					end
					self.voiceRoomInviteInfo = self.voiceRoomInviteInfo
					self.voiceRoomInviteInfo.inviter = uid
					self.voiceRoomInviteInfo.roomID = roomID
					self.voiceRoomInviteInfo.nickname = nickname
					self.voiceRoomInviteInfo.allianceAbbr = allianceAbbr
					local _ENV, data = self.voiceRoomInviteInfo, self.voiceRoomInviteInfo
					data.msgType = 1
					data.roomId = roomID
					data.alliance = allianceAbbr
					data.inviteUserName = nickname
					data.inviteUserId = uid
					_ENV = nil
					;(nil).msg = "MESSAGE_CHAT_SERVER_SDK_VOICE_INVITATION"
					;(nil).data = data
					SoraDSendMessage(nil)
				elseif "agree" == notifyType then
					local uid = notifyData.uid
					local roomID = notifyData.roomID
					local nickname = notifyData.nickname
					local allianceAbbr = notifyData.allianceAbbr
				elseif "reject" == notifyType then
					local uid = notifyData.uid
					local roomID = notifyData.roomID
					local nickname = notifyData.nickname
					local allianceAbbr = notifyData.allianceAbbr or ""
					_ENV = nil
					;(nil).abbr = allianceAbbr
					;(nil).name = nickname
					SoraDShowMsgTip(i18n("common_text_3981", nil))
				end
			end
		end
	end
end
function chatCtrl:getSendMessageRsp(content)
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_MESSAGE_SEND"
	;(nil).err = content.err
	SoraDSendMessage(nil, content)
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_SERVER_SEND_ONE_MESSAGE_BACK"
	;(nil).content = content
	SoraDSendMessage(nil)
end
function chatCtrl:initNewlyChatData()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_CHAT_MODULE
	;(nil).data, _ENV, (nil).subcmd = gCmd.REQ_INIT_NEWLY_CHATDATA, gCmd.REQ_INIT_NEWLY_CHATDATA, gCmd.REQ_INIT_NEWLY_CHATDATA
	local msg
	serverproxy:SendMsg(msg)
end
function chatCtrl:setVersion(v)
	self.version = v
end
function chatCtrl:getVersion()
	return self.version or gChatVersion.NONE
end
function chatCtrl:getNewlyChatDataRsp(content)
	local data = content.data
	local allianceSurpise = data.allianceSurpise
	local kingdomSurpise = data.kingdomSurpise
	local teamSurpise = data.teamSurpise
	if not data.initSetData then
		local _ENV, _tmpSetData = data.initSetData, data.initSetData
	end
	local chatRedPacketMgr = gChatMgrs:getMgr("chatRedPacketMgr")
	chatRedPacketMgr:setAllianceSurpise(allianceSurpise)
	chatRedPacketMgr:setKingdomSurprise(kingdomSurpise)
	chatRedPacketMgr:setTeamSurprise(teamSurpise)
	print("allianceSurpise, = ", allianceSurpise, ", kingdomSurpise = ", kingdomSurpise)
	local sendMsg = function(chatChannel, chatSetType)
		if _tmpSetData[tostring(chatChannel)] and _tmpSetData[tostring(chatChannel)][chatSetType] then
			local data = _tmpSetData[tostring(chatChannel)][chatSetType]
			if data and type(data) ~= "table" then
				return
			end
			if not data or not data.list then
				local _tmpSetData, list = data.list, data.list
			end
			if list and 0 < #list then
				table.sort(list, function(l, r)
					return l.date < r.date
				end)
			end
			local more = data.more
			function _tmpSetData(l, r)
				return l.date < r.date
			end
			;(function(l, r)
				return l.date < r.date
			end).msg = "MESSAGE_CHAT_SERVER_LOAD_SUCCESS"
			;(function(l, r)
				return l.date < r.date
			end).isLogin = true
			;(function(l, r)
				return l.date < r.date
			end).chatChannel = chatChannel
			;(function(l, r)
				return l.date < r.date
			end).data = list
			;(function(l, r)
				return l.date < r.date
			end).chatDataSet = chatSetType
			;(function(l, r)
				return l.date < r.date
			end).requestId = ""
			;(function(l, r)
				return l.date < r.date
			end).direction = gDirection.FORWARD
			;(function(l, r)
				return l.date < r.date
			end).more = more
			SoraDSendMessage(function(l, r)
				return l.date < r.date
			end)
		else
		end
	end
	sendMsg(gChatChannel.KINGDOM, gChatSet.TOTAL)
	sendMsg(gChatChannel.KINGDOM, gChatSet.NOTICE)
	sendMsg(gChatChannel.ALLIANCE, gChatSet.TOTAL)
	sendMsg(gChatChannel.ALLIANCE, gChatSet.NOTICE)
	sendMsg(gChatChannel.TEAM, gChatSet.TOTAL)
	sendMsg(gChatChannel.TEAM, gChatSet.NOTICE)
	sendMsg(gChatChannel.CAMP, gChatSet.TOTAL)
	sendMsg(gChatChannel.CAMP, gChatSet.NOTICE)
	sendMsg(gChatChannel.VIEWER, gChatSet.TOTAL)
	sendMsg(gChatChannel.VIEWER, gChatSet.NOTICE)
	self:initUnreadAtSelfMsg(data)
	self:onInitRsp()
end
function chatCtrl:getChatDataRsp(content)
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_DATA"
	;(nil).err = content.err
	;(nil).data = content.data
	;(nil).chatTypeUI = gChatTypeUI.kingdom
	SoraDSendMessage(nil, content)
end
function chatCtrl:getShieldUserRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local data = content.data
		self.shieldData = data
		self.shieldList = content.shieldList
		_ENV = nil
		;(nil).msg = "MESSAGE_CHAT_SHIELD_USER"
		;(nil).err = content.err
		;(nil).data = data
		SoraDSendMessage(nil, content)
	end
end
function chatCtrl:getUnShieldUserRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local data = content.data
		self.shieldData = data
		self.shieldList = content.shieldList
		_ENV = nil
		;(nil).msg = "MESSAGE_CHAT_UNSHIELD_USER"
		;(nil).err = content.err
		;(nil).data = data
		SoraDSendMessage(nil, content)
	end
end
function chatCtrl:reportAllianceChatMsgStatus(msg, status, ...)
	serverproxy = nil
	local (nil).msg, data = msg, nil
	msg.status = status
	serverproxy:Request(gCmd.CMD_CHAT_MODULE, gCmd.REQ_REPORT_ALLIANCE_CHAT_MSG_STATUS, data, ...)
end
function chatCtrl:getReportAllianceChatMsgStatusRsp(rsp)
	if rsp.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_CHAT_REPORT_ALLIANCE_CHAT_MSG_STATUS_SUCCESS"
		gErrDef.Err_None.data = rsp.data
		SoraDSendMessage(gErrDef.Err_None)
	else
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_CHAT_REPORT_ALLIANCE_CHAT_MSG_STATUS_FAIL"
		gErrDef.Err_None.err = rsp.err
		gErrDef.Err_None.data = rsp.data
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function chatCtrl:getChatSetDataRsp(rsp)
	local rspData = rsp.data
	local list = rspData.list
	local more = rspData.more
	local requireID = rspData.requireID
	local chatSetType = rspData.chatSetType
	local channel = rspData.channel
	local direction = rspData.direction
	if gErrDef.Err_None == rsp.err then
		if list and 0 < #list then
			table.sort(list, function(l, r)
				if l.date ~= r.date then
					return l.date < r.date
				end
				return l.msgID < r.msgID
			end)
		end
		_ENV = list
		list.msg = "MESSAGE_CHAT_SERVER_LOAD_SUCCESS"
		list.chatChannel = channel
		list.data = list
		list.chatDataSet = chatSetType
		list.requestId = requireID
		list.direction = direction
		list.more = more
		SoraDSendMessage(list)
	else
		_ENV = list
		list.msg = "MESSAGE_CHAT_SERVER_LOAD_SUCCESS"
		list.data, _ENV, list.chatChannel = function(l, r)
			if l.date ~= r.date then
				return l.date < r.date
			end
			return l.msgID < r.msgID
		end, function(l, r)
			if l.date ~= r.date then
				return l.date < r.date
			end
			return l.msgID < r.msgID
		end, channel
		list.chatDataSet = chatSetType
		list.requestId = requireID
		list.direction = direction
		list.more = false
		SoraDSendMessage(list)
	end
end
function chatCtrl:readChatMsg(chatChannel, msgID)
	print("chatCtrl:readChatMsg", chatChannel, msgID)
	_ENV = print
	print.chatChannel = chatChannel
	local print.msgID, data = msgID, print
	serverproxy:Request(gCmd.CMD_CHAT_MODULE, gCmd.REQ_READ_CHAT_MSG, data)
end
function chatCtrl:readChatMsgRsp(rsp)
	local data = rsp.data
	if gErrDef.Err_None == rsp.err then
	end
end
function chatCtrl:getChatPromptInfo(chatChannel)
	serverproxy = nil
	local (nil).chatChannel, data = chatChannel, nil
	serverproxy:Request(gCmd.CMD_CHAT_MODULE, gCmd.REQ_CHAT_PROMPT_INFO, data)
end
function chatCtrl:getChatPromptInfoRsp(rsp)
	if gErrDef.Err_None == rsp.err then
		local rspData = rsp.data
		local chatChannel = rspData.chatChannel
		local lastReadMsgID, unreadMsgCount, redPacketFlag, redEnvelopesType
		if gChatChannel.KINGDOM == chatChannel then
			lastReadMsgID = rspData.kLastReadMsgID
			unreadMsgCount = rspData.kUnreadMsgCount
			redPacketFlag = rspData.kRedPacketFlag
			redEnvelopesType = rspData.kRedEnvelopesType
		elseif gChatChannel.ALLIANCE == chatChannel then
			lastReadMsgID = rspData.aLastReadMsgID
			unreadMsgCount = rspData.aUnreadMsgCount
			redPacketFlag = rspData.aRedPacketFlag
			redEnvelopesType = rspData.kRedEnvelopesType
		end
		_ENV = nil
		;(nil).msg = "MESSAGE_CHAT_SERVER_UN_READ_BACK"
		;(nil).channel = chatChannel
		;(nil).chatId = lastReadMsgID
		;(nil).num = unreadMsgCount
		;(nil).hasRedPacket = redPacketFlag
		;(nil).redEnvelopesType = redEnvelopesType
		SoraDSendMessage(nil)
	end
end
function chatCtrl:share(chatChannel, shareType, shareData)
	serverproxy = nil
	;(nil).chatChannel = chatChannel
	;(nil).shareType = shareType
	local (nil).shareData, data = shareData, nil
	serverproxy:Request(gCmd.CMD_CHAT_MODULE, gCmd.REQ_SHARE_MESSAGE, data)
end
function chatCtrl:shareMessageRsp(rsp)
	local err = rsp.err
	local rspData = rsp.data
	if gErrDef.Err_None == err then
		SoraDShowMsgTip(i18n("notice_0103"))
	elseif gErrDef.Err_CLIENT_EXCEPTION == err then
		SoraDShowMsgTip(i18n("common_text_2549"))
	end
end
function chatCtrl:getChatSetData(chatChannel, chatSetType, startID, count, direction, requireID)
	serverproxy = nil
	;(nil).channel = chatChannel
	;(nil).chatSetType = chatSetType
	;(nil).startID = startID
	;(nil).count = count
	;(nil).direction = direction
	local (nil).requireID, data = requireID, nil
	serverproxy:Request(gCmd.CMD_CHAT_MODULE, gCmd.REQ_CHAT_SET_DATA, data)
end
function chatCtrl:sendAllianceMessage(message, messageType)
	local msg = self.chatAuxiliary:sendMessageByType(gChatTypeDef.chat_alliance_type, message, messageType)
	serverproxy:SendMsg(msg)
end
function chatCtrl:sendTeamMessage(message, messageType)
	local msg = self.chatAuxiliary:sendMessageByType(gChatTypeDef.chat_team_type, message, messageType)
	serverproxy:SendMsg(msg)
end
function chatCtrl:sendKingDomMessage(message, messageType)
	local msg = self.chatAuxiliary:sendMessageByType(gChatTypeDef.chat_kingDom_type, message, messageType)
	serverproxy:SendMsg(msg)
	print("发送完毕")
end
function chatCtrl:requestAllianceChatData(number)
	local err = self.chatAuxiliary:validateNumber(number)
	if err == gErrDef.Err_None then
		local msg = self.chatAuxiliary:requestChatDataByType(gChatTypeDef.chat_alliance_type, number)
		serverproxy:SendMsg(msg)
	end
	return err
end
function chatCtrl:requestKingDomChatData(number)
	local err = self.chatAuxiliary:validateNumber(number)
	if err == gErrDef.Err_None then
		local msg = self.chatAuxiliary:requestChatDataByType(gChatTypeDef.chat_kingDom_type, number)
		serverproxy:SendMsg(msg)
	end
	return err
end
function chatCtrl:sendCampMessage(message, messageType)
	local msg = self.chatAuxiliary:sendMessageByType(gChatTypeDef.chat_camp_type, message, messageType)
	serverproxy:SendMsg(msg)
end
function chatCtrl:sendCampHornMessage(message, messageType)
	local msg = self.chatAuxiliary:sendMessageByType(gChatTypeDef.chat_camp_horn, message, messageType)
	serverproxy:SendMsg(msg)
end
function chatCtrl:sendMessageByType(chatType, message, messageType)
	local msg = self.chatAuxiliary:sendMessageByType(chatType, message, messageType)
	serverproxy:SendMsg(msg)
end
function chatCtrl:shieldUser(uid)
	local msg = self.chatAuxiliary:shieldUserByType(uid)
	serverproxy:SendMsg(msg)
end
function chatCtrl:unShieldUser(uid)
	local msg = self.chatAuxiliary:unShieldUserByType(uid)
	serverproxy:SendMsg(msg)
end
function chatCtrl:sendServiceMessageByProp(message)
	local msg = self.chatAuxiliary:sendServiceMessage(gChatTypeDef.chat_send_message_prop, message)
	serverproxy:SendMsg(msg)
end
function chatCtrl:sendServiceMessageByGold(message)
	local msg = self.chatAuxiliary:sendServiceMessage(gChatTypeDef.chat_send_message_gold, message)
	serverproxy:SendMsg(msg)
end
function chatCtrl:getChatChannel()
	if self.behaviourData then
		_UPVALUE0_ = nil
		if self.behaviourData ~= nil then
			return self.behaviourData.chatChannel
	end
	else
		return 0
	end
end
function chatCtrl:setChatChannel(chatChannel)
	print("chatCtrl:setChatChannel(chatChannel)", chatChannel)
	local msg = self.chatAuxiliary:setChatChannel(chatChannel)
	serverproxy:SendMsg(msg)
end
function chatCtrl:getAllianceShield()
	if self.shieldData then
		return self.shieldData
	end
end
function chatCtrl:isShield(uid)
	local flag = false
	if self.shieldData and next(self.shieldData) ~= nil and self.shieldData[tostring(uid)] then
		flag = true
	end
	return flag
end
function chatCtrl:canChat()
	return self.chatStatusType == gChatStatusType.normal
end
_ENV, chatCtrl.getShieldList = function(self)
	if not self.shieldList then
		_UPVALUE0_ = self.shieldList
	end
	return self.shieldList
end, function(self)
	if not self.shieldList then
		_UPVALUE0_ = self.shieldList
	end
	return self.shieldList
end
;(function(self)
	if not self.shieldList then
		_UPVALUE0_ = self.shieldList
	end
	return self.shieldList
end)[gChatTypeDef.chat_content_equip_create] = true
;(function(self)
	if not self.shieldList then
		_UPVALUE0_ = self.shieldList
	end
	return self.shieldList
end)[gChatTypeDef.chat_content_eliminateGame_share] = true
;(function(self)
	if not self.shieldList then
		_UPVALUE0_ = self.shieldList
	end
	return self.shieldList
end)[gChatTypeDef.chat_content_starsWishGame_share] = true
;(function(self)
	if not self.shieldList then
		_UPVALUE0_ = self.shieldList
	end
	return self.shieldList
end)[gChatTypeDef.chat_alliance_sys_message] = true
;(function(self)
	if not self.shieldList then
		_UPVALUE0_ = self.shieldList
	end
	return self.shieldList
end)[gChatTypeDef.chat_kingDom_sys_message] = true
;(function(self)
	if not self.shieldList then
		_UPVALUE0_ = self.shieldList
	end
	return self.shieldList
end)[gChatTypeDef.chat_content_system_announcement_with_scroll] = true
;(function(self)
	if not self.shieldList then
		_UPVALUE0_ = self.shieldList
	end
	return self.shieldList
end)[gChatTypeDef.chat_content_system_king_msg] = true
;(function(self)
	if not self.shieldList then
		_UPVALUE0_ = self.shieldList
	end
	return self.shieldList
end)[gChatTypeDef.chat_content_system_new_king] = true
local _ENV, (function(self)
	if not self.shieldList then
		_UPVALUE0_ = self.shieldList
	end
	return self.shieldList
end)[gChatTypeDef.chat_content_system_control_king_castle], chatContentTypeConfig = gChatTypeDef.chat_content_system_control_king_castle, true, function(self)
	if not self.shieldList then
		_UPVALUE0_ = self.shieldList
	end
	return self.shieldList
end
local _ENV, gChatTypeDef.chat_content_system_control_king_castle[gChatTypeDef.chat_content_pyramid_share], notChatContentTypeConfig = gChatTypeDef.chat_content_pyramid_share, true, gChatTypeDef.chat_content_system_control_king_castle
gChatTypeDef.chat_content_pyramid_share[gChatTypeDef.chat_alliance_type] = true
local _ENV, gChatTypeDef.chat_content_pyramid_share[gChatTypeDef.chat_alliance_sys_message], chatSysTypeConfig = gChatTypeDef.chat_alliance_sys_message, true, gChatTypeDef.chat_content_pyramid_share
gChatTypeDef.chat_alliance_sys_message[gChatSysMsgType.boss_rally] = true
local _ENV, gChatTypeDef.chat_alliance_sys_message[gChatSysMsgType.player_rally], noChatTypeInContentConfig = gChatSysMsgType.player_rally, true, gChatTypeDef.chat_alliance_sys_message
local gChatSysMsgType.player_rally[gSystemNoticeKingdomMsgTypeDef.open_escort_buff_kingdom], notKingdomMsgTypeConfig = true, gChatSysMsgType.player_rally
function chatCtrl:isNoticeMsg(chatData)
	if chatData and chatData.content then
		if chatData.content.chatSysMsgType and noChatTypeInContentConfig[chatData.content.chatSysMsgType] then
			local isHeroBoss = false
			local values = chatData.content.values
			if type(values) == "table" and (values.bossType == gBossType.heroBattleBoss1 or values.bossType == gBossType.heroBattleBoss2) then
				isHeroBoss = true
			end
			if not isHeroBoss then
				return false
			end
		end
		if chatData.content.kingdomMsgType and notKingdomMsgTypeConfig[chatData.content.kingdomMsgType] then
			return false
		end
	end
	if notChatContentTypeConfig[chatData.contentType] then
		return false
	end
	if chatContentTypeConfig[chatData.contentType] then
		return true
	end
	if chatData.sysType and chatSysTypeConfig[chatData.sysType] then
		return true
	end
	return false
end
function chatCtrl:isTotalMsg(chatData)
	if chatData and chatData.content then
		if chatData.content.chatSysMsgType == gChatSysMsgType.alliance_treasure then
			return false
		end
		if chatData.content.chatSysMsgType == gChatSysMsgType.boss_rally then
			local values = chatData.content.values
			if type(values) == "table" and (values.bossType == gBossType.heroBattleBoss1 or values.bossType == gBossType.heroBattleBoss2) then
				return false
			end
		end
	end
	return true
end
function chatCtrl:getVoiceChatRoomInviteInfo()
	return self.voiceRoomInviteInfo
end
function chatCtrl:inviteUsersJoinVoiceRoom(roomID, userList)
	serverproxy = nil
	;(nil).roomID = roomID
	;(nil).userList = userList
	serverproxy:Request(gCmd.CMD_CHAT_MODULE, gCmd.REQ_INVITE_USERS_JOIN_VOICE_ROOM, nil)
end
function chatCtrl:reqVoiceChatRoomInviteInfo()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CHAT_MODULE, gCmd.REQ_GET_VOICE_ROOM_INVITE_INFO, nil)
end
function chatCtrl:agreeInvitation(inviter, roomID)
	serverproxy = nil
	;(nil).inviter = inviter
	;(nil).roomID = roomID
	serverproxy:Request(gCmd.CMD_CHAT_MODULE, gCmd.REQ_AGREE_VOICE_ROOM_INVITATION, nil)
end
function chatCtrl:rejectInvitation(inviter, roomID)
	serverproxy = nil
	;(nil).inviter = inviter
	;(nil).roomID = roomID
	serverproxy:Request(gCmd.CMD_CHAT_MODULE, gCmd.REQ_REJECT_VOICE_ROOM_INVITATION, nil)
end
function chatCtrl:chatReportUser(uid)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_CHAT_MODULE, gCmd.REQ_CHAT_REPORT_USER, nil)
end
function chatCtrl:chatSharePos(chatChannel, mapId, mapType, subMapType, x, y, name, targetUid, crid)
	serverproxy = nil
	;(nil).chatChannel = chatChannel
	;(nil).mapId = mapId
	;(nil).mapType = mapType
	;(nil).subMapType = subMapType
	;(nil).x = x
	;(nil).y = y
	;(nil).name = name
	;(nil).targetUid = targetUid
	local (nil).crid, data = crid, nil
	serverproxy:Request(gCmd.CMD_CHAT_MODULE, gCmd.REQ_SHARE_POS, data)
end
function chatCtrl:getVoiceRoomInviteInfoRsp(rsp)
	if gErrDef.Err_None == rsp.err then
		self.voiceRoomInviteInfo = rsp.data.data
	end
end
function chatCtrl:agreeVoiceRoomInvitationRsp(rsp)
	if gErrDef.Err_None == rsp.err then
		self.voiceRoomInviteInfo = nil
	end
end
function chatCtrl:rejectVoiceRoomInvitationRsp(rsp)
	if gErrDef.Err_None == rsp.err then
		self.voiceRoomInviteInfo = nil
	end
end
function chatCtrl:inviteUsersJoinVoiceRoomRsp(rsp)
	if gErrDef.Err_None == rsp.err then
	end
end
function chatCtrl:chatReportUserRsp(rsp)
	dump(rsp, "chatCtrl:chatReportUserRsp", 5)
	if gErrDef.Err_None == rsp.err then
	end
end
function chatCtrl:chatSharePosRsp(rsp)
	dump(rsp, "chatCtrl:chatSharePosRsp", 5)
	if gErrDef.Err_None == rsp.err and rsp.data.chatChannel == gChatChannel.MAIL then
		local contactCtrl = SoraDGetCtrl("contactCtrl")
		local friendList = contactCtrl:getContactList()
		local allianceAbbr = ""
		local nickName = ""
		for k, v in pairs(friendList) do
			if rsp.data.targetUid == tonumber(k) then
				allianceAbbr = v.allianceAbbr
				nickName = v.name
			end
		end
		_ENV = (for generator)
		pairs(friendList).targetType = gMailType.CHAT
		pairs(friendList).target = rsp.data.targetUid
		pairs(friendList).nickName = nickName
		local pairs(friendList).allianceAbbr, data = allianceAbbr, pairs(friendList)
		local panel = SoraDCreateChatView(data)
	end
end
function chatCtrl:reqSendTeamMsg(content)
	dump(content, "==chatCtrl:reqSendTeamMsg==")
	local teamType = content.teamType
	local teamCtrl = SoraDGetCtrl("teamCtrl")
	local myTeamInfo = teamCtrl:getTeamData(teamType)
	local channelID = content.channelId or myTeamInfo:getChannelID()
	local _ENV, data = myTeamInfo, myTeamInfo
	data.channelID = channelID
	data.content = content
	serverproxy:Request(gCmd.CMD_CHAT_MODULE, gCmd.REQ_SEND_MSG_TO_CHAT_CHANNEL, data)
end
function chatCtrl:reqSendTeamMsgRSP(event)
	local err = event.err
	if err == gErrDef.Err_None then
	else
	end
end
function chatCtrl:reqTeamMsgList(msgId, size, channelID, teamId, reqFlag)
	local serverproxy, data
	data.channelID = channelID
	data.from = msgId
	data.size = size
	data.reqFlag = reqFlag
	serverproxy = nil
	;(nil).teamId = teamId
	serverproxy:Request(gCmd.CMD_CHAT_MODULE, gCmd.REQ_GET_CHAT_CHANNEL_DATA, data, nil)
end
function chatCtrl:reqTeamMsgListRSP(event)
	SoraDCloseLoading()
	local err = event.err
	if err == gErrDef.Err_None then
		local retdata = event.rspdata
		self:sMsgHistoryTeamMsg(retdata, event.clientData)
	end
end
function chatCtrl:sMsgHistoryTeamMsg(data, clientData)
	local more = data.more
	local chatChannel = gChatChannel.TEAMMSG
	local chatDataSet = gChatSet.TOTAL
	local teamId = clientData.teamId
	local key = self:getTeamMsgChatKey(chatChannel, chatDataSet, teamId)
	if not data.msgs then
		local _ENV, teamMsgList = data.msgs, data.msgs
	end
	_ENV = chatChannel
	chatChannel.msg = "MESSAGE_CHAT_SERVER_LOAD_SUCCESS"
	chatChannel.data = teamMsgList
	chatChannel.chatChannel = chatChannel
	chatChannel.chatDataSet = chatDataSet
	chatChannel.key = key
	chatChannel.more = more
	chatChannel.target = teamId
	local chatChannel.isNeedScroll, param = false, chatChannel
	SoraDSendMessage(param)
	self:checkNewTeamMsg(data)
end
function chatCtrl:onTeamMsg(event)
	local data = event.data
	if data then
		for _, msg in pairs(data) do
			if msg.notifyType == "NEW_MSG" then
				self:addNewTeamMsg(msg.msg)
			end
		end
	end
end
function chatCtrl:addNewTeamMsg(data)
	local newMsg = data
	local sender = data.sender
	if not sender.userInfo then
		local gametop, userInfo = sender.userInfo, sender.userInfo
	end
	local playerId = userInfo.uid
	local isNeedScroll = false
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	if lordInfoCtrl ~= nil and lordInfoCtrl:getLordInfo() and lordInfoCtrl:getLordInfo().base ~= nil and lordInfoCtrl:getLordInfo().base.uid ~= nil and lordInfoCtrl:getLordInfo().base.uid == playerId then
		isNeedScroll = true
	end
	local chatChannel = gChatChannel.TEAMMSG
	local chatDataSet = gChatSet.TOTAL
	local teamType = data.content.teamType
	local teamCtrl = SoraDGetCtrl("teamCtrl")
	local myTeamInfo = teamCtrl:getTeamData(teamType)
	local teamId = myTeamInfo:getTeamID()
	local key = self:getTeamMsgChatKey(chatChannel, chatDataSet, teamId)
	gametop = self
	_ENV, self.msg = chatChannel, "MESSAGE_CHAT_SERVER_NEW_MESSAGE"
	self.data, chatChannel[1] = chatChannel, newMsg
	self.chatChannel = chatChannel
	self.chatDataSet = chatDataSet
	self.key = key
	self.target = teamId
	local self.isNeedScroll, param = isNeedScroll, self
	SoraDSendMessage(param)
	myTeamInfo:setHasNewTeamMsg(true)
end
function chatCtrl:checkNewTeamMsg(data)
	if not data.msgs then
		local _ENV, teamMsgList = data.msgs, data.msgs
	end
	local lastMsg = teamMsgList[#teamMsgList]
	if lastMsg ~= nil then
		local teamCtrl = SoraDGetCtrl("teamCtrl")
		local teamType = lastMsg.content.teamType
		local myTeamInfo = teamCtrl:getTeamData(teamType)
		if data.reqFlag == 1 then
			myTeamInfo:checkIsNewMsg(lastMsg.time)
		else
			myTeamInfo:updateLastMsgTime(lastMsg.time)
		end
	end
end
function chatCtrl:getTeamMsgChatKey(chatChannel, chatSet, allianceId)
	return string.format("%d_%d_%s", chatChannel, chatSet, tostring(allianceId))
end
function chatCtrl:initUnreadAtSelfMsg(...)
	return self.chatAtSelfMgr:initAllianceMsg(...)
end
function chatCtrl:updateUnreadAtSelfMsg(...)
	return self.chatAtSelfMgr:updateAllianceMsg(...)
end
function chatCtrl:checkUnreadAtSelfChannel(...)
	return self.chatAtSelfMgr:checkUnreadAtSelfChannel(...)
end
function chatCtrl:getUnreadAtSelfMsg(chatChannel, ...)
	local chatAtSelfMgr = self:getChatAtSelfMgr(chatChannel, ...)
	return chatAtSelfMgr:getUnreadAtSelfMsg(chatChannel, ...)
end
function chatCtrl:getUnreadAtSelfUserList(chatChannel, crid, needReset)
	local chatAtSelfMgr = self:getChatAtSelfMgr(chatChannel)
	return chatAtSelfMgr:getUnreadAtSelfUserList(chatChannel, crid, needReset)
end
function chatCtrl:cleanUnreadAtSelfUserList(chatChannel, crid)
	local chatAtSelfMgr = self:getChatAtSelfMgr(chatChannel)
	return chatAtSelfMgr:cleanAtSelfUserList(chatChannel, crid)
end
function chatCtrl:getChatAtSelfMgr(chatChannel)
	if chatChannel == gChatChannel.CHATROOM then
		local chatroomCtrl = SoraDGetCtrl("chatroomCtrl")
		return chatroomCtrl:getChatAtSelfMgr()
	else
		return self.chatAtSelfMgr
	end
end
return chatCtrl
