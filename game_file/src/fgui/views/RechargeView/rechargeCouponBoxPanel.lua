local rechargeExchangeCtrl = SoraDGetCtrl("rechargeExchangeCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local rechargeCouponBoxPanel = class("rechargeCouponBoxPanel", baseFguiPanel)
function rechargeCouponBoxPanel:ctor(...)
	rechargeCouponBoxPanel.super.ctor(self, ...)
	print("rechargeCouponBoxPanel:ctor", self.viewName)
end
function rechargeCouponBoxPanel:onInit()
	print("=======rechargeCouponBoxPanel:onInit")
	self.fields.Button_token:addClickListener(handler(self, self.btnTokenClick))
	self.fields.Button_coupon:setString(i18n("common_text_4849"))
	self.fields.Button_coupon:addClickListener(handler(self, self.btnCouponClick))
	self.fields.Button_token:fixPos()
	self.fields.Button_coupon:fixPos()
	self.fields.Text_count:fixPos()
end
function rechargeCouponBoxPanel:onShow()
	print("=======rechargeCouponBoxPanel:onShow")
	self.id = self.param.id
	self.couponID = self.param.couponID
	self.price = self.param.price
	self:initData()
end
function rechargeCouponBoxPanel:initData()
	self.fields.Button_token:setPriceIcon(TOKEN_ITEM)
	local count = backpackCtrl:getItemCount(TOKEN_ITEM)
	_ENV = nil
	;(nil).count = fguiHelper.getColorString(count >= self.price and "#FFFBD5" or "#BE2828", SoraDConvertNumberWithUnit(count))
	;(nil).need = SoraDConvertNumberWithUnit(self.price)
	self.fields.Button_token:setPriceTitle(i18n("%{count}/%{need}", nil))
	_ENV = i18n("%{count}/%{need}", nil)
	i18n("%{count}/%{need}", nil).name = include("publicRead").getName(self.couponID)
	self.fields.title:setString(i18n("common_text_4848", i18n("%{count}/%{need}", nil)))
	_ENV = i18n("common_text_4848", i18n("%{count}/%{need}", nil))
	i18n("common_text_4848", i18n("%{count}/%{need}", nil)).num = backpackCtrl:getItemCount(self.couponID)
	self.fields.Text_count:setString(i18n("common_text_4855", i18n("common_text_4848", i18n("%{count}/%{need}", nil))))
end
function rechargeCouponBoxPanel:btnTokenClick()
	SoraDPlaySound()
	SoraDShowH5PurchaseView(self.id, self.param.param, self.param.logInfo, true)
	self:close()
end
function rechargeCouponBoxPanel:btnCouponClick()
	SoraDPlaySound()
	rechargeExchangeCtrl:reqRechargeExchange(self.id, self.couponID, self.param.param)
	self:close()
end
return rechargeCouponBoxPanel
