local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001496_MainPanel = class("Activity_9001496_MainPanel", baseFguiPanel)
function Activity_9001496_MainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001496_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.BUILD_THRIVING_ACTIVITY
	self.tabIndex = 0
end
function Activity_9001496_MainPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "StarsTower"
	end
	return self._packageList
end
function Activity_9001496_MainPanel:onInit()
	print("=======Activity_9001496_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	_ENV = self.fields.Com_title.initActivityData
	_ENV, _ENV, self.fields.Com_title.initActivityData.defaultClick = self.activityID, self.fields.Com_title, 1
	_ENV, self.fields.Com_title[1], self.activityID.title = self.activityID, self.activityID, i18n("build_thriving_10")
	self.fields.Com_title.initActivityData.tabsetArray, self.fields.Com_title[2], self.activityID.title = self.fields.Com_title, self.activityID, i18n("return_title_08")
	local self.fields.Com_title.initActivityData.callback, param = handler(self, self.onClickTab), self.fields.Com_title.initActivityData
	self.fields.com_Tab:initView(param)
end
function Activity_9001496_MainPanel:onShow()
	print("=======Activity_9001496_MainPanel:onShow")
end
function Activity_9001496_MainPanel:onClickHelp()
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("build_thriving_1"))
end
function Activity_9001496_MainPanel:onClickTab(tag)
	print("==Activity_9001496_MainPanel:onClickTab==", tag)
	if self.tabIndex == tag then
		return
	end
	self.tabIndex = tag
	self.controllers.c1:setSelectedIndex(self.tabIndex - 1)
	if self.tabIndex == 1 then
		self.fields.Com_MainTask:showTask()
	else
		self.fields.Com_MainGift:showGift()
	end
end
function Activity_9001496_MainPanel:updateTaskList(...)
	self.fields.Com_MainTask:updateTaskList(...)
end
function Activity_9001496_MainPanel:onMsgUpdateRechargePrice(...)
	self.fields.Com_MainTask:onMsgUpdateRechargePrice(...)
end
function Activity_9001496_MainPanel:updateGift(...)
	self.fields.Com_MainGift:showGift()
end
function Activity_9001496_MainPanel:onMsgJumpToGift(...)
	self.fields.com_Tab:setTabIndex(2, true)
end
return Activity_9001496_MainPanel
