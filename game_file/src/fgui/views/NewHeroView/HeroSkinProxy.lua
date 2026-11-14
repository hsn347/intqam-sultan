local baseProxy = require("fgui.base.baseProxy")
local HeroSkinProxy = class("HeroSkinProxy", baseProxy)
function HeroSkinProxy:onRegisterEvent()
	print("=======HeroSkinProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_DRESS_ACTIVE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_DRESS_WEAR", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_DRESS_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_MERGE_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateView))
end
function HeroSkinProxy:updateView(target, data)
	SoraDCloseLoading(self.view)
	self.view:updateInfo()
	self.view:loadSingleList()
	self.view:updateBtns()
end
return HeroSkinProxy
