local buildLogic = include("buildLogic")
local buildRead = include("buildDescribeRead")
local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local cityBuildFunction = include("cityBuildFunction")
local cityltCtrl = include("cityltCtrl")
local maincityDesRead = include("maincityDesRead")
local cityBuildConstDef = include("cityBuildConstDef")
local cityBuildCreator = include("cityBuildCreator")
local cityBuildViewDef = include("cityBuildViewDef")
local wallsCtrl = gametop.playertop_:getModule("wallsCtrl")
local timeRewardCtrl = gametop.playertop_:getModule("timeRewardCtrl")
local loginRewardCtrl = gametop.playertop_:getModule("loginRewardCtrl")
local kingdomWeatherCtrl = gametop.playertop_:getModule("kingdomWeatherCtrl")
local activityCtrl = gametop.playertop_:getModule("activityCtrl")
local worldMapFunction = include("worldMapFunction")
local worldMapDefine = include("worldMapDefine")
local cityBuildViewDef = include("cityBuildViewDef")
local offset = cc.p(0, 0)
local cityBuildFirstFight = class("cityBuildFirstFight", function(ccsFile)
	return SoraDCreateBasePanel("cityFirstFightView")
end)
function cityBuildFirstFight:ctor()
	AudioEngine.stopMusic()
	AudioEngine.playMusic(getAudioFileNameByPlatform("worldMap", "BGM"), true)
	if not self.effectWarFire then
		self.effectWarFire = self:createEffectWarFire()
		if self.effectWarFire and not tolua.isnull(self.effectWarFire) then
			self:addChild(self.effectWarFire, 5)
			self.effectWarFire:setPosition(cc.p(display.width / 2, 0))
		end
	end
	self:setSwallowTouches(false)
	self.btn_pass = SoraDGetChildByName(self, "btn_pass")
	if self.btn_pass then
		self.btn_pass:setLocalZOrder(5)
		self.btn_pass:addTouchEventListener(handler(self, self.btnPass))
	end
	self.btn_pass:setVisible(true)
	self.btn_replay = SoraDGetChildByName(self, "btn_replay")
	if self.btn_replay then
		self.btn_replay:setLocalZOrder(5)
		self.btn_replay:addTouchEventListener(handler(self, self.btnReplay))
	end
	self.btn_end = SoraDGetChildByName(self, "btn_end")
	if self.btn_end then
		self.btn_end:setLocalZOrder(5)
		self.btn_end:addTouchEventListener(handler(self, self.btnEnd))
	end
	self.top_op = SoraDGetChildByName(self, "Top_Op")
	self.text_pass = SoraDGetChildByName(self, "text_pass")
	if self.text_pass then
		self.text_pass:setString(i18n("common_text_1037"))
	end
	if self.text_pass:getContentSize().width > 104 then
		local oriPassSize = self.btn_pass:getContentSize()
		self.btn_pass:setContentSize(cc.size(self.text_pass:getContentSize().width - 104 + oriPassSize.width, oriPassSize.height))
		if SoraDFIsRA() then
			self.text_pass:setPositionX(self.text_pass:getPositionX() + (self.text_pass:getContentSize().width - 104) / 2)
			local frame_guide_lace_01_1 = SoraDGetChildByName(self.btn_pass, "frame_guide_lace_01_1")
			if frame_guide_lace_01_1 then
				frame_guide_lace_01_1:setPositionX(frame_guide_lace_01_1:getPositionX() + (self.text_pass:getContentSize().width - 104) / 2)
			end
			local frame_guide_lace_02_2 = SoraDGetChildByName(self.btn_pass, "frame_guide_lace_02_2")
			if frame_guide_lace_02_2 then
				frame_guide_lace_02_2:setPositionX(frame_guide_lace_02_2:getPositionX() + (self.text_pass:getContentSize().width - 104) / 2)
			end
		end
	end
	self.panelMask = cc.LayerColor:create(cc.c4b(0, 0, 0, 0))
	self.panelMask:setContentSize(display.realSize)
	self.panelMask:ignoreAnchorPointForPosition(false)
	self.panelMask:setAnchorPoint(cc.p(0.5, 0))
	self.panelMask:setPosition(cc.p(display.width / 2, -display.iPhoneXBottom))
	self:addChild(self.panelMask, 2)
	self.panelMask:setVisible(false)
	self.panelMask:setLocalZOrder(6)
	_ENV = self.panelMask
	self.panelMask.text = i18n("common_text_1033")
	self.panelMask.size = 24
	self.panelMask.color = cc.c3b(255, 255, 255)
	self.panelMask.align = cc.VERTICAL_TEXT_ALIGNMENT_MIDDLE
	self.panelMask.valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
	self.panelMask.x = display.width / 2
	self.panelMask.y = display.height / 2
	self.text_tip = display.newTTFLabel(self.panelMask)
	self.panelMask:addChild(self.text_tip, 10)
	self.text_tip:setVisible(false)
	self.text_tip:setLocalZOrder(10)
	self.text_tip:setGlobalZOrder(1005)
	do return end
	self.minScale = 0.6
	self.minLimitScale = 0.5
	self.defaultScale = 0.9
	self.normalScale = 0.8
	self.maxScale = 1.8
	self.maxLimitScale = 2.0
	self.inertia = 1.4
	self.initScrollViewScale = 1.4
	self.normlScrollViewScale = 1.0
	self.zoomScaleDuration = 0.3
	self.initZoomScaleDuration = 0.6
	self.autoMoveSpeed = 1000
	self.autoMoveSpeedSlow = 600
	self.hUITop = 0
	self.hUIBottom = 0
	self.tipBoxCount = 1
	self.tipBoxMaxCount = 12
	self.viewModelWall = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	self.isMoved = false
	self.isMoveOnBuild = false
	self.currentSelectBuild = nil
	self.currentSelectTip = nil
	self.viewScrollView = nil
	self.containerView = nil
	self.touchlayer = nil
	self.isNeedRecover = false
	self.preContainerOffset = nil
	self.preContainerOffsetTip = nil
	self.isOnMoveMode = false
	self.currentSelectMoveModeIndex = 0
	self.afterSelectMoveModeIndex = 0
	self.currentTopTipArray, _ENV, self.currentMoveBtnArray, _ENV, self.currentSelectMoveModeType = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1, cityBuildConstDef.VIEWMODEL.VIEWMODEL_1, cityBuildConstDef.VIEWMODEL.VIEWMODEL_1, cityBuildConstDef.VIEWMODEL.VIEWMODEL_1, 0
	self.bufferNodeArray, _ENV, self.isOnCollectMode = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1, cityBuildConstDef.VIEWMODEL.VIEWMODEL_1, false
	self.hasCommunityCenterMsg = false
	self.hasConquerGateMsg = false
	self:setContentSize(display.size)
	local firstFightPath = getCCSPath("cityBuildFirstFight")
	self.containerView = cc.CSLoader:createNode(firstFightPath)
	local viewScrollViewSize = cc.size(self:getContentSize().width, self:getContentSize().height - (self.hUITop + self.hUIBottom))
	self.initScrollViewScale = display.height / viewScrollViewSize.height
	self.viewScrollView = cc.ScrollView:create(viewScrollViewSize)
	self.viewScrollView:setContainer(self.containerView)
	self.containerView:setPosition(cc.p(-700, -500))
	self.viewScrollView:setMinScale(self.minScale)
	self.viewScrollView:setMaxScale(self.maxScale)
	self.viewScrollView:setZoomScale(self.normalScale)
	self.zoomScale = self.normalScale
	self.viewScrollView:setBounceable(false)
	self.viewScrollView:setInertiaValue(self.inertia)
	self.viewScrollView:ignoreAnchorPointForPosition(false)
	self.viewScrollView:setAnchorPoint(cc.p(0.5, 0.5))
	self.viewScrollView:setScale(1)
	self.viewScrollView:setPosition(cc.p(display.width / 2, display.height / 2))
	self:addChild(self.viewScrollView, 1)
	self.viewScrollView:setClippingToBounds(true)
	self.btn_export = SoraDGetChildByName(self.containerView, "btn_export")
	self.btn_close = SoraDGetChildByName(self.containerView, "btn_close")
	self.btn_play = SoraDGetChildByName(self.containerView, "btn_play")
	self.btn_load = SoraDGetChildByName(self.containerView, "btn_load")
	self.btn_generate = SoraDGetChildByName(self.containerView, "btn_generate")
	self.btn_loadEffect = SoraDGetChildByName(self.containerView, "btn_loadEffect")
	self.btn_loadTest = SoraDGetChildByName(self.containerView, "btn_loadTest")
	if self.btn_close then
		self.btn_close:addTouchEventListener(handler(self, self.btnClose))
	end
	if self.btn_export then
		self.btn_export:addTouchEventListener(handler(self, self.btnExport))
	end
	if self.btn_play then
		self.btn_play:addTouchEventListener(handler(self, self.btnPlay))
	end
	if self.btn_load then
		self.btn_load:addTouchEventListener(handler(self, self.btnLoad))
	end
	if self.btn_generate then
		self.btn_generate:addTouchEventListener(handler(self, self.btnGenerate))
	end
	if self.btn_loadEffect then
		self.btn_loadEffect:addTouchEventListener(handler(self, self.btnLoadEffect))
	end
	if self.btn_loadTest then
		self.btn_loadTest:addTouchEventListener(handler(self, self.btnLoadTest))
	end
	self.tblEffects, _ENV, self.tblBuilds, _ENV, self.tblDynamicSoldiers, _ENV, self.tblStaticSoldiers, _ENV = self.btn_loadTest.addTouchEventListener, self.btn_loadTest.addTouchEventListener, self.btn_loadTest.addTouchEventListener, self.btn_loadTest.addTouchEventListener, self.btn_loadTest.addTouchEventListener, self.btn_loadTest.addTouchEventListener, self.btn_loadTest.addTouchEventListener, self.btn_loadTest.addTouchEventListener
	self.batchNodeFightBullet = self.containerView
	self.batchNodeFightBuilds = self.containerView
	self.batchNodeFightBuildWalls = self.containerView
	self.batchNodeFightSoldiers = self.containerView
	self.effectFightNode = self.containerView
	self:createOuterCitySoldiers()
end
function cityBuildFirstFight:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CLOSE_FIRST_FIGHT", handler(self, self.msgCloseFirstFight))
end
function cityBuildFirstFight:initWithData(mainCityView)
	self.batchNodeFightBullet = mainCityView.batchNodeFightBullet
	self.batchNodeFightBuilds = mainCityView.batchNodeFightBuilds
	self.batchNodeFightBuildWalls = mainCityView.batchNodeFightBuildWalls
	self.batchNodeFightSoldiers = mainCityView.batchNodeFightSoldiers
	self.effectFightNode = mainCityView.effectFightNode
	self.mainCityView = mainCityView
	self.containerView = mainCityView.containerView
	self:loadFromFightData()
	self:loadLockArea()
	self:moveCameraToEnemyChief()
end
function cityBuildFirstFight:btnClose(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:close(nil, ccui.TouchEventType.ended)
	end
end
function cityBuildFirstFight:btnExport(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("TODO:导出数据")
		self:exportData()
	end
end
function cityBuildFirstFight:btnPlay(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:playAnimation()
	end
end
function cityBuildFirstFight:btnLoad(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:loadSoldierData()
	end
end
function cityBuildFirstFight:btnGenerate(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:generateSoldiers()
	end
end
function cityBuildFirstFight:btnLoadEffect(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:addEffect()
	end
end
function cityBuildFirstFight:btnPass(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:doEnd(true)
	end
end
function cityBuildFirstFight:btnReplay(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:playAnimation()
	end
end
function cityBuildFirstFight:btnEnd(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		self:showMaskPanel()
	end
end
function cityBuildFirstFight:createTestSoldiers()
end
function cityBuildFirstFight:btnLoadTest(target, eventType)
end
function cityBuildFirstFight:showScountAnimation()
	for i, v in ipairs(self.tblDynamicSoldiers) do
		if v.node and v.soldierType == cityBuildConstDef.soldierType_Scout then
			v.node:setPosition(cc.p(v.posx + offset.x, v.posy + offset.y))
			v.node:stopAllActions()
			self:runActionForSoldier(v)
		end
	end
end
function cityBuildFirstFight:showLordAnimation()
	local delay = cca.delay(0)
	local callFunc = cca.callFunc(function()
		for i, v in ipairs(self.tblDynamicSoldiers) do
			if v.node and v.soldierType == cityBuildConstDef.soldierType_Lord then
				v.node:setPosition(cc.p(v.posx + offset.x, v.posy + offset.y))
				v.node:stopAllActions()
				self:runActionForSoldier(v)
			end
		end
	end)
	offset = nil
	;(nil)[1] = delay
	;(nil)[2] = callFunc
	self:runAction(cca.seq(nil))
end
function cityBuildFirstFight:playAnimation()
	print("开始执行动画")
	self.btn_pass:setVisible(false)
	math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
	math.random()
	math.random()
	for i, v in ipairs(self.tblStaticSoldiers) do
		if v.node then
			self:runDeadAnimation(v)
		end
	end
	for i, v in ipairs(self.tblDynamicSoldiers) do
		if v.node and v.soldierType ~= cityBuildConstDef.soldierType_Scout and v.soldierType ~= cityBuildConstDef.soldierType_Lord then
			v.node:setPosition(cc.p(v.posx + offset.x, v.posy + offset.y))
			v.node:stopAllActions()
			self:runActionForSoldier(v)
		end
	end
	for i, v in ipairs(self.tblBuilds) do
		if v.node then
			v.node:setPosition(cc.p(v.posx + offset.x, v.posy + offset.y))
			v.node:stopAllActions()
			self:runMoveAnimation(v)
		end
	end
	for i, v in ipairs(self.tblEffects) do
		if v.node then
			v.node:setPosition(cc.p(v.posx + offset.x, v.posy + offset.y))
			v.node:stopAllActions()
		end
		self:runEffectDelayAnimation(v)
		self:runEffectMoveAnimation(v)
	end
	self.soundGuideBegin = SoraDPlaySound("firstWar", 1, 7.0)
end
function cityBuildFirstFight:runEffectDelayAnimation(itemData)
	if itemData.delay and itemData.node then
		local duration = itemData.delay
		local delay = cca.delay(duration)
		local callFunc = cca.callFunc(function()
			itemData.node:setVisible(true)
			local particles = itemData.node:getChildren()
			for i, v in ipairs(particles) do
				if v.resetSystem then
					v:resetSystem()
				end
			end
		end)
		_UPVALUE2_ = nil
		;(nil)[1] = delay
		;(nil)[2] = callFunc
		itemData.node:runAction(cca.seq(nil))
	end
end
function cityBuildFirstFight:runEffectMoveAnimation(itemData)
	if itemData.move then
		local duration = itemData.move
		local delay = cca.delay(duration)
		if itemData.node == nil then
			itemData.node = self:createEffectFireStone()
			itemData.node:setPosition(cc.p(itemData.posx + offset.x, itemData.posy + offset.y))
			itemData.node:addTo(self.effectFightNode)
		end
		local callFunc = cca.callFunc(function()
			itemData.node:setVisible(true)
			local attackOffset = cityBuildConstDef.attackOffset[tostring(cityBuildConstDef.attackOffset_Type5)]
			worldMapFunction.createThrowAction(itemData.node, cc.p(itemData.posx + offset.x, itemData.posy + offset.y), cc.pAdd(cc.p(itemData.posx + offset.x, itemData.posy + offset.y), attackOffset))
			itemData.node = nil
		end)
		cityBuildConstDef = cc.p(itemData.posx + offset.x, itemData.posy + offset.y)
		cc.p(itemData.posx + offset.x, itemData.posy + offset.y)[1] = delay
		cc.p(itemData.posx + offset.x, itemData.posy + offset.y)[2] = callFunc
		itemData.node:runAction(cca.seq(cc.p(itemData.posx + offset.x, itemData.posy + offset.y)))
	end
end
function cityBuildFirstFight:runActionForSoldier(soldierData)
	if soldierData.attack then
		self:runAttackAnimation(soldierData)
	end
	if soldierData.dead then
		self:runDeadAnimation(soldierData)
	end
	if soldierData.move then
		self:runMoveAnimation(soldierData)
	end
end
function cityBuildFirstFight:runAttackAnimation(soldierData)
	if soldierData.attack and soldierData.node then
		local duration = soldierData.attack
		local delta = math.random() - 0.5
		duration = duration + delta
		local delay = cca.delay(duration)
		local callFunc = cca.callFunc(function()
			if not soldierData.node then
				return
			end
			if not self or not self.__cname then
				return
			end
			local imgNameAngle = soldierData.direction
			local soldierType = soldierData.soldierType
			local namePattern = self:getFramesNamePattern(soldierType, cityBuildConstDef.ACTION_ATK, imgNameAngle)
			local frames = display.newFrames(namePattern, 1, 8)
			if frames == nil then
			end
			local animation = display.newAnimation(frames, 0.125)
			if soldierData.soldierType == cityBuildConstDef.soldierType_Lord then
				local lordAttackEnd = function()
					self:playAnimation()
				end
				soldierData.node:playAnimationOnce(animation, false, lordAttackEnd)
			else
				soldierData.node:playAnimationForever(animation)
			end
			local isFlipX = false
			if soldierData.scaleX == -1 then
				isFlipX = true
			end
			soldierData.node:setFlippedX(isFlipX)
		end)
		if soldierData.soldierType == cityBuildConstDef.soldierType_Lord then
			if not soldierData.node then
				return
			end
			if not self or not self.__cname then
				return
			end
			offset = nil
			;(nil)[1] = delay
			;(nil)[2] = callFunc
			soldierData.node:runAction(cca.seq(nil))
			local delay2 = cca.delay(5.0)
			local callFunc2 = cca.callFunc(function()
				local btnChengmen = self.mainCityView:getBuildBtnByIndex(1053)
				local x, y = btnChengmen:getPosition()
				local targetPos = cc.p(x + 200, y - 300)
				self = y - 300
				;(y - 300).msg = "MESSAGE_MAINCITYVIEW_MOVE_CAMERA_TO"
				;(y - 300).delay = 4.5
				;(y - 300).targetPos = targetPos
				;(y - 300).zoomScale = 0.5
				SoraDSendMessage(y - 300)
			end)
			offset = cca.seq(nil)
			cca.seq(nil)[1] = delay2
			cca.seq(nil)[2] = callFunc2
			self:runAction(cca.seq(cca.seq(nil)))
			local delay3 = cca.delay(12.0)
			local callFunc3 = cca.callFunc(function()
				self:showMaskPanel()
			end)
			offset = cca.seq(cca.seq(nil))
			cca.seq(cca.seq(nil))[1] = delay3
			cca.seq(cca.seq(nil))[2] = callFunc3
			self:runAction(cca.seq(cca.seq(cca.seq(nil))))
			return
		end
		local randomDead = math.random(0, 30)
		if randomDead <= 15 and soldierData.subType == cityBuildConstDef.soldierType_SubType2 and soldierData.dead == nil then
			local deadTime = math.random(2, 7)
			local delayDead = cca.delay(deadTime)
			local callFuncDead = cca.callFunc(function()
				if not soldierData.node then
					return
				end
				if not self or not self.__cname then
					return
				end
				soldierData.node:stopAllActions()
				_UPVALUE4_ = soldierData.node.stopAllActions
				soldierData.node.stopAllActions[1] = "ws"
				soldierData.node.stopAllActions[2] = "w"
				soldierData.node.stopAllActions[3] = "wn"
				local soldierData.node.stopAllActions[4], imgNameAngleArray = "s", soldierData.node.stopAllActions
				local randomAngle = math.random(1, 4)
				local imgNameAngle = imgNameAngleArray[randomAngle]
				local soldierType = soldierData.soldierType
				local namePattern = self:getFramesNamePattern(soldierType, cityBuildConstDef.ACTION_DEAD, imgNameAngle)
				local frames = display.newFrames(namePattern, 1, 8)
				local animation = display.newAnimation(frames, 0.15)
				soldierData.node:playAnimationOnce(animation)
				soldierData.node:getParent():reorderChild(soldierData.node, -100)
				local isFlipX = false
				local isNeedFlip = math.random(0, 1)
				if isNeedFlip == 1 then
					isFlipX = true
				end
				soldierData.node:setFlippedX(isFlipX)
			end)
			offset = cca.seq(cca.seq(cca.seq(nil)))
			cca.seq(cca.seq(cca.seq(nil)))[1] = delayDead
			cca.seq(cca.seq(cca.seq(nil)))[2] = callFuncDead
			soldierData.node:runAction(cca.seq(cca.seq(cca.seq(cca.seq(nil)))))
		end
		local callFunc3 = cca.callFunc(function()
			if not soldierData.node then
				return
			end
			if not self or not self.__cname then
				return
			end
			local delay2 = cca.delay(1)
			local callFunc2 = cca.callFunc(function()
				local spriteName = "#icon_battle_jian_0.png"
				if soldierData.soldierType == 4 then
					spriteName = "#icon_battle_stone.png"
				end
				local bulletSprite = display.newSprite(spriteName)
				bulletSprite:setPosition(cc.p(soldierData.posx + offset.x, soldierData.posy + offset.y))
				bulletSprite:setScale(0.5)
				if self.batchNodeFightBullet then
					bulletSprite:addTo(self.batchNodeFightBullet, 50)
				end
				local deltax = math.random(-10, 10)
				local deltay = math.random(-10, 10)
				local attackOffset = cc.p(soldierData.attackOffset.x + delta, soldierData.attackOffset.y + deltay)
				worldMapFunction.createThrowAction(bulletSprite, cc.p(soldierData.posx + offset.x, soldierData.posy + offset.y), cc.pAdd(cc.p(soldierData.posx + offset.x, soldierData.posy + offset.y), attackOffset), 0, 300)
			end)
			_ENV = nil
			;(nil)[1] = delay2
			;(nil)[2] = callFunc2
			local seq2 = cca.seq(nil)
			local repeatSeq = cca.repeatForever(seq2)
			soldierData.node:runAction(repeatSeq)
		end)
		worldMapFunction = soldierData.node
		soldierData.node[1] = delay
		soldierData.node[2] = callFunc
		soldierData.node[3] = callFunc3
		soldierData.node:runAction(cca.seq(soldierData.node))
	end
end
function cityBuildFirstFight:runDeadAnimation(soldierData)
	if soldierData.dead then
		local duration = soldierData.dead
		local delta = math.random() - 0.5
		duration = duration + delta
		local delay = cca.delay(duration)
		local callFunc = cca.callFunc(function()
			if not soldierData.node then
				return
			end
			if not self or not self.__cname then
				return
			end
			soldierData.node:stopAllActions()
			local imgNameAngle = soldierData.direction
			_UPVALUE4_ = soldierData.node
			soldierData.node[1] = "ws"
			soldierData.node[2] = "w"
			soldierData.node[3] = "wn"
			local soldierData.node[4], imgNameAngleArray = "s", soldierData.node
			local randomAngle = math.random(1, 4)
			imgNameAngle = imgNameAngleArray[randomAngle]
			local soldierType = soldierData.soldierType
			if not self or not self.getFramesNamePattern then
				return
			end
			local namePattern = self:getFramesNamePattern(soldierType, cityBuildConstDef.ACTION_DEAD, imgNameAngle)
			local frames = display.newFrames(namePattern, 1, 8)
			local animation = display.newAnimation(frames, 0.125)
			soldierData.node:playAnimationOnce(animation)
			soldierData.node:getParent():reorderChild(soldierData.node, -100)
			local isFlipX = false
			if soldierData.scaleX == -1 then
				isFlipX = true
			end
			local isNeedFlip = math.random(0, 1)
			if isNeedFlip == 1 then
				isFlipX = true
			end
			soldierData.node:setFlippedX(isFlipX)
		end)
		_UPVALUE2_ = nil
		;(nil)[1] = delay
		;(nil)[2] = callFunc
		soldierData.node:runAction(cca.seq(nil))
	elseif soldierData.stateType == "s" and soldierData.soldierType == cityBuildConstDef.soldierType_QiBing and soldierData.subType == cityBuildConstDef.soldierType_SubType2 then
		local randomDead = math.random(0, 30)
		if randomDead <= 13 then
			local duration = math.random(5, 8)
			local delta = math.random() - 0.5
			duration = duration + delta
			local delay = cca.delay(duration)
			local callFunc = cca.callFunc(function()
				if not soldierData.node then
					return
				end
				if not self or not self.__cname then
					return
				end
				soldierData.node:stopAllActions()
				local imgNameAngle = soldierData.direction
				if soldierData.stateType == "s" then
					_UPVALUE4_ = soldierData.stateType
					soldierData.stateType[1] = "ws"
					soldierData.stateType[2] = "w"
					soldierData.stateType[3] = "wn"
					local soldierData.stateType[4], imgNameAngleArray = "s", soldierData.stateType
					local randomAngle = math.random(1, 4)
					imgNameAngle = imgNameAngleArray[randomAngle]
				end
				local soldierType = soldierData.soldierType
				local namePattern = self:getFramesNamePattern(soldierType, cityBuildConstDef.ACTION_DEAD, imgNameAngle)
				local frames = display.newFrames(namePattern, 1, 8)
				local animation = display.newAnimation(frames, 0.125)
				soldierData.node:playAnimationOnce(animation)
				soldierData.node:getParent():reorderChild(soldierData.node, -100)
				local isFlipX = false
				if soldierData.scaleX == -1 then
					isFlipX = true
				end
				local isNeedFlip = math.random(0, 1)
				if isNeedFlip == 1 then
					isFlipX = true
				end
				soldierData.node:setFlippedX(isFlipX)
			end)
			_UPVALUE2_ = cca.seq(nil)
			cca.seq(nil)[1] = delay
			cca.seq(nil)[2] = callFunc
			soldierData.node:runAction(cca.seq(cca.seq(nil)))
		end
	end
end
function cityBuildFirstFight:runMoveAnimation(soldierData)
	if soldierData.move and soldierData.stateType == cityBuildConstDef.stateType_Build then
		if soldierData.imageType == "m" then
			local duration = soldierData.move
			local delay = cca.delay(duration)
			local callFunc = cca.callFunc(function()
				if not soldierData.node then
					return
				end
				if not self or not self.__cname then
					return
				end
				local namePattern = "et_kaichang_cq_0%d.png"
				local frames = display.newFrames(namePattern, 1, 4)
				local animation = display.newAnimation(frames, 0.2)
				soldierData.node:playAnimationOnce(animation)
			end)
			offset = nil
			;(nil)[1] = delay
			;(nil)[2] = callFunc
			soldierData.node:runAction(cca.seq(nil))
		end
		return
	end
	if soldierData.move and soldierData.stateType == cityBuildConstDef.stateType_Dynamic then
		local duration = soldierData.move
		local delay = cca.delay(duration)
		local callFunc = cca.callFunc(function()
			if not soldierData.node then
				return
			end
			if not self or not self.__cname then
				return
			end
			local imgNameAngle = soldierData.direction
			local soldierType = soldierData.soldierType
			local namePattern = self:getFramesNamePattern(soldierType, cityBuildConstDef.MOVE, imgNameAngle)
			local frames = display.newFrames(namePattern, 1, 8)
			local animation = display.newAnimation(frames, 0.125)
			soldierData.node:playAnimationForever(animation)
			local isFlipX = false
			if soldierData.scaleX == -1 then
				isFlipX = true
			end
			soldierData.node:setFlippedX(isFlipX)
		end)
		local moveType = soldierData.moveType
		if soldierData.soldierType == cityBuildConstDef.soldierType_Scout and moveType == cityBuildConstDef.moveType3 then
			local beginPoint = cc.p(soldierData.posx + offset.x, soldierData.posy + offset.y)
			local endPoint = cityBuildConstDef.movePoints[tostring(moveType)][1]
			endPoint = cc.p(endPoint.x + offset.x, endPoint.y + offset.y)
			local distance = cc.pGetDistance(beginPoint, endPoint)
			local dt = distance / soldierData.moveSpeed
			local actMove = cca.moveTo(dt, endPoint.x, endPoint.y)
			local funcShaobingEnd = function()
				if not soldierData.node then
					return
				end
				if not self or not self.__cname then
					return
				end
				soldierData.node:stopAllActions()
				local spriteFrame = display.newSpriteFrame("zhencha_yd_ws_06.png")
				soldierData.node:setSpriteFrame(spriteFrame)
				local soldierData, arrAct = soldierData.node.setSpriteFrame, soldierData.node.setSpriteFrame
				for i = 1, 4 do
					arrAct[#arrAct + 1] = cca.delay(2)
					arrAct[#arrAct + 1] = cca.callFunc(function()
						_ENV = nil
						;(nil).msg = "MESSAGE_SERVER_GUIDE_STEP_ON"
						;(nil).step = 1003 + i
						SoraDSendMessage(nil)
					end)
				end
				arrAct[#arrAct + 1] = cca.callFunc(function()
					self:showLordAnimation()
				end)
				self:runAction(transition.sequence(arrAct))
			end
			local actFunc = cca.callFunc(funcShaobingEnd)
			_UPVALUE4_ = cca.seq(nil)
			cca.seq(nil)[1] = delay
			cca.seq(nil)[2] = callFunc
			cca.seq(nil)[3] = actMove
			cca.seq(nil)[4] = actFunc
			local actSeq = cca.seq(cca.seq(nil))
			soldierData.node:runAction(actSeq)
			return
		end
		local cityBuildConstDef, routePoints = beginPoint, cc.p(soldierData.posx + offset.x, soldierData.posy + offset.y)
		local beginPoint = cc.p(soldierData.posx + offset.x, soldierData.posy + offset.y)
		table.insert(routePoints, #routePoints + 1, beginPoint)
		local movePoints = cityBuildConstDef.movePoints[tostring(moveType)]
		for i = 1, #movePoints do
			local x = movePoints[i].x + math.random(cityBuildConstDef.movePointAmplitudeXL, cityBuildConstDef.movePointAmplitudeXR)
			local y = movePoints[i].y + math.random(cityBuildConstDef.movePointAmplitudeYL, cityBuildConstDef.movePointAmplitudeYR)
			table.insert(routePoints, #routePoints + 1, cc.p(x + offset.x, y + offset.y))
		end
		local endPoint = routePoints[#routePoints]
		local appendPoint = cc.pAdd(endPoint, cityBuildConstDef.vecTarget)
		table.insert(routePoints, #routePoints, appendPoint)
		dump(routePoints, "routePoints")
		local currentStepIndex = 1
		local function routeStep()
			if currentStepIndex < #routePoints then
				local beginPoint = routePoints[currentStepIndex]
				local endPoint = routePoints[currentStepIndex + 1]
				local worldMapFunction = include("worldMapFunction")
				local worldMapDefine = include("worldMapDefine")
				local rotation, imgNameAngle, isFlipX, moveAngle = worldMapFunction.getSoliderImgAngel(beginPoint, endPoint)
				soldierData.node:stopAllActions()
				local frames = display.newFrames(worldMapDefine.getSoliderImageNameByType(soldierData.soldierType) .. "_yd_" .. imgNameAngle .. "_0%d.png", 1, 8)
				local animation = display.newAnimation(frames, 0.125)
				soldierData.node:playAnimationForever(animation)
				soldierData.node:setFlippedX(isFlipX)
				local distance = cc.pGetDistance(beginPoint, endPoint)
				local dt = distance / soldierData.moveSpeed
				soldierData.node:setPosition(beginPoint.x, beginPoint.y)
				local actMove = cca.moveTo(dt, endPoint.x, endPoint.y)
				local actFunc = cca.callFunc(routeStep)
				_ENV = endPoint.y
				endPoint.y[1] = actMove
				endPoint.y[2] = actFunc
				local actSeq = cca.seq(endPoint.y)
				soldierData.node:runAction(actSeq)
				local randomDead = math.random(0, 30)
				if randomDead <= 13 then
					local deadTime = math.random(1, 3)
					local delayDead = cca.delay(deadTime)
					local callFuncDead = cca.callFunc(function()
						if not soldierData.node then
							return
						end
						if not self or not self.__cname then
							return
						end
						soldierData.node:stopAllActions()
						_UPVALUE4_ = soldierData.node.stopAllActions
						soldierData.node.stopAllActions[1] = "ws"
						soldierData.node.stopAllActions[2] = "w"
						soldierData.node.stopAllActions[3] = "wn"
						local soldierData.node.stopAllActions[4], imgNameAngleArray = "s", soldierData.node.stopAllActions
						local randomAngle = math.random(1, 4)
						local imgNameAngle = imgNameAngleArray[randomAngle]
						local soldierType = soldierData.soldierType
						local namePattern = self:getFramesNamePattern(soldierType, cityBuildConstDef.ACTION_DEAD, imgNameAngle)
						local frames = display.newFrames(namePattern, 1, 8)
						local animation = display.newAnimation(frames, 0.15)
						soldierData.node:playAnimationOnce(animation)
						soldierData.node:getParent():reorderChild(soldierData.node, -100)
						local isFlipX = false
						local isNeedFlip = math.random(0, 1)
						if isNeedFlip == 1 then
							isFlipX = true
						end
						soldierData.node:setFlippedX(isFlipX)
					end)
					_ENV = nil
					;(nil)[1] = delayDead
					;(nil)[2] = callFuncDead
					soldierData.node:runAction(cca.seq(nil))
				end
			else
			end
		end
		local callFuncRouteStep = cca.callFunc(routeStep)
		_UPVALUE3_ = #routePoints + 1
		;(#routePoints + 1)[1] = delay
		;(#routePoints + 1)[2] = callFunc
		;(#routePoints + 1)[3] = callFuncRouteStep
		soldierData.node:runAction(cca.seq(#routePoints + 1))
	end
end
function cityBuildFirstFight:parseItemData(node, nodeName)
	local _ENV, itemData
	if nodeName == nil or nodeName == "" then
		nodeName = node:getName()
	end
	local prefix = string.sub(nodeName, 1, 2)
	if prefix == "s_" then
		itemData = self:parseStaticSoldierData(node, nodeName)
	elseif prefix == "d_" then
		itemData = self:parseDynamicSoldierData(node, nodeName)
	elseif prefix == "b_" then
		itemData = self:parseBuildData(node, nodeName)
	else
		if prefix == "e_" then
			itemData = self:parseEffectData(node, nodeName)
		else
		end
	end
	return itemData
end
function cityBuildFirstFight:parseEffectData(node, nodeName)
	local _ENV, ret
	local splitRes = string.split(nodeName, "_")
	ret.name = nodeName
	ret.node = node
	ret.stateType = splitRes[1]
	ret.eType = tonumber(splitRes[2])
	ret.isShow = splitRes[3]
	if ret.isShow == 0 then
		ret.node:setVisible(false)
	else
		ret.node:setVisible(true)
	end
	ret.posx = node:getPositionX()
	ret.posy = node:getPositionY()
	for i = 4, 6 do
		local actRes = string.split(splitRes[i], "+")
		local flagType = actRes[1]
		local flagValue = tonumber(actRes[2])
		if flagType == "d" then
			ret.delay = tonumber(flagValue)
		elseif flagType == "mt" then
			ret.moveType = flagValue
		elseif flagType == "m" then
			ret.move = flagValue
		elseif flagType == "ms" then
			ret.moveSpeed = flagValue
		end
	end
	return ret
end
function cityBuildFirstFight:parseBuildData(node, nodeName)
	local _ENV, ret
	local splitRes = string.split(nodeName, "_")
	ret.name = nodeName
	ret.node = node
	ret.stateType = splitRes[1]
	ret.imageType = splitRes[2]
	ret.posx = node:getPositionX()
	ret.posy = node:getPositionY()
	ret.zOrder = tonumber(splitRes[3])
	ret.buildId = tonumber(splitRes[4])
	ret.viewModel = tonumber(splitRes[5])
	for i = 6, 10 do
		if splitRes[i] then
			local actRes = string.split(splitRes[i], "+")
			local flagType = actRes[1]
			local flagValue = tonumber(actRes[2])
			if flagType == "a" then
				ret.attack = flagValue
			elseif flagType == "d" then
				ret.dead = flagValue
			elseif flagType == "m" then
				print("捕捉到城门动画")
				ret.move = flagValue
			elseif flagType == "at" then
				ret.attackOffset = cityBuildConstDef.attackOffset[tostring(flagValue)]
			elseif flagType == "mt" then
				ret.moveType = flagValue
			elseif flagType == "ms" then
				ret.moveSpeed = flagValue
			end
		else
			break
		end
	end
	ret.image = self:getBuildImageName(ret.stateType, ret.imageType, ret.buildId, ret.viewModel)
	return ret
end
function cityBuildFirstFight:parseStaticSoldierData(node, nodeName)
	local _ENV, ret
	local splitRes = string.split(nodeName, "_")
	ret.name = nodeName
	ret.node = node
	ret.stateType = splitRes[1]
	ret.soldierType = tonumber(splitRes[2])
	ret.subType = tonumber(splitRes[3])
	ret.actType = tonumber(splitRes[4])
	ret.direction = splitRes[5]
	ret.posx = node:getPositionX()
	ret.posy = node:getPositionY()
	if splitRes[6] then
		ret.scaleX = tonumber(splitRes[6])
	else
		ret.scaleX = 1.0
	end
	if splitRes[7] then
		ret.scaleY = tonumber(splitRes[7])
		if ret.node then
			ret.node:setScale(ret.scaleY)
		end
	else
		ret.scaleY = 1.0
	end
	if splitRes[8] then
		ret.zOrder = tonumber(splitRes[8])
	else
		ret.zOrder = 50
	end
	for i = 9, 13 do
		if splitRes[i] then
			local actRes = string.split(splitRes[i], "+")
			local flagType = actRes[1]
			local flagValue = tonumber(actRes[2])
			if flagType == "a" then
				ret.attack = flagValue
			elseif flagType == "d" then
				ret.dead = flagValue
			elseif flagType == "m" then
				ret.move = flagValue
			elseif flagType == "at" then
				ret.attackOffset = cityBuildConstDef.attackOffset[tostring(flagValue)]
			elseif flagType == "mt" then
				ret.moveType = flagValue
			elseif flagType == "ms" then
				ret.moveSpeed = flagValue
			end
		else
			break
		end
	end
	if ret.move ~= nil then
		if ret.moveType == nil then
			ret.moveType = 1
		end
		if ret.moveSpeed == nil then
			ret.moveSpeed = cityBuildConstDef.moveSpeed
		end
	end
	ret.image = self:getSoldierImageName(ret.stateType, ret.soldierType, ret.actType, ret.direction, ret.subType)
	if ret.image == "" then
		print(ret.name, "Error here !!!")
	end
	return ret
end
function cityBuildFirstFight:parseDynamicSoldierData(node, nodeName)
	return self:parseStaticSoldierData(node, nodeName)
end
function cityBuildFirstFight:loadSoldierData()
	self.tblDynamicSoldiers, _ENV, self.tblStaticSoldiers, _ENV = nil, nil, nil, nil
	print("getChildrenCount: ", self.containerView:getChildrenCount())
	local allChildren = self.containerView:getChildren()
	for i, v in ipairs(allChildren) do
		print("node:", v:getName())
	end
	local containerView = self.containerView
	local minTag = 100
	local maxTag = 1000
	for i, v in ipairs(allChildren) do
		local node = v
		if node then
			local nodeName = node:getName()
			local prefix = string.sub(nodeName, 1, 2)
			local itemData = self:parseItemData(node, nodeName)
			if itemData.stateType == cityBuildConstDef.stateType_Static then
				table.insert(self.tblStaticSoldiers, #self.tblStaticSoldiers + 1, itemData)
			elseif itemData.stateType == cityBuildConstDef.stateType_Dynamic then
				table.insert(self.tblDynamicSoldiers, #self.tblDynamicSoldiers + 1, itemData)
			elseif itemData.stateType == cityBuildConstDef.stateType_Build then
				table.insert(self.tblBuilds, #self.tblBuilds + 1, itemData)
			else
				if itemData.stateType == cityBuildConstDef.stateType_Effect then
					table.insert(self.tblEffects, #self.tblEffects + 1, itemData)
				else
				end
			end
		end
	end
	print("加载完毕~~~~")
end
function cityBuildFirstFight:loadFromFightData()
	local fightDesRead = include("fightDesRead")
	local fightData = fightDesRead.fightData
	self.tblEffects, _ENV, self.tblDynamicSoldiers, _ENV, self.tblStaticSoldiers, _ENV, self.tblBuilds, _ENV = nil, nil, nil, nil, nil, nil, nil, nil
	for i, v in ipairs(fightData) do
		if v.stateType == "b" then
			table.insert(self.tblBuilds, #self.tblBuilds + 1, v)
			v.node = display.newSprite("#" .. v.image)
			if v.imageType == "c" then
				self.batchNodeFightBuilds:addChild(v.node)
			elseif v.imageType == "q" or v.imageType == "r" or v.imageType == "m" then
				self.batchNodeFightBuildWalls:addChild(v.node)
			end
			v.node:setPosition(cc.p(v.posx + offset.x, v.posy + offset.y))
			if v.scaleX == -1.0 then
				v.node:setFlippedX(true)
			end
			if v.scaleY then
				v.node:setScale(v.scaleY)
			end
			if v.zOrder then
				v.node:setLocalZOrder(v.zOrder)
			else
				v.node:setLocalZOrder(1)
			end
		elseif v.stateType == "s" then
			table.insert(self.tblStaticSoldiers, #self.tblStaticSoldiers + 1, v)
			v.node = display.newSprite("#" .. v.image)
			self.batchNodeFightSoldiers:addChild(v.node, v.zOrder)
			v.node:setPosition(cc.p(v.posx + offset.x, v.posy + offset.y))
			if v.scaleX == -1.0 then
				v.node:setFlippedX(true)
			end
			if v.scaleY then
				v.node:setScale(v.scaleY)
			end
			if v.zOrder then
				v.node:setLocalZOrder(v.zOrder)
			else
				v.node:setLocalZOrder(1)
			end
		elseif v.stateType == "d" then
			table.insert(self.tblDynamicSoldiers, #self.tblDynamicSoldiers + 1, v)
			v.node = display.newSprite("#" .. v.image)
			self.batchNodeFightSoldiers:addChild(v.node)
			v.node:setPosition(cc.p(v.posx + offset.x, v.posy + offset.y))
			if v.scaleX == -1.0 then
				v.node:setFlippedX(true)
			end
			if v.scaleY then
				v.node:setScale(v.scaleY)
			end
			if v.zOrder then
				v.node:setLocalZOrder(v.zOrder)
			else
				v.node:setLocalZOrder(1)
			end
		elseif v.stateType == "e" then
			table.insert(self.tblEffects, #self.tblEffects + 1, v)
			if v.eType == cityBuildConstDef.effect_Type1 then
				v.node = self:createEffectFireAndFrog()
			elseif v.eType == cityBuildConstDef.effect_Type2 then
				v.node = self:createEffectExplosion()
			elseif v.eType == cityBuildConstDef.effect_Type3 then
				v.node = self:createEffectFireStone()
			end
			if v.scaleY then
				v.node:setScale(v.scaleY)
			end
			self.effectFightNode:addChild(v.node)
			v.node:setPosition(cc.p(v.posx + offset.x, v.posy + offset.y))
			if v.isShow == 0 then
				v.node:setVisible(false)
			end
			if v.scaleX == -1.0 then
				v.node:setFlippedX(true)
			end
			if v.zOrder then
				v.node:setLocalZOrder(v.zOrder)
			else
				v.node:setLocalZOrder(1)
			end
		end
	end
end
function cityBuildFirstFight:addEffect()
	local nodeExplosion = self:createEffectExplosion()
	local nodeFireAndFrog = self:createEffectFireAndFrog()
	self.containerView:addChild(nodeExplosion, 60)
	nodeExplosion:setPosition(cc.p(300, 500))
	self.containerView:addChild(nodeFireAndFrog, 60)
	nodeFireAndFrog:setPosition(cc.p(400, 500))
end
function cityBuildFirstFight:createEffectFrog()
	local particleFile = "Particle/et_kaichang_yan.plist"
	local particle_1 = cc.ParticleSystemQuad:create(particleFile)
	particle_1:setPositionType(cc.POSITION_TYPE_RELATIVE)
	return particle_1
end
function cityBuildFirstFight:createEffectFire()
	local particleFile = "Particle/et_kaichang_huo.plist"
	local particle_1 = cc.ParticleSystemQuad:create(particleFile)
	particle_1:setPositionType(cc.POSITION_TYPE_RELATIVE)
	return particle_1
end
function cityBuildFirstFight:createEffectFireAndFrog()
	local node = display.newNode()
	local particleFire = self:createEffectFire()
	local particleFrog = self:createEffectFrog()
	node:addChild(particleFrog, 1)
	node:addChild(particleFire, 2)
	particleFire:setPosition(cc.p(0, 0))
	particleFrog:setPosition(cc.p(0, 0))
	return node
end
function cityBuildFirstFight:createEffectExplosion()
	local node = display.newNode()
	local particleFile = "Particle/et_kaichang_explosion_01.plist"
	local particle_1 = cc.ParticleSystemQuad:create(particleFile)
	particle_1:setPositionType(cc.POSITION_TYPE_RELATIVE)
	particle_1:setAutoRemoveOnFinish(false)
	particle_1:setPosition(cc.p(0, 0))
	node:addChild(particle_1, 1)
	local particleFile2 = "Particle/et_kaichang_explosion_02.plist"
	local particle_2 = cc.ParticleSystemQuad:create(particleFile2)
	particle_2:setPositionType(cc.POSITION_TYPE_RELATIVE)
	particle_2:setAutoRemoveOnFinish(false)
	particle_2:setPosition(cc.p(0, 0))
	node:addChild(particle_2, 2)
	return node
end
function cityBuildFirstFight:createEffectFireStone()
	local node = display.newNode()
	local particleFile = "Particle/et_paoshidan_display_01.plist"
	local particle_1 = cc.ParticleSystemQuad:create(particleFile)
	particle_1:setPositionType(cc.POSITION_TYPE_RELATIVE)
	particle_1:setAutoRemoveOnFinish(false)
	particle_1:setScaleX(0.45)
	particle_1:setScaleY(0.49)
	particle_1:setPosition(cc.p(0, 0))
	particle_1:setRotation(90)
	node:addChild(particle_1, 1)
	local particleFile2 = "Particle/et_paoshidan_display_02.plist"
	local particle_2 = cc.ParticleSystemQuad:create(particleFile2)
	particle_2:setPositionType(cc.POSITION_TYPE_RELATIVE)
	particle_2:setAutoRemoveOnFinish(false)
	particle_2:setScaleX(0.34)
	particle_2:setScaleY(0.4)
	particle_2:setRotation(178.4)
	particle_2:setPosition(cc.p(0, 0))
	node:addChild(particle_2, 2)
	local particleFile3 = "Particle/et_paoshidan_display_03.plist"
	local particle_3 = cc.ParticleSystemQuad:create(particleFile3)
	particle_3:setPositionType(cc.POSITION_TYPE_RELATIVE)
	particle_3:setAutoRemoveOnFinish(false)
	particle_3:setScaleX(0.71)
	particle_3:setScaleY(0.71)
	particle_3:setRotation(90)
	particle_3:setPosition(cc.p(-2, -5))
	node:addChild(particle_3, 3)
	local particleFile4 = "Particle/et_paoshidan_display_04.plist"
	local particle_4 = cc.ParticleSystemQuad:create(particleFile4)
	particle_4:setPositionType(cc.POSITION_TYPE_RELATIVE)
	particle_4:setAutoRemoveOnFinish(false)
	particle_4:setScaleX(1.4)
	particle_4:setScaleY(1.54)
	particle_4:setRotation(90)
	particle_4:setPosition(cc.p(47, -2))
	node:addChild(particle_4, 4)
	local particleFile5 = "Particle/et_paoshidan_display_05.plist"
	local particle_5 = cc.ParticleSystemQuad:create(particleFile5)
	particle_5:setPositionType(cc.POSITION_TYPE_RELATIVE)
	particle_5:setAutoRemoveOnFinish(false)
	particle_5:setScaleX(0.96)
	particle_5:setScaleY(1.0)
	particle_5:setRotation(90)
	particle_5:setPosition(cc.p(100, -2))
	node:addChild(particle_5, 5)
	return node
end
function cityBuildFirstFight:createEffectWarFire()
	local node = display.newNode()
	local particleFile = "Particle/et_gochenghuoyan_display_01.plist"
	local particle_1 = cc.ParticleSystemQuad:create(particleFile)
	particle_1:setPositionType(cc.POSITION_TYPE_RELATIVE)
	particle_1:setAutoRemoveOnFinish(false)
	particle_1:setScaleX(1.0)
	particle_1:setScaleY(1.0)
	particle_1:setPosition(cc.p(0, 0))
	node:addChild(particle_1, 1)
	local particleFile2 = "Particle/et_gochenghuoyan_display_02.plist"
	local particle_2 = cc.ParticleSystemQuad:create(particleFile2)
	particle_2:setPositionType(cc.POSITION_TYPE_RELATIVE)
	particle_2:setAutoRemoveOnFinish(false)
	particle_2:setScaleX(0.96)
	particle_2:setScaleY(1.0)
	particle_2:setPosition(cc.p(-148, -115))
	node:addChild(particle_2, 2)
	local particleFile3 = "Particle/et_gochenghuoyan_display_03.plist"
	local particle_3 = cc.ParticleSystemQuad:create(particleFile3)
	particle_3:setPositionType(cc.POSITION_TYPE_RELATIVE)
	particle_3:setAutoRemoveOnFinish(false)
	particle_3:setScaleX(1.4)
	particle_3:setScaleY(1.54)
	particle_3:setPosition(cc.p(-231, -66))
	node:addChild(particle_3, 3)
	local particleFile4 = "Particle/et_gochenghuoyan_display_04.plist"
	local particle_4 = cc.ParticleSystemQuad:create(particleFile4)
	particle_4:setPositionType(cc.POSITION_TYPE_RELATIVE)
	particle_4:setAutoRemoveOnFinish(false)
	particle_4:setScaleX(1.4)
	particle_4:setScaleY(1.54)
	particle_4:setPosition(cc.p(175, -80))
	node:addChild(particle_4, 4)
	local particleFile5 = "Particle/et_gochenghuoyan_display_05.plist"
	local particle_5 = cc.ParticleSystemQuad:create(particleFile5)
	particle_5:setPositionType(cc.POSITION_TYPE_RELATIVE)
	particle_5:setAutoRemoveOnFinish(false)
	particle_5:setScaleX(0.96)
	particle_5:setScaleY(1.0)
	particle_5:setPosition(cc.p(90, -119))
	node:addChild(particle_5, 5)
	return node
end
function cityBuildFirstFight:exportData()
	local file = io.open("/Volumes/lth_T5/firstFightData.lua", "w+")
	file:write("local firstFightData = {\n")
	local index = 1
	_UPVALUE4_ = "local firstFightData = {\n"
	;("local firstFightData = {\n")[1] = self.tblBuilds
	;("local firstFightData = {\n")[2] = self.tblEffects
	;("local firstFightData = {\n")[3] = self.tblStaticSoldiers
	;("local firstFightData = {\n")[4] = self.tblDynamicSoldiers
	for m, t in ipairs("local firstFightData = {\n") do
		for i = 1, #t do
			local line = ""
			line = line .. "[" .. index .. "]" .. "={"
			index = index + 1
			for k, v in pairs(t[i]) do
				if k == "node" then
				elseif k == "name" or k == "direction" or k == "stateType" then
					line = line .. string.format("%s=\"%s\",", k, v)
				elseif k == "attackOffset" then
					line = line .. string.format("%s=cc.p(%d,%d),", k, v.x, v.y)
				elseif k == "scaleX" or k == "scaleY" or k == "attack" or k == "dead" or k == "move" or k == "posx" or k == "posy" then
					line = line .. string.format("%s=%.2f,", k, tonumber(v))
				elseif k == "moveSpeed" or k == "moveType" or k == "soldierType" or k == "subType" or k == "viewModel" or k == "buildId" or k == "actType" or k == "zOrder" or k == "eType" or k == "isShow" then
					line = line .. string.format("%s=%d,", k, tonumber(v))
				else
					line = line .. string.format("%s=\"%s\",", k, tostring(v))
				end
			end
			line = line .. "},\n"
			file:write(line)
		end
		file:write("\n")
	end
	file:write([[
}
 return firstFightData]])
	file:flush()
	file:close()
	print("输出完毕")
end
function cityBuildFirstFight:getFramesNamePattern(soldierType, actType, imgNameAngle)
	local namePattern = "TODO"
	if soldierType == cityBuildConstDef.soldierType_Scout and actType == cityBuildConstDef.MOVE then
		namePattern = "zhencha_yd_" .. imgNameAngle .. "_0%d.png"
		return namePattern
	end
	if soldierType == cityBuildConstDef.soldierType_Lord and actType == cityBuildConstDef.ACTION_ATK then
		namePattern = "dajiang_0%d.png"
		return namePattern
	end
	local actName = "_gj_"
	if actType == cityBuildConstDef.MOVE then
		actName = "_yd_"
	end
	if actType == cityBuildConstDef.ACTION_ATK then
		actName = "_gj_"
	end
	if actType == cityBuildConstDef.ACTION_DEAD then
		actName = "_sw_"
	end
	namePattern = worldMapDefine.getSoliderImageNameByType(soldierType) .. actName .. imgNameAngle .. "_0%d.png"
	return namePattern
end
function cityBuildFirstFight:getBuildImageName(stateType, imageType, buildId, viewModel)
	local image = ""
	if stateType ~= "b" then
		return image
	end
	if imageType == "c" then
		image = cityBuildViewDef.getBuildViewCfg(buildId).baseView[1].nodeImg
		if buildId == BUILDID.TURRET then
			image = string.format("jianta_lv%d.png", viewModel)
		end
	elseif imageType == "q" then
		image = string.format("chengqiang_lv%d.png", viewModel)
	elseif imageType == "m" then
		image = "chengmen_lv1.png"
	elseif imageType == "r" then
		image = string.format("jianta_lv%d_base.png", viewModel)
	end
	return image
end
function cityBuildFirstFight:getSoldierImageName(stateType, soldierType, actType, direction, subType)
	local image = ""
	if stateType ~= "s" and stateType ~= "d" then
		return
	end
	if soldierType == cityBuildConstDef.soldierType_Scout then
		image = "zhencha_yd_" .. direction .. "_06.png"
		return image
	end
	if soldierType == cityBuildConstDef.soldierType_Lord then
		image = "dajiang_01.png"
		return image
	end
	local namePattern = self:getFramesNamePattern(soldierType, actType, direction)
	local imageIndex = cityBuildConstDef.soldierTypeSWIndex[tostring(soldierType)][direction]
	if actType == cityBuildConstDef.ACTION_ATK then
		imageIndex = 1
	end
	if subType == cityBuildConstDef.soldierType_SubType3 then
		imageIndex = 5
	end
	if imageIndex == nil then
		print("Error !!1==============!!!!")
		return image
	end
	image = string.format(namePattern, imageIndex)
	return image
end
function cityBuildFirstFight:cleanLockArea()
	local _ENV, unOpenAreaList
	local opengroundinfo = require("app." .. LocalTblPath .. ".config_server.opengroundinfo")
	for i, v in ipairs(opengroundinfo) do
		local isOpened = false
		if isOpened == false then
			table.insert(unOpenAreaList, #unOpenAreaList + 1, v.areaid)
		end
	end
	for i, v in ipairs(unOpenAreaList) do
		local lockNode = self.containerView:getChildByName("first_fight_lock_area_" .. v)
		if lockNode then
			lockNode:removeFromParent()
		end
	end
end
function cityBuildFirstFight:cleanAll()
	self.tblDynamicSoldiers, _ENV, self.tblStaticSoldiers, _ENV, self.tblBuilds, _ENV = nil, nil, nil, nil, nil, nil
	self:cleanLockArea()
	if self.effectWarFire and not tolua.isnull(self.effectWarFire) then
		self.effectWarFire:removeFromParent()
		self.effectWarFire = nil
	end
	if self.soundGuideBegin then
		AudioEngine.stopEffect(self.soundGuideBegin)
	end
	AudioEngine.stopMusic()
	AudioEngine.playMusic(getAudioFileNameByPlatform("mainCity", "BGM"), true)
	_ENV = getAudioFileNameByPlatform("mainCity", "BGM")
	getAudioFileNameByPlatform("mainCity", "BGM").msg = "MESSAGE_MAINCITYVIEW_CLEAN_FIRST_FIGHT"
	SoraDSendMessage((getAudioFileNameByPlatform("mainCity", "BGM")))
	self:stopAllActions()
end
function cityBuildFirstFight:showMaskPanel()
	self.panelMask:setVisible(true)
	local fadeIn = cca.fadeIn(0.6)
	local callFunc = cca.callFunc(function()
		self.text_tip:setVisible(true)
	end)
	local delay2 = cca.delay(1.6)
	local callFunc2 = cca.callFunc(function()
		self:doEnd()
	end)
	_UPVALUE4_ = nil
	;(nil)[1] = fadeIn
	;(nil)[2] = callFunc
	;(nil)[3] = delay2
	;(nil)[4] = callFunc2
	self.panelMask:runAction(cca.seq(nil))
end
function cityBuildFirstFight:doEnd(isPass)
	if isPass then
	end
	self.panelMask:setVisible(true)
	SoraDGetCtrl("guideCtrl"):setSkipFirstFight(true)
	self.top_op:setVisible(false)
	local callFunc1 = cca.callFunc(function()
		self.text_tip:setVisible(true)
		self:cleanAll()
		self.btn_pass:setVisible(false)
		self = self.btn_pass
		self.btn_pass.msg = "MESSAGE_SERVER_GUIDE_STEP_END"
		self.btn_pass.step = 1007
		SoraDSendMessage(self.btn_pass)
		self = self.btn_pass
		self.btn_pass.msg = "MESSAGE_MAINCITYVIEW_FIRST_FIGHT_END"
		SoraDSendMessage(self.btn_pass)
		userSDKManager.onGuideEvent(820100)
	end)
	_UPVALUE1_ = nil
	;(nil)[1] = callFunc1
	self.panelMask:runAction(cca.seq(nil))
end
function cityBuildFirstFight:msgCloseFirstFight(target, data)
	self.text_tip:setVisible(false)
	self:closeSelf()
end
function cityBuildFirstFight:closeSelf()
	local fadeOut = cca.fadeOut(0.6)
	local callFunc2 = cca.callFunc(function()
		self:close(nil, ccui.TouchEventType.ended)
		print("关闭 ：1007")
		self = "关闭 ：1007"
		;("关闭 ：1007").msg = "MESSAGE_SERVER_GUIDE_STEP_END"
		;("关闭 ：1007").step = 1007
		SoraDSendMessage("关闭 ：1007")
	end)
	_UPVALUE2_ = nil
	;(nil)[1] = fadeOut
	;(nil)[2] = callFunc2
	self.panelMask:runAction(cca.seq(nil))
end
local soldierSpeed = 80
local attackDelay = 0.8
local soldierScale = 0.9
local soldierScaleGongbing = 0.9
local soldierScaleQibing = 0.9
_ENV, _UPVALUE20_ = nil, nil
;(nil).beginPos = cc.p(5527.0, 1787)
;(nil).name = "d_1_2_1_wn_1.0_" .. soldierScale .. "_50_m+3.5_mt+1_ms+" .. soldierSpeed
;(nil).number = 3
;(nil).padx = 26
;(nil).pady = 12
;(nil).stateType = "d"
;(nil).soldierType = cityBuildConstDef.soldierType_BuBing
;(nil).subType = cityBuildConstDef.soldierType_SubType2
;(nil).actType = cityBuildConstDef.ACTION_ATK
;(nil).direction = "wn"
;(nil).scaleX = 1.0
;(nil).scaleY = soldierScale
;(nil).zOrder = 50
;(nil).m = 3.5
;(nil).mt = 1
;(nil).ms = 150
_ENV, (nil).image = cityBuildConstDef.ACTION_ATK, "bubing_gj_wn_01.png"
cityBuildConstDef.ACTION_ATK.beginPos = cc.p(5610.0, 1742)
cityBuildConstDef.ACTION_ATK.name = "d_1_2_1_n_-1.0_" .. soldierScale .. "_50_m+3.5_mt+1_ms+" .. soldierSpeed
cityBuildConstDef.ACTION_ATK.number = 6
cityBuildConstDef.ACTION_ATK.padx = 20
cityBuildConstDef.ACTION_ATK.pady = 10
cityBuildConstDef.ACTION_ATK.stateType = "d"
cityBuildConstDef.ACTION_ATK.soldierType = cityBuildConstDef.soldierType_BuBing
cityBuildConstDef.ACTION_ATK.subType = cityBuildConstDef.soldierType_SubType2
cityBuildConstDef.ACTION_ATK.actType = cityBuildConstDef.ACTION_ATK
cityBuildConstDef.ACTION_ATK.direction = "n"
cityBuildConstDef.ACTION_ATK.scaleX = -1.0
cityBuildConstDef.ACTION_ATK.scaleY = soldierScale
cityBuildConstDef.ACTION_ATK.zOrder = 50
_ENV, cityBuildConstDef.ACTION_ATK.image = cityBuildConstDef.ACTION_ATK, "bubing_gj_n_01.png"
cityBuildConstDef.ACTION_ATK.beginPos = cc.p(5616, 1714)
cityBuildConstDef.ACTION_ATK.name = "d_1_2_1_n_-1.0_" .. soldierScale .. "_50_m+3.5_mt+1_ms+" .. soldierSpeed
cityBuildConstDef.ACTION_ATK.number = 6
cityBuildConstDef.ACTION_ATK.padx = 20
cityBuildConstDef.ACTION_ATK.pady = 10
cityBuildConstDef.ACTION_ATK.stateType = "d"
cityBuildConstDef.ACTION_ATK.soldierType = cityBuildConstDef.soldierType_BuBing
cityBuildConstDef.ACTION_ATK.subType = cityBuildConstDef.soldierType_SubType2
cityBuildConstDef.ACTION_ATK.actType = cityBuildConstDef.ACTION_ATK
cityBuildConstDef.ACTION_ATK.direction = "n"
cityBuildConstDef.ACTION_ATK.scaleX = -1.0
cityBuildConstDef.ACTION_ATK.scaleY = soldierScale
cityBuildConstDef.ACTION_ATK.zOrder = 50
_ENV, cityBuildConstDef.ACTION_ATK.image = cityBuildConstDef.ACTION_ATK, "bubing_gj_n_01.png"
cityBuildConstDef.ACTION_ATK.beginPos = cc.p(5644.0, 1687)
cityBuildConstDef.ACTION_ATK.name = "d_1_2_1_n_1.0_" .. soldierScale .. "_50_m+3.5_mt+1_ms+" .. soldierSpeed
cityBuildConstDef.ACTION_ATK.number = 16
cityBuildConstDef.ACTION_ATK.padx = 17
cityBuildConstDef.ACTION_ATK.pady = 9
cityBuildConstDef.ACTION_ATK.stateType = "d"
cityBuildConstDef.ACTION_ATK.soldierType = cityBuildConstDef.soldierType_BuBing
cityBuildConstDef.ACTION_ATK.subType = cityBuildConstDef.soldierType_SubType2
cityBuildConstDef.ACTION_ATK.actType = cityBuildConstDef.ACTION_ATK
cityBuildConstDef.ACTION_ATK.direction = "n"
cityBuildConstDef.ACTION_ATK.scaleX = 1.0
cityBuildConstDef.ACTION_ATK.scaleY = soldierScale
cityBuildConstDef.ACTION_ATK.zOrder = 50
_ENV, cityBuildConstDef.ACTION_ATK.image = cityBuildConstDef.ACTION_ATK, "bubing_gj_n_01.png"
cityBuildConstDef.ACTION_ATK.beginPos = cc.p(5674, 1672)
cityBuildConstDef.ACTION_ATK.name = "d_1_2_1_n_1.0_" .. soldierScale .. "_50_m+3.5_mt+1_ms+" .. soldierSpeed
cityBuildConstDef.ACTION_ATK.number = 16
cityBuildConstDef.ACTION_ATK.padx = 17
cityBuildConstDef.ACTION_ATK.pady = 9
cityBuildConstDef.ACTION_ATK.stateType = "d"
cityBuildConstDef.ACTION_ATK.soldierType = cityBuildConstDef.soldierType_BuBing
cityBuildConstDef.ACTION_ATK.subType = cityBuildConstDef.soldierType_SubType2
cityBuildConstDef.ACTION_ATK.actType = cityBuildConstDef.ACTION_ATK
cityBuildConstDef.ACTION_ATK.direction = "n"
cityBuildConstDef.ACTION_ATK.scaleX = 1.0
cityBuildConstDef.ACTION_ATK.scaleY = soldierScale
cityBuildConstDef.ACTION_ATK.zOrder = 50
_ENV, cityBuildConstDef.ACTION_ATK.image = cityBuildConstDef.ACTION_ATK, "bubing_gj_n_01.png"
cityBuildConstDef.ACTION_ATK.beginPos = cc.p(5704.0, 1657)
cityBuildConstDef.ACTION_ATK.name = "d_1_2_1_n_1.0_" .. soldierScale .. "_50_m+3.5_mt+1_ms+" .. soldierSpeed
cityBuildConstDef.ACTION_ATK.number = 16
cityBuildConstDef.ACTION_ATK.padx = 17
cityBuildConstDef.ACTION_ATK.pady = 9
cityBuildConstDef.ACTION_ATK.stateType = "d"
cityBuildConstDef.ACTION_ATK.soldierType = cityBuildConstDef.soldierType_BuBing
cityBuildConstDef.ACTION_ATK.subType = cityBuildConstDef.soldierType_SubType2
cityBuildConstDef.ACTION_ATK.actType = cityBuildConstDef.ACTION_ATK
cityBuildConstDef.ACTION_ATK.direction = "n"
cityBuildConstDef.ACTION_ATK.scaleX = 1.0
cityBuildConstDef.ACTION_ATK.scaleY = soldierScale
cityBuildConstDef.ACTION_ATK.zOrder = 50
_ENV, cityBuildConstDef.ACTION_ATK.image = cityBuildConstDef.ACTION_ATK, "bubing_gj_n_01.png"
cityBuildConstDef.ACTION_ATK.beginPos = cc.p(5368.0, 1704)
cityBuildConstDef.ACTION_ATK.name = "d_1_2_1_wn_1.0_" .. soldierScale .. "_50_m+3.5_mt+1_ms+" .. soldierSpeed
cityBuildConstDef.ACTION_ATK.number = 3
cityBuildConstDef.ACTION_ATK.padx = 26
cityBuildConstDef.ACTION_ATK.pady = 12
cityBuildConstDef.ACTION_ATK.stateType = "d"
cityBuildConstDef.ACTION_ATK.soldierType = cityBuildConstDef.soldierType_BuBing
cityBuildConstDef.ACTION_ATK.subType = cityBuildConstDef.soldierType_SubType2
cityBuildConstDef.ACTION_ATK.actType = cityBuildConstDef.ACTION_ATK
cityBuildConstDef.ACTION_ATK.direction = "wn"
cityBuildConstDef.ACTION_ATK.scaleX = 1.0
cityBuildConstDef.ACTION_ATK.scaleY = soldierScale
cityBuildConstDef.ACTION_ATK.zOrder = 50
_ENV, cityBuildConstDef.ACTION_ATK.image = cityBuildConstDef.ACTION_ATK, "bubing_gj_wn_01.png"
cityBuildConstDef.ACTION_ATK.beginPos = cc.p(5288, 1605)
cityBuildConstDef.ACTION_ATK.name = "d_1_2_1_n_1.0_" .. soldierScale .. "_50_m+3.5_mt+1_ms+" .. soldierSpeed
cityBuildConstDef.ACTION_ATK.number = 6
cityBuildConstDef.ACTION_ATK.padx = 20
cityBuildConstDef.ACTION_ATK.pady = 10
cityBuildConstDef.ACTION_ATK.stateType = "d"
cityBuildConstDef.ACTION_ATK.soldierType = cityBuildConstDef.soldierType_BuBing
cityBuildConstDef.ACTION_ATK.subType = cityBuildConstDef.soldierType_SubType2
cityBuildConstDef.ACTION_ATK.actType = cityBuildConstDef.ACTION_ATK
cityBuildConstDef.ACTION_ATK.direction = "n"
cityBuildConstDef.ACTION_ATK.scaleX = 1.0
cityBuildConstDef.ACTION_ATK.scaleY = soldierScale
cityBuildConstDef.ACTION_ATK.zOrder = 50
_ENV, cityBuildConstDef.ACTION_ATK.image = cityBuildConstDef.ACTION_ATK, "bubing_gj_n_01.png"
cityBuildConstDef.ACTION_ATK.beginPos = cc.p(5328.0, 1602.17)
cityBuildConstDef.ACTION_ATK.name = "d_1_2_1_n_1.0_" .. soldierScale .. "_50_m+3.5_mt+1_ms+" .. soldierSpeed
cityBuildConstDef.ACTION_ATK.number = 6
cityBuildConstDef.ACTION_ATK.padx = 20
cityBuildConstDef.ACTION_ATK.pady = 10
cityBuildConstDef.ACTION_ATK.stateType = "d"
cityBuildConstDef.ACTION_ATK.soldierType = cityBuildConstDef.soldierType_BuBing
cityBuildConstDef.ACTION_ATK.subType = cityBuildConstDef.soldierType_SubType2
cityBuildConstDef.ACTION_ATK.actType = cityBuildConstDef.ACTION_ATK
cityBuildConstDef.ACTION_ATK.direction = "n"
cityBuildConstDef.ACTION_ATK.scaleX = 1.0
cityBuildConstDef.ACTION_ATK.scaleY = soldierScale
cityBuildConstDef.ACTION_ATK.zOrder = 50
_ENV, cityBuildConstDef.ACTION_ATK.image = cityBuildConstDef.ACTION_ATK, "bubing_gj_n_01.png"
cityBuildConstDef.ACTION_ATK.beginPos = cc.p(5212.0, 1485)
cityBuildConstDef.ACTION_ATK.name = "d_1_2_1_n_1.0_" .. soldierScale .. "_50_m+3.5_mt+1_ms+" .. soldierSpeed
cityBuildConstDef.ACTION_ATK.number = 16
cityBuildConstDef.ACTION_ATK.padx = 17
cityBuildConstDef.ACTION_ATK.pady = 8
cityBuildConstDef.ACTION_ATK.stateType = "d"
cityBuildConstDef.ACTION_ATK.soldierType = cityBuildConstDef.soldierType_BuBing
cityBuildConstDef.ACTION_ATK.subType = cityBuildConstDef.soldierType_SubType2
cityBuildConstDef.ACTION_ATK.actType = cityBuildConstDef.ACTION_ATK
cityBuildConstDef.ACTION_ATK.direction = "n"
cityBuildConstDef.ACTION_ATK.scaleX = 1.0
cityBuildConstDef.ACTION_ATK.scaleY = soldierScale
cityBuildConstDef.ACTION_ATK.zOrder = 50
_ENV, cityBuildConstDef.ACTION_ATK.image = cityBuildConstDef.ACTION_ATK, "bubing_gj_n_01.png"
cityBuildConstDef.ACTION_ATK.beginPos = cc.p(5242, 1470)
cityBuildConstDef.ACTION_ATK.name = "d_1_2_1_n_1.0_" .. soldierScale .. "_50_m+3.5_mt+1_ms+" .. soldierSpeed
cityBuildConstDef.ACTION_ATK.number = 16
cityBuildConstDef.ACTION_ATK.padx = 17
cityBuildConstDef.ACTION_ATK.pady = 8
cityBuildConstDef.ACTION_ATK.stateType = "d"
cityBuildConstDef.ACTION_ATK.soldierType = cityBuildConstDef.soldierType_BuBing
cityBuildConstDef.ACTION_ATK.subType = cityBuildConstDef.soldierType_SubType2
cityBuildConstDef.ACTION_ATK.actType = cityBuildConstDef.ACTION_ATK
cityBuildConstDef.ACTION_ATK.direction = "n"
cityBuildConstDef.ACTION_ATK.scaleX = 1.0
cityBuildConstDef.ACTION_ATK.scaleY = soldierScale
cityBuildConstDef.ACTION_ATK.zOrder = 50
_ENV, cityBuildConstDef.ACTION_ATK.image = cityBuildConstDef.ACTION_ATK, "bubing_gj_n_01.png"
cityBuildConstDef.ACTION_ATK.beginPos = cc.p(5262.0, 1455)
cityBuildConstDef.ACTION_ATK.name = "d_1_2_1_n_1.0_" .. soldierScale .. "_50_m+3.5_mt+1_ms+" .. soldierSpeed
cityBuildConstDef.ACTION_ATK.number = 16
cityBuildConstDef.ACTION_ATK.padx = 17
cityBuildConstDef.ACTION_ATK.pady = 8
cityBuildConstDef.ACTION_ATK.stateType = "d"
cityBuildConstDef.ACTION_ATK.soldierType = cityBuildConstDef.soldierType_BuBing
cityBuildConstDef.ACTION_ATK.subType = cityBuildConstDef.soldierType_SubType2
cityBuildConstDef.ACTION_ATK.actType = cityBuildConstDef.ACTION_ATK
cityBuildConstDef.ACTION_ATK.direction = "n"
cityBuildConstDef.ACTION_ATK.scaleX = 1.0
cityBuildConstDef.ACTION_ATK.scaleY = soldierScale
cityBuildConstDef.ACTION_ATK.zOrder = 50
_ENV, cityBuildConstDef.ACTION_ATK.image = cityBuildConstDef.ACTION_ATK, "bubing_gj_n_01.png"
cityBuildConstDef.ACTION_ATK.beginPos = cc.p(5390, 1440)
cityBuildConstDef.ACTION_ATK.name = "s_2_2_1_wn_1.0_" .. soldierScaleQibing .. "_50"
cityBuildConstDef.ACTION_ATK.number = 22
cityBuildConstDef.ACTION_ATK.padx = 24
cityBuildConstDef.ACTION_ATK.pady = 12
cityBuildConstDef.ACTION_ATK.stateType = "s"
cityBuildConstDef.ACTION_ATK.soldierType = cityBuildConstDef.soldierType_QiBing
cityBuildConstDef.ACTION_ATK.subType = cityBuildConstDef.soldierType_SubType2
cityBuildConstDef.ACTION_ATK.actType = cityBuildConstDef.ACTION_ATK
cityBuildConstDef.ACTION_ATK.direction = "wn"
cityBuildConstDef.ACTION_ATK.scaleX = 1.0
cityBuildConstDef.ACTION_ATK.scaleY = 1.0
cityBuildConstDef.ACTION_ATK.zOrder = 50
_ENV, cityBuildConstDef.ACTION_ATK.image = cityBuildConstDef.ACTION_ATK, "qibing_gj_wn_01.png"
cityBuildConstDef.ACTION_ATK.beginPos = cc.p(5420, 1400)
cityBuildConstDef.ACTION_ATK.name = "s_2_2_1_wn_1.0_" .. soldierScaleQibing .. "_50"
cityBuildConstDef.ACTION_ATK.number = 22
cityBuildConstDef.ACTION_ATK.padx = 24
cityBuildConstDef.ACTION_ATK.pady = 12
cityBuildConstDef.ACTION_ATK.stateType = "s"
cityBuildConstDef.ACTION_ATK.soldierType = cityBuildConstDef.soldierType_QiBing
cityBuildConstDef.ACTION_ATK.subType = cityBuildConstDef.soldierType_SubType2
cityBuildConstDef.ACTION_ATK.actType = cityBuildConstDef.ACTION_ATK
cityBuildConstDef.ACTION_ATK.direction = "wn"
cityBuildConstDef.ACTION_ATK.scaleX = 1.0
cityBuildConstDef.ACTION_ATK.scaleY = 1.0
cityBuildConstDef.ACTION_ATK.zOrder = 50
_ENV, cityBuildConstDef.ACTION_ATK.image = cityBuildConstDef.ACTION_ATK, "qibing_gj_wn_01.png"
cityBuildConstDef.ACTION_ATK.beginPos = cc.p(5570, 1397)
cityBuildConstDef.ACTION_ATK.name = "d_3_2_1_wn_1.0_" .. soldierScaleGongbing .. "_50_a+" .. attackDelay .. "_at+6"
cityBuildConstDef.ACTION_ATK.number = 6
cityBuildConstDef.ACTION_ATK.padx = 18
cityBuildConstDef.ACTION_ATK.pady = 10
cityBuildConstDef.ACTION_ATK.stateType = "d"
cityBuildConstDef.ACTION_ATK.soldierType = cityBuildConstDef.soldierType_GongjianBing
cityBuildConstDef.ACTION_ATK.subType = cityBuildConstDef.soldierType_SubType2
cityBuildConstDef.ACTION_ATK.actType = cityBuildConstDef.ACTION_ATK
cityBuildConstDef.ACTION_ATK.direction = "wn"
cityBuildConstDef.ACTION_ATK.scaleX = 1.0
cityBuildConstDef.ACTION_ATK.scaleY = soldierScaleGongbing
cityBuildConstDef.ACTION_ATK.zOrder = 50
cityBuildConstDef.ACTION_ATK.a = 1.5
cityBuildConstDef.ACTION_ATK.at = 6
_ENV, cityBuildConstDef.ACTION_ATK.image = cityBuildConstDef.ACTION_ATK, "gongbing_gj_wn_01.png"
cityBuildConstDef.ACTION_ATK.beginPos = cc.p(5600, 1377)
cityBuildConstDef.ACTION_ATK.name = "d_3_2_1_wn_1.0_" .. soldierScaleGongbing .. "_50_a+" .. attackDelay .. "_at+6"
cityBuildConstDef.ACTION_ATK.number = 6
cityBuildConstDef.ACTION_ATK.padx = 18
cityBuildConstDef.ACTION_ATK.pady = 10
cityBuildConstDef.ACTION_ATK.stateType = "d"
cityBuildConstDef.ACTION_ATK.soldierType = cityBuildConstDef.soldierType_GongjianBing
cityBuildConstDef.ACTION_ATK.subType = cityBuildConstDef.soldierType_SubType2
cityBuildConstDef.ACTION_ATK.actType = cityBuildConstDef.ACTION_ATK
cityBuildConstDef.ACTION_ATK.direction = "wn"
cityBuildConstDef.ACTION_ATK.scaleX = 1.0
cityBuildConstDef.ACTION_ATK.scaleY = soldierScaleGongbing
cityBuildConstDef.ACTION_ATK.zOrder = 50
cityBuildConstDef.ACTION_ATK.a = 1.5
cityBuildConstDef.ACTION_ATK.at = 6
_ENV, cityBuildConstDef.ACTION_ATK.image = cityBuildConstDef.ACTION_ATK, "gongbing_gj_wn_01.png"
cityBuildConstDef.ACTION_ATK.beginPos = cc.p(5630, 1357)
cityBuildConstDef.ACTION_ATK.name = "d_3_2_1_wn_1.0_" .. soldierScaleGongbing .. "_50_a+" .. attackDelay .. "_at+6"
cityBuildConstDef.ACTION_ATK.number = 6
cityBuildConstDef.ACTION_ATK.padx = 18
cityBuildConstDef.ACTION_ATK.pady = 10
cityBuildConstDef.ACTION_ATK.stateType = "d"
cityBuildConstDef.ACTION_ATK.soldierType = cityBuildConstDef.soldierType_GongjianBing
cityBuildConstDef.ACTION_ATK.subType = cityBuildConstDef.soldierType_SubType2
cityBuildConstDef.ACTION_ATK.actType = cityBuildConstDef.ACTION_ATK
cityBuildConstDef.ACTION_ATK.direction = "wn"
cityBuildConstDef.ACTION_ATK.scaleX = 1.0
cityBuildConstDef.ACTION_ATK.scaleY = soldierScaleGongbing
cityBuildConstDef.ACTION_ATK.zOrder = 50
cityBuildConstDef.ACTION_ATK.a = 1.5
cityBuildConstDef.ACTION_ATK.at = 6
_ENV, cityBuildConstDef.ACTION_ATK.image = cityBuildConstDef.ACTION_ATK, "gongbing_gj_wn_01.png"
cityBuildConstDef.ACTION_ATK.beginPos = cc.p(5870, 1544)
cityBuildConstDef.ACTION_ATK.name = "d_3_2_1_wn_1.0_" .. soldierScaleGongbing .. "_50_a+" .. attackDelay .. "_at+7"
cityBuildConstDef.ACTION_ATK.number = 6
cityBuildConstDef.ACTION_ATK.padx = 18
cityBuildConstDef.ACTION_ATK.pady = 10
cityBuildConstDef.ACTION_ATK.stateType = "d"
cityBuildConstDef.ACTION_ATK.soldierType = cityBuildConstDef.soldierType_GongjianBing
cityBuildConstDef.ACTION_ATK.subType = cityBuildConstDef.soldierType_SubType2
cityBuildConstDef.ACTION_ATK.actType = cityBuildConstDef.ACTION_ATK
cityBuildConstDef.ACTION_ATK.direction = "wn"
cityBuildConstDef.ACTION_ATK.scaleX = 1.0
cityBuildConstDef.ACTION_ATK.scaleY = soldierScaleGongbing
cityBuildConstDef.ACTION_ATK.zOrder = 50
cityBuildConstDef.ACTION_ATK.a = 1.5
cityBuildConstDef.ACTION_ATK.at = 6
_ENV, cityBuildConstDef.ACTION_ATK.image = cityBuildConstDef.ACTION_ATK, "gongbing_gj_wn_01.png"
cityBuildConstDef.ACTION_ATK.beginPos = cc.p(5905, 1524)
cityBuildConstDef.ACTION_ATK.name = "d_3_2_1_wn_1.0_" .. soldierScaleGongbing .. "_50_a+" .. attackDelay .. "_at+7"
cityBuildConstDef.ACTION_ATK.number = 6
cityBuildConstDef.ACTION_ATK.padx = 18
cityBuildConstDef.ACTION_ATK.pady = 10
cityBuildConstDef.ACTION_ATK.stateType = "d"
cityBuildConstDef.ACTION_ATK.soldierType = cityBuildConstDef.soldierType_GongjianBing
cityBuildConstDef.ACTION_ATK.subType = cityBuildConstDef.soldierType_SubType2
cityBuildConstDef.ACTION_ATK.actType = cityBuildConstDef.ACTION_ATK
cityBuildConstDef.ACTION_ATK.direction = "wn"
cityBuildConstDef.ACTION_ATK.scaleX = 1.0
cityBuildConstDef.ACTION_ATK.scaleY = soldierScaleGongbing
cityBuildConstDef.ACTION_ATK.zOrder = 50
cityBuildConstDef.ACTION_ATK.a = 1.5
cityBuildConstDef.ACTION_ATK.at = 6
_ENV, cityBuildConstDef.ACTION_ATK.image = cityBuildConstDef.ACTION_ATK, "gongbing_gj_wn_01.png"
cityBuildConstDef.ACTION_ATK.beginPos = cc.p(5935, 1504)
cityBuildConstDef.ACTION_ATK.name = "d_3_2_1_wn_1.0_" .. soldierScaleGongbing .. "_50_a+" .. attackDelay .. "_at+7"
cityBuildConstDef.ACTION_ATK.number = 6
cityBuildConstDef.ACTION_ATK.padx = 18
cityBuildConstDef.ACTION_ATK.pady = 10
cityBuildConstDef.ACTION_ATK.stateType = "d"
cityBuildConstDef.ACTION_ATK.soldierType = cityBuildConstDef.soldierType_GongjianBing
cityBuildConstDef.ACTION_ATK.subType = cityBuildConstDef.soldierType_SubType2
cityBuildConstDef.ACTION_ATK.actType = cityBuildConstDef.ACTION_ATK
cityBuildConstDef.ACTION_ATK.direction = "wn"
cityBuildConstDef.ACTION_ATK.scaleX = 1.0
cityBuildConstDef.ACTION_ATK.scaleY = soldierScaleGongbing
cityBuildConstDef.ACTION_ATK.zOrder = 50
cityBuildConstDef.ACTION_ATK.a = 1.5
cityBuildConstDef.ACTION_ATK.at = 6
_ENV, cityBuildConstDef.ACTION_ATK.image = cityBuildConstDef.ACTION_ATK, "gongbing_gj_wn_01.png"
cityBuildConstDef.ACTION_ATK.beginPos = cc.p(5620, 1300)
cityBuildConstDef.ACTION_ATK.name = "d_3_2_1_wn_1.0_" .. soldierScaleGongbing .. "_50_a+" .. attackDelay .. "_at+8"
cityBuildConstDef.ACTION_ATK.number = 26
cityBuildConstDef.ACTION_ATK.padx = 18
cityBuildConstDef.ACTION_ATK.pady = 9
cityBuildConstDef.ACTION_ATK.stateType = "d"
cityBuildConstDef.ACTION_ATK.soldierType = cityBuildConstDef.soldierType_GongjianBing
cityBuildConstDef.ACTION_ATK.subType = cityBuildConstDef.soldierType_SubType2
cityBuildConstDef.ACTION_ATK.actType = cityBuildConstDef.ACTION_ATK
cityBuildConstDef.ACTION_ATK.direction = "wn"
cityBuildConstDef.ACTION_ATK.scaleX = 1.0
cityBuildConstDef.ACTION_ATK.scaleY = soldierScaleGongbing
cityBuildConstDef.ACTION_ATK.zOrder = 50
cityBuildConstDef.ACTION_ATK.a = 1.5
cityBuildConstDef.ACTION_ATK.at = 8
_ENV, cityBuildConstDef.ACTION_ATK.image = cityBuildConstDef.ACTION_ATK, "gongbing_gj_wn_01.png"
cityBuildConstDef.ACTION_ATK.beginPos = cc.p(5640, 1280)
cityBuildConstDef.ACTION_ATK.name = "d_3_2_1_wn_1.0_" .. soldierScaleGongbing .. "_50_a+" .. attackDelay .. "_at+8"
cityBuildConstDef.ACTION_ATK.number = 26
cityBuildConstDef.ACTION_ATK.padx = 18
cityBuildConstDef.ACTION_ATK.pady = 9
cityBuildConstDef.ACTION_ATK.stateType = "d"
cityBuildConstDef.ACTION_ATK.soldierType = cityBuildConstDef.soldierType_GongjianBing
cityBuildConstDef.ACTION_ATK.subType = cityBuildConstDef.soldierType_SubType2
cityBuildConstDef.ACTION_ATK.actType = cityBuildConstDef.ACTION_ATK
cityBuildConstDef.ACTION_ATK.direction = "wn"
cityBuildConstDef.ACTION_ATK.scaleX = 1.0
cityBuildConstDef.ACTION_ATK.scaleY = soldierScaleGongbing
cityBuildConstDef.ACTION_ATK.zOrder = 50
cityBuildConstDef.ACTION_ATK.a = 1.5
cityBuildConstDef.ACTION_ATK.at = 8
_ENV, cityBuildConstDef.ACTION_ATK.image = cityBuildConstDef.ACTION_ATK, "gongbing_gj_wn_01.png"
cityBuildConstDef.ACTION_ATK.beginPos = cc.p(5660, 1260)
cityBuildConstDef.ACTION_ATK.name = "d_3_2_1_wn_1.0_" .. soldierScaleGongbing .. "_50_a+" .. attackDelay .. "_at+8"
cityBuildConstDef.ACTION_ATK.number = 26
cityBuildConstDef.ACTION_ATK.padx = 18
cityBuildConstDef.ACTION_ATK.pady = 9
cityBuildConstDef.ACTION_ATK.stateType = "d"
cityBuildConstDef.ACTION_ATK.soldierType = cityBuildConstDef.soldierType_GongjianBing
cityBuildConstDef.ACTION_ATK.subType = cityBuildConstDef.soldierType_SubType2
cityBuildConstDef.ACTION_ATK.actType = cityBuildConstDef.ACTION_ATK
cityBuildConstDef.ACTION_ATK.direction = "wn"
cityBuildConstDef.ACTION_ATK.scaleX = 1.0
cityBuildConstDef.ACTION_ATK.scaleY = soldierScaleGongbing
cityBuildConstDef.ACTION_ATK.zOrder = 50
cityBuildConstDef.ACTION_ATK.a = 1.5
cityBuildConstDef.ACTION_ATK.at = 8
cityBuildConstDef.ACTION_ATK.image = "gongbing_gj_wn_01.png"
;(nil)[1] = nil
;(nil)[2] = cityBuildConstDef.ACTION_ATK
;(nil)[3] = cityBuildConstDef.ACTION_ATK
;(nil)[4] = cityBuildConstDef.ACTION_ATK
;(nil)[5] = cityBuildConstDef.ACTION_ATK
;(nil)[6] = cityBuildConstDef.ACTION_ATK
;(nil)[7] = cityBuildConstDef.ACTION_ATK
;(nil)[8] = cityBuildConstDef.ACTION_ATK
;(nil)[9] = cityBuildConstDef.ACTION_ATK
;(nil)[10] = cityBuildConstDef.ACTION_ATK
;(nil)[11] = cityBuildConstDef.ACTION_ATK
;(nil)[12] = cityBuildConstDef.ACTION_ATK
;(nil)[13] = cityBuildConstDef.ACTION_ATK
;(nil)[14] = cityBuildConstDef.ACTION_ATK
;(nil)[15] = cityBuildConstDef.ACTION_ATK
;(nil)[16] = cityBuildConstDef.ACTION_ATK
;(nil)[17] = cityBuildConstDef.ACTION_ATK
;(nil)[18] = cityBuildConstDef.ACTION_ATK
;(nil)[19] = cityBuildConstDef.ACTION_ATK
;(nil)[20] = cityBuildConstDef.ACTION_ATK
;(nil)[21] = cityBuildConstDef.ACTION_ATK
;(nil)[22] = cityBuildConstDef.ACTION_ATK
local (nil)[23], outerCitySoldiers = cityBuildConstDef.ACTION_ATK, nil
function cityBuildFirstFight:createOuterCitySoldiers()
	for i, v in ipairs(outerCitySoldiers) do
		for k = 1, v.number do
			local sprite = display.newSprite("#" .. v.image)
			if v.scaleX == -1.0 then
				sprite:setFlippedX(true)
			end
			self.batchNodeFightSoldiers:addChild(sprite)
			sprite:setName(v.name)
			sprite:setPositionX(v.beginPos.x + (k - 1) * v.padx)
			sprite:setPositionY(v.beginPos.y + (k - 1) * v.pady)
			sprite:setScale(v.scaleY)
		end
	end
end
function cityBuildFirstFight:moveCameraToEnemyChief()
	local enemyPos = cc.p(3030, 3545)
	_ENV = 3545
	;(3545).msg = "MESSAGE_MAINCITYVIEW_MOVE_CAMERA_TO"
	;(3545).delay = 1.0
	;(3545).targetPos = enemyPos
	SoraDSendMessage(3545)
	_ENV = 3545
	;(3545).msg = "MESSAGE_SERVER_GUIDE_STEP_ON"
	;(3545).step = 1002
	SoraDSendMessage(3545)
	local delay = cca.delay(3.0)
	local callFunc = cca.callFunc(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_GUIDE_STEP_ON"
		;(nil).step = 1003
		SoraDSendMessage(nil)
		self:moveCameraToOuterCity()
	end)
	_UPVALUE2_ = nil
	;(nil)[1] = delay
	;(nil)[2] = callFunc
	self:runAction(cca.seq(nil))
end
function cityBuildFirstFight:moveCameraToOuterCity()
	local targetPos = self.mainCityView:getDefaultOuterCityPos()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_MOVE_CAMERA_TO"
	;(nil).delay = 3.5
	;(nil).targetPos = targetPos
	SoraDSendMessage(nil)
	local delay = cca.delay(3.6)
	local callFunc = cca.callFunc(function()
		self:showScountAnimation()
		if self.mainCityView then
			self.mainCityView:disableMoveForDuration(16)
		end
	end)
	_UPVALUE2_ = nil
	;(nil)[1] = delay
	;(nil)[2] = callFunc
	self:runAction(cca.seq(nil))
end
function cityBuildFirstFight:loadLockArea()
	_ENV = nil
	;(nil)[tostring(1220)] = cc.p(4447.0, 1287.73)
	;(nil)[tostring(1221)] = cc.p(4545.0, 678.73)
	local (nil)[tostring(1223)], posMap = cc.p(2764.0, 109.72999999999999), nil
	local _ENV, unOpenAreaList = tostring(1223), tostring(1223)
	local opengroundinfo = require("app." .. LocalTblPath .. ".config_server.opengroundinfo")
	for i, v in ipairs(opengroundinfo) do
		local isOpened = false
		if isOpened == false then
			table.insert(unOpenAreaList, #unOpenAreaList + 1, v.areaid)
		end
	end
end
function cityBuildFirstFight:moveCameraToCastle()
	local targetPos = cc.p(-1000, 5800)
	_ENV = 5800
	;(5800).msg = "MESSAGE_MAINCITYVIEW_MOVE_CAMERA_TO"
	;(5800).delay = 3.0
	;(5800).targetPos = targetPos
	;(5800).zoomScale = 0.58
	SoraDSendMessage(5800)
end
return cityBuildFirstFight
