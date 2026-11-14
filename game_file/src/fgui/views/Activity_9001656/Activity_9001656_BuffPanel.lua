local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001656_BuffPanel = class("Activity_9001656_BuffPanel", baseFguiPanel)
local activity_9001656_Read = include("activity_9001656_Read")
function Activity_9001656_BuffPanel:ctor(...)
	Activity_9001656_BuffPanel.super.ctor(self, ...)
	print("Activity_9001656_BuffPanel:ctor", self.viewName)
end
function Activity_9001656_BuffPanel:onInit()
	print("=======Activity_9001656_BuffPanel:onInit")
	self.activityID = self.param and self.param.activityID or gActivityTimeActivityID.WAR_ORDER_ACTIVITY
	self:fixChildrenPos()
	self.fields.Panel_bg:setString(i18n("Battle_Towers_23"))
	_UPVALUE9_ = self.fields.Panel_bg
	self.fields.Panel_bg[1] = "Text_1"
	self.fields.Panel_bg[2] = "Text_2"
	self.fields.Panel_bg[3] = "Text_3"
	self.fields.Panel_bg[4] = "Text_4"
	self.fields.Panel_bg[5] = "Text_5"
	self.fields.Panel_bg[6] = "line1"
	self.fields.Panel_bg[7] = "line2"
	self.fields.Panel_bg[8] = "line3"
	self.fields.Panel_bg[9] = "line4"
	for index, value in ipairs(self.fields.Panel_bg) do
		if self.fields[value] then
			self.fields[value]:fixPos()
		end
	end
	local buffNeedLv = activity_9001656_Read.getBuffNeedLv()
	self.fields.Text_1:setString(i18n("Braque_text_10"))
	self.fields.Text_2:setString(i18n("Braque_text_11"))
	self.fields.Text_4:setString(i18n("common_text_1961"))
	self.fields.Text_5:setString(i18n("common_text_748"))
	_ENV = i18n("common_text_748")
	i18n("common_text_748").lv = buffNeedLv
	self.fields.Text_Tips:setString(i18n("ramadan_bless_text_02", i18n("common_text_748")))
	self.fields.Scroll_Buff:setItemRenderer(handler(self, self.onItemRenderer))
end
function Activity_9001656_BuffPanel:onShow()
	print("=======Activity_9001656_BuffPanel:onShow")
	_UPVALUE3_ = print
	self.buffTypeList, print[1] = print, BUILD_ENUM.CASTLE_STAR
	self.buffTypeList, print[2] = print, BUILD_ENUM.GLORIOUS_STATUE
	self.buffTypeList, print[3] = print, BUILD_ENUM.MAGIC_LAMP
	self.fields.Scroll_Buff:setNumItems(#self.buffTypeList)
end
function Activity_9001656_BuffPanel:onItemRenderer(index, target)
	target:initData(self.buffTypeList[index + 1], self.activityID)
end
return Activity_9001656_BuffPanel
