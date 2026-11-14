local baseProxy = require("fgui.base.baseProxy")
local autokillSetItemViewProxy = class("autokillSetItemViewProxy", baseProxy)
function autokillSetItemViewProxy:onRegisterEvent()
	print("=======autokillSetItemViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_AUTO_KILL_ITEM_SET", handler(self, self.itemChange))
end
function autokillSetItemViewProxy:itemChange(target, data)
	self.view:itemChange(target, data)
end
return autokillSetItemViewProxy
