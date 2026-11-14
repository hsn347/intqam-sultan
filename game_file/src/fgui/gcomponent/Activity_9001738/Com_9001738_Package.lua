local commonBuyGiftCtrl = SoraDGetCtrl("commonBuyGiftCtrl")
local activity_9001738_Ctrl = SoraDGetCtrl("activity_9001738_Ctrl")
local rechargeRead = include("rechargeRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001738_Package = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001738/Com_9001738_Package", Com_9001738_Package)
function Com_9001738_Package:onInit()
	self:fixChildrenPos()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
end
function Com_9001738_Package:onShow()
end
function Com_9001738_Package:itemRenderer_List(index, obj)
	local data = self.itemList[index + 1]
	obj:initData(data.id, data.count)
end
local getDiscountRate = function(discount)
	if type(discount) ~= "table" then
		return 100
	end
	if type(discount[2]) == "table" then
		return discount[2].rate or discount[2].val or 100
	end
	return discount[2] or discount.rate or discount.val or 100
end
local cloneRewardList = function(rewardList)
	local _ENV, ret
	if type(rewardList) ~= "table" then
		return ret
	end
	for _, reward in ipairs(rewardList) do
		_ENV = nil
		;(nil).id = reward.id
		;(nil).count = reward.count
		table.insert(ret, nil)
	end
	return ret
end
function Com_9001738_Package:initData(packageCfg)
	self.packageCfg = packageCfg
	if not self.packageCfg then
		return
	end
	local rechargeCfg = rechargeRead.getPageViewData(self.packageCfg.rechargeID)
	self.fields.Text_name:setString(rechargeCfg and i18n(rechargeCfg.activeName) or i18n(self.packageCfg.rechargeName))
	self.itemList = cloneRewardList(self.packageCfg.reward)
	if 0 < (self.packageCfg.gold or 0) then
		rechargeRead = rechargeCfg and i18n(rechargeCfg.activeName) or i18n(self.packageCfg.rechargeName)
		;(rechargeCfg and i18n(rechargeCfg.activeName) or i18n(self.packageCfg.rechargeName)).id = 1001
		;(rechargeCfg and i18n(rechargeCfg.activeName) or i18n(self.packageCfg.rechargeName)).count = self.packageCfg.gold
		table.insert(self.itemList, rechargeCfg and i18n(rechargeCfg.activeName) or i18n(self.packageCfg.rechargeName))
	end
	self.fields.List:setNumItems(#self.itemList)
	local showPrice = paymentManager.judgePrice(self.packageCfg.rechargeID, self.packageCfg.rechargePrice)
	self.fields.Lab_discount:setTitle(tostring(getDiscountRate(self.packageCfg.discount)) .. "%")
	local discount = (self.packageCfg.originalPrice or 0) / (self.packageCfg.rechargePrice or 1)
	self.nowPrice = showPrice
	self.oriPrice = paymentManager.calculateDiscount(self.packageCfg.rechargeID, showPrice, discount, self.packageCfg.originalPrice)
	local buyCount = activity_9001738_Ctrl:getGiftDayBuyNum(self.packageCfg.rechargeID)
	local limitCount = self.packageCfg.extraData or 0
	self.leftCount = math.max(0, limitCount - buyCount)
	self.isMax = 0 < limitCount and 0 >= self.leftCount
	rechargeRead = getDiscountRate(self.packageCfg.discount)
	getDiscountRate(self.packageCfg.discount).cur = self.leftCount
	getDiscountRate(self.packageCfg.discount).total = limitCount
	self.fields.Text_limitNum:setString(i18n("common_text_4417", getDiscountRate(self.packageCfg.discount)))
	self:updateOutAppPurchase()
end
function Com_9001738_Package:updateOutAppPurchase()
	self.fields.Com_OutAppPurchaseButtons:setVisible(true)
	_ENV = true
	;(true).rid = self.packageCfg.rechargeID
	;(true).nowPrice = self.nowPrice
	_ENV, (true).oriPrice = self.oriPrice, self.oriPrice
	;(true).logInfo, self.oriPrice.fromCenter = self.oriPrice, gRechargeActiveFromEnum.ROAD53
	;(true).handleBuyClick = handler(self, self.btnBuyClick)
	;(true).handleItemBuyClick = handler(self, self.onClickItemBuyGift)
	self.fields.Com_OutAppPurchaseButtons:initData(true)
	self.fields.Com_OutAppPurchaseButtons:setBrightBtn(not self.isMax)
end
function Com_9001738_Package:onClickItemBuyGift()
	SoraDPlaySound()
	if self.isMax then
		SoraDShowMsgTip(i18n("snow_competition_text_02"))
		return false
	end
	return true
end
function Com_9001738_Package:btnBuyClick()
	SoraDPlaySound()
	if self.isMax then
		SoraDShowMsgTip(i18n("snow_competition_text_02"))
		return
	end
	SoraDShowLoading()
	paymentManager.normalGiftBuyClassify(self.packageCfg.rechargeID)
end
return Com_9001738_Package
