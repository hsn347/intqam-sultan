local baseProxy = require("fgui.base.baseProxy")
local RoadRoughViewProxy = class("RoadRoughViewProxy", baseProxy)
function RoadRoughViewProxy:onRegisterEvent()
	print("=======RoadRoughViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROADROUGH_MOVE_SHOW", handler(self, self.showMove))
	SoraDAddMessage(self, "MESSAGE_ROADROUGH_MOVE_HIDE", handler(self, self.hideMove))
	SoraDAddMessage(self, "MESSAGE_ROADROUGH_MOVE_ACT", handler(self, self.moveTo))
	SoraDAddMessage(self, "MESSAGE_ROADROUGH_RESULT", handler(self, self.showResult))
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE", handler(self, self.onResultClose))
end
function RoadRoughViewProxy:showMove(target, data)
	dump(data, "RoadRoughViewProxy:showMove=====", 10)
	self.view:showMove(data.x, data.y)
end
function RoadRoughViewProxy:hideMove(target, data)
	dump(data, "RoadRoughViewProxy:hideMove=====", 10)
	self.view:hideMove()
end
function RoadRoughViewProxy:moveTo(target, data)
	dump(data, "RoadRoughViewProxy:moveTo=====", 10)
	self.view:moveTo(data.x, data.y)
end
function RoadRoughViewProxy:showResult(target, data)
	dump(data, "RoadRoughViewProxy:moveTo=====", 10)
	self.view:showResult(data.isWin)
end
function RoadRoughViewProxy:onResultClose()
	self.view:close()
end
return RoadRoughViewProxy
