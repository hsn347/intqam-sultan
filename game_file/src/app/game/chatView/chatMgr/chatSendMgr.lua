local chatBaseMgr = include("chatBaseMgr")
local chatSendMgr = class("chatSendMgr", chatBaseMgr)
local schedulerTime = require(cc.PACKAGE_NAME .. ".scheduler")
local gametop = gModuleMgr.getObject("gametop")
local chatCtrl = gametop.playertop_:getModule("chatCtrl")
local mailCtrl = gametop.playertop_:getModule("mailCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local chatFunctions = include("chatFunctions")
local chatConst = include("chatConst")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local mailFunctions = include("mailFunctions")
local chatDataParser = include("chatDataParser")
local chatDataModuleAPI = include("chatDataModuleAPI")
function chatSendMgr:init()
	self.chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
	self.chatMsgMgr = gChatMgrs:getMgr("chatMsgMgr")
	self.chatAudioMgr = gChatMgrs:getMgr("chatAudioMgr")
	self.chatTranslateMgr = gChatMgrs:getMgr("chatTranslateMgr")
	self.deltaCheckSendTime = 5
	self:reset()
end
function chatSendMgr:reset()
	self.sendData, _ENV, self.tblReportMsgData, _ENV, self.tblSendInterval, _ENV, self.chatIndex = nil, nil, nil, nil, nil, nil, 0
	if self.sendTimer then
		for _, v in ipairs(self.sendTimer) do
			schedulerTime.unscheduleGlobal(v)
		end
	end
	self.sendTimer, _ENV = ipairs(self.sendTimer)
end
function chatSendMgr:clean()
	self:reset()
end
function chatSendMgr:getNewChatIndex()
	self.chatIndex = self.chatIndex + 1
	return self.chatIndex
end
function chatSendMgr:checkIntervalTime(chatIntervalType)
	local curTime = os.time()
	local preTime = self.tblSendInterval[chatIntervalType]
	if chatIntervalType == nil then
		return false
	end
	if preTime == nil then
		self.tblSendInterval[chatIntervalType] = curTime
		return true
	elseif curTime - preTime >= gChatSendInterval[chatIntervalType] then
		self.tblSendInterval[chatIntervalType] = curTime
		return true
	else
		if chatIntervalType == gChatSendIntervalType.kingdomEmotion or chatIntervalType == gChatSendIntervalType.allianceEmotion or chatIntervalType == gChatSendIntervalType.teamEmotion then
			SoraDShowMsgTip(i18n("common_text_509"), "#icon_mail_lock.png")
		else
			SoraDShowMsgTip(i18n("common_text_508"), "#icon_mail_lock.png")
		end
		return false
	end
end
function chatSendMgr:checkReportMsg(chatId)
	local curTime = os.time()
	local preTime = self.tblReportMsgData.lastTime
	if preTime == nil then
		self.tblReportMsgData.lastTime = curTime
		self.tblReportMsgData[chatId] = chatId
		return true
	elseif self.tblReportMsgData[chatId] then
		SoraDShowMsgTip(i18n("common_text_1454"))
		return false
	elseif curTime - preTime >= gChatSendInterval.reportMsg then
		self.tblReportMsgData.lastTime = curTime
		self.tblReportMsgData[chatId] = chatId
		return true
	else
		SoraDShowMsgTip(i18n("common_text_1455"))
		return false
	end
end
function chatSendMgr:sendMsgTimeOutManage(index, curChatChannel, chatSet, key)
	local timeHandle = schedulerTime.performWithDelayGlobal(function(dt)
		self:sendMsgTimeOut(dt)
	end, self.deltaCheckSendTime)
	schedulerTime = nil
	;(nil).chatIndex = index
	;(nil).chatChannel = curChatChannel
	;(nil).chatSet = chatSet
	;(nil).key = key
	table.insert(self.sendData, nil)
	table.insert(self.sendTimer, timeHandle)
end
function chatSendMgr:sendMsgTimeOut(dt)
	if #self.sendData <= 0 then
		return
	end
	local dataItem = self.sendData[1]
	local chatChannel = dataItem.chatChannel
	local chatSet = dataItem.chatSet or gChatSet.TOTAL
	local key = dataItem.key
	local curItemData = self.chatDataMgr:getData(chatChannel, chatSet, key)
	if not curItemData then
		return
	end
	for _, v in ipairs(curItemData) do
		if v.chatIndex and dataItem.chatIndex == v.chatIndex then
			if v.netStatus == gChatNetStatus.sending then
				v.netStatus = gChatNetStatus.warn_sending
				if v.itemNode and v.itemNode.updateNetStatus then
					v.itemNode:updateNetStatus()
				end
			end
			break
		end
	end
	if #self.sendData > 0 then
		table.remove(self.sendData, 1)
		table.remove(self.sendTimer, 1)
	end
end
function chatSendMgr:createSendingMessage(param)
	local chatChannel = param.chatChannel
	local packetId = param.packetId
	local messageType = param.messageType
	local message = param.message
	local chatIndex = param.chatIndex
	local chatSet = param.chatSet or gChatSet.TOTAL
	local alv = param.alv
	dump(param, "chatSendMgr:createSendingMessage(param)")
	print("生成新的消息，新的消息索引:" .. chatIndex)
	local vipDetail = lordInfoCtrl:getVipDetails()
	local isVipActivated = vipDetail.isActivated
	local vipLv = vipDetail.level
	_ENV = nil
	;(nil).translateContent = " this is translate content, you should not see this"
	;(nil).itemNode = nil
	;(nil).itemWidth = 0
	;(nil).itemHeight = 0
	;(nil).itemPosX = 0
	local (nil).itemPosY, localData = 0, nil
	localData.playerId = chatFunctions:getSelfId()
	localData.imageId = chatFunctions:getSelfImageId()
	localData.avatarUrl = chatFunctions:getSelfAvatar()
	localData.netStatus = gChatNetStatus.sending
	localData.align = SoraDFIsRA() and 0 or 1
	localData.nickName = chatFunctions:getSelfNickName()
	localData.isSysMsg = false
	localData.isSelf = true
	localData.sysType = 0
	localData.vipLv = vipLv
	localData.isKNotice = false
	localData.content = message
	localData.chatIndex = chatIndex
	localData.alv = alv
	localData.isKing = chatFunctions:getIsSelfKing()
	localData.isLegendKing = chatFunctions:getIsSelfLegendKing()
	localData.isLegendForSepKing = chatFunctions:getIsSelfKingStar()
	localData.isHegemon = chatFunctions:getIsSelfHegemon()
	local accountExtCtrl = gametop.playertop_:getModule("accountExtCtrl")
	localData.isGM = accountExtCtrl:getIsGM()
	local chatSkinRead = include("chatSkinRead")
	local dressCtrl = gametop.playertop_:getModule("dressCtrl")
	local dressBubbleId = dressCtrl:getCurDressID(gDressType.CHAT_TEXT_FRAME)
	local dressAvatarFrameId = dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_FRAME)
	local dressHeadWearId = dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_CROWN)
	localData.bubbleId = dressBubbleId and chatSkinRead.getBubbleIDByCid(dressBubbleId) or gBubbleId.BUBBLE_ID_NORMAL
	localData.avatarFrameId = dressAvatarFrameId and chatSkinRead.getHeadIDByCid(dressAvatarFrameId) or gAvatarFrameId.AVATAR_FRAME_ID_NORMAL
	localData.headWearId = dressHeadWearId and chatSkinRead.getHeadWearIDByCid(dressHeadWearId) or gHeadWearId.HEAD_ID_NORMAL
	if localData.bubbleId == gBubbleId.BUBBLE_ID_NORMAL then
	end
	if localData.isKing == true and localData.headWearId == gHeadWearId.HEAD_ID_NORMAL then
		localData.headWearId = gHeadWearId.HEAD_ID_KING
	end
	if isVipActivated == true then
		localData.isVip = true
	else
		localData.isVip = false
	end
	localData.chatChannel = chatChannel
	localData.chatSet = chatSet
	localData.key = param.key
	localData.chatType = gChatChannel2ChatTypeUI[chatChannel]
	if localData.chatChannel == gChatChannel.KINGDOM or localData.chatChannel == gChatChannel.DJ then
		if 0 < lordInfoCtrl:getSourceKid() then
			localData.kid = lordInfoCtrl:getSourceKid()
		else
			localData.kid = gametop.playertop_:getKingdomID()
		end
		if localData.chatChannel == gChatChannel.DJ then
			localData.castlelv = SoraDGetCastleLv()
			localData.bubbleId = gBubbleId.BUBBLE_ID_NORMAL
			localData.align = SoraDFIsRA() and 1 or 0
			localData.messageType = messageType
		end
	end
	localData.date = serviceFunctions.systemTime()
	localData.time = os.date("%m-%d %H:%M", localData.date)
	localData.bottomText = localData.time
	if worldMapDefine.isInLegendLord() then
		local legendTeamCtrl = gametop.playertop_:getModule("legendTeamCtrl")
		local kingStarTeamCtrl = gametop.playertop_:getModule("kingStarTeamCtrl")
		if legendTeamCtrl:isHasTeam() then
			localData.alliance = legendTeamCtrl:getTeamAbbr()
			localData.allianceId = legendTeamCtrl:getTeamID()
		elseif kingStarTeamCtrl:isHasTeam() then
			localData.alliance = kingStarTeamCtrl:getTeamAbbr()
			localData.allianceId = kingStarTeamCtrl:getTeamID()
		end
	else
		local alliance = allianceMgr:getAlliance()
		if alliance ~= nil then
			localData.alliance = alliance:getProperty("abbr")
			local aid
			localData.allianceId = alliance:getProperty(aid)
		end
	end
	localData.chatId = 0
	if localData.chatChannel == gChatChannel.ALLIANCE then
		localData.name = localData.nickName
	else
		localData.name = mailFunctions:getWrappedName(localData.alliance, localData.nickName)
	end
	if messageType == gChatTypeDef.chat_content_text then
		localData.dataType = gChatDataType.dataType_text
	elseif messageType == gChatTypeDef.chat_content_expression then
		localData.dataType = gChatDataType.dataType_emotion
		localData.packetId = packetId
		localData.emoticonId = localData.content
	elseif messageType == gChatTypeDef.chat_content_audio then
		localData.content = tostring(message.audioLen) .. "''"
		localData.dataType = gChatDataType.dataType_audio
		localData.customData = message
		localData.netStatus = gChatNetStatus.uploading
	elseif messageType == gChatTypeDef.chat_content_dj_text then
		localData.dataType = gChatDataType.dataType_dj
		localData.content = localData.content
	elseif messageType == gChatTypeDef.chat_content_dj_gift then
		localData.itemID = param.itemID
		localData.shopItemID = param.shopItemID
		localData.count = param.count
		localData.dataType = gChatDataType.dataType_dj
		local giftStr = SoraDFIsRA() and include("itemDesRead").getName(localData.itemID) .. " " .. localData.count .. "x" or include("itemDesRead").getName(localData.itemID) .. " x" .. localData.count
		_ENV = "x"
		;("x").gift = giftStr
		localData.content = i18n("Anchor_text_54", "x")
	end
	if localData.align == 0 then
		localData.direction = gChatDirection.left
	else
		localData.direction = gChatDirection.right
	end
	if localData.dataType == gChatDataType.dataType_audio then
		localData.audioLen = localData.customData.audioLen
		localData.audioId = localData.customData.audioId
	end
	localData.text = chatDataParser.wrapHtmlRichText(localData, localData.content)
	localData.nodeType = chatDataParser.getNodeType(localData)
	_ENV, localData.oriBubbleId = localData.bubbleId, localData.bubbleId
	localData.bubbleId.data = localData
	local localData.bubbleId.checkRes, bubbleParam = false, localData.bubbleId
	localData.bubbleId = chatFunctions.getShowBubbleId(bubbleParam)
	if param.replyMsg then
		chatDataParser.applyReplyMsg(localData, param.replyMsg)
	end
	local settingCtrl = SoraDGetCtrl("settingCtrl")
	if settingCtrl:checkValue(gSettingKeyType.chatTitleShow) then
		local officialType, officialId = lordInfoCtrl:getShowOfficialTypeAndId()
		if officialType then
			localData.officialType = officialType
			localData.officialTitle = officialId
		end
	end
	local activity_9001737_Ctrl = SoraDGetCtrl("activity_9001737_Ctrl")
	local campId = activity_9001737_Ctrl:getMyCamp()
	if campId and 0 < campId then
		localData.footballMonsterCamp = campId
	end
	return localData
end
function chatSendMgr:wrapSendMessageContent(param)
	_ENV = nil
	;(nil).textType = gChatTextType.text_plain
	;(nil).text = param.message
	;(nil).chatIndex = param.chatIndex
	local (nil).packetId, content = param.packetId, nil
	if param.replyMsg then
		content.replyMsg = param.replyMsg
	end
	if param.isAtAll then
		content.isAtAll = param.isAtAll
	end
	if param.atUserMap then
		content.atUserMap = param.atUserMap
	end
	return content
end
function chatSendMgr:requestMessage(data)
	print("发起聊天请求----------------------")
	local chatChannel = data.chatChannel
	local chatSet = data.chatSet or gChatSet.TOTAL
	local requestId = data.requestId or ""
	local startId = data.startId or 0
	local pageSize = data.pageSize or gChatPageSize[chatChannel]
	local direction = data.direction or gDirection.FORWARD
	print("chatChannel = ", chatChannel, ", chatSet = ", chatSet, ", requestId = ", requestId, ", startId = ", startId, ", pageSize = ", pageSize, ", direction =", direction)
	chatDataModuleAPI:load(chatChannel, chatSet, requestId, startId, pageSize, direction)
end
function chatSendMgr:requestHistory(param)
	local chatChannel = param.chatChannel
	local from = gChatChannel2From[chatChannel]
	local funcName = "requestHistory_" .. from
	local func = chatSendMgr[funcName]
	if func then
		func(self, param)
	end
end
function chatSendMgr:requestHistory_noraml(param)
	local chatChannel = param.chatChannel
	local chatSet = param.chatSet
	local key = param.key
	local requestId = ""
	local startId = param.startId or self.chatDataMgr:getStartId(chatChannel, chatSet, key)
	local pageSize = param.pageSize or gChatPageSize[chatChannel]
	local _ENV, direction = chatSet, param.direction or gDirection.FORWARD
	chatSet.chatChannel = chatChannel
	chatSet.chatSet = chatSet
	chatSet.key = key
	chatSet.requestId = requestId
	chatSet.startId = startId
	chatSet.pageSize = pageSize
	local chatSet.direction, requestData = direction, chatSet
	chatSendMgr:requestMessage(requestData)
end
function chatSendMgr:requestHistory_chatTeam(param)
	self:requestHistory_noraml(param)
end
function chatSendMgr:requestHistory_chatKingdom(param)
	self:requestHistory_noraml(param)
end
function chatSendMgr:requestHistory_chatAlliance(param)
	self:requestHistory_noraml(param)
end
function chatSendMgr:requestHistory_chatAllianceMsg(param)
	local chatChannel = param.chatChannel
	local chatSet = param.chatSet
	local key = param.key
	local setParam = self.chatDataMgr:getSetParam(chatChannel, chatSet, key)
	local aid = setParam.allianceId
	local nextIndex = setParam.nextIndex
	if nextIndex == nil then
		_ENV = key
		key.msg = "MESSAGE_CHAT_HISTORY_END"
		key.chatChannel = chatChannel
		key.chatSet = chatSet
		key.key = key
		SoraDSendMessage(key)
		return
	end
	print("请求联盟留言: aid:", aid, "nextIndex:", nextIndex)
	SoraDShowLoading(nil, nil, gShowLoadingMark.chat)
	local allianceMsg = gametop.playertop_:getModule("allianceMsg")
	allianceMsg:reqAllianceMsgList(aid, nextIndex)
end
function chatSendMgr:requestHistory_chatTeamMsg(param)
	local chatChannel = param.chatChannel
	local chatSet = param.chatSet
	local key = param.key
	local channelID = param.channelID
	local teamId = param.teamId
	SoraDShowLoading(nil, nil, _G.gShowLoadingMark.chat)
	local startId = param.startId or self.chatDataMgr:getStartId(chatChannel, chatSet, key)
	local pageSize = param.pageSize or _G.gChatPageSize[chatChannel]
	local chatCtrl = SoraDGetCtrl("chatCtrl")
	chatCtrl:reqTeamMsgList(startId, pageSize, channelID, teamId, param.reqFlag)
end
function chatSendMgr:requestHistory_chatMail(param)
	dump(param, "requestHistory_chatMail----------param-----------", 10)
	local mailSetType = param.mailSetType or gMailSetType.CHAT
	local key = param.key
	local flag = self.chatDataMgr:getMailStartMid(param)
	local num = param.num or 20
	local totalNum = gChatMgrs:getMgr("chatCoverMgr"):getNumInfoByKey(key).num or 0
	if not self.chatDataMgr:getMailChatData(key) then
		local _ENV, localMailList = self.chatDataMgr:getMailChatData(key), self.chatDataMgr:getMailChatData(key)
	end
	print("request chatMail msg: totalNum= ", totalNum, ", localnum = ", #localMailList, "mailsetType = ", mailSetType, " key = ", key)
	if totalNum > #localMailList then
		SoraDShowLoading(nil, nil, gShowLoadingMark.chat)
		_ENV = nil
		;(nil).setType = gMailSetType.CHAT
		;(nil).flag = flag
		;(nil).key = key
		SoraDGetCtrl("mailCtrl"):reqMoreMail(nil)
	else
		_ENV = SoraDGetCtrl("mailCtrl")
		SoraDGetCtrl("mailCtrl").data, _ENV, SoraDGetCtrl("mailCtrl").msg = nil, nil, "MESSAGE_CHAT_SERVER_LOAD_SUCCESS"
		SoraDGetCtrl("mailCtrl").chatChannel = gChatChannel.MAIL
		SoraDGetCtrl("mailCtrl").chatSet = gChatSet.TOTAL
		SoraDGetCtrl("mailCtrl").key = key
		SoraDSendMessage((SoraDGetCtrl("mailCtrl")))
	end
end
function chatSendMgr:requestHistory_chatRoomMsg(param)
	dump(param, "requestHistory_chatMail----------param-----------", 10)
	local crid = param.target
	local key = param.key
	local iBegin = self.chatDataMgr:getChatRoomStartId(param)
	local num = param.num or 20
	SoraDShowLoading(nil, nil, gShowLoadingMark.chat)
	print("request chatRoomMsg: iBegin= ", iBegin, ", num = ", num, " key = ", key)
	local chatroomCtrl = gametop.playertop_:getModule("chatroomCtrl")
	chatroomCtrl:getChatRoomMsgs(crid, iBegin, num)
end
function chatSendMgr:requestHistory_escortKingdom(param)
	print("请求国家军情--------------")
	local kingdomDatas = self.chatDataMgr:getKingdomEscortData()
	local numOfData = #kingdomDatas
	local iBegin = numOfData + 1
	local nCount = param.num
	print("请求历史数据加载: iBegin = ", iBegin, ", nCount = ", nCount)
	local escortIntelCtrl = gametop.playertop_:getModule("escortIntelCtrl")
	SoraDShowLoading(nil, nil, gShowLoadingMark.chat)
	escortIntelCtrl:getKingdomMsgs(iBegin, nCount)
end
function chatSendMgr:requestHistory_escortAlliance(param)
	print("请求联盟军情--------------")
	local allianceDatas = self.chatDataMgr:getAllianceEscortData()
	local numOfData = #allianceDatas
	local iBegin = numOfData + 1
	local nCount = param.num
	local escortIntelCtrl = gametop.playertop_:getModule("escortIntelCtrl")
	print("请求历史数据加载: iBegin = ", iBegin, ", nCount = ", nCount)
	SoraDShowLoading(nil, nil, gShowLoadingMark.chat)
	escortIntelCtrl:getAllianceMsgs(iBegin, nCount)
end
function chatSendMgr:requestHistory_chatCamp(param)
	self:requestHistory_noraml(param)
end
function chatSendMgr:requestHistory_viewer(param)
	self:requestHistory_noraml(param)
end
function chatSendMgr:handleNodeStatusClick(data)
	print("·chatSendMgr:handleNodeStatusClick(data)--------------")
	local netStatus = data.netStatus
	local netStatusFunc = chatSendMgr.handleNodeStatusFuncs[netStatus]
	if netStatusFunc then
		netStatusFunc(self, data)
	end
end
function chatSendMgr:handleNetStatus_warn_sending(data)
	SoraDShowMsgBox(i18n("common_text_896"), i18n("common_text_054"), nil, function(eventType)
		self:confirmSend(eventType, data)
	end)
end
function chatSendMgr:handleNetStatus_warn_uploading(data)
	SoraDShowMsgBox(i18n("common_text_896"), i18n("common_text_054"), nil, function(eventType)
		self:confirmUpload(eventType, data)
	end)
end
function chatSendMgr:handleNetStatus_warn_downloading(data)
	SoraDShowMsgBox(i18n("common_text_2090"), i18n("common_text_054"), nil, function(eventType)
		self:confirmDownload(eventType, data)
	end)
end
function chatSendMgr:handleNetStatus_warn_translating(data)
	data.netStatus = gChatNetStatus.translating
	if data.itemNode and data.itemNode.updateNetStatus then
		data.itemNode:updateNetStatus()
	end
	local message = data
	local chatChannel = message.chatChannel
	local from = gChatChannel2From[chatChannel]
	local dataKey = message.key
	local isAutoTransalte = false
	_ENV = nil
	_UPVALUE1_, (nil).from = nil, from
	;(nil).dataItemList, (nil)[1] = nil, message
	;(nil).isAutoTransalte = isAutoTransalte
	;(nil).dataKey = dataKey
	self.chatTranslateMgr:reqTranslate(nil)
end
function chatSendMgr:confirmSend(eventType, data)
	if eventType == MSGBOX_CALLBACK_YES then
		print("重新发送....")
		data.netStatus = gChatNetStatus.sending
		if data.itemNode then
			data.itemNode:updateNetStatus()
		end
		local comfirmSendFunc = chatSendMgr.confirmSendFuncs[data.chatChannel]
		if comfirmSendFunc then
			comfirmSendFunc(self, eventType, data)
		end
	end
end
function chatSendMgr:confirmSend_noraml(eventType, data)
	local message = data.content
	local messageType = gChatDataType2MessageType[data.dataType]
	if data.dataType == gChatDataType.dataType_audio then
		message = data.customData
	end
	local chatIndex = data.chatIndex
	local chatChannel = data.chatChannel
	local chatSet = data.chatSet
	local newChatIndex = chatIndex or self:getNewChatIndex()
	local newmessage
	if messageType == gChatTypeDef.chat_content_audio then
		newmessage = self.chatAudioMgr:wrapSendAudioContent(message.audioId, message.audioLen, newChatIndex)
	else
		newmessage = message
		if gModuleMgr.sharedMgr("shieldedWordsltCtrl"):hasShieldedWord(message) then
			newmessage = gModuleMgr.sharedMgr("shieldedWordsltCtrl"):replaceShieldedWords(message)
		end
		_ENV = message
		message.message = newmessage
		message.chatIndex = newChatIndex
		message.packetId = data.packetId
		newmessage = self:wrapSendMessageContent(message)
	end
	if chatChannel == gChatChannel.KINGDOM then
		print("确认发送国家消息-------")
		chatCtrl:sendKingDomMessage(newmessage, messageType)
	elseif chatChannel == gChatChannel.ALLIANCE then
		print("确认发送联盟消息-------")
		chatCtrl:sendAllianceMessage(newmessage, messageType)
	end
	self:sendMsgTimeOutManage(newChatIndex, chatChannel, chatSet)
end
function chatSendMgr:confirmSend_mail(eventType, data)
	local chatChannel = data.chatChannel
	local chatSet = data.chatSet
	local key = data.key
	if data.dataType == gChatDataType.dataType_audio then
		local isSendToAll = data.isSendToAll
		self:sendMsgTimeOutManage(data.chatIndex, chatChannel, chatSet, key)
		local dressCtrl = gametop.playertop_:getModule("dressCtrl")
		local bubbleId = dressCtrl:getCurDressID(gDressType.CHAT_TEXT_FRAME)
		local avatarFrameId = dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_FRAME)
		local headWearId = dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_CROWN)
		_ENV = dressCtrl
		dressCtrl.contentType = gChatMailContentType.content_audio
		dressCtrl.content = tostring(data.customData.audioLen) .. "''"
		dressCtrl.audioLen = data.customData.audioLen
		dressCtrl.audioId = data.customData.audioId
		dressCtrl.isRead = false
		dressCtrl.isSendToAll = isSendToAll
		dressCtrl.isKing = data.isKing
		dressCtrl.isLegendKing = data.isLegendKing
		dressCtrl.isLegendForSepKing = data.isLegendForSepKing
		dressCtrl.isHegemon = data.isHegemon
		dressCtrl.chatIndex = data.chatIndex
		dressCtrl.bubbleId = bubbleId
		dressCtrl.headWearId = headWearId
		local dressCtrl.avatarFrameId, content = avatarFrameId, dressCtrl
		if data.otherData and data.otherData.target then
			print("邮件重新发送到", data.otherData.target)
			mailCtrl:sendChatMail(data.otherData.target, content)
		end
	elseif data.dataType == gChatDataType.dataType_text then
		local isKing = data.isKing
		local isLegendKing = data.isLegendKing
		local isHegemon = data.isHegemon
		local isLegendForSepKing = data.isLegendForSepKing
		_ENV = dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_CROWN)
		dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_CROWN).contentType = gChatMailContentType.content_text
		dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_CROWN).content = data.content
		dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_CROWN).isKing = isKing
		dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_CROWN).isLegendKing = isLegendKing
		dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_CROWN).isLegendForSepKing = isLegendForSepKing
		local dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_CROWN).isHegemon, content = isHegemon, dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_CROWN)
		if data.otherData and data.otherData.target then
			print("邮件重新发送到", data.otherData.target)
			mailCtrl:sendChatMail(data.otherData.target, content)
		end
	elseif data.dataType == gChatDataType.dataType_emotion then
		local isKing = data.isKing
		local isLegendKing = data.isLegendKing
		local isLegendForSepKing = data.isLegendForSepKing
		local isHegemon = data.isHegemon
		_ENV = dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_CROWN)
		dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_CROWN).contentType = gChatMailContentType.content_emo
		dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_CROWN).content = data.content
		dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_CROWN).isKing = isKing
		dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_CROWN).isLegendKing = isLegendKing
		dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_CROWN).isLegendForSepKing = isLegendForSepKing
		local dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_CROWN).isHegemon, content = isHegemon, dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_CROWN)
		if data.otherData and data.otherData.target then
			print("邮件重新发送到", data.otherData.target)
			mailCtrl:sendChatMail(data.otherData.target, content)
		end
	end
end
function chatSendMgr:confirmSend_chatroom(eventType, data)
	if data.dataType == gChatDataType.dataType_audio then
		if data.otherData and data.otherData.crid then
			print("重新发送聊天室的语音消息, crid = ", data.otherData.crid)
			local chatroomCtrl = gametop.playertop_:getModule("chatroomCtrl")
			local dressCtrl = gametop.playertop_:getModule("dressCtrl")
			local bubbleId = dressCtrl:getCurDressID(gDressType.CHAT_TEXT_FRAME)
			local avatarFrameId = dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_FRAME)
			local headWearId = dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_CROWN)
			_ENV = dressCtrl
			_ENV, dressCtrl.chatType = gChatRoomChatType.VOICE, gChatRoomChatType.VOICE
			gChatRoomChatType.VOICE.audioLen = data.customData.audioLen
			gChatRoomChatType.VOICE.audioId = data.customData.audioId
			dressCtrl.content, gChatRoomChatType.VOICE.chatIndex = gChatRoomChatType.VOICE, data.chatIndex
			dressCtrl.isKing = data.isKing
			dressCtrl.isLegendKing = data.isLegendKing
			dressCtrl.isLegendForSepKing = data.isLegendForSepKing
			dressCtrl.isHegemon = data.isHegemon
			dressCtrl.bubbleId = bubbleId
			dressCtrl.headWearId = headWearId
			local dressCtrl.avatarFrameId, msgData = avatarFrameId, dressCtrl
			local crid = data.otherData.crid
			chatroomCtrl:reqChatRoomSendMsg(crid, msgData)
		end
	elseif data.dataType == gChatDataType.dataType_text then
		if data.otherData and data.otherData.crid then
			print("重新发送聊天室的语音消息, crid = ", data.otherData.crid)
			local chatroomCtrl = gametop.playertop_:getModule("chatroomCtrl")
			_ENV = gametop.playertop_
			gametop.playertop_.chatType = gChatRoomChatType.TEXT
			gametop.playertop_.content = data.content
			gametop.playertop_.isKing = data.isKing
			gametop.playertop_.isLegendKing = data.isLegendKing
			gametop.playertop_.isLegendForSepKing = data.isLegendForSepKing
			local gametop.playertop_.isHegemon, msgData = data.isHegemon, gametop.playertop_
			local crid = data.otherData.crid
			chatroomCtrl:reqChatRoomSendMsg(crid, msgData)
		end
	elseif data.dataType == gChatDataType.dataType_emotion and data.otherData and data.otherData.crid then
		print("重新发送聊天室的表情消息, crid = ", data.otherData.crid)
		local chatroomCtrl = gametop.playertop_:getModule("chatroomCtrl")
		_ENV = gametop.playertop_
		gametop.playertop_.chatType = gChatRoomChatType.EMOJI
		gametop.playertop_.content = data.content
		gametop.playertop_.isKing = data.isKing
		gametop.playertop_.isLegendKing = data.isLegendKing
		gametop.playertop_.isLegendForSepKing = data.isLegendForSepKing
		local gametop.playertop_.isHegemon, msgData = data.isHegemon, gametop.playertop_
		local crid = data.otherData.crid
		chatroomCtrl:reqChatRoomSendMsg(crid, msgData)
	end
end
function chatSendMgr:confirmUpload(eventType, data)
	if eventType == MSGBOX_CALLBACK_YES then
		if data.dataType ~= gChatDataType.dataType_audio then
			return
		end
		print("重新上传语音消息----------------------------")
		data.netStatus = gChatNetStatus.uploading
		if data.itemNode and data.itemNode.updateNetStatus then
			data.itemNode:updateNetStatus()
		end
		_ENV = data.itemNode.updateNetStatus
		data.itemNode.updateNetStatus.chatChannel = data.chatChannel
		data.itemNode.updateNetStatus.chatSet = data.chatSet
		local data.itemNode.updateNetStatus.key, param = data.key, data.itemNode.updateNetStatus
		self.chatAudioMgr:uploadAudioTimeOutManage(param, data.chatIndex, data.customData.localAudioId)
		userSDKManager.uploadRec(data.customData.localAudioId)
	end
end
_ENV, chatSendMgr.confirmDownload = function(self, eventType, data)
	if eventType == MSGBOX_CALLBACK_YES then
		if data.dataType ~= gChatDataType.dataType_audio then
			return
		end
		print("重新加载语音消息----------------------------")
		data.netStatus = gChatNetStatus.downloading
		if data.itemNode and data.itemNode.updateNetStatus then
			data.itemNode:updateNetStatus()
		end
		self.chatAudioMgr:cleanWaitPlayAudio()
		_ENV = nil
		;(nil).chatType = data.chatType
		;(nil).audioId = data.customData.audioId
		;(nil).itemData = data
		self.chatAudioMgr:saveWaitPlayAudio(nil)
		_ENV = self.chatAudioMgr.saveWaitPlayAudio
		self.chatAudioMgr.saveWaitPlayAudio.chatChannel = data.chatChannel
		self.chatAudioMgr.saveWaitPlayAudio.chatSet = data.chatSet
		local self.chatAudioMgr.saveWaitPlayAudio.key, param = data.key, self.chatAudioMgr.saveWaitPlayAudio
		self.chatAudioMgr:downloadAudioTimeOutManage(param, data.customData.audioId)
		userSDKManager.downloadRec(data.customData.audioId)
	end
end, function(self, eventType, data)
	if eventType == MSGBOX_CALLBACK_YES then
		if data.dataType ~= gChatDataType.dataType_audio then
			return
		end
		print("重新加载语音消息----------------------------")
		data.netStatus = gChatNetStatus.downloading
		if data.itemNode and data.itemNode.updateNetStatus then
			data.itemNode:updateNetStatus()
		end
		self.chatAudioMgr:cleanWaitPlayAudio()
		_ENV = nil
		;(nil).chatType = data.chatType
		;(nil).audioId = data.customData.audioId
		;(nil).itemData = data
		self.chatAudioMgr:saveWaitPlayAudio(nil)
		_ENV = self.chatAudioMgr.saveWaitPlayAudio
		self.chatAudioMgr.saveWaitPlayAudio.chatChannel = data.chatChannel
		self.chatAudioMgr.saveWaitPlayAudio.chatSet = data.chatSet
		local self.chatAudioMgr.saveWaitPlayAudio.key, param = data.key, self.chatAudioMgr.saveWaitPlayAudio
		self.chatAudioMgr:downloadAudioTimeOutManage(param, data.customData.audioId)
		userSDKManager.downloadRec(data.customData.audioId)
	end
end
;(function(self, eventType, data)
	if eventType == MSGBOX_CALLBACK_YES then
		if data.dataType ~= gChatDataType.dataType_audio then
			return
		end
		print("重新加载语音消息----------------------------")
		data.netStatus = gChatNetStatus.downloading
		if data.itemNode and data.itemNode.updateNetStatus then
			data.itemNode:updateNetStatus()
		end
		self.chatAudioMgr:cleanWaitPlayAudio()
		_ENV = nil
		;(nil).chatType = data.chatType
		;(nil).audioId = data.customData.audioId
		;(nil).itemData = data
		self.chatAudioMgr:saveWaitPlayAudio(nil)
		_ENV = self.chatAudioMgr.saveWaitPlayAudio
		self.chatAudioMgr.saveWaitPlayAudio.chatChannel = data.chatChannel
		self.chatAudioMgr.saveWaitPlayAudio.chatSet = data.chatSet
		local self.chatAudioMgr.saveWaitPlayAudio.key, param = data.key, self.chatAudioMgr.saveWaitPlayAudio
		self.chatAudioMgr:downloadAudioTimeOutManage(param, data.customData.audioId)
		userSDKManager.downloadRec(data.customData.audioId)
	end
end)[gChatNetStatus.warn_sending] = chatSendMgr.handleNetStatus_warn_sending
;(function(self, eventType, data)
	if eventType == MSGBOX_CALLBACK_YES then
		if data.dataType ~= gChatDataType.dataType_audio then
			return
		end
		print("重新加载语音消息----------------------------")
		data.netStatus = gChatNetStatus.downloading
		if data.itemNode and data.itemNode.updateNetStatus then
			data.itemNode:updateNetStatus()
		end
		self.chatAudioMgr:cleanWaitPlayAudio()
		_ENV = nil
		;(nil).chatType = data.chatType
		;(nil).audioId = data.customData.audioId
		;(nil).itemData = data
		self.chatAudioMgr:saveWaitPlayAudio(nil)
		_ENV = self.chatAudioMgr.saveWaitPlayAudio
		self.chatAudioMgr.saveWaitPlayAudio.chatChannel = data.chatChannel
		self.chatAudioMgr.saveWaitPlayAudio.chatSet = data.chatSet
		local self.chatAudioMgr.saveWaitPlayAudio.key, param = data.key, self.chatAudioMgr.saveWaitPlayAudio
		self.chatAudioMgr:downloadAudioTimeOutManage(param, data.customData.audioId)
		userSDKManager.downloadRec(data.customData.audioId)
	end
end)[gChatNetStatus.warn_uploading] = chatSendMgr.handleNetStatus_warn_uploading
;(function(self, eventType, data)
	if eventType == MSGBOX_CALLBACK_YES then
		if data.dataType ~= gChatDataType.dataType_audio then
			return
		end
		print("重新加载语音消息----------------------------")
		data.netStatus = gChatNetStatus.downloading
		if data.itemNode and data.itemNode.updateNetStatus then
			data.itemNode:updateNetStatus()
		end
		self.chatAudioMgr:cleanWaitPlayAudio()
		_ENV = nil
		;(nil).chatType = data.chatType
		;(nil).audioId = data.customData.audioId
		;(nil).itemData = data
		self.chatAudioMgr:saveWaitPlayAudio(nil)
		_ENV = self.chatAudioMgr.saveWaitPlayAudio
		self.chatAudioMgr.saveWaitPlayAudio.chatChannel = data.chatChannel
		self.chatAudioMgr.saveWaitPlayAudio.chatSet = data.chatSet
		local self.chatAudioMgr.saveWaitPlayAudio.key, param = data.key, self.chatAudioMgr.saveWaitPlayAudio
		self.chatAudioMgr:downloadAudioTimeOutManage(param, data.customData.audioId)
		userSDKManager.downloadRec(data.customData.audioId)
	end
end)[gChatNetStatus.warn_downloading] = chatSendMgr.handleNetStatus_warn_downloading
_ENV, chatSendMgr.handleNodeStatusFuncs, (function(self, eventType, data)
	if eventType == MSGBOX_CALLBACK_YES then
		if data.dataType ~= gChatDataType.dataType_audio then
			return
		end
		print("重新加载语音消息----------------------------")
		data.netStatus = gChatNetStatus.downloading
		if data.itemNode and data.itemNode.updateNetStatus then
			data.itemNode:updateNetStatus()
		end
		self.chatAudioMgr:cleanWaitPlayAudio()
		_ENV = nil
		;(nil).chatType = data.chatType
		;(nil).audioId = data.customData.audioId
		;(nil).itemData = data
		self.chatAudioMgr:saveWaitPlayAudio(nil)
		_ENV = self.chatAudioMgr.saveWaitPlayAudio
		self.chatAudioMgr.saveWaitPlayAudio.chatChannel = data.chatChannel
		self.chatAudioMgr.saveWaitPlayAudio.chatSet = data.chatSet
		local self.chatAudioMgr.saveWaitPlayAudio.key, param = data.key, self.chatAudioMgr.saveWaitPlayAudio
		self.chatAudioMgr:downloadAudioTimeOutManage(param, data.customData.audioId)
		userSDKManager.downloadRec(data.customData.audioId)
	end
end)[gChatNetStatus.warn_translating] = function(self, eventType, data)
	if eventType == MSGBOX_CALLBACK_YES then
		if data.dataType ~= gChatDataType.dataType_audio then
			return
		end
		print("重新加载语音消息----------------------------")
		data.netStatus = gChatNetStatus.downloading
		if data.itemNode and data.itemNode.updateNetStatus then
			data.itemNode:updateNetStatus()
		end
		self.chatAudioMgr:cleanWaitPlayAudio()
		_ENV = nil
		;(nil).chatType = data.chatType
		;(nil).audioId = data.customData.audioId
		;(nil).itemData = data
		self.chatAudioMgr:saveWaitPlayAudio(nil)
		_ENV = self.chatAudioMgr.saveWaitPlayAudio
		self.chatAudioMgr.saveWaitPlayAudio.chatChannel = data.chatChannel
		self.chatAudioMgr.saveWaitPlayAudio.chatSet = data.chatSet
		local self.chatAudioMgr.saveWaitPlayAudio.key, param = data.key, self.chatAudioMgr.saveWaitPlayAudio
		self.chatAudioMgr:downloadAudioTimeOutManage(param, data.customData.audioId)
		userSDKManager.downloadRec(data.customData.audioId)
	end
end, function(self, eventType, data)
	if eventType == MSGBOX_CALLBACK_YES then
		if data.dataType ~= gChatDataType.dataType_audio then
			return
		end
		print("重新加载语音消息----------------------------")
		data.netStatus = gChatNetStatus.downloading
		if data.itemNode and data.itemNode.updateNetStatus then
			data.itemNode:updateNetStatus()
		end
		self.chatAudioMgr:cleanWaitPlayAudio()
		_ENV = nil
		;(nil).chatType = data.chatType
		;(nil).audioId = data.customData.audioId
		;(nil).itemData = data
		self.chatAudioMgr:saveWaitPlayAudio(nil)
		_ENV = self.chatAudioMgr.saveWaitPlayAudio
		self.chatAudioMgr.saveWaitPlayAudio.chatChannel = data.chatChannel
		self.chatAudioMgr.saveWaitPlayAudio.chatSet = data.chatSet
		local self.chatAudioMgr.saveWaitPlayAudio.key, param = data.key, self.chatAudioMgr.saveWaitPlayAudio
		self.chatAudioMgr:downloadAudioTimeOutManage(param, data.customData.audioId)
		userSDKManager.downloadRec(data.customData.audioId)
	end
end, chatSendMgr.handleNetStatus_warn_translating
;(function(self, eventType, data)
	if eventType == MSGBOX_CALLBACK_YES then
		if data.dataType ~= gChatDataType.dataType_audio then
			return
		end
		print("重新加载语音消息----------------------------")
		data.netStatus = gChatNetStatus.downloading
		if data.itemNode and data.itemNode.updateNetStatus then
			data.itemNode:updateNetStatus()
		end
		self.chatAudioMgr:cleanWaitPlayAudio()
		_ENV = nil
		;(nil).chatType = data.chatType
		;(nil).audioId = data.customData.audioId
		;(nil).itemData = data
		self.chatAudioMgr:saveWaitPlayAudio(nil)
		_ENV = self.chatAudioMgr.saveWaitPlayAudio
		self.chatAudioMgr.saveWaitPlayAudio.chatChannel = data.chatChannel
		self.chatAudioMgr.saveWaitPlayAudio.chatSet = data.chatSet
		local self.chatAudioMgr.saveWaitPlayAudio.key, param = data.key, self.chatAudioMgr.saveWaitPlayAudio
		self.chatAudioMgr:downloadAudioTimeOutManage(param, data.customData.audioId)
		userSDKManager.downloadRec(data.customData.audioId)
	end
end)[gChatChannel.KINGDOM] = chatSendMgr.confirmSend_noraml
;(function(self, eventType, data)
	if eventType == MSGBOX_CALLBACK_YES then
		if data.dataType ~= gChatDataType.dataType_audio then
			return
		end
		print("重新加载语音消息----------------------------")
		data.netStatus = gChatNetStatus.downloading
		if data.itemNode and data.itemNode.updateNetStatus then
			data.itemNode:updateNetStatus()
		end
		self.chatAudioMgr:cleanWaitPlayAudio()
		_ENV = nil
		;(nil).chatType = data.chatType
		;(nil).audioId = data.customData.audioId
		;(nil).itemData = data
		self.chatAudioMgr:saveWaitPlayAudio(nil)
		_ENV = self.chatAudioMgr.saveWaitPlayAudio
		self.chatAudioMgr.saveWaitPlayAudio.chatChannel = data.chatChannel
		self.chatAudioMgr.saveWaitPlayAudio.chatSet = data.chatSet
		local self.chatAudioMgr.saveWaitPlayAudio.key, param = data.key, self.chatAudioMgr.saveWaitPlayAudio
		self.chatAudioMgr:downloadAudioTimeOutManage(param, data.customData.audioId)
		userSDKManager.downloadRec(data.customData.audioId)
	end
end)[gChatChannel.ALLIANCE] = chatSendMgr.confirmSend_noraml
;(function(self, eventType, data)
	if eventType == MSGBOX_CALLBACK_YES then
		if data.dataType ~= gChatDataType.dataType_audio then
			return
		end
		print("重新加载语音消息----------------------------")
		data.netStatus = gChatNetStatus.downloading
		if data.itemNode and data.itemNode.updateNetStatus then
			data.itemNode:updateNetStatus()
		end
		self.chatAudioMgr:cleanWaitPlayAudio()
		_ENV = nil
		;(nil).chatType = data.chatType
		;(nil).audioId = data.customData.audioId
		;(nil).itemData = data
		self.chatAudioMgr:saveWaitPlayAudio(nil)
		_ENV = self.chatAudioMgr.saveWaitPlayAudio
		self.chatAudioMgr.saveWaitPlayAudio.chatChannel = data.chatChannel
		self.chatAudioMgr.saveWaitPlayAudio.chatSet = data.chatSet
		local self.chatAudioMgr.saveWaitPlayAudio.key, param = data.key, self.chatAudioMgr.saveWaitPlayAudio
		self.chatAudioMgr:downloadAudioTimeOutManage(param, data.customData.audioId)
		userSDKManager.downloadRec(data.customData.audioId)
	end
end)[gChatChannel.MAIL] = chatSendMgr.confirmSend_mail
chatSendMgr.confirmSendFuncs, (function(self, eventType, data)
	if eventType == MSGBOX_CALLBACK_YES then
		if data.dataType ~= gChatDataType.dataType_audio then
			return
		end
		print("重新加载语音消息----------------------------")
		data.netStatus = gChatNetStatus.downloading
		if data.itemNode and data.itemNode.updateNetStatus then
			data.itemNode:updateNetStatus()
		end
		self.chatAudioMgr:cleanWaitPlayAudio()
		_ENV = nil
		;(nil).chatType = data.chatType
		;(nil).audioId = data.customData.audioId
		;(nil).itemData = data
		self.chatAudioMgr:saveWaitPlayAudio(nil)
		_ENV = self.chatAudioMgr.saveWaitPlayAudio
		self.chatAudioMgr.saveWaitPlayAudio.chatChannel = data.chatChannel
		self.chatAudioMgr.saveWaitPlayAudio.chatSet = data.chatSet
		local self.chatAudioMgr.saveWaitPlayAudio.key, param = data.key, self.chatAudioMgr.saveWaitPlayAudio
		self.chatAudioMgr:downloadAudioTimeOutManage(param, data.customData.audioId)
		userSDKManager.downloadRec(data.customData.audioId)
	end
end)[gChatChannel.CHATROOM] = function(self, eventType, data)
	if eventType == MSGBOX_CALLBACK_YES then
		if data.dataType ~= gChatDataType.dataType_audio then
			return
		end
		print("重新加载语音消息----------------------------")
		data.netStatus = gChatNetStatus.downloading
		if data.itemNode and data.itemNode.updateNetStatus then
			data.itemNode:updateNetStatus()
		end
		self.chatAudioMgr:cleanWaitPlayAudio()
		_ENV = nil
		;(nil).chatType = data.chatType
		;(nil).audioId = data.customData.audioId
		;(nil).itemData = data
		self.chatAudioMgr:saveWaitPlayAudio(nil)
		_ENV = self.chatAudioMgr.saveWaitPlayAudio
		self.chatAudioMgr.saveWaitPlayAudio.chatChannel = data.chatChannel
		self.chatAudioMgr.saveWaitPlayAudio.chatSet = data.chatSet
		local self.chatAudioMgr.saveWaitPlayAudio.key, param = data.key, self.chatAudioMgr.saveWaitPlayAudio
		self.chatAudioMgr:downloadAudioTimeOutManage(param, data.customData.audioId)
		userSDKManager.downloadRec(data.customData.audioId)
	end
end, chatSendMgr.confirmSend_chatroom
return chatSendMgr
