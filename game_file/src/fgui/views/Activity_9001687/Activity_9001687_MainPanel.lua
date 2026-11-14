local Activity_9001623_MainPanel = include_fgui("Activity_9001623_MainPanel")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001687_MainPanel = class("Activity_9001687_MainPanel", Activity_9001623_MainPanel)
local publicUtil = include("publicUtil")
local activityTimeRead = include("activityTimeRead")
local publicRead = include("publicRead")
local activityCommonSignCtrl = SoraDGetCtrl("activityCommonSignCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
function Activity_9001687_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001687_MainPanel.super.ctor(self, ...)
	self.activityID = gActivityTimeActivityID.SIGN_REWARD_9001687_ACTIVITY
	print("Activity_9001687_MainPanel:ctor", self.viewName)
end
function Activity_9001687_MainPanel:onInit()
	print("=======Activity_9001687_MainPanel:onInit")
	Activity_9001687_MainPanel.super.onInit(self)
	self.itemID = 874701
	self.jumpActivityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001676
	self.fields.Button_item:setTitle(publicRead.getName(self.itemID))
	self.fields.Button_item:addClickEventListener(handler(self, self.onItemClick))
	self.fields.Button_activity:addClickEventListener(handler(self, self.onActivityClick))
end
function Activity_9001687_MainPanel:onItemClick()
	SoraDPlaySound()
	local itemCount = publicUtil.getCount(self.itemID)
	if 0 < itemCount then
		_ENV = nil
		;(nil).goodId = self.itemID
		uiManager:show("Activity_9001687_Share", nil)
	else
		_ENV = nil
		;(nil).name = publicRead.getName(self.itemID)
		SoraDShowMsgTip(i18n("Frosty_Carnival_text_02", nil))
	end
end
function Activity_9001687_MainPanel:onActivityClick()
	SoraDPlaySound()
	clientEventMgr.singleClickEvent(self.jumpActivityID)
	if activityShowCtrl:isActivityOpen(self.jumpActivityID) then
		self:close()
	end
end
function Activity_9001687_MainPanel:endShow()
	print("=======Activity_9001687_MainPanel:endShow")
	self:updateView()
end
function Activity_9001687_MainPanel:updateView()
	local curDay = activityCommonSignCtrl:getCurDay(self.activityID)
	self.jumpActivityID = curDay <= 7 and gActivityTimeActivityID.NORMAL_ACTIVITY_9001676 or gActivityTimeActivityID.NORMAL_ACTIVITY_9001666
	self.fields.Button_activity:setTitle(i18n(activityTimeRead.getActivityNameByID(self.jumpActivityID)))
	self:updateItem()
end
function Activity_9001687_MainPanel:updateItem()
	local itemCount = publicUtil.getCount(self.itemID)
	self.fields.Button_item:setReddot(0 < itemCount, itemCount)
end
return Activity_9001687_MainPanel
