local baseProxy = require("fgui.base.baseProxy")
local rechargeViewProxy = class("rechargeViewProxy", baseProxy)
function rechargeViewProxy:onRegisterEvent()
	print("=======rechargeViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_EXTRA_UI_REFRESH", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.updateHeadBtns))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_DAILYFREEGIFT_REFRESH", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_DAILYSPECIALGIFTBUY_REFRESH", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_DAILYSPECIALGIFT_REFRESH", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_ACTIVETIMEOUT", handler(self, self.updateMonthWeek))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_WEEKLY_REFRESH", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_MONTHLY_REFRESH", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_TAKE_REFRESH", handler(self, self.updateRedPoint))
end
function rechargeViewProxy:updateHeadBtns(target, data)
	if type(data.activityID) == "table" then
		for _, v in pairs(data.activityID) do
			if v == gActivityTimeActivityID.DAILY_DISCOUNT_GIFT_ACTIVITY or v == gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT then
				self.view:updateHeadBtns(true)
			end
		end
	elseif type(data.activityID) == "number" and (data.activityID == gActivityTimeActivityID.DAILY_DISCOUNT_GIFT_ACTIVITY or data.activityID == gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT or data.activityID == gActivityTimeActivityID.NEW_PRINCE_GIFT_ACTIVITY) then
		self.view:updateHeadBtns(true)
	end
	self.view:updateRedPoint()
end
function rechargeViewProxy:updateRedPoint(target, data)
	self.view:updateRedPoint()
end
function rechargeViewProxy:updateMonthWeek(target, data)
	if data and data.redata and data.redata.rid then
		local info = include("rechargeRead").getPageViewData(data.redata.rid)
		if info and (gRechargeActiveModelType.MONTHLYGIFT == info.activeModelType or gRechargeActiveModelType.WEEKLY_GIFT == info.activeModelType or gRechargeActiveModelType.SUBSCRIPTION == info.activeModelType) then
			self.view:updateRedPoint()
		end
		self.view:updateHeadBtns(true)
	end
end
function rechargeViewProxy:updateHeadToOne(target, data)
	self.view:updateHeadBtns(true)
end
function rechargeViewProxy:initView(target, data)
	self.view:initView(target, data)
end
return rechargeViewProxy
