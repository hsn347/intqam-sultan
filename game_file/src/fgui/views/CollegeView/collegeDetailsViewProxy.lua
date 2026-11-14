local baseProxy = require("fgui.base.baseProxy")
local collegeDetailsViewProxy = class("collegeDetailsViewProxy", baseProxy)
function collegeDetailsViewProxy:onRegisterEvent()
	print("=======collegeDetailsViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_TECHNOLOGY", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_LUCKYBLESS_UPDATE", handler(self, self.updateLuckyBless))
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.updateView))
end
function collegeDetailsViewProxy:updateView()
	self.view:updateView()
end
function collegeDetailsViewProxy:updateLuckyBless()
	self.view:updateLuckyBless()
end
return collegeDetailsViewProxy
