local nebulaAllStarUtil = include("nebulaAllStarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAllStarNoticePanel = class("NebulaAllStarNoticePanel", baseFguiPanel)
function NebulaAllStarNoticePanel:ctor(...)
	NebulaAllStarNoticePanel.super.ctor(self, ...)
	print("NebulaAllStarNoticePanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NEBULA_ALL_STAR_SHOW_ACTIVITY
end
function NebulaAllStarNoticePanel:onInit()
	print("=======NebulaAllStarNoticePanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose))
	self.fields.Com_title:getLabelTime():initActivityTimeStyle(self.activityID, "common_text_607")
	self.fields.Text_des:setString(i18n("NebulaAllstar_396"))
end
function NebulaAllStarNoticePanel:onShow()
	print("=======NebulaAllStarNoticePanel:onShow")
	local areaName, areaIcon = nebulaAllStarUtil.getAreaNameAndIcon()
	_ENV = nil
	;(nil).name = areaName
	self.fields.Text_region:setString(i18n("emperorannounce_text_1", nil))
	self.fields.Load_region:setURL(areaIcon)
end
return NebulaAllStarNoticePanel
