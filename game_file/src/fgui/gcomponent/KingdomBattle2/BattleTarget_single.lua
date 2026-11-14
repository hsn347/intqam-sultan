local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local conquestWarltCtrl = include("conquestWarltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local BattleTarget_single = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://KingdomBattle2/BattleTarget_single", BattleTarget_single)
_ENV = fgui.register_extension
fgui.register_extension.person = 1
local fgui.register_extension.alliance, STAGE_TYPE = 2, fgui.register_extension
function BattleTarget_single:onInit()
	self.stageInfo, _ENV, self.curScore = nil, nil, 0
	self.fields.Button_help:addClickListener(handler(self, self.onClickBtnHelp))
	self.fields.Button_help_score:addClickListener(handler(self, self.onClickBtnHelpScore))
end
function BattleTarget_single:onShow()
end
function BattleTarget_single:onClickBtnHelp(...)
	SoraDPlaySound()
	local showMsg = ""
	if self.stageType == STAGE_TYPE.person then
		showMsg = i18n("common_text_3144")
	else
		showMsg = i18n("common_text_3145")
	end
	SoraDShowMsgBox(showMsg, i18n("common_text_3148"), nil, function(callBack)
		if callBack == MSGBOX_CALLBACK_YES then
			uiManager:show("kingdomBattlePrice")
		end
	end)
end
function BattleTarget_single:onClickBtnHelpScore(...)
	SoraDPlaySound()
	uiManager:show("kingdomBattleAllianceRank")
end
function BattleTarget_single:initStageType(stageType)
	self.stageType = stageType
	if self.stageType == STAGE_TYPE.person then
		self:initPersonStage()
	elseif self.stageType == STAGE_TYPE.alliance then
		self:initAllianceStage()
	end
end
function BattleTarget_single:initPersonStage(...)
	self.fields.Text_title:setString(i18n("common_text_3142"))
	self.controllers.c_type:setSelectedIndex(0)
	self.stageData = conquestWarltCtrl.getStageRewardByType(gConquestWarStageRewardType.PERSON, conquestWarCtrl:getMatchPool())
	self:initBoxAndProgress()
	self:updateInfo()
end
function BattleTarget_single:initAllianceStage(...)
	self.fields.Text_title:setString(i18n("common_text_3143"))
	self.fields.Text_alliance_tip:setString(i18n("common_text_3151"))
	if not allianceMgr:hasJoinAlliance() then
		self.controllers.c_hasAlliance:setSelectedIndex(1)
		return
	end
	self.controllers.c_hasAlliance:setSelectedIndex(0)
	self.controllers.c_type:setSelectedIndex(1)
	self.stageData = conquestWarltCtrl.getStageRewardByType(gConquestWarStageRewardType.ALLIANCE, conquestWarCtrl:getMatchPool())
	self:initBoxAndProgress()
	self:updateInfo()
end
function BattleTarget_single:initBoxAndProgress()
	self.contentFields = fguiHelper.get_fields(self.fields.Com_content)
	if self.stageType == STAGE_TYPE.person then
		self.contentFields.ProgressBar_alliance:setVisible(false)
		self.ProgressBar = self.contentFields.ProgressBar_person
	else
		self.contentFields.ProgressBar_person:setVisible(false)
		self.ProgressBar = self.contentFields.ProgressBar_alliance
	end
	self.ProgressBar:fixChildrenPos()
	local beginX = SoraDFPosX(594, 640)
	local endX = 640 - beginX
	local length = endX - beginX
	local maxScore = self.stageData[#self.stageData].needscore
	for i = 1, 3 do
		local Button_box = self.contentFields["Button_box" .. i]
		Button_box:fixPos()
		_ENV = nil
		;(nil).num = i
		Button_box:setString(i18n("common_text_3198", nil))
		Button_box:getController("c_state"):setSelectedIndex(0)
		Button_box:setTag(i)
		Button_box:addClickListener(handler(self, self.onClickBtnBox))
		local Text_stage = self.contentFields["Text_stage" .. i]
		local needscore = self.stageData[i].needscore
		Text_stage:setString(string.formatnumberthousands(needscore))
		Text_stage:setPositionX(needscore / maxScore * length + beginX)
	end
end
function BattleTarget_single:onClickBtnBox(EventContext)
	SoraDPlaySound()
	local boxIdx = EventContext:getSender():getTag()
	local data = self.stageData[boxIdx]
	_ENV = nil
	;(nil).goal = data.needscore
	;(nil).alliance = self.stageType == STAGE_TYPE.alliance
	;(nil).index = boxIdx
	;(nil).data = data
	uiManager:show("KingdomBattleTargetBoxDetail", nil)
end
function BattleTarget_single:updateInfo(curScore, stageInfo)
