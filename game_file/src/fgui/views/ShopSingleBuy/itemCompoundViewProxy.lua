local baseProxy = require("fgui.base.baseProxy")
local itemCompoundViewProxy = class("itemCompoundViewProxy", baseProxy)
function itemCompoundViewProxy:onRegisterEvent()
	print("=======itemCompoundViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_MERGE_BACK", handler(self, self.addItemUseEffect))
end
function itemCompoundViewProxy:addItemUseEffect()
	self.view:addItemUseEffect()
end
return itemCompoundViewProxy
