local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local ASD = require_data("atlantiswar_skill_display").data
local qualityConfig = gAtlantisQualityConfig
local constantRead = include("constantRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarRead = include("roaringFlameWarRead")
local worldMapAtlantisSkillSingle = class("worldMapAtlantisSkillSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapAtlantisSkillSingle")
	end
	return target
end)
_ENV = "worldMapAtlantisSkillSingle"
;("worldMapAtlantisSkillSingle").NO_SKILL = 1
;("worldMapAtlantisSkillSingle").HAS_SKILL = 2
local _ENV, ("worldMapAtlantisSkillSingle").LOCK, stateType = function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapAtlantisSkillSingle")
	end
	return target
end, 3, "worldMapAtlantisSkillSingle"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapAtlantisSkillSingle")
	end
	return target
end).OUT_WAR = 1
local (function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapAtlantisSkillSingle")
	end
	return target
end).IN_WAR, singleType = 2, function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapAtlantisSkillSingle")
	end
	return target
end
function worldMapAtlantisSkillSingle:setWarType(warType)
	self.warType = warType
	if self.warType == gKingdomClassType.roaringFlame then
		self.time_cd = roaringFlameWarRead.getConstValue("FLAMES_DUNES_SKILL_CD", 0)
	end
end
function worldMapAtlantisSkillSingle:ctor()
	self.curState = stateType.NO_SKILL
	self.remainTime = 0
	self.time_cd = constantRead.getConstValue("ATLANTIS_WAR_SKILL_CD", 0)
	self:initWidget()
end
function worldMapAtlantisSkillSingle:initWidget()
	SoraDGetAllChildFromWidget(self, self)
	self.Button_click:addTouchEventListener(handler(self, self.btnSkillClick))
	self.Button_click:setSwallowTouches(false)
	_ENV = self.Button_click.setSwallowTouches
	self.Button_click.setSwallowTouches[stateType.NO_SKILL] = self.Node_add
	self.Button_click.setSwallowTouches[stateType.HAS_SKILL] = self.Node_have
	self.Node_state, self.Button_click.setSwallowTouches[stateType.LOCK] = self.Button_click.setSwallowTouches, self.Node_lock
end
function worldMapAtlantisSkillSingle:initData(data, otherData)
end
function worldMapAtlantisSkillSingle:initOutWarData(data, otherData)
	self.singleType = singleType.OUT_WAR
	self.index = data.index
	if otherData then
		self.scroll = otherData.scroll
	end
	self.Node_count:setVisible(false)
	local isLock = false
	if self.index >= 4 and data.isPrivilegeLock ~= nil then
		self.isPrivilegeLock = data.isPrivilegeLock
		if not self.isPrivilegeLock then
			self:setState(stateType.LOCK)
			isLock = true
		end
	end
	if not isLock then
		local skillSlot = data.skillSlot
		if skillSlot then
			self:setState(stateType.HAS_SKILL)
			self:initStateHasSkill(skillSlot)
		else
			self:setState(stateType.NO_SKILL)
		end
	end
end
function worldMapAtlantisSkillSingle:initInWarData(data, otherData)
	self.singleType = singleType.IN_WAR
	if otherData then
		self.scroll = otherData.scroll
	end
	self.buffData = data.buffData
	self:setState(stateType.HAS_SKILL)
	local effect = self.buffData.effect
	if effect == gBuffEffect.ATLANTIS_WAR_JUDGE then
		self.Node_count:setVisible(false)
		self.Node_time:setVisible(false)
		self.time_cd = self.buffData.endTime - self.buffData.beginTime
		if not self.loadingBar then
			self:initLoadingBar()
			self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
		end
		self:refreshInWarTime()
	else
		self.Node_time:setVisible(false)
		self.Node_count:setVisible(true)
		self.Text_count:setString(self.buffData.value)
	end
	local config = atlantisActivityCtrl:getBuffConfig(effect)
	local qConfig = qualityConfig[config.itemquality]
	self.Text_name:setString(i18n(config.name))
	self.Text_name:setColor(qConfig.color)
	SoraChangeSpriteImage(self.Image_skill, config.icon)
	SoraChangeSpriteImage(self.Image_quality, qConfig.qImage)
end
function worldMapAtlantisSkillSingle:setState(state)
	self.curState = state
	for i, v in ipairs(self.Node_state) do
		v:setVisible(i == state)
	end
end
function worldMapAtlantisSkillSingle:initStateHasSkill(skillSlot)
	self.skillSlot = skillSlot
	local config = ASD[self.skillSlot.skillId]
	local qConfig = qualityConfig[config.quality]
	self.Text_name:setString(i18n(config.name))
	self.Text_name:setColor(qConfig.color)
	SoraChangeSpriteImage(self.Image_skill, config.img)
	SoraChangeSpriteImage(self.Image_quality, qConfig.qImage)
	if not self.loadingBar then
		self:initLoadingBar()
		self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	end
	self:refreshLastUseTime()
end
function worldMapAtlantisSkillSingle:initLoadingBar(...)
	local loadingBar = display.newProgressTimer(self.Sprite_bar, display.PROGRESS_TIMER_RADIAL)
	loadingBar:setPosition(cc.p(self.Sprite_bar:getPositionX(), self.Sprite_bar:getPositionY()))
	loadingBar:addTo(self.Node_time, -1)
	loadingBar:setScale(self.Sprite_bar:getScale())
	loadingBar:setOpacity(178.5)
	self.loadingBar = loadingBar
	self.Sprite_bar:removeFromParent(true)
end
function worldMapAtlantisSkillSingle:refreshInWarTime(...)
	if self.buffData.value >= 1 then
		self.Node_time:setVisible(false)
		return
	end
	local curTime = serviceFunctions.systemTime()
	local remainTime = math.max(0, self.buffData.endTime - curTime)
	self:refreshCDTime(remainTime)
end
function worldMapAtlantisSkillSingle:refreshLastUseTime(...)
	local lastUseTime = self.skillSlot.lastUseTime
	local curTime = serviceFunctions.systemTime()
	local remainTime = math.max(0, lastUseTime + self.time_cd - curTime)
	self:refreshCDTime(remainTime)
end
function worldMapAtlantisSkillSingle:refreshCDTime(remainTime)
	if 0 < remainTime then
		self.Node_time:setVisible(true)
		self:refreshPercent(remainTime)
		self.Text_time:setTimeLast(function(__, time)
			self:refreshPercent(time)
			return SoraDConvertSecondToStringNoDayNoHour(time)
		end)
		self.Text_time:setTimeEndListener(function()
			self.Node_time:setVisible(false)
			self = self.Node_time
			self.Node_time.msg = "MESSAGE_ATLANTISWAR_SKILL_BTNEFFECT"
			SoraDSendMessage(self.Node_time)
		end)
		self.Text_time:beginTime(remainTime)
	else
		self.Node_time:setVisible(false)
	end
end
function worldMapAtlantisSkillSingle:refreshPercent(time)
	self.remainTime = time
	self.loadingBar:setPercentage(time / self.time_cd * 100)
end
function worldMapAtlantisSkillSingle:onClickSkill(button)
	if self.curState == stateType.NO_SKILL or self.curState == stateType.LOCK then
		stateType = self.curState
		self.curState[stateType.NO_SKILL] = i18n("atlantiswar_skill_text_034")
		local self.curState[stateType.LOCK], msg = i18n("atlantiswar_skill_text_035"), self.curState
		SoraDShowMsgBox(msg[self.curState], i18n("common_text_477"), nil, function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				if self.warType == gKingdomClassType.roaringFlame then
					uiManager:show("RoaringFlame_Skill")
				else
					SoraDCreatePanel("atlantisSkillView"):show()
				end
			end
		end)
	elseif self.curState == stateType.HAS_SKILL then
		if self.singleType == singleType.OUT_WAR then
			if self.remainTime > 0 and self.Node_time:isVisible() then
				stateType = i18n("common_text_477")
				i18n("common_text_477").var = SoraDConvertSecondToStringNoDayNoHour(self.remainTime)
				SoraDShowMsgTip(i18n("atlantiswar_skill_text_038", (i18n("common_text_477"))))
			elseif self.warType == gKingdomClassType.roaringFlame then
				roaringFlameWarCtrl:reqSkillUse(self.index)
			else
				atlantisActivityCtrl:reqSkillUse(self.index)
			end
		elseif self.singleType == singleType.IN_WAR then
			if self.buffData.effect == gBuffEffect.ATLANTIS_WAR_JUDGE then
				if 0 < self.buffData.value then
					atlantisWarCtrl:reqUsePostSkill()
				else
					stateType = i18n("atlantiswar_skill_text_038", (i18n("common_text_477")))
					i18n("atlantiswar_skill_text_038", (i18n("common_text_477"))).var = SoraDConvertSecondToStringNoDayNoHour(self.remainTime)
					SoraDShowMsgTip(i18n("atlantiswar_skill_text_038", i18n("atlantiswar_skill_text_038", (i18n("common_text_477")))))
				end
			else
				SoraDShowMsgTip(i18n("atlantiswar_skill_text_039"))
				gAtlantisUseSkillEffect = self.buffData.effect
				self:showClickView()
			end
		end
	end
end
function worldMapAtlantisSkillSingle:showClickView(...)
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	SoraDSendMessage(nil)
	SoraDManagerRemoveTimerByTarget("gAtlantisUseSkillEffect")
	local parent = display.getRunningScene()
	local clickView = parent:getChildByName("atlantisClickView")
	if not clickView then
		clickView = include("baseView").new(display.realSize, false)
		clickView:setName("atlantisClickView")
		parent:addChild(clickView, 100)
		clickView:setPosition(cc.p(display.cx, display.rcy))
		clickView:setSwallowTouches(false)
		clickView:addTouchEventListener(function(target, event)
			if event == ccui.TouchEventType.ended then
				clickView:removeFromParent()
				SoraDDelayCallOnce("gAtlantisUseSkillEffect", function()
					gAtlantisUseSkillEffect = nil
				end)
			end
		end)
	end
end
function worldMapAtlantisSkillSingle:onClickSkillLong(button)
	if self.curState ~= stateType.HAS_SKILL then
		return
	end
	local buffId
	if self.singleType == singleType.IN_WAR then
		buffId = self.buffData.effect
	else
		buffId = self.skillSlot.skillId
	end
	stateType = nil
	;(nil).initFunc = function(tips, buffId)
		if self.singleType == singleType.IN_WAR then
			local config = atlantisActivityCtrl:getBuffConfig(buffId)
			tips:customName(i18n(config.name))
			tips:customDes(i18n(config.describe))
		else
			local config = ASD[self.skillSlot.skillId]
			tips:customName(i18n(config.name))
			tips:customDes(i18n(config.describe))
		end
		return true
	end
	SoraDShowCommonTips(button, buffId, nil)
end
function worldMapAtlantisSkillSingle:btnSkillClick(button, eventType)
	local longEventTime = 0.4
	local longActTag = 100
	if eventType == ccui.TouchEventType.began then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll, eventType) then
			print("node is not on view")
			return
		end
		SoraDPlaySound()
		self.singleIsMoved = false
		self.isLong = false
		_UPVALUE1_ = "node is not on view"
		;("node is not on view")[1] = cca.delay(longEventTime)
		;("node is not on view")[2] = cca.callFunc(function()
			self.isLong = true
			self:onClickSkillLong(button)
		end)
		;("node is not on view")[3] = cca.callFunc(function()
			self.isLong = true
			self:onClickSkillLong(button)
		end)
		;("node is not on view")[4] = cca.callFunc(function()
			self.isLong = true
			self:onClickSkillLong(button)
		end)
		local seqLong = cca.seq("node is not on view")
		seqLong:setTag(longActTag)
		button:runAction(seqLong)
	elseif eventType == ccui.TouchEventType.ended then
		button:stopActionByTag(longActTag)
		SoraDCloseCommonTips()
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll, eventType) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if not self.isLong then
			self:onClickSkill()
		end
	elseif eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
			button:stopActionByTag(longActTag)
			SoraDCloseCommonTips()
		end
	elseif eventType == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
		button:stopActionByTag(longActTag)
		SoraDCloseCommonTips()
	end
end
return worldMapAtlantisSkillSingle
