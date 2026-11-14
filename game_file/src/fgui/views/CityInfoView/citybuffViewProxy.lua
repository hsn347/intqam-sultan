local baseProxy = require("fgui.base.baseProxy")
local citybuffViewProxy = class("citybuffViewProxy", baseProxy)
function citybuffViewProxy:onRegisterEvent()
	print("=======citybuffViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CITYBUFF_DISAPPEAR", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CITYBUFF_ADD", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_NEWPLAYER_BUFF_END", handler(self, self.updateNewPlayer))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_CITY_BUFF_VIEW", handler(self, self.setRefreshMark))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_BUFF_NOTIFY", handler(self, self.setRefreshMark))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_SKILL_NOTIFY", handler(self, self.setRefreshMark))
end
function citybuffViewProxy:initData()
	self.view:initData()
end
function citybuffViewProxy:updateNewPlayer()
	self.view:updateNewPlayer()
end
function citybuffViewProxy:setRefreshMark()
	self.view:setRefreshMark()
end
return citybuffViewProxy
