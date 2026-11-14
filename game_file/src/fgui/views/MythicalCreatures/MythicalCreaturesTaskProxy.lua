local baseProxy = require("fgui.base.baseProxy")
local MythicalCreaturesTaskProxy = class("MythicalCreaturesTaskProxy", baseProxy)
function MythicalCreaturesTaskProxy:onRegisterEvent()
	print("=======MythicalCreaturesTaskProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_DIVINEBEAST", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.msgUpdateItem))
end
function MythicalCreaturesTaskProxy:msgUpdateView()
	self.view:updateView()
end
function MythicalCreaturesTaskProxy:msgUpdateItem()
	self.view:updateItem()
end
return MythicalCreaturesTaskProxy
