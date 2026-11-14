local baseProxy = require("fgui.base.baseProxy")
local castleChangeViewProxy = class("castleChangeViewProxy", baseProxy)
function castleChangeViewProxy:onRegisterEvent()
	print("=======castleChangeViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CASTLE_DRESS_STAGE_CHANGE", handler(self, self.updateRewardRed))
	SoraDAddMessage(self, "MESSAGE_CASTLE_SKIN_CHANGE_NEW", handler(self, self.refreshCastleSkin))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_UI_DRESS_SELECT", handler(self, self.updateSelectDress))
	SoraDAddMessage(self, "MESSAGE_UI_DRESS_GROUP_SELECT", handler(self, self.updateSelectGroupDress))
	SoraDAddMessage(self, "MESSAGE_UI_DRESS_TIME_SELECT", handler(self, self.updateSelectTimeDress))
end
function castleChangeViewProxy:updateRewardRed(target, data)
	self.view:updateRewardRed(target, data)
end
function castleChangeViewProxy:updateView(target, data)
	self.view:updateView(target, data)
end
function castleChangeViewProxy:updateSelectDress(target, data)
	self.view:updateSelectDress(target, data)
end
function castleChangeViewProxy:updateSelectGroupDress(target, data)
	self.view:updateSelectGroupDress(target, data)
end
function castleChangeViewProxy:updateSelectTimeDress(target, data)
	self.view:updateSelectTimeDress(target, data)
end
function castleChangeViewProxy:refreshCastleSkin(target, data)
	self.view:refreshCastleSkin(target, data)
end
return castleChangeViewProxy
