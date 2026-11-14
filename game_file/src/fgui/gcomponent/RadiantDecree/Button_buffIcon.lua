local baseComponent = require("fgui.base.baseComponent")
local Button_buffIcon = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://RadiantDecree/Button_buffIcon", Button_buffIcon)
function Button_buffIcon:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Button_buffIcon:initData(iconName, buffDes)
	self.buffDes = buffDes
	self.fields.icon:setURL(iconName)
end
function Button_buffIcon:onBtnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).des = self.buffDes
	uiManager:show("RadiantMsgTip", nil)
end
function Button_buffIcon:onShow()
end
return Button_buffIcon
