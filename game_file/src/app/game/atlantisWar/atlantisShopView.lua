local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local activityExchangeMallRead = include("activityExchangeMallRead")
local atlantisShopView = class("atlantisShopView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("atlantisShopView")
end)
function atlantisShopView:ctor(properties)
	self.activityID = gActivityTimeActivityID.ATLANTIS_WAR_ACTIVITY
	self.exchangeItemID = 1629
	self.nodeCommonFramTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_title")
	self.nodeCommonFramTitle:setTitle(i18n("common_text_1809"))
	self.nodeCommonFramTitle:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
	self.nodeItem = SoraDGetChildByName(self, "Node_Item")
	self.imgIcon = SoraDGetChildByName(self.nodeItem, "Image_Icon")
	self.textNum = SoraDGetChildByName(self.nodeItem, "Text_Num")
	self.nodeTimer = SoraDGetChildByName(self, "Node_timer")
	self.textRemainTime = SoraDGetChildByName(self.nodeTimer, "Text_remainTime")
	self.textTopTips = SoraDGetChildByName(self, "Text_TopTips")
	self.textTopTips:setString(i18n("atlantiswar_text_0241"))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView")
	self.nodeSingle = SoraDGetChildByName(self.scroll, "Node_Single")
	self.nodeSingle:setVisible(false)
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createScrollSingle))
	self.scroll:setSingleCCS("atlantisShopSingle")
	self:updateTokenInfo()
	self:updataScroll()
	include("atlantisWarUtil").playFireAnimation(self)
	self.scroll:getInnerContainer():setPositionY(-self.scroll:getInnerContainerSize().height)
	self.scroll:scrollToTop(0.45, true)
end
function atlantisShopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateTokenInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", handler(self, self.updataScroll))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", function()
		self:updataScroll()
		self:updateTokenInfo()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.msgCallBack))
end
function atlantisShopView:updataScroll(target, data)
	SoraDCloseLoading(self)
	if not activityExchangeMallRead:getShopItemList(self.activityID) then
		local _ENV, showShopItemList = activityExchangeMallRead:getShopItemList(self.activityID), activityExchangeMallRead:getShopItemList(self.activityID)
	end
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	self.scroll:updateScrollView(cc.size(205, 265), showShopItemList, 3, nil)
end
function atlantisShopView:updateTokenInfo()
	_ENV = nil
	;(nil).num = string.formatnumberthousands((activityExchangeMallCtrl:getPurpleAgateNum()))
	self.textNum:setString(i18n("common_text_063", nil))
end
function atlantisShopView:createScrollSingle()
	local single = include("atlantisShopSingle").new(self.nodeSingle:clone())
	single:setVisible(true)
	return single
end
function atlantisShopView:btnHelpClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		SoraDShowHelpMsgTip(i18n("atlantiswar_text_0220"))
	end
end
function atlantisShopView:msgCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		self:removeFromParent()
	end
end
return atlantisShopView
