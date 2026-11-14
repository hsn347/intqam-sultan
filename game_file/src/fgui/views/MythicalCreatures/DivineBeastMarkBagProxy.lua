local baseProxy = require("fgui.base.baseProxy")
local DivineBeastMarkBagProxy = class("DivineBeastMarkBagProxy", baseProxy)
function DivineBeastMarkBagProxy:onRegisterEvent()
	print("=======DivineBeastMarkBagProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_DIVINEBEAST_MARK", handler(self, self.onMarkUpdate))
end
function DivineBeastMarkBagProxy:onMarkUpdate(target, data)
	dump(data, "DivineBeastMarkBagProxy:onMarkUpdate")
	if data.type == "bag" or data.type == "recycle" or data.type == "star" or data.type == "change" or data.type == "modify" or data.type == "refine" or data.type == "element" then
		self.view:updateView(data.bagMarkId, data.type)
	elseif data.type == "exp" then
		self.view:updateExp()
	end
end
return DivineBeastMarkBagProxy
