local wishingTreeRead = include("wishingTreeRead")
local wishingTreeCtrl = SoraDGetCtrl("wishingTreeCtrl")
local wishingUpPopView = class("wishingUpPopView", function(target)
	if target then
		return target
	end
	return SoraDCreateTouchPanel("wishingUpPopView")
end)
local giftId = 13670
function wishingUpPopView:ctor()
	SoraDGetChildByName(self, "Center_Panel_cut"):setClippingEnabled(false)
	SoraDGetChildByName(self, "Text_name"):setString(i18n("wish_text_23"))
	self.btnUpgrade = SoraDGetChildByName(self, "Button_Look")
	self.btnText = SoraDGetChildByName(self, "Text_Button")
	self.btnUpgrade:addTouchEventListener(handler(self, self.btnClickUpgrade))
	self.textTitleInfo = SoraDGetChildByName(self, "Text_TitleInfo")
	self.textTitleInfo:setString(i18n("wish_text_24"))
	self.textGold = SoraDGetChildByName(self, "Text_Gold")
	self.textInfo_1 = SoraDGetChildByName(self, "Text_Info_1")
	self.textInfo_2 = SoraDGetChildByName(self, "Text_Info_2")
	self.awardNode = SoraDGetChildByName(self, "Node_Reward")
	self.nodeLeft = SoraDGetChildByName(self, "Node_Box_Left")
	self.imageFont_1 = SoraDGetChildByName(self.nodeLeft, "image_WishExplosion")
	self.nodeRight = SoraDGetChildByName(self, "Node_Box_Right")
	self.imageFont_2 = SoraDGetChildByName(self.nodeRight, "image_WishExplosion")
	self.imageFont_3 = SoraDGetChildByName(self.nodeRight, "image_Multiply")
	local lang = SoraDGetDefaultLanguage()
	if lang ~= "ar" and lang ~= "en" and lang ~= "ko" then
		lang = "en"
	end
	self.imageFont_1:setSpriteFrame("fong_wishing_wishbroke_" .. lang .. ".png")
	self.imageFont_2:setSpriteFrame("fong_wishing_wishbroke_" .. lang .. ".png")
	self.imageFont_3:setSpriteFrame("font_wishing_double_" .. lang .. ".png")
end
function wishingUpPopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_WISHING_TRESS_RECHARGE_SUCCESS", handler(self, self.purchaseBack))
end
function wishingUpPopView:initData(num)
	local itemBoxInfo = wishingTreeRead.getRechargeInfo()
	local originalPrice = itemBoxInfo.price
	self:initBoxData(itemBoxInfo)
	wishingTreeRead = nil
	;(nil).num = string.formatnumberthousands(num)
	self.textInfo_1:setString(i18n("wish_text_25", nil))
	self.btnUpgrade:setBright(true)
	self.btnUpgrade:setTouchEnabled(true)
	local goldStr = paymentManager.judgePrice(giftId, originalPrice)
	self.textGold:setString(goldStr)
	self.btnText:setString(i18n("graft_btn_02"))
	self.nowPrice = goldStr
	self.oriPrice = i18n("graft_btn_02")
	self:updateOutAppPurchase()
end
function wishingUpPopView:initBoxData(boxInfo)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local awardArry = serviceFunctions.tableFormat(boxInfo.reward, nil)
	dump(awardArry, "awardArry", 10)
	for i, v in ipairs(awardArry) do
		local single = include("commonItemAward").new()
		single:setBaseScale(0.8)
		single:addTo(self.awardNode)
		single:setOwnView(self)
		single:initData(v.id, v.count)
		single:setPositionY(0)
	end
	SoraDToCenter(self.awardNode, 90)
end
function wishingUpPopView:btnClickUpgrade(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowLoading(self)
		_ENV = nil
		;(nil).rechargeID = 13670
		wishingTreeCtrl:sendReqUpReward(nil)
	end
end
function wishingUpPopView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.WISH_TREE_ACTIVITY) then
		SoraDRemoveAllPrePanelFromManager(self, false)
	end
end
function wishingUpPopView:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen() then
		if not self.outAppPurchaseButtons then
			self.outAppPurchaseButtons = include("outAppPurchaseButtons").new()
			self.outAppPurchaseButtons:addTo(self.btnUpgrade:getParent())
			self.outAppPurchaseButtons:setPosition(cc.p(285, 60))
		end
		self.outAppPurchaseButtons:setVisible(true)
		self.btnUpgrade:setVisible(false)
		self.textGold:setVisible(false)
		self.btnText:setVisible(false)
		_ENV = false
		;(false).rid = 13670
		;(false).nowPrice = self.nowPrice
		;(false).oriPrice = self.oriPrice
		;(false).hideDicountLine = true
		;(false).handlePurchaseBack = handler(self, self.purchaseBack)
		;(false).handleBuyClick = handler(self, self.btnClickUpgrade)
		self.outAppPurchaseButtons:initData(false)
		_ENV, _UPVALUE1_ = false, self.outAppPurchaseButtons
		;(false).rechargeID = 13670
		self.outAppPurchaseButtons[1] = false
		SoraDCreateRechargeGiftNode(self.outAppPurchaseButtons, SoraDGetChildByName(self, "Center_Panel_cut"), cc.p(100, -50.0))
	else
		_ENV, _UPVALUE1_ = SoraDGetChildByName(self, "Center_Panel_cut"), self.outAppPurchaseButtons
		SoraDGetChildByName(self, "Center_Panel_cut").rechargeID = 13670
		self.outAppPurchaseButtons[1] = SoraDGetChildByName(self, "Center_Panel_cut")
		SoraDCreateRechargeGiftNode(self.outAppPurchaseButtons, SoraDGetChildByName(self, "Center_Panel_cut"), cc.p(100, 60.0))
	end
end
function wishingUpPopView:purchaseBack()
	SoraDCloseLoading(self)
	SoraDRemoveAllAfterPanelFromManager(self)
end
return wishingUpPopView
