local baseComponent = require("fgui.base.baseComponent")
local Button_rechargeItem = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://RechargeView/Button_rechargeItem", Button_rechargeItem)
function Button_rechargeItem:onInit()
	self:fixChildrenPos()
end
function Button_rechargeItem:onShow()
end
function Button_rechargeItem:initData(icon, curVal, needVal)
	self.fields.icon:setSpriteFrame(icon)
	_ENV = nil
	;(nil).curVal = fguiHelper.getColorString(needVal <= curVal and "#FFFBD5" or "#BE2828", curVal)
	;(nil).needVal = needVal
	self.fields.title:setString(i18n("%{curVal}/%{needVal}", nil))
end
return Button_rechargeItem
