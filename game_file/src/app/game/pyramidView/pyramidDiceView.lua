local gametop = gModuleMgr.getObject("gametop")
local pyramidCtrl = gametop.playertop_:getModule("pyramidCtrl")
local pyramidDiceView = class("pyramidDiceView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("pyramidDiceView")
	end
	return target
end)
function pyramidDiceView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.baseclose = self.close
	function self.close()
		print("overrided ")
	end
	self.isHidePrePanel = false
	self:setBackGround(204.0)
	self.speed = 1.0
	self.MATERIAL_DEFAULT = cc.PhysicsMaterial(0.1, 0.5, 0.5)
	self.STATIC_COLOR = cc.c4f(1.0, 0.0, 0.0, 1.0)
	self.DRAG_BODYS_TAG = 128
	self.isShowDebugDraw = false
	self.isDiceBegin = false
	self.wallDamping = 1.0
	self.wallFriction = 0.0
	self.wallRestitution = 1.0
	self.wallDensity = 1.0
	self.diceDamping = 0.2
	self.diceFriction = 0
	self.diceRestitution = 0.8
	self.diceDensity = 0.0
	self.minThrowAnimDuration = 1.7
	self.minDiceToAnimation = 0.6
	self.num1 = 0
	self.num2 = 0
	self.baseV = 1900
	self.isThrowAnimEnded = false
	self.isDiceAnimEnded = false
	self.isBeginDice = false
	self.isDiceSuccess = false
	self.ccsBg = SoraDGetExtendChildFromCCSByName(self, "Center_CCS_commonPopBox_bg")
	self.ccsBg:hideTitle()
	self.contentLayout = SoraDGetChildByName(self, "Top_Size_layout_content")
	self.diceContent = SoraDGetChildByName(self, "Center_Dice_Content")
	self.text_title = SoraDGetChildByName(self, "text_title")
	self.textScore = SoraDGetChildByName(self, "text_score")
	self.textScore = SoraDCreateScoreLabel(self.textScore)
	self.text_tip = SoraDGetChildByName(self, "text_tip")
	if self.text_title then
		self.text_title:setString(i18n("common_text_1142"))
	end
	if self.text_tip then
		self.text_tip:setString(i18n("common_text_1143"))
		self.text_tip:setLocalZOrder(50)
	end
	SoraDGetAutoHeightLabel(self.text_tip, 530)
	if self.text_title then
		self.text_title:setVisible(false)
		self.text_title:setLocalZOrder(50)
	end
	if self.textScore then
		self.textScore:setVisible(false)
		self.textScore:setLocalZOrder(50)
	end
	self.diceContent:setLocalZOrder(10)
	self.pyramidBg = SoraDGetChildByName(self, "Top_frame_pyramid_Bg")
	if self.diceContent then
		self.contentLayout:setTouchEnabled(true)
		self.diceContent:addTouchEventListener(handler(self, self.onContentEvent))
	end
	self:createArrows()
	self.physicsWorld = cc.Director:getInstance():getRunningScene():getPhysicsWorld()
	self:addClickListener(handler(self, self.onClickSelf))
end
function pyramidDiceView:onEnterOther()
	self:initPhysics()
	self:enableShack()
end
function pyramidDiceView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_UI_PYRAMID_DICE_TO", handler(self, self.msgDiceTo))
	SoraDAddMessage(self, "MESSAGE_UI_PYRAMID_DICE_BEGIN", handler(self, self.msgDiceBegin))
end
function pyramidDiceView:initPhysics()
	if not self.physicsWorld then
		return
	end
	local debug = self.isShowDebugDraw
	self.physicsWorld:setDebugDrawMask(debug and cc.PhysicsWorld.DEBUGDRAW_ALL or cc.PhysicsWorld.DEBUGDRAW_NONE)
	self.physicsWorld:setGravity(cc.p(0, 0))
	self.physicsWorld:setAutoStep(false)
	self:createBodies()
	self:beginTime()
end
function pyramidDiceView:createBodies()
	if not self.physicsWorld then
		return
	end
	if self.diceContent.setPhysicsUpdate then
		self.diceContent:setPhysicsUpdate(true)
	end
	local wallSize = self.diceContent:getContentSize()
	local wall = cc.Node:create()
	wall:setName("wall")
	wall:setPhysicsBody(cc.PhysicsBody:createEdgeBox(wallSize))
	wall:setPosition(cc.p(display.cx, display.cy))
	wall:setPosition(cc.p(wallSize.width / 2, wallSize.height / 2))
	self.diceContent:addChild(wall)
	self.wall = wall
	wall:getPhysicsBody():setLinearDamping(self.wallDamping)
	wall:getPhysicsBody():getShape(0):setFriction(self.wallFriction)
	wall:getPhysicsBody():getShape(0):setRestitution(self.wallRestitution)
	wall:getPhysicsBody():getShape(0):setDensity(self.wallDensity)
	wall:getPhysicsBody():getShape(0):setContactTestBitmask(-1)
	if wall.setPhysicsUpdate then
		wall:setPhysicsUpdate(true)
	end
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	math.random()
	math.random()
	math.random()
	math.random()
	local randName1 = 1
	local spriteName1 = "#" .. (self.exEndFrame or "et_dice_0") .. randName1 .. ".png"
	local dice1 = display.newSprite(spriteName1)
	dice1:setName("dice1")
	dice1:setPosition(284, 224)
	dice1:setPhysicsBody(cc.PhysicsBody:createBox(cc.size(dice1:getContentSize().width * 2 / 3, dice1:getContentSize().height * 2 / 3)))
	dice1:getPhysicsBody():setTag(self.DRAG_BODYS_TAG)
	dice1:getPhysicsBody():setLinearDamping(self.diceDamping)
	dice1:getPhysicsBody():getShape(0):setRestitution(self.diceRestitution)
	dice1:getPhysicsBody():getShape(0):setFriction(self.diceFriction)
	dice1:getPhysicsBody():getShape(0):setDensity(self.diceDensity)
	dice1:getPhysicsBody():getShape(0):setContactTestBitmask(-1)
	self.dice1 = dice1
	if self.dice1.setPhysicsUpdate then
		self.dice1:setPhysicsUpdate(true)
	end
	self.diceContent:addChild(dice1)
	local randomName2 = 5
	local spriteName2 = "#" .. (self.exEndFrame or "et_dice_0") .. randomName2 .. ".png"
	local dice2 = display.newSprite(spriteName2)
	dice2:setName("dice2")
	dice2:setPosition(260, 240)
	dice2:setPhysicsBody(cc.PhysicsBody:createBox(cc.size(dice2:getContentSize().width * 2 / 3, dice2:getContentSize().height * 2 / 3)))
	dice2:getPhysicsBody():setTag(self.DRAG_BODYS_TAG)
	dice2:getPhysicsBody():setLinearDamping(self.diceDamping)
	dice2:getPhysicsBody():getShape(0):setRestitution(self.diceRestitution)
	dice2:getPhysicsBody():getShape(0):setFriction(self.diceFriction)
	dice2:getPhysicsBody():getShape(0):setDensity(self.diceDensity)
	dice2:getPhysicsBody():getShape(0):setContactTestBitmask(-1)
	self.dice2 = dice2
	if self.dice2.setPhysicsUpdate then
		self.dice2:setPhysicsUpdate(true)
	end
	self.diceContent:addChild(dice2)
end
function pyramidDiceView:initExData(throwData, endHandler, exFrames, frameLength, frameTime, exEndFrame, speed)
	self.isEx = true
	self.exFrames = exFrames
	self.frameLength = frameLength
	self.frameTime = frameTime
	self.exEndFrame = exEndFrame
	self.endHandler = endHandler
	self.speed = speed or 1
	self.ccsBg:setVisible(false)
	self:setBackGround(0)
	self.contentLayout:setVisible(false)
	for _, v in ipairs(self.diceContent:getChildren()) do
		if v:getName() == "dice1" or v:getName() == "dice2" or v:getName() == "wall" then
		else
			v:setVisible(false)
		end
	end
	_UPVALUE2_ = self.diceContent:getChildren()
	self.diceContent:getChildren()[1] = cca.callFunc(function()
		self, self = nil, nil
		;(nil).x = math.random(-50, 50)
		;(nil).direction, (nil).y = nil, math.random(-50, 50)
		;(nil).throwData = throwData
		self:msgDiceBegin(self, nil)
	end)
	self.diceContent:getChildren()[2] = cca.delay(0.1)
	self.diceContent:getChildren()[3] = cca.callFunc(function()
		self = nil
		;(nil).throwData = throwData
		self:msgDiceTo(self, nil)
	end)
	self.diceContent:getChildren()[4] = cca.callFunc(function()
		self = nil
		;(nil).throwData = throwData
		self:msgDiceTo(self, nil)
	end)
	self:runAction(cca.seq(self.diceContent:getChildren()))
end
function pyramidDiceView:msgDiceTo(target, data)
	local throwData = data.throwData or pyramidCtrl:getThrowData()
	if not throwData then
		return
	end
	local num1 = throwData.num1 or 0
	local num2 = throwData.num2 or 0
	self.num1 = num1
	self.num2 = num2
	local scoreTo = pyramidCtrl:getScore()
	self.numFrom = scoreTo - num1 - num2
	self.numTo = scoreTo
	self.isDiceSuccess = true
	if self.isThrowAnimEnded == false then
		return
	end
	self:endDice()
end
function pyramidDiceView:endDice()
	if SoraDIsGameGuide() and SoraDIsGameGuide() >= 16003 and SoraDIsGameGuide() <= 16004 then
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_CLOSE_GUIDE"
		SoraDSendMessage(nil)
	end
	if self.dice1 then
		self.dice1:stopAllActions()
		self.dice2:stopAllActions()
		local diceNum1 = self.num1
		local diceNum2 = self.num2
		if diceNum1 == 0 or diceNum1 == nil then
			diceNum1 = 1
		end
		if diceNum2 == 0 or diceNum2 == nil then
			diceNum2 = 1
		end
		local spriteFrame1 = display.newSpriteFrame((self.exEndFrame or "et_dice_0") .. diceNum1 .. ".png")
		if spriteFrame1 then
			self.dice1:setAnimateFrame(spriteFrame1)
		end
		self.dice1:getPhysicsBody():setDynamic(false)
		if diceNum2 and 0 < diceNum2 then
			local spriteFrame2 = display.newSpriteFrame((self.exEndFrame or "et_dice_0") .. diceNum2 .. ".png")
			if spriteFrame2 then
				self.dice2:setAnimateFrame(spriteFrame2)
			end
			self.dice2:getPhysicsBody():setDynamic(false)
		end
	end
	if not self.isEx then
		local duration = 0.6
		self:runScoreAnimation(self.numFrom, self.numTo, duration)
	else
		_UPVALUE1_ = self.numFrom
		self.numFrom[1] = cca.delay(1)
		self.numFrom[2] = cca.callFunc(function()
			self:endScoreAnimation()
		end)
		self.numFrom[3] = cca.callFunc(function()
			self:endScoreAnimation()
		end)
		self:runAction(cca.seq(self.numFrom))
	end
end
function pyramidDiceView:msgDiceBegin(target, data)
	if SoraDIsGameGuide() == nil then
		local spriteHand = self.diceContent:getChildByName("pyramidSpriteHand")
		if spriteHand then
			spriteHand:stopAllActions()
			spriteHand:removeFromParent()
		end
	end
	if self.isDiceBegin == false then
		self.isDiceBegin = true
	else
		return
	end
	local direction = data.direction
	if not direction then
		return
	end
	SoraDPlaySound("pyramid", 3)
	_UPVALUE1_ = nil
	;(nil)[1] = cca.delay(0.3)
	;(nil)[2] = cca.callFunc(function()
		SoraDPlaySound("pyramid", 2)
	end)
	;(nil)[3] = cca.callFunc(function()
		SoraDPlaySound("pyramid", 2)
	end)
	;(nil)[4] = cca.callFunc(function()
		SoraDPlaySound("pyramid", 2)
	end)
	;(nil)[5] = cca.callFunc(function()
		SoraDPlaySound("pyramid", 2)
	end)
	;(nil)[6] = cca.callFunc(function()
		SoraDPlaySound("pyramid", 2)
	end)
	;(nil)[7] = cca.callFunc(function()
		SoraDPlaySound("pyramid", 2)
	end)
	;(nil)[8] = cca.callFunc(function()
		SoraDPlaySound("pyramid", 2)
	end)
	;(nil)[9] = cca.callFunc(function()
		SoraDPlaySound("pyramid", 2)
	end)
	;(nil)[10] = cca.callFunc(function()
		SoraDPlaySound("pyramid", 2)
	end)
	;(nil)[11] = cca.callFunc(function()
		SoraDPlaySound("pyramid", 2)
	end)
	;(nil)[12] = cca.callFunc(function()
		SoraDPlaySound("pyramid", 2)
	end)
	;(nil)[13] = cca.callFunc(function()
		SoraDPlaySound("pyramid", 2)
	end)
	;(nil)[14] = cca.callFunc(function()
		SoraDPlaySound("pyramid", 2)
	end)
	;(nil)[15] = cca.callFunc(function()
		SoraDPlaySound("pyramid", 2)
	end)
	;(nil)[16] = cca.callFunc(function()
		SoraDPlaySound("pyramid", 2)
	end)
	self:runAction(cca.seq(nil))
	self:stopArrowAnimation()
	self.text_tip:setVisible(false)
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	math.random()
	math.random()
	math.random()
	math.random()
	local rotate1 = math.pi / 3 - math.random() * math.pi / 3
	local rotate2 = math.pi / 3 - math.random() * math.pi / 3
	print("rotate1: ", rotate1)
	print("rotate2: ", rotate2)
	dump(direction, "direction")
	local direction1 = cc.pRotateByAngle(direction, cc.p(0, 0), rotate1)
	local direction2 = cc.pRotateByAngle(direction, cc.p(0, 0), rotate2)
	local dLength1 = cc.pGetLength(direction1)
	local nd1 = cc.p(direction1.x / dLength1, direction1.y / dLength1)
	local dLength2 = cc.pGetLength(direction2)
	local nd2 = cc.p(direction2.x / dLength2, direction2.y / dLength2)
	local baseV = self.baseV or 1900
	local velocity1 = cc.p(baseV * nd1.x, baseV * nd1.y)
	local velocity2 = cc.p(baseV * nd2.x, baseV * nd2.y)
	local throw2dice = not data.throwData or data.throwData and table.nums(data.throwData) == 2
	if self.dice1 then
		self.dice2:setVisible(throw2dice)
		self.dice1:getPhysicsBody():setDynamic(true)
		self.dice1:getPhysicsBody():setVelocity(velocity1)
		if throw2dice then
			self.dice2:getPhysicsBody():setDynamic(true)
			self.dice2:getPhysicsBody():setVelocity(velocity2)
		end
		local frames = self:getShuffleFrames(self.exFrames or "et_pyramid_dice_0%d.png", 1, self.frameLength or 8)
		local animation = display.newAnimation(frames, 0.05 or self.frameTime)
		self.dice1:playAnimationForever(animation)
		if throw2dice then
			local frames = self:getShuffleFrames(self.exFrames or "et_pyramid_dice_0%d.png", 1, self.frameLength or 8, true)
			local animation = display.newAnimation(frames, 0.05 or self.frameTime)
			self.dice2:playAnimationForever(animation)
		end
	end
	_UPVALUE1_ = display.newAnimation(frames, 0.05 or self.frameTime)
	display.newAnimation(frames, 0.05 or self.frameTime)[1] = cca.delay(self.minThrowAnimDuration / self.speed)
	display.newAnimation(frames, 0.05 or self.frameTime)[2] = cca.callFunc(function()
		self:minThrowAnimCallBack()
	end)
	display.newAnimation(frames, 0.05 or self.frameTime)[3] = cca.callFunc(function()
		self:minThrowAnimCallBack()
	end)
	display.newAnimation(frames, 0.05 or self.frameTime)[4] = cca.callFunc(function()
		self:minThrowAnimCallBack()
	end)
	self:runAction(cca.seq((display.newAnimation(frames, 0.05 or self.frameTime))))
end
function pyramidDiceView:getShuffleFrames(pattern, begin, length, isReversed)
	local _ENV, frames
	frames = display.newFrames(pattern, begin, length, isReversed)
	for i = 1, #frames * 2 do
		local a = math.random(#frames)
		local b = math.random(#frames)
		frames[a], frames[b] = frames[b], frames[a]
	end
	return frames
end
function pyramidDiceView:onBtnClose(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:baseclose(nil, ccui.TouchEventType.ended)
	end
end
function pyramidDiceView:onContentEvent(target, eventType)
	if eventType == ccui.TouchEventType.began then
	elseif eventType == ccui.TouchEventType.ended then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchEndPoint = target:getTouchEndPosition()
		local direction = cc.pSub(touchEndPoint, touchBeganPoint)
		if direction.x == 0 and direction.y == 0 then
			print("random direction")
			direction.x = math.random(1, 20)
			direction.y = math.random(1, 20)
		end
		_ENV = 1
		;(1).msg = "MESSAGE_UI_PYRAMID_DICE_BEGIN"
		;(1).direction = direction
		SoraDSendMessage(1)
	elseif eventType == ccui.TouchEventType.canceled then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchEndPoint = target:getTouchMovePosition()
		local direction = cc.pSub(touchEndPoint, touchBeganPoint)
		if direction.x == 0 and direction.y == 0 then
			print("random direction")
			direction.x = math.random(1, 20)
			direction.y = math.random(1, 20)
		end
		_ENV = 1
		;(1).msg = "MESSAGE_UI_PYRAMID_DICE_BEGIN"
		;(1).direction = direction
		SoraDSendMessage(1)
	end
end
function pyramidDiceView:closeSelf()
	self:baseclose(nil, ccui.TouchEventType.ended)
end
function pyramidDiceView:createSingleArrow(firstIndex, num)
	local arrowSpriteName = "#" .. "frame_main_integration_arrow.png"
	local layoutArrow = ccui.Layout:create()
	layoutArrow:setContentSize(cc.size(210, 80))
	local hightLight = 1
	local deltaW = 40
	for i = 1, num do
		local arrowSprite = display.newSprite(arrowSpriteName)
		arrowSprite:setRotation(-90)
		layoutArrow:addChild(arrowSprite)
		local arrowSize = arrowSprite:getContentSize()
		arrowSprite:setPosition(cc.p(i * deltaW - deltaW / 2 + i * 4, 40))
		local arrowName = "arrow_" .. firstIndex .. "_" .. i
		arrowSprite:setName(arrowName)
		self[arrowName] = arrowSprite
		if i ~= hightLight then
			arrowSprite:setColor(cc.c3b(120, 120, 120))
			arrowSprite:setOpacity(180)
		end
		arrowSprite:setScale(0.7 + i * 0.1)
	end
	return layoutArrow
end
function pyramidDiceView:runArrowAnimation()
	local curLightIndex = 1
	local delay = cca.delay(0.14)
	local callFuncStep = cca.callFunc(function()
		for i = 1, 4 do
			local arrowName = "arrow_" .. i .. "_" .. curLightIndex
			if self[arrowName] then
				self[arrowName]:setColor(cc.c3b(255, 255, 255))
				self[arrowName]:setOpacity(255)
			end
			for j = 1, 3 do
				if j ~= curLightIndex then
					local arrowNameOther = "arrow_" .. i .. "_" .. j
					if self[arrowNameOther] then
						self[arrowNameOther]:setColor(cc.c3b(120, 120, 120))
						self[arrowNameOther]:setOpacity(180)
					end
				end
			end
		end
		if 4 < curLightIndex then
			self.diceContent:stopAllActions()
			local delay = cca.delay(0.14)
			local callFuncAnim = cca.callFunc(function()
				self:runArrowAnimation()
			end)
			_ENV = 1
			;(1)[1] = delay
			;(1)[2] = callFuncAnim
			self.diceContent:runAction(cca.seq(1))
		end
	end)
	_UPVALUE2_ = nil
	;(nil)[1] = callFuncStep
	;(nil)[2] = delay
	self.diceContent:runAction(cca.repeatForever(cca.seq(nil)))
end
function pyramidDiceView:createArrows()
	local diceContentSize = self.diceContent:getContentSize()
	local deltaW = 160
	local deltaH = 160
	local layoutArrowL = self:createSingleArrow(1, 3)
	layoutArrowL:setName("layoutArrowL")
	self.diceContent:addChild(layoutArrowL)
	layoutArrowL:setAnchorPoint(cc.p(0.5, 0.5))
	layoutArrowL:setRotation(-180)
	layoutArrowL:setPosition(cc.p(diceContentSize.width / 2 - deltaW, diceContentSize.height / 2))
	local layoutArrowT = self:createSingleArrow(2, 3)
	layoutArrowT:setName("layoutArrowT")
	self.diceContent:addChild(layoutArrowT)
	layoutArrowT:setAnchorPoint(cc.p(0.5, 0.5))
	layoutArrowT:setRotation(-90)
	layoutArrowT:setPosition(cc.p(diceContentSize.width / 2, diceContentSize.height / 2 + deltaH))
	local layoutArrowR = self:createSingleArrow(3, 3)
	layoutArrowR:setName("layoutArrowR")
	self.diceContent:addChild(layoutArrowR)
	layoutArrowR:setAnchorPoint(cc.p(0.5, 0.5))
	layoutArrowR:setPosition(cc.p(diceContentSize.width / 2 + deltaW, diceContentSize.height / 2))
	local layoutArrowB = self:createSingleArrow(4, 3)
	layoutArrowB:setName("layoutArrowB")
	self.diceContent:addChild(layoutArrowB)
	layoutArrowB:setAnchorPoint(cc.p(0.5, 0.5))
	layoutArrowB:setRotation(90)
	layoutArrowB:setPosition(cc.p(diceContentSize.width / 2, diceContentSize.height / 2 - deltaH))
	self:runArrowAnimation()
end
function pyramidDiceView:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime), true)
	self:updateTime(0.0)
end
function pyramidDiceView:updateTime(dt)
	if not self.physicsWorld then
		return
	end
	for i = 1, 3 do
		self.physicsWorld:step(0.005555555555555556)
	end
end
function pyramidDiceView:endTime()
	SoraDManagerRemoveTimer(self, self.timeHandler)
	self.timeHandler = nil
end
function pyramidDiceView:runScoreAnimation(numFrom, numTo, duration)
	self.text_title:setVisible(true)
	self.textScore:setVisible(true)
	self.textScore:runScoreAnimation(numFrom, numTo, duration)
	_UPVALUE1_ = numTo
	numTo[1] = cca.delay(duration + 1.0)
	numTo[2] = cca.callFunc(function()
		self:endScoreAnimation()
	end)
	numTo[3] = cca.callFunc(function()
		self:endScoreAnimation()
	end)
	self:runAction(cca.seq(numTo))
end
function pyramidDiceView:endScoreAnimation()
	if self.endHandler then
		self.endHandler()
	end
	self:baseclose(nil, ccui.TouchEventType.ended)
	_ENV = self
	self.msg = "MESSAGE_UI_PYRAMID_SCORE_TO"
	SoraDSendMessage(self)
end
function pyramidDiceView:minThrowAnimCallBack()
	self.isThrowAnimEnded = true
	if self.isDiceSuccess then
		self:endDice()
	end
end
function pyramidDiceView:stopArrowAnimation()
	self.diceContent:stopAllActions()
	local curLightIndex = 0
	for i = 1, 4 do
		local arrowName = "arrow_" .. i .. "_" .. curLightIndex
		if self[arrowName] then
			self[arrowName]:setColor(cc.c3b(255, 255, 255))
			self[arrowName]:setOpacity(255)
		end
		for j = 1, 3 do
			if j ~= curLightIndex then
				local arrowNameOther = "arrow_" .. i .. "_" .. j
				if self[arrowNameOther] then
					self[arrowNameOther]:setColor(cc.c3b(120, 120, 120))
					self[arrowNameOther]:setOpacity(180)
					self[arrowNameOther]:setVisible(false)
				end
			end
		end
	end
end
function pyramidDiceView:onShackCallBack()
	print("摇一摇的回调~~~~~~")
	local _ENV, direction = print, print
	direction.x = math.random(1, 20)
	direction.y = math.random(1, 20)
	_ENV = 1
	;(1).msg = "MESSAGE_UI_PYRAMID_DICE_BEGIN"
	;(1).direction = direction
	SoraDSendMessage(1)
end
function pyramidDiceView:enableShack()
	print("启用摇一摇")
	SoraDShackON(self.diceContent, handler(self, self.onShackCallBack))
end
function pyramidDiceView:disableShack()
	SoraDShackOFF(self.diceContent)
end
function pyramidDiceView:onExitPanel()
	self:disableShack()
	if not self.physicsWorld then
		return
	end
end
function pyramidDiceView:createWheelAction()
	local spriteHand = self.diceContent:getChildByName("pyramidSpriteHand")
	if spriteHand then
		_UPVALUE10_ = "pyramidSpriteHand"
		_UPVALUE2_ = nil
		;(nil)[1] = cc.p(235, 230)
		;(nil)[2] = cc.p(235, 370)
		;(nil)[3] = cc.p(500, 425)
		;(nil)[4] = cc.p(500, 425)
		;(nil)[5] = cc.p(500, 425)
		;("pyramidSpriteHand")[1] = cca.callFunc(function(...)
			spriteHand:setPosition(cc.p(320, 160))
			spriteHand:setVisible(true)
		end)
		;("pyramidSpriteHand")[2] = cca.fadeIn(0.1)
		;("pyramidSpriteHand")[3] = cca.scaleTo(0.1, 1.2)
		;("pyramidSpriteHand")[4] = cca.scaleTo(0.1, 1)
		;("pyramidSpriteHand")[5] = cca.delay(0.2)
		;("pyramidSpriteHand")[6] = cc.BezierTo:create(0.5, nil)
		;("pyramidSpriteHand")[7] = cca.delay(0.2)
		;("pyramidSpriteHand")[8] = cca.fadeOut(0.1)
		;("pyramidSpriteHand")[9] = cca.callFunc(function(...)
			spriteHand:setVisible(false)
		end)
		;("pyramidSpriteHand")[10] = cca.delay(0.5)
		;("pyramidSpriteHand")[11] = cca.callFunc(function(...)
			if SoraDIsGameGuide() == 16004 then
				self:createWheelAction()
			else
				spriteHand:removeFromParent()
			end
		end)
		;("pyramidSpriteHand")[12] = cca.callFunc(function(...)
			if SoraDIsGameGuide() == 16004 then
				self:createWheelAction()
			else
				spriteHand:removeFromParent()
			end
		end)
		;("pyramidSpriteHand")[13] = cca.callFunc(function(...)
			if SoraDIsGameGuide() == 16004 then
				self:createWheelAction()
			else
				spriteHand:removeFromParent()
			end
		end)
		;("pyramidSpriteHand")[14] = cca.callFunc(function(...)
			if SoraDIsGameGuide() == 16004 then
				self:createWheelAction()
			else
				spriteHand:removeFromParent()
			end
		end)
		local newAction = cca.seq("pyramidSpriteHand")
		spriteHand:runAction(newAction)
	end
end
function pyramidDiceView:clickEffect(target)
	_ENV, _ENV = nil, nil
	;(nil)[1], (nil).plist = nil, "et_dianji_display.plist"
	local param
	local parNode = SoraDCreateEffectNode(param)
	parNode:setName("particle_click_node")
	parNode:setPosition(cc.p(target:getContentSize().width / 2 - 30, target:getContentSize().height / 2 - 30))
	parNode:addTo(target, -1)
end
function pyramidDiceView:gameGuide_getTarget(itemName, parameters)
	if itemName == "Center_Dice_Content" and self.diceContent:getChildByName("pyramidSpriteHand") == nil then
		local spriteHand = SoraDFingerAction()
		spriteHand:setName("pyramidSpriteHand")
		spriteHand:setPosition(300, 400)
		spriteHand:addTo(self.diceContent, 1)
		self:createWheelAction()
	end
	return SoraDGetChildByName(self, itemName)
end
function pyramidDiceView:onClickSelf()
	if self.clickCallBack then
		self.clickCallBack()
	end
end
function pyramidDiceView:setClickCallBack(callback)
	self.clickCallBack = callback
end
return pyramidDiceView
