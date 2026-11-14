local baseProxy = require("fgui.base.baseProxy")
local DivineBeastMarkStarProxy = class("DivineBeastMarkStarProxy", baseProxy)
function DivineBeastMarkStarProxy:onRegisterEvent()
	print("=======DivineBeastMarkStarProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_DIVINEBEAST_MARK", handler(self, self.onMarkUpdate))
end
function DivineBeastMarkStarProxy:onMarkUpdate(target, data)
	dump(data, "DivineBeastMarkBagProxy:onMarkUpdate")
	if data.type == "bag" then
		self.view:updateView()
	end
end
return DivineBeastMarkStarProxy
