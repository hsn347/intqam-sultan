local baseProxy = require("fgui.base.baseProxy")
local DivineBeastMarkSuitProxy = class("DivineBeastMarkSuitProxy", baseProxy)
function DivineBeastMarkSuitProxy:onRegisterEvent()
	print("=======DivineBeastMarkSuitProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_DIVINEBEAST_MARK", handler(self, self.onMarkUpdate))
end
function DivineBeastMarkSuitProxy:onMarkUpdate(target, data)
	dump(data, "DivineBeastMarkBagProxy:onMarkUpdate")
	if data.type == "reward" then
		self.view:updateView()
	end
end
return DivineBeastMarkSuitProxy
