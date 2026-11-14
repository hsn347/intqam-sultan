local baseProxy = require("fgui.base.baseProxy")
local WorldMassWhiteProxy = class("WorldMassWhiteProxy", baseProxy)
function WorldMassWhiteProxy:onRegisterEvent()
	print("=======WorldMassWhiteProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MASS_SETTING_WHITE_LIST_UPDATE", handler(self, self.updateView))
end
function WorldMassWhiteProxy:updateView()
	SoraDCloseLoading(self.view)
	self.view:updateView()
end
return WorldMassWhiteProxy
