local activity_9001721_Read = include("activity_9001721_Read")
local activity_9001721_Ctrl = SoraDGetCtrl("activity_9001721_Ctrl")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001721_TaskPanel = class("Activity_9001721_TaskPanel", baseFguiPanel)
function Activity_9001721_TaskPanel:ctor(...)
	self.isLRU = true
	Activity_9001721_TaskPanel.super.ctor(self, ...)
	print("Activity_9001721_TaskPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.CAPTURE_MONKEY_ACTIVITY
end
function Activity_9001721_TaskPanel:onInit()
	print("=======Activity_9001721_TaskPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
end
function Activity_9001721_TaskPanel:itemRenderer_List(index, obj)
	obj:initData(self.ListData[index + 1])
end
function Activity_9001721_TaskPanel:endShow()
	print("=======Activity_9001721_TaskPanel:endShow")
	self.tag = 1
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("eid_fireworks_010")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("eid_fireworks_011")
	;(nil).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	;(nil).callback = handler(self, self.onClickTab)
	self.fields.com_Tab:initView(nil)
end
function Activity_9001721_TaskPanel:onClickTab(tag)
	self.tag = tag
	self:initView()
end
function Activity_9001721_TaskPanel:initView(target, data)
	SoraDCloseLoading(self)
	self.ListData = activityTaskComponentCtrl:getTaskList(self.activityID, activity_9001721_Read.getTaskCfg(self.tag))
	self.fields.List:setNumItems(#self.ListData)
	local num1, num2 = activity_9001721_Ctrl:getTaskReceiveNum()
	self.fields.com_Tab:setBtnRedDot(1, 0 < num1, num1)
	self.fields.com_Tab:setBtnRedDot(2, 0 < num2, num2)
end
return Activity_9001721_TaskPanel
