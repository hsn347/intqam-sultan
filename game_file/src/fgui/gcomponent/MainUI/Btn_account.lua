local baseComponent = require("fgui.base.baseComponent")
local Btn_account = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_account", Btn_account)
function Btn_account:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
	self.fields.Sprite_redPoint:fixPos()
end
function Btn_account:onShow()
end
function Btn_account:setRedVisible(ret)
	self.fields.Sprite_redPoint:setVisible(ret)
end
function Btn_account:setShowType(sType)
	self.controllers.c1:setSelectedIndex(sType)
end
function Btn_account:onBtnClick()
	SoraDPlaySound("uicontrol", 48)
	uiManager:show("commonAccountBonusBox")
end
return Btn_account
