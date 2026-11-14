local commonBuyGiftCtrl = SoraDGetCtrl("commonBuyGiftCtrl")
local rechargeExchangeCtrl = SoraDGetCtrl("rechargeExchangeCtrl")
local rechargeRead = include("rechargeRead")
local activity_9001729_Ctrl = SoraDGetCtrl("activity_9001729_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001729_Package = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001729/Com_9001729_Package", Com_9001729_Package)
function Com_9001729_Package:onInit()
	self:fixChildrenPos()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_9001729_Package:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1].id, self.itemList[index + 1].count)
end
function Com_9001729_Package:onShow()
end
function Com_9001729_Package:initData(packageCfg)
	self.packageCfg = packageCfg
	local rechargeCfg = rechargeRead.getPageViewData(self.packageCfg.rechargeID)
	self.fields.Text_name:setString(i18n(rechargeCfg.activeName))
	activity_9001729_Ctrl = i18n(rechargeCfg.activeName)
	i18n(rechargeCfg.activeName)[1] = "id"
	i18n(rechargeCfg.activeName)[2] = "count"
	self.itemList = serviceFunctions.tableFormat(packageCfg.reward, i18n(rechargeCfg.activeName))
	rechargeRead = i18n(rechargeCfg.activeName)
	i18n(rechargeCfg.activeName).id = 1001
	i18n(rechargeCfg.activeName).count = packageCfg.gold
	table.insert(self.itemList, i18n(rechargeCfg.activeName))
	self.fields.List:setNumItems(#self.itemList)
	local showPrice, isGetPrice = paymentManager.judgePrice(packageCfg.rechargeID, packageCfg.rechargePrice)
	self.fields.Lab_discount:setTitle(tostring(packageCfg.discount[2]) .. "%")
	local discount = packageCfg.originalPrice / packageCfg.rechargePrice
	local oriShowPrice = paymentManager.calculateDiscount(packageCfg.rechargeID, showPrice, discount, packageCfg.originalPrice)
	self.nowPrice = showPrice
	self.oriPrice = oriShowPrice
	self:updateOutAppPurchase()
	local leftNum = activity_9001729_Ctrl:getGiftDayBuyNum(self.packageCfg.rechargeID)
	rechargeRead = i18n(rechargeCfg.activeName)
	i18n(rechargeCfg.activeName).cur = leftNum
	i18n(rechargeCfg.activeName).total = packageCfg.extraData
	self.fields.Text_limitNum:setString(i18n("common_text_4417", i18n(rechargeCfg.activeName)))
	self.isMax = leftNum >= packageCfg.extraData
	self.fields.Com_OutAppPurchaseButtons:setBrightBtn(not self.isMax)
end
function Com_9001729_Package:updateOutAppPurchase()
	self.fields.Com_OutAppPurchaseButtons:setVisible(true)
	_ENV = true
	;(true).rid = self.packageCfg.rechargeID
	;(true).nowPrice = self.nowPrice
	_ENV, (true).oriPrice = self.oriPrice, self.oriPrice
	;(true).logInfo, self.oriPrice.fromCenter = self.oriPrice, gRechargeActiveFromEnum.ROAD53
	;(true).handleBuyClick = handler(self, self.btnBuyClick)
	;(true).handleItemBuyClick = handler(self, self.onClickItemBuyGift)
	self.fields.Com_OutAppPurchaseButtons:initData(true)
end
function Com_9001729_Package:onClickItemBuyGift()
	SoraDPlaySound()
	if self.isMax then
		SoraDShowMsgTip(i18n("back_recharge_text13"))
		return false
	end
	return true
end
function Com_9001729_Package:btnBuyClick()
	SoraDPlaySound()
	SoraDShowLoading()
	if not self.isMax then
		commonBuyGiftCtrl:reqBuyGift(gBuyType.CRESCENT_TREASURE, self.packageCfg.rechargeID)
	else
		SoraDShowMsgTip(i18n("back_recharge_text13"))
	end
end
function Com_9001729_Package:onBuyGiftItem()
	SoraDPlaySound()
	return true
end
return Com_9001729_Package
