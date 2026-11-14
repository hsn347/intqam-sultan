local baseProxy = require("fgui.base.baseProxy")
local DivineBeastMarkChangeChooseProxy = class("DivineBeastMarkChangeChooseProxy", baseProxy)
function DivineBeastMarkChangeChooseProxy:onRegisterEvent()
	print("=======DivineBeastMarkChangeChooseProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_DIVINEBEAST_MARK", handler(self, self.onMarkUpdate))
end
function DivineBeastMarkChangeChooseProxy:onMarkUpdate(target, data)
	dump(data, "DivineBeastMarkRecycleProxy:onMarkUpdate")
	if data.type == "bag" or data.type == "change" then
		self.view:updateView()
	end
end
return DivineBeastMarkChangeChooseProxy
