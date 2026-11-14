local baseProxy = require("fgui.base.baseProxy")
local HeroCollectedBiographiesProxy = class("HeroCollectedBiographiesProxy", baseProxy)
function HeroCollectedBiographiesProxy:onRegisterEvent()
	print("=======HeroCollectedBiographiesProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_STORY_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_FILE_DOWNLOAD_SUCCESS_BY_KEY", handler(self, self.updateView))
end
function HeroCollectedBiographiesProxy:updateView(target, data)
	SoraDCloseLoading(self.view)
	if data and data.msg == "MESSAGE_FILE_DOWNLOAD_SUCCESS_BY_KEY" and data.key and data.key == "heros" then
		self.view:updateHeroStyle()
		return
	end
	if data and data.msg == "MESSAGE_SERVER_HERO_STORY_UPDATE" and data.isUnlock then
		self.view:runUnlockEffect()
		return
	end
	self.view:updateView()
end
return HeroCollectedBiographiesProxy
