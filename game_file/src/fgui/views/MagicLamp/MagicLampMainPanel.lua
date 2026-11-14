local nebulaWarUtil = include("nebulaWarUtil")
local constantRead = include("constantRead")
local warOrderCtrl = SoraDGetCtrl("warOrderCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local magicLampHatchRead = include("magicLampHatchRead")
local magicLampHatchCtrl = SoraDGetCtrl("magicLampHatchCtrl")
local buffCtrl = SoraDGetCtrl("buffCtrl")
local magicLampSkillLotteryCtrl = SoraDGetCtrl("magicLampSkillLotteryCtrl")
local MagicLampMainPanel = class("MagicLampMainPanel", baseFguiPanel)
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local magicLampRead = include("magicLampRead")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
function MagicLampMainPanel:ctor(...)
	self.debug = true
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	print("MagicLampMainPanel:ctor", self.viewName)
	self.buffData, _ENV = print, print
end
function MagicLampMainPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "MagicLampSkill"
		self._packageList, self._packageList[2] = self._packageList, "BuildViewCommon"
	end
	return self._packageList
end
function MagicLampMainPanel:onInit()
	if not SoraDFIsRA() then
		self.fields.Button_bless:fixPos()
		self.fields.Button_pray:fixPos()
		self.fields.Button_hatch:fixPos()
		self.fields.text_power:fixPos()
		self.fields.btn_recount:fixPos()
		self.fields.btn_group:fixPos()
		self.fields.Button_starRiver:fixPos()
		self.fields.Ani_yjjs:fixPos()
		self.fields.Ani_yjjs:fix()
		self.fields.n44:fixPos()
	end
	print("=======MagicLampMainPanel:onInit")
	self.fields.Com_title:initData(i18n("magic_lamp_title_01"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.list_jinn:setItemRenderer(handler(self, self.onJinnsRender))
	self.fields.list_att:setItemRenderer(handler(self, self.onAttsRender))
	self.fields.list_star:setItemRenderer(handler(self, self.onStarsRender))
	self.fields.Button_bless:setTitle(i18n("magic_lamp_text_002"))
	self.fields.Button_bless:addClickEventListener(handler(self, self.onBlessClick))
	self.fields.Button_pray:setTitle(i18n("magic_lamp_text_003"))
	self.fields.Button_pray:addClickEventListener(handler(self, self.onPrayClick))
	self.fields.Button_pray:setVisible(false)
	self.fields.Button_starRiver:setTitle(i18n("jinn_gaglxy_text01"))
	self.fields.Button_starRiver:addClickEventListener(handler(self, self.onStarRiverClick))
	self.fields.Button_starRiver:setVisible(false)
	self.fields.Button_break:setTitle(i18n("magic_lamp_text_004"))
	self.fields.Button_break:addClickEventListener(handler(self, self.onBreakClick))
	self.fields.Button_strength:setTitle(i18n("magic_lamp_text_006"))
	self.fields.Button_strength:addClickEventListener(handler(self, self.onStrengthClick))
	self.fields.Button_class:setTitle(i18n("magic_lamp_text_008"))
	self.fields.Button_class:addClickEventListener(handler(self, self.onClassClick))
	self.fields.button_speed:addClickEventListener(handler(self, self.onAddSpeed))
	self.fields.btn_recount:setTitle(i18n("magic_lamp_text_158"))
	self.fields.btn_recount:addClickEventListener(handler(self, self.onRecountClick))
	self.fields.btn_group:setTitle(i18n("magic_lamp_text_168"))
	self.fields.btn_group:addClickEventListener(handler(self, self.onGroupClick))
	self.fields.btn_group:setVisible(false)
	self.fields.Usm_2:setCompleteCallback(function()
		self.fields.Usm_2:clearEffect()
		self.isShowing = false
	end)
	self.fields.List_buff:setItemRenderer(handler(self, self.onBuffItemRenderer))
	self.fields.btn_left:addClickEventListener(handler(self, self.onPageClick), -1)
	self.fields.btn_right:addClickEventListener(handler(self, self.onPageClick), 1)
end
function MagicLampMainPanel:onBuffItemRenderer(index, obj)
	local activityID = self.buffDataList[index + 1]
	local buildType = BUILD_ENUM.MAGIC_LAMP
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001701 then
		buildType = BUILD_ENUM.TWO_MAGIC_LAMP
	end
	_ENV = nil
	;(nil).activityID = activityID
	;(nil).handle = function()
		self:updateListBuffData()
	end
	;(nil).buffBuildType = buildType
	obj:initData(nil)
end
function MagicLampMainPanel:updateListBuffData(...)
	self:updateWarOrderBuff()
	self:updateBuff_9001565()
	self:updateBuff_9001581()
	self:updateBuff_9001601()
	self:updateBuff_9001656()
	self:updateBuff_9001701()
	self:updateListBuff()
	self:updateItems()
end
function MagicLampMainPanel:updateListBuff()
	_ENV, self.buffDataList = table.keys(self.buffData), table.keys(self.buffData)
	table.keys(self.buffData)[gActivityTimeActivityID.WAR_ORDER_ACTIVITY] = 1
	table.keys(self.buffData)[gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY] = 2
	table.keys(self.buffData)[gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581] = 3
	table.keys(self.buffData)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001601] = 4
	table.keys(self.buffData)[gActivityTimeActivityID.PREPARE_FOR_WAR_ACTIVITY] = 5
	local table.keys(self.buffData)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001701], sortValue = 6, table.keys(self.buffData)
	table.sort(self.buffDataList, function(eid1, eid2)
		return sortValue[eid1] < sortValue[eid2]
	end)
	self.fields.List_buff:setNumItems(#self.buffDataList)
end
function MagicLampMainPanel:updateWarOrderBuff()
	local activityID = gActivityTimeActivityID.WAR_ORDER_ACTIVITY
	if self.curType ~= gJinnType.JINN_ONE then
		self.buffData[activityID] = nil
		return
	end
	local curCtrl = warOrderCtrl:getCurCtrl(activityID)
	if clientEventMgr.judgeIsOpen(activityID) and curCtrl:getBuffType() > 0 then
		self.buffData[activityID] = true
	else
		self.buffData[activityID] = nil
	end
end
function MagicLampMainPanel:updateBuff_9001581()
	local activityID = gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581
	if self.curType ~= gJinnType.JINN_ONE then
		self.buffData[activityID] = nil
		return
	end
	local curCtrl = warOrderCtrl:getCurCtrl(activityID)
	if clientEventMgr.judgeIsOpen(activityID) and curCtrl:isBuffEffect(BUILD_ENUM.MAGIC_LAMP) then
		self.buffData[activityID] = true
	else
		self.buffData[activityID] = nil
	end
end
function MagicLampMainPanel:updateBuff_9001565()
	local activityID = gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY
	if self.curType ~= gJinnType.JINN_ONE then
		self.buffData[activityID] = nil
		return
	end
	local curCtrl = warOrderCtrl:getCurCtrl(activityID)
	if clientEventMgr.judgeIsOpen(activityID) and curCtrl:isBuffEffect(BUILD_ENUM.MAGIC_LAMP) then
		self.buffData[activityID] = true
	else
		self.buffData[activityID] = nil
	end
end
function MagicLampMainPanel:updateBuff_9001601()
	if not include("constantRead").checkRamadanBlessBuffSwitch() then
		return
	end
	local activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001601
	if self.curType ~= gJinnType.JINN_ONE then
		self.buffData[activityID] = nil
		return
	end
	local curCtrl = warOrderCtrl:getCurCtrl(activityID)
	if clientEventMgr.judgeIsOpen(activityID) and curCtrl:isBuffEffect(BUILD_ENUM.MAGIC_LAMP) then
		self.buffData[activityID] = true
	else
		self.buffData[activityID] = nil
	end
end
function MagicLampMainPanel:updateBuff_9001656()
	local activityID = gActivityTimeActivityID.PREPARE_FOR_WAR_ACTIVITY
	if self.curType ~= gJinnType.JINN_ONE then
		self.buffData[activityID] = nil
		return
	end
	local curCtrl = warOrderCtrl:getCurCtrl(activityID)
	if clientEventMgr.judgeIsOpen(activityID) and curCtrl:isBuffEffect(BUILD_ENUM.MAGIC_LAMP) then
		self.buffData[activityID] = true
	else
		self.buffData[activityID] = nil
	end
end
function MagicLampMainPanel:updateBuff_9001701()
	local activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001701
	if self.curType ~= gJinnType.JINN_TWO then
		self.buffData[activityID] = nil
		return
	end
	local curCtrl = warOrderCtrl:getCurCtrl(activityID)
	if clientEventMgr.judgeIsOpen(activityID) and curCtrl:isBuffEffect(BUILD_ENUM.TWO_MAGIC_LAMP) then
		self.buffData[activityID] = true
	else
		self.buffData[activityID] = nil
	end
end
function MagicLampMainPanel:endShow()
	print("=======MagicLampMainPanel:onShow")
	magicLampHatchCtrl:sendReqInitDataMsg()
	self.curType = self.param and self.param.curType or magicLampCtrl:getShowingJinn()
	magicLampCtrl = magicLampCtrl
	magicLampCtrl[1] = magicLampCtrl:getShowingJinn()
	magicLampCtrl[2] = self.curType
	dump(magicLampCtrl, "magicLampCtrl:getShowingJinn()")
	self.jinnList = magicLampCtrl:getUnlockedJinnList()
	self.curIndex = 1
	for i, v in ipairs(self.jinnList) do
		if v == self.curType then
			self.curIndex = i
			break
		end
	end
	self:updateView()
end
function MagicLampMainPanel:onHide()
	magicLampCtrl:setShowingJinn(self.curType)
	magicLampCtrl = magicLampCtrl
	magicLampCtrl.msg = "MESSAGE_MAGICLAMP_UPDATE"
	SoraDSendMessage(magicLampCtrl)
end
function MagicLampMainPanel:updateView()
	self.jinnData = magicLampCtrl:getJinnByType(self.curType)
	if self.jinnData == nil or self.jinnData.lock then
		self.curType = gJinnType.JINN_ONE
		self.curIndex = 1
		self.jinnData = magicLampCtrl:getJinnByType(self.curType)
	end
	if self.jinnData == nil then
		self:close()
		return
	end
	self.curStar = self.jinnData.starLv
	self.jinnCfg = magicLampRead.getJinnCfg(self.curType, self.curStar)
	self.strengthCfg = magicLampRead.getStrengthenCfg(self.curType, self.jinnData.lv)
	self.classCfg = magicLampRead.getClassCfg(self.curType, self.jinnData.classLv)
	self.nextClassCfg = magicLampRead.getClassCfg(self.curType, self.jinnData.classLv + 1)
	self.breakCfg = magicLampRead.getBreakThroughCfg(self.curType, self.curStar)
	self.fields.name_icon:setURL(SoraDFIsRA() and self.jinnCfg.ArabNamePNG or self.jinnCfg.EnNamePNG)
	self.fields.text_lvdes:setTitle(self.jinnData.lv)
	if not self.turnPage and self.unlockingJinnType == nil and self.oldPower then
		SoraDCreateScoreLabel(self.fields.text_power, true):runScoreAnimation(self.oldPower, self.jinnData.power, 1)
	else
		self.fields.text_power:setString(self.jinnData.power)
	end
	self.oldPower = self.jinnData.power
	self.maxStar = magicLampRead.getMaxStar(self.curType)
	self.fields.list_star:setNumItems(self.curStar)
	self.fields.Button_bless:setReddot(self.jinnData.blessPoint > 0, self.jinnData.blessPoint)
	self.bigBlessCfgs = magicLampRead.getBigBlessList(self.curType)
	local isJinnStarUnlock, extraSkillSlotNum = magicLampCtrl:getIsStarRiverUnlock(self.curType)
	extraSkillSlotNum = isJinnStarUnlock and extraSkillSlotNum or 0
	self.fields.list_jinn:setNumItems(#self.bigBlessCfgs + extraSkillSlotNum)
	self.isStarRiverRedDot, self.isNeedSaveClickSlot = magicLampCtrl:getStarRiverRedDot(self.curType)
	self.fields.Button_starRiver:setReddot(self.isStarRiverRedDot)
	self.extraSkillSlotNum = extraSkillSlotNum
	self.attCfgs = self.breakCfg.buff
	self.fields.list_att:setNumItems(#self.attCfgs)
	self:updateTimers()
	self:updateAnimations()
	if self.oldJinnPoint ~= nil and not self.turnPage and self.unlockingJinnType == nil and self.jinnData.blessPoint > self.oldJinnPoint then
		magicLampCtrl = nil
		;(nil).num = self.jinnData.blessPoint - self.oldJinnPoint
		SoraDShowMsgTip(i18n("magic_lamp_tips_010", nil))
	end
	self.oldJinnPoint = self.jinnData.blessPoint
	self:upadteHatchBtn()
	self:updateListBuffData()
	self.fields.btn_recount:setVisible(1 < #self.jinnList)
	self.fields.btn_group:setVisible((CONST_VALUE.MAGIC_SKILL_COMBINATION or 0) == 1)
	local isAddPageShow = self.jinnList[self.curIndex + 1] ~= nil
	local isMinPageShow = self.jinnList[self.curIndex - 1] ~= nil
	self.fields.btn_right:setVisible(isAddPageShow)
	self.fields.btn_left:setVisible(isMinPageShow)
	self.fields.Button_pray:setVisible(magicLampSkillLotteryCtrl:getIsUnlock())
	if self.curType == gJinnType.JINN_TWO then
		if self.lastIsStarRiverUnlock ~= nil and not self.lastIsStarRiverUnlock and isJinnStarUnlock then
			magicLampCtrl = magicLampSkillLotteryCtrl:getIsUnlock()
			magicLampSkillLotteryCtrl:getIsUnlock().closeCallback = handler(self, self.showMarkGuideAni)
			uiManager:show("MagicLampSRUnlock", magicLampSkillLotteryCtrl:getIsUnlock())
			self.fields.list_jinn:setNumItems(#self.bigBlessCfgs)
			self.isStarRiverUnlocking = true
		else
			self.fields.Button_starRiver:setVisible(isJinnStarUnlock)
		end
		self.lastIsStarRiverUnlock = isJinnStarUnlock
	else
		self.fields.Button_starRiver:setVisible(false)
	end
end
function MagicLampMainPanel:updateAnimations()
	local effectCfgs = magicLampRead.getJinnEffect(self.curType)
	self.effects = effectCfgs.effects
	self.effectsBg = effectCfgs.effectsBg
	self.sx_effects = effectCfgs.sx_effects
	self.sx_frame = effectCfgs.sx_frame
	self.sj_effects = effectCfgs.sj_effects
	self.qh_effects = effectCfgs.qh_effects
	if not self.turnPage and self.unlockingJinnType == nil and self.oldLv ~= nil and self.oldLv ~= self.jinnData.lv then
		self.fields.Usm_2:clearEffect()
		self.fields.Usm_2:setEffectPath(self.qh_effects[self.jinnData.starLv], false, true)
		self.fields.Usm_2:setBlendMode(fgui.BlendMode.Add)
		self.fields.Usm_2:setVisible(true)
	end
	if not self.turnPage and self.unlockingJinnType == nil and self.oldClassLv ~= nil and self.oldClassLv ~= self.jinnData.classLv then
		self.fields.Usm_2:clearEffect()
		self.fields.Usm_2:setEffectPath(self.sj_effects[self.jinnData.starLv], false)
		self.fields.Usm_2:setBlendMode(fgui.BlendMode.Add)
		self.fields.Usm_2:setVisible(true)
	end
	if not self.turnPage and self.unlockingJinnType == nil and self.oldStarLv ~= nil and self.oldStarLv ~= self.jinnData.starLv then
		if self.jinnData.starLv == 1 and self.curType == gJinnType.JINN_ONE then
			self.fields.Usm_1:clearEffect()
			self.fields.Usm_1:setEffectPath("shendengcx_01.usm,shendengdjL1_01.usm", true)
			self.fields.Usm_1:getCriSprite():setSpeed(1, 2)
		else
			self.isShowing = true
			self.fields.Usm_2:clearEffect()
			self.fields.Usm_2:setVisible(true)
			self.fields.Usm_2:setEffectPath(self.sx_effects[self.jinnData.starLv], false)
			self.fields.Usm_2:setBlendMode(fgui.BlendMode.Normal)
			self.fields.Usm_2:getCriSprite():setSpeed(3, 4)
			magicLampRead = 3
			;(3).frame = self.sx_frame[self.jinnData.starLv]
			self.fields.Usm_2:getCriSprite():addFrameEventData(3)
			self.fields.Usm_2:getCriSprite():setFrameEventCallback(function(data)
				self.fields.Usm_1:clearEffect()
				self.fields.Usm_1:setEffectPath(self.effects[self.jinnData.starLv], true)
			end)
		end
	end
	if (self.oldStarLv == nil or self.turnPage) and self.unlockingJinnType == nil then
		self.fields.bg:setURL(self.effectsBg[self.jinnData.starLv])
		self.fields.Usm_1:clearEffect()
		self.fields.Usm_1:setEffectPath(self.effects[self.jinnData.starLv], true)
		self.fields.Usm_1:getCriSprite():setSpeed(3, 4)
	elseif self.unlockingJinnType ~= nil and self.unlockingJinnType == gJinnType.JINN_TWO then
		self.fields.Usm_1:setMaxChunkSize(78176)
		self.fields.bg:setURL("SD_rcdh_first.png")
		self.fields.Usm_1:clearEffect()
		self.fields.Usm_1:setEffectPath("SD_rcdhfire_01.usm,SD_yijiedjfire_01.usm", true)
		self.fields.Usm_1:getCriSprite():setSpeed(1, 1)
	end
	self.oldLv = self.jinnData.lv
	self.oldStarLv = self.jinnData.starLv
	self.oldClassLv = self.jinnData.classLv
end
function MagicLampMainPanel:updateTimers()
	self:updateItems()
	self.breakQueue = queueCtrl:queryQueue(gQueueTypeDef.magic_lamp_jinn_star)
	self.classQueue = queueCtrl:queryQueue(gQueueTypeDef.magic_lamp_jinn_class)
	self.strengthQueue = queueCtrl:queryQueue(gQueueTypeDef.magic_lamp_jinn_level)
	local isSpeedVisible = self:isInQueue(self.strengthQueue) or self:isInQueue(self.classQueue) or self:isInQueue(self.breakQueue)
	local speedTitle = self.breakQueue ~= nil and "magic_lamp_text_005" or self.strengthQueue ~= nil and "magic_lamp_text_007" or "magic_lamp_text_009"
	self.fields.button_speed:setVisible(isSpeedVisible)
	self.fields.button_speed:setTitle(i18n(speedTitle))
	local isNeedBreak = self.breakCfg ~= nil and self.breakCfg.MaxLv <= self.jinnData.lv and self.nextCfg ~= nil
	self.fields.Button_break:setVisible(not isSpeedVisible and isNeedBreak)
	local isNeedClass = self.nextClassCfg ~= nil and self.nextClassCfg.PreLevel <= self.jinnData.lv and self.nextCfg ~= nil
	self.fields.Button_class:setVisible(not isSpeedVisible and not isNeedBreak and isNeedClass)
	self.fields.Button_strength:setVisible(not isSpeedVisible and not isNeedBreak and not isNeedClass and self.nextCfg ~= nil)
	self.fields.Com_have:setVisible(self.fields.Button_strength:isVisible())
	if not self.fields.button_speed:isVisible() then
		self.fields.button_speed:endTime()
	else
		local queue = self.breakQueue ~= nil and self.breakQueue or self.strengthQueue ~= nil and self.strengthQueue or self.classQueue
		self.fields.button_speed:setBeginTime(queue.timerNode.timer:getRemainTime())
	end
end
function MagicLampMainPanel:isInQueue(queue)
	return queue ~= nil and queue.data ~= nil and queue.data.jinnID == self.curType
end
function MagicLampMainPanel:updateItems()
	self.nextCfg = magicLampRead.getStrengthenCfg(self.curType, self.jinnData.lv + 1)
	if self.nextCfg == nil then
		self.fields.Button_strength:setVisible(false)
		self.fields.text_max:setString(i18n("common_text_283"))
		self.fields.text_max:setVisible(true)
		self.fields.max_bg:setVisible(true)
		self.fields.text_lvlock:setVisible(false)
		self.fields.bg_lvlock:setVisible(false)
		return
	end
	if self.curType == gJinnType.JINN_TWO then
		local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
		local nebulaMileStoneLimit = nebulaMileStoneCtrl:getPlusByUnlockTypeEx(gNebulaMileStoneUnlockType.UP_MAGIC_LAMP_2_LV_LIMIT)
		print("神灯2等级上限", self.jinnData.lv, nebulaMileStoneLimit)
		if nebulaMileStoneLimit ~= 0 and nebulaMileStoneLimit <= self.jinnData.lv then
			self.fields.Button_strength:setVisible(false)
			self.fields.text_lvlock:setString(i18n("magic_lamp_text_167"))
			self.fields.text_lvlock:setVisible(true)
			self.fields.bg_lvlock:setVisible(true)
			self.fields.text_max:setVisible(false)
			self.fields.max_bg:setVisible(false)
			self.nextCfg = nil
			return
		end
	end
	self.fields.text_max:setVisible(false)
	self.fields.max_bg:setVisible(false)
	self.fields.text_lvlock:setVisible(false)
	self.fields.bg_lvlock:setVisible(false)
	local baseEffectBuff = magicLampCtrl:getBaseCostBuffValue(self.curType, -3, self.jinnData, "strength")
	for i, v in ipairs(self.nextCfg.spxCost) do
		self.fields.Com_have:initData(v.id)
		local buffSubPercent = magicLampCtrl:getCostBuffValue(self.curType, v.id, self.jinnData, "strength")
		local itemBaseBuff = magicLampCtrl:getBaseCostBuffValue(self.curType, v.id, self.jinnData, "strength")
		local subPercent = buffSubPercent * baseEffectBuff * itemBaseBuff
		local itemNum, isEnough = self.fields.Com_have:updateNum(v.num, subPercent)
		self.fields.Button_strength:setEnabled(isEnough)
	end
end
function MagicLampMainPanel:upadteHatchBtn()
	local hatchTypeCfg = magicLampHatchRead.getHatchTypeByJinnType(gJinnType.JINN_ONE)
	self.fields.Button_hatch:initData(hatchTypeCfg)
end
function MagicLampMainPanel:onJinnsRender(index, obj)
	if index + 1 <= #self.bigBlessCfgs then
		local bigBleesCfg = self.bigBlessCfgs[index + 1]
		obj:initData(self.curType, bigBleesCfg, self.breakCfg.MaxLv)
		obj:setClickCallback(handler(self, self.onJinnSkillClick))
	else
		index = index - #self.bigBlessCfgs
		local extraSlotID = magicLampRead.extraSkillSlotStartIndex + index + 1
		obj:initExtraSkillData(self.curType, index + 1, extraSlotID)
		obj:setClickCallback(handler(self, self.onJinnExtraSkillClick))
	end
end
function MagicLampMainPanel:onAttsRender(index, obj)
	obj:initData(self.attCfgs[index + 1], self.jinnData.lv)
end
function MagicLampMainPanel:onStarsRender(index, obj)
	obj:initData(index < self.curStar, false)
end
function MagicLampMainPanel:onBreakClick()
	SoraDPlaySound()
	if self.curStar >= self.maxStar then
		_ENV = nil
		;(nil).name = i18n(self.jinnCfg.Name)
		SoraDShowMsgTip(i18n("magic_lamp_tips_001", nil))
		return
	end
	_ENV = i18n("magic_lamp_tips_001", nil)
	i18n("magic_lamp_tips_001", nil).jinnType = self.curType
	uiManager:show("MagicLampBreak", i18n("magic_lamp_tips_001", nil))
end
function MagicLampMainPanel:onStrengthClick()
	if self.isShowing then
		return
	end
	SoraDPlaySound()
	if self.nextClassCfg == nil and self.breakCfg ~= nil and self.breakCfg.MaxLv == self.jinnData.lv then
		_ENV = nil
		;(nil).name = i18n(self.jinnCfg.Name)
		SoraDShowMsgTip(i18n("magic_lamp_tips_002", nil))
		return
	elseif self.breakCfg ~= nil and self.breakCfg.MaxLv <= self.jinnData.lv then
		_ENV = i18n("magic_lamp_tips_002", nil)
		i18n("magic_lamp_tips_002", nil).name = i18n(self.jinnCfg.Name)
		SoraDShowMsgTip(i18n("magic_lamp_tips_003", i18n("magic_lamp_tips_002", nil)))
		return
	end
	magicLampCtrl:reqMagicLampUpgradeLv(self.curType, 1)
end
function MagicLampMainPanel:onClassClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).jinnType = self.curType
	uiManager:show("MagicLampClass", nil)
end
function MagicLampMainPanel:onAddSpeed()
	SoraDPlaySound()
	local queue = self.breakQueue ~= nil and self.breakQueue or self.strengthQueue ~= nil and self.strengthQueue or self.classQueue
	if queue == nil then
		return
	end
	local speedUpItemList = backpackCtrl:getSpeedUpItemList(queue.qtype)
	if 0 < #speedUpItemList then
		SoraDShowSpeedUpByItemBox(queue.qtype)
	else
		SoraDShowSpeedUpBox(queue, nil, i18n("common_text_765"))
	end
end
function MagicLampMainPanel:onBlessClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).jinnType = self.curType
	uiManager:show("MagicLampBless", nil)
end
function MagicLampMainPanel:onPrayClick()
	SoraDPlaySound()
	SoraDRemoveAllPanelFromManager()
	uiManager:show("MagicLampMaigcPowerMain")
end
function MagicLampMainPanel:onStarRiverClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).jinnType = self.curType
	uiManager:show("MagicLampStarRiver", nil)
	self:saveClickedUnlockingSlot()
end
function MagicLampMainPanel:saveClickedUnlockingSlot()
	if self.isNeedSaveClickSlot then
		local unlockingSlot = magicLampCtrl:getUnlockingSlot(self.curType)
		magicLampCtrl = unlockingSlot
		unlockingSlot.byUID = true
		SoraDConfigSet("Game:magicLampCtrl:getStarRiverRedDotSlot~integer", math.min(unlockingSlot, self.extraSkillSlotNum), unlockingSlot)
		self.isStarRiverRedDot, self.isNeedSaveClickSlot = magicLampCtrl:getStarRiverRedDot(self.curType)
		self.fields.Button_starRiver:setReddot(self.isStarRiverRedDot)
	end
	if self.fields.Button_starRiver.spriteFinger then
		self.fields.Button_starRiver.spriteFinger:removeFromParent()
		self.fields.Button_starRiver.spriteFinger = nil
	end
end
function MagicLampMainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("magic_lamp_text_001")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function MagicLampMainPanel:onJinnSkillClick(data)
	SoraDPlaySound()
	_ENV = nil
	;(nil).jinnType = self.curType
	;(nil).scrollTo = data.BlessID
	uiManager:show("MagicLampBless", nil)
end
function MagicLampMainPanel:onJinnExtraSkillClick(extraSlotID, isUnlockingSlot)
	SoraDPlaySound()
	_UPVALUE2_ = nil
	;(nil)[1] = extraSlotID
	;(nil)[2] = isUnlockingSlot
	dump(nil, "extraSlotID, isUnlockingSlot")
	if not isUnlockingSlot then
		_ENV = isUnlockingSlot
		isUnlockingSlot.jinnType = self.curType
		isUnlockingSlot.blessID = extraSlotID
		uiManager:show("MagicLampPower", isUnlockingSlot)
	else
		_ENV = isUnlockingSlot
		isUnlockingSlot.jinnType = self.curType
		uiManager:show("MagicLampStarRiver", isUnlockingSlot)
		self:saveClickedUnlockingSlot()
	end
end
function MagicLampMainPanel:onRecountClick()
	SoraDPlaySound()
	uiManager:show("MagicLampRecount")
end
function MagicLampMainPanel:onGroupClick()
	if combinationCtrl == nil or combinationCtrl.isMagicLampCombinationOpen == nil or not combinationCtrl:isMagicLampCombinationOpen() then
		return
	end
	SoraDPlaySound()
	_ENV = nil
	;(nil).jinnType = self.curType
	uiManager:show("MagicLampSkillGroup", nil)
end
function MagicLampMainPanel:onPageClick(sender, params)
	SoraDPlaySound()
	local curIndex = self.curIndex + params
	if self.jinnList[curIndex] == nil then
		if 0 < params then
			curIndex = #self.jinnList
		else
			curIndex = 1
		end
	end
	self.curIndex = curIndex
	self.curType = self.jinnList[self.curIndex]
	self.turnPage = true
	self:updateView()
	self.turnPage = false
end
function MagicLampMainPanel:unlockJinn(jinnType)
	self.curType = jinnType
	self.jinnList = magicLampCtrl:getUnlockedJinnList()
	self.curIndex = 1
	for i, v in ipairs(self.jinnList) do
		if v == self.curType then
			self.curIndex = i
			break
		end
	end
	self.unlockingJinnType = jinnType
	self.turnPage = true
	self:updateView()
	self.turnPage = false
	self.unlockingJinnType = nil
end
function MagicLampMainPanel:showMarkGuideAni()
	self.controllers.c3:setSelectedIndex(1)
	self.fields.Button_starRiver:setVisible(false)
	self.fields.Button_starRiver:setOpacity(0)
	self.fields.Ani_yjjs:setVisible(true)
	self.fields.Ani_yjjs:setAllFrameNameOnce("ccxh_G_unlock_%02d.png", 1, false)
	self.fields.Button_starRiver:setReddot(false)
	local _ENV, seq = self.fields.Button_starRiver.setReddot, self.fields.Button_starRiver.setReddot
	table.insert(seq, ffa.delay(1.0))
	table.insert(seq, ffa.callFunc(function()
		self.fields.Button_starRiver:setVisible(true)
		self.fields.unlockMask:runAction(ffa.fadeOut(0.11666666666666667))
	end))
	table.insert(seq, ffa.fadeIn(0.5))
	table.insert(seq, ffa.callFunc(function()
		self.fields.Button_starRiver:setReddot(self.isStarRiverRedDot)
		local spriteFinger = SoraDFingerAction()
		spriteFinger:addTo(self.fields.Button_starRiver)
		spriteFinger:setPosition(54, 48)
		spriteFinger:setAlpha(0)
		spriteFinger:runAction(cca.fadeIn(0.5))
		self.fields.Button_starRiver.spriteFinger = spriteFinger
		self.controllers.c3:setSelectedIndex(0)
	end))
	self.fields.Button_starRiver:runAction(ffa.seq(seq))
end
function MagicLampMainPanel:unlockNewSlot(newSlots)
	if self.isStarRiverUnlocking then
		newSlots, _ENV = self.isStarRiverUnlocking, self.isStarRiverUnlocking
		for i = 1, self.extraSkillSlotNum do
			table.insert(newSlots, i)
		end
		self.fields.list_jinn:setNumItems(#self.bigBlessCfgs + self.extraSkillSlotNum)
		self.isStarRiverUnlocking = false
	end
	local showUnlockFUnc = function()
		for i, v in ipairs(newSlots) do
			local curSlotIndex = #self.bigBlessCfgs + v - 1
			self.fields.list_jinn:scrollToView(curSlotIndex, false)
			local Com_ML_JinnSkill = self.fields.list_jinn:getChildAt(curSlotIndex)
			Com_ML_JinnSkill:showUnlockAni()
		end
	end
	if newSlots then
		if self.isStarRiverUnlocking then
			self:runAction(ffa.seq(ffa.delay(0.016666666666666666), ffa.callFunc(showUnlockFUnc)))
		else
			showUnlockFUnc()
		end
	end
end
function MagicLampMainPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "jinn" then
		return self.fields.list_jinn:getChildAt(0)
	elseif itemName == "Button_hatch" then
		return self.fields.Button_hatch.fields.icon
	end
	return self.fields[itemName]
end
return MagicLampMainPanel
