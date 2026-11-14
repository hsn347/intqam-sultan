local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local supremacyRoadCtrl = SoraDGetCtrl("supremacyRoadCtrl")
local nebulaWarUtil = include("nebulaWarUtil")
local activityTimeRead = include("activityTimeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SupremacyRoadPanel = class("SupremacyRoadPanel", baseFguiPanel)
function SupremacyRoadPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SupremacyRoadPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.SUPREMACY_ROAD_ACTIVITY
end
function SupremacyRoadPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SupremacyRoadPanel:onInit()
	print("=======SupremacyRoadPanel:onInit")
	local activityName = activityTimeRead.getActivityNameByID(self.activityID)
	self.fields.Com_title:initData(i18n(activityName), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Label_time:initActivityTimeStyle(self.activityID)
	local remainTime = nebulaWarUtil.getSupremacyRoadRemainTime()
	if 0 < remainTime then
		self.fields.Label_time:beginTime(remainTime)
	else
		self.fields.Label_time:setString(i18n("Anchor_text_21"))
	end
	local curRound = activityShowCtrl:getParamClassType(self.activityID)
	self.questList = supremacyRoadCtrl:getQuestData(curRound)
end
function SupremacyRoadPanel:onShow()
	print("=======SupremacyRoadPanel:onShow")
	supremacyRoadCtrl:reqInit()
	SoraDShowLoading(self:displayObject())
end
_ENV, SupremacyRoadPanel.onClickHelp = function(self, ...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("supremacy_road_text_005")
	uiManager:show("RuleView", nil)
end, function(self, ...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("supremacy_road_text_005")
	uiManager:show("RuleView", nil)
end
;(function(self, ...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("supremacy_road_text_005")
	uiManager:show("RuleView", nil)
end).SELF_KILL_ENEMY_CAMP = 1
;(function(self, ...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("supremacy_road_text_005")
	uiManager:show("RuleView", nil)
end).TEAM_KILL_ENEMY_CAMP = 2
;(function(self, ...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("supremacy_road_text_005")
	uiManager:show("RuleView", nil)
end).SELF_KILL = 3
local (function(self, ...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("supremacy_road_text_005")
	uiManager:show("RuleView", nil)
end).TEAM_KILL, QUEST_TYPE_ENUM = 4, function(self, ...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("supremacy_road_text_005")
	uiManager:show("RuleView", nil)
end
function SupremacyRoadPanel:onMsgInitBack(target, event)
	SoraDCloseLoading(self:displayObject())
	local scoreData = event.rspdata
	_ENV = self:displayObject()
	self:displayObject()[QUEST_TYPE_ENUM.SELF_KILL_ENEMY_CAMP] = scoreData.selfKillEmemyPower
	self:displayObject()[QUEST_TYPE_ENUM.TEAM_KILL_ENEMY_CAMP] = scoreData.killEmemyPower
	self:displayObject()[QUEST_TYPE_ENUM.SELF_KILL] = scoreData.selfKillPower
	local self:displayObject()[QUEST_TYPE_ENUM.TEAM_KILL], type2score = scoreData.killPower, self:displayObject()
	local comIndex = 0
	for questType = QUEST_TYPE_ENUM.SELF_KILL_ENEMY_CAMP, QUEST_TYPE_ENUM.TEAM_KILL do
		local questData = self.questList[questType]
		if questData then
			comIndex = comIndex + 1
			local Com_stage = self.fields["Com_stage" .. comIndex]
			local fieldsStage = fguiHelper.get_fields(Com_stage)
			fieldsStage.Com_bar:fixChildrenPos()
			local curScore = type2score[questType]
			local name = supremacyRoadCtrl:getQuestTypeName(questType)
			_ENV = self:displayObject()
			self:displayObject().num = SoraDConvertNumberWithUnit(curScore)
			fieldsStage.Text_title:setString(i18n(name, self:displayObject()))
			local describe = supremacyRoadCtrl:getQuestTypeDes(questType)
			fieldsStage.Text_des:setString(i18n(describe))
			local scoreMin = questData[1].condition
			local scoreMax = questData[#questData].condition
			local percent = (curScore - scoreMin) / (scoreMax - scoreMin) * 100
			fieldsStage.Com_bar:setValue(percent)
			local stepX = 464 / (#questData - 1)
			local stageMax = 5
			for stage = 1, stageMax do
				local Com_box = fieldsStage["Com_box" .. stage]
				local data = questData[stage]
				if data then
					Com_box:setVisible(true)
					Com_box:setString(SoraDConvertNumberWithUnit(data.condition))
					if curScore >= data.condition then
						Com_box:setIcon("icon_lshs_common_06_FullyOpen.png")
					else
						Com_box:setIcon("icon_lshs_common_06_closed.png")
					end
					local posX = 492 - stepX * SoraDFPosX(stage - 1, stageMax - 1)
					Com_box:setPositionX(posX)
					local Button_click = Com_box:getChild("Button_click")
					Button_click.questType = questType
					_ENV, Button_click.stage = Com_box, stage
					Com_box.curScore = curScore
					Com_box.maxScore = data.condition
					supremacyRoadCtrl = SoraDConvertNumberWithUnit(data.condition)
					SoraDConvertNumberWithUnit(data.condition)[1] = "id"
					SoraDConvertNumberWithUnit(data.condition)[2] = "count"
					Button_click.config, Com_box.rewards = Com_box, serviceFunctions.tableFormat(data.award, SoraDConvertNumberWithUnit(data.condition))
					Button_click:addClickListener(handler(self, self.onClickBtnBox))
				else
					Com_box:setVisible(false)
				end
			end
		end
	end
end
function SupremacyRoadPanel:onClickBtnBox(EventContext)
	SoraDPlaySound()
	local sender = EventContext:getSender()
	local config = sender.config
	_ENV = nil
	;(nil).config = config
	uiManager:show("SupremacyRoadReward", nil)
end
return SupremacyRoadPanel
