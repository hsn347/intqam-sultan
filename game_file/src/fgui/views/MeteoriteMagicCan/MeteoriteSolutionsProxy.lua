local baseProxy = require("fgui.base.baseProxy")
local MeteoriteSolutionsProxy = class("MeteoriteSolutionsProxy", baseProxy)
function MeteoriteSolutionsProxy:onRegisterEvent()
	print("=======MeteoriteSolutionsProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_METEOR_MAGIC", handler(self, self.updateView))
end
function MeteoriteSolutionsProxy:updateView(target, data)
	self.view:updateView()
end
return MeteoriteSolutionsProxy
