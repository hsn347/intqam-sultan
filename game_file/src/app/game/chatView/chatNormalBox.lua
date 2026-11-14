local chatFunctions = include("chatFunctions")
local lordLocalData = include("lordLocalData")
local mailFunctions = include("mailFunctions")
local chatConst = include("chatConst")
local gametop = gModuleMgr.getObject("gametop")
local mailCtrl = gametop.playertop_:getModule("mailCtrl")
local chatCtrl = gametop.playertop_:getModule("chatCtrl")
local chatroomCtrl = gametop.playertop_:getModule("chatroomCtrl")
local chatAudioMgr = gChatMgrs:getMgr("chatAudioMgr")
local chatSendMgr = gChatMgrs:getMgr("chatSendMgr")
local maxWidth = 600
local minHeight = 105
local deltaTopAvatar = 5
local deltaSideAvatar = 10
local deltaSideChatBg = 110
local deltaTopChatBg = 35
local deltaTopChatBgKing = 100
local deltaSideNameBox = 135
local deltaTopNameBox = 10
local deltaChatTipBg = 0
local sizeChatTip = cc.size(61, 16)
local sizeRedPointTip = cc.size(18, 18)
local deltaChatRedPointBg = 10
local deltaCheckSendTime = 5
local deltaKingCapHeight = 50
local _ENV, tableWaitData
local gametop = gModuleMgr.getObject("gametop")
local translateCtrl = gametop.playertop_:getModule("translateCtrl")
local chatNormalBox = class("chatNormalBox", function(target)
	if target == nil then
		return display.newNode()
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function chatNormalBox:ctor()
	self.singleIsMoved = false
	self.ChatPanel = ccui.Layout:create()
	self.ChatPanel:setAnchorPoint(cc.p(0, 0))
	self.ChatPanel:setPosition(cc.p(0, 0))
	self.ChatPanel:addTo(self)
	self.ChatPanel:setTouchEnabled(true)
	self.ChatPanel:setSwallowTouches(false)
	self.ChatPanel:setContentSize(cc.size(600, 105))
	self.ChatPanel:addTouchEventListener(handler(self, self.onChatPanel))
	self.playerAvatarBoxNode = SoraDCreatePanel("playerAvatarBox")
	self.playerAvatarBoxNode:setPosition(cc.p(10, 0))
	self.playerAvatarBoxNode:addTo(self.ChatPanel)
	self.playerAvatarBoxNode:setBtnTouchEnabled(false)
	self.playerNameBoxNode = SoraDCreatePanel("playerNameBox")
	self.playerNameBoxNode:setPosition(cc.p(140, 70))
	self.playerNameBoxNode:addTo(self.ChatPanel)
	self.playerChatContentNode = SoraDCreatePanel("playerChatContent")
	self.playerChatContentNode:setPosition(cc.p(110, 0))
	self.playerChatContentNode:addTo(self.ChatPanel)
	local itemSize = self.ChatPanel:getContentSize()
	self.itemWidth = itemSize.width
	self.itemHeight = itemSize.height
end
function chatNormalBox:initWithData(data)
	self.itemData = data
	self.isShowKing = false
	self.isShowLegendKing = false
	self.isShowLegendForSepKing = false
	if self.playerAvatarBoxNode then
		if data.chatType == 3 and data.allianceId ~= nil and data.allianceId ~= 0 then
			lordLocalData = data.allianceId
			data.allianceId.allianceId = data.allianceId
			data.allianceId.allianceFlag = data.allianceFlag
			data.allianceId.playerId = data.playerId
			local data.allianceId.chatType, avatarBoxData = data.chatType, data.allianceId
			self.playerAvatarBoxNode:initWithAllianceData(avatarBoxData)
		else
			local imgHead = "head_m_001.png"
			if data.imageId then
				imgHead = lordLocalData.getHead(data.imageId)
			end
			local isKing = data.isKing
			local isLegendKing = data.isLegendKing
			local isLegendForSepKing = data.isLegendForSepKing
			local isHegemon = data.isHegemon
			if data.isSysMsg == true then
				isKing = false
			end
			if data.isSysMsg == true then
				isLegendKing = false
				isHegemon = false
				isLegendForSepKing = false
			end
			if data.dataType == gChatDataType.dataType_red_packet then
				isKing = false
				isLegendKing = false
				isHegemon = false
				isLegendForSepKing = false
			end
			if data.isKNotice then
				isKing = false
				isLegendKing = false
				isHegemon = false
				isLegendForSepKing = false
			end
			self.isShowKing = isKing
			self.isShowLegendKing = isLegendKing
			self.isShowLegendForSepKing = isLegendForSepKing
			lordLocalData, self.isShowHegemon = data.isKNotice, isHegemon
			data.isKNotice.playerId = data.playerId
			data.isKNotice.imageId = data.imageId
			data.isKNotice.avatar = data.avatarUrl
			data.isKNotice.imgPlayer = imgHead
			data.isKNotice.chatType = data.chatType
			data.isKNotice.alv = data.alv
			data.isKNotice.isKing = isKing
			data.isKNotice.isLegendKing = isLegendKing
			data.isKNotice.isLegendForSepKing = isLegendForSepKing
			local data.isKNotice.isHegemon, avatarBoxData = isHegemon, data.isKNotice
			self.playerAvatarBoxNode:initWithData(avatarBoxData)
		end
	end
	local settingCtrl = gametop.playertop_:getModule("settingCtrl")
	local tl = settingCtrl:getTranslateLanguage()
	if self.playerChatContentNode then
		local content = data.content
		if not data.isSelf and data.translation and data.isShowTranslate == true then
			content = data.translation.tText[tl] and data.translation.tText[tl].text or ""
		end
		if not data.isSendToAll or data.isSendToAll == 1 then
		end
		local info = data.time
		if not data.isSelf and data.translation and data.isShowTranslate == true then
			local langAbbrRead = include("langAbbrRead")
			local sourceKey = langAbbrRead.getAbbrName(data.translation.sl)
			local abbrName = data.translation.sl
			if sourceKey ~= nil then
				abbrName = i18n(sourceKey)
			end
			lordLocalData = nil
			;(nil).language = abbrName
			local prefix = i18n("common_text_1635", nil)
			prefix = prefix or "from " .. data.translation.sl
			info = prefix .. "  " .. info
		end
		lordLocalData = langAbbrRead
		include("langAbbrRead").playerId = data.playerId
		include("langAbbrRead").isSys = data.isSysMsg
		include("langAbbrRead").align = data.align
		include("langAbbrRead").isKNotice = data.isKNotice
		include("langAbbrRead").sysType = data.sysType
		include("langAbbrRead").chatId = data.chatId
		include("langAbbrRead").content = content
		include("langAbbrRead").translateContent = data.translateContent
		include("langAbbrRead").info = info
		include("langAbbrRead").dataType = data.dataType
		include("langAbbrRead").customData = data.customData
		include("langAbbrRead").labelSize = data.labelSize
		include("langAbbrRead").isKing = data.isKing
		include("langAbbrRead").isLegendKing = data.isLegendKing
		include("langAbbrRead").isLegendForSepKing = data.isLegendForSepKing
		include("langAbbrRead").isHegemon = data.isHegemon
		local include("langAbbrRead").isSendToAll, chatContentData = data.isSendToAll, include("langAbbrRead")
		self.playerChatContentNode:initWithData(chatContentData)
	end
	if self.playerNameBoxNode then
		local playerName = mailFunctions:getWrappedName(data.alliance, data.nickName)
		lordLocalData = mailFunctions
		mailFunctions.isVip = data.isVip
		mailFunctions.vipLv = data.vipLv
		mailFunctions.name = playerName
		mailFunctions.isGM = data.isGM
		local mailFunctions.kid, nameboxData = data.kid, mailFunctions
		self.playerNameBoxNode:initWithData(nameboxData)
		if data.chatType == 2 then
		end
	end
	local chatContentHeight = self.playerChatContentNode:getItemHeight()
	local chatContentWidth = self.playerChatContentNode:getItemWidth()
	local totalHeight = chatContentHeight + deltaTopChatBg + ((self.isShowLegendKing or self.isShowLegendForSepKing or self.isShowKing) and deltaKingCapHeight or 0)
	local deltaKing = (self.isShowLegendKing or self.isShowLegendForSepKing or self.isShowKing or self.isShowHegemon) and deltaKingCapHeight or 0
	if totalHeight < minHeight then
		totalHeight = minHeight
	end
	self.itemWidth = maxWidth
	self.itemHeight = totalHeight
	if data.align == 0 then
		self.playerAvatarBoxNode:setPosition(cc.p(deltaSideAvatar, self.itemHeight - deltaTopAvatar - self.playerAvatarBoxNode:getItemHeight() - deltaKing))
		self.playerChatContentNode:setPosition(cc.p(deltaSideChatBg, self.itemHeight - deltaTopChatBg - self.playerChatContentNode:getItemHeight() - deltaKing))
		self.playerNameBoxNode:setPosition(cc.p(deltaSideNameBox, self.itemHeight - deltaTopNameBox - self.playerNameBoxNode:getItemHeight() - deltaKing))
	elseif data.align == 1 then
		self.playerAvatarBoxNode:setPosition(cc.p(self.itemWidth - deltaSideAvatar - self.playerAvatarBoxNode:getItemWidth(), self.itemHeight - deltaTopAvatar - self.playerAvatarBoxNode:getItemHeight() - deltaKing))
		self.playerChatContentNode:setPosition(cc.p(self.itemWidth - deltaSideChatBg - self.playerChatContentNode:getItemWidth(), self.itemHeight - deltaTopChatBg - self.playerChatContentNode:getItemHeight() - deltaKing))
		self.playerNameBoxNode:setPosition(cc.p(self.itemWidth - deltaSideNameBox - self.playerNameBoxNode:getItemWidth(), self.itemHeight - deltaTopNameBox - self.playerNameBoxNode:getItemHeight() - deltaKing))
	end
	self:updateNetStatus()
	self:updateWarnStatus()
	self:updatePlayStatus()
	self:udpateReadStatus()
	self.ChatPanel:setContentSize(cc.size(self.itemWidth, self.itemHeight))
end
function chatNormalBox:onChatPanel(sender, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		local touchEndPos = sender:getTouchEndPosition()
		if true == self.playerAvatarBoxNode:getIsTouchPointInPlayer(touchEndPos) then
			SoraDPlaySound()
			if self.itemData.dataType == gChatDataType.dataType_audio and chatFunctions.getIsPlayerSelf(self.itemData.playerId) then
			else
				if self.itemData.playerId == 0 then
					return
				end
				_ENV = self.itemData.playerId
				self.itemData.playerId.msg = "MESSAGE_CHAT_SHOW_CHAT_MENU"
				self.itemData.playerId.itemData = self.itemData
				self.itemData.playerId.sender = sender
				SoraDSendMessage(self.itemData.playerId)
			end
			return
		elseif true == self.playerChatContentNode:getIsTouchPointInPlayer(touchEndPos) then
			if self.itemData.dataType == gChatDataType.dataType_red_packet then
				if not worldMapDefine.inInCrossWar() then
					local content = self.itemData.customData
					local uid = chatFunctions:getSelfId()
					local rid = content.redPacketInfo.RID
					print("请求查看红包-------------1111, uid = ", uid, " , rid = ", rid)
					SoraDShowLoading()
					local gametop = gModuleMgr.getObject("gametop")
					local redenvelopesCtrl = gametop.playertop_:getModule("redenvelopesCtrl")
					redenvelopesCtrl:sendCheck(uid, rid)
				else
					SoraDShowMsgTip(i18n("common_text_4479"))
				end
			elseif self.itemData.dataType == gChatDataType.dataType_audio then
				if self.itemData.netStatus == chatConst.netStatus.sending or self.itemData.netStatus == chatConst.netStatus.uploading or self.itemData.warnStatus == chatConst.warnStatus.warn_sending or self.itemData.warnStatus == chatConst.warnStatus.warn_uploading then
					print("正在发送中......")
					return
				end
				if self.itemData.netStatus == chatConst.netStatus.downloading or self.itemData.warnStatus == chatConst.warnStatus.warn_downloading then
					print("加载中....")
					return
				end
				if self.itemData.playStatus == chatConst.playStatus.playing_audio and chatAudioMgr:getCurPlayAudioId() == self.itemData.customData.audioId then
					print("本身正在播放，停止播放-----------")
					if chatAudioMgr:hasCurPlayAudio() then
						chatAudioMgr:stopCurPlayAudio()
					end
					chatAudioMgr:cleanWaitPlayAudio()
					return
				end
				print("开始播放语音消息----------------------------------")
				dump(self.itemData.customData, "语音数据")
				if self.itemData.readStatus == chatConst.readStatus.audio_unread then
					self.itemData.readStatus = chatConst.readStatus.default
					self:hideReadStatus()
					if self.itemData.chatType == gChatTypeUI.alliance then
						print("发起联盟频道的语音阅读请求-------------")
						chatCtrl:reportAllianceChatMsgStatus(self.itemData.serverMsg, gMsgStatus.READ)
					elseif self.itemData.chatType == gChatTypeUI.mail then
						print("发起邮件私聊的语音阅读请求")
						if self.itemData.mail then
							mailCtrl:viewVoiceMsg(self.itemData.mail.property.mid)
						end
					elseif self.itemData.chatType == gChatTypeUI.chatRoom then
						print("发起聊天室的语音阅读请求")
						if self.itemData.serverMsg then
							chatroomCtrl:reqChatRoomReportChatMsgStatus(self.itemData.serverMsg.chatroom.crid, self.itemData.serverMsg, gMsgStatus.READ)
						end
					end
				end
				if self.itemData.customData and self.itemData.customData.localAudioId ~= nil then
					print("本地已经有语音，直接播放-----------------")
					if chatAudioMgr:hasCurPlayAudio() then
						chatAudioMgr:stopCurPlayAudio()
					end
					chatAudioMgr:cleanWaitPlayAudio()
					_ENV = self.itemData.serverMsg.chatroom.crid
					self.itemData.serverMsg.chatroom.crid.chatType = self.itemData.chatType
					self.itemData.serverMsg.chatroom.crid.localAudioId = self.itemData.customData.localAudioId
					self.itemData.serverMsg.chatroom.crid.audioId = self.itemData.customData.audioId
					self.itemData.serverMsg.chatroom.crid.itemData = self.itemData
					chatAudioMgr:saveCurPlayAudio(self.itemData.serverMsg.chatroom.crid)
					self:playAudio()
				else
					if self.itemData.customData and self.itemData.customData.audioId == nil then
						local iconSprite = display.newSprite("#icon_liaotian_yuyin.png")
						SoraDShowMsgTip(i18n("common_text_2089"), iconSprite)
						return
					end
					print("本地没有语音，需要下载后播放--------------")
					self.itemData.netStatus = chatConst.netStatus.downloading
					chatAudioMgr:delayShowLoadingManage(self.itemData.chatType, self.itemData.customData.audioId)
					chatAudioMgr:cleanWaitPlayAudio()
					_ENV = self.itemData.chatType
					self.itemData.chatType.chatType = self.itemData.chatType
					self.itemData.chatType.audioId = self.itemData.customData.audioId
					self.itemData.chatType.itemData = self.itemData
					chatAudioMgr:saveWaitPlayAudio(self.itemData.chatType)
					print(" ---------请求下载远程数据: ", self.itemData.customData.audioId)
					chatAudioMgr:addToDownloadAudio(self.itemData.chatType, self.itemData.customData.audioId)
					chatAudioMgr:downloadAudioTimeOutManage(self.itemData.chatType, self.itemData.customData.audioId)
					userSDKManager.downloadRec(self.itemData.customData.audioId)
				end
			else
				if self.itemData.playerId == 0 then
					return
				end
				_ENV = self.itemData.customData.audioId
				self.itemData.customData.audioId.msg = "MESSAGE_CHAT_SHOW_CHAT_MENU"
				self.itemData.customData.audioId.itemData = self.itemData
				self.itemData.customData.audioId.sender = sender
				SoraDSendMessage(self.itemData.customData.audioId)
			end
			SoraDPlaySound()
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = sender:getTouchBeganPosition()
		local touchmovePoint = sender:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	elseif event == ccui.TouchEventType.began then
	end
end
function chatNormalBox:getLabelSize()
	if self.playerChatContentNode then
		return self.playerChatContentNode:getLabelSize()
	else
		return nil
	end
end
function chatNormalBox:getItemWidth()
	return self.itemWidth
end
function chatNormalBox:getItemHeight()
	return self.itemHeight
end
function chatNormalBox:showSending()
	self:hideWarning()
	if self.imgSending then
		self.imgSending:setVisible(true)
	else
		self.imgSending = ccui.ImageView:create()
		self.imgSending:ignoreAnchorPointForPosition(false)
		self.imgSending:ignoreContentAdaptWithSize(true)
		self.imgSending:loadTexture("icon_circle_small.png", ccui.TextureResType.plistType)
		self.imgSending:setAnchorPoint(cc.p(0.5, 0.5))
		self.ChatPanel:addChild(self.imgSending, 1)
	end
	self.imgSending:stopAllActions()
	local actionRotateBy = cc.RotateBy:create(1.0, 360)
	local repeatForever = cca.repeatForever(actionRotateBy)
	self.imgSending:runAction(repeatForever)
	local pos = self:getIconTipPos()
	self.imgSending:setPosition(cc.p(pos.x, pos.y))
end
function chatNormalBox:showWaring()
	self:hideSending()
	if self.btnWarning then
		self.btnWarning:setVisible(true)
	else
		self.btnWarning = ccui.Button:create()
		self.btnWarning:setSwallowTouches(true)
		self.btnWarning:setTouchEnabled(true)
		self.btnWarning:loadTextures("icon_warning_small.png", "icon_warning_small.png", "", ccui.TextureResType.plistType)
		self.btnWarning:setPressedActionEnabled(true)
		self.btnWarning:addTouchEventListener(handler(self, self.btnReSend))
		self.ChatPanel:addChild(self.btnWarning, 1)
	end
	self.btnWarning:setPosition(self:getIconTipPos())
end
function chatNormalBox:hideSending()
	if self.imgSending then
		self.imgSending:setVisible(false)
		self.imgSending:stopAllActions()
	end
end
function chatNormalBox:hideWarning()
	if self.btnWarning then
		self.btnWarning:setVisible(false)
	end
end
function chatNormalBox:getIconTipPos()
	local chatContentHeight = self.playerChatContentNode:getItemHeight()
	local chatContentWidth = self.playerChatContentNode:getItemWidth()
	local _deltaTopChatBg = deltaTopChatBg
	if self.isShowKing or self.isShowLegendKing or self.isShowLegendForSepKing then
		_deltaTopChatBg = deltaTopChatBgKing
	end
	local pos
	if self.itemData.align == 0 then
		local posx = deltaSideChatBg + chatContentWidth + deltaChatTipBg + sizeChatTip.width / 2
		local posy = self.itemHeight - (_deltaTopChatBg + chatContentHeight / 2 + sizeChatTip.height / 2)
		pos = cc.p(posx, posy)
	else
		local posx = self.itemWidth - (deltaSideChatBg + chatContentWidth + deltaChatTipBg + sizeChatTip.width / 2)
		local posy = self.itemHeight - (_deltaTopChatBg + chatContentHeight / 2 + sizeChatTip.height / 2)
		pos = cc.p(posx, posy)
	end
	return pos
end
function chatNormalBox:btnReSend(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.itemData.warnStatus == chatConst.warnStatus.warn_sending then
			SoraDShowMsgBox(i18n("common_text_896"), i18n("common_text_054"), nil, handler(self, self.confirmSend))
		elseif self.itemData.warnStatus == chatConst.warnStatus.warn_uploading then
			SoraDShowMsgBox(i18n("common_text_896"), i18n("common_text_054"), nil, handler(self, self.confirmUpload))
		elseif self.itemData.warnStatus == chatConst.warnStatus.warn_downloading then
			SoraDShowMsgBox(i18n("common_text_2090"), i18n("common_text_054"), nil, handler(self, self.confirmDownload))
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function chatNormalBox:confirmUpload(eventType)
	if eventType == MSGBOX_CALLBACK_YES then
		if self.itemData.dataType ~= gChatDataType.dataType_audio then
			return
		end
		print("重新上传语音消息----------------------------")
		self:showUploading()
		self.itemData.netStatus = chatConst.netStatus.uploading
		local chatTypeUI = self.itemData.chatType
		chatAudioMgr:uploadAudioTimeOutManage(chatTypeUI, self.itemData.chatIndex, self.itemData.customData.localAudioId)
		userSDKManager.uploadRec(self.itemData.customData.localAudioId)
	end
end
function chatNormalBox:confirmDownload(eventType)
	if eventType == MSGBOX_CALLBACK_YES then
		if self.itemData.dataType ~= gChatDataType.dataType_audio then
			return
		end
		print("重新加载语音消息----------------------------")
		self:showDownloading()
		self.itemData.netStatus = chatConst.netStatus.downloading
		self.itemData.warnStatus = chatConst.warnStatus.default
		chatAudioMgr:cleanWaitPlayAudio()
		_ENV = nil
		;(nil).chatType = self.itemData.chatType
		;(nil).audioId = self.itemData.customData.audioId
		;(nil).itemData = self.itemData
		chatAudioMgr:saveWaitPlayAudio(nil)
		chatAudioMgr:downloadAudioTimeOutManage(self.itemData.chatType, self.itemData.customData.audioId)
		userSDKManager.downloadRec(self.itemData.customData.audioId)
	end
end
function chatNormalBox:confirmSend(eventType)
	if eventType == MSGBOX_CALLBACK_YES then
		print("重新发送....")
		self:showSending()
		self.itemData.netStatus = chatConst.netStatus.sending
		if self.itemData.chatType == gChatTypeUI.alliance or self.itemData.chatType == gChatTypeUI.kingdom then
			local message = self.itemData.content
			local messageType = gChatTypeDef.chat_content_text
			if self.itemData.dataType == gChatDataType.dataType_text then
				messageType = gChatTypeDef.chat_content_text
			elseif self.itemData.dataType == gChatDataType.dataType_emotion then
				messageType = gChatTypeDef.chat_content_expression
			elseif self.itemData.dataType == gChatDataType.dataType_audio then
				message = self.itemData.customData
				messageType = gChatTypeDef.chat_content_audio
			end
			local chatIndex = self.itemData.chatIndex
			_ENV = nil
			;(nil).message = message
			;(nil).messageType = messageType
			;(nil).chatIndex = chatIndex
			chatSendMgr:reSendMessage(nil)
		elseif self.itemData.chatType == gChatTypeUI.mail then
			if self.itemData.dataType == gChatDataType.dataType_audio then
				local isSendToAll = self.itemData.isSendToAll
				chatSendMgr:sendMsgTimeOutManage(self.itemData.chatIndex, self.itemData.chatType)
				_ENV = chatSendMgr.sendMsgTimeOutManage
				chatSendMgr.sendMsgTimeOutManage.contentType = gChatMailContentType.content_audio
				chatSendMgr.sendMsgTimeOutManage.content = tostring(self.itemData.customData.audioLen) .. "''"
				chatSendMgr.sendMsgTimeOutManage.audioLen = self.itemData.customData.audioLen
				chatSendMgr.sendMsgTimeOutManage.audioId = self.itemData.customData.audioId
				chatSendMgr.sendMsgTimeOutManage.isRead = false
				chatSendMgr.sendMsgTimeOutManage.isSendToAll = isSendToAll
				chatSendMgr.sendMsgTimeOutManage.isKing = self.itemData.isKing
				chatSendMgr.sendMsgTimeOutManage.isLegendKing = self.itemData.isLegendKing
				chatSendMgr.sendMsgTimeOutManage.isLegendForSepKing = self.itemData.isLegendForSepKing
				chatSendMgr.sendMsgTimeOutManage.isHegemon = self.itemData.isHegemon
				local chatSendMgr.sendMsgTimeOutManage.chatIndex, content = self.itemData.chatIndex, chatSendMgr.sendMsgTimeOutManage
				if self.itemData.otherData and self.itemData.otherData.target then
					print("发送到")
					mailCtrl:sendChatMail(self.itemData.otherData.target, content)
				end
			elseif self.itemData.dataType == gChatDataType.dataType_text then
				local isKing = self.itemData.isKing
				local isLegendKing = self.itemData.isLegendKing
				local isLegendForSepKing = self.itemData.isLegendForSepKing
				local isHegemon = self.itemData.isHegemon
				_ENV = self.itemData.otherData.target
				self.itemData.otherData.target.contentType = gChatMailContentType.content_text
				self.itemData.otherData.target.content = self.itemData.content
				self.itemData.otherData.target.isKing = isKing
				self.itemData.otherData.target.isLegendKing = isLegendKing
				self.itemData.otherData.target.isLegendForSepKing = isLegendForSepKing
				local self.itemData.otherData.target.isHegemon, content = isHegemon, self.itemData.otherData.target
				if self.itemData.otherData and self.itemData.otherData.target then
					mailCtrl:sendChatMail(self.otherData.target, content)
				end
			elseif self.itemData.dataType == gChatDataType.dataType_emotion then
				local isKing = self.itemData.isKing
				local isLegendKing = self.itemData.isLegendKing
				local isLegendForSepKing = self.itemData.isLegendForSepKing
				local isHegemon = self.itemData.isHegemon
				_ENV = self.itemData.otherData.target
				self.itemData.otherData.target.contentType = gChatMailContentType.content_emo
				self.itemData.otherData.target.content = self.itemData.content
				self.itemData.otherData.target.isKing = isKing
				self.itemData.otherData.target.isLegendKing = isLegendKing
				self.itemData.otherData.target.isLegendForSepKing = isLegendForSepKing
				local self.itemData.otherData.target.isHegemon, content = isHegemon, self.itemData.otherData.target
				if self.itemData.otherData and self.itemData.otherData.target then
					mailCtrl:sendChatMail(self.itemData.otherData.target, content)
				end
			end
		elseif self.itemData.chatType == gChatTypeUI.chatRoom then
			if self.itemData.dataType == gChatDataType.dataType_audio then
				if self.itemData.otherData and self.itemData.otherData.crid then
					print("重新发送聊天室的语音消息, crid = ", self.itemData.otherData.crid)
					local gametop = gModuleMgr.getObject("gametop")
					_ENV = {
						["chatType"] = gChatRoomChatType.VOICE,
						["isKing"] = self.itemData.isKing,
						["isLegendKing"] = self.itemData.isLegendKing,
						["isLegendForSepKing"] = self.itemData.isLegendForSepKing,
						["isHegemon"] = self.itemData.isHegemon
					}
					_ENV = gChatRoomChatType.VOICE
					gChatRoomChatType.VOICE.audioLen = self.itemData.customData.audioLen
					gChatRoomChatType.VOICE.audioId = self.itemData.customData.audioId
					;({
						["chatType"] = gChatRoomChatType.VOICE,
						["isKing"] = self.itemData.isKing,
						["isLegendKing"] = self.itemData.isLegendKing,
						["isLegendForSepKing"] = self.itemData.isLegendForSepKing,
						["isHegemon"] = self.itemData.isHegemon
					}).content, gChatRoomChatType.VOICE.chatIndex = gChatRoomChatType.VOICE, self.itemData.chatIndex
					local msgData = {
						["chatType"] = gChatRoomChatType.VOICE,
						["isKing"] = self.itemData.isKing,
						["isLegendKing"] = self.itemData.isLegendKing,
						["isLegendForSepKing"] = self.itemData.isLegendForSepKing,
						["isHegemon"] = self.itemData.isHegemon
					}
					local crid = self.itemData.otherData.crid
					chatroomCtrl:reqChatRoomSendMsg(crid, msgData)
				end
			elseif self.itemData.dataType == gChatDataType.dataType_text then
				if self.itemData.otherData and self.itemData.otherData.crid then
					print("重新发送聊天室的语音消息, crid = ", self.itemData.otherData.crid)
					local gametop = gModuleMgr.getObject("gametop")
					_ENV = {
						["chatType"] = gChatRoomChatType.TEXT,
						["content"] = self.itemData.content,
						["isKing"] = self.itemData.isKing,
						["isLegendKing"] = self.itemData.isLegendKing,
						["isLegendForSepKing"] = self.itemData.isLegendForSepKing,
						["isHegemon"] = self.itemData.isHegemon
					}
					local msgData = {
						["chatType"] = gChatRoomChatType.TEXT,
						["content"] = self.itemData.content,
						["isKing"] = self.itemData.isKing,
						["isLegendKing"] = self.itemData.isLegendKing,
						["isLegendForSepKing"] = self.itemData.isLegendForSepKing,
						["isHegemon"] = self.itemData.isHegemon
					}
					local crid = self.itemData.otherData.crid
					chatroomCtrl:reqChatRoomSendMsg(crid, msgData)
				end
			elseif self.itemData.dataType == gChatDataType.dataType_emotion and self.itemData.otherData and self.itemData.otherData.crid then
				print("重新发送聊天室的表情消息, crid = ", self.itemData.otherData.crid)
				local gametop = gModuleMgr.getObject("gametop")
				_ENV = {
					["chatType"] = gChatRoomChatType.EMOJI,
					["content"] = self.itemData.content,
					["isKing"] = self.itemData.isKing,
					["isLegendKing"] = self.itemData.isLegendKing,
					["isLegendForSepKing"] = self.itemData.isLegendForSepKing,
					["isHegemon"] = self.itemData.isHegemon
				}
				local msgData = {
					["chatType"] = gChatRoomChatType.EMOJI,
					["content"] = self.itemData.content,
					["isKing"] = self.itemData.isKing,
					["isLegendKing"] = self.itemData.isLegendKing,
					["isLegendForSepKing"] = self.itemData.isLegendForSepKing,
					["isHegemon"] = self.itemData.isHegemon
				}
				local crid = self.itemData.otherData.crid
				chatroomCtrl:reqChatRoomSendMsg(crid, msgData)
			end
		end
	end
end
function chatNormalBox:toggleTranslate()
end
function chatNormalBox:getIconUnReadPos()
	local chatContentHeight = self.playerChatContentNode:getItemHeight()
	local chatContentWidth = self.playerChatContentNode:getItemWidth()
	local _deltaTopChatBg = deltaTopChatBg
	if self.isShowKing or self.isShowLegendKing or self.isShowLegendForSepKing then
		_deltaTopChatBg = deltaTopChatBgKing
	end
	local pos
	if self.itemData.align == 0 then
		local posx = deltaSideChatBg + chatContentWidth + deltaChatRedPointBg + sizeRedPointTip.width / 2
		local posy = self.itemHeight - (_deltaTopChatBg + sizeRedPointTip.height / 2)
		pos = cc.p(posx, posy)
	else
		local posx = self.itemWidth - (deltaSideChatBg + chatContentWidth + deltaChatRedPointBg + sizeRedPointTip.width / 2)
		local posy = self.itemHeight - (_deltaTopChatBg + sizeRedPointTip.height / 2)
		pos = cc.p(posx, posy)
	end
	return pos
end
function chatNormalBox:showUnRead()
	if self.imgUnRead then
		self.imgUnRead:setVisible(true)
	else
		self.imgUnRead = ccui.ImageView:create()
		self.imgUnRead:ignoreAnchorPointForPosition(false)
		self.imgUnRead:ignoreContentAdaptWithSize(true)
		self.imgUnRead:loadTexture("icon_liaotian_dot.png", ccui.TextureResType.plistType)
		self.imgUnRead:setColor(cc.c3b(179, 22, 0))
		self.imgUnRead:setAnchorPoint(cc.p(0.5, 0.5))
		self.ChatPanel:addChild(self.imgUnRead, 1)
	end
	local pos = self:getIconUnReadPos()
	self.imgUnRead:setPosition(cc.p(pos.x, pos.y))
end
function chatNormalBox:hideUnRead()
	if self.imgUnRead then
		self.imgUnRead:setVisible(false)
	end
end
function chatNormalBox:showPlayAudioAnim()
	self.playerChatContentNode:showPlayAudioAnim()
end
function chatNormalBox:stopPlayAudioAnim()
	self.playerChatContentNode:stopPlayAudioAnim()
end
function chatNormalBox:showUploading()
	self:showSending()
end
function chatNormalBox:hideUploading()
	self:hideSending()
end
function chatNormalBox:showDownloading()
	self:showSending()
end
function chatNormalBox:hideDownloading()
	self:hideSending()
end
function chatNormalBox:showWarnUploading()
	self:showWaring()
end
function chatNormalBox:hideWarnUploading()
	self:hideWarning()
end
function chatNormalBox:showWarnDownloading()
	self:showWaring()
end
function chatNormalBox:hideWarnDownloading()
	self:hideWarning()
end
function chatNormalBox:showAudioUnRead()
	self:showUnRead()
end
function chatNormalBox:hideAudioUnRead()
	self:hideUnRead()
end
function chatNormalBox:updateNetStatus()
	if self.itemData.netStatus == chatConst.netStatus.default or self.itemData.netStatus == nil then
		self:hideNetStatus()
	elseif self.itemData.netStatus == chatConst.netStatus.sending then
		self:showSending()
	elseif self.itemData.netStatus == chatConst.netStatus.uploading then
		self:showUploading()
	elseif self.itemData.netStatus == chatConst.netStatus.downloading then
		self:showDownloading()
	elseif self.itemData.netStatus == chatConst.netStatus.translating then
		self:showTranslateStatus()
	else
		print("TODO:chatNormalBox:updateNetStatus()", self.itemData.netStatus)
	end
end
function chatNormalBox:updateWarnStatus()
	if self.itemData.warnStatus == chatConst.warnStatus.default or self.itemData.warnStatus == nil then
		self:hideWarnStatus()
	elseif self.itemData.warnStatus == chatConst.warnStatus.warn_sending then
		self:showWaring()
	elseif self.itemData.warnStatus == chatConst.warnStatus.warn_uploading then
		self:showWarnUploading()
	elseif self.itemData.warnStatus == chatConst.warnStatus.warn_downloading then
		self:showWarnDownloading()
	else
		print("TODO:chatNormalBox:updateWarnStatus()", self.itemData.warnStatus)
	end
end
function chatNormalBox:updatePlayStatus()
	if self.itemData.playStatus == chatConst.playStatus.default or self.itemData.playStatus == nil then
		self:hidePlayStatus()
	elseif self.itemData.playStatus == chatConst.playStatus.playing_audio then
		self:showPlayAudioAnim()
	else
		print("TODO ------------------------------------------------: chatNormalBox:updatePlayStatus()", self.itemData.playStatus)
	end
end
function chatNormalBox:udpateReadStatus()
	if self.itemData.readStatus == chatConst.readStatus.default or self.itemData.readStatus == nil then
		self:hideReadStatus()
	elseif self.itemData.readStatus == chatConst.readStatus.audio_unread then
		self:showAudioUnRead()
	else
		print("TODO:chatNormalBox:udpateReadStatus()", self.itemData.readStatus)
	end
end
function chatNormalBox:hideNetStatus()
	self:hideSending()
end
function chatNormalBox:hideWarnStatus()
	self:hideWarning()
end
function chatNormalBox:hidePlayStatus()
	self:stopPlayAudioAnim()
end
function chatNormalBox:hideReadStatus()
	self:hideAudioUnRead()
end
function chatNormalBox:playAudio()
	if self.itemData.customData and self.itemData.customData.localAudioId ~= nil then
		if chatAudioMgr:getIsCapture() then
			chatAudioMgr:cleanCurPlayAudio()
			print("当前正在录制语音，无法播放，直接返回-----------------------------------")
			return
		end
		self.itemData.playStatus = chatConst.playStatus.playing_audio
		print("调用SDK开始播放声音---------------------------------------, localAudioId = , ", self.itemData.customData.localAudioId, ", audioId = ", self.itemData.customData.audioId)
		chatAudioMgr:pauseMusic()
		userSDKManager.playOrStop(self.itemData.customData.localAudioId)
		chatAudioMgr:playAudioTimeOutManage(self.itemData.chatType, self.itemData.customData.audioId, self.itemData.customData.audioLen)
		self:showPlayAudioAnim()
	end
end
function chatNormalBox:stopPlayAudio()
	self:stopPlayAudioAnim()
end
function chatNormalBox:showTranslateStatus()
	self:hideTranslateStatus()
	if not self.spriteTranslate then
		self.spriteTranslate = display.newSprite("#" .. "icon_translation_ar.png")
		self.ChatPanel:addChild(self.spriteTranslate, 1)
	else
		self.spriteTranslate:setVisible(true)
	end
	local _ENV, frames = self.spriteTranslate.setVisible, self.spriteTranslate.setVisible
	local frame1 = display.newSpriteFrame("icon_translation_ar.png")
	local frame2 = display.newSpriteFrame("icon_translation_en.png")
	table.insert(frames, frame1)
	table.insert(frames, frame2)
	local animation = display.newAnimation(frames, 0.25)
	self.spriteTranslate:playAnimationForever(animation)
	self.spriteTranslate:setAnchorPoint(cc.p(0.5, 0.5))
	local pos = self:getIconTipPos()
	dump(pos, "icon 位置")
	self.spriteTranslate:setPosition(cc.p(pos.x, pos.y))
	print("显示翻译动画-----------")
end
function chatNormalBox:hideTranslateStatus()
	if self.spriteTranslate then
		self.spriteTranslate:stopAllActions()
		local frame1 = display.newSpriteFrame("icon_translation_ar.png")
		if frame1 then
			self.spriteTranslate:setSpriteFrame(frame1)
		end
		self.spriteTranslate:setVisible(false)
	end
end
function chatNormalBox:showWarnTranslate()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:showWarnTranslate()
	end
end
function chatNormalBox:hideWarnTransalte()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:hideWarnTransalte()
	end
end
return chatNormalBox
