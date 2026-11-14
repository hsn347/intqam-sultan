local activityCenterUICtrl = SoraDGetCtrl("activityCenterUICtrl")
local shiftingstarsRead = include("shiftingstarsRead")
local activityTimeRead = include("activityTimeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local IceShimmerDetailPanel = class("IceShimmerDetailPanel", baseFguiPanel)
function IceShimmerDetailPanel:ctor(...)
	IceShimmerDetailPanel.super.ctor(self, ...)
	print("IceShimmerDetailPanel:ctor", self.viewName)
end
function IceShimmerDetailPanel:onInit()
	print("=======IceShimmerDetailPanel:onInit")
	self.rewards, _ENV = print, print
	self.fields.Text_get:setString(i18n("common_text_4458"))
	self.fields.Text_tip:setString(i18n("common_text_2486"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_go:setTitleText(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.onClickGo))
end
function IceShimmerDetailPanel:onItemRenderer(index, object)
	object:initData(self.rewards[index + 1])
end
function IceShimmerDetailPanel:onShow()
	print("=======IceShimmerDetailPanel:onShow")
	self:initData(self.param.data)
end
function IceShimmerDetailPanel:initData(data)
	self.data = data
	self.rewards = data.awardShow or shiftingstarsRead.getActRewardByIDClasstypeEX(data.activityID, data.classtype)
	self.activityID = data.activityID
	self.fields.Panel_bg:setString(i18n(activityTimeRead.getActivityNameByID(data.activityID, data.classtype)))
	self.fields.Text_timeLast:setString(string.gsub(SoraDConvertTimeToYear(data.beginTime), "-", "/") .. "-" .. string.gsub(SoraDConvertTimeToYear(data.endTime), "-", "/"))
	self.fields.Text_desc:setString(i18n(shiftingstarsRead.getActDescByIDEX(self.activityID)))
	self.fields.Label_banner:setIcon(shiftingstarsRead.getActBgByIDEX(data.activityID))
	if self.rewards and next(self.rewards) then
		self.fields.List_reward:setNumItems(table.nums(self.rewards))
		self.controllers.c2:setSelectedIndex(0)
	else
		self.controllers.c2:setSelectedIndex(1)
	end
	self:refreshView()
end
function IceShimmerDetailPanel:refreshView()
	local open = clientEventMgr.judgeIsOpen(self.activityID)
	self.controllers.c1:setSelectedIndex(open and 0 or 1)
end
function IceShimmerDetailPanel:onClickGo()
	SoraDPlaySound()
	if clientEventMgr.getEventInfoByeid(self.activityID) then
		clientEventMgr.singleClickEvent(self.activityID)
		self:close()
	end
end
return IceShimmerDetailPanel
