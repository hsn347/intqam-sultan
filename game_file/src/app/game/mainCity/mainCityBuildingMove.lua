local mainCityBuildingMove = class("mainCityBuildingMove")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local ACTION_TAG = 99
local PRESS_TIME = 1
local MAP_MOVE_DIS = 20
function mainCityBuildingMove:init(mainCityView)
	self.isEditing = false
	self.isCloneNodeMoving = false
	self.isChecking = false
	self.mainCityView = mainCityView
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_BUILD_BTN_EVENT", handler(self, self.buildBtnEvent))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_EXCHANGE_BUILD", handler(self, self.exChangeEvent))
	local layer = ccui.Layout:create()
	layer:setTouchEnabled(true)
	layer:setSwallowTouches(false)
	layer:setContentSize(display.size)
	layer:setAnchorPoint(cc.p(0.5, 0.5))
	layer:setPosition(display.width / 2, display.height / 2)
	layer:setName("BuildingMoveTouchLayer")
	layer:addTo(display:getRunningScene(), 3)
	layer:addTouchEventListener(handler(self, self.onLayerTouch))
	self.touchLayer = layer
end
function mainCityBuildingMove:clean()
	SoraDRemoveMessageByTarget(self)
	self:stopEditing()
	if self.touchLayer and self.touchLayer:getParent() and self.touchLayer:getParent():isRunning() then
		self.touchLayer:removeFromParent()
	end
	self.mainCityView = nil
	self.touchLayer = nil
end
function mainCityBuildingMove:onLayerTouch(ref, event)
	if not self.cloneNode then
		return
	end
	local rect = self.cloneNode:getBoundingBox()
	if event == ccui.TouchEventType.began then
		local touchBeganPoint = ref:getTouchBeganPosition()
		local tarPos = self.mainCityView.containerView:convertToNodeSpace(touchBeganPoint)
		if cc.rectContainsPoint(rect, tarPos) then
			self:onCloneNodeTouch(ref, event)
		else
			self.isStopEditTouchBegan = true
		end
	elseif event == ccui.TouchEventType.moved then
		if self.isCloneNodeMoving then
			self:onCloneNodeTouch(ref, event)
		end
		local touchBeganPoint = ref:getTouchBeganPosition()
		local touchmovePoint = ref:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.isStopEditTouchBegan = false
			return
		end
	else
		if self.isCloneNodeMoving then
			self:onCloneNodeTouch(ref, event)
		end
		if self.isStopEditTouchBegan then
			self.isStopEditTouchBegan = false
			self:stopEditing()
			return
		end
	end
end
function mainCityBuildingMove:viewOnClick(ref, event)
	if not self.touchLayer then
		return false
	end
	if not self.isEditing then
		if event == ccui.TouchEventType.moved then
			local touchBeganPoint = ref:getTouchBeganPosition()
			local touchmovePoint = ref:getTouchMovePosition()
			local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
			if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
				self:stopCheckIsStartEdit()
			end
		else
			self:stopCheckIsStartEdit()
		end
	end
	if self.isCloneNodeMoving then
		return true
	end
end
function mainCityBuildingMove:buildButtonCallFun(build, ref, event, isSelected, buildID)
	if not self.touchLayer then
		return false
	end
	if not self.isEditing then
		if event == ccui.TouchEventType.began then
			self:checkIsStartEdit(build, self.touchLayer)
		elseif event == ccui.TouchEventType.moved then
			local touchBeganPoint = ref:getTouchBeganPosition()
			local touchmovePoint = ref:getTouchMovePosition()
			local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
			if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
				self:stopCheckIsStartEdit()
			end
		else
			self:stopCheckIsStartEdit()
		end
	elseif event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.ended then
		return true
	else
		return true
	end
	return false
end
function mainCityBuildingMove:buildBtnEvent(target, data)
	local index = data.index
	local ref = data.ref
	local event = data.eventType
	local buildName = "build_" .. index
	local buildBtn = self.mainCityView:getBufferNodeByName(buildName)
	if nil == buildBtn then
		return
	end
	self:buildButtonCallFun(buildBtn, ref, event)
end
function mainCityBuildingMove:checkIsStartEdit(build, ref)
	self:stopCheckIsStartEdit()
	print("mainCityBuildingMove:checkIsStartEdit")
	self.isChecking = true
	PRESS_TIME = "mainCityBuildingMove:checkIsStartEdit"
	;("mainCityBuildingMove:checkIsStartEdit")[1] = cca.delay(PRESS_TIME)
	;("mainCityBuildingMove:checkIsStartEdit")[2] = cca.callFunc(function()
		self.isChecking = false
		if build.singleIsMoved then
			return
		end
		if self:startEdit(build) then
			self:cloneNodeMoveStart(ref)
		end
	end)
	;("mainCityBuildingMove:checkIsStartEdit")[3] = cca.callFunc(function()
		self.isChecking = false
		if build.singleIsMoved then
			return
		end
		if self:startEdit(build) then
			self:cloneNodeMoveStart(ref)
		end
	end)
	local action = cca.seq("mainCityBuildingMove:checkIsStartEdit")
	action:setTag(ACTION_TAG)
	self.touchLayer:runAction(action)
end
function mainCityBuildingMove:stopCheckIsStartEdit()
	if self.isChecking then
		print("mainCityBuildingMove:stopCheckIsStartEdit")
		self.isChecking = false
		self.touchLayer:stopActionByTag(ACTION_TAG)
	end
end
function mainCityBuildingMove:setMovingBuild(build)
	if self.movingBuild then
		self.movingBuild:setVisible(true)
		self.movingBuild:release()
		self.cloneNode:removeFromParent()
		self.cloneNode = nil
		self.movingBuildIndex = nil
		if self.movingLampNode then
			self.movingLampNode:setVisible(true)
			self.movingLampNode:release()
			self.movingLampNode = nil
		end
		if self.buildTopTip and self.buildTopTip:isRunning() then
			self.buildTopTip:setVisible(true)
			local btnTip = SoraDGetChildByName(self.buildTopTip, "btn")
			if btnTip then
				btnTip:setTouchEnabled(true)
			end
			self.buildTopTip:release()
		end
		self.buildTopTip = nil
		local darkLayer = self:getNightLayer()
		if darkLayer then
			darkLayer:setLocalZOrder(1000)
		end
		self:updateMoveBtnArray()
	end
	self.movingBuild = build
	if not build then
		return
	end
	self.movingBuild:retain()
	local buildIndex = self.movingBuild:getTag()
	self.movingBuildIndex = buildIndex
	self.movingBuild:setVisible(false)
	self.movingLampNode = build:getParent():getChildByName("lampNode" .. buildIndex)
	if self.movingLampNode then
		self.movingLampNode:retain()
		self.movingLampNode:setVisible(false)
	end
	self.buildTopTip = build:getParent():getChildByName("build_topTip_" .. buildIndex)
	if self.buildTopTip then
		local btnTip = SoraDGetChildByName(self.buildTopTip, "btn")
		if btnTip then
			btnTip:setTouchEnabled(false)
		end
		self.buildTopTip:retain()
		self.buildTopTip:setVisible(false)
	end
	self.cloneNode = ccui.Layout:create()
	self.cloneNode:setAnchorPoint(cc.p(0.5, 0.5))
	local tmpBuild = self.movingBuild:clone()
	local buildBtn = SoraDGetChildByName(tmpBuild, "buildBtn")
	local size = tmpBuild:getContentSize()
	if buildBtn then
		buildBtn:setVisible(false)
		size = buildBtn:getContentSize()
	end
	local buildImg = SoraDGetChildByName(tmpBuild, "buildImg")
	if buildImg then
		buildImg = cc.Sprite.new(buildImg)
		buildImg:setColor(cc.c3b(255, 255, 255))
		SoraDCreateStrokeSprite2(buildImg, cc.c3b(235, 235, 0), 1, 0.003, 0.8)
	end
	local buildLv = SoraDGetChildByName(tmpBuild, "textLv")
	if buildLv then
		buildLv:setSkewY(25)
		buildLv:setScaleX(0.8)
		buildLv:setScaleY(0.9)
	end
	self.cloneNode:setContentSize(cc.size(size.width, size.height))
	tmpBuild:setPosition(self.cloneNode:getContentSize().width / 2, self.cloneNode:getContentSize().height / 2)
	tmpBuild:addTo(self.cloneNode)
	self.cloneNode:setName("cloneNode")
	tmpBuild:setVisible(true)
	tmpBuild:setTouchEnabled(false)
	tmpBuild:setName("moveFlag")
	self.cloneNode:setCascadeOpacityEnabled(true)
	self.cloneNode:setCascadeColorEnabled(true)
	self.cloneNode:setTouchEnabled(true)
	self.cloneNode:setPosition(build:getPositionX(), build:getPositionY() + 60)
	self.cloneNode:addTo(build:getParent(), 1500)
	if self.movingLampNode then
		local lampNode = self.movingLampNode:clone()
		lampNode:setVisible(true)
		lampNode:addTo(tmpBuild, 10)
		lampNode:setPosition(self.movingLampNode:getPositionX() - build:getPositionX() + tmpBuild:getContentSize().width / 2, self.movingLampNode:getPositionY() - build:getPositionY() + tmpBuild:getContentSize().height / 2)
	end
	self:flagAction()
	self:updateMoveBtnArray()
end
function mainCityBuildingMove:flagAction()
	if not self.cloneNode then
		return
	end
	local tmpBuild = self.cloneNode:getChildByName("moveFlag")
	tmpBuild:setPosition(self.cloneNode:getContentSize().width / 2, self.cloneNode:getContentSize().height / 2)
	local action1 = cca.moveTo(1, tmpBuild:getPositionX(), tmpBuild:getPositionY() + 5)
	local action2 = cca.moveTo(1, tmpBuild:getPositionX(), tmpBuild:getPositionY() - 5)
	tmpBuild:setPositionY(tmpBuild:getPositionY() - 5)
	_UPVALUE2_ = nil
	;(nil)[1] = action1
	;(nil)[2] = action2
	tmpBuild:runAction(cca.repeatForever(cca.seq(nil)))
end
function mainCityBuildingMove:startEdit(build)
	print("mainCityBuildingMove:startEdit")
	if not build then
		return false
	end
	local buildIndex = build:getTag()
	local buildEntity = self.mainCityView:getBuildByIndex(buildIndex)
	if buildEntity and buildEntity:getIsCanMove() ~= true then
		SoraDShowMsgTip(i18n("tips_mobileArchitecture"))
		return false
	end
	if not buildEntity then
		return false
	end
	_ENV = i18n("tips_mobileArchitecture")
	i18n("tips_mobileArchitecture").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
	SoraDSendMessage(i18n("tips_mobileArchitecture"))
	self:getAllBuldIdxs()
	self.isEditing = true
	self.isFirstMove = true
	self:setMovingBuild(build)
	return true
end
function mainCityBuildingMove:stopEditing()
	self.isEditing = false
	self.isCloneNodeMoving = false
	self:clearLastBuild()
	self:setMovingBuild(nil)
end
function mainCityBuildingMove:getAllBuldIdxs()
	self.allBuildings, _UPVALUE0_ = nil, nil
	local buildEntity = self.mainCityView:getBuildByIndex(1051)
	if not buildEntity or buildEntity:getIsCanMove() == true then
		self:insertIndex(self.allBuildings, 1051)
	end
	for buildIndex = 1056, 1067 do
		local buildEntity = self.mainCityView:getBuildByIndex(buildIndex)
		if not buildEntity or buildEntity:getIsCanMove() == true then
			self:insertIndex(self.allBuildings, buildIndex)
		end
	end
	self:insertIndex(self.allBuildings, 1204)
	for buildIndex = 1100, 1134 do
		local buildEntity = self.mainCityView:getBuildByIndex(buildIndex)
		if (not buildEntity or buildEntity:getIsCanMove() == true) and self.mainCityView:getIsOuterBuildUnLocked(buildIndex) then
			self:insertIndex(self.allBuildings, buildIndex)
		end
	end
	return self.allBuildings
end
function mainCityBuildingMove:insertIndex(allBuildings, buildIndex)
	local buildBtnName = "build_" .. buildIndex
	local buildBtn = self.mainCityView:getBufferNodeByName(buildBtnName)
	local rect
	if nil ~= buildBtn then
		rect = buildBtn:getBoundingBox()
	end
	if rect then
		rect.x = rect.x + rect.width * 0.3
		rect.y = rect.y + rect.height * 0.3
		rect.width = rect.width * 0.4
		rect.height = rect.height * 0.4
	end
	_ENV = nil
	;(nil).buildIndex = buildIndex
	;(nil).rect = rect
	table.insert(allBuildings, nil)
	return allBuildings
end
function mainCityBuildingMove:getMoveTypeByBuildIndex(buildIndex)
	if buildIndex == nil then
		return 0
	end
	if buildIndex < 1100 or buildIndex == 1204 then
		return 1
	end
	return 2
end
function mainCityBuildingMove:updateMoveBtnArray()
	if not self.movingBuildIndex then
		for i, v in ipairs(self.allBuildings) do
			self:hideBuildMoveEffect(v.buildIndex)
		end
		return
	end
	local moveType = self:getMoveTypeByBuildIndex(self.movingBuildIndex)
	for i, v in ipairs(self.allBuildings) do
		local buildIndex = v.buildIndex
		if self:getMoveTypeByBuildIndex(buildIndex) == moveType and buildIndex ~= self.movingBuildIndex then
			self:showBuildMoveEffect(buildIndex, true)
		elseif buildIndex ~= self.movingBuildIndex then
			self:showBuildMoveEffect(buildIndex, false)
		else
			self:showBuildMoveEffect(buildIndex, true)
		end
	end
end
function mainCityBuildingMove:showBuildMoveEffect(buildIndex, isGreen, isNeedMove)
	local buildBtnName = "build_" .. buildIndex
	local buildBtn = self.mainCityView:getBufferNodeByName(buildBtnName)
	if nil == buildBtn then
		return
	end
	local bOriScale = 0.6
	if buildIndex < 1100 or buildIndex == 1204 then
		bOriScale = 1.4
	end
	local buildBtnImgMoveName = "imgMove_" .. buildIndex
	local buildBtnImgMove = self.mainCityView.batchNodeCityOthers:getChildByName(buildBtnImgMoveName)
	if nil == buildBtnImgMove then
		buildBtnImgMove = display.newSprite("#tile_frame.png")
		buildBtnImgMove:addTo(self.mainCityView.batchNodeCityOthers, 1)
		buildBtnImgMove:setName(buildBtnImgMoveName)
		buildBtnImgMove:setVisible(true)
		buildBtnImgMove:setOpacity(255)
		buildBtnImgMove:setAnchorPoint(cc.p(0.5, 0.5))
		buildBtnImgMove:setPosition(cc.p(buildBtn:getPositionX(), buildBtn:getPositionY()))
	end
	buildBtnImgMove:setScale(bOriScale)
	if isGreen then
		buildBtnImgMove:setColor(cc.c3b(6, 242, 2))
	else
		buildBtnImgMove:setColor(cc.c3b(220, 5, 5))
	end
end
function mainCityBuildingMove:hideBuildMoveEffect(buildIndex)
	local bOriScale = 1.0
	local buildBtnName = "build_" .. buildIndex
	local buildBtn = self.mainCityView:getBufferNodeByName(buildBtnName)
	if nil == buildBtn then
		return
	end
	local buildImgMoveName = "imgMove_" .. buildIndex
	local buildBtnImgMove = self.mainCityView.batchNodeCityOthers:getChildByName(buildImgMoveName)
	if nil == buildBtnImgMove then
		return
	end
	buildBtnImgMove:setVisible(false)
	buildBtnImgMove:stopAllActions()
	buildBtnImgMove:setScale(bOriScale)
	buildBtnImgMove:removeFromParent()
end
function mainCityBuildingMove:onCloneNodeTouch(ref, event)
	if event == ccui.TouchEventType.began then
		self:cloneNodeMoveStart(ref)
	elseif event == ccui.TouchEventType.moved then
		local touchMovePoint = ref:getTouchMovePosition()
		local tarPos = self.mainCityView.containerView:convertToNodeSpace(touchMovePoint)
		self.cloneNode:setPosition(self:getRealCloneNodePos(tarPos))
		self:onCloneNodeMoved(tarPos)
	else
		self.mainCityView.viewScrollView:getScrollPane():setTouchEffect(true)
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
		self.isCloneNodeMoving = false
		local touchEndPoint = ref:getTouchEndPosition()
		local tarPos = self.mainCityView.containerView:convertToNodeSpace(touchEndPoint)
		self:onCloneNodeMoveEnded(tarPos)
	end
end
function mainCityBuildingMove:cloneNodeMoveStart(ref)
	self.isCloneNodeMoving = true
	local startPos = self.mainCityView.containerView:convertToNodeSpace(ref:getTouchBeganPosition())
	self.minPos = cc.p(startPos.x - self.cloneNode:getPositionX(), startPos.y - self.cloneNode:getPositionY())
	self.mainCityView.viewScrollView:getScrollPane():setTouchEffect(false)
	if self.timer ~= nil then
		return
	else
		self.timer = SoraDCreateTimerEx(self, handler(self, self.updateInnerContainerPos), 0.03333333333333333)
	end
end
function mainCityBuildingMove:onCloneNodeMoved(tarPos)
	local moveType = self:getMoveTypeByBuildIndex(self.movingBuildIndex)
	local passBuild = self:getBuildIndexByCloneNodeRect()
	if passBuild == self.movingBuildIndex then
		passBuild = nil
	elseif self.isFirstMove then
		self.isFirstMove = false
	end
	if self.lastPassBuild and self.lastPassBuild ~= passBuild then
		self:clearLastBuild()
	end
	if (not self.lastPassBuild or self.lastPassBuild ~= passBuild) and self:getMoveTypeByBuildIndex(passBuild) == moveType then
		local buildEntity = self.mainCityView:getBuildByIndex(passBuild)
		if buildEntity then
			local buildNode = buildEntity:getParent()
			self.lastBuild = buildNode
			self.lastBuildLampNode = buildNode:getParent():getChildByName("lampNode" .. passBuild)
			buildNode:stopActionByTag(ACTION_TAG)
			_ENV = buildNode
			buildNode[1] = cca.delay(0.2)
			buildNode[2] = cca.callFunc(function()
				self.actionCloneNode = buildNode:clone()
				local buildLv = SoraDGetChildByName(self.actionCloneNode, "textLv")
				if buildLv then
					buildLv:setSkewY(25)
					buildLv:setScaleX(0.8)
					buildLv:setScaleY(0.9)
				end
				self.actionCloneNode:setPosition(buildNode:getPositionX(), buildNode:getPositionY())
				self.actionCloneNode:addTo(buildNode:getParent(), 1500)
				buildNode:setVisible(false)
				self.actionCloneNode:runAction(cca.moveTo(0.2, cc.p(self.movingBuild:getPosition())))
				if self.lastBuildLampNode then
					self.lastBuildLampNode:setVisible(false)
				end
			end)
			buildNode[3] = cca.callFunc(function()
				self.actionCloneNode = buildNode:clone()
				local buildLv = SoraDGetChildByName(self.actionCloneNode, "textLv")
				if buildLv then
					buildLv:setSkewY(25)
					buildLv:setScaleX(0.8)
					buildLv:setScaleY(0.9)
				end
				self.actionCloneNode:setPosition(buildNode:getPositionX(), buildNode:getPositionY())
				self.actionCloneNode:addTo(buildNode:getParent(), 1500)
				buildNode:setVisible(false)
				self.actionCloneNode:runAction(cca.moveTo(0.2, cc.p(self.movingBuild:getPosition())))
				if self.lastBuildLampNode then
					self.lastBuildLampNode:setVisible(false)
				end
			end)
			local action = cca.seq(buildNode)
			action:setTag(ACTION_TAG)
			buildNode:runAction(action)
		end
	elseif passBuild and self.lastPassBuild ~= passBuild then
		local tmpBuild = self.cloneNode:getChildByName("moveFlag")
		tmpBuild:setPosition(self.cloneNode:getContentSize().width / 2, self.cloneNode:getContentSize().height / 2)
		tmpBuild:setPosition(self.cloneNode:getContentSize().width / 2, self.cloneNode:getContentSize().height / 2 - 5)
		_ENV = tmpBuild
		tmpBuild[1] = cca.delay(0.5)
		tmpBuild[2] = cca.callFunc(function()
			tmpBuild:stopAllActions()
			local action1 = cca.moveTo(0.08, tmpBuild:getPositionX() - 10, tmpBuild:getPositionY() + 10)
			local action2 = cca.moveTo(0.08, tmpBuild:getPositionX() + 10, tmpBuild:getPositionY() - 10)
			local action3 = cca.moveTo(0.08, tmpBuild:getPositionX() - 10, tmpBuild:getPositionY() + 10)
			local action4 = cca.moveTo(0.04, tmpBuild:getPositionX(), tmpBuild:getPositionY())
			_UPVALUE4_ = tmpBuild:getPositionY()
			tmpBuild:getPositionY()[1] = action1
			tmpBuild:getPositionY()[2] = action2
			tmpBuild:getPositionY()[3] = action3
			tmpBuild:getPositionY()[4] = action4
			tmpBuild:getPositionY()[5] = cca.callFunc(handler(self, self.flagAction))
			tmpBuild:getPositionY()[6] = cca.callFunc(handler(self, self.flagAction))
			tmpBuild:getPositionY()[7] = cca.callFunc(handler(self, self.flagAction))
			tmpBuild:getPositionY()[8] = cca.callFunc(handler(self, self.flagAction))
			tmpBuild:runAction(cca.seq(tmpBuild:getPositionY()))
		end)
		tmpBuild[3] = cca.callFunc(function()
			tmpBuild:stopAllActions()
			local action1 = cca.moveTo(0.08, tmpBuild:getPositionX() - 10, tmpBuild:getPositionY() + 10)
			local action2 = cca.moveTo(0.08, tmpBuild:getPositionX() + 10, tmpBuild:getPositionY() - 10)
			local action3 = cca.moveTo(0.08, tmpBuild:getPositionX() - 10, tmpBuild:getPositionY() + 10)
			local action4 = cca.moveTo(0.04, tmpBuild:getPositionX(), tmpBuild:getPositionY())
			_UPVALUE4_ = tmpBuild:getPositionY()
			tmpBuild:getPositionY()[1] = action1
			tmpBuild:getPositionY()[2] = action2
			tmpBuild:getPositionY()[3] = action3
			tmpBuild:getPositionY()[4] = action4
			tmpBuild:getPositionY()[5] = cca.callFunc(handler(self, self.flagAction))
			tmpBuild:getPositionY()[6] = cca.callFunc(handler(self, self.flagAction))
			tmpBuild:getPositionY()[7] = cca.callFunc(handler(self, self.flagAction))
			tmpBuild:getPositionY()[8] = cca.callFunc(handler(self, self.flagAction))
			tmpBuild:runAction(cca.seq(tmpBuild:getPositionY()))
		end)
		tmpBuild[4] = cca.callFunc(function()
			tmpBuild:stopAllActions()
			local action1 = cca.moveTo(0.08, tmpBuild:getPositionX() - 10, tmpBuild:getPositionY() + 10)
			local action2 = cca.moveTo(0.08, tmpBuild:getPositionX() + 10, tmpBuild:getPositionY() - 10)
			local action3 = cca.moveTo(0.08, tmpBuild:getPositionX() - 10, tmpBuild:getPositionY() + 10)
			local action4 = cca.moveTo(0.04, tmpBuild:getPositionX(), tmpBuild:getPositionY())
			_UPVALUE4_ = tmpBuild:getPositionY()
			tmpBuild:getPositionY()[1] = action1
			tmpBuild:getPositionY()[2] = action2
			tmpBuild:getPositionY()[3] = action3
			tmpBuild:getPositionY()[4] = action4
			tmpBuild:getPositionY()[5] = cca.callFunc(handler(self, self.flagAction))
			tmpBuild:getPositionY()[6] = cca.callFunc(handler(self, self.flagAction))
			tmpBuild:getPositionY()[7] = cca.callFunc(handler(self, self.flagAction))
			tmpBuild:getPositionY()[8] = cca.callFunc(handler(self, self.flagAction))
			tmpBuild:runAction(cca.seq(tmpBuild:getPositionY()))
		end)
		local seq = cca.seq(tmpBuild)
		seq:setTag(ACTION_TAG + 1)
		tmpBuild:runAction(seq)
	elseif self.lastPassBuild ~= passBuild then
		local tmpBuild = self.cloneNode:getChildByName("moveFlag")
		local action = tmpBuild:getActionByTag(ACTION_TAG + 1)
		if action then
			tmpBuild:stopAction(action)
		end
	end
	self.lastPassBuild = passBuild
end
function mainCityBuildingMove:onCloneNodeMoveEnded(tarPos)
	local finalBuildIndex = self:getBuildIndexByCloneNodeRect()
	if self.lastPassBuild ~= finalBuildIndex then
		self:clearLastBuild()
	end
	if finalBuildIndex == self.movingBuildIndex then
		if not self.isFirstMove then
			self:stopEditing()
		end
		return
	end
	self.isFirstMove = false
	if finalBuildIndex then
		local moveType = self:getMoveTypeByBuildIndex(self.movingBuildIndex)
		if self:getMoveTypeByBuildIndex(finalBuildIndex) == moveType then
			self.finalBuildIndex = finalBuildIndex
			cityCtrl:exchangePosReq(self.movingBuildIndex, finalBuildIndex, BUILD_EXCHANGE_MODE.GOLD)
			cityCtrl = cityCtrl
			cityCtrl.msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
			SoraDSendMessage(cityCtrl)
		end
	end
end
function mainCityBuildingMove:clearLastBuild()
	if self.lastBuild and self.lastBuild:isRunning() then
		self.lastBuild:stopActionByTag(ACTION_TAG)
		self.lastBuild:setVisible(true)
	end
	self.lastBuild = nil
	if self.lastBuildLampNode and not tolua.isnull(self.lastBuildLampNode) and self.lastBuildLampNode:isRunning() then
		self.lastBuildLampNode:setVisible(true)
	end
	self.lastBuildLampNode = nil
	if self.actionCloneNode and self.actionCloneNode:isRunning() then
		self.actionCloneNode:removeFromParent()
	end
	self.actionCloneNode = nil
end
function mainCityBuildingMove:getBuildIndexByCloneNodeRect()
	local rect = self.cloneNode:getBoundingBox()
	if rect then
		rect.x = rect.x + rect.width * 0.3
		rect.y = rect.y + rect.height * 0.3
		rect.width = rect.width * 0.4
		rect.height = rect.height * 0.4
	end
	for i, v in ipairs(self.allBuildings) do
		if v.rect and cc.rectIntersectsRect(v.rect, rect) then
			return v.buildIndex
		end
	end
	return nil
end
function mainCityBuildingMove:updateInnerContainerPos()
	if self.isCloneNodeMoving then
		local worldPos = self.mainCityView.containerView:convertToWorldSpace(cc.p(self.cloneNode:getPosition()))
		local nowPos = self.mainCityView.viewScrollView:getContentOffset()
		local nowPosX, nowPosY = nowPos.x, nowPos.y
		local isMoved = false
		if worldPos.x >= display.width - 80 then
			isMoved = true
			self.mainCityView.viewScrollView:setContentOffset(nowPosX - MAP_MOVE_DIS, nowPosY)
		elseif worldPos.x <= 80 then
			isMoved = true
			self.mainCityView.viewScrollView:setContentOffset(nowPosX + MAP_MOVE_DIS, nowPosY)
		elseif worldPos.y >= display.height - 140 then
			isMoved = true
			self.mainCityView.viewScrollView:setContentOffset(nowPosX, nowPosY - MAP_MOVE_DIS)
		elseif worldPos.y <= 140 then
			isMoved = true
			self.mainCityView.viewScrollView:setContentOffset(nowPosX, nowPosY + MAP_MOVE_DIS)
		end
		if isMoved == true then
			local minOffset = self.mainCityView.viewScrollView:minContainerOffset()
			local nowPos = self.mainCityView.viewScrollView:getContentOffset()
			local nowPosX, nowPosY = nowPos.x, nowPos.y
			if 0 < nowPosX then
				self.mainCityView.viewScrollView:setContentOffset(0, nowPosY)
			end
			if nowPosX < minOffset.x then
				self.mainCityView.viewScrollView:setContentOffset(minOffset.x, nowPosY)
			end
			if 0 < nowPosY then
				self.mainCityView.viewScrollView:setContentOffset(nowPosX, 0)
			end
			if nowPosY < minOffset.y then
				self.mainCityView.viewScrollView:setContentOffset(nowPosX, minOffset.y)
			end
			local touchMovePoint = self.touchLayer:getTouchMovePosition()
			local tarPos = self.mainCityView.containerView:convertToNodeSpace(touchMovePoint)
			self.cloneNode:setPosition(self:getRealCloneNodePos(tarPos))
		end
	end
end
function mainCityBuildingMove:getRealCloneNodePos(pos)
	local correctPos = cc.p(pos.x - self.minPos.x, pos.y - self.minPos.y)
	local correctWordPos = self.mainCityView.containerView:convertToWorldSpace(correctPos)
	if correctWordPos.x >= display.width - 79 then
		correctWordPos.x = display.width - 79
	elseif correctWordPos.x <= 79 then
		correctWordPos.x = 79
	elseif correctWordPos.y >= display.height - 139 then
		correctWordPos.y = display.height - 139
	elseif correctWordPos.y <= 139 then
		correctWordPos.y = 139
	end
	local finalPos = self.mainCityView.containerView:convertToNodeSpace(correctWordPos)
	return finalPos
end
function mainCityBuildingMove:getNightLayer()
	local darkLayer = SoraDGetChildByName(self.mainCityView.containerView, "darkLayer")
	if darkLayer and darkLayer:isVisible() then
		return darkLayer
	end
	return nil
end
function mainCityBuildingMove:exChangeEvent()
	if self.cloneNode then
		self.cloneNode:setVisible(false)
	end
	if self.finalBuildIndex and self.movingBuildIndex then
		local build = self.mainCityView:getBuildByIndex(self.finalBuildIndex)
		if build then
			local effect_normal = SoraDCreatAnimation("Node_Effect_zjyd01", nil, false)
			effect_normal:setPosition(cc.p(build:getParent():getContentSize().width / 2, build:getParent():getContentSize().height / 2))
			local scaleValue = self:getMoveTypeByBuildIndex(self.finalBuildIndex) == 1 and 1.4 or 1.0
			effect_normal:setScale(scaleValue)
			build:getParent():addChild(effect_normal, -1)
			_UPVALUE1_ = -1
			;(-1)[1] = cca.delay(1.5833333333333333)
			;(-1)[2] = cca.removeSelf()
			effect_normal:runAction(cca.seq(-1))
			build:updateLvPos()
		end
		build = self.mainCityView:getBuildByIndex(self.movingBuildIndex)
		if build then
			local effect_normal = SoraDCreatAnimation("Node_Effect_zjyd01", nil, false)
			effect_normal:setPosition(cc.p(build:getParent():getContentSize().width / 2, build:getParent():getContentSize().height / 2))
			local scaleValue = self:getMoveTypeByBuildIndex(self.finalBuildIndex) == 1 and 1.4 or 1.0
			effect_normal:setScale(scaleValue)
			build:getParent():addChild(effect_normal, -1)
			_UPVALUE1_ = -1
			;(-1)[1] = cca.delay(1.5833333333333333)
			;(-1)[2] = cca.removeSelf()
			effect_normal:runAction(cca.seq(-1))
			build:updateLvPos()
		end
	end
	self:stopEditing()
end
return mainCityBuildingMove
