local activity_9001746_Ctrl = SoraDGetCtrl("activity_9001746_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001746_ViewPanel = class("Activity_9001746_ViewPanel", baseFguiPanel)
local CTRL_TYPE_GAME = 0
local CTRL_TYPE_BATTLEPASS = 1
local REWARD_PREV_PANEL_NAME = "Activity_9001746_RewardPrev"
local TAB_GAME = 1
local TAB_BATTLEPASS = 2
local INIT_LOADING_MARK = gCmd.REQ_UNDERWATER_TREASURE_INIT
function Activity_9001746_ViewPanel:ctor(...)
	self.isLRU = true
	Activity_9001746_ViewPanel.super.ctor(self, ...)
	self.activityID = gActivityTimeActivityID.UNDERWATER_TREASURE_ACTIVITY
end
function Activity_9001746_ViewPanel:getPackageList()
	_UPVALUE1_ = nil
	;(nil)[1] = "Activity_9001738"
	return nil
end
function Activity_9001746_ViewPanel:onInit()
	self:fixChildrenPos()
	self.fields.Com_bg:setGradientColor()
	self.fields.comTitle:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	_ENV = handler(self, self.onClickHelp)
	handler(self, self.onClickHelp).time = ""
	self.fields.comTitle:initSpecialActivityTimeNew(self.activityID, i18n("common_text_4481", handler(self, self.onClickHelp)))
	self.tag = TAB_GAME
	_ENV = self.activityID
	_ENV, _ENV, self.activityID.defaultClick = i18n("common_text_4481", handler(self, self.onClickHelp))
	i18n("common_text_4481", handler(self, self.onClickHelp)).title = i18n("football_treasure_text_002")
	_ENV, self.tag[1], i18n("common_text_4481", handler(self, self.onClickHelp)).tag = i18n("common_text_4481", handler(self, self.onClickHelp))
	i18n("common_text_4481", handler(self, self.onClickHelp)).title = i18n("football_treasure_text_003")
	self.activityID.tabsetArray, self.tag[2], i18n("common_text_4481", handler(self, self.onClickHelp)).tag = self.tag, i18n("common_text_4481", handler(self, self.onClickHelp))
	self.activityID.callback = handler(self, self.onTabClick)
	self.activityID.unDefaultClick = true
	self.fields.comTitle:initTab(self.activityID)
	self.fields.btnRewardPrev:setString(i18n("football_treasure_text_017"))
	self.fields.btnRewardPrev:addClickListener(handler(self, self.onClick_btnRewardPrev))
	self.fields.btnRewardPrev:fixPos()
	self:updateRewardPrevState()
end
function Activity_9001746_ViewPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("water_treasure_text_001")
	uiManager:show("RuleView", nil)
end
function Activity_9001746_ViewPanel:endShow()
	self.tag = self:getDefaultTabTag()
	self.isWaitingInitData = true
	SoraDShowLoading(self, nil, INIT_LOADING_MARK)
	self.fields.comTitle:setTabIndex(self.tag, true)
	activity_9001746_Ctrl:sendReqInitDataMsg()
end
function Activity_9001746_ViewPanel:getDefaultTabTag()
	if not self.param then
		local TAB_BATTLEPASS, param = self.param, self.param
	end
	local defaultTab = param.defaultTab or param.tab or param.tag
	if param.jumpToBattlePass or defaultTab == TAB_BATTLEPASS or defaultTab == "battlepass" then
		return TAB_BATTLEPASS
	end
	return TAB_GAME
end
function Activity_9001746_ViewPanel:onTabClick(tag)
	self.tag = tag
	self:updateTypeController(tag)
	if self.isWaitingInitData then
		return
	end
	if tag == TAB_BATTLEPASS then
		self:refreshBattlePass()
	else
		self:refreshGame()
	end
	self:refreshEntryButtons()
end
function Activity_9001746_ViewPanel:updateTypeController(tag)
	self.controllers.ctrlType:setSelectedIndex(tag == TAB_BATTLEPASS and CTRL_TYPE_BATTLEPASS or CTRL_TYPE_GAME)
end
function Activity_9001746_ViewPanel:refreshGame(updateData)
	self.fields.game:initData(self.activityID, updateData)
	self:updateRewardPrevState()
end
function Activity_9001746_ViewPanel:refreshBattlePass(updateData)
	self.fields.pass:initData(self.activityID, updateData)
end
function Activity_9001746_ViewPanel:jumpToGame()
	self.fields.comTitle:setTabIndex(TAB_GAME, true)
end
function Activity_9001746_ViewPanel:jumpToBattlePass()
	self.fields.comTitle:setTabIndex(TAB_BATTLEPASS, true)
end
function Activity_9001746_ViewPanel:updateRewardPrevState()
	self.fields.btnRewardPrev:setEnabled(true)
	self.fields.btnRewardPrev:setReddot(false, 0)
end
function Activity_9001746_ViewPanel:refreshEntryButtons()
	local gameTabNum = activity_9001746_Ctrl:getShootTabRedNum()
	local battlePassNum = activity_9001746_Ctrl:getBattlePassTabRedNum()
	self.fields.comTitle:setBtnRedDot(TAB_GAME, 0 < gameTabNum, -1)
	self.fields.comTitle:setBtnRedDot(TAB_BATTLEPASS, 0 < battlePassNum, battlePassNum)
	self:updateRewardPrevState()
end
function Activity_9001746_ViewPanel:updatRed()
	self:refreshEntryButtons()
end
function Activity_9001746_ViewPanel:updateView(updateData)
	if self.isWaitingInitData then
		if not updateData or updateData.subMsg ~= "init" then
			return
		end
		self.isWaitingInitData = false
		SoraDCloseLoading(self, INIT_LOADING_MARK)
	end
	if self.tag == TAB_BATTLEPASS then
		self:refreshBattlePass(updateData)
	else
		self:refreshGame(updateData)
	end
	self:refreshEntryButtons()
end
function Activity_9001746_ViewPanel:onHide()
	self.isWaitingInitData = false
	SoraDCloseLoading(self, INIT_LOADING_MARK)
end
function Activity_9001746_ViewPanel:onClick_btnRewardPrev()
	SoraDPlaySound()
	uiManager:show(REWARD_PREV_PANEL_NAME)
end
return Activity_9001746_ViewPanel
