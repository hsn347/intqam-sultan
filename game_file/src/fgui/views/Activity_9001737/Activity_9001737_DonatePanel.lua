local activity_9001737_Read = include("activity_9001737_Read")
local activity_9001737_Ctrl = SoraDGetCtrl("activity_9001737_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001737_DonatePanel = class("Activity_9001737_DonatePanel", baseFguiPanel)
function Activity_9001737_DonatePanel:ctor(...)
	self.isLRU = true
	Activity_9001737_DonatePanel.super.ctor(self, ...)
	print("Activity_9001737_DonatePanel:ctor", self.viewName)
end
function Activity_9001737_DonatePanel:onInit()
	print("=======Activity_9001737_DonatePanel:onInit")
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Panel_bg:setString(i18n("troublemaker_text_12"))
	self.fields.Text_rank:setString(i18n("common_text_2193"))
	self.fields.Text_name:setString(i18n("common_text_264"))
	self.fields.Text_donate:setString(i18n("troublemaker_text_13"))
	self.fields.Text_noData:setString(i18n("fishingmaster_text_07"))
	self.fields.Text_noData:setVisible(false)
	self.fields.Text_rank:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_donate:fixPos()
end
function Activity_9001737_DonatePanel:endShow()
	print("=======Activity_9001737_DonatePanel:endShow")
	self.campId = self.param and self.param.campId or activity_9001737_Ctrl:getMyCamp()
	activity_9001737_Ctrl:reqMemberRanklist(self.campId)
end
function Activity_9001737_DonatePanel:initView(target, data)
	self.myInfo = data.myInfo
	self.rankList = data.rankList
	self.fields.List:setNumItems(#self.rankList)
	self.fields.Text_noData:setVisible(#self.rankList == 0)
	if self.campId == activity_9001737_Ctrl:getMyCamp() then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Com_rankBase:initData(self.myInfo, self.myInfo.rank, true)
	else
		self.controllers.c1:setSelectedIndex(1)
	end
end
function Activity_9001737_DonatePanel:itemRenderer_List(index, obj)
	local data = self.rankList[index + 1]
	obj:initData(data, index + 1)
end
return Activity_9001737_DonatePanel
