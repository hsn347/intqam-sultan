local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local constantRead = include("constantRead")
local worldMapComAtlantis = class("worldMapComAtlantis", include("worldMapCom"))
function worldMapComAtlantis:ctor()
	worldMapComAtlantis.super.ctor(self, "worldMapComAtlantis")
end
function worldMapComAtlantis:init()
	self.isSkillShow = false
	self:initWidget()
end
function worldMapComAtlantis:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_REFRESH_WARDATA", handler(self, self.refreshWarData))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_REFRESH_CAMPMAP", handler(self, self.refreshCampMap))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_SKILL_LOTTERY", handler(self, self.onMessageSkillLottery))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_SKILL_REPLACE", handler(self, self.onMessageSkillReplace))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_SKILL_USE", handler(self, self.onMessageSkillUse))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_SKILL_SELECT", handler(self, self.onMessageSkillSelect))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_BUFF_NOTIFY", handler(self, self.onMessageSkillNotify))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_SKILLBTN_EFFECT", handler(self, self.refreshSkillBtnEffect))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_BUYGIFT_SUCCESS", handler(self, self.onMessageBuyGiftSuccess))
	local worldMapEvent = include("worldMapEvent")
	self:addEventListener(worldMapEvent.EVENT_SCROLL_LOD_CHANGE, handler(self, self.updateLodChange))
	self:doReqestData()
end
function worldMapComAtlantis:doReqestData(...)
	local mapId = worldMapDefine.currentMapKindomID
	atlantisWarCtrl:reqWarData(mapId)
	SoraDShowLoading()
end
function worldMapComAtlantis:relogin()
	self.isSkillShow = false
	self.ccs_skill:setStateShow(self.isSkillShow)
	self:refreshSkillBtnEffect()
end
function worldMapComAtlantis:initWidget(...)
	self.Node_war = SoraDGetChildByName(self.target_, "Node_war")
	local atlantisWarUtil = include("atlantisWarUtil")
	local warInfo = atlantisWarUtil.getWorldMapAtlantisWarInfo()
	warInfo:setStageChangeHandle(handler(self, self.refreshWarStage))
	self.ccs_warInfo = warInfo
	self.ccs_skill = SoraDGetExtendChildFromCCSByName(self.Node_war, "CCS_worldMapAtlantisSkill_1")
	self.ccs_skill:setStateShow(self.isSkillShow)
	_UPVALUE5_ = self.ccs_skill
	self.ccs_skill[1] = "Button_skill"
	self.ccs_skill[2] = "Button_miniMap"
	self.ccs_skill[3] = "Button_marshal"
	self.ccs_skill[4] = "Button_hospital"
	self.ccs_skill[5] = "Button_quitBattle"
	for i, v in ipairs(self.ccs_skill) do
		self[v] = SoraDGetChildByName(self.Node_war, v)
	end
	self.Button_skill:addTouchEventListener(handler(self, self.btnSkillClick))
	self:refreshSkillBtnEffect()
	self.Button_miniMap:addTouchEventListener(handler(self, self.btnMiniMapClick))
	self.Button_marshal:addTouchEventListener(handler(self, self.btnMarshalClick))
	self.Button_marshal:setVisible(false)
	self.Button_hospital:setPositionY(455)
	SoraDGetAllChildFromWidget(self.Button_marshal, self)
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Text_time:setTimeLast(function(__, time)
		return SoraDConvertSecondToStringNoDayNoHour(time)
	end)
	self.Text_time:setTimeEndListener(handler(self, self.refreshMarshalTime))
	self.Button_quitBattle:setTitleText(i18n("common_text_3351"))
	SoraDAutoSizeButtonTextByContent(self.Button_quitBattle)
	self.Button_quitBattle:addTouchEventListener(handler(self, self.btnQuitClick))
	self.Button_quitBattle:setVisible(false)
	self:fitNodeBottom()
end
function worldMapComAtlantis:fitNodeBottom()
	local fitHeight = 1136
	if fitHeight <= display.height then
		return
	end
	local fitWidth = fitHeight / display.height * 640
	local fitScale = 640 / fitWidth
	self.Node_war:setScale(fitScale)
	local posXSearch = self.Button_quitBattle:getPositionX()
	self.Button_quitBattle:setPositionX(posXSearch * (1 / fitScale))
end
function worldMapComAtlantis:checkShowSkillEffect(...)
	local skillSlot = atlantisActivityCtrl:getSkillData("skillSlot")
	local time_cd = constantRead.getConstValue("ATLANTIS_WAR_SKILL_CD", 0)
	for k, skill in pairs(skillSlot) do
		local lastUseTime = skill.lastUseTime
		if not (lastUseTime and 0 < lastUseTime) or not (lastUseTime + time_cd > serviceFunctions.systemTime()) then
			return true
		end
	end
	local buffList = atlantisWarCtrl:getPlayerBuffList()
	for k, v in pairs(buffList) do
		if ATLANTIS_WAR_BOSS_ACTIVE_BUFF[v.effect] and (v.effect ~= gBuffEffect.ATLANTIS_WAR_JUDGE or v.effect == gBuffEffect.ATLANTIS_WAR_JUDGE and 0 < v.value) then
			return true
		end
	end
end
function worldMapComAtlantis:refreshSkillBtnEffect(...)
	if self:checkShowSkillEffect() and not self.isSkillShow then
		if not self.skillBtnEffect then
			local criSprite = cc.criSprite.createCriSprite("G_shahaiUI_01.usm", false, true, nil)
			criSprite:addTo(self.Button_skill, 1)
			criSprite:setBlendFunc(gl.ONE, gl.ONE)
			if SoraDFIsRA() then
				criSprite:setPosition(12, 49)
			else
				criSprite:setPosition(75, 49)
				criSprite:setScale(-1, 1)
			end
			self.skillBtnEffect = criSprite
		end
		self.skillBtnEffect:setVisible(true)
		self.skillBtnEffect:runAction(cca.fadeTo(0.1, 1))
	elseif self.skillBtnEffect and self.skillBtnEffect:isVisible() then
		_UPVALUE1_ = cca.fadeTo(0.1, 1)
		cca.fadeTo(0.1, 1)[1] = cca.fadeTo(0.1, 0)
		cca.fadeTo(0.1, 1)[2] = cca.callFunc(function()
			self.skillBtnEffect:setVisible(false)
		end)
		cca.fadeTo(0.1, 1)[3] = cca.callFunc(function()
			self.skillBtnEffect:setVisible(false)
		end)
		self.skillBtnEffect:runAction(cca.seq(cca.fadeTo(0.1, 1)))
	end
end
function worldMapComAtlantis:refreshWarStage(...)
	local stage = atlantisWarCtrl:getWarStage()
	print("==worldMapComAtlantis:refreshWarStage==", stage)
	if stage >= gAtlantisWarStageType.warAreaIng then
		self.Button_marshal:setVisible(true)
		self.Button_hospital:setPositionY(540)
		self:refreshMarshalTime()
		atlantisWarCtrl = self
		self.msg = "MESSAGE_MAINUIBOTTOM_SORTBOTTOMQUESTBTNS"
		SoraDSendMessage(self)
	end
	if stage >= gAtlantisWarStageType.battleEnd then
		self.Button_quitBattle:setVisible(true)
	end
end
function worldMapComAtlantis:refreshMarshalTime(...)
	local time = atlantisWarCtrl:getMarshalTime()
	if 0 < time then
		self.Text_time:beginTime(time)
	end
end
function worldMapComAtlantis:btnSkillClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.isSkillShow = not self.isSkillShow
		self.ccs_skill:setStateShow(self.isSkillShow)
		self:refreshSkillBtnEffect()
	end
end
function worldMapComAtlantis:btnMiniMapClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:switchMiniView(true)
	end
end
function worldMapComAtlantis:switchMiniView(tips)
	local parent = display.getRunningScene().panelView
	local panel = SoraDGetChildByName(parent, "atlantisWarMiniMap", true)
	local show = false
	if not panel then
		panel = SoraDCreatePanelByFixName("atlantisWarMiniMap")
		panel:setName("atlantisWarMiniMap")
		parent:addChild(panel)
		panel:setPositionX(display.cx - SoraDFSign(50))
		show = true
	else
		panel:removeFromParent()
	end
	if tips then
		if show then
			SoraDShowMsgTip(i18n("remains_text_368"))
		else
			SoraDShowMsgTip(i18n("remains_text_369"))
		end
	end
	return show
end
function worldMapComAtlantis:btnMarshalClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("atlantisMarshalView"):show()
	end
end
function worldMapComAtlantis:btnQuitClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if worldMapDefine.isInAtlantis() then
			atlantisActivityCtrl:reqQuitBattlefield()
		end
	end
end
function worldMapComAtlantis:refreshWarData(...)
	self.ccs_warInfo:setVisible(true)
	self.ccs_warInfo:initData()
	self.ccs_skill:initData()
	self:refreshWarStage()
end
function worldMapComAtlantis:refreshCampMap(...)
	self.ccs_warInfo:refreshCampMap()
end
function worldMapComAtlantis:onMessageSkillLottery(target, event)
	local index = event.index
	self.candidateSkill = atlantisActivityCtrl:getSkillData("candidateSkill")
	if self.candidateSkill[tostring(index)] then
		return
	end
	self.ccs_skill:refreshOutWarSingle(index)
	self:refreshSkillBtnEffect()
end
function worldMapComAtlantis:onMessageSkillReplace(target, event)
	local index = event.index
	self.ccs_skill:refreshOutWarSingle(index)
end
function worldMapComAtlantis:onMessageSkillUse(target, event)
	local index = event.index
	self.ccs_skill:refreshOutWarSingle(index)
	self:refreshSkillBtnEffect()
end
function worldMapComAtlantis:onMessageSkillSelect(target, event)
	local index = event.index
	self.ccs_skill:refreshOutWarSingle(index)
end
function worldMapComAtlantis:onMessageSkillNotify(target, event)
	local notifyType = event.notifyType
	local notifyData = event.notifyData
	local buffId = event.buffId
	local buffEffect = event.buffEffect or notifyData.effect
	if not ATLANTIS_WAR_BOSS_ACTIVE_BUFF[buffEffect] then
		return
	end
	if notifyType == "addPlayerBuff" then
		self.ccs_skill:addInWarSingle(buffId)
	elseif notifyType == "removePlayerBuff" then
		self.ccs_skill:removeInWarSingle(buffId)
	elseif notifyType == "updatePlayerBuff" then
		self.ccs_skill:refreshInWarSingle(buffId)
	end
	self:refreshSkillBtnEffect()
end
function worldMapComAtlantis:onMessageBuyGiftSuccess(...)
	for i = 4, 5 do
		self.ccs_skill:refreshOutWarSingle(i)
	end
end
function worldMapComAtlantis:getBottomQuestBtnsOffsetY(...)
	local fitHeight = 1136
	local fitWidth = fitHeight / display.height * 640
	local fitScale = 640 / fitWidth
	local offsetY = 500
	if not self.Button_hospital:isVisible() then
		offsetY = offsetY - 85
	end
	if not self.Button_marshal:isVisible() then
		offsetY = offsetY - 85
	end
	return offsetY * fitScale
end
function worldMapComAtlantis:getWorldMapAtlantisSkill(...)
	return self.ccs_skill
end
function worldMapComAtlantis:getNodeWar()
	return self.Node_war
end
function worldMapComAtlantis:getNodeWarInfo()
	return self.ccs_warInfo
end
local worldLodDef = worldMapDefine.worldLodDef
function worldMapComAtlantis:updateLodChange(event)
	local lod = event.lod
	if lod >= worldLodDef.LOD2 then
		local parent = display.getRunningScene().panelView
		local panel = SoraDGetChildByName(parent, "atlantisWarMiniMap", true)
		if panel then
			panel:removeFromParent()
		end
	end
end
function worldMapComAtlantis:exportMethods()
	_UPVALUE4_ = nil
	;(nil)[1] = "getBottomQuestBtnsOffsetY"
	;(nil)[2] = "getWorldMapAtlantisSkill"
	;(nil)[3] = "getNodeWar"
	;(nil)[4] = "getNodeWarInfo"
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComAtlantis
