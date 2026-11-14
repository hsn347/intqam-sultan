local privilegeGiftRead = include("privilegeGiftRead")
local rechargeRead = include("rechargeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampLvUpViewPanel = class("MagicLampLvUpViewPanel", baseFguiPanel)
function MagicLampLvUpViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampLvUpViewPanel:ctor", self.viewName)
end
function MagicLampLvUpViewPanel:onInit()
	self.isAddToPopManager = true
	print("=======MagicLampLvUpViewPanel:onInit")
	self.itemList, _ENV = print, print
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_buy:addClickListener(handler(self, self.readyBuy))
end
function MagicLampLvUpViewPanel:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1].id, self.itemList[index + 1].count)
end
function MagicLampLvUpViewPanel:onShow()
	print("=======MagicLampLvUpViewPanel:onShow")
	if not self.param or not self.param.rechargeID then
		_ENV = nil
		;(nil).byUID = true
	end
	self.rechargeID = SoraDConfigGet("Game:MagicLampLvUpView:magicLvUpRid~integer", nil)
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:MagicLampLvUpView:magicLvUpRid~integer", 0, nil)
	self.giftCfg = privilegeGiftRead.getMagicLampGiftByID(self.rechargeID)
	if self.giftCfg.lv == 999 then
		self:close()
		return
	end
	self:initData()
end
function MagicLampLvUpViewPanel:initData()
	local privilegeType = self.giftCfg.privilegeType
	local giftStyle = rechargeRead.getPageViewData(self.giftCfg.rechargeID)
	if privilegeType == 7 or privilegeType == 8 then
		rechargeRead = nil
		;(nil).name = privilegeGiftRead.getMagicLampJinnName(self.giftCfg.targetID)
		self.fields.Text_giftName:setString(i18n("common_text_4938", nil))
	else
		rechargeRead = i18n("common_text_4938", nil)
		i18n("common_text_4938", nil).lv = fguiHelper.getColorString("#FFFFFF", giftStyle.activeName.lv)
		self.fields.Text_giftName:setString(i18n(giftStyle.activeName[1], i18n("common_text_4938", nil)))
	end
	self.fields.icon:setIcon(privilegeGiftRead.getMagicLampJinnPng(self.giftCfg.targetID))
	rechargeRead = privilegeGiftRead.getMagicLampJinnPng(self.giftCfg.targetID)
	privilegeGiftRead.getMagicLampJinnPng(self.giftCfg.targetID).name = privilegeGiftRead.getMagicLampJinnName(self.giftCfg.targetID)
	privilegeGiftRead.getMagicLampJinnPng(self.giftCfg.targetID).lv = self.giftCfg.lv
	self.fields.Text_lvup:setString(i18n("common_text_4780", privilegeGiftRead.getMagicLampJinnPng(self.giftCfg.targetID)))
	self.fields.Com_disTop:initData(self.giftCfg)
	self.itemList = self.giftCfg.totalReward
	self.fields.List:setNumItems(#self.itemList)
	local str_resource = SoraDConvertNumberWithUnit(self.giftCfg.totalResource)
	local str_hour = math.floor(self.giftCfg.totalSpeed / 3600)
	rechargeRead = i18n("common_text_4780", privilegeGiftRead.getMagicLampJinnPng(self.giftCfg.targetID))
	i18n("common_text_4780", privilegeGiftRead.getMagicLampJinnPng(self.giftCfg.targetID)).resource = str_resource
	i18n("common_text_4780", privilegeGiftRead.getMagicLampJinnPng(self.giftCfg.targetID)).hour = str_hour
	self.fields.Text_tips:setString(i18n("common_text_3989", i18n("common_text_4780", privilegeGiftRead.getMagicLampJinnPng(self.giftCfg.targetID))))
	local showPrice, isGetPrice = paymentManager.judgePrice(self.giftCfg.rechargeID, self.giftCfg.price)
	local discount = self.giftCfg.originalPrice / self.giftCfg.price
	local oriShowPrice = paymentManager.calculateDiscount(self.giftCfg.rechargeID, showPrice, discount, self.giftCfg.originalPrice)
	self.nowPrice = showPrice
	self.oriPrice = oriShowPrice
	self.fields.Button_buy:initData(self.nowPrice, self.oriPrice)
	self:updateOutAppPurchase()
end
function MagicLampLvUpViewPanel:updateOutAppPurchase()
	local rid = self.giftCfg.rechargeID
	if SoraDCheckOAPIsOpen(rid) then
		self.fields.outAppPurchaseButtons:setVisible(true)
		self.fields.Button_buy:setVisible(false)
		_ENV = false
		;(false).rid = rid
		;(false).nowPrice = self.nowPrice
		_ENV, (false).oriPrice = self.oriPrice, self.oriPrice
		self.oriPrice.fromCenter = gRechargeActiveFromEnum.ROAD49
		;(false).logInfo, self.oriPrice.isPageTurn = self.oriPrice, false
		;(false).handlePurchaseBack = handler(self, self.close)
		;(false).handleBuyClick = handler(self, self.readyBuy)
		self.fields.outAppPurchaseButtons:initData(false)
	else
		self.fields.outAppPurchaseButtons:setVisible(false)
		self.fields.Button_buy:setVisible(true)
	end
end
function MagicLampLvUpViewPanel:readyBuy()
	SoraDPlaySound()
	paymentManager.normalGiftBuyClassify(self.giftCfg.rechargeID)
	paymentManager.OnemtReadyBuy(self.giftCfg.rechargeID, gRechargeActiveFromEnum.ROAD49)
end
return MagicLampLvUpViewPanel
