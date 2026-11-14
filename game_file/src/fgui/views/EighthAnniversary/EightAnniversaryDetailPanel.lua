local activityCenterUICtrl = SoraDGetCtrl("activityCenterUICtrl")
local anniversaryRead = include("anniversaryRead")
local activityTimeRead = include("activityTimeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local EightAnniversaryDetailPanel = class("EightAnniversaryDetailPanel", baseFguiPanel)
function EightAnniversaryDetailPanel:ctor(...)
	self.super.ctor(self, ...)
	print("EightAnniversaryDetailPanel:ctor", self.viewName)
end
function EightAnniversaryDetailPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function EightAnniversaryDetailPanel:onInit()
	print("=======EightAnniversaryDetailPanel:onInit")
	self.fields.Text_get:setString(i18n("common_text_4458"))
	self.fields.Text_tip:setString(i18n("common_text_2486"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.onClickGo))
end
function EightAnniversaryDetailPanel:initData(data)
	self.data = data
	self.rewards = data.awardShow or anniversaryRead.getActRewardByIDClasstype(data.activityID, data.classtype)
	self.activityID = data.activityID
	self.fields.Panel_bg:setString(i18n(activityTimeRead.getActivityNameByID(data.activityID, data.classtype)))
	self.fields.Text_timeLast:setString(string.gsub(SoraDConvertTimeToYear(data.beginTime), "-", "/") .. "-" .. string.gsub(SoraDConvertTimeToYear(data.endTime), "-", "/"))
	self.fields.Text_desc:setString(i18n(anniversaryRead.getActDescByID(self.activityID)))
	self.fields.Label_banner:setIcon(anniversaryRead.getActBgByID(data.activityID))
	if self.rewards and next(self.rewards) then
		self.fields.List_reward:setNumItems(table.nums(self.rewards))
		self.controllers.c2:setSelectedIndex(0)
	else
		self.controllers.c2:setSelectedIndex(1)
	end
	self:refreshView()
end
function EightAnniversaryDetailPanel:refreshView()
	local open = clientEventMgr.judgeIsOpen(self.activityID)
	self.controllers.c1:setSelectedIndex(open and 0 or 1)
end
function EightAnniversaryDetailPanel:onItemRenderer(index, object)
	object:initData(self.rewards[index + 1])
end
function EightAnniversaryDetailPanel:onClickGo()
	SoraDPlaySound()
	if clientEventMgr.judgeIsOpen(self.activityID) then
		clientEventMgr.singleClickEvent(self.activityID)
		self:close()
	end
end
function EightAnniversaryDetailPanel:onShow()
	print("=======EightAnniversaryDetailPanel:onShow")
	self:initData(self.proxy.param)
end
return EightAnniversaryDetailPanel
