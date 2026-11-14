local activity_9001738_Read = include("activity_9001738_Read")
local activity_9001738_Ctrl = SoraDGetCtrl("activity_9001738_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001738_ViewPanel = class("Activity_9001738_ViewPanel", baseFguiPanel)
local CTRL_TYPE_LEVEL_SELECT = 0
local CTRL_TYPE_BATTLEPASS = 1
function Activity_9001738_ViewPanel:ctor(...)
	self.isLRU = true
	Activity_9001738_ViewPanel.super.ctor(self, ...)
	print("Activity_9001738_ViewPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY
end
function Activity_9001738_ViewPanel:onInit()
	print("=======Activity_9001738_ViewPanel:onInit")
	self:fixChildrenPos()
	self.fields.comTitle:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.tag = 1
	_ENV = self.activityID
	_ENV, _ENV, self.activityID.defaultClick = handler(self, self.onClickHelp)
	handler(self, self.onClickHelp).title = i18n("memory_flip_text_03")
	_ENV, self.tag[1], handler(self, self.onClickHelp).tag = handler(self, self.onClickHelp)
	handler(self, self.onClickHelp).title = i18n("memory_flip_text_02")
	self.activityID.tabsetArray, self.tag[2], handler(self, self.onClickHelp).tag = self.tag, handler(self, self.onClickHelp)
	self.activityID.callback = handler(self, self.onTabClick)
	self.fields.comTitle:initTab(self.activityID)
	self.fields.btnRank:setTitle(i18n("common_text_851"))
	self.fields.btnRank:addClickListener(handler(self, self.onClick_btnRank))
	self.fields.btnPackage:setTitle(i18n("snow_competition_text_11"))
	self.fields.btnPackage:addClickListener(handler(self, self.onClick_btnPackage))
	self.fields.btnRewardPrev:setTitle(i18n("devilvalley_text_27"))
	self.fields.btnRewardPrev:addClickListener(handler(self, self.onClick_btnRewardPrev))
	self.fields.btnRewardPrev:fixPos()
	self.fields.btnRank:fixPos()
	self.fields.btnPackage:fixPos()
end
function Activity_9001738_ViewPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("memory_flip_text_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001738_ViewPanel:endShow()
	print("=======Activity_9001738_ViewPanel:endShow")
	self.tag = 1
	activity_9001738_Ctrl:sendReqInitDataMsg()
	self:refreshBattlePass()
	self.fields.comTitle:setTabIndex(self.tag, true)
	self:initLevelSelect()
	self:updateReddot()
end
function Activity_9001738_ViewPanel:onTabClick(tag)
	self.tag = tag
	if tag == 1 then
		self:showLevelSelect()
	else
		self:showBattlePass()
	end
	self:updateReddot()
end
function Activity_9001738_ViewPanel:showLevelSelect()
	self.controllers.ctrlType:setSelectedIndex(CTRL_TYPE_LEVEL_SELECT)
	self:initLevelSelect()
end
function Activity_9001738_ViewPanel:initLevelSelect()
	self.fields.levelSelect:initData(self.activityID)
end
function Activity_9001738_ViewPanel:showBattlePass()
	self.controllers.ctrlType:setSelectedIndex(CTRL_TYPE_BATTLEPASS)
	self:refreshBattlePass()
end
function Activity_9001738_ViewPanel:refreshBattlePass()
	self.fields.n18:initData(self.activityID)
end
function Activity_9001738_ViewPanel:updateView()
	self:refreshBattlePass()
	if self.tag == 1 then
		self:showLevelSelect()
	else
		self:showBattlePass()
	end
	self:updateReddot()
end
function Activity_9001738_ViewPanel:updateReddot()
	self.fields.comTitle:setBtnRedDot(2, activity_9001738_Ctrl:getBattlePassCanReceiveNum() > 0)
end
function Activity_9001738_ViewPanel:onClick_btnRank(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001738_Rank")
end
function Activity_9001738_ViewPanel:onClick_btnPackage(context)
	SoraDPlaySound()
	if activity_9001738_Ctrl:isDailyGiftSoldOut() then
		SoraDShowMsgTip(i18n("snow_competition_text_02"))
		return
	end
	uiManager:show("Activity_9001738_Package")
end
function Activity_9001738_ViewPanel:onClick_btnRewardPrev(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001738_RewardPrev")
end
return Activity_9001738_ViewPanel
