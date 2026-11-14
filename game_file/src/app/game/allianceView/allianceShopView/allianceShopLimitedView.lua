local allianceShopLimitedView = class("allianceShopLimitedView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceShopLimitedView")
	end
	return target
end)
function allianceShopLimitedView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("allianceShop_timeLimitDesc_title"))
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Text_msg = SoraDGetChildByName(self, "Text_msg")
	self.Text_msg:setString(i18n("allianceShop_timeLimitDesc_text"))
end
function allianceShopLimitedView:setTime(endtime)
	local leftTime = endtime - serviceFunctions.systemTime()
	if 0 < leftTime then
		self.Text_time:setTimeLast(function(time)
			_ENV = nil
			;(nil).var1 = time
			return i18n("allianceShop_timeLimit_name", nil)
		end)
		self.Text_time:beginTime(leftTime)
		self.Text_time:setTimeEndListener(function()
			self:removeFromParent()
		end)
	end
end
return allianceShopLimitedView
