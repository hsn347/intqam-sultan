local anniversaryRead = include("anniversaryRead")
local activityTimeRead = include("activityTimeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001690_DetailPanel = class("Activity_9001690_DetailPanel", baseFguiPanel)
function Activity_9001690_DetailPanel:ctor(...)
	self.isLRU = true
	Activity_9001690_DetailPanel.super.ctor(self, ...)
	print("Activity_9001690_DetailPanel:ctor", self.viewName)
end
function Activity_9001690_DetailPanel:onInit()
	print("=======Activity_9001690_DetailPanel:onInit")
	self.fields.Text_get:setString(i18n("common_text_4458"))
	self.fields.Text_tip:setString(i18n("common_text_2486"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.onClickGo))
end
function Activity_9001690_DetailPanel:onItemRenderer(index, object)
	object:initData(self.rewards[index + 1])
end
function Activity_9001690_DetailPanel:endShow()
	print("=======Activity_9001690_DetailPanel:endShow")
	self.data = self.param.data
	self:initData()
end
function Activity_9001690_DetailPanel:initData()
	self.rewards = self.data.awardShow or anniversaryRead.getActRewardByIDClasstypeEX(self.data.activityID, self.data.classtype, gActivityTimeActivityID.CALENDAR_9001690_ACTIVITY)
	self.activityID = self.data.activityID
	self.fields.Panel_bg:setString(i18n(activityTimeRead.getActivityNameByID(self.data.activityID, self.data.classtype)))
	self.fields.Text_timeLast:setString(string.gsub(SoraDConvertTimeToYear(self.data.beginTime), "-", "/") .. "-" .. string.gsub(SoraDConvertTimeToYear(self.data.endTime), "-", "/"))
	self.fields.Text_desc:setString(i18n(anniversaryRead.getActDescByIDEX(self.activityID, gActivityTimeActivityID.CALENDAR_9001690_ACTIVITY)))
	self.fields.Label_banner:setIcon(activityTimeRead.getActivityBgByID(self.data.activityID, self.data.classtype))
	if self.rewards and next(self.rewards) then
		self.fields.List_reward:setNumItems(table.nums(self.rewards))
		self.controllers.c2:setSelectedIndex(0)
	else
		self.controllers.c2:setSelectedIndex(1)
	end
	self:refreshView()
end
function Activity_9001690_DetailPanel:refreshView()
	local open = clientEventMgr.judgeIsOpen(self.activityID)
	self.controllers.c1:setSelectedIndex(open and 0 or 1)
end
function Activity_9001690_DetailPanel:onClickGo()
	SoraDPlaySound()
	if clientEventMgr.judgeIsOpen(self.activityID) then
		clientEventMgr.singleClickEvent(self.activityID)
		self:close()
	end
end
return Activity_9001690_DetailPanel
