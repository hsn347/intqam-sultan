local activity_9001733_Read = include("activity_9001733_Read")
local activity_9001733_Ctrl = SoraDGetCtrl("activity_9001733_Ctrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_factory = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001733/Com_factory", Com_factory)
function Com_factory:onInit()
	self.activityID = gActivityTimeActivityID.FOOTBALL_TREASURE_ACTIVITY
	self.currentFactoryStage = nil
	self.currentFactoryLv = nil
	self.currentFactoryExp = nil
	self.currentEffectIndex = nil
	self.fields.btnFree:getChild("Text_num"):setUBBEnabled(true)
	self.fields.btnPay:addClickListener(handler(self, self.onClick_btnPay))
	self.fields.btnFree:addClickListener(handler(self, self.onClick_btnFree))
	self:fixChildrenPos()
	self.fields.comLv:fixPos()
end
function Com_factory:onShow()
	if self.currentFactoryStage then
		self:playFactoryEffect(self.currentFactoryStage, true)
	end
end
function Com_factory:getEffectIndex(factoryStage)
	factoryStage = factoryStage or 0
	if factoryStage <= 0 then
		return 0
	end
	factoryStage = math.min(factoryStage, 9)
	return 4 - math.min(3, math.ceil(factoryStage / 3))
end
function Com_factory:stopFactoryEffects()
	for index = 1, 3 do
		local transition = self.transitions[tostring(index)]
		if transition then
			transition:stop()
		end
	end
	return self
end
function Com_factory:playFactoryEffect(factoryStage, forcePlay)
	local effectIndex = self:getEffectIndex(factoryStage)
	if effectIndex <= 0 then
		self.currentEffectIndex = effectIndex
		return self:stopFactoryEffects()
	end
	if not forcePlay and self.currentEffectIndex == effectIndex then
		return self
	end
	self:stopFactoryEffects()
	local transition = self.transitions[tostring(effectIndex)]
	if transition then
		transition:play(-1, 0, 0, -1)
	end
	self.currentEffectIndex = effectIndex
	return self
end
function Com_factory:getFreeButtonNumText(freeCount)
	local totalFreeCount = activity_9001733_Read.getDailyFreeRemakeTimes()
	local remainCount = math.max(freeCount or 0, 0)
	local remainText = tostring(remainCount)
	if remainCount <= 0 then
		activity_9001733_Read = nil
		;(nil).color = "#E02B2B"
		remainText = SoraDWrapHtmlTagByStyle(remainText, nil)
	end
	return string.format("(%s/%s)", remainText, tostring(totalFreeCount))
end
function Com_factory:getPayButtonNumText(costCount, ownCount)
	return string.format("%s/%s", string.formatnumberthousands(costCount or 0), string.formatnumberthousands(ownCount or 0))
end
function Com_factory:getFactoryExpGain(fromLevel, fromExp, toLevel, toExp)
	fromLevel = fromLevel or 0
	fromExp = fromExp or 0
	toLevel = toLevel or fromLevel
	toExp = toExp or 0
	if fromLevel > toLevel or toLevel == fromLevel and fromExp >= toExp then
		return 0
	end
	local addExp = 0
	while fromLevel < toLevel do
		local cfg = activity_9001733_Ctrl:getFactoryCfg(fromLevel)
		local maxExp = cfg and cfg.needExp or 0
		if 0 < maxExp then
			addExp = addExp + math.max(maxExp - fromExp, 0)
		end
		fromLevel = fromLevel + 1
		fromExp = 0
	end
	return addExp + math.max(toExp - fromExp, 0)
end
function Com_factory:initData(activityID, updateData)
	self.activityID = activityID or gActivityTimeActivityID.FOOTBALL_TREASURE_ACTIVITY
	local previousFactoryLv = self.currentFactoryLv
	local previousFactoryExp = self.currentFactoryExp
	local factoryLv = activity_9001733_Ctrl:getFactoryLv()
	local factoryExp = activity_9001733_Ctrl:getFactoryExp()
	local freeCount = activity_9001733_Ctrl:getFactoryFreeCount()
	local cfg = activity_9001733_Ctrl:getFactoryCfg(factoryLv)
	local isMax = activity_9001733_Ctrl:isFactoryMax()
	local remakeCost = activity_9001733_Read.getRemakeItemCost()
	local maxExp = cfg and cfg.needExp or 0
	local factoryStage = cfg and cfg.factoryStage or 0
	local addLv = previousFactoryLv and math.max(factoryLv - previousFactoryLv, 0) or 0
	local addExp = 0
	if previousFactoryLv ~= nil and previousFactoryExp ~= nil then
		addExp = self:getFactoryExpGain(previousFactoryLv, previousFactoryExp, factoryLv, factoryExp)
	end
	local shouldAnimate = previousFactoryLv ~= nil and previousFactoryExp ~= nil and 0 < addExp
	self.currentFactoryStage = factoryStage
	self.fields.txtStage:setString(i18n(cfg.factoryName))
	self:playFactoryEffect(factoryStage, 0 < addLv)
	self.fields.machine:initData(factoryStage)
	if 0 < addLv then
		self.fields.machine:playStageEffect(factoryStage, true)
		self.fields.Usm_machine:clearEffect()
		self.fields.Usm_machine:setEffectPath("G_activity_usm_9001594_02.usm")
		self.fields.Usm_machine:play()
	end
	_ENV = "G_activity_usm_9001594_02.usm"
	;("G_activity_usm_9001594_02.usm").level = factoryLv
	;("G_activity_usm_9001594_02.usm").value = factoryExp
	;("G_activity_usm_9001594_02.usm").max = maxExp
	;("G_activity_usm_9001594_02.usm").isMax = isMax
	;("G_activity_usm_9001594_02.usm").animate = shouldAnimate
	;("G_activity_usm_9001594_02.usm").fromLevel = previousFactoryLv
	;("G_activity_usm_9001594_02.usm").fromValue = previousFactoryExp
	self.fields.comLv:initData("G_activity_usm_9001594_02.usm")
	self.currentFactoryLv = factoryLv
	self.currentFactoryExp = factoryExp
	self.fields.btnFree:setTitle(i18n("football_treasure_text_005"))
	self.fields.btnFree:getChild("Text_num"):setString(self:getFreeButtonNumText(freeCount))
	self.fields.btnFree:setTitleColor(display.COLOR_WHITE)
	self.fields.btnFree:setReddot(false, 0)
	self.fields.btnPay:setTitle(i18n("football_treasure_text_006"))
	self.fields.btnPay:setCost(remakeCost.id, remakeCost.count)
	self.fields.btnPay:setCostTitle(self:getPayButtonNumText(remakeCost.count, backpackCtrl:getItemCount(remakeCost.id) or 0))
	self.fields.btnPay:setGrayed(false)
	self.fields.btnPay:setReddot(false, 0)
end
function Com_factory:onClick_btnPay(context)
	SoraDPlaySound()
	local isMax = activity_9001733_Ctrl:isFactoryMax()
	if isMax then
		SoraDShowMsgTip(i18n("football_treasure_text_008"))
		return
	end
	local remakeCost = activity_9001733_Read.getRemakeItemCost()
	if backpackCtrl:getItemCount(remakeCost.id) < remakeCost.count then
		_ENV = i18n("football_treasure_text_008")
		i18n("football_treasure_text_008").itemID = remakeCost.id
		i18n("football_treasure_text_008").itemNum = remakeCost.count
		uiManager:show("Activity_9001733_Getway", i18n("football_treasure_text_008"))
		return
	end
	activity_9001733_Ctrl:reqDonateMsg(false)
end
function Com_factory:onClick_btnFree(context)
	SoraDPlaySound()
	local isMax = activity_9001733_Ctrl:isFactoryMax()
	if isMax then
		SoraDShowMsgTip(i18n("football_treasure_text_008"))
		return
	end
	if activity_9001733_Ctrl:getFactoryFreeCount() <= 0 then
		SoraDShowMsgTip(i18n("football_treasure_text_007"))
		return
	end
	activity_9001733_Ctrl:reqDonateMsg(true)
end
return Com_factory
