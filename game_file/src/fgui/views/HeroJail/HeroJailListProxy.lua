local baseProxy = require("fgui.base.baseProxy")
local HeroJailListProxy = class("HeroJailListProxy", baseProxy)
function HeroJailListProxy:onRegisterEvent()
	print("=======HeroJailListProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_RELEASESUCCESS", handler(self, self.releaseSuccessCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_EXECUTESUCCESS", handler(self, self.releaseSuccessCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_NOTICEOTHERHERO", handler(self, self.releaseSuccessCallBack))
end
function HeroJailListProxy:releaseSuccessCallBack()
	self.view:initData()
end
return HeroJailListProxy
