local teamInfoSingle = include("teamInfoSingle")
local anchorDef = include("anchorDef")
local remainsWarRead = include("remainsWarRead")
local remainsWarltCtrl = include("remainsWarltCtrl")
local scrollNode = include("scrollNode")
local gQueueTargetStatusType = anchorDef.gQueueTargetStatusType
local anchorTeamInfoSingle = class("anchorTeamInfoSingle", function(target)
	target = teamInfoSingle.new(target)
	return target
end)
function anchorTeamInfoSingle:ctor()
	local remainsWarUtil = include("remainsWarUtil")
	self.isXianXia = remainsWarUtil.checkIsInRemainsXianXia()
end
local SINGLE_HEIGHT = 195
function anchorTeamInfoSingle:updateNodeData()
	for i, v in ipairs(self.tableSingleData) do
		local single = self:getSingle()
		self:setSingleView(single, v, i)
		single:setPositionY(-(i - 1) * SINGLE_HEIGHT)
		table.insert(self.scrollItems, single)
	end
end
function anchorTeamInfoSingle:setIsWar(isWar)
	self.isWar = isWar
end
function anchorTeamInfoSingle:getHeight()
	return #self.scrollItems * SINGLE_HEIGHT + 20
end
function anchorTeamInfoSingle:setShowStatus(showStatus)
	for _, v in ipairs(self.scrollItems) do
		local nodeStatus = SoraDGetChildByName(v, "Node_status")
		nodeStatus:setVisible(showStatus)
	end
end
function anchorTeamInfoSingle:setSingleView(single, headData, index)
	if self.isWar then
		local framehead = SoraDGetChildByName(single, "frame_head")
		if framehead then
			framehead:setTag(index)
			framehead:setScroll(self.scroll)
			framehead:addTouchEventListener(function()
				SoraDGotoWorldMapPoint(cc.p(headData.x, headData.y), true)
				SoraDRemoveAllPanelFromManager()
			end)
		end
	end
	do
		local iconhead = SoraDGetChildByName(single, "icon_head")
		SoraDGetHeadFromManager(iconhead, headData.headid, headData.avatar)
	end
	do
		local name = headData.nickName
		local allianceAbbr = headData.allianceAbb
		if allianceAbbr ~= nil and string.len(allianceAbbr) > 0 then
			_ENV = headData.avatar
			headData.avatar.abbr = allianceAbbr
			headData.avatar.name = headData.nickName
			name = i18n("common_text_186", headData.avatar)
		end
		if headData.fromKid then
			name = name .. "#" .. tostring(headData.fromKid)
		end
		local txtName = SoraDGetChildByName(single, "Text_name")
		txtName:setString(name)
	end
	do
		local txtDanNum = SoraDGetChildByName(single, "Text_dan_num")
		local strDanNum = remainsWarRead.getDanName(headData.segment)
		_ENV = nil
		;(nil).name = strDanNum
		txtDanNum:setString(i18n("remains_text_130", nil))
		local txtScoreNum = SoraDGetChildByName(single, "Text_score_num")
		local strScoreNum = string.formatnumberthousands(headData.point)
		if self.isXianXia then
			_ENV = i18n("remains_text_130", nil)
			i18n("remains_text_130", nil).num = strScoreNum
			txtScoreNum:setString(i18n("common_text_2556", i18n("remains_text_130", nil)))
		else
			_ENV = i18n("common_text_2556", i18n("remains_text_130", nil))
			i18n("common_text_2556", i18n("remains_text_130", nil)).num = strScoreNum
			txtScoreNum:setString(i18n("remains_text_128", i18n("common_text_2556", i18n("remains_text_130", nil))))
		end
		if self.isXianXia then
			SoraDGetChildByName(single, "Node_score_font"):setVisible(false)
		else
			local score = remainsWarltCtrl.getRuinsWarGrade(headData.point)
			local strScore = remainsWarRead.getScoreName(score)
			local txtScoreFont = SoraDGetChildByName(single, "Text_score_font")
			txtScoreFont:setString(strScore)
		end
	end
	do
		local nodeTip = SoraDGetChildByName(single, "Node_war_top")
		nodeTip:setVisible(not headData.isIn)
		if not headData.isIn then
			local txtWarTip = SoraDGetChildByName(single, "Text_war_tips")
			txtWarTip:setString(i18n("Anchor_text_07"))
		end
	end
	do
		local txtArmyNum = SoraDGetChildByName(single, "Text_army_num")
		local strArmyNum = string.formatnumberthousands(headData.killArmyFc or 0)
		_ENV = i18n("Anchor_text_07")
		i18n("Anchor_text_07").power = strArmyNum
		txtArmyNum:setString(i18n("remains_text_169", i18n("Anchor_text_07")))
		SoraDSetTextWidthHeight(txtArmyNum, cc.size(180, 42))
		local killNpcNum = (headData.killRedNpcNum or 0) + (headData.killBlueNpcNum or 0) + (headData.killMyBossNum or 0) + (headData.killZjssgBossNum or 0) + (headData.killBxmsBossNum or 0) + (headData.killMmjxBossNum or 0)
		local txtMonsterNum = SoraDGetChildByName(single, "Text_monster_num")
		if self.isXianXia then
			txtMonsterNum:setVisible(false)
		else
			local strMonsterNum = string.formatnumberthousands(killNpcNum)
			_ENV = cc.size(180, 42)
			cc.size(180, 42).num = strMonsterNum
			txtMonsterNum:setString(i18n("remains_text_129", cc.size(180, 42)))
		end
		local txtAttackNum = SoraDGetChildByName(single, "Text_attack_num")
		if self.isXianXia then
			txtAttackNum:setVisible(false)
		else
			local strAttackNum = string.formatnumberthousands(headData.atkCityWinNum or 0)
			_ENV = i18n("remains_text_129", cc.size(180, 42))
			i18n("remains_text_129", cc.size(180, 42)).count = strAttackNum
			txtAttackNum:setString(i18n("common_text_4406", i18n("remains_text_129", cc.size(180, 42))))
		end
	end
	local status = headData.beAttackStatus
	do
		local nodeAttack = SoraDGetChildByName(single, "Node_attack")
		if status == gQueueTargetStatusType.attacking then
			nodeAttack:setVisible(true)
		else
			nodeAttack:setVisible(false)
		end
	end
	do
		local nodeMass = SoraDGetChildByName(single, "Node_mass")
		if status == gQueueTargetStatusType.massing then
			nodeMass:setVisible(true)
		else
			nodeMass:setVisible(false)
		end
	end
	do
		local nodeDie = SoraDGetChildByName(single, "Node_die")
		local txtRefresh = SoraDGetChildByName(single, "Text_refresh_time")
		txtRefresh:setTimeEndListener(function()
			nodeDie:setVisible(false)
		end)
		local time = 0
		local moveCityCDEndTime = headData.moveCityCDEndTime
		if moveCityCDEndTime and 0 < moveCityCDEndTime then
			local sysTime = serviceFunctions.systemTime()
			if moveCityCDEndTime > sysTime then
				time = moveCityCDEndTime - sysTime
			end
		end
		if 0 < time then
			nodeDie:setVisible(true)
			txtRefresh:beginTime(time)
		else
			nodeDie:setVisible(false)
		end
	end
	do
		local labelPos = SoraDGetChildByName(single, "Text_pos")
		if self.isWar then
			local btnJump = SoraDGetChildByName(single, "Button_jump")
			btnJump:setScroll(self.scroll)
			labelPos:setString(tostring(headData.x) .. "," .. tostring(headData.y))
			SoraDDrawTextUnderLine(labelPos, cc.c4b(145, 140, 230, 255))
			btnJump:addTouchEventListener(function()
				SoraDGotoWorldMapPoint(cc.p(headData.x, headData.y), true)
				SoraDRemoveAllPanelFromManager()
			end)
		else
			labelPos:setString("")
		end
	end
end
function anchorTeamInfoSingle:initSingle(single)
	local framehead = SoraDGetChildByName(single, "frame_head")
	if framehead then
		framehead = scrollNode.new(framehead)
		framehead:setSwallowTouches(false)
	end
	local txtRefresh = SoraDGetChildByName(single, "Text_refresh_time")
	SoraDCreateTimerLabel(single, txtRefresh)
	local btnJump = SoraDGetChildByName(single, "Button_jump")
	scrollNode.new(btnJump)
end
return anchorTeamInfoSingle
