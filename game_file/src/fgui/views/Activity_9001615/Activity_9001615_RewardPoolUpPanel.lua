local activity_9001615_Ctrl = SoraDGetCtrl("activity_9001615_Ctrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001615_RewardPoolUpPanel = class("Activity_9001615_RewardPoolUpPanel", baseFguiPanel)
function Activity_9001615_RewardPoolUpPanel:ctor(...)
	Activity_9001615_RewardPoolUpPanel.super.ctor(self, ...)
	print("Activity_9001615_RewardPoolUpPanel:ctor", self.viewName)
end
function Activity_9001615_RewardPoolUpPanel:onInit()
	print("=======Activity_9001615_RewardPoolUpPanel:onInit")
	self.nodeCommonPopBox = SoraDGetChildByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitle(i18n("Smelt_text_15"))
	self.arrow = SoraDGetChildByName(self, "arrow")
	self.arrow:fix()
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	self.textTips:setString(i18n("Smelt_text_29"))
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.nodeAward:setVirtual()
	self.nodeAward:setItemRenderer(handler(self, self.onItemRenderer))
	self.textTips1 = SoraDGetChildByName(self, "Text_Tips_1")
	self.textTips1:setString(i18n("Smelt_text_16"))
	self.textTips2 = SoraDGetChildByName(self, "Text_Tips_2")
	self.textTips2:setString(activity_9001615_Ctrl:getGroupID() == 1 and i18n("Smelt_text_17") or i18n("Smelt_text_41"))
	self.btn_buy = SoraDGetChildByName(self, "Button_up")
	self.btn_buy:addTouchEventListener(handler(self, self.btnBuyClick))
	self.btn_reward = SoraDGetChildByName(self, "btn_reward")
	self.btn_reward:addTouchEventListener(handler(self, self.btnRewardClick))
	self.tmpItem = SoraDGetChildByName(self, "Node_Item")
	self:initData()
end
function Activity_9001615_RewardPoolUpPanel:onShow()
	print("=======Activity_9001615_RewardPoolUpPanel:onShow")
end
function Activity_9001615_RewardPoolUpPanel:onMessageListener()
end
function Activity_9001615_RewardPoolUpPanel:onItemRenderer(index, obj)
	local data = self.goldRewards[index + 1]
	obj:initData(data.id, data.count)
end
function Activity_9001615_RewardPoolUpPanel:reInit(target, data)
	if activity_9001615_Ctrl:getIsBuy() then
		_ENV = nil
		;(nil)[1] = ffa.delay(0.1)
		;(nil)[2] = ffa.callFunc(function()
			self:close()
		end)
		;(nil)[3] = ffa.callFunc(function()
			self:close()
		end)
		self:runAction(ffa.seq(nil))
	end
end
function Activity_9001615_RewardPoolUpPanel:initData()
	local equipCfg = activity_9001615_Ctrl:getChooseEquipCfg()
	self.choosedEquip = activity_9001615_Ctrl:getChooseID()
	local parent = SoraDGetChildByName(self, "Node_item_1")
	parent:fixPos()
	local item = SoraDGetChildByName(parent, "node_item")
	item:initData(self.choosedEquip, equipCfg.num[1])
	local nameLb = SoraDGetChildByName(parent, "Text_name")
	nameLb:setString(activity_9001615_Ctrl:getEquipName(self.choosedEquip))
	self.item1 = item
	self.upChoosedEquip = activity_9001615_Ctrl:getUpChooseID()
	local parent = SoraDGetChildByName(self, "Node_item_2")
	parent:fixPos()
	local item = SoraDGetChildByName(parent, "node_item")
	item:initData(self.upChoosedEquip, equipCfg.num[2])
	dump(self.upChoosedEquip, "self.upChoosedEquip")
	local nameLb = SoraDGetChildByName(parent, "Text_name")
	nameLb:setString(activity_9001615_Ctrl:getEquipName(self.upChoosedEquip))
	self.item2 = item
	local giftData = activity_9001615_Ctrl:getGiftData()
	if not giftData then
		return
	end
	self.giftData = giftData
	self.text_price = SoraDGetChildByName(self, "Text_price")
	local price = paymentManager.judgePrice(self.giftData.rechargeId, self.giftData.rechargePrice)
	self.text_price:setString(price)
	self.text_buy_desc = SoraDGetChildByName(self, "Text_btn_desc")
	self.text_buy_desc:setString(i18n("runningSheep_text_06"))
	self.nowPrice = price
	self.items, activity_9001615_Ctrl, self.oriPrice = i18n("runningSheep_text_06"), i18n("runningSheep_text_06"), i18n("runningSheep_text_06")
	_UPVALUE2_ = i18n("runningSheep_text_06")
	i18n("runningSheep_text_06")[1] = "id"
	i18n("runningSheep_text_06")[2] = "count"
	local goldRewards = serviceFunctions.tableFormat(giftData.reward, i18n("runningSheep_text_06"))
	self.goldRewards = goldRewards
	self.nodeAward:setNumItems(#self.goldRewards)
	self:updateOutAppPurchase()
end
function Activity_9001615_RewardPoolUpPanel:btnBuyClick(button, eventType)
	SoraDPlaySound()
	paymentManager.normalGiftBuyClassify(self.giftData.rechargeId)
end
function Activity_9001615_RewardPoolUpPanel:btnRewardClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local view = uiManager:show("Activity_9001615_RewardPool").view
		view.ccs_tab:setDefaultClick(2, 2)
	end
end
function Activity_9001615_RewardPoolUpPanel:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen(self.giftData.rechargeId) then
		if not self.outAppPurchaseButtons then
			self.outAppPurchaseButtons = SoraDGetChildByName(self, "Com_OutAppPurchaseButtons")
		end
		self.centerNode:setScale(0.9)
		self.outAppPurchaseButtons:setVisible(true)
		self.btn_buy:setVisible(false)
		_ENV = false
		;(false).rid = self.giftData.rechargeId
		;(false).nowPrice = self.nowPrice
		;(false).oriPrice = self.oriPrice
		;(false).hideDicountLine = true
		;(false).handlePurchaseBack = handler(self, self.reInit)
		;(false).handleBuyClick = handler(self, self.btnBuyClick)
		self.outAppPurchaseButtons:initData(false)
		_ENV, _UPVALUE1_ = false, self.outAppPurchaseButtons
		;(false).rechargeID = self.giftData.rechargeId
		self.outAppPurchaseButtons[1] = false
		SoraDCreateRechargeGiftNode(self.outAppPurchaseButtons, self.btn_buy:getParent(), cc.p(SoraDFPosX(-210, 0), -370), 1, 1)
	else
		_ENV, _UPVALUE1_ = self.btn_buy:getParent(), self.outAppPurchaseButtons
		self.btn_buy:getParent().rechargeID = self.giftData.rechargeId
		self.outAppPurchaseButtons[1] = self.btn_buy:getParent()
		SoraDCreateRechargeGiftNode(self.outAppPurchaseButtons, self.btn_buy:getParent(), cc.p(SoraDFPosX(-210, 0), -266), 1, 1, 260)
	end
end
return Activity_9001615_RewardPoolUpPanel
