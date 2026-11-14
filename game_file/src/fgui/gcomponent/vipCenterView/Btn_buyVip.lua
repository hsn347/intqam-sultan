local baseComponent = require("fgui.base.baseComponent")
local Btn_buyVip = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://vipCenterView/Btn_buyVip", Btn_buyVip)
function Btn_buyVip:onInit()
	self.fields.text_already:setString(i18n("common_text_3833"))
	self:fixChildrenPos()
	self.fields.arrow:fix()
end
function Btn_buyVip:onShow()
end
function Btn_buyVip:initData(retValue, nowPrice, oriPrice)
	local isAlreadyBuy = retValue == gErrDef.Err_PRIVILEGE_GIFT_ALREADY_BUY
	local isNotRnough = retValue == gErrDef.Err_PRIVILEGE_GIFT_VIP_LV_NOT_ENOUGH
	self.controllers.c1:setSelectedIndex(isAlreadyBuy and 1 or 0)
	self:setTouchEnabled(not isAlreadyBuy)
	self:setBright(not isAlreadyBuy and not isNotRnough)
	self.fields.Text_nowPrice:setString(nowPrice)
	self.fields.Text_oriPrice:setString(oriPrice)
	if SoraDFIsRA() then
		self.fields.line:setPositionX(self.fields.Text_oriPrice:getPositionX() - self.fields.Text_oriPrice:getContentSize().width / 2)
	else
		self.fields.line:setPositionX(self.fields.Text_oriPrice:getPositionX() + self.fields.Text_oriPrice:getContentSize().width / 2)
	end
end
return Btn_buyVip
