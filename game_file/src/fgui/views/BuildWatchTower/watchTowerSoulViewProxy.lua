local baseProxy = require("fgui.base.baseProxy")
local watchTowerSoulViewProxy = class("watchTowerSoulViewProxy", baseProxy)
function watchTowerSoulViewProxy:onRegisterEvent()
	print("=======watchTowerSoulViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_WATCHSOULTOWER_ADDINFO", handler(self, self.reciveData))
	SoraDAddMessage(self, "MESSAGE_SERVER_WATCHSOULTOWER_EDITINFO", handler(self, self.reciveData))
	SoraDAddMessage(self, "MESSAGE_SERVER_WATCHSOULTOWER_REMOVEINFO", handler(self, self.reciveData))
	SoraDAddMessage(self, "MESSAGE_CLIENT_WATCHTOWER_INGORECONTROL", handler(self, self.checkIgnore))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_ROMANSOUL_EVENTREFRESH", handler(self, self.refreshRomanNode))
end
function watchTowerSoulViewProxy:reciveData(target, data)
	self.view:reciveData(target, data)
end
function watchTowerSoulViewProxy:checkIgnore(target, data)
	self.view:checkIgnore(target, data)
end
function watchTowerSoulViewProxy:refreshRomanNode(target, data)
	self.view:refreshRomanNode(target, data)
end
return watchTowerSoulViewProxy
