local activity_9001736_Ctrl = SoraDGetCtrl("activity_9001736_Ctrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001736_Match = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001736/Com_9001736_Match", Com_9001736_Match)
function Com_9001736_Match:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001736_BATTLE_BACK", handler(self, self.onMsgBattleBack))
end
function Com_9001736_Match:onInit()
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001736
	self.fields.Button_rank:setTitle(i18n("football_match_text_010"))
	self.fields.Button_rank:addClickListener(handler(self, self.onClick_Button_rank))
	self.fields.Button_battle:addClickListener(handler(self, self.onClick_Button_battle))
	self.fields.Text_tip:setString(i18n("football_match_text_009"))
	self.fields.Com_have:setIcon("icon_9001736_score.png")
end
function Com_9001736_Match:onShow()
	self:updateData()
end
function Com_9001736_Match:updateData()
	local doStage = activityShowCtrl:getDoStageByID(self.activityID)
	if doStage == 0 then
		local remainTime = activityShowCtrl:getRemainTime(self.activityID) or 0
		if 0 < remainTime then
			self.fields.Lab_lock:initSpecialTime(remainTime, "football_match_text_034")
			self.fields.bg_lock:setVisible(true)
			self.fields.Lab_lock:setVisible(true)
		else
			self.fields.bg_lock:setVisible(false)
			self.fields.Lab_lock:setVisible(false)
		end
		self.fields.Button_battle:setEnabled(false)
		self.fields.Button_rank:setVisible(false)
	else
		self.fields.bg_lock:setVisible(false)
		self.fields.Lab_lock:setVisible(false)
		self.fields.Button_battle:setEnabled(true)
		self.fields.Button_rank:setVisible(true)
	end
	self:updateScore()
	local power = activity_9001736_Ctrl:getPower()
	local powerStr = string.formatnumberthousands(power)
	activityShowCtrl = "football_match_text_034"
	;("football_match_text_034").color = "#FFC864"
	powerStr = SoraDWrapHtmlTagByStyle(powerStr, "football_match_text_034")
	activityShowCtrl = nil
	;(nil).num = powerStr
	self.fields.Lab_power:setString(i18n("football_match_text_005", nil))
	self:updateChallengeTimes()
end
function Com_9001736_Match:onClick_Button_rank(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.activityID
	uiManager:show("Activity_Common_Rank", nil)
end
function Com_9001736_Match:onClick_Button_battle(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001736_BattleList")
end
function Com_9001736_Match:updateChallengeTimes()
	local doStage = activityShowCtrl:getDoStageByID(self.activityID)
	if doStage == 0 then
		self.fields.Button_battle:setVisible(false)
		return
	end
	self.fields.Button_battle:setVisible(true)
	local leftTimes, maxTimes = activity_9001736_Ctrl:getChallengeLeftTimes()
	local battleStr = i18n("football_match_text_006")
	self.fields.Button_battle:setTitle(battleStr)
	self.fields.Button_battle:setReddot(0 < leftTimes)
end
function Com_9001736_Match:updateScore()
	local score = activity_9001736_Ctrl:getScore()
	self.fields.Com_have:setString(score)
end
function Com_9001736_Match:onMsgBattleBack(target, event)
	local Activity_9001736_Main = uiManager:getProxy("Activity_9001736_Main").view
	SoraDRemoveAllAfterPanelFromManager(Activity_9001736_Main, true)
	self:updateChallengeTimes()
	self:updateScore()
	_ENV = self.updateScore
	self.updateScore.seedList, _ENV, self.updateScore.isWin = self, self, false
	self.updateScore.rewards = event.rewards
	local self.updateScore.score, param = 0, self.updateScore
	if not event.battleInfo then
		local _ENV, battleInfo = event.battleInfo, event.battleInfo
	end
	local score = battleInfo.score or 0
	param.isWin = 0 < score
	param.score = score
	local _ENV, temp = 0 < score, 0 < score
	local seedList = battleInfo.enemyInfo.seedList
	for i, v in ipairs(seedList) do
		table.insert(temp, v.seedId)
	end
	param.seedList = temp
	uiManager:show("Activity_9001736_Action", param)
end
return Com_9001736_Match
