local baseComponent = require("fgui.base.baseComponent")
local Btn_menuRes = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://marketView/Btn_menuRes", Btn_menuRes)
function Btn_menuRes:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_menuRes:onShow()
end
function Btn_menuRes:initData(cfg, index)
	self.index = cfg.tag
	self.fields.icon:setSpriteFrame(cfg.png)
	self.controllers.c1:setSelectedIndex(self.index == index and 1 or 0)
end
function Btn_menuRes:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_MARKET_NEW_RESOURCE_SELECT"
	;(nil).index = self.index
	SoraDSendMessage(nil)
end
return Btn_menuRes
