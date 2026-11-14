local baseProxy = require("fgui.base.baseProxy")
local ResurgenceTreeViewProxy = class("ResurgenceTreeViewProxy", baseProxy)
function ResurgenceTreeViewProxy:onRegisterEvent()
	print("=======ResurgenceTreeViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_RESURGENCE_ARMY", handler(self, self.resurgenceBack))
	SoraDAddMessage(self, "MESSAGE_RESURGENCE_TREE_STATE_CHANGE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateView))
end
function ResurgenceTreeViewProxy:resurgenceBack(target, data)
	self.view:resurgenceBack(target, data)
end
function ResurgenceTreeViewProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return ResurgenceTreeViewProxy
