local gametop = gModuleMgr.getObject("gametop")
local chatConst = include("chatConst")
local mailFunctions = include("mailFunctions")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local chatUnReadMgr = gChatMgrs:getMgr("chatUnReadMgr")
local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
local chatCtrl = SoraDGetCtrl("chatCtrl")
local chatContentView = class("chatContentView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("chatContentView")
	end
	return target
end)
function chatContentView:ctor()
	self.chat_tip_node_text = SoraDGetChildByName(self, "Top_chat_tip_node_text")
	self.chat_tip_bg = SoraDGetChildByName(self, "chat_tip_bg")
	if self.chat_tip_bg then
		self.chat_tip_bg:setTouchEnabled(true)
		self.chat_tip_bg:addTouchEventListener(handler(self, self.onBtnChatTip))
	end
	self.chat_tip_text = SoraDGetChildByName(self, "chat_tip_text")
	self.chat_tip_icon = SoraDGetChildByName(self, "chat_tip_icon")
	self.chat_tip_node_rp = SoraDGetChildByName(self, "Top_chat_tip_node_rp")
	self.chat_tip_bg_rp = SoraDGetChildByName(self, "chat_tip_bg_rp")
	if self.chat_tip_bg_rp then
		self.chat_tip_bg_rp:setTouchEnabled(true)
		self.chat_tip_bg_rp:addTouchEventListener(handler(self, self.onBtnChatTipRP))
	end
	self.chat_tip_text_rp = SoraDGetChildByName(self, "chat_tip_text_rp")
	self.chat_tip_icon_rp = SoraDGetChildByName(self, "chat_tip_icon_rp")
	self.chat_tip_node_text:setAnchorPoint(SoraDFAP(0, 1))
	self.chat_tip_node_text:setPosition(SoraDFPoint(0, display.height - 216))
	self.chat_tip_node_rp:setAnchorPoint(SoraDFAP(0, 1))
	self.chat_tip_node_rp:setPosition(SoraDFPoint(0, display.height - 260))
	self.chat_tip_text:setString("")
	self.chat_tip_node_text:setVisible(false)
	self.chat_tip_node_rp:setVisible(false)
	local tip_node = SoraDGetChildByName(self, "Bottom_chat_tip_node_at")
	self.chat_tip_node_at = tip_node
	self.chat_tip_node_at:setVisible(false)
	local chat_tip_btn = SoraDGetChildByName(tip_node, "chat_tip_btn_at")
	chat_tip_btn:addTouchEventListener(handler(self, self.onBtnChatTipAt))
	self.chat_tip_text_at = SoraDGetChildByName(tip_node, "chat_tip_text_at")
	self.Top_Channel_info = SoraDGetChildByName(self, "Top_channel_info")
	self.btn_top_info = SoraDGetChildByName(self.Top_Channel_info, "btn_top_info")
	self.btn_top_info:addTouchEventListener(handler(self, self.onBtnTop))
	self.text_top_info = SoraDGetChildByName(self, "text_top_info")
	self.icon_top_info = SoraDGetChildByName(self, "icon_top")
	self.Top_Channel_korea = SoraDGetChildByName(self, "Top_channel_korea")
	self.Top_Channel_korea:setVisible(false)
	self.text_top_korea = SoraDGetChildByName(self, "text_top_korea")
	if SoraDGetDefaultLanguage() == "ko" then
		self.Top_Channel_korea:setVisible(true)
		self.Top_Channel_info:setPositionY(self.Top_Channel_info:getPositionY() - 60)
		self.chat_tip_node_text:setPositionY(self.chat_tip_node_text:getPositionY() - 60)
		self.chat_tip_node_rp:setPositionY(self.chat_tip_node_rp:getPositionY() - 60)
		self.text_top_korea:setString(i18n("common_text_4491"))
	end
	self.Top_channel_Personal = SoraDGetChildByName(self, "Top_channel_Personal")
	self.Button_OpenList = SoraDGetChildByName(self, "Button_OpenList")
	self.Button_OpenList:setSwallowTouches(true)
	self.Button_OpenList:addTouchEventListener(handler(self, self.btnClickOpenList))
	self.text_top_Name = SoraDGetChildByName(self, "text_top_Name")
	self.Top_channel_Personal:setVisible(false)
	self.Center_PersonalTip = SoraDGetChildByName(self, "Center_PersonalTip")
	self.textPersonalTips = SoraDGetChildByName(self, "Text_Tips")
	self.textPersonalTips:setString(i18n("chat_text_71"))
	self.Center_PersonalTip:setVisible(false)
	self.scrollView = SoraDGetExtendChildFromCCSByName(self, "CCS_chatScrollView_node", true)
	self.bottomViewNode = SoraDGetExtendChildFromCCSByName(self, "CCS_chatBottomView_node")
	self.bottomViewNode:setMaxCharCount(gChatMaxLength.normalChatLength)
	if self.bottomViewNode then
		self.bottomViewNode:setViewType("chatView")
	end
	self.oriScrollViewPos = cc.p(self.scrollView:getPosition())
	self.chatSet = gChatSet.TOTAL
	self._isInit = false
end
function chatContentView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_CHAT_UPDATE_TIP", handler(self, self.msgUpdateChatTip))
	SoraDAddMessage(self, "MESSAGE_UPDATE_UNREAD_WHEN_SCROLL", handler(self, self.msgUpdateUnReadTipWhenScroll))
	SoraDAddMessage(self, "MESSAGE_CHAT_ROOM_SERVER_MODIFY_NAME_SUCCESS", handler(self, self.sMsgModifyNameSuccess))
	SoraDAddMessage(self, "MESSAGE_CHAT_ADD_MESSAGE", handler(self, self.chatAddMessage))
end
function chatContentView:chatAddMessage(target, data)
	local chatChannel = data.chatChannel
	local chatSet = data.chatSet
	local key = data.key
	if self.chatChannel ~= chatChannel or self.chatSet ~= chatSet then
		return
	end
	if chatChannel == gChatChannel.CHATROOM then
		local otherData = chatDataMgr:getChatChannelInfo()
		if otherData and otherData.key ~= key then
			return
		end
	end
	self:updateAtSelfInfo()
end
function chatContentView:init(data)
	self.chatChannel = data.chatChannel
	self.chatDelegate = data.chatDelegate
	if self.chatChannel == gChatChannel.KINGDOM then
		local kname = worldMapDefine.getKingdomName(true)
		self.text_top_info:setString(kname)
		_ENV = kname
		kname.chatChannel = self.chatChannel
		kname.chatSet = gChatSet.TOTAL
		self.scrollView:initWithChatChannel(kname)
	elseif self.chatChannel == gChatChannel.ALLIANCE then
		if allianceMgr:hasJoinAlliance() and not worldMapDefine.isInTeamStatus() then
			self.text_top_info:setVisible(true)
			self.icon_top_info:setVisible(true)
			local allianceFullName = allianceMgr:getAllianceProperty("name")
			local strAlliance = allianceFullName
			self.text_top_info:setString(strAlliance)
		else
			self.text_top_info:setVisible(false)
			self.icon_top_info:setVisible(false)
		end
		_ENV = false
		;(false).chatChannel = self.chatChannel
		;(false).chatSet = gChatSet.TOTAL
		self.scrollView:initWithChatChannel(false)
	elseif self.chatChannel == gChatChannel.TEAM or self.chatChannel == gChatChannel.CAMP or self.chatChannel == gChatChannel.VIEWER then
		self.text_top_info:setVisible(false)
		self.icon_top_info:setVisible(false)
		_ENV = false
		;(false).chatChannel = self.chatChannel
		;(false).chatSet = gChatSet.TOTAL
		self.scrollView:initWithChatChannel(false)
	elseif self.chatChannel == gChatChannel.MAIL or self.chatChannel == gChatChannel.CHATROOM then
		local otherData = chatDataMgr:getChatChannelInfo()
		self.Top_channel_Personal:setVisible(true)
		self.Top_Channel_info:setVisible(false)
		dump(otherData, "otheData")
		self.text_top_Name:setString(otherData and otherData.titleName or "")
		self.bottomViewNode:setViewType("chatView", true)
		local key
		if otherData and otherData.key then
			key = otherData.key
			self.Center_PersonalTip:setVisible(false)
			self.bottomViewNode:checkNonePersonlHide(false)
			self.scrollView:setVisible(true)
			_ENV = true
			;(true).chatChannel = self.chatChannel
			;(true).chatSet = gChatSet.TOTAL
			;(true).target = otherData and otherData.target
			;(true).key = key
			self.scrollView:initWithChatChannel(true)
			self.scrollView.scrollView:jumpToBottom()
			self.chatDelegate:hidePersonalList(true)
		else
			print("aaabbb")
			self.chatDelegate:showPersonalList(true)
		end
	end
	self.bottomViewNode:setChatDelegate(self.chatDelegate)
	chatUnReadMgr:reqUnReadInfo(self.chatChannel)
	self._isInit = true
	self:updateAtSelfInfo()
end
function chatContentView:isInit()
	return self._isInit
end
function chatContentView:resetInit()
	self._isInit = false
end
function chatContentView:initInputView(chatInputType)
	self.bottomViewNode:setChatInputType(chatInputType)
end
function chatContentView:initTop(data)
	local chatChannel = data.chatChannel
	if chatChannel == gChatChannel.KINGDOM then
		local kname = worldMapDefine.getKingdomName(true)
		self.text_top_info:setString(kname)
	elseif chatChannel == gChatChannel.ALLIANCE and allianceMgr:hasJoinAlliance() then
		local allianceName = allianceMgr:getAllianceProperty("abbr")
		local allianceFullName = allianceMgr:getAllianceProperty("name")
		local strAlliance = mailFunctions:getWrappedName(allianceName, allianceFullName)
		self.text_top_info:setString(strAlliance)
	end
end
function chatContentView:setChatDelegate(chatDelegate)
	self.chatDelegate = chatDelegate
end
function chatContentView:onBtnChatTip(target, event)
	if event == ccui.TouchEventType.ended then
		local unReadInfo = chatUnReadMgr:getUnReadInfo(self.chatChannel)
		if unReadInfo == nil then
			return
		end
		local isLocal = false
		local isExist = chatDataMgr:hasExistData(self.chatChannel, gChatSet.TOTAL, nil, unReadInfo.chatId)
		if isExist then
			isLocal = true
		end
		if isLocal then
			print("本地已经有未读数据，直接跳转到本地----")
			self.scrollView:navigateToChatId(unReadInfo.chatId)
			self.chat_tip_node_text:setVisible(false)
		else
			print("发起历史未读消息请求")
			_ENV = false
			;(false).chatChannel = self.chatChannel
			;(false).chatSet = self.chatSet
			chatUnReadMgr:requestAllHistoryData(false, unReadInfo)
			self.chat_tip_node_text:setVisible(false)
		end
		self.isChatTipClick = true
	end
end
function chatContentView:onBtnChatTipRP(target, event)
	if event == ccui.TouchEventType.ended then
		print("todo:打开红包或天降宝箱集合界面")
		local unReadInfo = chatUnReadMgr:getUnReadInfo(self.chatChannel)
		local redPacketView = SoraDCreatePanel("chatRedPacketView")
		redPacketView:show()
		_ENV = nil
		;(nil).chatChannel = self.chatChannel
		;(nil).chatSet = gChatSet.RED_PACKET
		redPacketView:init(nil)
	end
end
function chatContentView:onBtnTop(target, event)
	if event == ccui.TouchEventType.ended then
		print("打开系统集合界面")
		if not self.chatChannel then
			return
		end
		if not self.sysContentView then
			self.sysContentView = SoraDCreatePanel("chatSysContentView")
			self.sysContentView:addTo(self, 2)
			_ENV = self
			self.chatChannel = self.chatChannel
			self.chatDelegate = self.chatDelegate
			self.sysContentView:init(self)
		end
		self.sysContentView:onShow()
	end
end
function chatContentView:onOffsetUI(data)
	dump(data, "chatContentView:onOpenEmotionUI(data)")
	local duration = data.duration or 0.25
	local isMoveTo = data.isMoveTo
	self.bottomViewNode:stopAllActions()
	self.scrollView:stopAllActions()
	local offsetY = data.offsetY
	if duration == 0 then
		self.bottomViewNode:setPositionY(offsetY)
		self.scrollView:setPositionY(self.oriScrollViewPos.y + offsetY)
	else
		local actMoveTo1 = cca.moveTo(duration, 320, offsetY)
		self.bottomViewNode:runAction(actMoveTo1)
		local actMoveTo = cca.moveTo(duration, self.oriScrollViewPos.x, self.oriScrollViewPos.y + offsetY)
		self.scrollView:runAction(actMoveTo)
	end
end
function chatContentView:msgUpdateChatTip(target, data)
	if data.chatChannel ~= self.chatChannel then
		return
	end
	self.isUnReadTipBack = true
	self:updateUnReadTip()
	self:updateRedPacketTip()
	_ENV = self.updateRedPacketTip
	self.updateRedPacketTip[gChatChannel.KINGDOM] = true
	self.updateRedPacketTip[gChatChannel.TEAM] = true
	self.updateRedPacketTip[gChatChannel.ALLIANCE] = true
	self.updateRedPacketTip[gChatChannel.CAMP] = true
	local self.updateRedPacketTip[gChatChannel.VIEWER], config = true, self.updateRedPacketTip
	if config[self.chatChannel] and self.chatSet == gChatSet.TOTAL then
		_ENV = nil
		;(nil).chatChannel = self.chatChannel
		;(nil).chatSet = self.chatSet
		chatUnReadMgr:reqReadChatMsg(nil)
	end
end
function chatContentView:onScrollUpdateFirst(scroll)
	print("chatContentView:onScrollUpdateFirst", self.chatChannel)
	if self.isUnReadTipBack and not self.isUnReadTipInitFirst then
		print("检测到tip数据回来了，但是还没初始化")
		self:updateUnReadTip()
	end
end
function chatContentView:updateUnReadTip()
	if not self.isUnReadTipBack then
		return
	end
	if not self.scrollView.isScrollUpdatedFirst then
		print("scroll还没初始化好", self.chatChannel)
		return
	end
	local unReadInfo = chatUnReadMgr:getUnReadInfo(self.chatChannel)
	if not unReadInfo or not self:needShowUnReadNum() then
		self.chat_tip_node_text:setVisible(false)
	elseif not self.isChatTipClick then
		self:resizeTextTip(unReadInfo.num)
		self.chat_tip_icon:stopAllActions()
		local moveUp = cca.moveTo(0.4, self.chat_tip_icon:getPositionX(), self.chat_tip_icon:getPositionY() + 4)
		local moveDown = cca.moveTo(0.2, self.chat_tip_icon:getPositionX(), self.chat_tip_icon:getPositionY() - 2)
		local move = cca.moveTo(0.1, self.chat_tip_icon:getPositionX(), self.chat_tip_icon:getPositionY())
		_UPVALUE8_ = self.chat_tip_icon:getPositionX()
		self.chat_tip_icon:getPositionX()[1] = cca.delay(1)
		self.chat_tip_icon:getPositionX()[2] = moveUp
		self.chat_tip_icon:getPositionX()[3] = moveDown
		self.chat_tip_icon:getPositionX()[4] = moveUp
		self.chat_tip_icon:getPositionX()[5] = moveDown
		self.chat_tip_icon:getPositionX()[6] = moveUp
		self.chat_tip_icon:getPositionX()[7] = moveDown
		self.chat_tip_icon:getPositionX()[8] = move
		local moveAct = cca.seq((self.chat_tip_icon:getPositionX()))
		self.chat_tip_icon:runAction(cca.repeatForever(moveAct))
		self.chat_tip_node_text:setVisible(true)
	end
	self.isUnReadTipInitFirst = true
end
function chatContentView:msgUpdateUnReadTipWhenScroll(target, data)
	if data.chatChannel ~= self.chatChannel then
		return
	end
	self:updateUnReadTipWhenScroll()
end
function chatContentView:sMsgModifyNameSuccess(target, data)
	local crid = data.crid
	local otherData = chatDataMgr:getChatChannelInfo()
	if otherData.target == crid then
		local newName = data.newName
		otherData.titleName = newName
		chatDataMgr:setChatChannelInfo(otherData)
		self.text_top_Name:setString(newName)
	end
end
function chatContentView:updateUnReadTipWhenScroll()
	if self.chat_tip_node_text:isVisible() == false then
		return
	end
	local unReadInfo = chatUnReadMgr:getUnReadInfo(self.chatChannel)
	if not unReadInfo or not self:needShowUnReadNum() then
		self.chat_tip_node_text:setVisible(false)
	end
end
function chatContentView:needShowUnReadNum()
	local unReadInfo = chatUnReadMgr:getUnReadInfo(self.chatChannel)
	local chatId = unReadInfo.chatId
	if not chatId then
		return false
	end
	if self.scrollView.hasMore == false then
		return false
	end
	local isExist = chatDataMgr:hasExistData(self.chatChannel, gChatSet.TOTAL, nil, chatId)
	if not isExist and unReadInfo.num and unReadInfo.num > 0 then
		print("本地没检测到chatId，", chatId, "那么需要显示角标----")
		return true
	elseif unReadInfo.num and unReadInfo.num > 0 then
		print("本地有数据，检测可视范围")
		local itemsData = chatDataMgr:getData(self.chatChannel, self.chatSet, self.key)
		local itemData
		for i = 1, #itemsData do
			if chatId == itemsData[i].chatId and not gFakeDataTypeMap[itemsData[i].dataType] then
				itemData = itemsData[i]
				break
			end
		end
		if not itemData then
			return false
		end
		print("itemData.chatId = ", itemData.chatId)
		local isOutSideVisible = self.scrollView:isDataOutSideVisible(itemData)
		print("isOutSideVisible = ", isOutSideVisible)
		if isOutSideVisible then
			return true
		else
			return false
		end
	end
	return false
end
function chatContentView:updatePersonalRedIcon()
	SoraDGetChildByName(self, "icon_red"):setVisible(gChatMgrs:getMgr("chatCoverMgr"):getTotalNewNum() > 0)
end
function chatContentView:updateRedPacketTip()
	if self.chatChannel == gChatChannel.MAIL or self.chatChannel == gChatChannel.CHATROOM then
		return
	end
	local unReadInfo = chatUnReadMgr:getUnReadInfo(self.chatChannel)
	dump(unReadInfo, "unReadInfo")
	if not unReadInfo or not unReadInfo.hasRedPacket then
		self.chat_tip_node_rp:setVisible(false)
	else
		self.chat_tip_node_rp:setVisible(true)
		local textTip = i18n("common_text_1794")
		if unReadInfo.redEnvelopesType and unReadInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
			textTip = i18n("treasureChest_text_14")
			self.chat_tip_icon_rp:setSpriteFrame("icon_tjbx_bx06.png")
			if self.chatChannel == gChatChannel.ALLIANCE or self.chatChannel == gChatChannel.TEAM then
				self.chat_tip_node_rp:setVisible(false)
			end
		end
		self:resizeRPTip(textTip)
	end
end
function chatContentView:resizeRPTip(text)
	local deltaSide = 18
	local sizeImgIcon = cc.size(41, 62)
	local scaleIcon = 0.5
	local deltaImgIcon = 30
	self.chat_tip_text_rp:setString(text or "")
	local widthText = self.chat_tip_text_rp:getContentSize().width
	local totalWidth = widthText + deltaSide + sizeImgIcon.width * scaleIcon + deltaImgIcon
	local totalHeight = 40
	self.chat_tip_bg_rp:setContentSize(cc.size(totalWidth, totalHeight))
	self.chat_tip_node_rp:setContentSize(cc.size(totalWidth, totalHeight))
	self.chat_tip_bg_rp:setAnchorPoint(cc.p(0.5, 0))
	self.chat_tip_bg_rp:setPosition(cc.p(totalWidth / 2, 0))
	self.chat_tip_text_rp:setTextHorizontalAlignment(SoraDFLabelL())
	self.chat_tip_text_rp:setAnchorPoint(SoraDFAP(0, 0.5))
	self.chat_tip_text_rp:setPosition(SoraDFPoint(deltaSide, totalHeight / 2, totalWidth))
	self.chat_tip_icon_rp:setAnchorPoint(SoraDFAP(0.5, 0.5))
	self.chat_tip_icon_rp:setPosition(SoraDFPoint(totalWidth - deltaImgIcon, totalHeight / 2, totalWidth))
end
function chatContentView:resizeTextTip(text)
	local deltaSide = 24
	local sizeImgIcon = cc.size(34, 20)
	local scaleIcon = 1.0
	local deltaImgIcon = 20
	self.chat_tip_text:setString(text or "")
	local widthText = self.chat_tip_text:getContentSize().width
	local totalWidth = widthText + deltaSide + sizeImgIcon.width * scaleIcon
	local totalHeight = 40
	self.chat_tip_bg:setContentSize(cc.size(totalWidth, totalHeight))
	self.chat_tip_node_text:setContentSize(cc.size(totalWidth, totalHeight))
	self.chat_tip_bg:setAnchorPoint(cc.p(0.5, 0))
	self.chat_tip_bg:setPosition(cc.p(totalWidth / 2, 0))
	self.chat_tip_text:setTextHorizontalAlignment(SoraDFLabelL())
	self.chat_tip_text:setAnchorPoint(SoraDFAP(0, 0.5))
	self.chat_tip_text:setPosition(SoraDFPoint(deltaSide, totalHeight / 2, totalWidth))
	self.chat_tip_icon:setAnchorPoint(cc.p(0.5, 0.5))
	self.chat_tip_icon:setPosition(SoraDFPoint(totalWidth - deltaImgIcon, totalHeight / 2, totalWidth))
end
function chatContentView:btnClickOpenList(target, eventType)
	if eventType == ccui.TouchEventType.began then
		SoraDPlaySound()
		if self.chatDelegate.isShowList then
			self.chatDelegate:hidePersonalList()
		else
			self.chatDelegate:showPersonalList()
			if self.chatChannel == gChatChannel.CHATROOM then
				local otherData = chatDataMgr:getChatChannelInfo()
				chatCtrl:cleanUnreadAtSelfUserList(self.chatChannel, otherData.target)
			end
		end
	end
end
function chatContentView:onBtnChatTipAt(target, event)
	if event == ccui.TouchEventType.ended then
		if not self.atSelfUserList then
			_ENV = self.atSelfUserList
		end
		local data = table.remove(self.atSelfUserList)
		if data then
			self.scrollView:navigateToChatId(data.msgID)
		end
		self:updateAtSelfInfo()
	end
end
function chatContentView:updateAtSelfInfo(...)
	if not chatCtrl:checkUnreadAtSelfChannel(self.chatChannel) then
		self.chat_tip_node_at:setVisible(false)
		return
	end
	if self.chatChannel == gChatChannel.CHATROOM then
		local otherData = chatDataMgr:getChatChannelInfo()
		self.atSelfUserList = chatCtrl:getUnreadAtSelfUserList(self.chatChannel, otherData.target)
		dump(self.atSelfUserList, "==self.atSelfUserList==")
	else
		self.atSelfUserList = chatCtrl:getUnreadAtSelfUserList(self.chatChannel)
	end
	if #self.atSelfUserList > 0 then
		self.chat_tip_node_at:setVisible(true)
		if #self.atSelfUserList > 1 then
			chatCtrl = otherData.target
			otherData.target.num = #self.atSelfUserList
			self.chat_tip_text_at:setString(i18n("chat_text_77", otherData.target))
		else
			chatCtrl = i18n("chat_text_77", otherData.target)
			i18n("chat_text_77", otherData.target).name = self.atSelfUserList[1].nickName
			self.chat_tip_text_at:setString(i18n("chat_text_78", i18n("chat_text_77", otherData.target)))
		end
	else
		self.chat_tip_node_at:setVisible(false)
	end
end
return chatContentView
