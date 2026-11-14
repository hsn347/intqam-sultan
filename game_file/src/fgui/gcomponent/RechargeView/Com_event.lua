local baseComponent = require("fgui.base.baseComponent")
local Com_event = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://RechargeView/Com_event", Com_event)
function Com_event:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Com_event:onShow()
end
function Com_event:initData(data, curTab)
	self.data = data
	self.controllers.c1:setSelectedIndex(self.data.index == curTab and 1 or 0)
	self.fields.icon:setSpriteFrame(self.data.icon)
	self.fields.title:setString(i18n(self.data.name))
end
function Com_event:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_RECHARGECENTER_MENU_SELECT"
	;(nil).index = self.data.index
	SoraDSendMessage(nil)
end
return Com_event
