local gametop = gModuleMgr.getObject("gametop")
local chatCtrl = gametop.playertop_:getModule("chatCtrl")
local escortIntel = gametop.playertop_:getModule("escortIntel")
local escortIntelCtrl = gametop.playertop_:getModule("escortIntelCtrl")
local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
local chatSendMgr = gChatMgrs:getMgr("chatSendMgr")
local worldEscortLogView = class("worldEscortLogView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldEscortLogView")
	end
	return target
end)
function worldEscortLogView:ctor()
	self.isHideCurrentSceneView = true
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_chat")
	self.title:setTitle(i18n("common_text_705"))
	self.btnWorld = SoraDGetChildByName(self, "Button_World")
	self.btnAlliance = SoraDGetChildByName(self, "Button_Alliance")
	self.imgLine = SoraDGetChildByName(self, "Image_topline")
	self.chatBg = SoraDGetChildByName(self, "Top_Size_Image_bg")
	self.chatBg:setColor(cc.c3b(157, 140, 122))
	self.chatBg:setLocalZOrder(-2)
	self.btnWorld:setTitleText(i18n("common_text_2535"))
	self.btnAlliance:setTitleText(i18n("common_text_069"))
	self.btnWorld:addTouchEventListener(handler(self, self.OnBtnChangeClick))
	self.btnAlliance:addTouchEventListener(handler(self, self.OnBtnChangeClick))
	self.chatScrollViewAlliance = nil
	self.chatScrollViewKingdom = nil
	self.chatJoinAlliance = nil
	local escortChannel = chatDataMgr:getEscortChannel()
	print("当前军情频道:", escortChannel)
	if escortChannel == gEscortIntelChannel.KINGDOM then
		self:OnBtnChangeClick(self.btnWorld, ccui.TouchEventType.ended)
	elseif escortChannel == gEscortIntelChannel.ALLIANCE then
		self:OnBtnChangeClick(self.btnAlliance, ccui.TouchEventType.ended)
	end
end
function worldEscortLogView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_CREATE_SUCCESS", handler(self, self.refreshAllianceChat))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_BE_KICKED_UI", handler(self, self.sMsgAllianceBeKicked))
end
function worldEscortLogView:requestHistoryMessage(chatChannel)
	local delay = cca.delay(2.0E-4)
	local callFunc = cca.callFunc(function()
		chatChannel = nil
		;(nil).chatChannel = chatChannel
		;(nil).chatSet = gChatSet.TOTAL
		local (nil).num, param = 7, nil
		chatSendMgr:requestHistory(param)
	end)
	_UPVALUE2_ = nil
	;(nil)[1] = delay
	;(nil)[2] = callFunc
	local seq = cca.seq(nil)
	self:runAction(seq)
end
function worldEscortLogView:OnBtnChangeClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound(nil, nil, true)
		local isItemsClick = self.btnWorld == button
		local checkColor = cc.c3b(144, 132, 97)
		local uncheckColor = cc.c3b(255, 245, 176)
		self.btnWorld:setTouchEnabled(not isItemsClick)
		self.btnWorld:setBright(isItemsClick)
		self.btnAlliance:setTouchEnabled(isItemsClick)
		self.btnAlliance:setBright(not isItemsClick)
		self.btnAlliance:setTitleColor(isItemsClick and checkColor or uncheckColor)
		self.btnWorld:setTitleColor(isItemsClick and uncheckColor or checkColor)
		if isItemsClick == true then
			chatDataMgr:setEscortChannel(gEscortIntelChannel.KINGDOM)
			chatDataMgr:saveEscortChannel()
			chatDataMgr:setCurrentEscortType(gChatTypeUI.escortKingdom)
			self.currentChatType = gChatTypeUI.escortKingdom
			if self.chatScrollViewKingdom then
				self.chatScrollViewKingdom:setVisible(true)
			else
				self.chatScrollViewKingdom = SoraDCreatePanel("worldEscortLogScroll")
				self.chatScrollViewKingdom:setPosition(cc.p(20, 0))
				self.chatScrollViewKingdom:addTo(self.chatBg:getParent(), -1)
				_ENV = self.chatScrollViewKingdom.addTo
				self.chatScrollViewKingdom.addTo.chatChannel = gChatChannel.ESCORTKINGDOM
				self.chatScrollViewKingdom.addTo.chatSet = gChatSet.TOTAL
				local self.chatScrollViewKingdom.addTo.ignoreCloseLoading, channelData = true, self.chatScrollViewKingdom.addTo
				self.chatScrollViewKingdom:initWithChatChannel(channelData)
				self.oriKingdomScrollViewSize = self.chatScrollViewKingdom.scrollView:getContentSize()
				self:requestHistoryMessage(gChatChannel.ESCORTKINGDOM)
			end
			if self.chatScrollViewAlliance then
				self.chatScrollViewAlliance:setVisible(false)
			end
			if self.chatJoinAlliance then
				self.chatJoinAlliance:setVisible(false)
			end
		else
			chatDataMgr:setEscortChannel(gEscortIntelChannel.ALLIANCE)
			chatDataMgr:saveEscortChannel()
			chatDataMgr:setCurrentEscortType(gChatTypeUI.escortAlliance)
			self.currentChatType = gChatTypeUI.escortAlliance
			local allianceMgr = gametop.playertop_:getModule("allianceMgr")
			if allianceMgr:hasJoinAlliance() then
				if self.chatScrollViewAlliance == nil then
					self.chatScrollViewAlliance = SoraDCreatePanel("worldEscortLogScroll")
					self.chatScrollViewAlliance:setPosition(cc.p(20, 0))
					self.chatScrollViewAlliance:addTo(self.chatBg:getParent(), -1)
					_ENV = self.chatScrollViewAlliance.addTo
					self.chatScrollViewAlliance.addTo.chatChannel = gChatChannel.ESCORTALLIANCE
					self.chatScrollViewAlliance.addTo.chatSet = gChatSet.TOTAL
					local self.chatScrollViewAlliance.addTo.ignoreCloseLoading, channelData = true, self.chatScrollViewAlliance.addTo
					self.chatScrollViewAlliance:initWithChatChannel(channelData)
					self.oriAllianceScrollViewSize = self.chatScrollViewAlliance.scrollView:getContentSize()
					self:requestHistoryMessage(gChatChannel.ESCORTALLIANCE)
				end
				if self.chatScrollViewAlliance then
					self.chatScrollViewAlliance:setVisible(true)
				end
				if self.chatJoinAlliance then
					self.chatJoinAlliance:setVisible(false)
				end
			else
				if self.chatScrollViewAlliance then
					self.chatScrollViewAlliance:setVisible(false)
				end
				if self.chatJoinAlliance then
					self.chatJoinAlliance:setVisible(true)
				else
					self.chatJoinAlliance = SoraDCreatePanel("chatJoinAlliance")
					self.chatJoinAlliance:setPosition(cc.p(15, 88))
					self.chatJoinAlliance:addTo(self.chatBg:getParent(), -1)
				end
			end
			if self.chatScrollViewKingdom then
				self.chatScrollViewKingdom:setVisible(false)
			end
		end
	end
end
function worldEscortLogView:onExitPanel()
	print("worldEscortLogView: on Exit Panel")
	chatDataMgr:cleanEscortData()
	SoraDDelayCallOnce("closeLoading", function()
		SoraDCloseLoading(nil, gShowLoadingMark.chat)
	end)
end
function worldEscortLogView:refreshAllianceChat()
	print("----------------------------Update alliance chat channel")
	if self.currentChatType == gChatTypeUI.escortAlliance then
		self:OnBtnChangeClick(self.btnAlliance, ccui.TouchEventType.ended)
	end
end
function worldEscortLogView:sMsgAllianceBeKicked(target, data)
	self:refreshAllianceChat()
end
return worldEscortLogView
