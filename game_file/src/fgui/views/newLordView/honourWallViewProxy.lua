local baseProxy = require("fgui.base.baseProxy")
local honourWallViewProxy = class("honourWallViewProxy", baseProxy)
function honourWallViewProxy:onRegisterEvent()
	print("=======honourWallViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LORDINFO_HONOUR_ACHIEVEMENT", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_HONOUR_MEDALREFRESH", handler(self, self.initMedalData))
	SoraDAddMessage(self, "MESSAGE_ITEM_CASTLE_DRESS_CHANGE", handler(self, self.initMedalData))
	SoraDAddMessage(self, "MESSAGE_CASTLE_SKIN_CHANGE", handler(self, self.initMedalData))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_HONOUR_MEDALONSHOW", handler(self, self.initMedalData))
end
function honourWallViewProxy:initData(target, data)
	self.view:initData(target, data)
end
function honourWallViewProxy:initMedalData(target, data)
	self.view:initMedalData(target, data)
end
return honourWallViewProxy
