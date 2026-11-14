local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local publicRead = include("publicRead")
local heroUskillStudyView = class("heroUskillStudyView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroUskillStudyView")
	end
	return target
end)
function heroUskillStudyView:ctor()
	self.isEnoughChip = false
	self.isAllUp = false
	self.isSkillClick = false
	self.isFirstEnter = true
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_heroStudy")
	self.Button_chip = SoraDGetChildByName(self, "Button_chip")
	self.Button_chip:addTouchEventListener(handler(self, self.btnChipClick))
	self.Node_item = SoraDGetChildByName(self.Button_chip, "Node_item")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_scroll")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("heroUskillStudySingle")
	self.scrollSize = self.scroll:getContentSize()
	self.Text_maxTip = SoraDGetChildByName(self, "Text_maxTip")
	self.Text_maxTip:setString(i18n("heroskill_text_12"))
	self.Text_maxTip:setVisible(false)
	self.Button_save = SoraDGetChildByName(self, "Button_save")
	self.Button_save:setTitleText(i18n("common_text_195"))
	self.Button_save = include("commonBtnInstance").new(self.Button_save)
	self.Button_save:setHandle(handler(self, self.btnSaveClick))
	self.Button_awake = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_awake")
	self.Button_awake:addTouchEventListener(handler(self, self.btnAwakeClick))
	self.Node_quality = SoraDGetChildByName(self, "Node_quality")
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setVisible(false)
	self.txtPow = SoraDGetChildByName(self, "BitmapFontLabel_pow")
	self.imgScouring = display.newSprite("#font_slim_sessesful_en.png")
	if SoraDFIsRA() then
		self.imgScouring:setSpriteFrame("font_slim_sessesful_ar.png")
	end
	self.imgScouring:setPosition(cc.p(320, display.height / 2 + 190))
	self.imgScouring:setVisible(false)
	self.imgScouring:addTo(self, 20)
	self.Node_spSkill = SoraDGetChildByName(self, "Node_spSkill")
	self.Node_spSkill:setVisible(false)
	self.Node_bar = SoraDGetChildByName(self.Node_spSkill, "Node_bar")
	self.SpLoading_bar = SoraDGetChildByName(self.Node_spSkill, "LoadingBar_bar")
	self.Image_skill = SoraDGetChildByName(self.Node_spSkill, "Image_skill")
	self.Image_skFrm = SoraDGetChildByName(self.Node_spSkill, "Image_skFrm")
	self.Image_itemBar = SoraDGetChildByName(self.Node_spSkill, "Image_itemBar")
	self.Image_itemBar:setVisible(false)
	self.Text_lv = SoraDGetChildByName(self.Node_spSkill, "Text_lv")
	self.Text_skillName = SoraDGetChildByName(self.Node_spSkill, "Text_skillName")
	self.Text_skillDes = SoraDGetChildByName(self.Node_spSkill, "Text_skillDes")
	self.Text_skillFull = SoraDGetChildByName(self.Node_spSkill, "Text_skillFull")
	self.Text_skillFull:setString(i18n("hero_mastery_03"))
	self.Button_upgrade = SoraDGetChildByName(self.Node_spSkill, "Button_upgrade")
	self.Button_upgrade:setTitleText(i18n("common_text_055"))
	self.Button_upgrade:addTouchEventListener(handler(self, self.btnUpgradeClick))
	self.Text_topNum = SoraDGetChildByName(self, "Text_topNum")
	self.Text_topNum:setString(i18n("common_text_283"))
	self.Text_topNum:setVisible(false)
	_ENV, _UPVALUE2_ = self.Text_topNum, self.Text_topNum.setVisible
	self.Text_topNum.activityID = gActivityTimeActivityID.HERO_AWAKE_ACTIVTY
	self.Text_topNum.name = "activity_name_9001303"
	self.Text_topNum.desc = "addition_text_01"
	_ENV, self.Text_topNum.icon = gActivityTimeActivityID.HERO_AWAKE_ACTIVTY, "icon_JJJC_huodong.png"
	gActivityTimeActivityID.HERO_AWAKE_ACTIVTY.activityID = gActivityTimeActivityID.HERO_AWAKE_CRIT_ACTIVTY
	gActivityTimeActivityID.HERO_AWAKE_ACTIVTY.name = "activity_name_9001365"
	gActivityTimeActivityID.HERO_AWAKE_ACTIVTY.desc = "addition_text_02"
	gActivityTimeActivityID.HERO_AWAKE_ACTIVTY.icon = "icon_jjbj_huodong.png"
	self.activeActivities, _ENV, self.bottomNodes, _ENV, self.activities, self.Text_topNum.setVisible[1] = self.Text_topNum.setVisible, self.Text_topNum.setVisible, self.Text_topNum.setVisible, self.Text_topNum.setVisible, self.Text_topNum.setVisible, self.Text_topNum
	self.activeActivities, _ENV, self.bottomNodes, _ENV, self.activities, self.Text_topNum.setVisible[2] = self.Text_topNum.setVisible, self.Text_topNum.setVisible, self.Text_topNum.setVisible, self.Text_topNum.setVisible, self.Text_topNum.setVisible, gActivityTimeActivityID.HERO_AWAKE_ACTIVTY
	self.Bottom_activity = SoraDGetChildByName(self, "Bottom_activity")
	self.Bottom_activity:setVisible(false)
	self.aStartY = self.Bottom_activity:getPositionY()
	self.aStartX = self.Bottom_activity:getPositionX()
end
function heroUskillStudyView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_AWAKE", function(target, data)
		self.isFirstEnter = false
		self:refresh(target, data)
	end)
	SoraDAddMessage(self, "MESSAGE_ITEM_CHANGE_TYPE", handler(self, self.recevieItemChangeMsg))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_FEED_SKILL", handler(self, self.refreshSillEXP))
	if not IsArClient then
		SoraDAddMessage(self, "MESSAGE_SERVER_HERO_AWAKE_FOR_ROS", handler(self, self.remakePopViewForROS))
		SoraDAddMessage(self, "MESSAGE_SERVER_HERO_AWAKE_SKILL_CLICK", handler(self, self.skillClick))
	end
end
function heroUskillStudyView:onEnterPanel()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	SoradCreateTimer(self, handler(self, function(target, dt)
		for i, v in ipairs(self.activeActivities) do
			local eventTime = activityShowCtrl:getTimeInfoByID(v.activityID)
			if not eventTime then
				timeCount = timeSce
				self:updateActivityNode()
				return
			end
		end
	end))
end
function heroUskillStudyView:recevieItemChangeMsg(target, redata)
	if redata and redata.itemType and gItemType.HERO_CHIP == redata.itemType then
		self:refreshChips()
	end
end
function heroUskillStudyView:refreshSillEXP()
	self:initData(self.heroID)
end
function heroUskillStudyView:updateActivityNode()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	self.activeActivities, gametop = gametop.playertop_, gametop.playertop_
	local activeNums = 0
	for i, v in ipairs(self.activities) do
		local state = activityShowCtrl:getStateByID(v.activityID)
		local rarity = heroltCtrl:getRarity(self.heroID)
		local isShow = gActivityState.OPEN == state and rarity >= gHeroRarity.BLUE
		if isShow then
			table.insert(self.activeActivities, v)
		elseif self.bottomNodes[i] then
			self.bottomNodes[i]:setVisible(false)
		end
	end
	if 0 < table.nums(self.activeActivities) then
		self.scroll:setContentSize(cc.size(self.scrollSize.width, self.scrollSize.height))
	else
		self.scroll:setContentSize(cc.size(self.scrollSize.width, self.scrollSize.height + 126))
	end
	self:setActivityNodes()
end
function heroUskillStudyView:setActivityNodes()
	_UPVALUE1_ = nil
	self.bottomNodes, (nil)[1] = nil, self.Bottom_activity
	for i, v in ipairs(self.activeActivities) do
		local bottomNode
		if i == 1 then
			bottomNode = self.Bottom_activity
		else
			bottomNode = self.bottomNodes[i]
			if bottomNode == nil then
				bottomNode = self.Bottom_activity:clone()
				local sx = SoraDFIsRA() and self.aStartX - 100 * (i - 1) or self.aStartX + 100 * (i - 1)
				bottomNode:setPosition(sx, self.aStartY)
				bottomNode:addTo(self.Bottom_activity:getParent())
				table.insert(self.bottomNodes, bottomNode)
			end
		end
		bottomNode:stopAllActions()
		self:initActivityNode(bottomNode)
		bottomNode:setVisible(true)
		self:setActivityNode(bottomNode, v)
	end
end
function heroUskillStudyView:initActivityNode(bottomNode)
	if bottomNode.Text_activity_time then
		return
	end
	local Text_activity_time = SoraDGetChildByName(bottomNode, "Text_activity_time")
	Text_activity_time = SoraDCreateTimerLabel(self, Text_activity_time)
	Text_activity_time:setTimeLast(function(time)
		return time
	end)
	bottomNode.Text_activity_time = Text_activity_time
	local Image_desc = SoraDGetChildByName(bottomNode, "Image_desc")
	Image_desc:setVisible(false)
	local button_activity = SoraDGetChildByName(bottomNode, "Button_activity")
	button_activity:addTouchEventListener(function(button, event)
		if event == ccui.TouchEventType.began then
			Image_desc:setVisible(true)
		elseif event == ccui.TouchEventType.ended then
			Image_desc:setVisible(false)
		elseif event == ccui.TouchEventType.canceled then
			Image_desc:setVisible(false)
		end
	end)
end
function heroUskillStudyView:setActivityNode(bottomNode, activityData)
	local Text_activity_time = bottomNode.Text_activity_time
	local Text_activity_name = SoraDGetChildByName(bottomNode, "Text_activity_name")
	local Text_activity_desc = SoraDGetChildByName(bottomNode, "Text_activity_desc")
	local icon_activity = SoraDGetChildByName(bottomNode, "icon_activity")
	local Image_desc = SoraDGetChildByName(bottomNode, "Image_desc")
	Image_desc:setVisible(false)
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	Text_activity_name:setString(i18n(activityData.name))
	Text_activity_desc:setString(i18n(activityData.desc))
	icon_activity:setSpriteFrame(activityData.icon)
	local eventTime = activityShowCtrl:getTimeInfoByID(activityData.activityID)
	if eventTime then
		local leftTime = eventTime.timerNode.timer:getRemainTime()
		Text_activity_time:setString(leftTime)
		Text_activity_time:beginTime(leftTime)
	end
end
function heroUskillStudyView:initData(heroID)
	self.heroID = heroID
	self.skillID = nil
	self:updateActivityNode()
	self:refresh()
	self:initView()
end
function heroUskillStudyView:skillClick(target, data)
	self.skillID = data.skillID
	self.isSkillClick = true
	self:refresh()
end
function heroUskillStudyView:remakePopViewForROS(target, data)
	local panel = SoraDSearchPanelFromManagerByName("heroUskillStudyPopViewForROS")
	if panel then
		panel:removeFromParent()
	end
	local panel = SoraDCreatePanel("heroUskillStudyPopViewForROS")
	panel:initData(data.isSuccess, data.data, data.preBuff, data.afterBuff, data.isCrit)
	panel:show()
end
function heroUskillStudyView:refresh(target, data)
	SoraDCloseLoading(self)
	local _ENV, data = SoraDCloseLoading, data or SoraDCloseLoading
	self.txtPow:setString(string.formatnumberthousands(heroCtrl:getHeroPower(self.heroID)))
	self.heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	self.isAutoSave = data.isAuto
	self.scroll.isRefresh = self.powerSkillBack and next(self.powerSkillBack) ~= nil
	if self.isAutoSave then
		self.Button_save:setVisible(false)
		self.Button_awake:setPositionX(320)
		self.Button_awake:setTitleStr(i18n("heroskill_btn_02"))
		_ENV = i18n("heroskill_btn_02")
		i18n("heroskill_btn_02").skillBack = self.powerSkillBack
		i18n("heroskill_btn_02").isAutoSave = true
		i18n("heroskill_btn_02").scroll = self.scroll
		self.scroll:updateScrollView(cc.size(640, 120), self.skillList, 1, i18n("heroskill_btn_02"))
		self.Text_tip:setVisible(true)
		self.Text_tip:setString(i18n("heroskill_text_10"))
		self.isAllUp = false
		self.scroll.isRefresh = false
		return
	end
	self.Text_topNum:setVisible(false)
	self.powerSkillBack = self.heroInfo.powerSkillBack
	self.skillList, _ENV, self.isAwaked = next(self.powerSkillBack) ~= nil, next(self.powerSkillBack) ~= nil, next(self.powerSkillBack) ~= nil
	for k, v in pairs(self.heroInfo.powerSkill) do
		table.insert(self.skillList, v)
	end
	table.sort(self.skillList, function(a, b)
		return a.skillID < b.skillID
	end)
	self.skillID = self:selectSkillID()
	self.isAllUp = self:checkIsAllUp()
	self:initChips()
	if next(data) and not self.isAllUp then
		self.Text_tip:setVisible(true)
		self.Text_tip:setString(i18n("heroskill_text_14"))
	end
	if not self.isAllUp and data.msg == "MESSAGE_SERVER_HERO_AWAKE" or next(data) == nil then
		_ENV = i18n("heroskill_text_14")
		i18n("heroskill_text_14").skillBack = self.powerSkillBack
		i18n("heroskill_text_14").scroll = self.scroll
		i18n("heroskill_text_14").isFailed = true
		self.scroll:updateScrollView(cc.size(640, 120), self.skillList, 1, i18n("heroskill_text_14"))
		if not IsArClient and isFailed then
			self.Text_tip:setString(i18n("hero_comprehend_text_02"))
		end
	end
	self.scroll.isRefresh = false
	local isMax = self:checkIsAllMax()
	if isMax then
		self.Button_save:setVisible(false)
		self.Button_awake:setVisible(false)
		self.Text_maxTip:setVisible(true)
	end
	if not IsArClient then
		self.Button_save:setVisible(false)
		self.Button_awake:setPositionX(320)
	end
	local rarity = heroltCtrl:getRarity(self.heroID)
	if not self.isFirstEnter and (rarity == gHeroRarity.BLUE or rarity == gHeroRarity.PURPLE or rarity == gHeroRarity.ORANGE) and clientEventMgr.judgeIsOpen(gActivityTimeActivityID.HERO_AWAKE_ACTIVTY) then
		local isShowEffect = true
		for i, v in ipairs(self.skillList) do
			if self.powerSkillBack[tostring(v.skillID)] then
				if self.powerSkillBack[tostring(v.skillID)].buffValue - v.buffValue <= 0 then
					isShowEffect = false
					break
				end
			else
				isShowEffect = false
			end
		end
		if isShowEffect then
			_UPVALUE3_ = ipairs(self.skillList)
			ipairs(self.skillList)[1] = cca.delay(0.5)
			ipairs(self.skillList)[2] = cca.callFunc(function()
				self:showInsightBonusEffect()
				self.imgScouring:setVisible(true)
			end)
			ipairs(self.skillList)[3] = cca.delay(1.0)
			ipairs(self.skillList)[4] = cca.callFunc(function()
				self.imgScouring:setVisible(false)
			end)
			ipairs(self.skillList)[5] = cca.callFunc(function()
				self.imgScouring:setVisible(false)
			end)
			ipairs(self.skillList)[6] = cca.callFunc(function()
				self.imgScouring:setVisible(false)
			end)
			ipairs(self.skillList)[7] = cca.callFunc(function()
				self.imgScouring:setVisible(false)
			end)
			ipairs(self.skillList)[8] = cca.callFunc(function()
				self.imgScouring:setVisible(false)
			end)
			ipairs(self.skillList)[9] = cca.callFunc(function()
				self.imgScouring:setVisible(false)
			end)
			ipairs(self.skillList)[10] = cca.callFunc(function()
				self.imgScouring:setVisible(false)
			end)
			local seq = cca.seq(ipairs(self.skillList))
			self:runAction(seq)
		end
	end
	local isShowSpNode = rarity >= gHeroQuality.BLUE
	if not IsArClient and self.heroID == 1715 then
		isShowSpNode = false
	end
	self.Node_spSkill:setVisible(isShowSpNode)
	if isShowSpNode then
		local advanceInfo = heroCtrl:getHeroAdvancedSkillInfo(self.heroID)
		local mSkillID = heroltCtrl.getMSkillID(self.heroID)
		local mSkillInfo = heroltCtrl.getSkillDesInfo(mSkillID)
		local isFullSkill = heroltCtrl:isHeroUSkillFull(self.heroInfo.powerSkill, self.heroInfo.advancedSkill.bActive)
		self.Image_skill:loadTexture(mSkillInfo.herIcon, ccui.TextureResType.plistType)
		if not isFullSkill or not i18n(mSkillInfo.herName) then
			_ENV = cca.callFunc(function()
				self.imgScouring:setVisible(false)
			end)
			cca.callFunc(function()
				self.imgScouring:setVisible(false)
			end).name = i18n(mSkillInfo.herName)
		end
		self.Text_skillName:setString((i18n("hero_mastery_02", cca.callFunc(function()
			self.imgScouring:setVisible(false)
		end))))
		if advanceInfo and next(advanceInfo) then
			self:getSkillDes(mSkillID, advanceInfo.level)
		end
		self.Text_skillFull:setVisible(not isFullSkill)
		if self.Text_skillFull:isVisible() then
			self:getSkillDes(mSkillID, 10)
		end
		self.Image_skill:getVirtualRenderer():setState(isFullSkill and 0 or 1)
		self.Image_skFrm:getVirtualRenderer():setState(isFullSkill and 0 or 1)
		self.Button_upgrade:setVisible(isFullSkill)
		if advanceInfo and next(advanceInfo) and advanceInfo.level >= 10 then
			self.Button_upgrade:setVisible(false)
			self.Text_topNum:setVisible(true)
		end
		if advanceInfo and next(advanceInfo) then
			self.Node_bar:setVisible(true)
			local percent, nextExp = heroltCtrl:getAdvancedSkillPercent(self.heroID, advanceInfo.level, advanceInfo.skillExp)
			self.SpLoading_bar:setPercent(advanceInfo.level >= 10 and 100 or percent)
			_ENV = mSkillInfo.herName
			mSkillInfo.herName.lv = advanceInfo.level
			self.Text_lv:setString(i18n("common_text_100", mSkillInfo.herName))
			self.Image_itemBar:setVisible(true)
		else
			self.Node_bar:setVisible(false)
		end
	end
end
function heroUskillStudyView:getSkillDes(mSkillID, level)
	local heroltCtrl, args
	local mSkillInfo = heroltCtrl.getSkillDesInfo(mSkillID)
	local curMSkillID = tonumber(string.format("%d%.2d", mSkillID, level))
	local mSkillCfg = heroltCtrl:getMasterySkillInfo(curMSkillID)
	local buffLogic = include("buffLogic")
	if #mSkillCfg.buffType > 0 then
		for k, v in ipairs(mSkillCfg.buffType) do
			local model = mSkillCfg.buffMode[k]
			local val = mSkillCfg.buffValue[k] / 10 .. "%"
			if model == 2 then
				val = buffLogic.isNeedThousand(v) and mSkillCfg.buffValue[k] / 1000 or mSkillCfg.buffValue[k]
			end
			if self.heroID == 1728 then
				args["var" .. k] = val
			else
				args["num" .. k] = val
			end
		end
		if self.heroID == 1722 then
			args.num2 = args.num1
		end
	end
	self.Text_skillDes:setString(i18n(mSkillInfo.des, args))
end
function heroUskillStudyView:showInsightBonusEffect()
	if self.effectScouring then
		SoraDResetEffectNode(self.effectScouring)
		self.effectScouring.action:gotoFrameAndPlay(0, 57, false)
	else
		self.effectScouring = SoraDCreatAnimationEx("Node_Effect_xljc", nil, false)
		self.effectScouring:setPosition(320, display.height / 2)
		self.effectScouring:addTo(self, 10)
	end
end
function heroUskillStudyView:checkIsAllUp()
	local isAllUp = self.isAwaked
	for k, v in ipairs(self.skillList) do
		if self.powerSkillBack[tostring(v.skillID)] and self.powerSkillBack[tostring(v.skillID)].buffValue < v.buffValue then
			isAllUp = false
			break
		end
	end
	return isAllUp
end
function heroUskillStudyView:checkIsAllMax()
	local isMax = true
	for k, v in ipairs(self.skillList) do
		if v.skillID and v.buffValue < heroltCtrl:getMaxBuffValue(v.skillID) then
			isMax = false
			break
		end
	end
	return isMax
end
function heroUskillStudyView:selectSkillID()
	local skillID
	if not IsArClient then
		for k, v in pairs(self.skillList) do
			v.isSelect = false
		end
		for k, v in pairs(self.skillList) do
			if not self.isSkillClick then
				if v.isActive and v.buffValue < heroltCtrl:getMaxBuffValue(v.skillID) then
					skillID = v.skillID
					v.isSelect = true
					break
				end
			elseif self.skillID == v.skillID then
				skillID = v.skillID
				v.isSelect = true
			end
		end
	end
	return skillID
end
function heroUskillStudyView:initView()
	local Bg_King = SoraDGetChildByName(self, "Bg_King")
	local Image_hero = SoraDGetChildByName(self, "Image_hero")
	local Node_spine = SoraDGetChildByName(self, "Node_spine")
	local Sprite_heroname = SoraDGetChildByName(self, "Sprite_heroname")
	local Sprite_quality = SoraDGetChildByName(self, "Sprite_quality")
	local Sprite_heroClass = SoraDGetChildByName(self, "Sprite_heroClass")
	Bg_King:loadTexture(heroltCtrl.getHeroViewBg(self.heroID), ccui.TextureResType.plistType)
	Sprite_heroname:setSpriteFrame(heroltCtrl.getHeroNamePng(self.heroID))
	Sprite_quality:setSpriteFrame(heroltCtrl:getCardRareImg(self.heroID))
	Sprite_heroClass:setSpriteFrame(heroltCtrl.getHeroClassTypeInfo(self.heroID).icon)
	if self.ccs_quality then
		self.ccs_quality:initData(self.heroInfo and self.heroInfo.quality or gHeroQuality.WHITE)
	else
		self.ccs_quality = SoraDCreatePanel("heroEffectQuality")
		self.ccs_quality:setPosition(0, 0)
		self.ccs_quality:addTo(self.Node_quality)
	end
	if self.heroInfo.dress and not heroltCtrl:isDefaultDress(self.heroInfo.dress.seting) then
		local info = heroltCtrl.getHeroDressSpineInfo(self.heroID, self.heroInfo.dress.seting)
		Image_hero:setVisible(false)
		Node_spine:setVisible(true)
		self.spine_hero = sp.SkeletonAnimation:create(info.skel, info.atlas, 1)
		self.spine_hero:setPosition(info.skillOffset)
		self.spine_hero:setAnimation(0, "animation", true)
		self.spine_hero:addTo(Node_spine)
		return
	end
	local info = heroltCtrl.getHeroHeadSpineInfo(self.heroID)
	if info then
		Image_hero:setVisible(false)
		Node_spine:setVisible(true)
		self.spine_hero = sp.SkeletonAnimation:create(info.skel, info.atlas, 1)
		self.spine_hero:setPosition(info.skillOffset)
		self.spine_hero:setAnimation(0, "animation", true)
		self.spine_hero:addTo(Node_spine)
	else
		Image_hero:setVisible(true)
		Node_spine:setVisible(false)
		local _, haveImage = SoraDIsFileExistByFileName(self.heroExInfo.herImage)
		if haveImage then
			Image_hero:loadTexture(self.heroExInfo.herImage, ccui.TextureResType.plistType)
			Image_hero:ignoreContentAdaptWithSize(true)
			Image_hero:setPositionY(self.heroID ~= 1718 and 560 or 440)
		else
			Image_hero:loadTexture("bg_hero_default.png", ccui.TextureResType.plistType)
			Image_hero:ignoreContentAdaptWithSize(true)
		end
	end
end
function heroUskillStudyView:initChips()
	self:refreshChips()
	if self.isAllUp then
		SoraDShowLoading(self)
		heroCtrl:saveRemakeSkillReq(self.heroID, true)
	else
		self:initBtns()
		self.Button_awake:setTitleStr(self.isAwaked and i18n("heroskill_btn_02") or i18n("heroskill_btn_01"))
	end
	if not self.isAwaked or not i18n("heroskill_title_03") then
		_ENV = nil
		;(nil).name = i18n(self.heroExInfo.herName)
	end
	self.ccs_title:setTitle((i18n("heroskill_title_02", nil)))
	self.ccs_title:setTitleWidthHeight(cc.size(300, 60))
end
function heroUskillStudyView:refreshChips()
	local costInfo = heroltCtrl:getAwakeCost(self.heroID)
	self.itemID = costInfo.id
	self.itemNum = backpackCtrl:getItemCount(self.itemID)
	self.needNum = costInfo.num
	self.heroExInfo = heroltCtrl.getHeroInfo(self.heroID)
	if not heroltCtrl:getExchangeInfo(self.heroExInfo.itemID) then
		heroltCtrl = heroltCtrl:getExchangeInfo(self.heroExInfo.itemID)
	end
	self.exInfo = heroltCtrl:getExchangeInfo(self.heroExInfo.itemID)
	SoraDGetChildByName(self.Node_item, "icon_item"):setSpriteFrame(publicRead.getIcon(self.exInfo.changeID))
	heroltCtrl = publicRead.getIcon(self.exInfo.changeID)
	publicRead.getIcon(self.exInfo.changeID).total = self.exInfo.changeNum
	publicRead.getIcon(self.exInfo.changeID).member = backpackCtrl:getItemCount(self.exInfo.changeID)
	SoraDGetChildByName(self.Node_item, "Text_num"):setString(i18n("common_text_155", publicRead.getIcon(self.exInfo.changeID)))
	SoraDGetChildByName(self.Node_item, "Text_exchange"):setString(i18n("common_text_1889"))
	self.Button_awake:setIconTexture(publicRead.getIcon(self.itemID))
	heroltCtrl = publicRead.getIcon(self.itemID)
	publicRead.getIcon(self.itemID).total = self.itemNum
	publicRead.getIcon(self.itemID).member = costInfo.num
	self.Button_awake:setGoldText(i18n("common_text_155", publicRead.getIcon(self.itemID)))
	self.isEnoughChip = self.itemNum >= costInfo.num
	self.Button_awake:setTextGoldColor(self.isEnoughChip and cc.c3b(255, 255, 0) or cc.c3b(190, 40, 40))
end
function heroUskillStudyView:initBtns()
	self.Button_save:setVisible(self.isAwaked)
	self.Button_awake:setPositionX(self.isAwaked and SoraDFPosX(460) or 320)
end
function heroUskillStudyView:btnSaveClick()
	local save = function(isChcek)
		if isChcek ~= nil then
			GAME_HERO_SAVE_SHOW = isChcek
		end
		SoraDShowLoading(self)
		SoraDPlaySound("uicontrol", 3)
		heroCtrl:saveRemakeSkillReq(self.heroID)
	end
	if GAME_HERO_SAVE_SHOW then
		local panel = SoraDCreatePanel("heroUskillPromptBox")
		panel:initData(i18n("weapon_text_07"), save, GAME_HERO_SAVE_SHOW)
		panel:show()
	else
		save()
	end
end
function heroUskillStudyView:btnAwakeClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isEnoughChip then
			if not IsArClient then
				if not self.skillID then
					SoraDShowMsgTip(i18n("skill_text_17"))
					return
				end
				for i, v in ipairs(self.skillList) do
					if self.skillID and v.skillID == self.skillID and v.buffValue >= heroltCtrl:getMaxBuffValue(self.skillID) then
						SoraDShowMsgTip(i18n("skill_text_17"))
						return
					end
				end
			end
			local remake = function(isChcek)
				if isChcek ~= nil then
					GAME_HERO_REMAKE_SHOW = isChcek
				end
				SoraDShowLoading(self)
				SoraDPlaySound("uicontrol", 21)
				heroCtrl:remakeSkillReq(self.heroID, self.skillID)
			end
			if IsArClient and GAME_HERO_REMAKE_SHOW and self.isAwaked and not self.isAllUp and not self.isAutoSave then
				local panel = SoraDCreatePanel("heroUskillPromptBox")
				panel:initData(i18n("heroskill_text_06"), remake, GAME_HERO_REMAKE_SHOW)
				panel:show()
			else
				remake()
			end
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
function heroUskillStudyView:btnChipClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local ownNum = backpackCtrl:getItemCount(self.exInfo.changeID)
		if 0 < ownNum then
			_ENV = nil
			;(nil).heroID = self.heroID
			;(nil).mode = 2
			uiManager:show("HeroChipExchange", nil)
		else
			SoraDShowMsgTip(i18n("heroskill_text_03"), "#" .. publicRead.getIcon(self.exInfo.changeID))
		end
	end
end
function heroUskillStudyView:btnUpgradeClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local advanceInfo = heroCtrl:getHeroAdvancedSkillInfo(self.heroID)
		if advanceInfo and next(advanceInfo) and advanceInfo.level >= 10 then
			SoraDShowMsgTip(i18n("hero_mastery_01"))
			return
		end
		local isChipsEnough = false
		for i, v in ipairs(heroltCtrl:getAllHeroesChipsID()) do
			if backpackCtrl:getItemCount(v) > 0 then
				isChipsEnough = true
				break
			end
		end
		if not isChipsEnough then
			SoraDShowMsgBox(i18n("heroskill_text_04"), i18n("common_text_054"), i18n("common_text_185"), function(eventType)
				if MSGBOX_CALLBACK_YES == eventType then
					_ENV = nil
					;(nil).itemID = self.itemID
					;(nil).needCount = self.needNum
					uiManager:show("newHeroGainChipMethodView", nil)
				end
			end)
			return
		end
		local chipsArray = backpackCtrl:getAllHeroChips()
		if 0 < #chipsArray then
			function _ENV(eventType)
				if MSGBOX_CALLBACK_YES == eventType then
					_ENV = nil
					;(nil).itemID = self.itemID
					;(nil).needCount = self.needNum
					uiManager:show("newHeroGainChipMethodView", nil)
				end
			end
			;(function(eventType)
				if MSGBOX_CALLBACK_YES == eventType then
					_ENV = nil
					;(nil).itemID = self.itemID
					;(nil).needCount = self.needNum
					uiManager:show("newHeroGainChipMethodView", nil)
				end
			end).heroID = self.heroID
			uiManager:show("heroMskillFeedView", function(eventType)
				if MSGBOX_CALLBACK_YES == eventType then
					_ENV = nil
					;(nil).itemID = self.itemID
					;(nil).needCount = self.needNum
					uiManager:show("newHeroGainChipMethodView", nil)
				end
			end)
		else
			function _ENV(eventType)
				if MSGBOX_CALLBACK_YES == eventType then
					_ENV = nil
					;(nil).itemID = self.itemID
					;(nil).needCount = self.needNum
					uiManager:show("newHeroGainChipMethodView", nil)
				end
			end
			;(function(eventType)
				if MSGBOX_CALLBACK_YES == eventType then
					_ENV = nil
					;(nil).itemID = self.itemID
					;(nil).needCount = self.needNum
					uiManager:show("newHeroGainChipMethodView", nil)
				end
			end).itemID = heroltCtrl.getHeroInfo(self.heroID).itemID
			;(function(eventType)
				if MSGBOX_CALLBACK_YES == eventType then
					_ENV = nil
					;(nil).itemID = self.itemID
					;(nil).needCount = self.needNum
					uiManager:show("newHeroGainChipMethodView", nil)
				end
			end).needCount = 1
			uiManager:show("newHeroGainChipMethodView", function(eventType)
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
return heroUskillStudyView
