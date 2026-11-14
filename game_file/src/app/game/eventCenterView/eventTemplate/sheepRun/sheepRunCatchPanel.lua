local publicRead = include("publicRead")
local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local sheepRunCtrl = gametop.playertop_:getModule("sheepRunCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl", gametop)
local constantRead = include("constantRead")
local sheepRunCatchPanel = class("sheepRunCatchPanel", function(target)
	return target
end)
function sheepRunCatchPanel:ctor()
	self.sheeps = self:getChildren()
	local _ENV, childrenSheep = self:getChildren(), self:getChildren()
	for i, v in ipairs(self.sheeps) do
		local name = v:getName()
		local fileName = name .. "yangpao"
		local sp = display.newSprite("#" .. fileName .. "_01.png")
		sp:setName(name)
		sp:addTo(v)
		sp:setPosition(cc.p(50, 50))
		local animation = self:createAnimate(fileName, 16, true)
		sp:playAnimationForever(animation)
		v:addTouchEventListener(handler(self, self.onSheepClick))
		table.insert(childrenSheep, v)
	end
	for i, v in ipairs(childrenSheep) do
		v:setLocalZOrder(2000 - v:getPositionY())
	end
	self.isClicked = false
end
function sheepRunCatchPanel:reset()
	self.isClicked = false
	for i, v in ipairs(self.sheeps) do
		v:stopAllActions()
		local name = v:getName()
		local sp = v:getChildByName(name)
		sp:stopAllActions()
		local fileName = name .. "yangpao"
		v:getChildByName(v:getName()):setVisible(true)
		sp:setOpacity(0)
		transition.stopTarget(sp)
		sp:setOpacity(255)
		local animation = self:createAnimate(fileName, 16, true)
		sp:playAnimationForever(animation)
		v:setTouchEnabled(true)
	end
end
function sheepRunCatchPanel:initData(mainView)
	self.mainView = mainView
	self.center_tips = SoraDGetChildByName(mainView, "Top_Tips")
	self.image_tip_bg = SoraDGetChildByName(mainView, "Image_tip_bg")
	self.image_tip_bg:setVisible(false)
	self.text_reward_tip = SoraDGetChildByName(mainView, "Text_reward_tip")
	self.unTouchablePanel = SoraDGetChildByName(mainView, "Center_Panel_untouch")
end
function sheepRunCatchPanel:createAnimate(fileName, count, isRd)
	local frames = isRd and self:newFrames(fileName .. "_%.2d.png", 1, count) or display.newFrames(fileName .. "_%.2d.png", 1, count)
	local animation = display.newAnimation(frames, 0.03333333333333333)
	return animation
end
function sheepRunCatchPanel:newFrames(pattern, begin, length)
	local _ENV, frames
	local step = 1
	local last = begin + length - 1
	local rdIdx = math.random(begin, length)
	for index = begin + rdIdx, last, step do
		local frameName = string.format(pattern, index)
		local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
		if not frame then
			printError("display.newFrames() - invalid frame, name %s", tostring(frameName))
			return
		end
		frames[#frames + 1] = frame
	end
	for index = begin, begin + rdIdx - 1, step do
		local frameName = string.format(pattern, index)
		local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
		if not frame then
			printError("display.newFrames() - invalid frame, name %s", tostring(frameName))
			return
		end
		frames[#frames + 1] = frame
	end
	return frames
end
function sheepRunCatchPanel:createCatchEffect()
	local fileName = "buyangwang"
	local sp = display.newSprite(fileName .. "_01")
	local animation = self:createAnimate(fileName, 26)
	sp:playAnimationOnce(animation, true, function()
	end, 0)
	sp:setOpacity(0)
	_UPVALUE2_ = true
	;(true)[1] = cca.fadeIn(0.16666666666666666)
	;(true)[2] = cca.delay(0.5333333333333333)
	;(true)[3] = cca.fadeOut(0.16666666666666666)
	;(true)[4] = cca.fadeOut(0.16666666666666666)
	sp:runAction(cca.seq(true))
	return sp
end
function sheepRunCatchPanel:setCatched(button)
	local name = button:getName()
	local sp = button:getChildByName(name)
	_UPVALUE1_ = nil
	;(nil)[1] = cca.delay(0.26666666666666666)
	;(nil)[2] = cca.callFunc(function()
		local fileName = name .. "yangbeizhua"
		local animation = self:createAnimate(fileName, 16)
		transition.stopTarget(sp)
		sp:playAnimationOnce(animation, false, function()
			sp:setVisible(false)
		end, 0)
		self = false
		;(false)[1] = cca.delay(0.36666666666666664)
		;(false)[2] = cca.fadeOut(0.16666666666666666)
		;(false)[3] = cca.fadeOut(0.16666666666666666)
		sp:runAction(cca.seq(false))
	end)
	;(nil)[3] = cca.callFunc(function()
		local fileName = name .. "yangbeizhua"
		local animation = self:createAnimate(fileName, 16)
		transition.stopTarget(sp)
		sp:playAnimationOnce(animation, false, function()
			sp:setVisible(false)
		end, 0)
		self = false
		;(false)[1] = cca.delay(0.36666666666666664)
		;(false)[2] = cca.fadeOut(0.16666666666666666)
		;(false)[3] = cca.fadeOut(0.16666666666666666)
		sp:runAction(cca.seq(false))
	end)
	button:runAction(cca.seq(nil))
	local catchEf = self:createCatchEffect()
	catchEf:setPosition(cc.p(10, 30))
	catchEf:addTo(sp:getParent())
end
function sheepRunCatchPanel:onSheepClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		local itemNum = backpackCtrl:getItemCount(self.mainView.itemID) or 0
		if itemNum <= 0 then
			SoraDShowMsgTip(i18n("runningSheep_text_09"))
			return
		end
		if self.isClicked or not self.mainView.isInCatch then
			return
		end
		self.isClicked = true
		SoraDPlaySound()
		sheepRunCtrl:reqCatch(false)
		self.unTouchablePanel:setVisible(true)
		button:setTouchEnabled(false)
		self:setCatched(button)
		sheepRunCtrl = i18n("runningSheep_text_09")
		i18n("runningSheep_text_09")[1] = cca.delay(0.5)
		i18n("runningSheep_text_09")[2] = cca.callFunc(function()
			self.isClicked = false
			if self.mainView.isInCatch then
				self.unTouchablePanel:setVisible(false)
			end
		end)
		i18n("runningSheep_text_09")[3] = cca.callFunc(function()
			self.isClicked = false
			if self.mainView.isInCatch then
				self.unTouchablePanel:setVisible(false)
			end
		end)
		self:runAction(cca.seq(i18n("runningSheep_text_09")))
	end
end
function sheepRunCatchPanel:showCatchReward(target, data)
	self.isShowingCatch = true
	self.center_tips:removeChildByName("CriSprite")
	local tipEf = cc.criSprite.createCriSprite("sp_xykp_001.usm", true, false, true)
	tipEf:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	tipEf:setPosition(0, 218)
	tipEf:setVisible(false)
	tipEf:addTo(self.center_tips, -1)
	self.center_tips:stopAllActions()
	self.center_tips:setVisible(true)
	local itemName = publicRead.getName(data.reward.id)
	self.text_reward_tip:setString(itemName .. "X" .. data.reward.count)
	self.text_reward_tip:setVisible(false)
	self.center_tips:setCascadeOpacityEnabled(true)
	self.center_tips:setOpacity(255)
	_UPVALUE4_ = "X"
	;("X")[1] = cca.delay(0.5)
	;("X")[2] = cca.callFunc(function()
		self.text_reward_tip:setVisible(true)
		tipEf:setVisible(true)
		tipEf:start()
	end)
	;("X")[3] = cca.fadeIn(0.1)
	;("X")[4] = cca.delay(0.75)
	;("X")[5] = cca.fadeOut(0.2)
	;("X")[6] = cca.fadeOut(0.2)
	self.center_tips:runAction(cca.seq("X"))
	self.isShowingCatch = false
	if not self.mainView.isInCatch then
		self.mainView:setShowNode()
	end
end
return sheepRunCatchPanel
