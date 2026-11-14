local chatBaseMgr = include("chatBaseMgr")
local chatAudioMgr = class("chatAudioMgr", chatBaseMgr)
local schedulerTime = require(cc.PACKAGE_NAME .. ".scheduler")
local gametop = gModuleMgr.getObject("gametop")
function chatAudioMgr:init()
	self.chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
	self.chatMsgMgr = gChatMgrs:getMgr("chatMsgMgr")
	self.chatSendMgr = gChatMgrs:getMgr("chatSendMgr")
	self:reset()
end
function chatAudioMgr:reset()
	self.tblPlayAudio, _ENV, self.tblDownloadAudio, _ENV, self.tblUploadAudio, _ENV, self.audioTargets, _ENV = nil, nil, nil, nil, nil, nil, nil, nil
	if self.audioDownLoadingTimer then
		for _, v in pairs(self.audioDownLoadingTimer) do
			schedulerTime.unscheduleGlobal(v)
		end
	end
	if self.audioUpLoadingTimer then
		for _, v in pairs(self.audioUpLoadingTimer) do
			schedulerTime.unscheduleGlobal(v)
		end
	end
	if self.audioPlayTimer then
		for _, v in pairs(self.audioPlayTimer) do
			schedulerTime.unscheduleGlobal(v)
		end
	end
	self.audioDelayShowLoading, _ENV, self.audioPlayTimer, _ENV, self.audioUpLoadingTimer, _ENV, self.audioDownLoadingTimer, _ENV, self.audioPlayTimer, _ENV, self.audioUpLoadingTimer, _ENV, self.audioDownLoadingTimer, _ENV = pairs(self.audioPlayTimer)
	self.tblCurPlayAudio = nil
	self.tblAudioLen, _ENV, self.tblWaitPlayAudio = pairs(self.audioPlayTimer)
	self.currentAudioLen = 1
	self.isCapture = false
end
function chatAudioMgr:clean()
	self:reset()
end
function chatAudioMgr:removeMessageListener()
	SoraDRemoveMessageByTarget(self)
end
function chatAudioMgr:registerMessageListener()
	self:removeMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_GOTO_FOREG_BACK_GROUD", handler(self, self.gotoForeBackGroud))
end
function chatAudioMgr:isSending(data)
	if not self.isSendingMap then
		_ENV = self.isSendingMap
		self.isSendingMap[gChatNetStatus.sending] = true
		self.isSendingMap[gChatNetStatus.uploading] = true
		self.isSendingMap[gChatNetStatus.warn_sending] = true
		self.isSendingMap, self.isSendingMap[gChatNetStatus.warn_uploading] = self.isSendingMap, true
	end
	return self.isSendingMap[data.netStatus] or false
end
function chatAudioMgr:isLoading(data)
	if not self.isLoadingMap then
		_ENV = self.isLoadingMap
		self.isLoadingMap[gChatNetStatus.downloading] = true
		self.isLoadingMap, self.isLoadingMap[gChatNetStatus.warn_downloading] = self.isLoadingMap, true
	end
	return self.isLoadingMap[data.netStatus] or false
end
function chatAudioMgr:pushAudioTarget(audioTarget)
	self.audioTargets[#self.audioTargets + 1] = audioTarget
end
function chatAudioMgr:popAudioTarget()
	local currentTarget = self.audioTargets[#self.audioTargets]
	self.audioTargets[#self.audioTargets] = nil
	local nextTarget = self.audioTargets[#self.audioTargets]
	return currentTarget, nextTarget
end
function chatAudioMgr:getCurrentAudioTarget()
	return self.audioTargets[#self.audioTargets]
end
function chatAudioMgr:addToUploadAudio(param, chatIndex, localAudioId, otherData)
	_ENV = localAudioId
	localAudioId.param = param
	localAudioId.chatIndex = chatIndex
	localAudioId.localAudioId = localAudioId
	self.tblUploadAudio[tostring(localAudioId)], localAudioId.otherData = localAudioId, otherData
end
function chatAudioMgr:addToDownloadAudio(param, remoteAudioId)
	_ENV = remoteAudioId
	remoteAudioId.param = param
	self.tblDownloadAudio[tostring(remoteAudioId)], remoteAudioId.remoteAudioId = remoteAudioId, remoteAudioId
end
function chatAudioMgr:delFromUploadAudio(localAudioId)
	if localAudioId then
		self.tblUploadAudio[tostring(localAudioId)] = nil
	end
end
function chatAudioMgr:delFromDownloadAudio(remoteAudioId)
	if remoteAudioId then
		self.tblDownloadAudio[tostring(remoteAudioId)] = nil
	end
end
function chatAudioMgr:uploadAudioTimeOutManage(param, chatIndex, localAudioId)
	local timeHandle = schedulerTime.performWithDelayGlobal(function(dt)
		self:uploadAudioTimeOut(dt, param, chatIndex, localAudioId)
	end, gChatCheckOutTime.chatAudioUpLoading)
	self.audioUpLoadingTimer[tostring(localAudioId)] = timeHandle
end
function chatAudioMgr:uploadAudioTimeOut(dt, param, chatIndex, localAudioId)
	local curItemData = self.chatDataMgr:getData(param.chatChannel, param.chatSet, param.key)
	if curItemData == nil then
		curItemData, _ENV = self.chatDataMgr, self.chatDataMgr
	end
	for _, v in ipairs(curItemData) do
		if v.chatIndex and v.chatIndex == chatIndex and v.dataType == gChatDataType.dataType_audio and v.netStatus == gChatNetStatus.uploading then
			v.netStatus = gChatNetStatus.warn_uploading
			self.audioUpLoadingTimer[tostring(localAudioId)] = nil
			if v.itemNode and v.itemNode.updateNetStatus then
				v.itemNode:updateNetStatus()
			end
			break
		end
	end
end
function chatAudioMgr:downloadAudioTimeOutManage(param, remoteAudioId)
	local timeHandle = schedulerTime.performWithDelayGlobal(function(dt)
		self:downloadAudioTimeOut(dt, param, remoteAudioId)
	end, gChatCheckOutTime.chatAudioDownLoading)
	self.audioDownLoadingTimer[tostring(remoteAudioId)] = timeHandle
end
function chatAudioMgr:downloadAudioTimeOut(dt, param, remoteAudioId)
	local curItemData
	print("chatAudioMgr:downloadAudioTimeOut 时间到了--------------------------")
	local chatChannel = param.chatChannel
	local chatSet = param.chatSet
	local key = param.key
	local curItemData = self.chatDataMgr:getData(chatChannel, chatSet, key)
	if curItemData == nil then
		curItemData, _ENV = self.chatDataMgr, self.chatDataMgr
	end
	for _, v in ipairs(curItemData) do
		if v.dataType == gChatDataType.dataType_audio and v.customData and v.customData.audioId == remoteAudioId then
			if v.netStatus == gChatNetStatus.downloading then
				v.netStatus = gChatNetStatus.warn_downloading
				if v.itemNode and v.itemNode.updateNetStatus then
					v.itemNode:updateNetStatus()
				end
			end
			self.audioDownLoadingTimer[tostring(remoteAudioId)] = nil
			break
		end
	end
end
function chatAudioMgr:playAudioTimeOutManage(param, remoteAudioId, audioLen)
	if not audioLen or audioLen == 0 then
		audioLen = 1
	end
	print("chatAudioMgr:playAudioTimeOutManage(param, remoteAudioId, audioLen)", param, remoteAudioId, audioLen)
	dump(param, "param")
	local timeHandle
	timeHandle = schedulerTime.performWithDelayGlobal(function(dt)
		self:playAudioTimeOut(dt, param, remoteAudioId, timeHandle)
	end, audioLen)
	self.audioPlayTimer[tostring(remoteAudioId)] = timeHandle
end
function chatAudioMgr:playAudioTimeOut(dt, param, remoteAudioId, timeHandle)
	local chatChannel = param.chatChannel
	local chatSet = param.chatSet
	local key = param.key
	print("function chatAudioMgr:playAudioTimeOut(dt, param , remoteAudioId, timeHandle)")
	dump(param, "param")
	local curItemData = self.chatDataMgr:getData(chatChannel, chatSet, key)
	if curItemData == nil then
		curItemData, _ENV = self.chatDataMgr, self.chatDataMgr
	end
	for i, v in ipairs(curItemData) do
		if v.dataType == gChatDataType.dataType_audio and v.customData and v.customData.audioId == remoteAudioId then
			self.audioPlayTimer[tostring(remoteAudioId)] = nil
			if v.playStatus == gPlayStatus.playing_audio then
				v.playStatus = gPlayStatus.normal
				if v.itemNode and v.itemNode.updatePlayStatus then
					v.itemNode:updatePlayStatus()
				end
				self:cleanCurPlayAudio()
				self:resumeMusic()
				break
			end
			print("Error ! -- 没找到------index = ", i, " ,   chatAudioMgr:playAudioTimeOut(dt, param, remoteAudioId), chatChannel = ", param.chatChannel, ", remoteAudioId = ", remoteAudioId, ", v.playStatus= ", v.playStatus, ", v.netStatus = ", v.netStatus)
			print("---------------------------------------------")
			break
		end
	end
end
function chatAudioMgr:uploadAudio(param, data)
	local chatFunctions = include("chatFunctions")
	local chatChannel = param.chatChannel
	local chatSet = param.chatSet
	local key = param.key
	local messageType = gChatTypeDef.chat_content_audio
	local message = data
	print("chatAudioMgr:uploadAudio(param, data) chatChannel = ", chatChannel, ",chatSet = ", chatSet, ", key = ", key)
	if chatChannel == gChatChannel.ALLIANCE or chatChannel == gChatChannel.TEAM then
		print("这是发送到联盟的语音消息----")
		local newChatIndex = self.chatSendMgr:getNewChatIndex()
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		local member = memberMgr:getOwnMember()
		local rank = member:getProperty("rank")
		_ENV = member
		member.chatChannel = chatChannel
		member.chatSet = chatSet
		member.key = key
		member.messageType = messageType
		member.message = message
		member.chatIndex = newChatIndex
		local member.alv, msgParam = rank, member
		local sendingMessage = self.chatSendMgr:createSendingMessage(msgParam)
		gametop = self.chatSendMgr
		local self.chatSendMgr[1], dataArray = sendingMessage, self.chatSendMgr
		_ENV = nil
		;(nil).data = dataArray
		;(nil).isHistory = false
		;(nil).chatChannel = chatChannel
		;(nil).chatDataSet = chatSet
		;(nil).isWrapped = true
		;(nil).isNeedScroll = true
		self.chatDataMgr:addChatData(nil)
		self:addToUploadAudio(param, sendingMessage.chatIndex, sendingMessage.customData.localAudioId)
		self:uploadAudioTimeOutManage(param, sendingMessage.chatIndex, sendingMessage.customData.localAudioId)
	elseif chatChannel == gChatChannel.MAIL then
		print("chatAudioMgr:uploadAudio(data)-------------邮件私聊语音------------------")
		local curChatChannelInfo = self.chatDataMgr:getChatChannelInfo()
		if not curChatChannelInfo then
			return
		end
		local key = curChatChannelInfo.key
		local target = curChatChannelInfo.target
		local isKing = chatFunctions:getIsSelfKing()
		local isLegendKing = chatFunctions:getIsSelfLegendKing()
		local isKingStar = chatFunctions:getIsSelfKingStar()
		local isHegemon = chatFunctions:getIsSelfHegemon()
		local newChatIndex = self.chatSendMgr:getNewChatIndex()
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		local member = memberMgr:getOwnMember()
		local rank
		_ENV = sendingMessage.customData.localAudioId
		sendingMessage.customData.localAudioId.key = key
		sendingMessage.customData.localAudioId.target = target
		sendingMessage.customData.localAudioId.isKing = isKing
		sendingMessage.customData.localAudioId.isLegendKing = isLegendKing
		sendingMessage.customData.localAudioId.isLegendForSepKing = isKingStar
		local sendingMessage.customData.localAudioId.isHegemon, otherData = isHegemon, sendingMessage.customData.localAudioId
		local dressCtrl = gametop.playertop_:getModule("dressCtrl")
		local bubbleId = dressCtrl:getCurDressID(gDressType.CHAT_TEXT_FRAME)
		local avatarFrameId = dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_FRAME)
		local headWearId = dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_CROWN)
		otherData.bubbleId = bubbleId
		otherData.avatarFrameId = avatarFrameId
		_ENV, otherData.headWearId = dressCtrl, headWearId
		dressCtrl.chatChannel = chatChannel
		dressCtrl.chatSet = chatSet
		dressCtrl.key = key
		dressCtrl.messageType = messageType
		dressCtrl.message = message
		dressCtrl.chatIndex = newChatIndex
		local dressCtrl.alv, msgParam = rank, dressCtrl
		local sendingMessage = self.chatSendMgr:createSendingMessage(msgParam)
		gametop, sendingMessage.otherData = self.chatSendMgr, otherData
		local self.chatSendMgr[1], dataArray = sendingMessage, self.chatSendMgr
		_ENV = nil
		;(nil).data = dataArray
		;(nil).isHistory = false
		;(nil).chatChannel = chatChannel
		;(nil).chatDataSet = chatSet
		;(nil).key = key
		;(nil).isWrapped = true
		;(nil).isNeedScroll = true
		self.chatDataMgr:addChatData(nil)
		self:addToUploadAudio(param, sendingMessage.chatIndex, sendingMessage.customData.localAudioId, otherData)
		self:uploadAudioTimeOutManage(param, sendingMessage.chatIndex, sendingMessage.customData.localAudioId)
	elseif chatChannel == gChatChannel.CHATROOM then
		local curChatChannelInfo = self.chatDataMgr:getChatChannelInfo()
		if not curChatChannelInfo then
			return
		end
		local crid = curChatChannelInfo.target
		local key = curChatChannelInfo.key
		local newChatIndex = self.chatSendMgr:getNewChatIndex()
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		local member = memberMgr:getOwnMember()
		local rank
		_ENV = self.chatSendMgr:getNewChatIndex()
		self.chatSendMgr:getNewChatIndex().chatChannel = chatChannel
		self.chatSendMgr:getNewChatIndex().chatSet = chatSet
		self.chatSendMgr:getNewChatIndex().key = key
		self.chatSendMgr:getNewChatIndex().messageType = messageType
		self.chatSendMgr:getNewChatIndex().message = message
		self.chatSendMgr:getNewChatIndex().chatIndex = newChatIndex
		local self.chatSendMgr:getNewChatIndex().alv, msgParam = rank, self.chatSendMgr:getNewChatIndex()
		local sendingMessage = self.chatSendMgr:createSendingMessage(msgParam)
		_ENV = self.chatSendMgr
		local self.chatSendMgr.crid, otherData = crid, self.chatSendMgr
		local dressCtrl = gametop.playertop_:getModule("dressCtrl")
		local bubbleId = dressCtrl:getCurDressID(gDressType.CHAT_TEXT_FRAME)
		local avatarFrameId = dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_FRAME)
		local headWearId = dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_CROWN)
		otherData.bubbleId = bubbleId
		otherData.avatarFrameId = avatarFrameId
		otherData.headWearId = headWearId
		gametop, sendingMessage.otherData = dressCtrl, otherData
		local dressCtrl[1], dataArray = sendingMessage, dressCtrl
		_ENV = self.chatSendMgr:createSendingMessage(msgParam)
		self.chatSendMgr:createSendingMessage(msgParam).data = dataArray
		self.chatSendMgr:createSendingMessage(msgParam).isHistory = false
		self.chatSendMgr:createSendingMessage(msgParam).chatChannel = chatChannel
		self.chatSendMgr:createSendingMessage(msgParam).chatDataSet = chatSet
		self.chatSendMgr:createSendingMessage(msgParam).key = key
		self.chatSendMgr:createSendingMessage(msgParam).isWrapped = true
		self.chatSendMgr:createSendingMessage(msgParam).isNeedScroll = true
		self.chatDataMgr:addChatData((self.chatSendMgr:createSendingMessage(msgParam)))
		self:addToUploadAudio(param, sendingMessage.chatIndex, sendingMessage.customData.localAudioId, otherData)
		self:uploadAudioTimeOutManage(param, sendingMessage.chatIndex, sendingMessage.customData.localAudioId)
	end
end
function chatAudioMgr:sendAudioToGame(data)
	local chatCtrl = gametop.playertop_:getModule("chatCtrl")
	local mailCtrl = gametop.playertop_:getModule("mailCtrl")
	local chatroomCtrl = gametop.playertop_:getModule("chatroomCtrl")
	print("chatAudioMgr:sendAudioToGame(data)")
	dump(data, "chatAudioMgr:sendAudioToGame")
	local item = self.tblUploadAudio[tostring(data.localAudioId)]
	if not item then
		print("Error!------------没有在上传队列中找到------------------")
		dump(data, "chatAudioMgr:sendAudioToGame")
		return
	else
		local param = item.param
		local chatChannel = param.chatChannel
		local curItemData = self.chatDataMgr:getData(param.chatChannel, param.chatSet, param.key)
		if curItemData == nil then
			curItemData, gametop = self.chatDataMgr, self.chatDataMgr
		end
		local isFound = false
		for _, v in ipairs(curItemData) do
			if v.chatIndex and item.chatIndex == v.chatIndex and (v.netStatus == gChatNetStatus.uploading or v.netStatus == gChatNetStatus.warn_uploading) then
				v.netStatus = gChatNetStatus.sending
				if v.itemNode and v.itemNode.updateNetStatus then
					v.itemNode:updateNetStatus()
				end
				v.customData.audioId = data.audioId
				isFound = true
				self:delFromUploadAudio(data.localAudioId)
				break
			end
		end
		if isFound then
			if chatChannel == gChatChannel.ALLIANCE or chatChannel == gChatChannel.TEAM then
				self.chatSendMgr:sendMsgTimeOutManage(item.chatIndex, param.chatChannel, param.chatSet, param.key)
				local message = self:wrapSendAudioContent(data.audioId, data.audioLen, item.chatIndex)
				local messageType = gChatTypeDef.chat_content_audio
				dump(message, "发送语音消息到服务器")
				chatCtrl:sendAllianceMessage(message, messageType)
			elseif chatChannel == gChatChannel.MAIL then
				print("邮件私聊：发送语音到服务器------------------------------")
				self.chatSendMgr:sendMsgTimeOutManage(item.chatIndex, param.chatChannel, param.chatSet, param.key)
				gametop = self.chatSendMgr.sendMsgTimeOutManage
				self.chatSendMgr.sendMsgTimeOutManage.contentType = gChatMailContentType.content_audio
				self.chatSendMgr.sendMsgTimeOutManage.content = tostring(data.audioLen) .. "''"
				self.chatSendMgr.sendMsgTimeOutManage.audioLen = data.audioLen
				self.chatSendMgr.sendMsgTimeOutManage.audioId = data.audioId
				self.chatSendMgr.sendMsgTimeOutManage.isRead = false
				self.chatSendMgr.sendMsgTimeOutManage.isSendToAll = item.isSendToAll
				self.chatSendMgr.sendMsgTimeOutManage.isKing = item.otherData.isKing
				self.chatSendMgr.sendMsgTimeOutManage.isLegendKing = item.otherData.isLegendKing
				self.chatSendMgr.sendMsgTimeOutManage.isLegendForSepKing = item.otherData.isLegendForSepKing
				self.chatSendMgr.sendMsgTimeOutManage.isHegemon = item.otherData.isHegemon
				self.chatSendMgr.sendMsgTimeOutManage.chatIndex = item.chatIndex
				self.chatSendMgr.sendMsgTimeOutManage.bubbleId = item.otherData.bubbleId
				self.chatSendMgr.sendMsgTimeOutManage.avatarFrameId = item.otherData.avatarFrameId
				local self.chatSendMgr.sendMsgTimeOutManage.headWearId, content = item.otherData.headWearId, self.chatSendMgr.sendMsgTimeOutManage
				dump(content, "需要发送的邮件数据", 10)
				if item.otherData and item.otherData.target then
					mailCtrl:sendChatMail(item.otherData.target, content)
				end
			elseif chatChannel == gChatChannel.CHATROOM then
				gametop = gChatChannel.CHATROOM
				gametop, gChatChannel.CHATROOM.chatType = gChatRoomChatType.VOICE, gChatRoomChatType.VOICE
				gChatRoomChatType.VOICE.audioLen = data.audioLen
				gChatRoomChatType.VOICE.audioId = data.audioId
				gChatChannel.CHATROOM.content, gChatRoomChatType.VOICE.chatIndex = gChatRoomChatType.VOICE, item.chatIndex
				gChatChannel.CHATROOM.isKing = item.otherData.isKing
				gChatChannel.CHATROOM.isLegendKing = item.otherData.isLegendKing
				gChatChannel.CHATROOM.isLegendForSepKing = item.otherData.isLegendForSepKing
				gChatChannel.CHATROOM.isHegemon = item.otherData.isHegemon
				gChatChannel.CHATROOM.bubbleId = item.otherData.bubbleId
				gChatChannel.CHATROOM.avatarFrameId = item.otherData.avatarFrameId
				local gChatChannel.CHATROOM.headWearId, msgData = item.otherData.headWearId, gChatChannel.CHATROOM
				local crid = item.otherData.crid
				chatroomCtrl:reqChatRoomSendMsg(crid, msgData)
			end
		else
			print("Error ! Not Found!! chatAudioMgr:sendAudioToGame(data)")
		end
	end
end
function chatAudioMgr:wrapSendAudioContent(audioId, audioLen, chatIndex)
	_UPVALUE0_ = nil
	;(nil).audioLen = audioLen
	;(nil).audioId = audioId
	local (nil).chatIndex, content = chatIndex, nil
	return content
end
function chatAudioMgr:saveCurPlayAudio(data)
	self.tblCurPlayAudio = data
end
function chatAudioMgr:cleanCurPlayAudio()
	self.tblCurPlayAudio = nil
end
function chatAudioMgr:getCurPlayAudioId()
	if self.tblCurPlayAudio then
		return self.tblCurPlayAudio.audioId
	end
end
function chatAudioMgr:stopCurPlayAudio()
	if self.tblCurPlayAudio then
		print("tblCurPlayAudio , audioId = ", self.tblCurPlayAudio.audioId, ", chatChannel = ", self.tblCurPlayAudio.chatChannel, ", localAudioId = ", self.tblCurPlayAudio.localAudioId)
	end
	dump(self.audioPlayTimer, "audioPlayTimer")
	if self.tblCurPlayAudio and self.tblCurPlayAudio.localAudioId ~= nil then
		if self.tblCurPlayAudio.itemData ~= nil and self.tblCurPlayAudio.itemData.playStatus == gPlayStatus.playing_audio then
			self.tblCurPlayAudio.itemData.playStatus = gPlayStatus.normal
			if self.tblCurPlayAudio.itemData.itemNode and self.tblCurPlayAudio.itemData.itemNode.updatePlayStatus then
				self.tblCurPlayAudio.itemData.itemNode:updatePlayStatus()
			end
		end
		if self.tblCurPlayAudio then
			print("-----------------到这里了-------------------------", ", localAudioId = ", self.tblCurPlayAudio.localAudioId, ", audioId = ", self.tblCurPlayAudio.audioId, ", timerhandle = ", self.audioPlayTimer[self.tblCurPlayAudio.audioId])
		end
		local audioId = self.tblCurPlayAudio.audioId
		if self.audioPlayTimer[audioId] then
			local timeHandle = self.audioPlayTimer[audioId]
			print("取消了全局回调------------", timeHandle)
			schedulerTime.unscheduleGlobal(timeHandle)
			self.audioPlayTimer[audioId] = nil
		end
	else
		print("当前没有需要停止的语音----------------------------------------")
	end
	if userSDKManager.stopPlay then
		userSDKManager.stopPlay()
	end
	self:cleanCurPlayAudio()
end
function chatAudioMgr:hasCurPlayAudio()
	if self.tblCurPlayAudio ~= nil then
		return true
	end
	return false
end
function chatAudioMgr:saveWaitPlayAudio(data)
	self.tblWaitPlayAudio = data
end
function chatAudioMgr:cleanWaitPlayAudio()
	self.tblWaitPlayAudio = nil
end
function chatAudioMgr:hasCurWaitPlayAudio()
	if self.tblWaitPlayAudio ~= nil then
		return true
	end
	return false
end
function chatAudioMgr:getCurWaiPlayAudioId()
	if self.tblWaitPlayAudio ~= nil then
		return self.tblWaitPlayAudio.audioId
	end
end
function chatAudioMgr:setCurrentAudioLen(audioLen)
	self.currentAudioLen = audioLen
end
function chatAudioMgr:resetCurrentAudioLen()
	self.currentAudioLen = 1
end
function chatAudioMgr:getCurrentAudioLen()
	return self.currentAudioLen
end
function chatAudioMgr:addAudioIdAndLen(localAudioId, audioLen)
	self.tblAudioLen[localAudioId] = audioLen
end
function chatAudioMgr:delAudioIdAndLen(localAudioId)
	self.tblAudioLen[localAudioId] = nil
end
function chatAudioMgr:getAudioLenByLocalId(localAudioId)
	return self.tblAudioLen[localAudioId] or 1
end
function chatAudioMgr:getIsCapture()
	return self.isCapture
end
function chatAudioMgr:setIsCapture(isCapture)
	self.isCapture = isCapture
end
function chatAudioMgr:hasAudioPermission(request)
	if self.audioPermission then
		return self.audioPermission
	end
	local CSUserSDKManager = _G.CSUserSDKManager
	self.audioPermission = CSUserSDKManager:authorizationStatusForAudio()
	if request and not self.audioPermission then
		CSUserSDKManager:requestAudioPermission()
	end
	return self.audioPermission
end
function chatAudioMgr:setAudioPermission(has)
	self.audioPermission = has
end
function chatAudioMgr:pauseMusic()
	print("---------------暂停音乐-----------------")
	AudioEngine.pauseMusic()
end
function chatAudioMgr:resumeMusic()
	print("---------------恢复音乐---------------")
	AudioEngine.resumeMusic()
end
function chatAudioMgr:delayShowLoadingManage(param, audioId)
	local timeHandle = schedulerTime.performWithDelayGlobal(function(dt)
		self:delayShowLoadingCallback(dt, param, audioId)
	end, gChatCheckOutTime.chatAudioDelayShowLoading)
	self.audioDelayShowLoading[tostring(audioId)] = timeHandle
end
function chatAudioMgr:delayShowLoadingCallback(dt, param, audioId)
	print("chatAudioMgr:delayShowLoadingCallback 延迟转圈回调时间到了--------------------------")
	local curItemData = self.chatDataMgr:getData(param.chatChannel, param.chatSet, param.key)
	if curItemData == nil then
		curItemData, _ENV = self.chatDataMgr, self.chatDataMgr
	end
	for _, v in ipairs(curItemData) do
		if v.dataType == gChatDataType.dataType_audio and v.customData and v.customData.audioId == audioId then
			if v.netStatus == gChatNetStatus.downloading and v.itemNode and v.itemNode.updateNetStatus then
				v.itemNode:updateNetStatus()
			end
			self.audioDelayShowLoading[tostring(audioId)] = nil
			break
		end
	end
end
function chatAudioMgr:gotoForeBackGroud(target, data)
	local groudType = data.groudType
	if groudType == GOTO_FOREG_GROUD then
		print("回到了前台------------")
	elseif groudType == GOTO_BACK_GROUD then
		print("切换到了后台-------------------")
		if self:hasCurPlayAudio() then
			print("还在有播放的语音，需要停止掉------------")
			self:stopCurPlayAudio()
		end
		self:cleanWaitPlayAudio()
	end
end
function chatAudioMgr:userSDKManager_captureProgressCallBack(decibel, timeInterval)
	if decibel == -1 then
		print("TODO: ----停止了语音录制-------------")
	end
	print("userSDKManager_captureProgressCallBack: decibel = ", decibel, ", timeInterval = ", timeInterval)
end
function chatAudioMgr:uploadAudioCallback(param, data)
	print("uploadAudioCallback 停止成功------------------------------11111")
	self:uploadAudio(param, data)
	dump(param, "param", 10)
	print("录制成功，----------------开始生成本地语音记录------开始上传到SDK服务器")
	dump(data)
	self:addAudioIdAndLen(data.localAudioId, data.audioLen)
	userSDKManager.uploadRec(data.localAudioId)
end
function chatAudioMgr:userSDKManager_stopCaptureCallBack(recIdentifier)
	print("chatAudioMgr:userSDKManager_stopCaptureCallBack( recIdentifier ) -----", recIdentifier)
	local recId = recIdentifier
	if recId and recId ~= "" then
		local audioLen = self:getCurrentAudioLen()
		_ENV, audioLen = math.min(59, math.max(1, audioLen)), math.min(59, math.max(1, audioLen))
		math.min(59, math.max(1, audioLen)).audioLen = audioLen
		local math.min(59, math.max(1, audioLen)).localAudioId, data = recId, math.min(59, math.max(1, audioLen))
		local channelInfo = self.chatDataMgr:getChatChannelInfo()
		if channelInfo == nil then
			return
		end
		_ENV = self.chatDataMgr
		self.chatDataMgr.chatChannel = channelInfo.chatChannel
		self.chatDataMgr.chatSet = gChatSet.TOTAL
		local self.chatDataMgr.key, param = channelInfo.key, self.chatDataMgr
		schedulerTime.performWithDelayGlobal(function(dt)
			self:uploadAudioCallback(param, data)
		end, 0.01)
	else
		local iconSprite = display.newSprite("#icon_liaotian_yuyin.png")
		SoraDShowMsgTip(i18n("common_text_2051"), iconSprite)
		return
	end
end
function chatAudioMgr:userSDKManager_uploadRecCallBack(finished, localIdentifier, remoteIdentifier)
	if finished and remoteIdentifier then
		local audioId = remoteIdentifier
		local audioLen = self:getAudioLenByLocalId(localIdentifier)
		_ENV, audioLen = math.min(59, math.max(1, audioLen)), math.min(59, math.max(1, audioLen))
		math.min(59, math.max(1, audioLen)).audioLen = audioLen
		math.min(59, math.max(1, audioLen)).audioId = audioId
		local math.min(59, math.max(1, audioLen)).localAudioId, data = localIdentifier, math.min(59, math.max(1, audioLen))
		print("语音上传到了SDK服务器，接下来发送有游戏服务器---------------------------------------")
		dump(data, "data")
		self:sendAudioToGame(data)
	else
		local iconSprite = display.newSprite("#icon_liaotian_yuyin.png")
		SoraDShowMsgTip(i18n("common_text_2094"), iconSprite)
	end
end
function chatAudioMgr:userSDKManager_downloadRecCallBack(finished, localIdentifier, remoteIdentifier)
	print("userSDKManager_downloadRecCallBack --------------------", finished, localIdentifier, remoteIdentifier)
	if finished and localIdentifier and remoteIdentifier then
		print("-----TODO: 判断下是否需要播放------- 目前是直接播放-------, localIdentifier = ", localIdentifier, ", remoteIdentifier = ", remoteIdentifier)
		local item = self.tblDownloadAudio[tostring(remoteIdentifier)]
		if not item then
			return
		end
		self:delFromDownloadAudio(remoteIdentifier)
		local param = item.param
		local curItemData = self.chatDataMgr:getData(param.chatChannel, param.chatSet, param.key)
		if curItemData == nil then
			curItemData, _ENV = self.chatDataMgr, self.chatDataMgr
		end
		local isFound = false
		for _, v in ipairs(curItemData) do
			if v.dataType == gChatDataType.dataType_audio and v.customData.audioId == remoteIdentifier and (v.netStatus == gChatNetStatus.downloading or v.netStatus == gChatNetStatus.warn_downloading) then
				print("找到了--------------------------------------------")
				v.netStatus = gChatNetStatus.normal
				v.customData.localAudioId = localIdentifier
				if v.itemNode and v.itemNode.updateNetStatus then
					v.itemNode:updateNetStatus()
					if self:hasCurWaitPlayAudio() and self:getCurWaiPlayAudioId() == remoteIdentifier then
						self:cleanWaitPlayAudio()
						if self:hasCurPlayAudio() then
							self:stopCurPlayAudio()
						end
						_ENV = nil
						;(nil).param = param
						;(nil).localAudioId = v.customData.localAudioId
						;(nil).audioId = v.customData.audioId
						;(nil).itemData = v
						self:saveCurPlayAudio(nil)
						print("真的开始开始播放语音-----------------------------")
						self:playAudio(v)
					end
				end
				isFound = true
				break
			end
		end
	else
		local iconSprite = display.newSprite("#icon_liaotian_yuyin.png")
		SoraDShowMsgTip(i18n("common_text_2089"), iconSprite)
	end
end
function chatAudioMgr:userSDKManager_playOrStopRecProgressCallBack(decibel, timeInterval)
	if decibel == -1 then
		print("TODO: ----停止了语音播放-------------")
	end
	print("userSDKManager_playOrStopRecProgressCallBack, ", "decibel = ", decibel, ", timerInterval = ", timeInterval)
end
function chatAudioMgr:reqReadAudio(data)
	local func = chatAudioMgr.reqReadAudioFuncs[data.chatChannel]
	if func then
		func(self, data)
	else
		print("chatAudioMgr:reqReadAudio(data) not implemented! chatChannel = ", data.chatChannel)
	end
end
function chatAudioMgr:reqReadAudioNormal(data)
	local chatCtrl = gametop.playertop_:getModule("chatCtrl")
	chatCtrl:reportAllianceChatMsgStatus(data.serverMsg, gMsgStatus.READ)
end
function chatAudioMgr:reqReadAudioMail(data)
	local mailCtrl = gametop.playertop_:getModule("mailCtrl")
	if data.mail then
		mailCtrl:viewVoiceMsg(data.mail.property.mid)
	end
end
_ENV, chatAudioMgr.reqReadAudioChatRoom = function(self, data)
	local chatroomCtrl = gametop.playertop_:getModule("chatroomCtrl")
	if data.serverMsg then
		chatroomCtrl:reqChatRoomReportChatMsgStatus(data.serverMsg.chatroom.crid, data.serverMsg, gMsgStatus.READ)
	end
end, function(self, data)
	local chatroomCtrl = gametop.playertop_:getModule("chatroomCtrl")
	if data.serverMsg then
		chatroomCtrl:reqChatRoomReportChatMsgStatus(data.serverMsg.chatroom.crid, data.serverMsg, gMsgStatus.READ)
	end
end
;(function(self, data)
	local chatroomCtrl = gametop.playertop_:getModule("chatroomCtrl")
	if data.serverMsg then
		chatroomCtrl:reqChatRoomReportChatMsgStatus(data.serverMsg.chatroom.crid, data.serverMsg, gMsgStatus.READ)
	end
end)[gChatChannel.ALLIANCE] = chatAudioMgr.reqReadAudioNormal
;(function(self, data)
	local chatroomCtrl = gametop.playertop_:getModule("chatroomCtrl")
	if data.serverMsg then
		chatroomCtrl:reqChatRoomReportChatMsgStatus(data.serverMsg.chatroom.crid, data.serverMsg, gMsgStatus.READ)
	end
end)[gChatChannel.TEAM] = chatAudioMgr.reqReadAudioNormal
;(function(self, data)
	local chatroomCtrl = gametop.playertop_:getModule("chatroomCtrl")
	if data.serverMsg then
		chatroomCtrl:reqChatRoomReportChatMsgStatus(data.serverMsg.chatroom.crid, data.serverMsg, gMsgStatus.READ)
	end
end)[gChatChannel.MAIL] = chatAudioMgr.reqReadAudioMail
chatAudioMgr.reqReadAudioFuncs, (function(self, data)
	local chatroomCtrl = gametop.playertop_:getModule("chatroomCtrl")
	if data.serverMsg then
		chatroomCtrl:reqChatRoomReportChatMsgStatus(data.serverMsg.chatroom.crid, data.serverMsg, gMsgStatus.READ)
	end
end)[gChatChannel.CHATROOM] = function(self, data)
	local chatroomCtrl = gametop.playertop_:getModule("chatroomCtrl")
	if data.serverMsg then
		chatroomCtrl:reqChatRoomReportChatMsgStatus(data.serverMsg.chatroom.crid, data.serverMsg, gMsgStatus.READ)
	end
end, chatAudioMgr.reqReadAudioChatRoom
function chatAudioMgr:playAudio(data)
	if data.customData and data.customData.localAudioId ~= nil then
		if self:getIsCapture() then
			self:cleanCurPlayAudio()
			print("当前正在录制语音，无法播放，直接返回-----------------------------------")
			return
		end
		data.playStatus = gPlayStatus.playing_audio
		if data.itemNode and data.itemNode.updatePlayStatus then
			data.itemNode:updatePlayStatus()
		end
		print("调用SDK开始播放声音---------------------------------------, localAudioId = , ", data.customData.localAudioId, ", audioId = ", data.customData.audioId)
		self:pauseMusic()
		userSDKManager.playOrStop(data.customData.localAudioId)
		_ENV = userSDKManager.playOrStop
		userSDKManager.playOrStop.chatChannel = data.chatChannel
		userSDKManager.playOrStop.chatSet = data.chatSet
		local userSDKManager.playOrStop.key, param = data.key, userSDKManager.playOrStop
		self:playAudioTimeOutManage(param, data.customData.audioId, data.customData.audioLen)
	end
end
function chatAudioMgr:playOrStop(data)
	if self:isSending(data) then
		print("正在发送中......")
		return
	end
	if self:isLoading(data) then
		print("加载中....")
		return
	end
	if data.playStatus == gPlayStatus.playing_audio and self:getCurPlayAudioId() == data.customData.audioId then
		print("本身正在播放，停止播放-----------")
		if self:hasCurPlayAudio() then
			self:stopCurPlayAudio()
		end
		self:cleanWaitPlayAudio()
		return
	end
	print("开始播放语音消息----------------------------------")
	dump(data.customData, "语音数据")
	if data.readStatus == gChatReadStatus.unread then
		data.readStatus = gChatReadStatus.normal
		if data.itemNode and data.itemNode.updateReadStatus then
			data.itemNode:updateReadStatus()
		end
		self:reqReadAudio(data)
	end
	_ENV = self.reqReadAudio
	self.reqReadAudio.chatChannel = data.chatChannel
	self.reqReadAudio.chatSet = data.chatSet
	local self.reqReadAudio.key, param = data.key, self.reqReadAudio
	if data.customData and data.customData.localAudioId ~= nil then
		print("本地已经有语音，直接播放-----------------")
		if self:hasCurPlayAudio() then
			self:stopCurPlayAudio()
		end
		self:cleanWaitPlayAudio()
		_ENV = nil
		;(nil).param = param
		;(nil).localAudioId = data.customData.localAudioId
		;(nil).audioId = data.customData.audioId
		;(nil).itemData = data
		self:saveCurPlayAudio(nil)
		self:playAudio(data)
	else
		if data.customData and data.customData.audioId == nil then
			local iconSprite = display.newSprite("#icon_liaotian_yuyin.png")
			SoraDShowMsgTip(i18n("common_text_2089"), iconSprite)
			return
		end
		print("本地没有语音，需要下载后播放--------------")
		data.netStatus = gChatNetStatus.downloading
		self:delayShowLoadingManage(param, data.customData.audioId)
		self:cleanWaitPlayAudio()
		_ENV = param
		param.param = param
		param.audioId = data.customData.audioId
		param.itemData = data
		self:saveWaitPlayAudio(param)
		print(" ---------请求下载远程数据: ", data.customData.audioId)
		self:addToDownloadAudio(param, data.customData.audioId)
		self:downloadAudioTimeOutManage(param, data.customData.audioId)
		userSDKManager.downloadRec(data.customData.audioId)
	end
end
return chatAudioMgr
