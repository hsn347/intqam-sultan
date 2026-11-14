local activity_9001628_Read = include("activity_9001628_Read")
local activity_9001628_Ctrl = SoraDGetCtrl("activity_9001628_Ctrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001628_GiftPanel = class("Activity_9001628_GiftPanel", baseFguiPanel)
function Activity_9001628_GiftPanel:ctor(...)
	self.isLRU = true
	Activity_9001628_GiftPanel.super.ctor(self, ...)
	print("Activity_9001628_GiftPanel:ctor", self.viewName)
end
function Activity_9001628_GiftPanel:onInit()
	print("=======Activity_9001628_GiftPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Text_tip:setString(i18n("nebula_treasure_hunt_text21"))
	self.fields.Text_lock:setString(i18n("common_text_2274"))
	self.fields.Button_bought:setString(i18n("common_text_3833"))
	self.fields.Button_lArrow:addTouchEventListener(handler(self, self.btnLeftArrowClick))
	self.fields.Button_rArrow:addTouchEventListener(handler(self, self.btnRightArrowClick))
	self.fields.Lab_discount:fixPos()
end
function Activity_9001628_GiftPanel:endShow()
	print("=======Activity_9001628_GiftPanel:endShow")
	self.cfg = activity_9001628_Read:getHuntSecretCfg()
	self.roundCount = activity_9001628_Ctrl:getRoundCount()
	_ENV = nil
	;(nil).time = self.roundCount
	self.fields.Text_ex:setString(i18n("nebula_treasure_hunt_text19", nil))
	self.buyIndex = #self.cfg
	self.buyTimes = activity_9001628_Ctrl:getBuyTimes()
	self.roundTimes = activity_9001628_Ctrl:getMaxRoundGiftTimes()
	self.roundGift = activity_9001628_Ctrl:getRoundGift()
	for _, v in ipairs(self.cfg) do
		if not self.roundGift[tostring(v.require)] then
			self.buyIndex = v.index
			break
		end
	end
	self.fields.Com_indicator:setVisible(#self.cfg > 1)
	self.fields.Com_indicator:reserLastIndex()
	_ENV = #self.cfg > 1
	;(#self.cfg > 1).count = #self.cfg
	;(#self.cfg > 1).intervalWidth = 8
	;(#self.cfg > 1).begin = self.buyIndex
	self.fields.Com_indicator:initData(#self.cfg > 1)
	self:initView()
end
function Activity_9001628_GiftPanel:initView()
	self.fields.Com_indicator:setCurLight(self.buyIndex)
	self.fields.Button_lArrow:setVisible(self.buyIndex > 1)
	self.fields.Button_rArrow:setVisible(self.buyIndex < #self.cfg)
	self.gift = self.cfg[self.buyIndex]
	self.fields.Lab_bg:setString(i18n(self.gift.name))
	self.fields.Lab_discount:setTitle(tostring(math.floor(self.gift.discount[2] / self.gift.discount[1])) .. "%")
	_UPVALUE2_ = tostring(math.floor(self.gift.discount[2] / self.gift.discount[1])) .. "%"
	;(tostring(math.floor(self.gift.discount[2] / self.gift.discount[1])) .. "%")[1] = "id"
	;(tostring(math.floor(self.gift.discount[2] / self.gift.discount[1])) .. "%")[2] = "count"
	self.itemList = serviceFunctions.tableFormat(self.gift.Rewards, tostring(math.floor(self.gift.discount[2] / self.gift.discount[1])) .. "%")
	self.fields.List:setNumItems(#self.itemList)
	local showPrice, isGetPrice = paymentManager.judgePrice(self.gift.RechargeID, self.gift.Price)
	local discount = self.gift.OriginalPrice / self.gift.Price
	local oriShowPrice = paymentManager.calculateDiscount(self.gift.RechargeID, showPrice, discount, self.gift.OriginalPrice)
	self.nowPrice = showPrice
	self.oriPrice = oriShowPrice
	self:updateOutAppPurchase()
	self.isCanBuy = self.buyTimes < self.roundTimes
	self.fields.Com_OutAppPurchaseButtons:setBrightBtn(self.isCanBuy)
	local cIndex = 0
	if self.roundGift[tostring(self.gift.require)] then
		cIndex = 2
	elseif self.roundCount >= self.gift.require then
		cIndex = self.buyTimes < self.roundTimes and 1 or 2
	end
	self.controllers.c1:setSelectedIndex(cIndex)
end
function Activity_9001628_GiftPanel:itemRenderer_List(index, obj)
	local data = self.itemList[index + 1]
	obj:fixChildrenPos()
	obj:getChild("bg"):setVisible(index % 2 == 0)
	obj:getChild("item"):initData(data.id, data.count)
	obj:getChild("Text_name"):setString(publicRead.getName(data.id))
	obj:getChild("Text_count"):setString("x" .. string.formatnumberthousands(data.count))
end
function Activity_9001628_GiftPanel:updateOutAppPurchase()
	_ENV = nil
	;(nil).rid = self.gift.RechargeID
	;(nil).nowPrice = self.nowPrice
	_ENV, (nil).oriPrice = self.oriPrice, self.oriPrice
	;(nil).logInfo, self.oriPrice.fromCenter = self.oriPrice, gRechargeActiveFromEnum.ROAD64
	;(nil).handleBuyClick = handler(self, self.btnBuyClick)
	;(nil).handleItemBuyClick = handler(self, self.onClickItemBuyGift)
	self.fields.Com_OutAppPurchaseButtons:initData(nil)
end
function Activity_9001628_GiftPanel:btnLeftArrowClick()
	SoraDPlaySound()
	self.buyIndex = math.max(1, self.buyIndex - 1)
	self:initView()
end
function Activity_9001628_GiftPanel:btnRightArrowClick()
	SoraDPlaySound()
	self.buyIndex = math.min(#self.cfg, self.buyIndex + 1)
	self:initView()
end
function Activity_9001628_GiftPanel:onClickItemBuyGift()
	SoraDPlaySound()
	if not self.isCanBuy then
		SoraDShowMsgTip(i18n("nebula_treasure_hunt_text16"))
	end
	return self.isCanBuy
end
function Activity_9001628_GiftPanel:btnBuyClick()
	SoraDPlaySound()
	if not self.isCanBuy then
		SoraDShowMsgTip(i18n("nebula_treasure_hunt_text16"))
		return
	end
	paymentManager.normalGiftBuyClassify(self.gift.RechargeID)
	paymentManager.OnemtReadyBuy(self.gift.RechargeID, gRechargeActiveFromEnum.ROAD64)
end
return Activity_9001628_GiftPanel
