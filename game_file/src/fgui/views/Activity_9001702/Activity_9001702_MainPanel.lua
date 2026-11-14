local activity_9001702_Read = include("activity_9001702_Read")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activity_9001702_Ctrl = SoraDGetCtrl("activity_9001702_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001702_MainPanel = class("Activity_9001702_MainPanel", baseFguiPanel)
function Activity_9001702_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001702_MainPanel.super.ctor(self, ...)
	print("Activity_9001702_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001702
end
function Activity_9001702_MainPanel:onInit()
	print("=======Activity_9001702_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
end
function Activity_9001702_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Eidal_celebration_text_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001702_MainPanel:endShow()
	print("=======Activity_9001702_MainPanel:endShow")
	local isStage0 = activity_9001702_Ctrl:checkDoStage0()
	local _ENV, defaultClick = nil, isStage0 and 1 or 2
	_ENV, _ENV, (nil).defaultClick = nil, nil, defaultClick
	;(nil).title = i18n("Eidal_celebration_text_02")
	_ENV, (nil)[1], (nil).isEnabled = nil, nil, isStage0
	;(nil).tabsetArray, (nil)[2], (nil).title = nil, nil, i18n("Eidal_celebration_text_03")
	local (nil).callback, param = handler(self, self.onClickTab), nil
	self.fields.Com_title:initTab(param)
	self:updateBtnRed()
	self.fields.Com_page2:updateDoStage()
end
function Activity_9001702_MainPanel:onClickTab(tag)
	print("==Activity_9001702_MainPanel:onClickTab==", tag)
	self.curTag = tag
	self.controllers.viewType:setSelectedIndex(tag - 1)
	if tag == 1 then
		self.fields.Com_page1:switchTab()
	else
		self.fields.Com_page2:switchTab()
	end
end
function Activity_9001702_MainPanel:updateBtnRed()
	local ret, retNum = activity_9001702_Ctrl:getPage1RedNum()
	self.fields.Com_title:setBtnRedDot(1, ret, retNum)
	local ret, retNum = activity_9001702_Ctrl:getPage2RedNum()
	self.fields.Com_title:setBtnRedDot(2, ret, retNum)
end
function Activity_9001702_MainPanel:onMsgUpdate(target, event)
	_UPVALUE0_ = nil
	;(nil).itemCount = true
	;(nil).init = true
	local (nil).receive, config = true, nil
	local subMsg = event.subMsg
	if config[subMsg] then
		self:updateBtnRed()
	end
end
function Activity_9001702_MainPanel:updateActivityHandler()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
		return
	end
	self:updateDoStage()
end
function Activity_9001702_MainPanel:updateDoStage(...)
	local doStage = activityShowCtrl:getDoStageByID(self.activityID)
	if self.doStage == doStage then
		return
	end
	self.doStage = doStage
	if doStage ~= 0 then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return Activity_9001702_MainPanel
