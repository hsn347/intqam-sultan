local baseProxy = require("fgui.base.baseProxy")
local bagViewProxy = class("bagViewProxy", baseProxy)
function bagViewProxy:onRegisterEvent()
	print("=======bagViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.updateDiscount))
	SoraDAddMessage(self, "MESSAGE_ITEM_LIMITITEM_TIMEOUT_BACK", handler(self, self.updateNewTag))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateNewTag))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", function(target, data)
		if data.name == "remind" or data.name == "refreshData" then
			self:updateNewTag()
		end
	end)
end
function bagViewProxy:updateDiscount(target, data)
	if data and data.activityID == gActivityTimeActivityID.LIMITED_DISCOUNT_ACTIVITY then
		self.view:updateDiscount()
	end
end
function bagViewProxy:updateNewTag(target, data)
	self.view:updateNewTag()
end
return bagViewProxy
