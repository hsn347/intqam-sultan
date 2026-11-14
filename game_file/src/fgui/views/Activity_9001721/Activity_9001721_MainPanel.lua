local activity_9001721_Read = include("activity_9001721_Read")
local activity_9001721_Ctrl = SoraDGetCtrl("activity_9001721_Ctrl")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001721_MainPanel = class("Activity_9001721_MainPanel", baseFguiPanel)
function Activity_9001721_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001721_MainPanel.super.ctor(self, ...)
	print("Activity_9001721_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.CAPTURE_MONKEY_ACTIVITY
	self.itemID = activity_9001721_Read.getItemID()
	self.itemCount = activity_9001721_Read.getItemCount()
end
function Activity_9001721_MainPanel:onInit()
	print("=======Activity_9001721_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Label_title:setString(i18n("worldboss_monkey_05"))
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Button_trace:setTitle(i18n("worldboss_monkey_02"))
	self.fields.Button_trace:addClickListener(handler(self, self.onClick_Button_trace))
	self.fields.Button_shop:setTitle(i18n("worldboss_monkey_03"))
	self.fields.Button_shop:addClickListener(handler(self, self.onClick_Button_shop))
	self.fields.Button_go:setTitle(i18n("worldboss_monkey_04"))
	self.fields.Button_go:addClickListener(handler(self, self.onClick_Button_go))
end
function Activity_9001721_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("worldboss_monkey_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001721_MainPanel:endShow()
	print("=======Activity_9001721_MainPanel:endShow")
	self.ListData = activity_9001721_Read.getVictoryRewards()
	self.fields.List:setNumItems(#self.ListData)
	self.fields.Com_have:initData(self.itemID, handler(self, self.onClick_Button_trace))
	self.fields.Button_go:setCostIcon(self.itemID)
	self.fields.Button_go:setCostNum(self.itemCount)
	self:initView()
end
function Activity_9001721_MainPanel:initView(target, data)
	SoraDCloseLoading(self)
	self.point = activity_9001721_Ctrl:getPoint()
	self.fields.Com_have:updateNum(self.point)
	self.fields.Button_go:setIsEnough(self.point >= self.itemCount)
	self:updateRedPoint()
end
function Activity_9001721_MainPanel:updateRedPoint()
	local num1, num2 = activity_9001721_Ctrl:getTaskReceiveNum()
	self.fields.Button_trace:setReddot(0 < num1 + num2, num1 + num2)
	local ret = activityExchangeMallCtrl:getReceiveStatusAndNum(self.activityID)
	self.fields.Button_shop:setReddot(ret, -1)
end
function Activity_9001721_MainPanel:itemRenderer_List(index, obj)
	local data = self.ListData[index + 1]
	obj:initData(data.id, data.count)
end
function Activity_9001721_MainPanel:onClick_Button_trace()
	SoraDPlaySound()
	uiManager:show("Activity_9001721_Task")
end
function Activity_9001721_MainPanel:onClick_Button_shop()
	SoraDPlaySound()
	uiManager:show("Activity_9001721_Shop")
end
function Activity_9001721_MainPanel:onClick_Button_go()
	SoraDPlaySound()
	local isAlive = activity_9001721_Ctrl:isBossAlive()
	if isAlive then
		local pos = activity_9001721_Ctrl:getBossPos()
		SoraDGotoWorldMapPoint(include("mapSyncUtilClient").serverTOClientPos(pos), true)
		SoraDRemoveAllPanelFromManager()
	else
		if self.point < self.itemCount then
			SoraDShowMsgTip(i18n("worldboss_monkey_06"))
			return
		end
		if lordInfoCtrl:getSourceKid() > 0 then
			SoraDShowMsgTip(i18n("worldboss_monkey_19"))
			return
		end
		activity_9001721_Ctrl:reqCaptureMonkeyCreate()
	end
end
return Activity_9001721_MainPanel
