local chatConst = include("chatConst")
local gametop = gModuleMgr.getObject("gametop")
local translateCtrl = gametop.playertop_:getModule("translateCtrl")
local settingCtrl = gametop.playertop_:getModule("settingCtrl")
local chatItemView = class("chatItemView", function(target)
	if target == nil then
		return display.newNode()
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function chatItemView:ctor()
	local itemWidth = 600
	local itemHeight = 0
	self.itemWidth = itemWidth
	self.itemData, _UPVALUE0_, self.itemHeight = nil, nil, itemHeight
	self.chatDateBoxNode = nil
	self.chatNormalBoxNode = nil
	self.chatEmotionBoxNode = nil
end
function chatItemView:initWithData(data)
	if not data then
		return
	end
	self.itemData = data
	self:hideTip()
	if self.chatDateBoxNode then
		self.chatDateBoxNode:setVisible(false)
	end
	if self.chatEmotionBoxNode then
		self.chatEmotionBoxNode:setVisible(false)
	end
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:setVisible(false)
	end
	if self.chatSysBoxNode then
		self.chatSysBoxNode:setVisible(false)
	end
	local dataType = data.dataType
	if dataType == gChatDataType.dataType_text then
		self:initWithChatNormalBox(data)
	elseif dataType == gChatDataType.dataType_emotion then
		self:initWithChatEmotionBox(data)
	elseif dataType == gChatDataType.dataType_date then
		self:initWithChatDateBox(data)
	elseif dataType == gChatDataType.dataType_fightReport then
		self:initWithChatNormalBox(data)
	elseif dataType == gChatDataType.dataType_equip_create or dataType == gChatDataType.dataType_equip_share then
		self:initWithChatNormalBox(data)
	elseif dataType == gChatDataType.dataType_pyramid_share then
		self:initWithChatNormalBox(data)
	elseif dataType == gChatDataType.dataType_red_packet then
		self:initWithChatNormalBox(data)
	elseif dataType == gChatDataType.dataType_chatroom_sys_op then
		self:initWithChatSysBox(data)
	elseif dataType == gChatDataType.dataType_audio then
		self:initWithChatNormalBox(data)
	elseif dataType == gChatDataType.dataType_rally then
		self:initWithChatNormalBox(data)
	elseif dataType == gChatDataType.dataType_ancient_treasure or dataType == gChatDataType.dataType_ancient_treasure_rally then
		self:initWithChatNormalBox(data)
	elseif dataType == gChatDataType.dataType_eliminateGame_share then
		self:initWithChatNormalBox(data)
	elseif dataType == gChatDataType.dataType_starsWishGame_share then
		self:initWithChatNormalBox(data)
	elseif dataType == gChatDataType.dataType_king_of_glory then
		self:initWithChatNormalBox(data)
	else
		self:initWithChatNormalBox(data)
	end
	self.itemHeight = self.itemHeight
	self.itemWidth = self.itemWidth
end
function chatItemView:initWithChatDateBox(data)
	if self.chatDateBoxNode == nil then
		local chatDateBox = include("chatDateBox")
		self.chatDateBoxNode = chatDateBox.new()
		self.chatDateBoxNode:addTo(self, 1)
		self.chatDateBoxNode:setAnchorPoint(cc.p(0, 0))
		self.chatDateBoxNode:setPosition(cc.p(0, 0))
	else
		self.chatDateBoxNode:setVisible(true)
	end
	self.chatDateBoxNode:initWithData(data)
	self.itemWidth = self.chatDateBoxNode:getItemWidth()
	self.itemHeight = self.chatDateBoxNode:getItemHeight()
end
function chatItemView:initWithChatEmotionBox(data)
	if self.chatEmotionBoxNode == nil then
		local chatEmotionBox = include("chatEmotionBox")
		self.chatEmotionBoxNode = chatEmotionBox.new()
		self.chatEmotionBoxNode:addTo(self, 1)
		self.chatEmotionBoxNode:setAnchorPoint(cc.p(0, 0))
		self.chatEmotionBoxNode:setPosition(cc.p(0, 0))
	else
		self.chatEmotionBoxNode:setVisible(true)
	end
	self.chatEmotionBoxNode:initWithData(data)
	self.itemWidth = self.chatEmotionBoxNode:getItemWidth()
	self.itemHeight = self.chatEmotionBoxNode:getItemHeight()
end
function chatItemView:initWithChatNormalBox(data)
	if self.chatNormalBoxNode == nil then
		local chatNormalBox = include("chatNormalBox")
		self.chatNormalBoxNode = chatNormalBox.new()
		self.chatNormalBoxNode:addTo(self, 1)
		self.chatNormalBoxNode:setAnchorPoint(cc.p(0, 0))
		self.chatNormalBoxNode:setPosition(cc.p(0, 0))
	else
		self.chatNormalBoxNode:setVisible(true)
	end
	self.chatNormalBoxNode:initWithData(data)
	self.itemWidth = self.chatNormalBoxNode:getItemWidth()
	self.itemHeight = self.chatNormalBoxNode:getItemHeight()
end
function chatItemView:initWithChatSysBox(data)
	if self.chatSysBoxNode == nil then
		local chatSysBox = include("chatSystemInfoBox")
		self.chatSysBoxNode = chatSysBox.new()
		self.chatSysBoxNode:addTo(self, 1)
		self.chatSysBoxNode:setAnchorPoint(cc.p(0, 0))
		self.chatSysBoxNode:setPosition(cc.p(0, 0))
	else
		self.chatSysBoxNode:setVisible(true)
	end
	self.chatSysBoxNode:initWithData(data)
	self.itemWidth = self.chatSysBoxNode:getItemWidth()
	self.itemHeight = self.chatSysBoxNode:getItemHeight()
end
function chatItemView:showSending()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:showSending()
	end
	if self.chatEmotionBoxNode then
		self.chatEmotionBoxNode:showSending()
	end
end
function chatItemView:showWaring()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:showWaring()
	end
	if self.chatEmotionBoxNode then
		self.chatEmotionBoxNode:showWaring()
	end
end
function chatItemView:hideSending()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:hideSending()
	end
	if self.chatEmotionBoxNode then
		self.chatEmotionBoxNode:hideSending()
	end
end
function chatItemView:hideWarning()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:hideWarning()
	end
	if self.chatEmotionBoxNode then
		self.chatEmotionBoxNode:hideWarning()
	end
end
function chatItemView:hideTip()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:hideSending()
		self.chatNormalBoxNode:hideWarning()
		self.chatNormalBoxNode:hideTranslateStatus()
		self.chatNormalBoxNode:hideWarnTransalte()
	end
	if self.chatEmotionBoxNode then
		self.chatEmotionBoxNode:hideSending()
		self.chatEmotionBoxNode:hideWarning()
	end
end
function chatItemView:getLabelSize()
	if self.chatNormalBoxNode and self.chatNormalBoxNode:isVisible() then
		return self.chatNormalBoxNode:getLabelSize()
	else
		return nil
	end
end
function chatItemView:getItemWidth()
	return self.itemWidth
end
function chatItemView:getItemHeight()
	return self.itemHeight
end
function chatItemView:toggleTranslate(ignoreUpdateScroll, isAutoTranslate)
	local gametop = gModuleMgr.getObject("gametop")
	local translateCtrl = gametop.playertop_:getModule("translateCtrl")
	if self.chatNormalBoxNode == nil then
		return
	end
	local data = self.itemData
	if data.isShowTranslate == false then
		self:showTranslate(ignoreUpdateScroll, isAutoTranslate)
	else
		self:showOrigin(ignoreUpdateScroll, isAutoTranslate)
	end
end
function chatItemView:showTranslate(ignoreUpdateScroll, isAutoTranslate)
	if self.chatNormalBoxNode == nil then
		return
	end
	local data = self.itemData
	if self.itemData.isShowTranslate == true then
		return
	end
	if data.isSelf and not data.translation then
		return
	end
	local chatType = data.chatType
	local tl = settingCtrl:getTranslateLanguage()
	local isShowTranslate = false
	print("chatItemView:showTranslte isAutoTranslate = ", isAutoTranslate)
	if data.isShowTranslate == false and data.translation.tText ~= nil then
		if not isAutoTranslate then
			if data.translation.tText[tl] ~= nil then
				isShowTranslate = true
			end
		elseif isAutoTranslate == true then
			local isNeedTranslate, tText = translateCtrl:needTranslate(data.translation)
			print("sl = ", data.translation.sl, ", isNeedTranslate, tText = ", isNeedTranslate, tText)
			if isNeedTranslate == false and tText ~= nil then
				isShowTranslate = true
			end
		end
	end
	data.isShowTranslate = isShowTranslate
	if chatType == gChatTypeUI.mail then
		if data.mail then
			data.mail.property.data.isShowTranslate = isShowTransalte
		end
	elseif chatType == gChatTypeUI.chatRoom and data.serverMsg and data.serverMsg.data then
		data.serverMsg.data.isShowTranslate = isShowTransalte
	end
	if data.isShowTranslate == false then
		return
	end
	data.labelSize = nil
	data.itemWidth = 0
	data.itemHeight = 0
	self:initWithChatNormalBox(self.itemData)
	if not ignoreUpdateScroll then
		settingCtrl = self
		self.msg = "MESSAGE_CHAT_UPDATE_SCROLLVIEW"
		self.chatType = chatType
		SoraDSendMessage(self)
	end
end
function chatItemView:showOrigin(ignoreUpdateScroll, isAutoTranslate)
	if self.chatNormalBoxNode == nil then
		return
	end
	local data = self.itemData
	if self.itemData.isShowTranslate == false then
		return
	else
		local chatType = data.chatType
		local isShowTranslate = false
		data.isShowTranslate = isShowTranslate
		if chatType == gChatTypeUI.mail then
			if data.mail then
				data.mail.property.data.isShowTranslate = isShowTransalte
			end
		elseif chatType == gChatTypeUI.chatRoom and data.serverMsg and data.serverMsg.data then
			data.serverMsg.data.isShowTranslate = isShowTransalte
		end
	end
	data.labelSize = nil
	data.itemWidth = 0
	data.itemHeight = 0
	self:initWithChatNormalBox(self.itemData)
	if not ignoreUpdateScroll then
		_ENV = self
		self.msg = "MESSAGE_CHAT_UPDATE_SCROLLVIEW"
		self.chatType = chatType
		SoraDSendMessage(self)
	end
end
function chatItemView:playAudio()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:playAudio()
	end
end
function chatItemView:stopPlayAudio()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:stopPlayAudio()
	end
end
function chatItemView:showPlayAudioAnim()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:showPlayAudioAnim()
	end
end
function chatItemView:stopPlayAudioAnim()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:stopPlayAudioAnim()
	end
end
function chatItemView:showUploading()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:showUploading()
	end
end
function chatItemView:hideUploading()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:hideUploading()
	end
end
function chatItemView:showDownloading()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:showDownloading()
	end
end
function chatItemView:hideDownloading()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:hideDownloading()
	end
end
function chatItemView:showWarnDownloading()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:showWarnDownloading()
	end
end
function chatItemView:hideWarnDownloading()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:hideWarnDownloading()
	end
end
function chatItemView:showWarnUploading()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:showWarnUploading()
	end
end
function chatItemView:hideWarnUploading()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:hideWarnUploading()
	end
end
function chatItemView:showAudioUnRead()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:showAudioUnRead()
	end
end
function chatItemView:hideAudioUnRead()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:hideAudioUnRead()
	end
end
function chatItemView:updateNetStatus()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:updateNetStatus()
	end
end
function chatItemView:updateWarnStatus()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:updateWarnStatus()
	end
end
function chatItemView:updatePlayStatus()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:updatePlayStatus()
	end
end
function chatItemView:udpateReadStatus()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:udpateReadStatus()
	end
end
function chatItemView:showTranslateStatus()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:showTranslateStatus()
	end
end
function chatItemView:hideTranslateStatus()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:hideTranslateStatus()
	end
end
function chatItemView:showWarnTranslate()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:showWarnTranslate()
	end
end
function chatItemView:hideWarnTransalte()
	if self.chatNormalBoxNode then
		self.chatNormalBoxNode:hideWarnTransalte()
	end
end
function chatItemView:reInit(ignoreUpdateScroll)
	self.itemData.labelSize = nil
	self.itemData.itemWidth = 0
	self.itemData.itemHeight = 0
	self:initWithData(self.itemData)
	local chatType = self.itemData.chatType
	if not ignoreUpdateScroll then
		_ENV = self.itemData
		self.itemData.msg = "MESSAGE_CHAT_UPDATE_SCROLLVIEW"
		self.itemData.chatType = chatType
		SoraDSendMessage(self.itemData)
	end
end
return chatItemView
