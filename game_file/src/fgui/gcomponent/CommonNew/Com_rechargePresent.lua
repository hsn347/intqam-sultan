local activityTimeRead = include("activityTimeRead")
local rechargePresentUtil = include("rechargePresentUtil")
local resDesRead = include("resDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_rechargePresent = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Com_rechargePresent", Com_rechargePresent)
fgui.register_extension("ui://CommonNew/Com_rechargePresent_SVIP", Com_rechargePresent)
function Com_rechargePresent:onInit()
	self.activityID = gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT
	self:addClickListener(handler(self, self.onClick))
	self.fields.Label_timer:setTimeEndListener(function()
		self:setVisible(false)
	end)
end
function Com_rechargePresent:onClick()
	SoraDPlaySound()
	rechargePresentUtil.openActivityView(self.activityID)
end
function Com_rechargePresent:onShow()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if eventTime then
		self.fields.Label_timer:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
end
function Com_rechargePresent:setActivityID(activityID)
	self.activityID = activityID
	local resId = rechargePresentUtil.getResIdByActivityID(self.activityID)
	local iconName = resDesRead.getIcon(resId)
	self.fields.Loader:setURL(iconName)
	local activityName = activityTimeRead.getActivityNameByID(self.activityID)
	self.fields.Text_Tips:setString(i18n(activityName))
end
function Com_rechargePresent:fixBgEX()
	self.fields.n7:setScaleX(SoraDFIsRA() and -1 or 1)
end
