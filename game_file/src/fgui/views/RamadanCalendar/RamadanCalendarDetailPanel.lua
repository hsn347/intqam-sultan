local activityTimeRead = include("activityTimeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RamadanCalendarDetailPanel = class("RamadanCalendarDetailPanel", baseFguiPanel)
function RamadanCalendarDetailPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RamadanCalendarDetailPanel:ctor", self.viewName)
end
function RamadanCalendarDetailPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RamadanCalendarDetailPanel:onInit()
	print("=======RamadanCalendarDetailPanel:onInit")
	self.fields.Text_reward:setString(i18n("common_text_4458"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
	self.fields.Button_Go:setText(i18n("common_text_477"))
	self.fields.Button_Go:addClickListener(handler(self, self.onBtnGoClick))
end
function RamadanCalendarDetailPanel:onShow()
	print("=======RamadanCalendarDetailPanel:onShow")
	local data = self.param.data
	self.activityID = data.activityID
	local iconName = activityTimeRead.getActivityIconByID(data.activityID, data.classtype)
	self.fields.Com_name:setIcon(iconName)
	local activityNameStr = i18n(activityTimeRead.getActivityNameByID(data.activityID, data.classtype))
	self.fields.Com_name:setString(activityNameStr)
	self.fields.Text_Time:setString(os.date("!%Y/%m/%d %H:%M:%S-", data.beginTime) .. os.date("!%Y/%m/%d %H:%M:%S", data.endTime))
	if not activityTimeRead.getActivityConfigByID(data.activityID, data.classtype) then
		local _ENV, config = activityTimeRead.getActivityConfigByID(data.activityID, data.classtype), activityTimeRead.getActivityConfigByID(data.activityID, data.classtype)
	end
	local activity_desc = config.activity_desc
	if not activity_desc or activity_desc == "" then
		activity_desc = "calendar2021_text01"
	end
	self.fields.Text_Tips:setString(i18n(activity_desc))
	if not config.show_reward then
		_ENV = config.show_reward
	end
	self.rewardData = config.show_reward
	if next(self.rewardData) then
		self.fields.List_reward:setNumItems(#self.rewardData)
	else
		self.fields.Group_reward:setVisible(false)
	end
	if not clientEventMgr.getEventInfoByeid(data.activityID) or not clientEventMgr.judgeIsOpen(data.activityID) then
		self.fields.Button_Go:setVisible(false)
	else
		self.fields.Button_Go:setVisible(true)
	end
	local pos = self:globalToLocal(self.param.clickPos)
	local size = cc.size(440, 340)
	pos.x = math.max(pos.x, size.width / 2)
	pos.x = math.min(pos.x, self.view:getWidth() - size.width / 2)
	if pos.y > self.view:getHeight() / 2 then
		pos.y = pos.y - size.height
	end
	pos.x = pos.x - size.width / 2
	self.fields.n14:setPosition(pos.x, pos.y)
	self.fields.Com_name:fixChildrenPos()
end
function RamadanCalendarDetailPanel:onRewardItemRenderer(index, object)
	object:initData(self.rewardData[index + 1])
end
function RamadanCalendarDetailPanel:onBtnGoClick(button, event)
	SoraDPlaySound()
	clientEventMgr.singleClickEvent(self.activityID)
	self:closePanel()
end
return RamadanCalendarDetailPanel
