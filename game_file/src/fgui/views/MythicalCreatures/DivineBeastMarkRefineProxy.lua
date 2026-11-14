local baseProxy = require("fgui.base.baseProxy")
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
local DivineBeastMarkRefineProxy = class("DivineBeastMarkRefineProxy", baseProxy)
function DivineBeastMarkRefineProxy:onRegisterEvent()
	print("=======DivineBeastMarkRefineProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_DIVINEBEAST_MARK", handler(self, self.onMarkUpdate))
end
function DivineBeastMarkRefineProxy:onMarkUpdate(target, data)
	dump(data, "DivineBeastMarkBagProxy:onMarkUpdate")
	if data.type == "upgrade" or data.type == "element" or data.type == "lock" or data.type == "star" or data.type == "modify" or data.type == "refine" then
		self.view:initData()
	end
end
return DivineBeastMarkRefineProxy
