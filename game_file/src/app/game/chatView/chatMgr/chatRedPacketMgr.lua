local chatBaseMgr = include("chatBaseMgr")
local chatRedPacketMgr = class("chatRedPacketMgr", chatBaseMgr)
function chatRedPacketMgr:init()
	self.chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
	self.chatMsgMgr = gChatMgrs:getMgr("chatMsgMgr")
	self.chatUnReadMgr = gChatMgrs:getMgr("chatUnReadMgr")
	self:reset()
end
function chatRedPacketMgr:reset()
	self.sendRPChatType = 0
	self.isReqViewRedPacket = false
	self.isReqViewDropBox = false
	self.allianceSurpise = false
	self.kingdomSurpise = false
	self.teamSurpise = false
	self.reqChatMessage = nil
end
function chatRedPacketMgr:clean()
	self:reset()
end
function chatRedPacketMgr:removeMessageListener()
	SoraDRemoveMessageByTarget(self)
end
function chatRedPacketMgr:registerMessageListener()
	SoraDAddMessage(self, "MESSAGE_CHAT_SERVER_GET_DROP_BOX", handler(self, self.sMsgDropBoxBack))
	SoraDAddMessage(self, "MESSAGE_CHAT_SERVER_GET_RED_PACKET", handler(self, self.sMsgRedPacketBack))
	SoraDAddMessage(self, "MESSAGE_ITEM_USE_SUCCESS_RED_PACKET", handler(self, self.sMsgUseRedPacketSuccess))
	SoraDAddMessage(self, "MESSAGE_CHAT_SERVER_CLAIM_RED_PACKET", handler(self, self.sMsgClaimRedPacket))
	SoraDAddMessage(self, "MESSAGE_CHAT_SERVER_CLAIM_DROP_BOX", handler(self, self.sMsgClaimDropBox))
end
function chatRedPacketMgr:sMsgDropBoxBack(target, data)
	local redPacketInfo = data.redPacketInfo
	if not redPacketInfo then
		return
	end
	dump(redPacketInfo, "chatRedPacketMgr:sMsgDropBoxBack", 5)
	local chatFunctions = include("chatFunctions")
	local isNeedShowDetail = chatFunctions:isNeedShowDropBoxDetail(redPacketInfo)
	if self.isReqViewDropBox == true or isNeedShowDetail then
		self.isReqViewDropBox = false
		local panel = SoraDCreatePanel("dropBoxClaimDetailView")
		panel:initData(redPacketInfo)
		panel:show()
	else
		local panel = SoraDCreatePanel("dropBoxGetRewardView")
		panel:initData(redPacketInfo)
		panel:show()
	end
end
function chatRedPacketMgr:sMsgRedPacketBack(target, data)
	local redPacketInfo = data.redPacketInfo
	if not redPacketInfo then
		return
	end
	dump(redPacketInfo, "chatRedPacketMgr:sMsgRedPacketBack", 5)
	local chatFunctions = include("chatFunctions")
	local isNeedShowDetail = chatFunctions:isNeedShowRedPacketDetail(redPacketInfo)
	_UPVALUE2_ = redPacketInfo
	redPacketInfo[1] = self.isReqViewRedPacket == true
	redPacketInfo[2] = isNeedShowDetail
	dump(redPacketInfo, "self.isReqViewRedPacket == true or isNeedShowDetail")
	if self.isReqViewRedPacket == true or isNeedShowDetail then
		self.isReqViewRedPacket = false
		if redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_RED_PACKET then
			_ENV = isNeedShowDetail
			isNeedShowDetail.redPacketInfo = redPacketInfo
			uiManager:show("Activity_9001687_Record", isNeedShowDetail)
		else
			local panel = SoraDCreatePanel("redPacketDetail")
			panel:initWithData(redPacketInfo)
			panel:show()
		end
	elseif redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_RED_PACKET then
		_ENV = redPacketInfo
		redPacketInfo.redPacketInfo = redPacketInfo
		redPacketInfo.msg = self.reqChatMessage
		uiManager:show("Activity_9001687_RedPacket", redPacketInfo)
	else
		local redPacketPanel = SoraDCreatePanel("redPacket")
		redPacketPanel:initWithData(redPacketInfo, self.reqChatMessage)
		redPacketPanel:show()
	end
end
function chatRedPacketMgr:setIsReqViewDropBox(value)
	self.isReqViewDropBox = value
end
function chatRedPacketMgr:setIsReqViewRedPacket(value)
	self.isReqViewRedPacket = value
end
function chatRedPacketMgr:getIsReqViewRedPacket(value)
	return self.isReqViewRedPacket
end
function chatRedPacketMgr:setAllianceSurpise(value)
	if value == nil then
		self.allianceSurpise = false
	else
		self.allianceSurpise = value
	end
end
function chatRedPacketMgr:setKingdomSurprise(value)
	if value == nil then
		self.kingdomSurpise = false
	else
		self.kingdomSurpise = value
	end
end
function chatRedPacketMgr:setTeamSurprise(value)
	if value == nil then
		self.teamSurpise = false
	else
		self.teamSurpise = value
	end
end
function chatRedPacketMgr:hasAllianceSurprise()
	return self.allianceSurpise
end
function chatRedPacketMgr:hasTeamSurprise()
	return self.teamSurpise
end
function chatRedPacketMgr:hasKingdomSurprise()
	return self.kingdomSurpise
end
function chatRedPacketMgr:setSendRPChannel(channel)
	self.sendRPChannel = channel
end
function chatRedPacketMgr:sMsgUseRedPacketSuccess(target, data)
	if data.isSuccess then
		local sendRPChannel = self.sendRPChannel
		local chatChannel = sendRPChannel
		local panel = SoraDSearchPanelFromManagerByName("chatView")
		if panel then
			panel:removeFromParent()
		end
		panel = SoraDCreatePanel("chatView")
		panel:show()
		_ENV = nil
		;(nil).chatChannel = chatChannel
		panel:init(nil)
	end
end
function chatRedPacketMgr:sMsgClaimRedPacket(target, data)
	local redPacketInfo = data.redPacketInfo
	if not redPacketInfo then
		return
	end
	local RID = redPacketInfo.RID
	local chatChannel = gRPChatType2ChatChannel[redPacketInfo.type]
	_UPVALUE2_ = redPacketInfo.type
	redPacketInfo.type[1] = gChatSet.TOTAL
	local redPacketInfo.type[2], chatSets = gChatSet.RED_PACKET, redPacketInfo.type
	for _, chatSet in ipairs(chatSets) do
		local listItems = self.chatDataMgr:getData(chatChannel, chatSet)
		for _, v in ipairs(listItems) do
			if v.dataType == gChatDataType.dataType_red_packet and v.customData and v.customData.redPacketInfo.RID == RID then
				v.customData.redPacketInfo.getStatus = gUserRedEnvelopesStatus.ALREADY_GET
				if v.itemNode then
					v.itemNode:reInit()
				end
			end
		end
	end
	self.chatUnReadMgr:reqUnReadInfo(chatChannel)
end
function chatRedPacketMgr:sMsgClaimDropBox(target, data)
	local redPacketInfo = data.redPacketInfo
	if not redPacketInfo then
		return
	end
	local RID = redPacketInfo.RID
	local chatChannel = gRPChatType2ChatChannel[redPacketInfo.type]
	_UPVALUE2_ = redPacketInfo.type
	redPacketInfo.type[1] = gChatSet.TOTAL
	local redPacketInfo.type[2], chatSets = gChatSet.DROP_BOX, redPacketInfo.type
	for _, chatSet in ipairs(chatSets) do
		local listItems = self.chatDataMgr:getData(chatChannel, chatSet)
		for _, v in ipairs(listItems) do
			if v.dataType == gChatDataType.dataType_red_packet and v.customData and v.customData.redPacketInfo.RID == RID then
				v.customData.redPacketInfo.getStatus = gUserRedEnvelopesStatus.ALREADY_GET
				if v.itemNode then
					v.itemNode:reInit()
				end
			end
		end
	end
	self.chatUnReadMgr:reqUnReadInfo(chatChannel)
end
function chatRedPacketMgr:setReqChatMessage(message)
	self.reqChatMessage = message
end
return chatRedPacketMgr
