local baseProxy = require("fgui.base.baseProxy")
local testXYBZProxy = class("testXYBZProxy", baseProxy)
function testXYBZProxy:onRegisterEvent()
	print("=======testXYBZProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_KING_INIT", handler(self, self.onMsg))
	SoraDAddMessage(self, "MESSAGE_NEBULA_KING_STAGE_RANK", handler(self, self.onMsg))
	SoraDAddMessage(self, "MESSAGE_NEBULA_KING_TOTAL_RANK", handler(self, self.onMsg))
	SoraDAddMessage(self, "MESSAGE_NEBULA_KING_HISTORY_RANK", handler(self, self.onMsg))
end
function testXYBZProxy:onMsg(target, data)
	self.view:addContent(data)
end
return testXYBZProxy
