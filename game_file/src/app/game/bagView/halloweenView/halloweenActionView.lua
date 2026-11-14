local HalloweenActionView = class("halloweenActionView", function(target)
	if target == nil then
		local target = SoraDCreateBasePanel("halloweenActionView")
		target:setSwallowTouches(false)
		return target
	end
	return target
end)
function HalloweenActionView:ctor()
	_UPVALUE4_, self.fromData, _ENV = nil, nil, nil
	self.tableRand, (nil)[1] = nil, 1
	self.tableRand, (nil)[2] = nil, 2
	self.tableRand, (nil)[3] = nil, 3
	self.tableRand, (nil)[4] = nil, 4
	self.closeCount = 0
	self.baseCount = 1
	self.isHidePrePanel = false
	self:setLocalZOrder(50)
	self:addTouchEventListener(handler(self, self.btnClickCallBack))
	if display.getAnimationCache("bfflyAnimation") == nil then
		local frames = display.newFrames("et_bffly_%.2d.png", 1, 2)
		local animation = display.newAnimation(frames, 0.1)
		display.setAnimationCache("bfflyAnimation", animation)
	end
end
function HalloweenActionView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local child = self:getChildren()
		for i, v in ipairs(child) do
			if v:getName() ~= "name" and v:getName() ~= "afk" then
				v:stopAllActions()
				v:removeFromParent()
				self:updateClose()
			end
		end
	end
end
function HalloweenActionView:initData(tip, fromData, isAFK, noShowName, isShowWarning)
	if tip then
		self:showTips(2, 20)
	else
		if isAFK then
			_UPVALUE3_ = self.showTips
			self.tableRand, self.showTips[1] = self.showTips, 1
			self.tableRand, self.showTips[2] = self.showTips, 2
			self.tableRand, self.showTips[3] = self.showTips, 3
			self.baseCount = 2
		end
		for i, v in ipairs(fromData) do
			table.insert(self.fromData, v)
			if #self.tableRand > 0 then
				math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
				local index = table.remove(self.tableRand, math.random(1, #self.tableRand))
				if index == 1 then
					self:showSpider()
				elseif index == 2 then
					self:showPumpkin(2)
				elseif index == 3 then
					self:showBffly(2)
				elseif index == 4 then
					self:showPumpkinBffly(2)
				end
			end
		end
		if noShowName then
		else
			self:showName(isAFK)
		end
		if isShowWarning then
			self.warning = ccui.ImageView:create("frame_sheer_red_01.png", ccui.TextureResType.plistType)
			self.warning:ignoreContentAdaptWithSize(false)
			self.warning:setContentSize(display.size)
			self.warning:setAnchorPoint(cc.p(0.5, 0.5))
			self.warning:setPosition(cc.p(display.cx, display.cy))
			self.warning:addTo(display.getRunningScene(), 7)
			local actionTintTo = cca.fadeTo(1, 0)
			local actionTinBack = cca.fadeTo(1, 1)
			local actionDelay = cca.delay(0.8)
			_UPVALUE3_ = cc.p(display.cx, display.cy)
			cc.p(display.cx, display.cy)[1] = actionTintTo
			cc.p(display.cx, display.cy)[2] = actionTinBack
			cc.p(display.cx, display.cy)[3] = actionDelay
			local actionRepeat = cca.repeatForever(cca.seq(cc.p(display.cx, display.cy)))
			self.warning:runAction(actionRepeat)
		end
	end
end
function HalloweenActionView:showName(isAFK)
	local singleDelay = 0.2
	local moveDelay = 2
	local singleHeight = 100
	if #self.fromData < 10 then
		singleDelay = 0.4
		moveDelay = 2
	elseif #self.fromData < 50 then
		singleDelay = 0.2
		moveDelay = 1
	else
		singleDelay = 0.05
		moveDelay = 0.7
		singleHeight = 300
	end
	for i, v in ipairs(self.fromData) do
		self.closeCount = self.closeCount + 1
		local labelName = ccui.Text:create()
		labelName:setFontSize(24)
		labelName:setColor(cc.c3b(45, 150, 65))
		_ENV = cc.c3b(45, 150, 65)
		cc.c3b(45, 150, 65).name = v
		labelName:setString(i18n("common_text_2238", cc.c3b(45, 150, 65)))
		labelName:setOpacity(0)
		labelName:setName("name")
		labelName:addTo(self, 2)
		labelName:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		labelName:setPosition(cc.p(320, 0.5 * display.height - singleHeight))
		_UPVALUE3_ = cc.p(320, 0.5 * display.height - singleHeight)
		_UPVALUE1_ = cc.p(320, 0.5 * display.height - singleHeight)
		_UPVALUE1_ = 320
		;(320)[1] = cca.delay(moveDelay - 0.3)
		;(320)[2] = cca.fadeOut(0.3)
		;(320)[3] = cca.fadeOut(0.3)
		cc.p(320, 0.5 * display.height - singleHeight)[1] = cca.moveTo(moveDelay, 320, 0.5 * display.height + 50)
		cc.p(320, 0.5 * display.height - singleHeight)[2] = cca.seq(320)
		cc.p(320, 0.5 * display.height - singleHeight)[3] = cca.seq(320)
		cc.p(320, 0.5 * display.height - singleHeight)[4] = cca.seq(320)
		cc.p(320, 0.5 * display.height - singleHeight)[5] = cca.seq(320)
		cc.p(320, 0.5 * display.height - singleHeight)[6] = cca.seq(320)
		cc.p(320, 0.5 * display.height - singleHeight)[1] = cca.delay(singleDelay * i)
		cc.p(320, 0.5 * display.height - singleHeight)[2] = cca.fadeIn(0.1)
		cc.p(320, 0.5 * display.height - singleHeight)[3] = cca.spawn(cc.p(320, 0.5 * display.height - singleHeight))
		cc.p(320, 0.5 * display.height - singleHeight)[4] = cca.callFunc(function(...)
			labelName:removeFromParent()
			self:updateClose()
		end)
		cc.p(320, 0.5 * display.height - singleHeight)[5] = cca.callFunc(function(...)
			labelName:removeFromParent()
			self:updateClose()
		end)
		cc.p(320, 0.5 * display.height - singleHeight)[6] = cca.callFunc(function(...)
			labelName:removeFromParent()
			self:updateClose()
		end)
		cc.p(320, 0.5 * display.height - singleHeight)[7] = cca.callFunc(function(...)
			labelName:removeFromParent()
			self:updateClose()
		end)
		cc.p(320, 0.5 * display.height - singleHeight)[8] = cca.callFunc(function(...)
			labelName:removeFromParent()
			self:updateClose()
		end)
		cc.p(320, 0.5 * display.height - singleHeight)[9] = cca.callFunc(function(...)
			labelName:removeFromParent()
			self:updateClose()
		end)
		cc.p(320, 0.5 * display.height - singleHeight)[10] = cca.callFunc(function(...)
			labelName:removeFromParent()
			self:updateClose()
		end)
		labelName:runAction(cca.seq(cc.p(320, 0.5 * display.height - singleHeight)))
	end
	self.fromData, _ENV = ipairs(self.fromData)
	if isAFK and not self:getChildByName("afk") then
		local labelName = ccui.Text:create()
		labelName:setFontSize(24)
		labelName:setColor(cc.c3b(45, 150, 65))
		labelName:setString(i18n("common_text_2237"))
		labelName:setName("afk")
		labelName:addTo(self, 3)
		labelName:setAnchorPoint(SoraDFAP(1, 0.5))
		labelName:setPosition(SoraDFPoint(600, 0.5 * display.height + 110, 640))
	end
end
function HalloweenActionView:updateClose()
	self.closeCount = self.closeCount - 1
	if self.closeCount <= 0 then
		self:removeFromParent()
	end
end
function HalloweenActionView:showTips(delay, rewardNum)
	self.closeCount = self.closeCount + rewardNum
	local height = display.height
	local _ENV, tableBeginPos
	local _ENV, tableEndPos
	local _ENV, tableScale
	local _ENV, tableRotate
	local beginDelay = SoraDGetRandNum(rewardNum, 0.5 * delay)
	tableBeginPos.x = SoraDGetRandNum(rewardNum, 600, 640)
	tableBeginPos.y = SoraDGetRandNum(rewardNum, height / 2, height / 2 + 160)
	tableEndPos.x = SoraDGetRandNum(rewardNum, -40, 0)
	tableEndPos.y = SoraDGetRandNum(rewardNum, height / 2 - 160, height / 2)
	tableScale.beginS = SoraDGetRandNum(rewardNum, 0.5)
	tableScale.endS = SoraDGetRandNum(rewardNum, 2)
	tableRotate[1] = SoraDGetRandNum(rewardNum, -20, 20, true)
	tableRotate[2] = SoraDGetRandNum(rewardNum, -20, 20, true)
	tableRotate[3] = SoraDGetRandNum(rewardNum, -20, 20, true)
	for i = 1, rewardNum do
		do
			local goldSprite = display.newSprite("#et_bffly_01.png")
			goldSprite:setPosition(cc.p(tableBeginPos.x[i], tableBeginPos.y[i]))
			goldSprite:setOpacity(0)
			goldSprite:setRotation(tableRotate[1][i])
			goldSprite:setScale(tableScale.beginS[i] + 0.5)
			self:addChild(goldSprite)
			_UPVALUE5_ = self
			_UPVALUE2_ = cc.p(tableBeginPos.x[i], tableBeginPos.y[i])
			_UPVALUE1_ = tableEndPos.x[i]
			tableEndPos.x[i][1] = cca.rotateBy(0.25 * delay, tableRotate[2][i])
			tableEndPos.x[i][2] = cca.rotateBy(0.25 * delay, tableRotate[3][i])
			tableEndPos.x[i][3] = cca.rotateBy(0.25 * delay, tableRotate[3][i])
			tableEndPos.x[i][4] = cca.rotateBy(0.25 * delay, tableRotate[3][i])
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[1] = cca.moveTo(0.5 * delay, tableEndPos.x[i], tableEndPos.y[i])
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[2] = cca.seq(tableEndPos.x[i])
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[3] = cca.scaleTo(0.5 * delay, tableScale.endS[i] + 1)
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[4] = cca.scaleTo(0.5 * delay, tableScale.endS[i] + 1)
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[5] = cca.scaleTo(0.5 * delay, tableScale.endS[i] + 1)
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[6] = cca.scaleTo(0.5 * delay, tableScale.endS[i] + 1)
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[7] = cca.scaleTo(0.5 * delay, tableScale.endS[i] + 1)
			self[1] = cca.delay(beginDelay[i])
			self[2] = cca.callFunc(function(...)
				goldSprite:playAnimationForever(display.getAnimationCache("bfflyAnimation"))
			end)
			self[3] = cca.fadeIn(0.2)
			self[4] = cca.spawn(cc.p(tableBeginPos.x[i], tableBeginPos.y[i]))
			self[5] = cca.fadeOut(0.2)
			self[6] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[7] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[8] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[9] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[10] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[11] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[12] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			local seq = cca.seq(self)
			goldSprite:runAction(seq)
		end
	end
	SoraDPlaySound("uicontrol", 7)
end
function HalloweenActionView:showSpider()
	self:showSpiderMan(3)
	self:showSpiderWeb(2)
end
function HalloweenActionView:showSpiderMan(delay)
	local rewardNum = 20
	self.closeCount = self.closeCount + rewardNum
	local height = display.height
	local _ENV, tableBeginPos
	local _ENV, tableEndPos
	local _ENV, tableScale
	local _ENV, tableRotate
	local beginDelay = SoraDGetRandNum(rewardNum, 0.5)
	tableBeginPos.x = SoraDGetRandNum(rewardNum, 20, 620)
	tableEndPos.y = SoraDGetRandNum(rewardNum, 0.1 * height, 0.9 * height)
	tableScale.beginS = SoraDGetRandNum(rewardNum, 2)
	for i = 1, rewardNum do
		do
			local goldSprite = display.newNode()
			local spiderSprite = display.newSprite("#frame_Halloween_zhizhu.png")
			local lineSprite = display.newSprite("#frame_Halloween_zhizhusi.png")
			spiderSprite:addTo(goldSprite)
			spiderSprite:setScale(tableScale.beginS[i] + 0.5)
			lineSprite:setAnchorPoint(cc.p(0.5, 0))
			lineSprite:setPosition(cc.p(2, 10))
			lineSprite:setScaleY((height - tableEndPos.y[i]) / 24)
			lineSprite:addTo(goldSprite, -1)
			goldSprite:setPosition(cc.p(tableBeginPos.x[i], height))
			goldSprite:setOpacity(0)
			self:addChild(goldSprite)
			_UPVALUE5_ = self
			self[1] = cca.delay(beginDelay[i])
			self[2] = cca.fadeIn(0.1)
			self[3] = cc.EaseBackOut:create(cca.moveTo(0.6 * delay, tableBeginPos.x[i], tableEndPos.y[i]))
			self[4] = cca.delay(0.1 * delay)
			self[5] = cc.EaseBackIn:create(cca.moveTo(0.3 * delay, tableBeginPos.x[i], height + 100))
			self[6] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[7] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[8] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[9] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[10] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			local seq = cca.seq(self)
			goldSprite:runAction(seq)
		end
	end
end
function HalloweenActionView:showSpiderWeb(delay)
	local rewardNum = 15
	self.closeCount = self.closeCount + rewardNum
	local height = display.height
	local _ENV, tableBeginPos
	local _ENV, tableEndPos
	local _ENV, tableScale
	local _ENV, tableRotate
	local beginDelay = SoraDGetRandNum(rewardNum, 0.5)
	tableBeginPos.x = SoraDGetRandNum(rewardNum, 40, 600)
	tableBeginPos.y = SoraDGetRandNum(rewardNum, 100, 0.7 * height)
	tableEndPos.x = SoraDGetRandNum(rewardNum, -40, 40)
	tableEndPos.y = SoraDGetRandNum(rewardNum, -40, 40)
	tableScale.beginS = SoraDGetRandNum(rewardNum, 1)
	tableScale.endS = SoraDGetRandNum(rewardNum, 1, 4)
	tableRotate = SoraDGetRandNum(rewardNum, -180, 180)
	for i = 1, rewardNum do
		do
			local goldSprite = display.newSprite("#frame_Halloween_zhizhuwang.png")
			goldSprite:setPosition(cc.p(tableBeginPos.x[i], tableBeginPos.y[i]))
			goldSprite:setOpacity(0)
			goldSprite:setRotation(tableRotate[i])
			goldSprite:setScale(tableScale.beginS[i])
			self:addChild(goldSprite)
			_UPVALUE5_ = self
			_UPVALUE1_ = cc.p(tableBeginPos.x[i], tableBeginPos.y[i])
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[1] = cca.scaleTo(0.2, tableScale.endS[i])
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[2] = cca.moveTo(0.2, tableBeginPos.x[i] + tableEndPos.x[i], tableBeginPos.y[i] + tableEndPos.y[i])
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[3] = cca.moveTo(0.2, tableBeginPos.x[i] + tableEndPos.x[i], tableBeginPos.y[i] + tableEndPos.y[i])
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[4] = cca.moveTo(0.2, tableBeginPos.x[i] + tableEndPos.x[i], tableBeginPos.y[i] + tableEndPos.y[i])
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[5] = cca.moveTo(0.2, tableBeginPos.x[i] + tableEndPos.x[i], tableBeginPos.y[i] + tableEndPos.y[i])
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[6] = cca.moveTo(0.2, tableBeginPos.x[i] + tableEndPos.x[i], tableBeginPos.y[i] + tableEndPos.y[i])
			self[1] = cca.delay(beginDelay[i])
			self[2] = cca.fadeIn(0.1)
			self[3] = cca.spawn(cc.p(tableBeginPos.x[i], tableBeginPos.y[i]))
			self[4] = cca.delay(0.8 * delay)
			self[5] = cca.fadeOut(0.2)
			self[6] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[7] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[8] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[9] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[10] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			local seq = cca.seq(self)
			goldSprite:runAction(seq)
		end
	end
end
function HalloweenActionView:showPumpkin(delay)
	local rewardNum = 60 / self.baseCount
	self.closeCount = self.closeCount + rewardNum
	local height = display.height
	local _ENV, tableBeginPos
	local _ENV, tableEndPos
	local _ENV, tableScale
	local _ENV, tableRotate
	local beginDelay = SoraDGetRandNum(rewardNum, 1, 5 * delay)
	local _ENV, heightMax = rewardNum, rewardNum
	for i, v in ipairs(SoraDGetRandNum(3, 1, rewardNum)) do
		heightMax[v] = true
	end
	tableBeginPos.x = SoraDGetRandNum(rewardNum, 40, 600)
	tableBeginPos.y = SoraDGetRandNum(rewardNum, height - 100, height - 40)
	tableEndPos.height = SoraDGetRandNum(rewardNum, 0.2 * height, 0.4 * height)
	tableEndPos.y = SoraDGetRandNum(rewardNum, 40, 130)
	tableScale.beginS = SoraDGetRandNum(rewardNum, 1)
	tableRotate = SoraDGetRandNum(rewardNum, -20, 20, true)
	for i = 1, rewardNum do
		do
			local goldSprite = display.newSprite("#8027.png")
			goldSprite:setPosition(cc.p(tableBeginPos.x[i], tableBeginPos.y[i]))
			goldSprite:setAnchorPoint(cc.p(0.5, 0.4))
			goldSprite:setOpacity(0)
			goldSprite:setRotation(tableRotate[i])
			goldSprite:setScale(tableScale.beginS[i] + 0.5)
			self:addChild(goldSprite)
			_UPVALUE4_ = self
			_UPVALUE2_ = cc.p(0.5, 0.4)
			_UPVALUE1_ = cc.p(0.5, 0.4)
			cc.p(0.5, 0.4)[1] = cca.moveTo(0.2, tableBeginPos.x[i], tableEndPos.y[i])
			cc.p(0.5, 0.4)[2] = cca.jumpTo(delay, tableBeginPos.x[i] + math.random(-60, 60), tableEndPos.y[i], tableEndPos.height[i] + (heightMax[i] and 0.5 * height or 0), math.floor(tableEndPos.height[i] / 100))
			cc.p(0.5, 0.4)[3] = cca.jumpTo(delay, tableBeginPos.x[i] + math.random(-60, 60), tableEndPos.y[i], tableEndPos.height[i] + (heightMax[i] and 0.5 * height or 0), math.floor(tableEndPos.height[i] / 100))
			cc.p(0.5, 0.4)[4] = cca.jumpTo(delay, tableBeginPos.x[i] + math.random(-60, 60), tableEndPos.y[i], tableEndPos.height[i] + (heightMax[i] and 0.5 * height or 0), math.floor(tableEndPos.height[i] / 100))
			cc.p(0.5, 0.4)[5] = cca.jumpTo(delay, tableBeginPos.x[i] + math.random(-60, 60), tableEndPos.y[i], tableEndPos.height[i] + (heightMax[i] and 0.5 * height or 0), math.floor(tableEndPos.height[i] / 100))
			cc.p(0.5, 0.4)[6] = cca.jumpTo(delay, tableBeginPos.x[i] + math.random(-60, 60), tableEndPos.y[i], tableEndPos.height[i] + (heightMax[i] and 0.5 * height or 0), math.floor(tableEndPos.height[i] / 100))
			cc.p(0.5, 0.4)[7] = cca.jumpTo(delay, tableBeginPos.x[i] + math.random(-60, 60), tableEndPos.y[i], tableEndPos.height[i] + (heightMax[i] and 0.5 * height or 0), math.floor(tableEndPos.height[i] / 100))
			cc.p(0.5, 0.4)[8] = cca.jumpTo(delay, tableBeginPos.x[i] + math.random(-60, 60), tableEndPos.y[i], tableEndPos.height[i] + (heightMax[i] and 0.5 * height or 0), math.floor(tableEndPos.height[i] / 100))
			cc.p(0.5, 0.4)[9] = cca.jumpTo(delay, tableBeginPos.x[i] + math.random(-60, 60), tableEndPos.y[i], tableEndPos.height[i] + (heightMax[i] and 0.5 * height or 0), math.floor(tableEndPos.height[i] / 100))
			cc.p(0.5, 0.4)[10] = cca.jumpTo(delay, tableBeginPos.x[i] + math.random(-60, 60), tableEndPos.y[i], tableEndPos.height[i] + (heightMax[i] and 0.5 * height or 0), math.floor(tableEndPos.height[i] / 100))
			_UPVALUE5_ = 0 < tableRotate[i] and tableRotate[i] + 20 or tableRotate[i] - 20
			;(0 < tableRotate[i] and tableRotate[i] + 20 or tableRotate[i] - 20)[1] = cca.rotateTo(0.2 * delay, 0 < tableRotate[i] and -(tableRotate[i] + 15) or -(tableRotate[i] - 15))
			;(0 < tableRotate[i] and tableRotate[i] + 20 or tableRotate[i] - 20)[2] = cca.rotateTo(0.15 * delay, 0 < tableRotate[i] and tableRotate[i] + 12 or tableRotate[i] - 12)
			;(0 < tableRotate[i] and tableRotate[i] + 20 or tableRotate[i] - 20)[3] = cca.rotateTo(0.1 * delay, 0 < tableRotate[i] and -(tableRotate[i] + 8) or -(tableRotate[i] - 8))
			;(0 < tableRotate[i] and tableRotate[i] + 20 or tableRotate[i] - 20)[4] = cca.rotateTo(0.05 * delay, 0 < tableRotate[i] and tableRotate[i] + 5 or tableRotate[i] - 5)
			;(0 < tableRotate[i] and tableRotate[i] + 20 or tableRotate[i] - 20)[5] = cca.rotateTo(0.05 * delay, 0 < tableRotate[i] and -(tableRotate[i] + 3) or -(tableRotate[i] - 3))
			;(0 < tableRotate[i] and tableRotate[i] + 20 or tableRotate[i] - 20)[6] = cca.rotateTo(0.01 * delay, 0)
			;(0 < tableRotate[i] and tableRotate[i] + 20 or tableRotate[i] - 20)[7] = cca.rotateTo(0.01 * delay, 0)
			;(0 < tableRotate[i] and tableRotate[i] + 20 or tableRotate[i] - 20)[8] = cca.rotateTo(0.01 * delay, 0)
			cc.p(0.5, 0.4)[1] = cca.seq(cc.p(0.5, 0.4))
			cc.p(0.5, 0.4)[2] = cca.rotateTo(0.5 * delay, 0 < tableRotate[i] and tableRotate[i] + 20 or tableRotate[i] - 20)
			cc.p(0.5, 0.4)[3] = cca.seq(0 < tableRotate[i] and tableRotate[i] + 20 or tableRotate[i] - 20)
			cc.p(0.5, 0.4)[4] = cca.seq(0 < tableRotate[i] and tableRotate[i] + 20 or tableRotate[i] - 20)
			cc.p(0.5, 0.4)[5] = cca.seq(0 < tableRotate[i] and tableRotate[i] + 20 or tableRotate[i] - 20)
			cc.p(0.5, 0.4)[6] = cca.seq(0 < tableRotate[i] and tableRotate[i] + 20 or tableRotate[i] - 20)
			cc.p(0.5, 0.4)[7] = cca.seq(0 < tableRotate[i] and tableRotate[i] + 20 or tableRotate[i] - 20)
			cc.p(0.5, 0.4)[8] = cca.seq(0 < tableRotate[i] and tableRotate[i] + 20 or tableRotate[i] - 20)
			cc.p(0.5, 0.4)[9] = cca.seq(0 < tableRotate[i] and tableRotate[i] + 20 or tableRotate[i] - 20)
			cc.p(0.5, 0.4)[10] = cca.seq(0 < tableRotate[i] and tableRotate[i] + 20 or tableRotate[i] - 20)
			cc.p(0.5, 0.4)[11] = cca.seq(0 < tableRotate[i] and tableRotate[i] + 20 or tableRotate[i] - 20)
			cc.p(0.5, 0.4)[12] = cca.seq(0 < tableRotate[i] and tableRotate[i] + 20 or tableRotate[i] - 20)
			self[1] = cca.delay(beginDelay[i] / 10)
			self[2] = cca.fadeIn(0.2)
			self[3] = cca.spawn(cc.p(0.5, 0.4))
			self[4] = cca.fadeOut(0.2)
			self[5] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[6] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[7] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[8] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[9] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[10] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[11] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[12] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[13] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[14] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[15] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[16] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			local seq = cca.seq(self)
			goldSprite:runAction(seq)
		end
	end
	SoraDPlaySound("uicontrol", 8)
end
function HalloweenActionView:showPumpkinBffly(delay)
	local rewardNum = 60
	self.closeCount = self.closeCount + rewardNum
	local height = display.height
	local _ENV, tableBeginPos
	local _ENV, tableEndPos
	local _ENV, tableScale
	local _ENV, tableRotate
	local beginDelay = SoraDGetRandNum(rewardNum, 1, 10 * delay)
	tableBeginPos.x = SoraDGetRandNum(rewardNum, 160, 480)
	tableBeginPos.y = SoraDGetRandNum(rewardNum, height / 2 - 160, height / 2 + 160)
	tableEndPos.x = SoraDGetRandNum(rewardNum, 0, 640)
	tableEndPos.y = SoraDGetRandNum(rewardNum, 0, height)
	tableScale.beginS = SoraDGetRandNum(rewardNum, 1)
	tableScale.endS = SoraDGetRandNum(rewardNum, 2)
	tableRotate[1] = SoraDGetRandNum(rewardNum, -20, 20, true)
	tableRotate[2] = SoraDGetRandNum(rewardNum, -20, 20, true)
	tableRotate[3] = SoraDGetRandNum(rewardNum, -20, 20, true)
	for i = 1, rewardNum do
		do
			local goldSprite = display.newSprite("#8027.png")
			goldSprite:setPosition(cc.p(tableBeginPos.x[i], tableBeginPos.y[i]))
			goldSprite:setOpacity(0)
			goldSprite:setRotation(tableRotate[1][i])
			goldSprite:setScale(tableScale.beginS[i])
			self:addChild(goldSprite)
			_UPVALUE4_ = self
			_UPVALUE2_ = cc.p(tableBeginPos.x[i], tableBeginPos.y[i])
			_UPVALUE1_ = tableEndPos.x[i]
			tableEndPos.x[i][1] = cca.rotateBy(0.25 * delay, tableRotate[2][i])
			tableEndPos.x[i][2] = cca.rotateBy(0.25 * delay, tableRotate[3][i])
			tableEndPos.x[i][3] = cca.rotateBy(0.25 * delay, tableRotate[3][i])
			tableEndPos.x[i][4] = cca.rotateBy(0.25 * delay, tableRotate[3][i])
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[1] = cca.moveTo(0.5 * delay, tableEndPos.x[i], tableEndPos.y[i])
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[2] = cca.seq(tableEndPos.x[i])
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[3] = cca.scaleTo(0.5 * delay, tableScale.endS[i] + 0.5)
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[4] = cca.scaleTo(0.5 * delay, tableScale.endS[i] + 0.5)
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[5] = cca.scaleTo(0.5 * delay, tableScale.endS[i] + 0.5)
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[6] = cca.scaleTo(0.5 * delay, tableScale.endS[i] + 0.5)
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[7] = cca.scaleTo(0.5 * delay, tableScale.endS[i] + 0.5)
			self[1] = cca.delay(beginDelay[i] / 10)
			self[2] = cca.fadeIn(0.2)
			self[3] = cca.spawn(cc.p(tableBeginPos.x[i], tableBeginPos.y[i]))
			self[4] = cca.fadeOut(0.2)
			self[5] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[6] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[7] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[8] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[9] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[10] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[11] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			local seq = cca.seq(self)
			goldSprite:runAction(seq)
		end
	end
	SoraDPlaySound("uicontrol", 8)
end
function HalloweenActionView:showBffly(delay)
	local rewardNum = 100
	self.closeCount = self.closeCount + rewardNum
	local height = display.height
	local _ENV, tableBeginPos
	local _ENV, tableEndPos
	local _ENV, tableScale
	local _ENV, tableRotate
	local beginDelay = SoraDGetRandNum(rewardNum, 1, 10 * delay)
	tableBeginPos.x = SoraDGetRandNum(rewardNum, 160, 480)
	tableBeginPos.y = SoraDGetRandNum(rewardNum, height / 2 - 160, height / 2 + 160)
	tableEndPos.x = SoraDGetRandNum(rewardNum, 0, 640)
	tableEndPos.y = SoraDGetRandNum(rewardNum, 0, height)
	tableScale.beginS = SoraDGetRandNum(rewardNum, 1)
	tableScale.endS = SoraDGetRandNum(rewardNum, 2)
	tableRotate[1] = SoraDGetRandNum(rewardNum, -20, 20, true)
	tableRotate[2] = SoraDGetRandNum(rewardNum, -20, 20, true)
	tableRotate[3] = SoraDGetRandNum(rewardNum, -20, 20, true)
	for i = 1, rewardNum do
		do
			local goldSprite = display.newSprite("#et_bffly_01.png")
			goldSprite:setPosition(cc.p(tableBeginPos.x[i], tableBeginPos.y[i]))
			goldSprite:setOpacity(0)
			goldSprite:setRotation(tableRotate[1][i])
			goldSprite:setScale(tableScale.beginS[i] + 0.5)
			self:addChild(goldSprite)
			_UPVALUE5_ = self
			_UPVALUE2_ = cc.p(tableBeginPos.x[i], tableBeginPos.y[i])
			_UPVALUE1_ = tableEndPos.x[i]
			tableEndPos.x[i][1] = cca.rotateBy(0.25 * delay, tableRotate[2][i])
			tableEndPos.x[i][2] = cca.rotateBy(0.25 * delay, tableRotate[3][i])
			tableEndPos.x[i][3] = cca.rotateBy(0.25 * delay, tableRotate[3][i])
			tableEndPos.x[i][4] = cca.rotateBy(0.25 * delay, tableRotate[3][i])
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[1] = cca.moveTo(0.5 * delay, tableEndPos.x[i], tableEndPos.y[i])
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[2] = cca.seq(tableEndPos.x[i])
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[3] = cca.scaleTo(0.5 * delay, tableScale.endS[i] + 2)
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[4] = cca.scaleTo(0.5 * delay, tableScale.endS[i] + 2)
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[5] = cca.scaleTo(0.5 * delay, tableScale.endS[i] + 2)
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[6] = cca.scaleTo(0.5 * delay, tableScale.endS[i] + 2)
			cc.p(tableBeginPos.x[i], tableBeginPos.y[i])[7] = cca.scaleTo(0.5 * delay, tableScale.endS[i] + 2)
			self[1] = cca.delay(beginDelay[i] / 10)
			self[2] = cca.callFunc(function(...)
				goldSprite:playAnimationForever(display.getAnimationCache("bfflyAnimation"))
			end)
			self[3] = cca.fadeIn(0.2)
			self[4] = cca.spawn(cc.p(tableBeginPos.x[i], tableBeginPos.y[i]))
			self[5] = cca.fadeOut(0.2)
			self[6] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[7] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[8] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[9] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[10] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[11] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			self[12] = cca.callFunc(function()
				goldSprite:removeFromParent()
				self:updateClose()
			end)
			local seq = cca.seq(self)
			goldSprite:runAction(seq)
		end
	end
	SoraDPlaySound("uicontrol", 7)
end
function HalloweenActionView:onExitPanel()
	display.removeAnimationCache("bfflyAnimation")
	if self.warning then
		self.warning:removeFromParent()
	end
end
return HalloweenActionView
