local AllianceUnlockMessagesView = class("allianceUnlockMessagesView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceUnlockMessagesView")
	end
	return target
end)
function AllianceUnlockMessagesView:ctor()
	self.tableListData, _ENV = nil, nil
	self.imgBg = SoraDGetChildByName(self, "Image_bg")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_lock")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("common_text_077"))
	self.btnLockAlliance = SoraDGetChildByName(self, "Button_lockAlliance")
	self.btnLockLord = SoraDGetChildByName(self, "Button_lockLord")
	self.btnLockAlliance:setTitleText(i18n("common_text_081"))
	self.btnLockLord:setTitleText(i18n("common_text_080"))
	self.btnLockLord:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnLockAlliance:addTouchEventListener(handler(self, self.btnClickCallBack))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_SHIELD_LIST_SUCCESS", handler(self, self.updateScrollWithData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_UNLOCK_SHIELD_SUCCESS", handler(self, self.updateScrollWithData))
	self:changeState(true)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMsg = gametop.playertop_:getModule("allianceMsg")
	allianceMsg:reqAllianceMessageShieldList()
end
function AllianceUnlockMessagesView:updateScrollWithData()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMsg = gametop.playertop_:getModule("allianceMsg")
	self.scroll:removeAllChildren()
	if not self.btnLockAlliance:isTouchEnabled() then
		self.tableListData = allianceMsg.aMsgList.shieldalliance
	else
		self.tableListData = allianceMsg.aMsgList.shieldlord
	end
	local scrollH = math.max(self.scroll:getContentSize().height, 120 * #self.tableListData)
	for i, v in ipairs(self.tableListData) do
		local single = SoraDCreatePanel("allianceUnlockMessagesSingle")
		single:initData(v, self.btnLockAlliance:isTouchEnabled())
		single:setScroll(self.scroll, self.btnLockAlliance:isTouchEnabled())
		single:setPosition(cc.p(320, scrollH - (i - 1) * 120))
		single:addTo(self.scroll)
	end
	offsetY = offsetY - (scrollH - scrollInner:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(640, scrollH))
	scrollInner:setPositionY(offsetY)
end
function AllianceUnlockMessagesView:changeState(isLord)
	local checkColor = cc.c3b(144, 132, 97)
	local uncheckColor = cc.c3b(255, 245, 176)
	self.btnLockAlliance:setTouchEnabled(isLord)
	self.btnLockAlliance:setBright(not isLord)
	self.btnLockLord:setTouchEnabled(not isLord)
	self.btnLockLord:setBright(isLord)
	self.btnLockAlliance:setTitleColor(isLord and checkColor or uncheckColor)
	self.btnLockLord:setTitleColor(isLord and uncheckColor or checkColor)
end
function AllianceUnlockMessagesView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:changeState(self.btnLockLord == button)
		self:updateScrollWithData()
		self.scroll:jumpToTop()
	end
end
return AllianceUnlockMessagesView
