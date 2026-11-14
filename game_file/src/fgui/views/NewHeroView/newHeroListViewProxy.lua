local baseProxy = require("fgui.base.baseProxy")
local newHeroListViewProxy = class("newHeroListViewProxy", baseProxy)
function newHeroListViewProxy:onRegisterEvent()
	print("=======newHeroListViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_CHANGE_TYPE", handler(self, self.recevieItemChangeMsg))
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_RECRUITSUCCESS", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_STARTUPGRADE", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_RESURGENCESUCCESS", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_UI_HERO_REFRESHLISTVIEW", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_NOTICEHERO", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_STORY_UPDATE", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_DRESS_UPDATE", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_HERO_NEW_TRIAL_UPDATE", handler(self, self.onMsgUpdateHeroNewTrial))
end
function newHeroListViewProxy:recevieItemChangeMsg(target, data)
	if data and data.itemType and gItemType.HERO_CHIP == data.itemType then
		self.view:updateData()
	end
end
function newHeroListViewProxy:updateData(target, data)
	self.view:updateData()
end
function newHeroListViewProxy:onMsgUpdateHeroNewTrial(...)
	self.view:onMsgUpdateHeroNewTrial(...)
end
return newHeroListViewProxy
