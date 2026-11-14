local baseProxy = require("fgui.base.baseProxy")
local WatchTowerViewProxy = class("WatchTowerViewProxy", baseProxy)
function WatchTowerViewProxy:onRegisterEvent()
	print("=======WatchTowerViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_WATCHTOWER_ADDINFO", handler(self, self.dataAdd))
	SoraDAddMessage(self, "MESSAGE_SERVER_WATCHTOWER_REMOVEINFO", handler(self, self.dataDel))
	SoraDAddMessage(self, "MESSAGE_SERVER_WATCHTOWER_EDITINFO", handler(self, self.dataUpdate))
	SoraDAddMessage(self, "MESSAGE_SERVER_WATCHTOWER_REFRESHALL", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_SETTING", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_SERVER_ESCORT_WATCHTOWER_INVITE_ACCEPTED", handler(self, self.handlEscort))
	SoraDAddMessage(self, "MESSAGE_CLIENT_WATCHTOWER_INGORECONTROL", handler(self, self.checkIgnore))
	SoraDAddMessage(self, "MESSAGE_CLIENT_WATCHTOWER_INGORECONTROLONE", handler(self, self.ignoreDataOne))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_GOTO_FOREG_BACK_GROUD", function(...)
		self.view:close()
	end)
end
function WatchTowerViewProxy:dataAdd(target, redata)
	self.view:dataAdd(target, redata)
end
function WatchTowerViewProxy:dataDel(target, redata)
	self.view:dataDel(target, redata)
end
function WatchTowerViewProxy:dataUpdate(target, redata)
	self.view:dataUpdate(target, redata)
end
function WatchTowerViewProxy:refreshView(target, redata)
	self.view:refreshView(target, redata)
end
function WatchTowerViewProxy:handlEscort(target, redata)
	self.view:handlEscort(target, redata)
end
function WatchTowerViewProxy:checkIgnore(target, redata)
	self.view:checkIgnore(target, redata)
end
function WatchTowerViewProxy:ignoreDataOne(target, redata)
	self.view:ignoreDataOne(target, redata)
end
return WatchTowerViewProxy
