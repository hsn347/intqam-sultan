local activity_9001702_Read = include("activity_9001702_Read")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activity_9001702_Ctrl = SoraDGetCtrl("activity_9001702_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001702_MachinePanel = class("Activity_9001702_MachinePanel", baseFguiPanel)
function Activity_9001702_MachinePanel:ctor(...)
	self.isLRU = true
	Activity_9001702_MachinePanel.super.ctor(self, ...)
	print("Activity_9001702_MachinePanel:ctor", self.viewName)
end
function Activity_9001702_MachinePanel:onInit()
	print("=======Activity_9001702_MachinePanel:onInit")
	self.fields.Panel_bg:setString(i18n("Eidal_celebration_text_28"))
	self.fields.Button_more:setString(i18n("common_text_337"))
	self.fields.Button_more:addClickListener(handler(self, self.onClickMore))
	self.fields.Text_des2 = SoraDCreateTimerLabel(nil, self.fields.Text_des2)
	self.fields.Text_des2:setTimeLast(function(timeStr)
		_ENV = nil
		;(nil).time = timeStr
		return i18n("Eidal_celebration_text_30", nil)
	end)
	self.fields.Text_des2:setTimeEndListener(function()
		self:closePanel()
	end)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	if not SoraDFIsRA() then
		self.fields.Image_item:fixPos()
		self.fields.Text_des1:fixPos()
		self.fields.Button_more:fixPos()
	end
end
function Activity_9001702_MachinePanel:endShow()
	print("=======Activity_9001702_MachinePanel:endShow")
	local itemID = activity_9001702_Read.getDrawItemID()
	local itemCount = backpackCtrl:getItemCount(itemID)
	local count = activity_9001702_Ctrl:getTodayFirstPrizeCount()
	_ENV = nil
	;(nil).num = count
	self.fields.Text_des1:setString(i18n("Eidal_celebration_text_27", nil))
	local nextTime = serviceFunctions.getTomorrowZeroHourUTC()
	local remainTime = nextTime - serviceFunctions.systemTime()
	self.fields.Text_des2:beginTime(remainTime)
	self.rewardList = activity_9001702_Read.getDrawReward()
	self.fields.List:setNumItems(#self.rewardList)
end
function Activity_9001702_MachinePanel:onClickMore()
	SoraDPlaySound()
	self:closePanel()
	_ENV = self
	self.msg = "MESSAGE_ACTIVITY_9001702_UPDATE"
	self.subMsg = "showFinger"
	SoraDSendMessage(self)
end
function Activity_9001702_MachinePanel:onItemRenderer(index, obj)
	local data = self.rewardList[index + 1]
	obj:initData(data.id, data.count)
end
return Activity_9001702_MachinePanel
