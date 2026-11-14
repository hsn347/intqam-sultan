local baseComponent = require("fgui.base.baseComponent")
local Com_9001597_add = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Activity_9001597/Com_9001597_add", Com_9001597_add)
function Com_9001597_add:onInit()
	self:fixChildrenPos()
	self.fields.Button_add:addClickEventListener(handler(self, self.onClick))
end
function Com_9001597_add:onShow()
end
function Com_9001597_add:initData(itemID)
	self.itemID = itemID
end
function Com_9001597_add:onClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.itemID
	uiManager:show("CommonSourceGuide", nil)
end
return Com_9001597_add
