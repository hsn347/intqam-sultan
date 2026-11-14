local rechargeRead = include("rechargeRead")
local activity_9001708_Ctrl = SoraDGetCtrl("activity_9001708_Ctrl")
local activity_9001708_Read = include("activity_9001708_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001708_gift = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001708/Com_9001708_gift", Com_9001708_gift)
function Com_9001708_gift:onInit()
	self.activityID = gActivityTimeActivityID.KOH_MIGRATE_HELP_9001708
	self.buff_rid = 19933
	self.fields.Button_question:addClickListener(handler(self, self.onClickBtnQuestion))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_hasBuy:setString(i18n("common_text_2699"))
end
function Com_9001708_gift:onItemRenderer(index, obj)
	local data = self.itemList[index + 1]
	obj:initData(data.id, data.count)
end
function Com_9001708_gift:onShow()
end
function Com_9001708_gift:initData(giftCfg)
	self.giftCfg = giftCfg
	local rechargeCfg = rechargeRead.getPageViewData(self.giftCfg.giftId)
	self.fields.Text_name:setString(i18n(rechargeCfg.activeName))
	self.itemList = clone(self.giftCfg.gift)
	rechargeRead = i18n(rechargeCfg.activeName)
	i18n(rechargeCfg.activeName).id = 1001
	i18n(rechargeCfg.activeName).count = self.giftCfg.gold
	table.insert(self.itemList, i18n(rechargeCfg.activeName))
	self.fields.List:setNumItems(#self.itemList)
	local showPrice, isGetPrice = paymentManager.judgePrice(giftCfg.giftId, giftCfg.price)
	local discount = giftCfg.originalPrice / giftCfg.price
	local oriShowPrice = paymentManager.calculateDiscount(giftCfg.giftId, showPrice, discount, giftCfg.originalPrice)
	rechargeRead = discount
	discount.rid = self.giftCfg.giftId
	discount.nowPrice = showPrice
	rechargeRead, discount.oriPrice = self.giftCfg.giftId, oriShowPrice
	discount.logInfo, self.giftCfg.giftId.fromCenter = self.giftCfg.giftId, self.activityID
	discount.handleBuyClick = handler(self, self.btnBuyClick)
	discount.handleItemBuyClick = handler(self, self.onClickItemBuyGift)
	self.fields.Com_OutAppPurchaseButtons:initData(discount)
	self:updateBuyState()
end
function Com_9001708_gift:btnBuyClick()
	SoraDPlaySound()
	paymentManager.normalGiftBuyClassify(self.giftCfg.giftId)
	paymentManager.OnemtReadyBuy(self.giftCfg.giftId, self.activityID)
end
function Com_9001708_gift:onClickItemBuyGift()
	SoraDPlaySound()
	return true
end
function Com_9001708_gift:updateBuyState()
	if activity_9001708_Ctrl:checkCanBuyGift() then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(1)
	end
end
function Com_9001708_gift:onClickBtnQuestion()
	SoraDPlaySound()
	local content = i18n("migrant_move_text73")
	content = content .. [[


]] .. activity_9001708_Read.getRechargeBuffDes(self.giftCfg.giftId)
	_ENV = self.giftCfg.giftId
	self.giftCfg.giftId.title = i18n("migrant_move_text72")
	self.giftCfg.giftId.content = content
	self.giftCfg.giftId.contentAlignCenter = true
	uiManager:show("RuleView", self.giftCfg.giftId)
end
return Com_9001708_gift
