local activity_9001719_Read = include("activity_9001719_Read")
local activity_9001719_Ctrl = SoraDGetCtrl("activity_9001719_Ctrl")
local constantRead = include("constantRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001719_MainPanel = class("Activity_9001719_MainPanel", baseFguiPanel)
function Activity_9001719_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001719_MainPanel.super.ctor(self, ...)
	print("Activity_9001719_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.MAGIC_CARPET
	self.costID = constantRead.getConstValue("MAGIC_CARPET_STAR_COST", 878001)
end
function Activity_9001719_MainPanel:onInit()
	print("=======Activity_9001719_MainPanel:onInit")
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_title:initData(i18n("activity_name_9001719"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_task:setString(i18n("common_text_675"))
	self.fields.Button_sign:setString(i18n("magic_carpet_02"))
	self.fields.Button_rank:setString(i18n("common_text_851"))
	self.fields.Button_challenge:setString(i18n("exitic_pavillion_text_0117"))
	self.fields.Button_task:addClickListener(handler(self, self.btnTaskClick))
	self.fields.Button_sign:addClickListener(handler(self, self.btnSignClick))
	self.fields.Button_rank:addClickListener(handler(self, self.btnRankClick))
	self.fields.Button_challenge:addClickListener(handler(self, self.btnChallengeClick))
end
function Activity_9001719_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("magic_carpet_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001719_MainPanel:endShow()
	print("=======Activity_9001719_MainPanel:endShow")
	_ENV = nil
	;(nil).time = ""
	self.fields.Com_title:initSpecialActivityTimeNew(self.activityID, i18n("common_text_4481", nil))
	_ENV = self.activityID
	self.activityID.byUID = true
	local recordTable = SoraDConfigGet("Game:Com_9001719_game:recordTable~table", self.activityID)
	if recordTable ~= nil then
		activity_9001719_Ctrl:reqGameEnd(recordTable[1], recordTable[2])
		_ENV = recordTable[2]
		recordTable[2].byUID = true
		SoraDConfigSet("Game:Com_9001719_game:recordTable~table", nil, recordTable[2])
	end
	self:initView()
end
function Activity_9001719_MainPanel:initView()
	local bestScore = activity_9001719_Ctrl:getBestScore()
	activity_9001719_Ctrl = nil
	;(nil).score = fguiHelper.getColorString("#FFD43E", bestScore)
	self.fields.Text_score:setString(i18n("magic_carpet_03", nil))
	self.fields.Com_have:initData(self.costID, handler(self, self.btnSignClick))
	self.fields.Button_challenge:setCost(self.costID, 1)
	self.fields.Button_challenge:setIsEnough(1 <= backpackCtrl:getItemCount(self.costID))
	self:updateReddot()
end
function Activity_9001719_MainPanel:updateReddot()
	local taskNum = activity_9001719_Ctrl:getTaskRewardNum() + activity_9001719_Ctrl:getStageRewardNum()
	self.fields.Button_task:setReddot(0 < taskNum, taskNum)
	local isSignReward = activity_9001719_Ctrl:isHaveSignReward()
	self.fields.Button_sign:setReddot(isSignReward)
end
function Activity_9001719_MainPanel:newGame()
	SoraDCloseLoading(self)
	uiManager:show("Activity_9001719_Game")
end
function Activity_9001719_MainPanel:btnTaskClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001719_Task")
end
function Activity_9001719_MainPanel:btnSignClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001719_Pass")
end
function Activity_9001719_MainPanel:btnRankClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001719_Rank")
end
function Activity_9001719_MainPanel:btnChallengeClick()
	SoraDPlaySound()
	if backpackCtrl:getItemCount(self.costID) < 1 then
		SoraDShowMsgTip(i18n("magic_carpet_09"))
		return
	end
	activity_9001719_Ctrl:reqGameBegin()
	SoraDShowLoading(self)
end
return Activity_9001719_MainPanel
