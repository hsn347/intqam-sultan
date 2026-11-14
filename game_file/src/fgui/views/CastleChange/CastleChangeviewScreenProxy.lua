local baseProxy = require("fgui.base.baseProxy")
local CastleChangeviewScreenProxy = class("CastleChangeviewScreenProxy", baseProxy)
function CastleChangeviewScreenProxy:onRegisterEvent()
	print("=======CastleChangeviewScreenProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_DRESS_GROUP_SELECT", handler(self, self.updateView))
end
function CastleChangeviewScreenProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return CastleChangeviewScreenProxy
