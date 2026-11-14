local baseProxy = require("fgui.base.baseProxy")
local CastleChangeTaskViewProxy = class("CastleChangeTaskViewProxy", baseProxy)
function CastleChangeTaskViewProxy:onRegisterEvent()
	print("=======CastleChangeTaskViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CASTLE_DRESS_STAGE_CHANGE", handler(self, self.initData))
end
function CastleChangeTaskViewProxy:initData()
	self.view:initData()
end
return CastleChangeTaskViewProxy
