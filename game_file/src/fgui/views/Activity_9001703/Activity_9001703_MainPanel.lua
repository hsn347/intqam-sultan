local constantRead = include("constantRead")
local activity_9001703_Read = include("activity_9001703_Read")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activity_9001703_Ctrl = SoraDGetCtrl("activity_9001703_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001703_MainPanel = class("Activity_9001703_MainPanel", baseFguiPanel)
function Activity_9001703_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001703_MainPanel.super.ctor(self, ...)
	print("Activity_9001703_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.BALLOON_HUNTER_ACTIVITY
end
function Activity_9001703_MainPanel:onInit()
	print("=======Activity_9001703_MainPanel:onInit")
	self.fields.Com_bg:setGradientColor()
	self.huntCost = constantRead.getConstValue("BALLOON_HUNTER_STAR_COST", 876601)
	self.fields.Com_title:initData(i18n("balloon_hunter_001"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_task:setString(i18n("balloon_hunter_003"))
	self.fields.Button_sign:setString(i18n("balloon_hunter_004"))
	self.fields.Button_rank:setString(i18n("balloon_hunter_005"))
	self.fields.Button_challenge:setString(i18n("arena_btn_04"))
	self.fields.Button_task:addClickListener(handler(self, self.btnTaskClick))
	self.fields.Button_sign:addClickListener(handler(self, self.btnSignClick))
	self.fields.Button_rank:addClickListener(handler(self, self.btnRankClick))
	self.fields.Button_challenge:addClickListener(handler(self, self.btnChallengeClick))
	self.fields.Btn_tip:addClickListener(handler(self, self.btnTipClick))
	self.fields.List_skill:setItemRenderer(handler(self, self.onSkillRenderer))
	self.fields.icon_coin:fixPos()
	self.fields.Text_coin:fixPos()
	self.fields.Btn_tip:fixPos()
end
function Activity_9001703_MainPanel:onSkillRenderer(index, obj)
	obj:initData(index + 1)
end
function Activity_9001703_MainPanel:endShow()
	print("=======Activity_9001703_MainPanel:endShow")
	_ENV = nil
	;(nil).time = ""
	self.fields.Com_title:initSpecialActivityTimeNew(self.activityID, i18n("common_text_4481", nil))
	self:initView()
end
function Activity_9001703_MainPanel:initView(target, data)
	local coinNum = activity_9001703_Ctrl:getCoinNum()
	activity_9001703_Ctrl = nil
	;(nil).num = coinNum
	self.fields.Text_coin:setString(i18n("balloon_hunter_006", nil))
	self.skillData = activity_9001703_Read.getBasicSkillCfg()
	self.fields.List_skill:setNumItems(#self.skillData)
	self.fields.Com_have:initData(self.huntCost)
	self.fields.Button_challenge:setCost(self.huntCost, 1)
	self.fields.Button_challenge:setIsEnough(1 <= backpackCtrl:getItemCount(self.huntCost))
	self:updateReddot()
end
function Activity_9001703_MainPanel:updateReddot()
	local taskNum = activity_9001703_Ctrl:getTaskRewardNum() + activity_9001703_Ctrl:getStageRewardNum()
	self.fields.Button_task:setReddot(0 < taskNum, taskNum)
	local isSignReward = activity_9001703_Ctrl:isHaveSignReward()
	self.fields.Button_sign:setReddot(isSignReward)
end
function Activity_9001703_MainPanel:newGame()
	SoraDCloseLoading(self)
	_ENV = nil
	;(nil).isGuide = self.isGuide
	uiManager:show("Activity_9001703_Game", nil)
end
function Activity_9001703_MainPanel:btnTaskClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001703_Task")
end
function Activity_9001703_MainPanel:btnSignClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001703_Pass")
end
function Activity_9001703_MainPanel:btnRankClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001703_Rank")
end
function Activity_9001703_MainPanel:btnChallengeClick()
	SoraDPlaySound()
	if backpackCtrl:getItemCount(self.huntCost) < 1 then
		SoraDShowMsgTip(i18n("balloon_hunter_011"))
		return
	end
	self.isGuide = activity_9001703_Ctrl:isNeedGuide()
	activity_9001703_Ctrl:reqNewGame()
	SoraDShowLoading(self)
end
function Activity_9001703_MainPanel:btnTipClick()
	SoraDPlaySound()
	SoraDShowMsgTip(i18n("balloon_hunter_007"))
end
function Activity_9001703_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("balloon_hunter_002")
	uiManager:show("RuleView", nil)
end
return Activity_9001703_MainPanel
