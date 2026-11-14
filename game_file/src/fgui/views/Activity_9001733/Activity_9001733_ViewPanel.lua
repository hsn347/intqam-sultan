local activity_9001733_Read = include("activity_9001733_Read")
local activity_9001733_Ctrl = SoraDGetCtrl("activity_9001733_Ctrl")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001733_ViewPanel = class("Activity_9001733_ViewPanel", baseFguiPanel)
local FLIP_PANEL_NAME = "Activity_9001733_Flip"
local CTRL_TYPE_FACTORY = 0
local CTRL_TYPE_GAME = 1
local CTRL_TYPE_BATTLEPASS = 2
local REWARD_PREV_PANEL_NAME = "Activity_9001733_RewardPrev"
local TAB_FACTORY = 1
local TAB_GAME = 2
local TAB_BATTLEPASS = 3
local INIT_LOADING_MARK = gCmd.REQ_FOOTBALL_TREASURE_INIT
function Activity_9001733_ViewPanel:ctor(...)
	self.isLRU = true
	Activity_9001733_ViewPanel.super.ctor(self, ...)
	print("Activity_9001733_ViewPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.FOOTBALL_TREASURE_ACTIVITY
end
function Activity_9001733_ViewPanel:getPackageList()
	_UPVALUE1_ = nil
	;(nil)[1] = "Activity_9001738"
	return nil
end
function Activity_9001733_ViewPanel:onInit()
	print("=======Activity_9001733_ViewPanel:onInit")
	self:fixChildrenPos()
	self.fields.Com_bg:setGradientColor()
	self.fields.comTitle:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	_ENV = handler(self, self.onClickHelp)
	handler(self, self.onClickHelp).time = ""
	self.fields.comTitle:initSpecialActivityTimeNew(self.activityID, i18n("common_text_4481", handler(self, self.onClickHelp)))
	self.tag = TAB_FACTORY
	_ENV = self.activityID
	_ENV, _ENV, self.activityID.defaultClick = i18n("common_text_4481", handler(self, self.onClickHelp))
	i18n("common_text_4481", handler(self, self.onClickHelp)).title = i18n("football_treasure_text_001")
	_ENV, self.tag[1], i18n("common_text_4481", handler(self, self.onClickHelp)).tag = i18n("common_text_4481", handler(self, self.onClickHelp))
	i18n("common_text_4481", handler(self, self.onClickHelp)).title = i18n("football_treasure_text_002")
	_ENV, self.tag[2], i18n("common_text_4481", handler(self, self.onClickHelp)).tag = i18n("common_text_4481", handler(self, self.onClickHelp))
	i18n("common_text_4481", handler(self, self.onClickHelp)).title = i18n("football_treasure_text_003")
	self.activityID.tabsetArray, self.tag[3], i18n("common_text_4481", handler(self, self.onClickHelp)).tag = self.tag, i18n("common_text_4481", handler(self, self.onClickHelp))
	self.activityID.callback = handler(self, self.onTabClick)
	self.activityID.unDefaultClick = true
	self.fields.comTitle:initTab(self.activityID)
	self.fields.btnBall:setString(i18n("football_treasure_text_001"))
	self.fields.btnRewardPrev:setString(i18n("football_treasure_text_017"))
	self.fields.btnTask:setString(i18n("balloon_hunter_003"))
	self.fields.btnTask:addClickListener(handler(self, self.onClick_btnTask))
	self.fields.btnBall:addClickListener(handler(self, self.onClick_btnBall))
	self.fields.btnRewardPrev:addClickListener(handler(self, self.onClick_btnRewardPrev))
	self:updateRewardPrevState()
	self.fields.btnBall:fixPos()
	self.fields.btnRewardPrev:fixPos()
	self.fields.btnTask:fixPos()
end
function Activity_9001733_ViewPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("football_treasure_text_004")
	uiManager:show("RuleView", nil)
end
function Activity_9001733_ViewPanel:endShow()
	print("=======Activity_9001733_ViewPanel:endShow")
	self.tag = self:getDefaultTabTag()
	self.isWaitingInitData = true
	SoraDShowLoading(self, nil, INIT_LOADING_MARK)
	self.fields.comTitle:setTabIndex(self.tag, true)
	activity_9001733_Ctrl:sendReqInitDataMsg()
end
function Activity_9001733_ViewPanel:getDefaultTabTag()
	if not self.param then
		local TAB_BATTLEPASS, param = self.param, self.param
	end
	local defaultTab = param.defaultTab or param.tab or param.tag
	if param.jumpToBattlePass or defaultTab == TAB_BATTLEPASS or defaultTab == "battlepass" then
		return TAB_BATTLEPASS
	end
	if param.jumpToGame or defaultTab == TAB_GAME or defaultTab == "game" then
		return TAB_GAME
	end
	return TAB_FACTORY
end
function Activity_9001733_ViewPanel:onTabClick(tag)
	self.tag = tag
	self:updateTypeController(tag)
	if self.isWaitingInitData then
		return
	end
	if tag == TAB_BATTLEPASS then
		self:showBattlePass()
	elseif tag == TAB_GAME then
		self:showGame()
	else
		self:showFactory()
	end
	self:refreshEntryButtons()
end
function Activity_9001733_ViewPanel:updateTypeController(tag)
	local ctrlType = CTRL_TYPE_FACTORY
	if tag == TAB_BATTLEPASS then
		ctrlType = CTRL_TYPE_BATTLEPASS
	elseif tag == TAB_GAME then
		ctrlType = CTRL_TYPE_GAME
	end
	self.controllers.ctrlType:setSelectedIndex(ctrlType)
end
function Activity_9001733_ViewPanel:showFactory(updateData)
	self.fields.factory:initData(self.activityID, updateData)
end
function Activity_9001733_ViewPanel:showGame(updateData)
	self:refreshGame(updateData)
end
function Activity_9001733_ViewPanel:showBattlePass(updateData)
	self:refreshBattlePass(updateData)
end
function Activity_9001733_ViewPanel:refreshGame(updateData)
	self.fields.game:initData(self.activityID, updateData)
	self:updateRewardPrevState()
	return self
end
function Activity_9001733_ViewPanel:refreshBattlePass(updateData)
	self.fields.pass:initData(self.activityID, updateData)
end
function Activity_9001733_ViewPanel:jumpToFactory()
	self.fields.comTitle:setTabIndex(TAB_FACTORY, true)
end
function Activity_9001733_ViewPanel:jumpToGame()
	self.fields.comTitle:setTabIndex(TAB_GAME, true)
end
function Activity_9001733_ViewPanel:jumpToBattlePass()
	self.fields.comTitle:setTabIndex(TAB_BATTLEPASS, true)
end
function Activity_9001733_ViewPanel:updateRewardPrevState()
	self.fields.btnRewardPrev:setEnabled(true)
	self.fields.btnRewardPrev:setReddot(false, 0)
end
function Activity_9001733_ViewPanel:refreshEntryButtons()
	local taskNum = activity_9001733_Ctrl:getTaskRewardNum()
	local factoryTabNum = activity_9001733_Ctrl:getFactoryTabRedNum()
	local factoryBallEntryNum = activity_9001733_Ctrl:getFactoryBallEntryRedNum()
	local gameTabNum = activity_9001733_Ctrl:getShootCanUseNum()
	local battlePassNum = activity_9001733_Ctrl:getBattlePassCanReceiveNum()
	self.fields.btnTask:setReddot(0 < taskNum, taskNum)
	self.fields.btnBall:setReddot(0 < factoryBallEntryNum, factoryBallEntryNum)
	self.fields.comTitle:setBtnRedDot(1, 0 < factoryTabNum, factoryTabNum)
	self.fields.comTitle:setBtnRedDot(2, 0 < gameTabNum, -1)
	self.fields.comTitle:setBtnRedDot(3, 0 < battlePassNum, battlePassNum)
	self:updateRewardPrevState()
end
function Activity_9001733_ViewPanel:updateTask()
	self:refreshEntryButtons()
end
function Activity_9001733_ViewPanel:updatRed()
	self:refreshEntryButtons()
end
function Activity_9001733_ViewPanel:updateView(updateData)
	if self.isWaitingInitData then
		if not updateData or updateData.subMsg ~= "init" then
			return
		end
		self.isWaitingInitData = false
		SoraDCloseLoading(self, INIT_LOADING_MARK)
	end
	if self.tag == TAB_BATTLEPASS then
		self:showBattlePass(updateData)
	elseif self.tag == TAB_GAME then
		self:showGame(updateData)
	else
		self:showFactory(updateData)
	end
	self:refreshEntryButtons()
end
function Activity_9001733_ViewPanel:onHide()
	self.isWaitingInitData = false
	SoraDCloseLoading(self, INIT_LOADING_MARK)
end
function Activity_9001733_ViewPanel:onClick_btnTask(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001733_Task")
end
function Activity_9001733_ViewPanel:onClick_btnBall(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001733_Produce")
end
function Activity_9001733_ViewPanel:onClick_btnRewardPrev(context)
	SoraDPlaySound()
	uiManager:show(REWARD_PREV_PANEL_NAME)
end
return Activity_9001733_ViewPanel
