local baseProxy = require("fgui.base.baseProxy")
local collegeViewProxy = class("collegeViewProxy", baseProxy)
function collegeViewProxy:onRegisterEvent()
	print("=======collegeViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_UPDATE_TECHNOLOGY", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_LUCKYBLESS_UPDATE", handler(self, self.updateLuckyBless))
	SoraDAddMessage(self, "MESSAGE_TECHNOLOGY_WAITQUEUE", handler(self, self.refreshWaitQueue))
end
function collegeViewProxy:initData()
	self.view:initData()
end
function collegeViewProxy:updateLuckyBless()
	self.view:updateLuckyBless()
end
function collegeViewProxy:refreshWaitQueue()
	self.view:refreshWaitQueue()
end
return collegeViewProxy
