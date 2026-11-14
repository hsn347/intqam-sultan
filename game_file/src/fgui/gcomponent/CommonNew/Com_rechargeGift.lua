local baseComponent = require("fgui.base.baseComponent")
local Com_rechargeGift = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Com_rechargeGift", Com_rechargeGift)
fgui.register_extension("ui://CommonNew/Com_rechargeGiftEx", Com_rechargeGift)
fgui.register_extension("ui://CommonNew/Com_rechargeGift_SVIP", Com_rechargeGift)
function Com_rechargeGift:onInit()
	self:addClickListener(handler(self, self.onClick))
	if self.fields.Text_Tips then
		self.fields.Text_Tips:setString(i18n("activity_name_9001266"))
	end
	self.fields.Label_timer:setTimeEndListener(function()
		self:setVisible(false)
	end)
end
function Com_rechargeGift:onClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).rechargeIDList = self.rechargeIDList
	uiManager:show("rechargeGiftRewardPopView", nil)
end
function Com_rechargeGift:onShow()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.RECHARGE_ACTIVITY_GIFT_ACTIVITY)
	if eventTime then
		self.fields.Label_timer:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
end
function Com_rechargeGift:initData(rechargeIDList)
	self.rechargeIDList = rechargeIDList
end
function Com_rechargeGift:fixBgEX()
	self.fields.n7:setScaleX(SoraDFIsRA() and -1 or 1)
end
