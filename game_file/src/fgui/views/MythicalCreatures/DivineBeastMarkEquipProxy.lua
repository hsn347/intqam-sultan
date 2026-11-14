local baseProxy = require("fgui.base.baseProxy")
local DivineBeastMarkEquipProxy = class("DivineBeastMarkEquipProxy", baseProxy)
function DivineBeastMarkEquipProxy:onRegisterEvent()
	print("=======DivineBeastMarkEquipProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_DIVINEBEAST_MARK", handler(self, self.onMarkUpdate))
end
function DivineBeastMarkEquipProxy:onMarkUpdate(target, data)
	dump(data, "DivineBeastMarkBagProxy:onMarkUpdate")
	if data.type == "upgrade" or data.type == "element" or data.type == "lock" or data.type == "refine" or data.type == "modify" then
		self.view:updateMark(data.bagMarkId)
	end
end
return DivineBeastMarkEquipProxy
