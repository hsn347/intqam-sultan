local baseProxy = require("fgui.base.baseProxy")
local MeteoriteDetailsProxy = class("MeteoriteDetailsProxy", baseProxy)
function MeteoriteDetailsProxy:onRegisterEvent()
	print("=======MeteoriteDetailsProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_METEOR_MAGIC", handler(self, self.updateView))
end
function MeteoriteDetailsProxy:updateView(target, data)
	self.view:updateView()
end
return MeteoriteDetailsProxy
