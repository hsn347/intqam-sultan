local payBackCtrl = SoraDGetCtrl("payBackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local BackMoneySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BackMoney/BackMoneySingle", BackMoneySingle)
function BackMoneySingle:onInit()
	self.fields.Button_buy:setTitleText(i18n("common_text_282"))
	self.fields.Button_buy:addClickListener(handler(self, self.onBuyClick))
	self:fixChildrenPos()
	self.fields.n0:fix()
	self.fields.n1:fix()
end
function BackMoneySingle:onShow()
end
function BackMoneySingle:initData(data, isSelect)
	self.data = data
	self.isSelect = isSelect
	self.fields.Sprite_icon:setSpriteFrame(self.data.Icon)
	_ENV = nil
	;(nil).num = ""
	self.fields.Text_name:setString(i18n("PayBack_Text_13", nil))
	self.fields.Text_price:setString("$" .. self.data.Price)
end
function BackMoneySingle:onBuyClick()
	SoraDPlaySound()
	if not self.isSelect then
		SoraDShowMsgTip(i18n("PayBack_Text_12"))
		return
	end
	if payBackCtrl:getPrice() > 0 then
		_ENV = i18n("PayBack_Text_12")
		userSDKManager.logEvent(gSDKDef.TDonEvent.payback_6, i18n("PayBack_Text_12"))
		payBackCtrl:reqPayBackBuy(self.data.RechargeId)
	end
end
return BackMoneySingle
