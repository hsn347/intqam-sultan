local baseComponent = require("fgui.base.baseComponent")
local UI_Btn_recharge = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Btn_recharge", UI_Btn_recharge)
function UI_Btn_recharge:onInit()
end
function UI_Btn_recharge:onShow()
end
function UI_Btn_recharge:initData(nowPri, oriPri)
	self.controllers.c1:setSelectedIndex(0)
	self.fields.textNowPrice:setString(nowPri)
	self.fields.oriShowPrice:setString(oriPri)
	self.fields.arrow:fix()
	self.fields.textNowPrice:fixPos()
	self.fields.oriShowPrice:fixPos()
	self.fields.line:fixPos()
end
function UI_Btn_recharge:setFirstFree(str)
	self.controllers.c1:setSelectedIndex(1)
	self.fields.Text_free:setString(str)
end
function UI_Btn_recharge:setTitle(str)
	self.controllers.c1:setSelectedIndex(2)
	self.fields.title:setString(str)
end
return UI_Btn_recharge
