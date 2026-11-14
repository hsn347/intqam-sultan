local baseProxy = require("fgui.base.baseProxy")
local DivineBeastMarkElementSwitchProxy = class("DivineBeastMarkElementSwitchProxy", baseProxy)
function DivineBeastMarkElementSwitchProxy:onRegisterEvent()
	print("=======DivineBeastMarkElementSwitchProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_DIVINEBEAST_MARK", handler(self, self.onMarkUpdate))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onItemUpdate))
end
function DivineBeastMarkElementSwitchProxy:onMarkUpdate(target, data)
	dump(data, "DivineBeastMarkElementSwitchProxy:onMarkUpdate")
	if data.type == "element" then
		self.view:onUpdateNewRandomElem()
	end
end
function DivineBeastMarkElementSwitchProxy:onItemUpdate(target, data)
	self.view:updateBtnStatus()
end
return DivineBeastMarkElementSwitchProxy
