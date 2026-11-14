local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceShopLimitedPanel = class("AllianceShopLimitedPanel", baseFguiPanel)
function AllianceShopLimitedPanel:ctor(...)
	self.super.ctor(self, ...)
	print("AllianceShopLimitedPanel:ctor", self.viewName)
end
function AllianceShopLimitedPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function AllianceShopLimitedPanel:onInit()
	print("=======AllianceShopLimitedPanel:onInit")
	self.fields.Panel_bg:setString(i18n("allianceShop_timeLimitDesc_title"))
	self.fields.Text_des:setString(i18n("allianceShop_timeLimitDesc_text"))
end
function AllianceShopLimitedPanel:onShow()
	print("=======AllianceShopLimitedPanel:onShow")
	self:setTime(self.proxy.param.endTime)
end
function AllianceShopLimitedPanel:setTime(endtime)
	local leftTime = endtime - serviceFunctions.systemTime()
	if 0 < leftTime then
		self.fields.Text_time:setTimeLast(function(time)
			_ENV = nil
			;(nil).var1 = time
			return i18n("allianceShop_timeLimit_name", nil)
		end)
		self.fields.Text_time:beginTime(leftTime)
		self.fields.Text_time:setTimeEndListener(function()
			self:removeFromParent()
		end)
	end
end
return AllianceShopLimitedPanel
