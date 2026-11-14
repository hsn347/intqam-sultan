local smeltCtrl = SoraDGetCtrl("smeltCtrl")
local smeltRead = include("smeltRead")
local publicRead = include("publicRead")
local smeltRewardPoolUp = class("smeltRewardPoolUp", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("smeltRewardPoolUp")
end)
function smeltRewardPoolUp:ctor(properties)
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("Smelt_text_15"))
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	self.textTips:setString(i18n("Smelt_text_29"))
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.textTips1 = SoraDGetChildByName(self, "Text_Tips_1")
	self.textTips1:setString(i18n("Smelt_text_16"))
	self.textTips2 = SoraDGetChildByName(self, "Text_Tips_2")
	self.textTips2:setString(smeltCtrl:getGroupID() == 1 and i18n("Smelt_text_17") or i18n("Smelt_text_41"))
	self.btn_buy = SoraDGetChildByName(self, "Button_up")
	self.btn_buy:addTouchEventListener(handler(self, self.btnBuyClick))
	self.btn_reward = SoraDGetChildByName(self, "btn_reward")
	self.btn_reward:addTouchEventListener(handler(self, self.btnRewardClick))
	self.tmpItem = SoraDGetChildByName(self, "Node_Item")
	self:initData()
end
function smeltRewardPoolUp:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_UPDATE_SMELT_DATA", handler(self, self.reInit))
end
function smeltRewardPoolUp:reInit(target, data)
	if smeltCtrl:getIsBuy() then
		_ENV = nil
		;(nil)[1] = cca.delay(0.1)
		;(nil)[2] = cca.removeSelf()
		self:runAction(cca.seq(nil))
	end
end
function smeltRewardPoolUp:initData()
	local equipCfg = smeltCtrl:getChooseEquipCfg()
	self.choosedEquip = smeltCtrl:getChooseID()
	local parent = SoraDGetChildByName(self, "Node_item_1")
	local item = SoraDPopItemAward()
	item:setName("Node_Main_equip")
	item:setPosition(0, 0)
	item:addTo(parent, 0)
	item:setBaseScale(1.1)
	item:setOwnView(self)
	item:initData(self.choosedEquip, equipCfg.num[1])
	local nameLb = SoraDGetChildByName(parent, "Text_name")
	nameLb:setString(smeltCtrl:getEquipName(self.choosedEquip))
	self.item1 = item
	self.upChoosedEquip = smeltCtrl:getUpChooseID()
	local parent = SoraDGetChildByName(self, "Node_item_2")
	local item = SoraDPopItemAward()
	item:setName("Node_Main_equip")
	item:setPosition(0, 0)
	item:addTo(parent, 0)
	item:setBaseScale(1.1)
	item:setOwnView(self)
	item:initData(self.upChoosedEquip, equipCfg.num[2])
	dump(self.upChoosedEquip, "self.upChoosedEquip")
	local nameLb = SoraDGetChildByName(parent, "Text_name")
	nameLb:setString(smeltCtrl:getEquipName(self.upChoosedEquip))
	self.item2 = item
	local giftData = smeltCtrl:getGiftData()
	if not giftData or not giftData.gift then
		return
	end
	self.giftData = giftData
	self.text_price = SoraDGetChildByName(self, "Text_price")
	local price = paymentManager.judgePrice(self.giftData.ID, self.giftData.price)
	self.text_price:setString(price)
	self.text_buy_desc = SoraDGetChildByName(self, "Text_btn_desc")
	self.text_buy_desc:setString(i18n("runningSheep_text_06"))
	self.nowPrice = price
	self.items, smeltCtrl, self.oriPrice = i18n("runningSheep_text_06"), i18n("runningSheep_text_06"), i18n("runningSheep_text_06")
	_UPVALUE2_ = giftData.gift
	giftData.gift[1] = "id"
	giftData.gift[2] = "count"
	local goldRewards = serviceFunctions.tableFormat(SoraDStringsSplit(giftData.gift, ","), giftData.gift)
	for i, v in ipairs(goldRewards) do
		local item = SoraDPopItemAward()
		item:addTo(self.nodeAward)
		item:setBaseScale(1)
		item:setScale(0.8)
		item:setOwnView(self)
		item:initData(v.id, v.count)
		table.insert(self.items, item)
	end
	SoraDautoSortPos(self.nodeAward, 5, 1, cc.size(88, 88), SoraDFIsRA())
	self:updateOutAppPurchase()
end
function smeltRewardPoolUp:btnBuyClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		paymentManager.normalGiftBuyClassify(self.giftData.ID)
	end
end
function smeltRewardPoolUp:btnRewardClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local view = SoraDCreatePanel("smeltRewardPool")
		view.ccs_tab:clickByTag(2)
		view:show()
	end
end
function smeltRewardPoolUp:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen(self.giftData.ID) then
		if not self.outAppPurchaseButtons then
			self.outAppPurchaseButtons = include("outAppPurchaseButtons").new()
			self.outAppPurchaseButtons:addTo(self.btn_buy:getParent())
			self.outAppPurchaseButtons:setPosition(cc.p(0, -270))
		end
		self.centerNode:setScale(0.9)
		self.outAppPurchaseButtons:setVisible(true)
		self.btn_buy:setVisible(false)
		_ENV = false
		;(false).rid = self.giftData.ID
		;(false).nowPrice = self.nowPrice
		;(false).oriPrice = self.oriPrice
		;(false).hideDicountLine = true
		;(false).handlePurchaseBack = handler(self, self.reInit)
		;(false).handleBuyClick = handler(self, self.btnBuyClick)
		self.outAppPurchaseButtons:initData(false)
		_ENV, _UPVALUE1_ = false, self.outAppPurchaseButtons
		;(false).rechargeID = self.giftData.ID
		self.outAppPurchaseButtons[1] = false
		SoraDCreateRechargeGiftNode(self.outAppPurchaseButtons, self.btn_buy:getParent(), cc.p(SoraDFPosX(-210, 0), -370), 1, 1)
	else
		_ENV, _UPVALUE1_ = self.btn_buy:getParent(), self.outAppPurchaseButtons
		self.btn_buy:getParent().rechargeID = self.giftData.ID
		self.outAppPurchaseButtons[1] = self.btn_buy:getParent()
		SoraDCreateRechargeGiftNode(self.outAppPurchaseButtons, self.btn_buy:getParent(), cc.p(SoraDFPosX(-210, 0), -266), 1, 1, 260)
	end
end
return smeltRewardPoolUp
