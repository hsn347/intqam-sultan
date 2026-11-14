local activity_9001493_Ctrl = SoraDGetCtrl("activity_9001493_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001493_mainPanel = class("Activity_9001493_mainPanel", baseFguiPanel)
function Activity_9001493_mainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001493_mainPanel:ctor", self.viewName)
end
function Activity_9001493_mainPanel:onInit()
	print("=======Activity_9001493_mainPanel:onInit")
	self.activityID = gActivityTimeActivityID.GIVE_GIFTS_ACTIVITY
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose))
	local itemID = activity_9001493_Ctrl:getItemID()
	local publicRead = include("publicRead")
	self.fields.Com_gift:setIcon(publicRead.getIcon(itemID))
	self.fields.Text_tip:setString(i18n("ramadan_friends_01"))
	self.fields.Button_send:setString(i18n("common_text_3644"))
	self.fields.Button_send:addClickListener(handler(self, self.onClickBtnSend))
end
function Activity_9001493_mainPanel:onShow()
	print("=======Activity_9001493_mainPanel:onShow")
	self:updateItemCount()
end
function Activity_9001493_mainPanel:updateItemCount(...)
	local itemCount = activity_9001493_Ctrl:getItemCount()
	self.fields.Com_gift:setString(itemCount)
end
function Activity_9001493_mainPanel:onClickBtnSend(...)
	SoraDPlaySound()
	if activity_9001493_Ctrl:checkItemCount() then
		_ENV = nil
		;(nil).activityID = self.activityID
		uiManager:show("Activity_9001493_friend", nil)
	end
end
return Activity_9001493_mainPanel
