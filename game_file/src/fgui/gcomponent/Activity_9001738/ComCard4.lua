local activity_9001738_Read = include("activity_9001738_Read")
local baseComponent = require("fgui.base.baseComponent")
local ComCard4 = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001738/ComCard4", ComCard4)
fgui.register_extension("ui://Activity_9001738/ComCard6", ComCard4)
local CARD_STATE_COVER = "cover"
local CARD_STATE_OPEN = "open"
local TRANSITION_NAME_OPEN = "FlipOpen"
local TRANSITION_NAME_CLOSE = "Flipclose"
local TRANSITION_NAME_IN = "in"
local TRANSITION_NAME_BOMB = "Boom"
local TRANSITION_NAME_FATE = "mingyun"
local TRANSITION_NAME_FREEZE = "freeze"
local TRANSITION_NAME_UNFREEZE = "unfreeze"
local TRANSITION_NAME_DISAPPEAR = "disappear"
local runCallback = function(callback)
	if callback then
		callback()
	end
end
local appendMovieClip = function(list, clip, frameName)
	if not clip then
		return
	end
	table.insert(list, clip)
	clip:setAllFrameName(frameName, 0)
	clip:setVisible(false)
	clip:setAlpha(0)
end
function ComCard4:onInit()
	self:addClickListener(handler(self, self.onClickCard))
	self.effectMovieClips, _ENV = self.addClickListener, self.addClickListener
	appendMovieClip(self.effectMovieClips, self.fields.n13, "dh_budui1_%02d.png")
	appendMovieClip(self.effectMovieClips, self.fields.n14, "dh_budui1_%02d.png")
	appendMovieClip(self.effectMovieClips, self.fields.n17, "9001738_mingyun_%02d.png")
	self.fields.n17:setFrame(34)
	appendMovieClip(self.effectMovieClips, self.fields.n18, "9001738_bingdong_%02d.png")
	appendMovieClip(self.effectMovieClips, self.fields.n21, "9001738_bd_%02d.png")
	appendMovieClip(self.effectMovieClips, self.fields.n22, "activity_9001680_boom_%02d.png")
	appendMovieClip(self.effectMovieClips, self.fields.n23, "9001738_xiaochu_%02d.png")
	self:setLockStateVisible(false)
	self:bindTransitionHook(TRANSITION_NAME_OPEN, CARD_STATE_OPEN, handler(self, self.onOpenFrame))
	self:bindTransitionHook(TRANSITION_NAME_CLOSE, CARD_STATE_COVER, handler(self, self.onCloseFrame))
	self:bindTransitionHook(TRANSITION_NAME_BOMB, TRANSITION_NAME_OPEN, handler(self, self.onBoomFlipOpenHook))
	self:bindTransitionHook(TRANSITION_NAME_FATE, TRANSITION_NAME_DISAPPEAR, handler(self, self.onFateDisappearHook))
	self:bindTransitionHook(TRANSITION_NAME_FATE, TRANSITION_NAME_UNFREEZE, handler(self, self.onFateUnfreezeHook))
end
function ComCard4:onShow()
end
local playTransition = function(transition, completeCallback)
	transition:play(function()
		runCallback(completeCallback)
	end)
end
function ComCard4:findTransition(name)
	return self.transitions[name]
end
function ComCard4:bindTransitionHook(transitionName, hookName, callback)
	self:findTransition(transitionName):setHook(hookName, callback)
end
function ComCard4:playTransitionByName(name, callback)
	playTransition(self:findTransition(name), callback)
end
local normalizeTransitionTime = function(value)
	value = tonumber(value)
	if not value or value ~= value or value < 0 then
		return 0
	end
	return value
end
function ComCard4:getTransitionDuration(name)
	local transition = self:findTransition(name)
	local duration = normalizeTransitionTime(transition.totalDuration)
	if duration <= 0 then
		return 0
	end
	local timeScale = tonumber(transition.timeScale) or 1
	if timeScale <= 0 then
		timeScale = 1
	end
	return duration / timeScale
end
function ComCard4:getTransitionLabelTime(name, label)
	local transition = self:findTransition(name)
	local labelTime = tonumber(transition:GetLabelTime(label))
	if not labelTime or labelTime ~= labelTime or labelTime < 0 then
		return nil
	end
	local timeScale = tonumber(transition.timeScale) or 1
	if timeScale <= 0 then
		timeScale = 1
	end
	return labelTime / timeScale
end
function ComCard4:getCloseEffectDuration()
	return self:getTransitionDuration(TRANSITION_NAME_CLOSE)
end
function ComCard4:getDisappearEffectDuration()
	return self:getTransitionDuration(TRANSITION_NAME_DISAPPEAR)
end
function ComCard4:getEliminateEffectDuration()
	return self:getDisappearEffectDuration()
end
function ComCard4:getFreezeEffectDuration()
	return self:getTransitionDuration(TRANSITION_NAME_FREEZE)
end
function ComCard4:getLockedUnfreezeEffectDuration()
	return self:getTransitionDuration(TRANSITION_NAME_UNFREEZE)
end
function ComCard4:getLockedEliminateEffectDuration()
	return self:getLockedUnfreezeEffectDuration() + self:getDisappearEffectDuration()
end
function ComCard4:getFateEffectDuration(needUnfreeze)
	local maxDuration = self:getTransitionDuration(TRANSITION_NAME_FATE)
	local disappearLabelTime = self:getTransitionLabelTime(TRANSITION_NAME_FATE, TRANSITION_NAME_DISAPPEAR)
	maxDuration = math.max(maxDuration, disappearLabelTime + self:getDisappearEffectDuration())
	if needUnfreeze then
		local unfreezeLabelTime = self:getTransitionLabelTime(TRANSITION_NAME_FATE, TRANSITION_NAME_UNFREEZE)
		maxDuration = math.max(maxDuration, unfreezeLabelTime + self:getLockedUnfreezeEffectDuration())
	end
	return maxDuration
end
function ComCard4:beginCompositeEffect(callback)
	_UPVALUE0_ = nil
	;(nil).pending = 1
	;(nil).callback = callback
	return nil
end
function ComCard4:endCompositeEffect(context)
	if not context then
		return
	end
	context.pending = context.pending - 1
	if context.pending > 0 then
		return
	end
	local callback = context.callback
	context.callback = nil
	runCallback(callback)
end
function ComCard4:playTransitionInComposite(name, context, callback)
	context.pending = context.pending + 1
	playTransition(self:findTransition(name), function()
		runCallback(callback)
		self:endCompositeEffect(context)
	end)
end
function ComCard4:resetFrontState()
	self:setAlpha(1)
	self.fields.n9:setVisible(true)
	self.fields.n9:setAlpha(1)
	self.fields.icon:setVisible(true)
	self.fields.icon:setAlpha(1)
	self.fields.n10:setVisible(true)
	self.fields.n10:setAlpha(1)
	self.fields.n9:setScale(1, 1)
	self.fields.icon:setScale(1, 1)
end
function ComCard4:resetEffectClipAlpha()
	for _, movieClip in ipairs(self.effectMovieClips) do
		movieClip:setAlpha(1)
	end
end
function ComCard4:hideEffectState()
	for _, movieClip in ipairs(self.effectMovieClips) do
		movieClip:setVisible(false)
		movieClip:setAlpha(0)
	end
end
function ComCard4:setFlipGlowStateVisible(isVisible)
	self.fields.n13:setVisible(isVisible == true)
	self.fields.n13:setAlpha(isVisible == true and 1 or 0)
	self.fields.n14:setVisible(isVisible == true)
	self.fields.n14:setAlpha(isVisible == true and 1 or 0)
end
function ComCard4:setLockStateVisible(isVisible)
	local lockNode = self.fields.n19
	if not lockNode then
		return
	end
	lockNode:setVisible(isVisible == true)
	if lockNode.setAlpha then
		lockNode:setAlpha(1)
	end
end
function ComCard4:setOpenState(showLockState)
	self.controllers.ctrlState:setSelectedPage(CARD_STATE_OPEN)
	self:resetFrontState()
	self:hideEffectState()
	if showLockState == nil then
		showLockState = self.isLocked == true
	end
	self:setFlipGlowStateVisible(showLockState ~= true)
	self:setLockStateVisible(showLockState == true)
	self.fields.n10:setScale(0, 1)
end
function ComCard4:setCoverState()
	self.controllers.ctrlState:setSelectedPage(CARD_STATE_COVER)
	self.fields.n10:setScale(1, 1)
	self:resetFrontState()
	self:hideEffectState()
	self:setFlipGlowStateVisible(false)
	self:setLockStateVisible(false)
end
function ComCard4:setClearedState()
	self:hideEffectState()
	self:setFlipGlowStateVisible(false)
	self:setLockStateVisible(false)
	self:setVisible(false)
	self:setTouchEnabled(false)
end
function ComCard4:onOpenFrame()
	self.controllers.ctrlState:setSelectedPage(CARD_STATE_OPEN)
	self.fields.n9:setAlpha(1)
	self.fields.icon:setAlpha(1)
	self:setFlipGlowStateVisible(false)
	self:setLockStateVisible(self.isLocked == true)
end
function ComCard4:onCloseFrame()
	self:hideEffectState()
	self:setLockStateVisible(false)
end
function ComCard4:onBoomFlipOpenHook()
	local context = self.boomEffectContext
	if not context then
		self:onOpenFrame()
		return
	end
	if context.skipFlipOpen == true then
		self:onOpenFrame()
		return
	end
	self:playTransitionInComposite(TRANSITION_NAME_OPEN, context, handler(self, self.setOpenState))
end
function ComCard4:onFateDisappearHook()
	local context = self.fateEffectContext
	if not context then
		return
	end
	self:prepareDisappearState()
	self:playTransitionInComposite(TRANSITION_NAME_DISAPPEAR, context)
end
function ComCard4:onFateUnfreezeHook()
	local context = self.fateEffectContext
	if not context or not context.needUnfreeze then
		return
	end
	self:playTransitionInComposite(TRANSITION_NAME_UNFREEZE, context)
end
local getCardID = function(data)
	local flipInfo = data.flipInfo
	return data.cardID or flipInfo.cardID
end
function ComCard4:refreshCardIcon()
	local cardID = tonumber(getCardID(self.data)) or 0
	self.fields.icon:setURL(activity_9001738_Read.getCardPic(cardID) or "")
	self:resetFrontState()
end
function ComCard4:refreshDebugText()
	local debugValue = userSDKManager.isBeta() and self.data.debugLevelData
	self.fields.txtDebug:setString(debugValue and tostring(debugValue) or "")
end
function ComCard4:initData(data, clickCallback)
