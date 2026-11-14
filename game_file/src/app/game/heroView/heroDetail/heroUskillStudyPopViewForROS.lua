local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local publicRead = include("publicRead")
local BAR_LEN = 460
local heroUskillStudyPopViewForROS = class("heroUskillStudyPopViewForROS", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("heroUskillStudyPopViewForROS")
	end
	return target
end)
function heroUskillStudyPopViewForROS:ctor()
	self:initControls()
end
function heroUskillStudyPopViewForROS:initControls()
	self.Image_bg = SoraDGetChildByName(self, "Image_bg")
	self.Image_bg:setFillType(1)
	self.nodeWin = SoraDGetChildByName(self, "node_win")
	self.nodeLose = SoraDGetChildByName(self, "node_lose")
	self.txtWin = SoraDGetChildByName(self, "text_win")
	self.txtLose = SoraDGetChildByName(self, "text_lose")
	self.txtTitle = SoraDGetChildByName(self, "Text_name")
	self.txtWinOriginal = SoraDGetChildByName(self, "text_original")
	self.txtLoseOriginal = SoraDGetChildByName(self, "text_original_0")
	self.txtSkillNameOriginal = SoraDGetChildByName(self, "Text_skillName")
	self.txtBuffOriginal = SoraDGetChildByName(self, "Text_oriBuff")
	self.txtNowTitle = SoraDGetChildByName(self, "text_now")
	self.txtNowSkillName = SoraDGetChildByName(self, "Text_skillName_now")
	self.txtNowBuff = SoraDGetChildByName(self, "Text_oriBuff_now")
	self.txtNowBuffPre = SoraDGetChildByName(self, "Text_preBuff")
	self.txtTipWin = SoraDGetChildByName(self, "text_tipWin")
	self.spSkillIconWin = SoraDGetChildByName(self, "Sprite_skill")
	self.spSkillIconWinNow = SoraDGetChildByName(self, "Sprite_skill_now")
	self.panel = SoraDGetChildByName(self, "Panel_cut")
	self.imgBarSkillWin = SoraDGetChildByName(self.nodeWin, "Bar_skill")
	self.imgBarSkillWinNow = SoraDGetChildByName(self.nodeWin, "Bar_skill_now")
	self.panelPreWinOri = SoraDGetChildByName(self.imgBarSkillWin, "Panel_pre")
	self.panelPreWinOri:setSwallowTouches(false)
	self.panelPreWinNow = SoraDGetChildByName(self.imgBarSkillWinNow, "Panel_pre")
	self.panelPreWinNow:setSwallowTouches(false)
	self.panelAfterWinNow = SoraDGetChildByName(self.imgBarSkillWinNow, "Panel_now")
	self.panelAfterWinNow:setSwallowTouches(false)
	self.txtLoseSkillName = SoraDGetChildByName(self, "Text_skillName_0")
	self.txtLoseBuffValue = SoraDGetChildByName(self, "Text_oriBuff_0")
	self.imgBarSkillLose = SoraDGetChildByName(self.nodeLose, "Bar_skill_0")
	self.panelPreLose = SoraDGetChildByName(self.imgBarSkillLose, "Panel_pre")
	self.txtTipLose = SoraDGetChildByName(self, "text_tipLose")
	self.spSkillIconLose = SoraDGetChildByName(self, "Sprite_skill_0")
	self.frameBuff = SoraDGetChildByName(self, "frame_buff")
	self.Button_awake = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_awake")
	self.Button_awake:addTouchEventListener(handler(self, self.btnAwakeClick))
	self.panel:setPositionY(display.height / 2)
	self.Button_awake:setTitleStr(i18n("heroskill_btn_02"))
	self.isEnoughChip = false
	self.imgScouring = display.newSprite("#font_slim_sessesful_en.png")
	if SoraDFIsRA() then
		self.imgScouring:setSpriteFrame("font_slim_sessesful_ar.png")
	end
	self.imgScouring:setPosition(cc.p(320, display.height / 2 + 190))
	self.imgScouring:setVisible(false)
	self.imgScouring:addTo(self, 20)
end
function heroUskillStudyPopViewForROS:setBarOri(oriVal, maxVal, barName)
	if barName then
		SoraDGetChildByName(barName, "Image_bar"):loadTexture("progressbar_alliance_yellow.png", ccui.TextureResType.plistType)
		barName:setContentSize(cc.size(BAR_LEN * (oriVal / maxVal), 21))
	end
end
function heroUskillStudyPopViewForROS:setBarUpgrade(oriVal, preVal, maxVal, isNoPreVal)
	if oriVal <= preVal then
		SoraDGetChildByName(self.panelPreWinNow, "Image_bar"):loadTexture("progressbar_alliance_yellow.png", ccui.TextureResType.plistType)
		SoraDGetChildByName(self.panelAfterWinNow, "Image_bar"):loadTexture("progressbar_01_green1.png", ccui.TextureResType.plistType)
		self.panelPreWinNow:setContentSize(cc.size(BAR_LEN * (oriVal / maxVal), 21))
		self.panelAfterWinNow:setContentSize(cc.size(BAR_LEN * (preVal / maxVal), 21))
	else
		if isNoPreVal then
			SoraDGetChildByName(self.panelAfterWinNow, "Image_bar"):loadTexture("progressbar_alliance_yellow.png", ccui.TextureResType.plistType)
		else
			SoraDGetChildByName(self.panelPreWinNow, "Image_bar"):loadTexture("progressbar_alliance_yellow.png", ccui.TextureResType.plistType)
			SoraDGetChildByName(self.panelAfterWinNow, "Image_bar"):loadTexture("progressbar_01_red.png", ccui.TextureResType.plistType)
		end
		self.panelPreWinNow:setContentSize(cc.size(BAR_LEN * (preVal / maxVal), 21))
		self.panelAfterWinNow:setContentSize(cc.size(BAR_LEN * (oriVal / maxVal), 21))
	end
end
function heroUskillStudyPopViewForROS:initData(isSuccess, data, preBuff, afterBuff, isCrit)
	SoraDCloseLoading(self)
	self.heroExInfo = heroltCtrl.getHeroInfo(data.heroID)
	local skillInfo = heroltCtrl:getStuntSkillInfo(data.skillID)
	local costInfo = heroltCtrl:getAwakeCost(data.heroID)
	self.itemID = costInfo.id
	self.itemNum = backpackCtrl:getItemCount(self.itemID)
	self.needNum = costInfo.num
	self.heroID = data.heroID
	self.skillID = data.skillID
	self.afterBuff = afterBuff
	self.nodeWin:setVisible(isSuccess)
	self.nodeLose:setVisible(not isSuccess)
	self.txtWin:setString(i18n("hero_comprehend_text_03"))
	self.txtWinOriginal:setString(i18n("hero_comprehend_text_04"))
	_ENV = i18n("hero_comprehend_text_04")
	i18n("hero_comprehend_text_04").name = i18n(self.heroExInfo.herName)
	self.txtTitle:setString(i18n("heroskill_title_02", i18n("hero_comprehend_text_04")))
	self.txtSkillNameOriginal:setString(i18n(skillInfo.des))
	if self.txtSkillNameOriginal:getContentSize().width > 300 then
		SoraDSetTextWidthHeight(self.txtSkillNameOriginal, cc.size(300, 40))
	end
	self.spSkillIconWin:setSpriteFrame(skillInfo.icon)
	self.spSkillIconWinNow:setSpriteFrame(skillInfo.icon)
	self.txtBuffOriginal:setString(SoraDPreciseDecimal(preBuff / 1000, 4) * 100 .. "%")
	self.txtBuffOriginal:setPositionX(self.txtSkillNameOriginal:getContentSize().width + self.txtSkillNameOriginal:getPositionX() + 10)
	self.txtNowTitle:setString(i18n("hero_comprehend_text_05"))
	self.txtNowSkillName:setString(i18n(skillInfo.des))
	if self.txtNowSkillName:getContentSize().width > 180 then
		SoraDSetTextWidthHeight(self.txtNowSkillName, cc.size(180, 40))
	end
	self.txtNowBuff:setString(SoraDPreciseDecimal(preBuff / 1000, 4) * 100 .. "%")
	self.txtNowBuff:setPositionX(self.txtNowSkillName:getPositionX() + self.txtNowSkillName:getContentSize().width + 10)
	local char = 0 < afterBuff - preBuff and "+" or ""
	local valueNow = afterBuff - preBuff
	self.txtNowBuffPre:setString(char .. SoraDPreciseDecimal(valueNow / 1000, 4) * 100 .. "%")
	self.txtTipWin:setString(i18n("hero_comprehend_text_06"))
	self.txtNowBuffPre:setColor(isCrit and cc.c3b(255, 255, 0, 1) or cc.c3b(0, 190, 30))
	self.frameBuff:setSpriteFrame(isCrit and "img_lwbj_jiantou.png" or "frame_YX_juejiup.png")
	self:setBarOri(preBuff, heroltCtrl:getMaxBuffValue(data.skillID), self.panelPreWinOri)
	self:setBarUpgrade(preBuff, afterBuff, heroltCtrl:getMaxBuffValue(data.skillID))
	local rarity = heroltCtrl:getRarity(self.heroID)
	if (rarity == gHeroRarity.BLUE or rarity == gHeroRarity.PURPLE or rarity == gHeroRarity.ORANGE) and isSuccess and clientEventMgr.judgeIsOpen(gActivityTimeActivityID.HERO_AWAKE_ACTIVTY) then
		local isShowEffect = true
		if valueNow <= 0 then
			isShowEffect = false
		end
		if isShowEffect then
			publicRead = afterBuff
			afterBuff[1] = cca.delay(0.5)
			afterBuff[2] = cca.callFunc(function()
				self:showInsightBonusEffect()
				self.imgScouring:setVisible(true)
			end)
			afterBuff[3] = cca.delay(1.0)
			afterBuff[4] = cca.callFunc(function()
				self.imgScouring:setVisible(false)
			end)
			afterBuff[5] = cca.callFunc(function()
				self.imgScouring:setVisible(false)
			end)
			local seq = cca.seq(afterBuff)
			self:runAction(seq)
		end
	end
	self.txtLose:setString(i18n("hero_comprehend_text_01"))
	self.txtLoseOriginal:setString(i18n("hero_comprehend_text_04"))
	self.txtLoseSkillName:setString(i18n(skillInfo.des))
	if self.txtLoseSkillName:getContentSize().width > 260 then
		SoraDSetTextWidthHeight(self.txtLoseSkillName, cc.size(260, 40))
	end
	self.txtLoseBuffValue:setString(SoraDPreciseDecimal(preBuff / 1000, 4) * 100 .. "%")
	self.txtLoseBuffValue:setPositionX(self.txtLoseSkillName:getContentSize().width + self.txtLoseSkillName:getPositionX() + 10)
	self:setBarOri(preBuff, heroltCtrl:getMaxBuffValue(data.skillID), self.panelPreLose)
	self.txtTipLose:setString(i18n("hero_comprehend_text_02"))
	self.spSkillIconLose:setSpriteFrame(skillInfo.icon)
	self.Button_awake:setIconTexture(publicRead.getIcon(self.itemID))
	_ENV = publicRead.getIcon(self.itemID)
	publicRead.getIcon(self.itemID).total = self.itemNum
	publicRead.getIcon(self.itemID).member = costInfo.num
	self.Button_awake:setGoldText(i18n("common_text_155", publicRead.getIcon(self.itemID)))
	self.isEnoughChip = self.itemNum >= costInfo.num
	self.Button_awake:setTextGoldColor(self.isEnoughChip and cc.c3b(255, 255, 0) or cc.c3b(190, 40, 40))
	SoraDSetTextWidthHeight(self.txtNowTitle, cc.size(140, 40))
	self.txtNowTitle:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	self.txtNowTitle:setTextVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	SoraDSetTextWidthHeight(self.txtWinOriginal, cc.size(140, 40))
	self.txtWinOriginal:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	self.txtWinOriginal:setTextVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	SoraDSetTextWidthHeight(self.txtLoseOriginal, cc.size(140, 40))
	self.txtLoseOriginal:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	self.txtLoseOriginal:setTextVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	SoraDSetTextWidthHeight(self.txtTipWin, cc.size(500, 40))
	SoraDSetTextWidthHeight(self.txtTipLose, cc.size(500, 100))
end
function heroUskillStudyPopViewForROS:showInsightBonusEffect()
	if self.effectScouring then
		SoraDResetEffectNode(self.effectScouring)
		self.effectScouring.action:gotoFrameAndPlay(0, 57, false)
	else
		self.effectScouring = SoraDCreatAnimationEx("Node_Effect_xljc", nil, false)
		self.effectScouring:setPosition(320, display.height / 2)
		self.effectScouring:addTo(self, 10)
	end
end
function heroUskillStudyPopViewForROS:btnAwakeClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isEnoughChip then
			if not IsArClient and self.afterBuff >= heroltCtrl:getMaxBuffValue(self.skillID) then
				SoraDShowMsgTip(i18n("skill_text_17"))
				return
			end
			local remake = function(isCheck)
				if isCheck ~= nil then
					GAME_HERO_REMAKE_SHOW = isCheck
				end
				SoraDShowLoading(self)
				SoraDPlaySound("uicontrol", 21)
				heroCtrl:remakeSkillReq(self.heroID, self.skillID, self.itemID)
			end
			remake()
		else
			SoraDShowMsgBox(i18n("heroskill_text_04"), i18n("common_text_054"), i18n("common_text_185"), function(eventType)
				if MSGBOX_CALLBACK_YES == eventType then
					_ENV = nil
					;(nil).itemID = self.itemID
					;(nil).needCount = self.needNum
					uiManager:show("newHeroGainChipMethodView", nil)
				end
			end)
		end
	end
end
return heroUskillStudyPopViewForROS
