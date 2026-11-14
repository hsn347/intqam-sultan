local baseProxy = require("fgui.base.baseProxy")
local questViewProxy = class("questViewProxy", baseProxy)
function questViewProxy:onRegisterEvent()
	print("=======questViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_QUEST_NOTICE_RECOMMEND_UPDATE", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_QUEST_NOTICE_COMMIT_SUCCESS", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_QUEST_NOTICE_PROGRESS_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_NEW_PLAYER_QUEST_CHAPTER", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_UI_DAILYAWARD_REFRESH_BOXES", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_UI_DAILYAWARD_REFRESH_TREASURES", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_UI_DAILYAWARD_REFRESH_EVENTS", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_UI_DAILYAWARD_REFRESH_VIEW", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CASTLE_LEVELUP", handler(self, self.updateView))
end
function questViewProxy:updateRedPoint(target, data)
	self.view:updateRedPoint()
end
function questViewProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return questViewProxy
