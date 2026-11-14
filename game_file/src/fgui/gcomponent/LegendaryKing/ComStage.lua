local gametop = gModuleMgr.getObject("gametop")
local legendStageRewardCtrl = gametop.playertop_:getModule("legendStageRewardCtrl")
local legendRewardRead = include("legendRewardRead")
local baseComponent = require("fgui.base.baseComponent")
local ComStage = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://LegendaryKing/ComStage", ComStage)
function ComStage:onInit()
	self.fields.effectBg.isCocos = true
	self.fields.effectTop.isCocos = true
end
function ComStage:onShow()
end
function ComStage:initData(stage, stageType, rewardType, score, maxScore, needScore, totalPrice, mapid, _realRewardType)
	self.rewardType = rewardType
	self.stageType = stageType
	self.mapid = mapid
	self.stage = stage
	self.score = score
	self.maxScore = maxScore
	self.needScore = needScore
	self.totalPrice = totalPrice
	self._realRewardType = _realRewardType
	local stageInfo = legendStageRewardCtrl:getStageInfo()
	local killAndLoseInfo = legendStageRewardCtrl:getKillAndLoseInfo()
	local isOpen = false
	local scoreEnough = false
	if self.score >= self.needScore then
		self.controllers.ctrlLock:setSelectedIndex(2)
		scoreEnough = true
	else
		self.controllers.ctrlLock:setSelectedIndex(0)
	end
	if self.rewardType == gLegendStageRewardType.PERSONAL then
		local personStageInfo
		if _realRewardType == gLegendStageRewardType.KILL then
			personStageInfo, legendStageRewardCtrl = killAndLoseInfo.personPalaceKillStageInfo, killAndLoseInfo.personPalaceKillStageInfo
			personStageInfo = killAndLoseInfo.personPalaceKillStageInfo or nil
			self.receiveStatus = personStageInfo[stage] and gPersonPalaceReceiveStatus.HAVE_RECEIVED or scoreEnough and gPersonPalaceReceiveStatus.NO_RECEIVE or gPersonPalaceReceiveStatus.CANNOT_RECEIVE
		elseif _realRewardType == gLegendStageRewardType.LOSE then
			personStageInfo, legendStageRewardCtrl = killAndLoseInfo.personPalaceLoseStageInfo, killAndLoseInfo.personPalaceLoseStageInfo
			personStageInfo = killAndLoseInfo.personPalaceLoseStageInfo or nil
			self.receiveStatus = personStageInfo[stage] and gPersonPalaceReceiveStatus.HAVE_RECEIVED or scoreEnough and gPersonPalaceReceiveStatus.NO_RECEIVE or gPersonPalaceReceiveStatus.CANNOT_RECEIVE
		elseif _realRewardType == gLegendStageRewardType.PERSONAL then
			personStageInfo = stageInfo.personStageInfo
			self.receiveStatus = personStageInfo[tostring(stage)] and personStageInfo[tostring(stage)].receiveStatus or 0
		end
		if _realRewardType == gLegendStageRewardType.PERSONAL then
			isOpen = self.receiveStatus == 1
		elseif _realRewardType == gLegendStageRewardType.LOSE or _realRewardType == gLegendStageRewardType.KILL then
			isOpen = self.receiveStatus == gPersonPalaceReceiveStatus.HAVE_RECEIVED
		end
		if isOpen then
			self.fields.img_icon:loadTexture("icon_recruitsupplies_box_02.png", ccui.TextureResType.plistType)
			self.fields.img_icon:setScale(0.9)
		else
			self.fields.img_icon:loadTexture("icon_recruitsupplies_box_01.png", ccui.TextureResType.plistType)
			self.fields.img_icon:setScale(1.0)
		end
		if (_realRewardType == gLegendStageRewardType.KILL or _realRewardType == gLegendStageRewardType.LOSE) and self.receiveStatus == gPersonPalaceReceiveStatus.NO_RECEIVE then
			self.controllers.ctrlLock:setSelectedIndex(1)
		end
	elseif self.rewardType == gLegendStageRewardType.ALLIANCE then
		if isOpen then
			self.fields.img_icon:loadTexture("icon_everydayVIP_box_open.png", ccui.TextureResType.plistType)
		else
			self.fields.img_icon:loadTexture("icon_everydayVIP_box_close.png", ccui.TextureResType.plistType)
		end
		self.fields.img_icon:setScale(1.2)
		local allianceStageInfo = stageInfo.allianceStageInfo
		self.receiveStatus = allianceStageInfo[tostring(stage)] and allianceStageInfo[tostring(stage)].receiveStatus or 0
		if self.receiveStatus == gAllianceReceiveStatus.CANNOT_RECEIVE then
			self.fields.img_icon:setGray(true)
			self:setEffectVisible(false)
			self.fields.yes:setVisible(false)
		end
	end
	local stageInfo = legendStageRewardCtrl:getStageInfo()
	local score, scoreKey, titleKey
	if self.rewardType == gLegendStageRewardType.PERSONAL then
		scoreKey = "common_text_1256"
		titleKey = "common_text_3142"
	elseif self.rewardType == gLegendStageRewardType.ALLIANCE then
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		scoreKey = "free_team_text_68"
		titleKey = "free_team_text_69"
		if legendStageRewardCtrl:isActivityPrepare(self.stageType) then
		end
	end
	local stageRewards = legendRewardRead.getStageRewardByType(self.stageType, _realRewardType or self.rewardType, self.mapid)
	self.fields.txtProgress:setString(string.formatnumberthousands(stageRewards[stage].needscore))
	legendStageRewardCtrl = string.formatnumberthousands(stageRewards[stage].needscore)
	string.formatnumberthousands(stageRewards[stage].needscore).num = stage
	self.fields.title:setString(i18n("common_text_3198", string.formatnumberthousands(stageRewards[stage].needscore)))
	self:updateRedDot()
end
function ComStage:setEffectVisible(isVisible)
	self.fields.effectBg:setVisible(isVisible)
	self.fields.effectTop:setVisible(isVisible)
end
function ComStage:updateRedDot(...)
	local stageInfo = legendStageRewardCtrl:getKillAndLoseInfo()
	local personStageInfo
	if self._realRewardType == gLegendStageRewardType.KILL then
		personStageInfo, legendStageRewardCtrl = stageInfo.personPalaceKillStageInfo, stageInfo.personPalaceKillStageInfo
		personStageInfo = stageInfo.personPalaceKillStageInfo or nil
	elseif self._realRewardType == gLegendStageRewardType.LOSE then
		personStageInfo, legendStageRewardCtrl = stageInfo.personPalaceLoseStageInfo, stageInfo.personPalaceLoseStageInfo
		personStageInfo = stageInfo.personPalaceLoseStageInfo or nil
	else
		self:setReddot(false, -1)
		return
	end
	local scoreEnough = self.score >= self.needScore
	self:setReddot(scoreEnough and not personStageInfo[self.stage], -1)
end
return ComStage
