local baseProxy = require("fgui.base.baseProxy")
local DivineBeastMarkRecycleProxy = class("DivineBeastMarkRecycleProxy", baseProxy)
function DivineBeastMarkRecycleProxy:onRegisterEvent()
	print("=======DivineBeastMarkRecycleProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_DIVINEBEAST_MARK", handler(self, self.onMarkUpdate))
end
function DivineBeastMarkRecycleProxy:onMarkUpdate(target, data)
	dump(data, "DivineBeastMarkRecycleProxy:onMarkUpdate")
	if data.type == "bag" or data.type == "recycle" then
		self.view:updateView()
	end
end
return DivineBeastMarkRecycleProxy
