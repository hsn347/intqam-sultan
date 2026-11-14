local baseComponent = require("fgui.base.baseComponent")
local Button_recharge = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://RechargeView/Button_recharge", Button_recharge)
function Button_recharge:onInit()
end
function Button_recharge:onShow()
end
function Button_recharge:initData(nowPri, oriPri)
	self.controllers.c1:setSelectedIndex(0)
	self.fields.textNowPrice:setString(nowPri)
	self.fields.oriShowPrice:setString(oriPri)
	self.fields.arrow:fix()
	self.fields.textNowPrice:fixPos()
	self.fields.oriShowPrice:fixPos()
	self.fields.line:fixPos()
end
function Button_recharge:setFirstFree(str)
	self.controllers.c1:setSelectedIndex(1)
	self.fields.Text_free:setString(str)
end
function Button_recharge:setTitle(str)
	self.controllers.c1:setSelectedIndex(2)
	self.fields.title:setString(str)
end
return Button_recharge
