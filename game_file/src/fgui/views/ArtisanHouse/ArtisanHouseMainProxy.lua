local baseProxy = require("fgui.base.baseProxy")
local ArtisanHouseMainProxy = class("ArtisanHouseMainProxy", baseProxy)
function ArtisanHouseMainProxy:onRegisterEvent()
	print("=======ArtisanHouseMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ARTISAN_HOUSE_REFRESH", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.updateTask))
end
function ArtisanHouseMainProxy:refreshView(target, data)
	if self.view then
		self.view:refreshView(data)
	end
end
function ArtisanHouseMainProxy:updateTask(target, data)
	if self.view then
		self.view:updateTask(data)
		self.view:initData()
	end
end
function ArtisanHouseMainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ARTISAN_HOUSE_ACTIVITY) and self.view then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return ArtisanHouseMainProxy
