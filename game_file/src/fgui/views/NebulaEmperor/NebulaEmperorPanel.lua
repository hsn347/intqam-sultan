local nebulaWarRead = include("nebulaWarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaEmperorPanel = class("NebulaEmperorPanel", baseFguiPanel)
function NebulaEmperorPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaEmperorPanel:ctor", self.viewName)
end
function NebulaEmperorPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaEmperorPanel:onInit()
	print("=======NebulaEmperorPanel:onInit")
	self.activityID = gActivityTimeActivityID.NEBULA_EMPEROR_SHOW_ACTIVITY
	self.fields.Com_title:initData(i18n("activity_name_9001536"), handler(self, self.onClickClose))
	self.fields.Com_title:setTimeShow(false)
	self.fields.Text_1:setString(i18n("emperorannounce_text_2"))
	self.fields.Text_2:setString(i18n("Community_text_0011"))
end
function NebulaEmperorPanel:onShow()
	print("=======NebulaEmperorPanel:onShow")
	local regionType, rId = SoraDGetCtrl("nebulaActivityCtrl"):getKingdomRegionType()
	rId = rId or 8
	if regionType ~= NEBULA_REGION_TYPE.HEGEMONY_REGION then
		self.fields.Text_3:setVisible(false)
	else
		_ENV = nil
		;(nil).name = nebulaWarRead.getAreaName(rId)
		self.fields.Text_3:setString(i18n("emperorannounce_text_1", nil))
	end
	self.fields.Com_MapArro:initData(rId)
end
return NebulaEmperorPanel
