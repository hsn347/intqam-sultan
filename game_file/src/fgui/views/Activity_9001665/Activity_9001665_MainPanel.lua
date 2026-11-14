local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001665_MainPanel = class("Activity_9001665_MainPanel", baseFguiPanel)
local activity_9001665_Read = include("activity_9001665_Read")
local activity_9001665_Ctrl = SoraDGetCtrl("activity_9001665_Ctrl")
function Activity_9001665_MainPanel:ctor(...)
	Activity_9001665_MainPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001665_MainPanel:ctor", self.viewName)
end
function Activity_9001665_MainPanel:onInit()
	print("=======Activity_9001665_MainPanel:onInit")
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001665
	self.fields.Com_title:initData(i18n("activity_name_9001665"), handler(self, self.onBackClick), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.btn_rank:setTitle(i18n("pyramid_btn_29"))
	self.fields.btn_rank:addClickEventListener(handler(self, self.onRankClick))
	self.fields.btn_book:setTitle(i18n("fishingmaster_text_24"))
	self.fields.btn_book:addClickEventListener(handler(self, self.onBookClick))
	_UPVALUE2_ = self.fields.btn_book.addClickEventListener
	self.hardNames, self.fields.btn_book.addClickEventListener[1] = self.fields.btn_book.addClickEventListener, i18n("devilvalley_btn_04")
	self.hardNames, self.fields.btn_book.addClickEventListener[2] = self.fields.btn_book.addClickEventListener, i18n("atlantiswar_skill_text_020")
	self.hardNames, self.fields.btn_book.addClickEventListener[3] = self.fields.btn_book.addClickEventListener, i18n("devilvalley_btn_06")
	self.hardNames, self.fields.btn_book.addClickEventListener[4] = self.fields.btn_book.addClickEventListener, i18n("devilvalley_btn_06")
	self.hardNames, self.fields.btn_book.addClickEventListener[5] = self.fields.btn_book.addClickEventListener, i18n("devilvalley_btn_06")
	self.hardNames, self.fields.btn_book.addClickEventListener[6] = self.fields.btn_book.addClickEventListener, i18n("devilvalley_btn_06")
	self.hardNames, self.fields.btn_book.addClickEventListener[7] = self.fields.btn_book.addClickEventListener, i18n("devilvalley_btn_06")
	self.hardNames, self.fields.btn_book.addClickEventListener[8] = self.fields.btn_book.addClickEventListener, i18n("devilvalley_btn_06")
	self.hardNames, self.fields.btn_book.addClickEventListener[9] = self.fields.btn_book.addClickEventListener, i18n("devilvalley_btn_06")
	self.hardNames, self.fields.btn_book.addClickEventListener[10] = self.fields.btn_book.addClickEventListener, i18n("devilvalley_btn_06")
	self.fields.btn_hard1:setTitle(i18n("devilvalley_btn_04"))
	self.fields.btn_hard1:addClickEventListener(handler(self, self.onHardClick), 1)
	self.fields.btn_hard2:setTitle(i18n("atlantiswar_skill_text_020"))
	self.fields.btn_hard2:addClickEventListener(handler(self, self.onHardClick), 2)
	self.fields.btn_hard3:setTitle(i18n("devilvalley_btn_06"))
	self.fields.btn_hard3:addClickEventListener(handler(self, self.onHardClick), 3)
	self.fields.btn_rank:fixPos()
	self.fields.btn_book:fixPos()
	for i = 1, 3 do
		self.fields["btn_hard" .. i]:fixPos()
		local effect = fguiHelper.get_fields(self.fields["btn_hard" .. i]).n10
		effect:setAllFrameNameOnce("frame_9001665_grouperfish%02d.png", 1, true)
	end
	local _ENV, stageData = (for index), 1
	local stageConfig = activity_9001665_Read.getBoxCfgs()
	for i, cfg in ipairs(stageConfig) do
		_ENV = true
		;(true).stage = i
		;(true).point = cfg.point
		;(true).rewards = cfg.reward
		table.insert(stageData, true)
	end
	self.stageData = stageData
	_ENV = ipairs(stageConfig)
	ipairs(stageConfig).activityID = self.activityID
	ipairs(stageConfig).stageMax = #self.stageData
	self.fields.Com_boxList:initData(ipairs(stageConfig))
	self.fields.Com_9001665_game:setTimePull(self.fields.time_pull)
	self.fields.Com_9001665_game:setResultCallback(handler(self, self.onResultCallback))
end
function Activity_9001665_MainPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ForeignPavilion"
	end
	return self._packageList
end
function Activity_9001665_MainPanel:onShow()
	print("=======Activity_9001665_MainPanel:onShow")
	self:updateView()
end
function Activity_9001665_MainPanel:updateView()
	local season = activity_9001665_Ctrl:getSeason()
	self.fields.iconSeason:setURL(activity_9001665_Ctrl:getSeasonIcon(season))
	for __, data in ipairs(self.stageData) do
		data.state = activity_9001665_Ctrl:getBoxRewardDataStatus(data.stage, data.point)
	end
	local maxScore = activity_9001665_Ctrl:getMaxScore()
	activity_9001665_Ctrl = activity_9001665_Ctrl:getSeasonIcon(season)
	activity_9001665_Ctrl:getSeasonIcon(season).score = maxScore
	activity_9001665_Ctrl:getSeasonIcon(season).stageData = self.stageData
	self.fields.Com_boxList:updateData(activity_9001665_Ctrl:getSeasonIcon(season))
	activity_9001665_Ctrl = activity_9001665_Ctrl:getBoxRewardDataStatus(data.stage, data.point)
	activity_9001665_Ctrl, activity_9001665_Ctrl, activity_9001665_Ctrl:getBoxRewardDataStatus(data.stage, data.point).num = maxScore, string.formatnumberthousands(maxScore), string.formatnumberthousands(maxScore)
	string.formatnumberthousands(maxScore).num, maxScore.color = maxScore, "#FFDF2D"
	self.fields.tips:setTitle(i18n_html("fishingmaster_text_02", activity_9001665_Ctrl:getBoxRewardDataStatus(data.stage, data.point), (string.formatnumberthousands(maxScore))))
	self:updateRed()
end
function Activity_9001665_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("fishingmaster_text_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001665_MainPanel:onRankClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001665_Rank")
end
function Activity_9001665_MainPanel:onBookClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001665_Book")
end
function Activity_9001665_MainPanel:onHardClick(sender, param)
	SoraDPlaySound()
	if param > activity_9001665_Ctrl:getFinishedDifficult() + 1 then
		_ENV = nil
		;(nil).name = self.hardNames[param - 1]
		SoraDShowMsgTip(i18n("fishingmaster_text_23", nil))
		return
	end
	self.choosingHard = param
	self.controllers.c1:setSelectedIndex(1)
	self.isInGame = true
	self.fields.Com_9001665_game:startGame(param)
	self.fields.Usm_1:clearEffect()
	local seq = ffa.seq(ffa.delay(3), ffa.callFunc(function()
		self.fields.Usm_1:clearEffect()
		self.fields.Usm_1:setEffectPath("activity_9001665_01.usm,activity_9001665_02.usm", true, true)
	end))
	seq:setTag(995)
	self:stopActionByTag(995)
	self:runAction(seq)
end
function Activity_9001665_MainPanel:onResultCallback(isWin, hard, passTime, difficultPoint, operatePoint)
	SoraDShowLoading(self, nil, nil, true, 1.0)
	self.isInGame = false
	local passTime, difficultPoint, operatePoint = passTime or 0, difficultPoint or 0, operatePoint or 0
	local showResultFunc = function()
		self.controllers.c1:setSelectedIndex(0)
		self = operatePoint
		operatePoint.isWin = isWin
		operatePoint.hard = hard
		operatePoint.passTime = passTime
		operatePoint.difficultPoint = difficultPoint
		operatePoint.operatePoint = operatePoint
		activity_9001665_Ctrl:reqPlay(hard, math.floor(passTime * 100), difficultPoint + operatePoint, operatePoint)
		SoraDCloseLoading(self)
	end
	if isWin then
		self.fields.Usm_1:setCompleteCallback(showResultFunc)
		self.fields.Usm_1:setEffectPath("activity_9001665_03.usm", false)
	else
		SoraDCloseLoading(self)
		self.controllers.c1:setSelectedIndex(0)
		_ENV = false
		_ENV, (false).fishId = nil, 0
		;(nil).isWin = isWin
		;(nil).hard = hard
		;(nil).passTime = passTime
		;(nil).difficultPoint = difficultPoint
		;(false).extraData, (nil).operatePoint = nil, operatePoint
		uiManager:show("Activity_9001665_Reward", false)
	end
end
function Activity_9001665_MainPanel:onBackClick()
	if self.isInGame then
		SoraDPlaySound()
		self:stopActionByTag(995)
		self.fields.Com_9001665_game:finishGame()
		self.controllers.c1:setSelectedIndex(0)
		self.isInGame = false
	else
		self:onClickClose()
	end
end
function Activity_9001665_MainPanel:gameGuide_getTarget(itemName, parameters)
	print("Activity_9001665_MainPanel:gameGuide_getTarget", itemName)
	if not self.fields[itemName] then
		return self.fields.Com_9001665_game.fields[itemName]
	end
	return self.fields[itemName]
end
function Activity_9001665_MainPanel:updateRed()
	local bookStageData = activity_9001665_Ctrl:getBookStageData()
	local num = 0
	for i, v in ipairs(bookStageData) do
		if v.state == gBtnTargetStatusDef.GET then
			num = num + 1
		end
	end
	self.fields.btn_book:setReddot(0 < num)
end
return Activity_9001665_MainPanel
