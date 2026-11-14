local baseProxy = require("fgui.base.baseProxy")
local DivineBeastMarkGroupProxy = class("DivineBeastMarkGroupProxy", baseProxy)
function DivineBeastMarkGroupProxy:onRegisterEvent()
	print("=======DivineBeastMarkGroupProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_DIVINEBEAST_MARK", handler(self, self.onMarkUpdate))
end
function DivineBeastMarkGroupProxy:onMarkUpdate(target, data)
	if data.type == "mountInset" then
		self.view:updateView()
	elseif data.type == "rename" then
		self.view:updateGroupName()
	end
end
return DivineBeastMarkGroupProxy
