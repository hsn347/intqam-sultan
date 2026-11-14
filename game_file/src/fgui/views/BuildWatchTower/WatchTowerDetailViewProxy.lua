local baseProxy = require("fgui.base.baseProxy")
local WatchTowerDetailViewProxy = class("WatchTowerDetailViewProxy", baseProxy)
function WatchTowerDetailViewProxy:onRegisterEvent()
	print("=======WatchTowerDetailViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_WATCHTOWER_DETAILBACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_WATCHTOWER_REMOVEINFO", handler(self, self.reciveData))
	SoraDAddMessage(self, "MESSAGE_SERVER_WATCHTOWER_EDITINFO", handler(self, self.reciveData))
	SoraDAddMessage(self, "MESSAGE_SERVER_WATCHSOULTOWER_REMOVEINFO", handler(self, self.reciveData))
	SoraDAddMessage(self, "MESSAGE_SERVER_WATCHSOULTOWER_EDITINFO", handler(self, self.reciveData))
	SoraDAddMessage(self, "MESSAGE_SERVER_WATCHTOWER_REFRESHALL", handler(self, self.closeMe))
end
function WatchTowerDetailViewProxy:initData(target, redata)
	self.view:initData(target, redata)
end
function WatchTowerDetailViewProxy:reciveData(target, redata)
	self.view:reciveData(target, redata)
end
function WatchTowerDetailViewProxy:closeMe(target, redata)
	self.view:closeMe(target, redata)
end
function WatchTowerDetailViewProxy:req4info(...)
	self.view:req4info(...)
end
return WatchTowerDetailViewProxy
