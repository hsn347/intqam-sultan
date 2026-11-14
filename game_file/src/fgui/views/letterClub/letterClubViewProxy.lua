local baseProxy = require("fgui.base.baseProxy")
local letterClubViewProxy = class("letterClubViewProxy", baseProxy)
function letterClubViewProxy:onRegisterEvent()
	print("=======letterClubViewProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_LETTER_CLUB_BACK", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_LETTER_CLUB_REFRESH", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateLetter))
end
function letterClubViewProxy:initView(target, data)
	self.view:initView(target, data)
end
function letterClubViewProxy:updateLetter(target, data)
	self.view:updateLetter(target, data)
end
return letterClubViewProxy
