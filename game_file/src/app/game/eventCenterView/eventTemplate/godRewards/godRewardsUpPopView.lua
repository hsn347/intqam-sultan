local godRewardsRead = include("godRewardsRead")
local privilegeGiftRead = include("privilegeGiftRead")
local itemDesRead = include("itemDesRead")
local godRewardsCtrl = SoraDGetCtrl("godRewardsCtrl")
local godRewardsUpPopView = class("godRewardsUpPopView", function(target)
	if target then
		return target
	end
	return SoraDCreateTouchPanel("godRewardsUpPopView")
end)
local normalBoxID = 722301
function godRewardsUpPopView:ctor()
	self.panel = SoraDGetChildByName(self, "Center_Panel_cut")
	self.panel:setClippingEnabled(false)
	SoraDGetChildByName(self, "Text_name"):setString(i18n("graft_btn_01"))
	self.btnUpgrade = SoraDGetChildByName(self, "Button_Look")
	self.btnText = SoraDGetChildByName(self, "Text_Button")
	self.btnUpgrade:addTouchEventListener(handler(self, self.btnClickUpgrade))
	self.textGold = SoraDGetChildByName(self, "Text_Gold")
	self.textTitleInfo = SoraDGetChildByName(self, "Text_TitleInfo")
	self.textTitleInfo:setString(i18n("graft_title_02"))
	self.textInfo = SoraDGetChildByName(self, "Text_Info")
	self.normalBox = SoraDGetChildByName(self, "Node_Box_Left")
	self.privilegeBox = SoraDGetChildByName(self, "Node_Box_Right")
	self.outAppPurchaseButtons = SoraDGetExtendChildFromCCSByName(self, "CCS_outAppPurchaseButtons")
end
function godRewardsUpPopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_GODREWARDS_GRAFT_PRIVILEGE_GIFT", handler(self, self.purchaseBack))
end
function godRewardsUpPopView:initData(toID)
	self.upBoxID = toID
	self.giftID = godRewardsRead.getGiftID(self.upBoxID)
	godRewardsRead = nil
	;(nil).name1 = itemDesRead.getName(normalBoxID)
	;(nil).name2 = itemDesRead.getName(self.upBoxID)
	self.textInfo:setString(i18n("mail_text_552", nil))
	local originalPrice = privilegeGiftRead.getValueByRechargeIDFromGraft(self.giftID, "price") or 0
	self:initBoxData(self.normalBox, godRewardsRead.getItemInfo(normalBoxID))
	self:initBoxData(self.privilegeBox, godRewardsRead.getItemInfo(self.upBoxID))
	self.btnUpgrade:setBright(true)
	self.btnUpgrade:setTouchEnabled(true)
	local goldStr = paymentManager.judgePrice(self.giftID, originalPrice)
	self.textGold:setString(goldStr)
	self.btnText:setString(i18n("graft_btn_02"))
	self.nowPrice = goldStr
	self.oriPrice = i18n("graft_btn_02")
	self:updateOutAppPurchase()
end
function godRewardsUpPopView:initBoxData(parent, boxInfo)
	local itemID = boxInfo.item
	SoraDGetChildByName(parent, "Text_BoxName"):setString(itemDesRead.getName(itemID))
	local boxItem = SoraDGetChildByName(parent, "Node_Item")
	SoraDGetChildByName(parent, "Text_NumberHave"):setString(i18n("graft_title_01"))
	SoraDSetTextWidthHeight(SoraDGetChildByName(parent, "Text_NumberHave"), cc.size(225, 24))
	boxItem = include("commonItemAward").new(boxItem)
	boxItem:setOwnView(self)
	boxItem:initData(itemID, 1)
	boxItem:setRealScale(1.4)
	local awardNode = SoraDGetChildByName(parent, "Node_Reward")
	_UPVALUE2_ = 1
	;(1)[1] = "id"
	;(1)[2] = "count"
	local awardArry = serviceFunctions.tableFormat(boxInfo.show, 1)
	for i, v in ipairs(awardArry) do
		local single = include("commonItemAward").new()
		single:setBaseScale(0.5)
		single:addTo(awardNode)
		single:setOwnView(self)
		single:initData(v.id, v.count)
		single:setPositionY(0)
	end
	SoraDToCenter(awardNode, 65)
	btnLookReward = SoraDGetChildByName(parent, "Button_Look")
	btnLookReward:setTag(itemID)
	btnLookReward:addTouchEventListener(handler(self, self.btnClickLookReward))
end
function godRewardsUpPopView:btnClickLookReward(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).itemID = button:getTag()
		uiManager:show("CommonItemShowBox", nil)
	end
end
function godRewardsUpPopView:btnClickUpgrade(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowMsgBox(i18n("graft_text_05"), i18n("common_text_204"), i18n("common_text_185"), function(eventType)
			if MSGBOX_CALLBACK_YES == eventType then
				paymentManager.normalGiftBuyClassify(self.giftID)
				paymentManager.OnemtReadyBuy(self.giftID, gRechargeActiveFromEnum.ROAD32)
			end
		end)
	end
end
function godRewardsUpPopView:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen(self.giftID) then
		if not self.outAppPurchaseButtons then
			self.outAppPurchaseButtons = include("outAppPurchaseButtons").new()
			self.outAppPurchaseButtons:addTo(SoraDGetChildByName(self, "Center_Panel_cut"))
			self.outAppPurchaseButtons:setPosition(cc.p(285, 70))
		end
		self.outAppPurchaseButtons:setVisible(true)
		self.btnUpgrade:setVisible(false)
		self.textGold:setVisible(false)
		self.btnText:setVisible(false)
		_ENV = false
		;(false).rid = self.giftID
		;(false).nowPrice = self.nowPrice
		;(false).oriPrice = self.oriPrice
		_ENV, (false).hideDicountLine = self.oriPrice, true
		self.oriPrice.fromCenter = gRechargeActiveFromEnum.ROAD32
		;(false).logInfo, self.oriPrice.activityID = self.oriPrice, gActivityTimeActivityID.UPGRADE_REWARD_ACTIVITY
		;(false).handlePurchaseBack = handler(self, self.purchaseBack)
		;(false).handleBuyClick = handler(self, self.btnClickUpgrade)
		self.outAppPurchaseButtons:initData(false)
		_ENV, _UPVALUE1_ = false, self.outAppPurchaseButtons
		;(false).rechargeID = self.giftID
		self.outAppPurchaseButtons[1] = false
		SoraDCreateRechargeGiftNode(self.outAppPurchaseButtons, SoraDGetChildByName(self, "Center_Panel_cut"), cc.p(80, -40))
	else
		_ENV, _UPVALUE1_ = SoraDGetChildByName(self, "Center_Panel_cut"), self.outAppPurchaseButtons
		SoraDGetChildByName(self, "Center_Panel_cut").rechargeID = self.giftID
		self.outAppPurchaseButtons[1] = SoraDGetChildByName(self, "Center_Panel_cut")
		SoraDCreateRechargeGiftNode(self.outAppPurchaseButtons, SoraDGetChildByName(self, "Center_Panel_cut"), cc.p(80, 70))
	end
end
function godRewardsUpPopView:purchaseBack()
	SoraDRemoveAllAfterPanelFromManager(self)
end
return godRewardsUpPopView
