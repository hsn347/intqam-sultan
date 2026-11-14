local activityCenterUICtrl = SoraDGetCtrl("activityCenterUICtrl")
local activityTimeRead = include("activityTimeRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseComponent = require("fgui.base.baseComponent")
local activitySingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://TroopsChange/activitySingle", activitySingle)
_ENV, activitySingle.onInit = function(self)
	self:fixChildrenPos()
end, function(self)
	self:fixChildrenPos()
end
;(function(self)
	self:fixChildrenPos()
end)[gActivityTimeActivityID.BATTLEFIELD_TRAINING] = "frame_bzzh_zhanchang.png"
;(function(self)
	self:fixChildrenPos()
end)[gActivityTimeActivityID.PREFERENTIAL_SHOP_ACTIVITY] = "frame_bzzh_shangdian.png"
;(function(self)
	self:fixChildrenPos()
end)[gActivityTimeActivityID.ARMY_TRANSFER_ACTIVTY] = "frame_bzzh_zhuanhuan.png"
local (function(self)
	self:fixChildrenPos()
end)[gActivityTimeActivityID.GEM_EXCHANGE_ACTIVITY], activityBgName = "frame_bzzh_baoshi.png", function(self)
	self:fixChildrenPos()
end
function activitySingle:initData(activityID)
	self.fields.Iconnew:setVisible(activityCenterUICtrl:isHaveNewFlag(activityID))
	self.fields.bg:setURL(activityBgName[activityID])
	self.fields.title:setString(i18n(activityTimeRead.getActivityNameByID(activityID)))
	self:initActivityTime(activityID)
end
function activitySingle:initActivityTime(activityID)
	self.fields.label_Time:setTimeLast(function(strTime)
		_ENV = nil
		;(nil).time = strTime
		return i18n("common_text_4415", nil)
	end)
	local timer = activityShowCtrl:getTimeInfoByID(activityID)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		if 0 < leftTime then
			self.fields.label_Time:beginTime(leftTime)
		else
			self:setVisible(false)
		end
	end
end
return activitySingle
