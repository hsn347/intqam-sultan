local baseProxy = require("fgui.base.baseProxy")
local AllianceWarRallyViewProxy = class("AllianceWarRallyViewProxy", baseProxy)
function AllianceWarRallyViewProxy:onRegisterEvent()
	print("=======AllianceWarRallyViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_MAIN_DELETE_NEW", handler(self, self.updateDelete))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_UPDATE_STATUS_NEW", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_RALLY_DELETE_NEW", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_RALLY_ADD_NEW", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_RALLY_MASS_UPDATE_NEW", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_MAIN_REFRESH", handler(self, self.updateDataRefresh))
end
function AllianceWarRallyViewProxy:updateDelete(...)
	self.view:updateDelete(...)
end
function AllianceWarRallyViewProxy:updateView(...)
	self.view:updateView(...)
end
function AllianceWarRallyViewProxy:updateDataRefresh(...)
	self.view:updateDataRefresh(...)
end
function AllianceWarRallyViewProxy:initData(...)
	self.view:initData(...)
end
return AllianceWarRallyViewProxy
