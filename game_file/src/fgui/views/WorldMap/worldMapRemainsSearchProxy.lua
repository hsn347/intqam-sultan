local baseProxy = require("fgui.base.baseProxy")
local worldMapRemainsSearchProxy = class("worldMapRemainsSearchProxy", baseProxy)
function worldMapRemainsSearchProxy:onRegisterEvent()
	print("=======worldMapRemainsSearchProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_MONSTERSEARCH_DATAARRIVE", handler(self, self.msgBackData))
end
function worldMapRemainsSearchProxy:msgBackData(target, data)
	self.view:msgBackData(target, data)
end
return worldMapRemainsSearchProxy
