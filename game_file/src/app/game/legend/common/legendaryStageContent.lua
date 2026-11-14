local gametop = gModuleMgr.getObject("gametop")
local legendStageRewardCtrl = gametop.playertop_:getModule("legendStageRewardCtrl")
local legendRewardRead = include("legendRewardRead")
local legendTeamCtrl = gametop.playertop_:getModule("legendTeamCtrl")
local kingStarTeamCtrl = gametop.playertop_:getModule("kingStarTeamCtrl")
local legendaryStageContent = class("legendaryStageContent", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("legendaryStageContent")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function legendaryStageContent:ctor()
	self:createUI()
	self.nodeRewardTopFrame = SoraDGetChildByName(self, "node_reward_top_frame")
	self.frameQdlhlBtL = SoraDGetChildByName(self, "frame_qdlhl_bt_L")
	self.frameQdlhlBtR = SoraDGetChildByName(self, "frame_qdlhl_bt_R")
	self.lineL = SoraDGetChildByName(self, "line_L")
	self.lineR = SoraDGetChildByName(self, "line_R")
	self.frameThroneContendL = SoraDGetChildByName(self, "frame_throne_contend_L")
	self.frameThroneContendR = SoraDGetChildByName(self, "frame_throne_contend_R")
	self.labelRewardTitle = SoraDGetChildByName(self, "label_reward_title")
	self.btnInfo = SoraDGetChildByName(self, "btnInfo")
	self.nodeContent = SoraDGetChildByName(self, "node_content")
	self.nodeProgressScore = SoraDGetChildByName(self, "node_progress_score")
	self.bgBarBg = SoraDGetChildByName(self, "bg_bar_bg")
	self.progressBarScoreP = SoraDGetChildByName(self, "progress_bar_score_p")
	self.bgProgressScore = SoraDGetChildByName(self, "bg_progress_score")
	self.txtProgress1 = SoraDGetChildByName(self, "txtProgress_1")
	self.txtProgress2 = SoraDGetChildByName(self, "txtProgress_2")
	self.txtProgress3 = SoraDGetChildByName(self, "txtProgress_3")
	self.txtProgress4 = SoraDGetChildByName(self, "txtProgress_4")
	self.txtProgress5 = SoraDGetChildByName(self, "txtProgress_5")
	self.legendStageTreasure_Node_1 = SoraDGetExtendChildFromCCSByName(self, "CCS_legendaryStageTreasure_Node_1")
	self.legendStageTreasure_Node_2 = SoraDGetExtendChildFromCCSByName(self, "CCS_legendaryStageTreasure_Node_2")
	self.legendStageTreasure_Node_3 = SoraDGetExtendChildFromCCSByName(self, "CCS_legendaryStageTreasure_Node_3")
	self.legendStageTreasure_Node_4 = SoraDGetExtendChildFromCCSByName(self, "CCS_legendaryStageTreasure_Node_4")
	self.legendStageTreasure_Node_5 = SoraDGetExtendChildFromCCSByName(self, "CCS_legendaryStageTreasure_Node_5")
	self.txtScore = SoraDGetChildByName(self, "txtScore")
	self.btnRank = SoraDGetChildByName(self, "btn_rank")
	self.frameMaintenanceR = SoraDGetChildByName(self, "frame_maintenance_R")
	self.frameMaintenanceL = SoraDGetChildByName(self, "frame_maintenance_L")
	self.img_black = SoraDGetChildByName(self, "img_black")
	self.node_noAlliance = SoraDGetChildByName(self, "node_noAlliance")
	self.textTip = SoraDGetChildByName(self, "text_tip")
	self.textTip:setString(i18n("free_team_text_67"))
	self.btnJoin = SoraDGetChildByName(self, "btnJoin")
	self.btnJoin:setTitleText(i18n("common_text_068"))
	self.btnInfo:addTouchEventListener(handler(self, self.onClick_btnInfo))
	self.btnRank:addTouchEventListener(handler(self, self.onClick_btnRank))
	self.node_noAlliance:setVisible(false)
	self.btnJoin:addTouchEventListener(handler(self, self.onClick_btnJoin))
	_ENV = handler(self, self.onClick_btnJoin)
	handler(self, self.onClick_btnJoin).num = 1
	self.legendStageTreasure_Node_1:setTitle(i18n("common_text_3198", handler(self, self.onClick_btnJoin)))
	_ENV = i18n("common_text_3198", handler(self, self.onClick_btnJoin))
	i18n("common_text_3198", handler(self, self.onClick_btnJoin)).num = 2
	self.legendStageTreasure_Node_2:setTitle(i18n("common_text_3198", i18n("common_text_3198", handler(self, self.onClick_btnJoin))))
	_ENV = i18n("common_text_3198", i18n("common_text_3198", handler(self, self.onClick_btnJoin)))
	i18n("common_text_3198", i18n("common_text_3198", handler(self, self.onClick_btnJoin))).num = 3
	self.legendStageTreasure_Node_3:setTitle(i18n("common_text_3198", i18n("common_text_3198", i18n("common_text_3198", handler(self, self.onClick_btnJoin)))))
	_ENV = i18n("common_text_3198", i18n("common_text_3198", i18n("common_text_3198", handler(self, self.onClick_btnJoin))))
	i18n("common_text_3198", i18n("common_text_3198", i18n("common_text_3198", handler(self, self.onClick_btnJoin)))).num = 4
	self.legendStageTreasure_Node_4:setTitle(i18n("common_text_3198", i18n("common_text_3198", i18n("common_text_3198", i18n("common_text_3198", handler(self, self.onClick_btnJoin))))))
	_ENV = i18n("common_text_3198", i18n("common_text_3198", i18n("common_text_3198", i18n("common_text_3198", handler(self, self.onClick_btnJoin)))))
	i18n("common_text_3198", i18n("common_text_3198", i18n("common_text_3198", i18n("common_text_3198", handler(self, self.onClick_btnJoin))))).num = 5
	self.legendStageTreasure_Node_5:setTitle(i18n("common_text_3198", i18n("common_text_3198", i18n("common_text_3198", i18n("common_text_3198", i18n("common_text_3198", handler(self, self.onClick_btnJoin)))))))
	_UPVALUE5_ = self.legendStageTreasure_Node_5.setTitle
	self.treasureBoxes, self.legendStageTreasure_Node_5.setTitle[1] = self.legendStageTreasure_Node_5.setTitle, self.legendStageTreasure_Node_1
	self.treasureBoxes, self.legendStageTreasure_Node_5.setTitle[2] = self.legendStageTreasure_Node_5.setTitle, self.legendStageTreasure_Node_2
	self.treasureBoxes, self.legendStageTreasure_Node_5.setTitle[3] = self.legendStageTreasure_Node_5.setTitle, self.legendStageTreasure_Node_3
	self.treasureBoxes, self.legendStageTreasure_Node_5.setTitle[4] = self.legendStageTreasure_Node_5.setTitle, self.legendStageTreasure_Node_4
	self.treasureBoxes, self.legendStageTreasure_Node_5.setTitle[5] = self.legendStageTreasure_Node_5.setTitle, self.legendStageTreasure_Node_5
	self.img_bg = SoraDGetChildByName(self, "img_bg")
end
function legendaryStageContent:setFitH(fitH)
	print("fitH = ", fitH)
	if self.img_bg then
		self.img_bg:setScale(fitH / 372)
		self.img_black:setContentSize(cc.size(640, fitH))
		self.lineL:setContentSize(cc.size(54, fitH - 26))
		self.lineR:setContentSize(cc.size(54, fitH - 26))
	end
	_UPVALUE6_ = self.lineR.setContentSize
	self.lineR.setContentSize[1] = self.nodeProgressScore
	self.lineR.setContentSize[2] = self.legendStageTreasure_Node_1
	self.lineR.setContentSize[3] = self.legendStageTreasure_Node_2
	self.lineR.setContentSize[4] = self.legendStageTreasure_Node_3
	self.lineR.setContentSize[5] = self.legendStageTreasure_Node_4
	local self.lineR.setContentSize[6], nodesArray = self.legendStageTreasure_Node_5, self.lineR.setContentSize
	if 490 < fitH then
		local deltaH = (fitH - 490) / 2
		for _, v in ipairs(nodesArray) do
			v:setPositionY(v:getPositionY() - deltaH)
		end
	end
end
function legendaryStageContent:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function legendaryStageContent:init(data)
	self.rewardType = data.rewardType
	self.stageType = data.stageType
	self.mapid = data.mapid
	if self.stageType == gLegendStageType.KING then
		if self.img_bg then
			self.img_bg:loadTexture("bg_junwang_jieduanmubiaobeijing.png", ccui.TextureResType.plistType)
		end
	elseif self.stageType == gLegendStageType.KING_STAR then
	elseif self.img_bg then
		self.img_bg:loadTexture("bg_bazhu_jieduanmubiaobeijing.png", ccui.TextureResType.plistType)
	end
	local stageInfo = legendStageRewardCtrl:getStageInfo()
	local score, scoreKey, titleKey
	if self.rewardType == gLegendStageRewardType.PERSONAL then
		score = stageInfo.personScore
		scoreKey = "common_text_1256"
		titleKey = "common_text_3142"
		self.btnRank:setVisible(false)
		_ENV = nil
		;(nil).num = string.formatnumberthousands(score)
		self.txtScore:setString(i18n(scoreKey, nil))
		legendTeamCtrl = i18n(scoreKey, nil)
		i18n(scoreKey, nil)[1] = self.frameMaintenanceL
		i18n(scoreKey, nil)[2] = self.txtScore
		i18n(scoreKey, nil)[3] = self.frameMaintenanceR
		gametop = self.txtScore
		self.txtScore[1] = 15
		self.txtScore[2] = 15
		SoraDAlignNodeArrayOnCenterX(320, i18n(scoreKey, nil))
	elseif self.rewardType == gLegendStageRewardType.ALLIANCE then
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		scoreKey = "free_team_text_68"
		titleKey = "free_team_text_69"
		if not legendTeamCtrl:isHasTeam() and not kingStarTeamCtrl:isHasTeam() then
			self.node_noAlliance:setVisible(true)
			self.nodeContent:setVisible(false)
			self.labelRewardTitle:setString(i18n(titleKey))
			return
		else
			self.node_noAlliance:setVisible(false)
			self.nodeContent:setVisible(true)
		end
		score = stageInfo.allianceScore
		_ENV = i18n(titleKey)
		i18n(titleKey).num = string.formatnumberthousands(score)
		self.txtScore:setString(i18n(scoreKey, i18n(titleKey)))
		kingStarTeamCtrl = i18n(scoreKey, i18n(titleKey))
		i18n(scoreKey, i18n(titleKey))[1] = self.frameMaintenanceL
		i18n(scoreKey, i18n(titleKey))[2] = self.txtScore
		i18n(scoreKey, i18n(titleKey))[3] = self.btnRank
		i18n(scoreKey, i18n(titleKey))[4] = self.frameMaintenanceR
		legendTeamCtrl = self.txtScore
		self.txtScore[1] = 15
		self.txtScore[2] = 15
		self.txtScore[3] = 15
		SoraDAlignNodeArrayOnCenterX(320, i18n(scoreKey, i18n(titleKey)))
		if legendStageRewardCtrl:isActivityPrepare(self.stageType) then
			self.btnRank:setBright(false)
		end
	end
	self.score = score
	self.labelRewardTitle:setString(i18n(titleKey))
	print("self.stageType,self.rewardTypeself.mapid ====== ", self.stageType, self.rewardType, self.mapid)
	local stageRewards = legendRewardRead.getStageRewardByType(self.stageType, self.rewardType, self.mapid)
	self.txtProgress1:setString(string.formatnumberthousands(stageRewards[1].needscore))
	self.txtProgress2:setString(string.formatnumberthousands(stageRewards[2].needscore))
	self.txtProgress3:setString(string.formatnumberthousands(stageRewards[3].needscore))
	self.txtProgress4:setString(string.formatnumberthousands(stageRewards[4].needscore))
	self.txtProgress5:setString(string.formatnumberthousands(stageRewards[5].needscore))
	for i = 1, 5 do
		_ENV = string.formatnumberthousands(stageRewards[5].needscore)
		string.formatnumberthousands(stageRewards[5].needscore).stage = i
		string.formatnumberthousands(stageRewards[5].needscore).stageType = self.stageType
		string.formatnumberthousands(stageRewards[5].needscore).rewardType = self.rewardType
		string.formatnumberthousands(stageRewards[5].needscore).score = score
		string.formatnumberthousands(stageRewards[5].needscore).maxScore = maxScore
		string.formatnumberthousands(stageRewards[5].needscore).needScore = stageRewards[i].needscore
		string.formatnumberthousands(stageRewards[5].needscore).totalPrice = stageRewards[i].totalPrice
		string.formatnumberthousands(stageRewards[5].needscore).mapid = self.mapid
		self.treasureBoxes[i]:init(string.formatnumberthousands(stageRewards[5].needscore))
	end
end
function legendaryStageContent:onMessageListener()
end
function legendaryStageContent:onClick_btnInfo(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panelStageHelp = SoraDCreatePanel("legendaryStageHelp")
		_ENV = nil
		;(nil).rewardType = self.rewardType
		;(nil).stageType = self.stageType
		;(nil).score = self.score
		;(nil).mapid = self.mapid
		panelStageHelp:init(nil)
		panelStageHelp:show()
	end
end
function legendaryStageContent:onClick_btnRank(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if legendStageRewardCtrl:isActivityPrepare(self.stageType) then
			SoraDShowMsgTip(i18n("common_text_2486"))
			return
		end
		local panelStageHelp = SoraDCreatePanel("legendaryStageRank")
		panelStageHelp:init(self.stageType)
		panelStageHelp:show()
	end
end
function legendaryStageContent:onClick_btnJoin(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local legendTeamUtil = include("legendTeamUtil")
		legendTeamUtil.openView(self.stageType == gLegendStageType.KING_STAR and worldMapDefine.KINGSTAR_KINGDOM_ID or nil)
	end
end
return legendaryStageContent
