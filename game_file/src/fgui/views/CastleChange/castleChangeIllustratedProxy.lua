local baseProxy = require("fgui.base.baseProxy")
local castleChangeIllustratedProxy = class("castleChangeIllustratedProxy", baseProxy)
function castleChangeIllustratedProxy:onRegisterEvent()
	print("=======castleChangeIllustratedProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CASTLE_DRESS_STAGE_CHANGE", handler(self, self.initData))
end
function castleChangeIllustratedProxy:initData(target, data)
	self.view:initData(target, data)
end
return castleChangeIllustratedProxy
