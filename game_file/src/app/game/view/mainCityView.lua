include("cityBuildingInfo")
local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local cityBuildFunction = include("cityBuildFunction")
local cityBuildConstDef = include("cityBuildConstDef")
local wallsCtrl = gametop.playertop_:getModule("wallsCtrl")
local cityBuildMgr = include("cityBuildMgr")
local mainCityMsg = include("mainCityMsg")
local mainCityCreate = include("mainCityCreate")
local effectMainCityView = include("effectMainCityView")
local mainCityFunctions = include("mainCityFunctions")
local mainCityHandler = include("mainCityHandler")
local mainCityBuildingMove = include("mainCityBuildingMove")
local mainCityABMManager = include("mainCityABMManager")
local mainCityView = class("mainCityView", function(ccsFile)
	local ccsFile = getCCSPath("mainCityView")
	local view = include("ccsView")
	return view.new(ccsFile)
end)
function mainCityView:ctor(param)
	userSDKManager.timeInfo.t_maincity.tbegin = SoraDGetSocketTime()
	print("开始创建内城------")
	self.param = param
	self:preLoadImages()
end
function mainCityView:onMessageListener()
	if self.isFinishInit then
		self:onMessageListener_FinishLoadImage()
	end
end
function mainCityView:onMessageListener_FinishLoadImage()
	mainCityMsg.registerMessage(self)
end
function mainCityView:msgUpdatePyramidBattle(target, data)
	mainCityMsg.msgUpdatePyramidBattle(self, target, data)
end
function mainCityView:msgOpenBuildByBid(target, data)
	mainCityMsg.msgOpenBuildByBid(self, target, data)
end
function mainCityView:msgReceiveOnlineBack(target, data)
	mainCityMsg.msgReceiveOnlineBack(self, target, data)
end
function mainCityView:msgNotifyShipMove(target, data)
	mainCityMsg.msgNotifyShipMove(self, target, data)
end
function mainCityView:msgNotifyShakeControl(target, data)
	mainCityMsg.msgNotifyShakeControl(self, target, data)
end
function mainCityView:addBuild(buildBtnId, buildCfgId)
	mainCityFunctions.addBuild(self, buildBtnId, buildCfgId)
end
function mainCityView:createBuild(target, data)
	mainCityMsg.createBuild(self, target, data)
end
function mainCityView:removeBuild(target, data)
	mainCityMsg.removeBuild(self, target, data)
end
function mainCityView:upgradeBuild(target, data)
	mainCityMsg.upgradeBuild(self, target, data)
end
function mainCityView:workBuild(target, data)
	if data.buildID ~= nil then
		local buildID = data.buildID
		local buildCfgID = data.buildCfgID
		local buildButton = self:getBufferNodeByName("build_" .. buildID)
		if buildButton ~= nil then
			local buildNode = SoraDGetChildByName(buildButton, "buildName")
			if buildNode then
				buildNode:setIsWaitTraining(false)
				buildNode:setBlockState("working")
				buildNode:changeState()
			end
		end
		_ENV = "working"
		;("working").buildIndex = buildID
		self:removeBuildTip(nil, "working")
	end
end
function mainCityView:btnLockAreaCallFunc(btnLockArea, ref, event)
	mainCityHandler.btnLockAreaCallFunc(self, btnLockArea, ref, event)
end
function mainCityView:buildButtonCallFun(build, ref, type, isSelected, buildID)
	mainCityHandler.buildButtonCallFun(self, build, ref, type, isSelected, buildID)
end
function mainCityView:kipchaksButtonCallFun(build, ref, type)
	if type == ccui.TouchEventType.ended then
		local index = build:getTag()
		if cityCtrl.kipchaksData.refreshNpc and cityCtrl.kipchaksData.refreshNpc[tostring(index)] then
			local panel = SoraDCreatePanel("kipchaksBossInfoView")
			panel:initData(index)
			panel:show()
		end
	end
end
function mainCityView:kipchaksUpdate(target, data)
	local cityCtrl, kipchaksData
	if cityCtrl.kipchaksData and cityCtrl.kipchaksData.refreshNpc then
		kipchaksData = cityCtrl.kipchaksData.refreshNpc
	end
	local createNPC = function(btn, lv, index)
		local sprite = btn:getChildByName("Node_npc")
		if sprite == nil then
			sprite = SoraDCreatePanel("animationKipchaksSingle")
			sprite:setPosition(105, 55)
			sprite:addTo(btn)
			sprite:setName("Node_npc")
		end
		sprite:initData(lv, index)
		sprite:setOpacity(255)
		sprite:setVisible(true)
	end
	for i = 1, 10 do
		local buildBtnName = "kipchaks_" .. i
		local buildBtn = self:getBufferNodeByName(buildBtnName)
		if buildBtn then
			if kipchaksData[tostring(i)] then
				buildBtn:setVisible(true)
				buildBtn:setTouchEnabled(true)
				buildBtn:setSwallowTouches(true)
				createNPC(buildBtn, kipchaksData[tostring(i)], i)
			else
				buildBtn:setTouchEnabled(false)
				if data and data.isUpdate then
					local npc = buildBtn:getChildByName("Node_npc")
					if npc then
						npc:setVisible(false)
					end
				end
			end
		end
	end
end
function mainCityView:buildCreatePanelShowBegin()
	print("界面动画开始")
	local guideStep = SoraDIsGameGuide()
end
function mainCityView:doBuildOffset(build)
	mainCityFunctions.doBuildOffset(self, build)
end
function mainCityView:setOffsetContainerWithBuildTip(target, data)
	mainCityMsg.setOffsetContainerWithBuildTip(self, target, data)
end
function mainCityView:setOffsetContainerWithBuildTipHand(target, data)
	mainCityMsg.setOffsetContainerWithBuildTipHand(self, target, data)
end
function mainCityView:seBuildBtnEnable(target, data)
	mainCityMsg.seBuildBtnEnable(self, target, data)
end
function mainCityView:setOffsetContainerWithSelectBuild(target, data)
	mainCityMsg.setOffsetContainerWithSelectBuild(self, target, data)
end
function mainCityView:doOffsetContainerWithSelectBuild(build, scale, other)
	mainCityFunctions.doOffsetContainerWithSelectBuild(self, build, scale, other)
end
function mainCityView:viewOnClick(ref, event)
	if not mainCityBuildingMove:viewOnClick(ref, event) then
		mainCityHandler.viewOnClick(self, ref, event)
	end
end
function mainCityView:scrollViewDidZoom()
	mainCityABMManager:scrollViewDidZoom(self)
	self:PauseCastleCriSpriteOnScroll()
end
function mainCityView:scrollViewDidOffset(...)
	local sun = self:getChildByName("particle_node" .. cityBuildConstDef.weatherType.sunshine) or self:getChildByName("particle_node" .. cityBuildConstDef.weatherType.heat)
	if not tolua.isnull(sun) and not tolua.isnull(self.viewScrollView) then
		local offset = self.viewScrollView:getContentOffset()
		local rotation
		local containerSize = self.containerView:getContentSize()
		local offsetX = offset.x / self.viewScrollView:getZoomScale()
		local minX = self.viewScrollView:getViewSize().width - containerSize.width
		local percent = math.max(0, math.min(1, offsetX / minX))
		rotation = SoraDLerpNumber(-15, 20, percent)
		sun:setRotation(rotation)
	end
	self.isVisibleAreaDirty = true
	self:PauseCastleCriSpriteOnScroll()
end
function mainCityView:PauseCastleCriSpriteOnScroll()
	if self.CastleCriPaused or SoraDGetGrapicsQualityLevel() > 1 then
		return
	end
	self.CastleCriPaused = true
	if self.castleSkin and self.castleSkin.criSps then
		for i, v in ipairs(self.castleSkin.criSps) do
			if not tolua.isnull(v) then
				v:pause(true)
			end
		end
	end
	if self.castleNightSkin and self.castleNightSkin.criSps then
		for i, v in ipairs(self.castleNightSkin.criSps) do
			if not tolua.isnull(v) then
				v:pause(true)
			end
		end
	end
	SoraDDelayCallOnce("PauseCastleCriSpriteOnScroll", handler(self, self.ResumeCastleCriSpriteOnScroll), 0.1)
end
function mainCityView:ResumeCastleCriSpriteOnScroll()
	if self.isShowBuildName or not self.CastleCriPaused then
		return
	end
	self.CastleCriPaused = false
	if self.castleSkin and self.castleSkin.criSps then
		for i, v in ipairs(self.castleSkin.criSps) do
			if not tolua.isnull(v) then
				v:pause(false)
			end
		end
	end
	if self.castleNightSkin and self.castleNightSkin.criSps then
		for i, v in ipairs(self.castleNightSkin.criSps) do
			if not tolua.isnull(v) then
				v:pause(false)
			end
		end
	end
end
function mainCityView:ShowNodeTint(node)
	mainCityFunctions.ShowNodeTint(self, node)
end
function mainCityView:ShowNodeTintOnce(node)
	mainCityFunctions.ShowNodeTintOnce(self, node)
end
function mainCityView:CancelNodeTint(node)
	mainCityFunctions.CancelNodeTint(self, node)
end
function mainCityView:ShowBuildTint(build, bShow)
	mainCityFunctions.ShowBuildTint(self, build, bShow)
end
function mainCityView:CancelBuildTint(build)
	self:ShowBuildTint(build, false)
end
function mainCityView:createBuildByCfgId(buildButtonIndex, buildCfgItem)
	mainCityCreate.createBuildByCfgId(self, buildButtonIndex, buildCfgItem)
end
function mainCityView:removeBuildTip(target, data)
	mainCityMsg.removeBuildTip(self, target, data)
end
function mainCityView:addBuildTopTip(target, data)
	mainCityMsg.addBuildTopTip(self, target, data)
end
function mainCityView:removeBuildTopTip(target, data)
	mainCityMsg.removeBuildTopTip(self, target, data)
end
function mainCityView:addAnimWorker(target, data)
	mainCityMsg.addAnimWorker(self, target, data)
end
function mainCityView:removeAnimWorker(target, data)
	mainCityMsg.removeAnimWorker(self, target, data)
end
function mainCityView:addBuildWorkDoneEffect(target, data)
	mainCityMsg.addBuildWorkDoneEffect(self, target, data)
end
function mainCityView:removeBuildWorkDoneEffect(target, data)
	mainCityMsg.removeBuildWorkDoneEffect(self, target, data)
end
function mainCityView:msgUpdateFlagCoolingPanel(target, data)
	mainCityMsg.msgUpdateFlagCoolingPanel(self, target, data)
end
function mainCityView:addBuildCoolingPanel(target, data)
	mainCityMsg.addBuildCoolingPanel(self, target, data)
end
function mainCityView:removeBuildCoolingPanel(target, data)
	mainCityMsg.removeBuildCoolingPanel(self, target, data)
end
function mainCityView:addBuildTopTipHand(target, data)
	mainCityMsg.addBuildTopTipHand(self, target, data)
end
function mainCityView:removeBuildTopTipHand(target, data)
	mainCityMsg.removeBuildTopTipHand(self, target, data)
end
function mainCityView:addTroopSolider(target, data)
	mainCityMsg.addTroopSolider(self, target, data)
end
function mainCityView:removeTroopSolider(target, data)
end
function mainCityView:enterMoveMode(target, data)
	mainCityMsg.enterMoveMode(self, target, data)
end
function mainCityView:leaveMoveMode(target, data)
	mainCityMsg.leaveMoveMode(self, target, data)
end
function mainCityView:getMoveTypeByBuildIndex(buildIndex)
	if buildIndex < 1100 then
		return 1
	end
	return 2
end
function mainCityView:isBuildInMoveBtnArray(buildIndex)
	local bFindRet = false
	for i = 1, #self.currentMoveBtnArray do
		if self.currentMoveBtnArray[i] == buildIndex then
			bFindRet = true
			break
		end
	end
	return bFindRet
end
function mainCityView:getHasBuildEntity(buildIndex)
	local buildBtnName = "build_" .. buildIndex
	local buildBtn = self:getBufferNodeByName(buildBtnName)
	local buildEntity = SoraDGetChildByName(buildBtn, "buildName")
	return buildEntity ~= nil
end
function mainCityView:updateMoveBtnArrayByType(moveType)
	mainCityFunctions.updateMoveBtnArrayByType(self, moveType)
end
function mainCityView:exchangeBuild(target, data)
	mainCityMsg.exchangeBuild(self, target, data)
end
function mainCityView:showBuildMoveEffect(buildIndex, isGreen, isNeedMove)
	mainCityFunctions.showBuildMoveEffect(self, buildIndex, isGreen, isNeedMove)
end
function mainCityView:hideBuildMoveEffect(buildIndex)
	mainCityFunctions.hideBuildMoveEffect(self, buildIndex)
end
function mainCityView:showBuildMoveTip(strMoveTip)
	mainCityFunctions.showBuildMoveTip(self, strMoveTip)
end
function mainCityView:hideBuildMoveTip()
	mainCityFunctions.hideBuildMoveTip(self)
end
function mainCityView:onMoveTipClose()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
	SoraDSendMessage(nil)
end
function mainCityView:onPromptBoxCallBackUseGold(exitType)
	if MSGBOX_CALLBACK_CANCEL == exitType then
		self:showBuildMoveEffect(self.afterSelectMoveModeIndex, true, false)
		self.afterSelectMoveModeIndex = 0
		return
	elseif MSGBOX_CALLBACK_YES == exitType then
		cityCtrl:exchangePosReq(self.currentSelectMoveModeIndex, self.afterSelectMoveModeIndex, BUILD_EXCHANGE_MODE.GOLD)
		_ENV = cityCtrl
		cityCtrl.msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
		SoraDSendMessage(cityCtrl)
		return
	end
end
function mainCityView:onPromptBoxCallBackUseItem(exitType)
	if MSGBOX_CALLBACK_CANCEL == exitType then
		self:showBuildMoveEffect(self.afterSelectMoveModeIndex, true, false)
		self.afterSelectMoveModeIndex = 0
		return
	elseif MSGBOX_CALLBACK_YES == exitType then
		cityCtrl:exchangePosReq(self.currentSelectMoveModeIndex, self.afterSelectMoveModeIndex, BUILD_EXCHANGE_MODE.TOOLS)
		_ENV = cityCtrl
		cityCtrl.msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
		SoraDSendMessage(cityCtrl)
		return
	end
end
function mainCityView:onTopTipCallBack(btnTopTip, ref, event)
	mainCityHandler.onTopTipCallBack(self, btnTopTip, ref, event)
end
function mainCityView:addToTopTipArray(nodeTopTip)
	local nodeTopTipName = nodeTopTip:getName()
	if self.currentTopTipArray[nodeTopTipName] ~= nil then
		self.currentTopTipArray[nodeTopTipName] = nil
	end
	self.currentTopTipArray[nodeTopTipName] = nodeTopTip
end
function mainCityView:removeFromTopTipArray(nodeTopTip)
	local nodeTopTipName = nodeTopTip:getName()
	if self.currentTopTipArray[nodeTopTipName] ~= nil then
		self.currentTopTipArray[nodeTopTipName] = nil
	end
end
function mainCityView:getIsTouchPointInTopTipNode(touchPoint, nodeTopTip)
	return mainCityFunctions.getIsTouchPointInTopTipNode(self, touchPoint, nodeTopTip)
end
function mainCityView:getTopTipOnTouch(touchPoint)
	for k, v in pairs(self.currentTopTipArray) do
		local nodeTopTip = v
		local isTouchPointOnTopTip = self:getIsTouchPointInTopTipNode(touchPoint, nodeTopTip)
		if isTouchPointOnTopTip then
			return nodeTopTip
		end
	end
	return nil
end
function mainCityView:addHarvestFloating(target, data)
	mainCityMsg.addHarvestFloating(self, target, data)
end
function mainCityView:addResCollectAnimation(resId, buildIndex, buildEntity, numOfRes)
	mainCityFunctions.addResCollectAnimation(self, resId, buildIndex, buildEntity, numOfRes)
end
function mainCityView:buildQueueCallback(target, data)
	mainCityMsg.buildQueueCallback(self, target, data)
end
function mainCityView:demolishBuild(target, data)
	mainCityMsg.demolishBuild(self, target, data)
end
function mainCityView:cancelDemolishBuild(target, data)
	mainCityMsg.demolishBuild(self, target, data)
end
function mainCityView:cancelUpgradeBuild(target, data)
	mainCityMsg.cancelDemolishBuild(self, target, data)
end
function mainCityView:addToBufferNodeArrayByName(nodeName, nodeObj)
	if nodeName == nil or nodeObj == nil then
		return
	end
	self.bufferNodeArray[nodeName] = nodeObj
end
function mainCityView:getBufferNodeByName(nodeName)
	if nodeName == nil then
		return
	end
	local nodeObj = self.bufferNodeArray[nodeName]
	if nodeObj ~= nil then
		return nodeObj
	else
		return nil
	end
end
function mainCityView:getBufferNodeIndex(buildIndex)
	local exName = "topTip_" .. buildIndex
	for k, v in pairs(self.bufferNodeArray) do
		if string.find(k, exName) then
			return true
		end
	end
	return false
end
function mainCityView:delBufferNodeByName(nodeName)
	if self.bufferNodeArray[nodeName] ~= nil then
		self.bufferNodeArray[nodeName] = nil
	end
end
function mainCityView:addToTableIfNotExist(valueTable, value)
	mainCityFunctions.addToTableIfNotExist(self, valueTable, value)
end
function mainCityView:getCanBuildIndexByBid(bid)
	return mainCityFunctions.getCanBuildIndexByBid(self, bid)
end
function mainCityView:addBuildPreview(target, data)
	mainCityMsg.addBuildPreview(self, target, data)
end
function mainCityView:removeBuildPreview(target, data)
	mainCityMsg.removeBuildPreview(self, target, data)
end
function mainCityView:showHarvestArmyResult(target, data)
	mainCityMsg.showHarvestArmyResult(self, target, data)
end
function mainCityView:buildBtnEvent(target, data)
	mainCityMsg.buildBtnEvent(self, target, data)
end
function mainCityView:loadSoldiers()
	print("-------------------- device.platform = ", device.platform)
	if device.platform == "mac" then
		mainCityFunctions.loadSoldiers(self)
	elseif xpcall(function()
		mainCityFunctions.loadSoldiers(self)
	end, function()
		print(debug.traceback())
	end) then
	else
		print("mainCityView:loadSoldiers 异常了，请处理-------@hlp")
	end
end
function mainCityView:armyQueueCallback(target, data)
	mainCityMsg.armyQueueCallback(self, target, data)
end
function mainCityView:getLastSoldierMatrixPosArrayByBid(bid)
	if self.cityBuildSoldiersMatrixNode == nil then
		_ENV = self.cityBuildSoldiersMatrixNode
		self.cityBuildSoldiersMatrixNode[1] = cc.p(0, 0)
		self.cityBuildSoldiersMatrixNode[2] = cc.p(0, 0)
		self.cityBuildSoldiersMatrixNode[3] = cc.p(0, 0)
		self.cityBuildSoldiersMatrixNode[4] = cc.p(0, 0)
		self.cityBuildSoldiersMatrixNode[5] = cc.p(0, 0)
		self.cityBuildSoldiersMatrixNode[6] = cc.p(0, 0)
		self.cityBuildSoldiersMatrixNode[7] = cc.p(0, 0)
		self.cityBuildSoldiersMatrixNode[8] = cc.p(0, 0)
		self.cityBuildSoldiersMatrixNode[9] = cc.p(0, 0)
		self.cityBuildSoldiersMatrixNode[10] = cc.p(0, 0)
		self.cityBuildSoldiersMatrixNode[11] = cc.p(0, 0)
		self.cityBuildSoldiersMatrixNode[12] = cc.p(0, 0)
		self.cityBuildSoldiersMatrixNode[13] = cc.p(0, 0)
		return self.cityBuildSoldiersMatrixNode
	end
	local _ENV, retPosArray = self.cityBuildSoldiersMatrixNode, self.cityBuildSoldiersMatrixNode
	local targetNode
	if bid == BUILDID.ELITE_PALACE then
		targetNode = self.cityBuildEliteMatrixNode
	else
		targetNode = self.cityBuildSoldiersMatrixNode
	end
	retPosArray = targetNode:getLastSoldierMatrixPosArrayByBid(bid)
	local _ENV, posArray = targetNode:getLastSoldierMatrixPosArrayByBid(bid), targetNode:getLastSoldierMatrixPosArrayByBid(bid)
	for i, v in ipairs(retPosArray) do
		local worldPos = targetNode.cityBuildTroopsMatrixNode.graphNode:convertToWorldSpace(v)
		local nodePos = self.containerView:convertToNodeSpace(worldPos)
		nodePos.z = 15
		table.insert(posArray, #posArray + 1, nodePos)
	end
	return posArray
end
function mainCityView:updateSoldierMatrixs(target, data)
	local bid = data.bid
	local targetNode
	if bid == BUILDID.ELITE_PALACE then
		targetNode = self.cityBuildEliteMatrixNode
	else
		targetNode = self.cityBuildSoldiersMatrixNode
	end
	if not targetNode then
		return
	end
	if device.platform == "mac" then
		targetNode:updateMatrixs()
	elseif xpcall(function()
		targetNode:updateMatrixs()
	end, function()
		print(debug.traceback())
	end) then
	else
		print("mainCityView:updateSoldierMatrixs 异常了，请处理-------@hlp")
	end
end
function mainCityView:otherBuildButtonCallFun(build, ref, type)
	mainCityHandler.otherBuildButtonCallFun(self, build, ref, type)
end
function mainCityView:addMatouTip(target, data)
	mainCityMsg.addMatouTip(self, target, data)
end
function mainCityView:removeMatouTip(target, data)
	mainCityMsg.removeMatouTip(self, target, data)
end
function mainCityView:msgUnLockArea(target, data)
	mainCityMsg.msgUnLockArea(self, target, data)
end
function mainCityView:msgUpdateLockArea(target, data)
	mainCityMsg.msgUpdateLockArea(self, target, data)
end
function mainCityView:updateLockTurret()
	mainCityFunctions.updateLockTurret(self)
end
function mainCityView:msgUpdateLockTurret(target, data)
	self:updateLockTurret()
end
function mainCityView:msgUpdateAllianceHelpList(target, data)
	mainCityMsg.msgUpdateAllianceHelpList(self, target, data)
end
function mainCityView:addBuildAnimBoostBottom(buildIndex)
	effectMainCityView.addBuildAnimBoostBottom(self, buildIndex)
end
function mainCityView:addBuildAnimBoost(target, data)
	mainCityMsg.addBuildAnimBoost(self, target, data)
end
function mainCityView:removeBuildAnimBoost(target, data)
	mainCityMsg.removeBuildAnimBoost(self, target, data)
end
function mainCityView:autoUpdateMainCityPos()
	local actDelay = cca.delay(0.3)
	local callFunc = cca.callFunc(handler(self, self.delayUpdateMainCityPos))
	_UPVALUE2_ = handler(self, self.delayUpdateMainCityPos)
	handler(self, self.delayUpdateMainCityPos)[1] = actDelay
	handler(self, self.delayUpdateMainCityPos)[2] = callFunc
	local seq = cca.seq(handler(self, self.delayUpdateMainCityPos))
	self:runAction(seq)
end
function mainCityView:autoUpdateViewScrollViewPos(delay)
	self.viewScrollView:stopAllActions()
	local delayTime = delay or self.initZoomScaleDuration
	local actionScaleToV = cca.scaleTo(0, self.normlScrollViewScale)
	local viewScrollViewSize = cc.size(self:getContentSize().width, self:getContentSize().height - (self.hUITop + self.hUIBottom + display.iPhoneXOffset))
	local targetY = self.hUIBottom + display.iPhoneXBottom + viewScrollViewSize.height / 2
	local actionMoveTo = cca.moveTo(0, display.width / 2, targetY)
	self.viewScrollView:runAction(actionScaleToV)
	self.viewScrollView:runAction(actionMoveTo)
end
function mainCityView:delayUpdateMainCityPos()
	mainCityFunctions.delayUpdateMainCityPos(self)
end
function mainCityView:getContainerOffsetWhenCenterTarget(target, force)
	return self:getContainerOffsetWhenPosTarget(target, cc.p(display.width / 2, display.height / 2), false, force)
end
function mainCityView:getContainerOffsetWhenPosTarget(target, winPos, ignoreCheck, force)
	local targetPos = cc.p(target:getPositionX(), target:getPositionY())
	local contentSize = target:getContentSize()
	local targetAp = target:getAnchorPoint()
	local centerX = targetPos.x + (0.5 - targetAp.x) * contentSize.width
	local centerY = targetPos.y + (0.5 - targetAp.y) * contentSize.height
	local centerPos = cc.p(centerX, centerY)
	return self:getContainerOffsetWhenPosPoint(centerPos, winPos, ignoreCheck, force)
end
function mainCityView:getContainerOffsetWhenPosPoint(centerPos, winPos, ignoreCheck, force, zoomScale)
	winPos.y = winPos.y - self.hUIBottom - display.iPhoneXBottom
	local zoomScale = zoomScale and zoomScale or self:getZoomScale(force)
	centerPos.x = centerPos.x * zoomScale
	centerPos.y = centerPos.y * zoomScale
	local deltaOffsetX = winPos.x
	local deltaOffsetY = winPos.y
	local offsetX = -(centerPos.x - deltaOffsetX)
	local offsetY = -(centerPos.y - deltaOffsetY)
	local minOffset = self.viewScrollView:minContainerOffset()
	local maxOffset = self.viewScrollView:maxContainerOffset()
	local realZoomScale = self:getZoomScale(true)
	local viewW = self.viewScrollView:getViewSize().width
	minOffset.x = (minOffset.x - viewW) * zoomScale / realZoomScale + viewW
	minOffset.y = minOffset.y * zoomScale / realZoomScale
	maxOffset = cc.pMul(maxOffset, zoomScale / realZoomScale)
	if ignoreCheck == nil or false == ignoreCheck then
		offsetX = math.max(minOffset.x, math.min(maxOffset.x, offsetX))
		offsetY = math.max(minOffset.y, math.min(maxOffset.y, offsetY))
	end
	return cc.p(offsetX, offsetY)
end
function mainCityView:getZoomScale(force)
	if self.zoomScale == nil then
		self.zoomScale = self.viewScrollView:getZoomScale()
	elseif force then
		self.zoomScale = self.viewScrollView:getZoomScale()
	end
	return self.zoomScale
end
function mainCityView:runContainerViewMove(moveToPos, duration)
	local scrollPane = self.viewScrollView:getScrollPane()
	scrollPane:stopAllActionsByTag(cityBuildConstDef.ActionTag.Tag_ContainerViewMove)
	if duration == nil or duration == 0 then
		self.viewScrollView:getScrollPane():setPosition(moveToPos)
	else
		local moveTo = cca.moveTo(duration, moveToPos)
		moveTo:setTag(cityBuildConstDef.ActionTag.Tag_ContainerViewMove)
		scrollPane:runAction(moveTo)
	end
end
function mainCityView:setZoomScale(zoomScale, animated, duration, customAnim)
	self.zoomScale = zoomScale
	local scrollPane = self.viewScrollView:getScrollPane()
	scrollPane:stopAllActionsByTag(cityBuildConstDef.ActionTag.Tag_ContainerViewScale)
	if customAnim ~= nil then
		if duration == nil or duration == 0 then
			scrollPane:setScale(zoomScale)
		else
			local actScaleTo = cca.scaleTo(duration, zoomScale)
			local callFunc = cca.callFunc(handler(self, self.afterCustomAnim))
			_UPVALUE2_ = handler(self, self.afterCustomAnim)
			handler(self, self.afterCustomAnim)[1] = actScaleTo
			handler(self, self.afterCustomAnim)[2] = callFunc
			local seq = cca.seq(handler(self, self.afterCustomAnim))
			seq:setTag(cityBuildConstDef.ActionTag.Tag_ContainerViewScale)
			scrollPane:runAction(seq)
		end
		return
	end
	if duration == nil then
		self.viewScrollView:setZoomScale(zoomScale, animated)
	elseif duration ~= nil then
		self.viewScrollView:setZoomScaleInDuration(zoomScale, duration)
	end
	cityBuildConstDef = self.viewScrollView
	self.viewScrollView.msg = "MESSAGE_MAINCITYVIEW_SCALE_CHANGE"
	self.viewScrollView.scale = self.viewScrollView:getZoomScale()
	SoraDSendMessage(self.viewScrollView)
end
function mainCityView:afterCustomAnim()
end
function mainCityView:getHarbourPosOffset()
	local retPos = self:getContainerOffsetWhenCenterTarget(self.btnHuoChuang)
	return retPos
end
function mainCityView:getLeisureCenterPosOffset()
	local retPos = self:getContainerOffsetWhenCenterTarget(self.buttonLeisureCenter)
	return retPos
end
function mainCityView:getMatouPosOffset()
	local retPos = self:getContainerOffsetWhenCenterTarget(self.buttonMaTou)
	return retPos
end
function mainCityView:getLegendMonumentOffset()
	local retPos = self:getContainerOffsetWhenCenterTarget(self.buttonMonument)
	return retPos
end
function mainCityView:getCastlePosOffset()
	local Button_Chengbao = self:getBufferNodeByName("build_1050")
	local retPos = self:getContainerOffsetWhenCenterTarget(Button_Chengbao)
	local zoomScale = self:getZoomScale(true)
	retPos.y = retPos.y + 200 * zoomScale
	return retPos
end
function mainCityView:getDefaultMainCityPos()
	local Button_Chengbao = self:getBufferNodeByName("build_1050")
	local posX = Button_Chengbao:getPositionX()
	local posY = Button_Chengbao:getPositionY() + 500
	local retPos = self:getContainerOffsetWhenPosPoint(cc.p(posX, posY), cc.p(display.width / 2, display.height / 2), false, true)
	local zoomScale = self:getZoomScale(true)
	retPos.x = retPos.x - 200 * zoomScale
	retPos.y = retPos.y
	return retPos
end
function mainCityView:getDefaultMainCityMantouPos()
	local posX = self.buttonMaTou:getPositionX()
	local posY = self.buttonMaTou:getPositionY() + 500
	local retPos = self:getContainerOffsetWhenPosPoint(cc.p(posX, posY), cc.p(display.width / 2, display.height / 2), false, true)
	local zoomScale = self:getZoomScale(true)
	retPos.x = retPos.x + 800 * zoomScale
	retPos.y = retPos.y
	return retPos
end
function mainCityView:getDefaultMainCityHuochuangPos()
	local posX = self.btnHuoChuang:getPositionX()
	local posY = self.btnHuoChuang:getPositionY() + 500
	local retPos = self:getContainerOffsetWhenPosPoint(cc.p(posX, posY), cc.p(display.width / 2, display.height / 2), false, true)
	local zoomScale = self:getZoomScale(true)
	retPos.x = retPos.x + 800 * zoomScale
	retPos.y = retPos.y
	return retPos
end
function mainCityView:msgSaveMainCityPos(target, data)
	local currentMainCityPos = self.viewScrollView:getContentOffset()
	local viewScale = self:getZoomScale(true)
	cityBuildFunction:setCurrentMainCityPos(currentMainCityPos, viewScale)
end
function mainCityView:getAnimDuration(currentOffset, targetOffset, autoMoveSpeed)
	local autoMoveSpeed = autoMoveSpeed or self.autoMoveSpeed
	local duration = 0
	local distance = cc.pGetDistance(currentOffset, targetOffset)
	duration = distance / autoMoveSpeed
	return duration
end
function mainCityView:updatePeriod()
	local isDealed = false
	if not isDealed and not self.isCfgNightOn then
		self.currentDayPeriod = gDay.DAY_TIME
		self:enterDayPeriod(self.currentDayPeriod)
		isDealed = true
	end
	if not isDealed then
		local currentDayPeriod = SoraDGetDayPeriod()
		if self.currentDayPeriod ~= currentDayPeriod then
			self.currentDayPeriod = currentDayPeriod
			self:enterDayPeriod(self.currentDayPeriod)
		end
	end
	if self.timerHandlerPeriod then
		SoraDManagerRemoveTimer(self, self.timerHandlerPeriod)
		self.timerHandlerPeriod = nil
	end
	local delay = mainCityFunctions:getNextPeroidDelay()
	self.timerHandlerPeriod = SoraDCreateDelayTimer(self, handler(self, self.updatePeriod), delay)
end
function mainCityView:updateDarkOpacity()
	effectMainCityView.updateDarkOpacity(self)
end
function mainCityView:updateTimePerFrame(time)
	if not self.frameCount then
		self.frameCount = 1
	end
	if self.frameCount < 3 then
		self.frameCount = self.frameCount + 1
		return
	end
	self.frameCount = 1
	if self.isVisibleAreaDirty then
		self:moveVisible()
		self.isVisibleAreaDirty = false
	end
end
function mainCityView:updateTime(time)
	if self.isNeedFirstFight == true then
		return
	end
	if self.tipBoxCount >= self.tipBoxMaxCount then
		_ENV = self.tipBoxMaxCount
		self.tipBoxMaxCount.msg = "MESSAGE_MAINCITYVIEW_UPDATE_BUILD_TIP_BOX"
		SoraDSendMessage(self.tipBoxMaxCount)
		_ENV = self.tipBoxMaxCount
		self.tipBoxMaxCount.msg = "MESSAGE_MAINCITYVIEW_SHOW_COMMUNITYCENTER_MSG"
		SoraDSendMessage(self.tipBoxMaxCount)
		self.tipBoxCount = 1
	else
		self.tipBoxCount = self.tipBoxCount + 1
	end
	if self.soldierBoxCount >= self.soldierBoxMaxCount then
		_ENV = self.soldierBoxMaxCount
		self.soldierBoxMaxCount.msg = "MESSAGE_MAINCITYVIEW_UPDATE_GUARD_SOLDIER_BOX"
		SoraDSendMessage(self.soldierBoxMaxCount)
		self.soldierBoxCount = 1
	else
		self.soldierBoxCount = self.soldierBoxCount + 1
		if self.isSoldierBoxCountOffset and self.soldierBoxCount == self.soldierBoxCountOffset then
			self.soldierBoxCount = 1
			self.isSoldierBoxCountOffset = false
		end
	end
	if self.merchantBoxCount >= self.merchantBoxMaxCount then
		_ENV = self.merchantBoxMaxCount
		self.merchantBoxMaxCount.msg = "MESSAGE_MAINCITYVIEW_UPDATE_MERCHANT_VIEW"
		SoraDSendMessage(self.merchantBoxMaxCount)
		self.merchantBoxCount = 1
	else
		self.merchantBoxCount = self.merchantBoxCount + 1
	end
	if self.conquerBoxCount >= self.conquerBoxMaxCount then
		self.hasConquerGateMsg = false
		_ENV = self.conquerBoxMaxCount
		self.conquerBoxMaxCount.msg = "MESSAGE_MAINCITYVIEW_UPDATE_BUILD_TIP_BOX"
		SoraDSendMessage(self.conquerBoxMaxCount)
		self.conquerBoxCount = 1
	else
		self.conquerBoxCount = self.conquerBoxCount + 1
	end
	if self.petBoxCount >= self.petBoxMaxCount then
		_ENV = self.petBoxMaxCount
		self.petBoxMaxCount.msg = "MESSAGE_MAINCITYVIEW_UPDATE_PET_TIP_BOX"
		SoraDSendMessage(self.petBoxMaxCount)
		self.petBoxCount = 1
	else
		self.petBoxCount = self.petBoxCount + 1
	end
end
function mainCityView:getIsTouchOnTarget(touchPoint, target)
	local bRet = false
	if target == nil then
		return bRet
	end
	local btn = target
	local parent = btn:getParent()
	local boundingBox = btn:getBoundingBox()
	local btnPosBL = cc.p(boundingBox.x, boundingBox.y)
	local posTouchToNode = parent:convertToNodeSpace(touchPoint)
	if cc.rectContainsPoint(boundingBox, posTouchToNode) then
		bRet = true
	end
	return bRet
end
function mainCityView:updateBuildTiles()
	for i = 1100, 1114 do
		local buildBtnName = "build_" .. i
		local buildBtn = self:getBufferNodeByName(buildBtnName)
		self:updateBuildTile(buildBtn)
	end
end
function mainCityView:updateBuildTile(buildBtn)
	local buildName = "buildName"
	local buildEntity = buildBtn:getChildByName(buildName)
	if buildEntity == nil then
		self:addBuildTile(buildBtn)
	else
		self:delBuildTile(buildBtn)
	end
end
function mainCityView:addBuildTile(buildBtn)
	local buildIndex = buildBtn:getTag()
	local buildType = SoraDGetBuildTypeByIndex(buildIndex)
	if 0 == buildType then
		return
	end
	local sprite = self.batchNodeOuterTiles:getChildByName("res_tile" .. buildIndex)
	if sprite then
		return
	end
	local spriteName = "#" .. "res_tile.png"
	local sprite = display.newSprite(spriteName)
	if buildBtn then
		sprite:setAnchorPoint(cc.p(0.5, 0.5))
		sprite:setName("res_tile" .. buildIndex)
		local targetPos = cc.p(buildBtn:getPositionX(), buildBtn:getPositionY())
		sprite:setPosition(targetPos)
		self.batchNodeOuterTiles:addChild(sprite)
	end
end
function mainCityView:delBuildTile(buildBtn)
	local buildIndex = buildBtn:getTag()
	local buildType
	if 0 == buildType then
		return
	end
	if buildBtn then
		local sprite = self.batchNodeOuterTiles:getChildByName("res_tile" .. buildIndex)
		if sprite then
			sprite:removeFromParent()
		end
	end
end
function mainCityView:onOtherTopTipCallBack(btnTopTip, ref, event)
	mainCityHandler.onOtherTopTipCallBack(self, btnTopTip, ref, event)
end
function mainCityView:onNpcTopTipCallBack(btnTopTip, ref, event)
	mainCityHandler.onNpcTopTipCallBack(self, btnTopTip, ref, event)
end
function mainCityView:msgAddBuildEffect(target, data)
	local buildIndex = data.buildIndex
	self:addBuildEffect(buildIndex)
end
function mainCityView:msgRemoveBuildEffect(target, data)
	local buildIndex = data.buildIndex
	self:removeBuildEffect(buildIndex)
end
function mainCityView:addBuildEffect(buildIndex)
	if buildIndex == cityBuildConstDef.OtherBuildDef.HuoChuang then
		self:addHuoChuanEffect()
	elseif buildIndex == cityBuildConstDef.OtherBuildDef.Gangkou then
		self:addMatouEffect()
	elseif buildIndex == cityBuildConstDef.OtherBuildDef.ActivityCenter then
		effectMainCityView.addEffectActivityCenter(self)
	elseif buildIndex == cityBuildConstDef.OtherBuildDef.Wall then
		self:addEffectWall()
	elseif buildIndex == cityBuildConstDef.OtherBuildDef.CommunityCenter then
		self:addEffectCommunityCenter()
	end
end
function mainCityView:addBuildTipBox(buildIndex)
	if buildIndex == cityBuildConstDef.OtherBuildDef.CommunityCenter then
		self:addBuildTipBoxCommunityCenter()
	elseif buildIndex == cityBuildConstDef.OtherBuildDef.ActivityCenter then
		self:addBuildTipBoxActivityCenter()
	elseif buildIndex == cityBuildConstDef.OtherBuildDef.ConquerGate then
		self:addBuildTipBoxConquerGate()
	elseif buildIndex == cityBuildConstDef.fixedBuildDef.LeisureCenter then
		effectMainCityView.addBuildTipBoxLeisureCenter(self, buildIndex)
	else
		local buildBtnName = "build_" .. buildIndex
		local buildBtn = self:getBufferNodeByName(buildBtnName)
		if nil == buildBtn then
			return
		end
		local cityBuild = buildBtn:getChildByName("buildName")
		if cityBuild then
			local bid = cityBuild:getBuildBid()
			if bid == BUILDID.WISHING_WELL then
				self:addBuildTipBoxWishingWell(buildIndex)
			end
		end
	end
end
function mainCityView:addBuildTipBoxWishingWell(buildIndex)
	effectMainCityView.addBuildTipBoxWishingWell(self, buildIndex)
end
function mainCityView:addBuildTipBoxConquerGate()
	effectMainCityView.addBuildTipBoxConquerGate(self)
end
function mainCityView:addBuildTipBoxActivityCenter()
	effectMainCityView.addBuildTipBoxActivityCenter(self)
end
function mainCityView:addBuildTipBoxCommunityCenter()
	effectMainCityView.addBuildTipBoxCommunityCenter(self)
end
function mainCityView:removeBuildEffect(buildIndex)
	if buildIndex == cityBuildConstDef.OtherBuildDef.HuoChuang then
		self:removeHuoChuanEffect()
	elseif buildIndex == cityBuildConstDef.OtherBuildDef.Gangkou then
		self:removeMatouEffect()
	elseif buildIndex == cityBuildConstDef.OtherBuildDef.ActivityCenter then
		self:removeEffectActivityCenter()
	elseif buildIndex == cityBuildConstDef.OtherBuildDef.Wall then
		self:removeEffectWall()
	end
end
function mainCityView:addEffectWall()
	effectMainCityView.addEffectWall(self)
end
function mainCityView:removeEffectWall()
	effectMainCityView.removeEffectWall(self)
end
function mainCityView:addHuoChuanEffect()
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_NORMAL then
		effectMainCityView.addHuoChuanEffect(self)
	end
end
function mainCityView:removeHuoChuanEffect()
	effectMainCityView.removeHuoChuanEffect(self)
end
function mainCityView:addBuildTopTipHuochuang()
	effectMainCityView.addBuildTopTipHuochuang(self)
end
function mainCityView:addMatouEffect()
	effectMainCityView.addMatouEffect(self)
end
function mainCityView:removeMatouEffect()
	effectMainCityView.removeMatouEffect(self)
end
function mainCityView:msgAddBuildEffectUpgrade(target, data)
	mainCityMsg.msgAddBuildEffectUpgrade(self, target, data)
end
function mainCityView:showEffectUpgrade2(buildPos, posEtUpgradeOffset, zOrder)
	effectMainCityView.showEffectUpgrade2(self, buildPos, posEtUpgradeOffset, zOrder)
end
function mainCityView:removeEffectActivityCenter()
	effectMainCityView.removeEffectActivityCenter(self)
end
function mainCityView:msgUpdateWallView(target, data)
	self:updateWallViewModel()
end
function mainCityView:updateWallViewModel()
	effectMainCityView.updateWallViewModel(self)
end
function mainCityView:msgUpdateWallEffect(target, data)
	self:updateWallEffect()
end
function mainCityView:updateWallEffect()
	if wallsCtrl:isDamage() or wallsCtrl:isDestruction() then
		wallsCtrl = wallsCtrl
		wallsCtrl.msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_EFFECT"
		wallsCtrl.buildIndex = cityBuildConstDef.OtherBuildDef.Wall
		SoraDSendMessage(wallsCtrl)
	else
		wallsCtrl = wallsCtrl
		wallsCtrl.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_EFFECT"
		wallsCtrl.buildIndex = cityBuildConstDef.OtherBuildDef.Wall
		SoraDSendMessage(wallsCtrl)
	end
end
function mainCityView:onTipBoxCall(tag, jumpData)
	mainCityHandler.onTipBoxCall(self, tag, jumpData)
end
function mainCityView:gotoLockArea(delay)
	mainCityFunctions.gotoLockArea(self, delay)
end
function mainCityView:gotoOuterCity(needRecover)
	local offset = self:getContainerOffsetWhenPosPoint(self:getDefaultOuterCityPos(), cc.p(display.width / 2, display.height / 2), false, true)
	local currentOffset = self.viewScrollView:getContentOffset()
	local duration = self:getAnimDuration(currentOffset, offset)
	if needRecover then
		self:disableMoveForDuration(duration)
	end
	self.viewScrollView:setContentOffsetInDuration(offset, duration)
end
function mainCityView:gotoInnerCity(needRecover)
	local offset = self:getCastlePosOffset()
	local currentOffset = self.viewScrollView:getContentOffset()
	local duration = self:getAnimDuration(currentOffset, offset)
	if needRecover then
		self:disableMoveForDuration(duration)
	end
	self.viewScrollView:setContentOffsetInDuration(offset, duration)
end
function mainCityView:getDefaultOuterCityPos()
	return cc.p(5342, 1735)
end
function mainCityView:sMsgCancelTechnology(target, data)
	mainCityMsg.sMsgCancelTechnology(self, target, data)
end
function mainCityView:addTouchParticle(touchPos)
	effectMainCityView.addTouchParticle(self, touchPos)
end
function mainCityView:getBuildBtnByIndex(buildIndex)
	local buildBtn
	if buildIndex == cityBuildConstDef.OtherBuildDef.ActivityCenter then
		buildBtn = self:getBufferNodeByName("Button_Activity")
	elseif buildIndex == cityBuildConstDef.buildIndexDef.index_Gangkou then
		buildBtn = self.buttonMaTou
	elseif buildIndex == cityBuildConstDef.buildIndexDef.index_Merchant then
		buildBtn = self.buttonMerchante
	elseif buildIndex == cityBuildConstDef.buildIndexDef.index_TroopFlag then
		buildBtn = self.buttonMilitaryInfo
	elseif buildIndex >= cityBuildConstDef.buildIndexDef.index_lock_area_1 and buildIndex <= cityBuildConstDef.buildIndexDef.index_lock_area_4 then
		local buildBtnName = "Panel_Area_Lock_" .. buildIndex
		local panelLockArea = self:getBufferNodeByName(buildBtnName)
		local buildLockArea = SoraDGetChildByName(panelLockArea, "buildName")
		buildBtn = buildLockArea and buildLockArea:getLockAreaBtn() or nil
	else
		local buildBtnName = "build_" .. buildIndex
		buildBtn = self:getBufferNodeByName(buildBtnName)
	end
	return buildBtn
end
function mainCityView:getBuildByIndex(buildIndex)
	local buildBtn = self:getBuildBtnByIndex(buildIndex)
	if buildBtn then
		local cityBuild = buildBtn:getChildByName("buildName")
		return cityBuild
	end
end
function mainCityView:getAllResBuildBtn()
	local _ENV, buildBtns
	local buildBtnsFarm = self:getAllBuildBtnByBid(BUILDID.FARM)
	local buildBtnsSawmill = self:getAllBuildBtnByBid(BUILDID.SAWMILL)
	local buildBtnsIronMine = self:getAllBuildBtnByBid(BUILDID.IRON_MINE)
	local buildBtnsSteel = self:getAllBuildBtnByBid(BUILDID.STEEL)
	local buildBtnsCrystal = self:getAllBuildBtnByBid(BUILDID.CRYSTAL_MINE)
	_UPVALUE5_ = BUILDID.CRYSTAL_MINE
	BUILDID.CRYSTAL_MINE[1] = buildBtnsFarm
	BUILDID.CRYSTAL_MINE[2] = buildBtnsSawmill
	BUILDID.CRYSTAL_MINE[3] = buildBtnsIronMine
	BUILDID.CRYSTAL_MINE[4] = buildBtnsSteel
	BUILDID.CRYSTAL_MINE[5] = buildBtnsCrystal
	for i, v in ipairs(BUILDID.CRYSTAL_MINE) do
		if 0 < #v then
			for j, k in ipairs(v) do
				table.insert(buildBtns, #buildBtns + 1, k)
			end
		end
	end
	return buildBtns
end
function mainCityView:getAllBuildBtnByBid(bid)
	local cityCtrl, buildBtns
	local buildlist = cityCtrl:getBuildList()
	if buildlist == nil then
		return
	end
	for k, buildcell in pairs(buildlist) do
		if tonumber(buildcell.info.bid) == bid then
			local index = tonumber(buildcell.info.index)
			local cellIndexName = "build_" .. index
			local buildBtn = self:getBufferNodeByName(cellIndexName)
			local buildEntity = self:getBuildByIndex(index)
			if buildBtn then
				_UPVALUE4_ = nil
				;(nil)[1] = bid
				;(nil)[2] = buildBtn
				;(nil)[3] = buildEntity
				;(nil)[4] = index
				table.insert(buildBtns, #buildBtns + 1, nil)
			end
		end
	end
	return buildBtns
end
function mainCityView:gotoBuild(target, data)
	dump(data, "mainCityView:gotoBuild")
	local buildIndex = data.buildIndex
	local buildBtn = data.buildBtn
	local buildID = data.buildID
	local iid = data.iid
	local delay = data.delay
	local needRecover = data.needRecover
	if needRecover == nil then
		needRecover = true
	end
	local isSelected = data.isSelected
	local isShowHand = data.isShowHand
	local isStep = data.isStep
	if buildIndex and buildIndex >= cityBuildConstDef.buildIndexDef.index_lock_area_1 and buildIndex <= cityBuildConstDef.buildIndexDef.index_lock_area_4 then
		print("跳转到解锁区域------:", buildIndex)
		mainCityFunctions.gotoLockAreaByIndex(self, buildIndex, delay, isShowHand)
		return
	end
	if buildIndex then
		buildBtn = self:getBuildBtnByIndex(buildIndex)
	elseif buildID then
		buildBtn = self:getBuildBtnByIndex(self:getBuildIndexByBid(buildID, iid))
	end
	if buildBtn == nil then
		return
	end
	self:stopScrollContainer()
	local zoomScale = self:getZoomScale()
	if SoraDIsGameGuide() ~= nil then
		zoomScale = self:getZoomScale(true)
	end
	if self.defaultScale == zoomScale then
	else
		self:setZoomScale(self.defaultScale, false)
	end
	local offset = self:getContainerOffsetWhenCenterTarget(buildBtn)
	if isStep then
		local zoomScale = self.viewScrollView:getZoomScale()
		if zoomScale ~= 0 then
			offset = cc.p(-buildBtn:getPositionX() * zoomScale + display.cx, -buildBtn:getPositionY() * zoomScale + display.cy - self.hUIBottom)
			if 0 <= offset.x then
				offset.x = 0
			elseif offset.x < -(self.containerView:getContentSize().width * zoomScale - display.width) then
				offset.x = -(self.containerView:getContentSize().width * zoomScale - display.width)
			end
			if 0 <= offset.y then
				offset.y = 0
			elseif offset.y < -(self.containerView:getContentSize().height * zoomScale - display.height + self.hUITop + self.hUIBottom) then
				offset.y = -(self.containerView:getContentSize().height * zoomScale - display.height + self.hUITop + self.hUIBottom)
			end
		end
	end
	local currentOffset = self.viewScrollView:getContentOffset()
	local duration = delay or self:getAnimDuration(currentOffset, offset, self.autoMoveSpeedSlow)
	if needRecover then
		self:disableMoveForDuration(duration)
	end
	local scrollPane = self.viewScrollView:getScrollPane()
	scrollPane:stopAllActionsByTag(cityBuildConstDef.ActionTag.Tag_ContainerViewMove)
	self.viewScrollView:setContentOffsetInDuration(offset, duration)
	if isSelected then
		cityBuildConstDef = self.viewScrollView.setContentOffsetInDuration
		self.viewScrollView.setContentOffsetInDuration[1] = cca.delay(duration)
		self.viewScrollView.setContentOffsetInDuration[2] = cca.callFunc(function()
			self:buildButtonCallFun(buildBtn, buildBtn, ccui.TouchEventType.ended, true, buildID)
		end)
		self.viewScrollView.setContentOffsetInDuration[3] = cca.callFunc(function()
			self:buildButtonCallFun(buildBtn, buildBtn, ccui.TouchEventType.ended, true, buildID)
		end)
		self.viewScrollView.setContentOffsetInDuration[4] = cca.callFunc(function()
			self:buildButtonCallFun(buildBtn, buildBtn, ccui.TouchEventType.ended, true, buildID)
		end)
		local self.viewScrollView.setContentOffsetInDuration[5], seqs = cca.callFunc(function()
			self:buildButtonCallFun(buildBtn, buildBtn, ccui.TouchEventType.ended, true, buildID)
		end)
		if isShowHand then
			table.insert(seqs, #seqs + 1, cca.callFunc(function()
				_ENV = nil
				;(nil).msg = "MESSAGE_SHOW_BUILD_TIP_BUTTON_HAND"
				;(nil).btnName = "OpResuscitate"
				;(nil).delay = 0.3
				SoraDSendMessage(nil)
			end))
		end
		self.viewScrollView:runAction(cca.seq(seqs))
	end
end
function mainCityView:getBuildBtnByBid(bid)
	local buildlist = cityCtrl:getBuildList()
	if buildlist == nil then
		return
	end
	for k, buildcell in pairs(buildlist) do
		if tonumber(buildcell.info.bid) == bid then
			local index = tonumber(buildcell.info.index)
			local cellIndexName = "build_" .. index
			local buildBtn = self:getBufferNodeByName(cellIndexName)
			return buildBtn
		end
	end
end
function mainCityView:getBuildIndexByBid(bid, iid)
	local buildlist = cityCtrl:getBuildList()
	if buildlist == nil then
		return
	end
	for k, buildcell in pairs(buildlist) do
		if iid ~= nil then
			if tonumber(buildcell.info.bid) == bid and iid == tonumber(buildcell.info.iid) then
				local index = tonumber(buildcell.info.index)
				return index
			end
		elseif tonumber(buildcell.info.bid) == bid then
			local index = tonumber(buildcell.info.index)
			return index
		end
	end
	return bid
end
function mainCityView:getBuildTipTop(bid, iid)
	local buildIndex = self:getBuildIndexByBid(bid, iid)
	local buildTopTipName = "build_topTip_" .. buildIndex
	local buildTopTipNode = self:getBufferNodeByName(buildTopTipName)
	return buildTopTipNode
end
function mainCityView:moveCameraTo(targetPos, delay, zoomScale)
	local duration = delay
	local zoomScale = zoomScale or self.defaultScale
	local offset = self:getContainerOffsetWhenPosPoint(targetPos, cc.p(display.width / 2, display.height / 2), false)
	local currentOffset = self.viewScrollView:getContentOffset()
	duration = duration or self:getAnimDuration(currentOffset, offset, self.autoMoveSpeedSlow)
	self:disableMoveForDuration(duration)
	self.viewScrollView:setContentOffsetInDuration(offset, duration)
	self:setZoomScale(zoomScale, true, duration)
end
function mainCityView:msgMoveCameraTo(target, data)
	local delay = data.delay
	local targetPos = data.targetPos
	local zoomScale = data.zoomScale
	self:moveCameraTo(targetPos, delay, zoomScale)
end
function mainCityView:getIsOuterBuildUnLocked(buildIndex)
	return mainCityFunctions.getIsOuterBuildUnLocked(self, buildIndex)
end
function mainCityView:addEffectCommunityCenter()
end
function mainCityView:msgAddBuildTipBox(target, data)
	local buildIndex = data.buildIndex
	self:addBuildTipBox(buildIndex)
end
function mainCityView:msgUpdateBuildTipBox(target, data)
	mainCityMsg.msgUpdateBuildTipBox(self, target, data)
end
function mainCityView:msgHideBuildTipBox(target, data)
	mainCityMsg.msgHideBuildTipBox(self, target, data)
end
function mainCityView:getOneActivityCenterDes()
	return mainCityFunctions.getOneActivityCenterDes(self)
end
function mainCityView:getOneGuardSoldierDes()
	return mainCityFunctions.getOneGuardSoldierDes(self)
end
function mainCityView:getOnePetDes()
	return mainCityFunctions.getOnePetDes(self)
end
function mainCityView:stopScrollContainer()
	self.containerView:stopAllActions()
	self:setMainCityEnabled(true)
end
function mainCityView:loadPathData()
	mainCityFunctions.loadPathData(self)
end
function mainCityView:msgShowTurretLock(target, data)
	mainCityMsg.msgShowTurretLock(self, target, data)
end
function mainCityView:msgHideTurretLock(target, data)
	mainCityMsg.msgHideTurretLock(self, target, data)
end
function mainCityView:weatherEffect(target, data)
	mainCityMsg.weatherEffect(self, target, data)
end
function mainCityView:cloudRunEffect()
	effectMainCityView.cloudRunEffect(self)
end
function mainCityView:removeCloudEffect(...)
	effectMainCityView.removeCloudEffect(self, ...)
end
function mainCityView:removeWeatherEffect(wType, isAllRemove)
	effectMainCityView.removeWeatherEffect(self, wType, isAllRemove)
end
function mainCityView:freePlaceEffect(target, data)
end
function mainCityView:deleteFreePlaceEffect(target, data)
end
function mainCityView:msgShowBuildLock(target, data)
	mainCityMsg.msgShowBuildLock(self, target, data)
end
function mainCityView:msgHideBuildLock(target, data)
	mainCityMsg.msgHideBuildLock(self, target, data)
end
function mainCityView:msgShowCommunityCenterMsg(target, data)
	mainCityMsg.msgShowCommunityCenterMsg(self, target, data)
end
function mainCityView:msgHideCommunityCenterMsg(target, data)
	mainCityMsg.msgHideCommunityCenterMsg(self, target, data)
end
function mainCityView:msgFirstFightEnd(target, data)
	mainCityMsg.msgFirstFightEnd(self, target, data)
end
function mainCityView:msgCleanMainCityGuide(target, data)
	mainCityMsg.msgCleanMainCityGuide(self, target, data)
end
function mainCityView:showLordSkillEffect(target, data)
	mainCityMsg.showLordSkillEffect(self, target, data)
end
function mainCityView:showSkillEffectBySkillID(skillID, trapType)
	effectMainCityView.showSkillEffectBySkillID(self, skillID, trapType)
end
function mainCityView:trainArmyFinishEffect(pos, isCollege, isToBag)
	include("effectMainCityView").finishEffect(self.containerView, pos, isCollege, isToBag)
end
function mainCityView:createFightView()
	mainCityCreate.createFightView(self)
end
function mainCityView:cleanMainCityView()
	self:disableShack()
	local cityBuildSoldierPool = include("cityBuildSoldierPool")
	cityBuildSoldierPool:removeAll()
	cityBuildMgr:clean()
	local cityBuildSpritePool = include("cityBuildSpritePool")
	cityBuildSpritePool:removeAll()
	mainCityBuildingMove:clean()
end
function mainCityView:onExitOther()
	self:disableShack()
	local cityBuildSoldierPool = include("cityBuildSoldierPool")
	cityBuildSoldierPool:removeAll()
	cityBuildMgr:clean()
	local cityBuildSpritePool = include("cityBuildSpritePool")
	cityBuildSpritePool:removeAll()
	mainCityBuildingMove:clean()
	mainCityABMManager:pauseCurABM()
end
function mainCityView:getIsNeedFirstFight()
	local gametop = gModuleMgr.getObject("gametop")
	local guideCtrl = gametop.playertop_:getModule("guideCtrl")
	local step = guideCtrl:getCurForceGuideStep()
	print("mainCityView:getIsNeedFirstFight", step)
	if guideCtrl.isSkipFirstFight or step == nil or step ~= 1001 then
		self.isNeedFirstFight = false
	else
		_ENV = "mainCityView:getIsNeedFirstFight"
		;("mainCityView:getIsNeedFirstFight").msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		;("mainCityView:getIsNeedFirstFight").step = 1001
		SoraDSendMessage("mainCityView:getIsNeedFirstFight")
		self.isNeedFirstFight = true
	end
	return self.isNeedFirstFight
end
function mainCityView:setIsNeedFirstFight(isNeedFirstFight)
	self.isNeedFirstFight = isNeedFirstFight
	cityBuildFunction.isNeedFirstFight = isNeedFirstFight
end
function mainCityView:msgCleanFirstFight(target, data)
	self:cleanFirstFight()
end
function mainCityView:cleanFirstFight()
	mainCityCreate.cleanFirstFight(self)
end
function mainCityView:disableMoveForDuration(duration)
	if self.viewScrollView then
		self:setMainCityEnabled(false)
		self.viewScrollView:stopAllActionsByTag(100)
		local delay = cca.delay(duration or 0.5)
		local callFunc = cca.callFunc(function()
			self:setMainCityEnabled(true)
			self.isVisibleAreaDirty = true
			self = self
			self.msg = "MESSAGE_MAINCITY_FINISH_UPDATEPOS"
			SoraDSendMessage(self)
		end)
		_UPVALUE2_ = nil
		;(nil)[1] = delay
		;(nil)[2] = callFunc
		local seq = cca.seq(nil)
		seq:setTag(100)
		self.viewScrollView:runAction(seq)
	end
end
function mainCityView:setMainCityEnabled(isEnable)
	self.viewScrollView:setTouchEnabled(isEnable)
	self.isBuildBtnEnable = isEnable
end
function mainCityView:msgUpdateGuardSoldierBox(target, data)
	mainCityMsg.msgUpdateGuardSoldierBox(self, target, data)
end
function mainCityView:msgUpdateMerchantView(target, data)
	mainCityMsg.msgUpdateMerchantView(self, target, data)
end
function mainCityView:msgResetContentView(target, data)
	self:stopScrollContainer()
	self:setZoomScale(self.defaultScale, false)
end
function mainCityView:loadFixedBuilds()
	print("mainCityView:loadFixedBuilds star")
	self:addBuild(cityBuildConstDef.fixedBuildDef.LeisureCenter, cityBuildConstDef.fixedBuildDef.LeisureCenter)
	self:addBuild(cityBuildConstDef.buildIndexDef.index_Material_WorkShop, BUILDID.MATERIAL_WORKSHOP)
	self:addBuild(cityBuildConstDef.fixedBuildDef.HuoChuang, cityBuildConstDef.fixedBuildDef.HuoChuang)
	self:addBuild(cityBuildConstDef.fixedBuildDef.ServiceCenter, cityBuildConstDef.fixedBuildDef.ServiceCenter)
	self:addBuild(cityBuildConstDef.buildIndexDef.index_PetCenter, cityBuildConstDef.fixedBuildDef.PetCenter)
	self:addBuild(cityBuildConstDef.buildIndexDef.index_ResurrectionHall, cityBuildConstDef.fixedBuildDef.ResurrectionHall)
	self:addBuild(cityBuildConstDef.buildIndexDef.index_EpicBattle, cityBuildConstDef.fixedBuildDef.EpicBattle)
	self:addBuild(cityBuildConstDef.buildIndexDef.index_Monument, BUILDID.MONUMENT)
	if not IsArClient then
		self:addBuild(cityBuildConstDef.buildIndexDef.index_Mastery, cityBuildConstDef.fixedBuildDef.Mastery)
	end
	print("mainCityView:loadFixedBuilds end")
end
function mainCityView:updateIdlePop()
end
function mainCityView:msgToggleDark(target, data)
	mainCityMsg.msgToggleDark(self, target, data)
end
function mainCityView:addWaterFallEffect()
	if device.platform == "mac" then
		include("effectMainCityView").waterfall(self)
	else
		xpcall(function()
			include("effectMainCityView").waterfall(self)
		end, function()
			print(debug.traceback())
		end)
	end
end
function mainCityView:addPetFlyBird()
	include("effectMainCityView").addPetFlyBird(self)
end
function mainCityView:initCityGroupNode()
	mainCityCreate.initCityGroupNode(self)
end
function mainCityView:initCelebrateGift(target, data)
	effectMainCityView.initCelebrateGift(self, target, data)
end
function mainCityView:refreshCastleSkin(target, data)
	mainCityMsg.refreshCastleSkin(self, target, data)
end
function mainCityView:hideAllRamadanEffectNode()
end
function mainCityView:openClassicalEffect()
end
function mainCityView:openGenaralEffect()
end
function mainCityView:openPaidEffect(isRamadan)
end
function mainCityView:updateRichCastlePos(isRamadan, isGenaral)
end
function mainCityView:showFadeInOut(node)
end
function mainCityView:updateBGHALL(isRamadan)
end
function mainCityView:updateCityShow()
	effectMainCityView.updateCityShow(self)
end
function mainCityView:initMatouData(target, data)
	mainCityCreate.initMatouData(self, target, data)
end
function mainCityView:initWithHuoChuangData(target, data)
	mainCityCreate.initWithHuoChuangData(self, target, data)
end
function mainCityView:preLoadImages()
	print("开始预加载资源--------------")
	_ENV, _UPVALUE4_ = "开始预加载资源--------------", print
	_ENV, ("开始预加载资源--------------").name = nil, "MainCity/mainCity"
	_ENV, (nil).name = nil, "MainCity/mainCity2"
	_ENV, (nil).name = nil, "MainCity/mainCityOuter"
	;(nil).name = "FrameAnimation/mainCityNpc"
	print[1] = "开始预加载资源--------------"
	print[2] = nil
	print[3] = nil
	local print[4], imgArray = nil, print
	local format = "png"
	if device.platform == "android" then
		format = nil
	end
	self.isNeedFirstFight = self:getIsNeedFirstFight()
	local _ENV, specialIndexArray = self:getIsNeedFirstFight(), self:getIsNeedFirstFight()
	if commonCheck.GARDEN then
		_ENV = commonCheck.GARDEN
		if commonCheck.GARDEN then
			goto lbl_34
		end
	end
	_ENV = commonCheck.GARDEN
	commonCheck.GARDEN[22] = true
	local commonCheck.GARDEN[39], gardenConfig = true, commonCheck.GARDEN
	::lbl_34::
	if IsArClient then
		_ENV = nil
		;(nil).name = "MainCity/mainCityInner"
		table.insert(imgArray, nil)
		_ENV = nil
		;(nil).name = "MainCity/mainCityBGDH"
		;(nil).format = "png"
		table.insert(imgArray, nil)
		_ENV = nil
		;(nil).name = "MainCity/mainCityWall"
		table.insert(imgArray, nil)
		for i = 1, 40 do
			if gardenConfig[i] then
				_ENV = nil
				;(nil).name = "MainCity/mainCityBGHall_" .. i .. "_ROS"
				;(nil).format = format
				table.insert(imgArray, nil)
			else
				_ENV = nil
				;(nil).name = "MainCity/mainCityBGHall_" .. i
				;(nil).format = format
				table.insert(imgArray, nil)
			end
		end
	else
		local factionCtrl = SoraDGetCtrl("factionCtrl")
		factionCtrl:setFirstLogin(self.isNeedFirstFight)
		local factionType = factionCtrl:getFactionId()
		local bgPrePath = FACTION_CITY_BG_PRELOAD[factionType]
		for i = 1, 40 do
			if gardenConfig[i] then
				_ENV = "_ROS"
				;("_ROS").name = "MainCity/mainCityBGHall_" .. i .. "_ROS"
				;("_ROS").format = format
				table.insert(imgArray, "_ROS")
			else
				_ENV = "_ROS"
				;("_ROS").name = "MainCity/mainCityBGHall_" .. i
				;("_ROS").format = format
				table.insert(imgArray, "_ROS")
			end
		end
		for _, v in ipairs(FACTION_COMM_PRELOAD[factionType]) do
			table.insert(imgArray, v)
		end
	end
	self:loadImages(imgArray, handler(self, self.finishLoadImages))
end
function mainCityView:preLoadAudios()
	local innersoundtable = gSoundDataList.innerbuildsound
	self.cachedSound, _ENV = nil, nil
	print("预加载声音-----------begin")
	for k, v in pairs(innersoundtable) do
		if v ~= "" then
			local fullFilePath = cc.FileUtils:getInstance():fullPathForFilename(getAudioFileNameByPlatform(v, "Sound"))
			self.cachedSound[v] = fullFilePath
			print("·预加载：", v)
			AudioEngine.preloadEffect(fullFilePath)
		end
	end
	_UPVALUE1_ = (for generator)
	local pairs(innersoundtable)[1], otherAudio = "city_click", pairs(innersoundtable)
	for k, v in pairs(otherAudio) do
		if v ~= "" then
			local fullFilePath = cc.FileUtils:getInstance():fullPathForFilename(getAudioFileNameByPlatform(v, "Sound"))
			self.cachedSound[v] = fullFilePath
			AudioEngine.preloadEffect(fullFilePath)
		end
	end
	print("预加载声音-----------end")
	dump(self.cachedSound, "缓存的声音路径-----")
end
function mainCityView:finishLoadImages()
	print("内城 预加载图片完成---------------------")
	self.isFinishInit = true
	mainCityCreate.ctor(self, self.param)
	self:onMessageListener_FinishLoadImage()
	mainCityCreate.initAfterCreate(self)
	local guideCtrl = gametop.playertop_:getModule("guideCtrl")
	local mainCityGuideStep = guideCtrl:getCurMainCityGuideStep()
	if mainCityGuideStep ~= nil or SoraDCloseLoginView() then
		print("登入进入主城成功")
		_ENV = nil
		userSDKManager.logEvent(gSDKDef.TDonEvent.enter_city, nil)
		if self.isNeedFirstFight then
			_ENV = gSDKDef.TDonEvent.enter_city
			gSDKDef.TDonEvent.enter_city.msg = "MESSAGE_MAIN_SCENE_IPHONEX"
			gSDKDef.TDonEvent.enter_city.isShow = false
			SoraDSendMessage(gSDKDef.TDonEvent.enter_city)
			print("隐藏iPhoneX-----------------")
		end
	end
	print("-----------------------------------------------------")
end
function mainCityView:enterDayPeriod(dayPeriod)
	effectMainCityView.enterDayPeriod(self, dayPeriod)
end
function mainCityView:msgUpdateNightCfg(target, data)
	mainCityMsg.msgUpdateNightCfg(self, target, data)
end
function mainCityView:addHarvestEffect(target, data)
	mainCityMsg.addHarvestEffect(self, target, data)
end
function mainCityView:msgRemoveHarvestEffect(target, data)
	mainCityMsg.msgRemoveHarvestEffect(self, target, data)
end
function mainCityView:msgUpdateHorseFlag(target, data)
	mainCityMsg.msgUpdateHorseFlag(self, target, data)
end
function mainCityView:initVisibleArea()
	do return end
	cityBuildConstDef = nil
	cityBuildConstDef = self.WaterFallNode
	self.WaterFallNode.visibleType = cityBuildConstDef.visibleType.single
	self.WaterFallNode.node = self.WaterFallNode
	self.WaterFallNode.boundingBox = cc.rect(1319, 1579, 600, 500)
	;(nil)[self.WaterFallNode:getName()], self.WaterFallNode.parent = self.WaterFallNode, self.containerView
	cityBuildConstDef = self.cityBuildSoldiersMatrixNode
	self.cityBuildSoldiersMatrixNode.visibleType = cityBuildConstDef.visibleType.single
	self.cityBuildSoldiersMatrixNode.node = self.cityBuildSoldiersMatrixNode
	self.cityBuildSoldiersMatrixNode.boundingBox = cc.rect(1198, 120, 1300, 700)
	_UPVALUE2_, self.checkVisibleNodes, (nil)[self.cityBuildSoldiersMatrixNode:getName()], self.cityBuildSoldiersMatrixNode.parent = nil, nil, self.cityBuildSoldiersMatrixNode, self.containerView
	;(nil)[1] = self:getBufferNodeByName("build_1058")
	;(nil)[2] = self:getBufferNodeByName("build_1059")
	;(nil)[3] = self:getBufferNodeByName("build_1060")
	;(nil)[4] = self:getBufferNodeByName("build_1060")
	;(nil)[5] = self:getBufferNodeByName("build_1060")
	;(nil)[6] = self:getBufferNodeByName("build_1060")
	;(nil)[7] = self:getBufferNodeByName("build_1060")
	;(nil)[8] = self:getBufferNodeByName("build_1060")
	;(nil)[9] = self:getBufferNodeByName("build_1060")
	;(nil)[10] = self:getBufferNodeByName("build_1060")
	local (nil)[11], blockAreaInnerNodes1 = self:getBufferNodeByName("build_1060")
	local boundingBoxInner1 = cc.rect(1544, 1202, 950, 350)
	cityBuildConstDef = 950
	;(950).visibleType = cityBuildConstDef.visibleType.block
	;(950).nodes = blockAreaInnerNodes1
	;(950).boundingBox = boundingBoxInner1
	_UPVALUE3_, self.checkVisibleNodes[cityBuildConstDef.blockArea.blockAreaInner1], (950).parent = self.checkVisibleNodes, 950, self.containerView
	self.checkVisibleNodes[1] = self:getBufferNodeByName("build_1061")
	self.checkVisibleNodes[2] = self:getBufferNodeByName("build_1062")
	self.checkVisibleNodes[3] = self:getBufferNodeByName("build_1066")
	self.checkVisibleNodes[4] = self:getBufferNodeByName("build_1067")
	self.checkVisibleNodes[5] = self:getBufferNodeByName("build_1067")
	self.checkVisibleNodes[6] = self:getBufferNodeByName("build_1067")
	self.checkVisibleNodes[7] = self:getBufferNodeByName("build_1067")
	self.checkVisibleNodes[8] = self:getBufferNodeByName("build_1067")
	local self.checkVisibleNodes[9], blockAreaInnerNodes2 = self:getBufferNodeByName("build_1067")
	local boundingBoxInner2 = cc.rect(1930, 695, 1100, 600)
	cityBuildConstDef = 1100
	;(1100).visibleType = cityBuildConstDef.visibleType.block
	;(1100).nodes = blockAreaInnerNodes2
	;(1100).boundingBox = boundingBoxInner2
	_UPVALUE2_, self.checkVisibleNodes[cityBuildConstDef.blockArea.blockAreaInner2], (1100).parent = self.checkVisibleNodes, 1100, self.containerView
	self.checkVisibleNodes[1] = self:getBufferNodeByName("build_1051")
	self.checkVisibleNodes[2] = self:getBufferNodeByName("build_1056")
	self.checkVisibleNodes[3] = self:getBufferNodeByName("build_1057")
	self.checkVisibleNodes[4] = self:getBufferNodeByName("build_1057")
	self.checkVisibleNodes[5] = self:getBufferNodeByName("build_1057")
	self.checkVisibleNodes[6] = self:getBufferNodeByName("build_1057")
	local self.checkVisibleNodes[7], blockAreaInnerNodes3 = self:getBufferNodeByName("build_1057")
	local boundingBoxInner3 = cc.rect(2406, 1488, 700, 500)
	cityBuildConstDef = 700
	;(700).visibleType = cityBuildConstDef.visibleType.block
	;(700).nodes = blockAreaInnerNodes3
	;(700).boundingBox = boundingBoxInner3
	_UPVALUE2_, self.checkVisibleNodes[cityBuildConstDef.blockArea.blockAreaInner3], (700).parent = self.checkVisibleNodes, 700, self.containerView
	self.checkVisibleNodes[1] = self:getBufferNodeByName("build_1063")
	self.checkVisibleNodes[2] = self:getBufferNodeByName("build_1064")
	self.checkVisibleNodes[3] = self:getBufferNodeByName("build_1065")
	self.checkVisibleNodes[4] = self:getBufferNodeByName("build_1065")
	local self.checkVisibleNodes[5], blockAreaInnerNodes4 = self:getBufferNodeByName("build_1065")
	local boundingBoxInner4 = cc.rect(2935, 1185, 820, 600)
	cityBuildConstDef = 820
	;(820).visibleType = cityBuildConstDef.visibleType.block
	;(820).nodes = blockAreaInnerNodes4
	;(820).boundingBox = boundingBoxInner4
	self.checkVisibleNodes[cityBuildConstDef.blockArea.blockAreaInner4], (820).parent = 820, self.containerView
end
function mainCityView:isNodeInsideVisible(node, rect, target)
	local isInside = false
	local winRect = cc.rect(-100, -100, display.size.width + 200, display.size.height + 200)
	local nodeRect = rect or node:getBoundingBox()
	local parent
	if target then
		parent = target
	else
		parent = node:getParent()
	end
	local LB = parent:convertToWorldSpace(cc.p(nodeRect.x, nodeRect.y))
	local RT = parent:convertToWorldSpace(cc.p(nodeRect.x + nodeRect.width, nodeRect.y + nodeRect.height))
	local nodeWorldRect = cc.rect(LB.x, LB.y, RT.x - LB.x, RT.y - LB.y)
	isInside = cc.rectIntersectsRect(nodeWorldRect, winRect)
	return isInside
end
function mainCityView:moveVisible()
	if not self.checkVisibleNodes then
		return
	end
	for k, v in pairs(self.checkVisibleNodes) do
		if v.visibleType == cityBuildConstDef.visibleType.single then
			local node = v.node
			node = node or self:getBufferNodeByName(k)
			if node then
				if self:isNodeInsideVisible(node, v.boundingBox, v.parent) then
					node:setVisible(true)
				else
					node:setVisible(false)
				end
			end
		elseif v.visibleType == cityBuildConstDef.visibleType.block then
			local nodes = v.nodes
			if nodes then
				if self:isNodeInsideVisible(nil, v.boundingBox, v.parent) then
					for k, v in pairs(nodes) do
						v:setVisible(true)
					end
				else
					for k, v in pairs(nodes) do
						v:setVisible(false)
					end
				end
			end
		end
	end
end
function mainCityView:msgAutoCollectRes(target, data)
	mainCityMsg.msgAutoCollectRes(self, data, data)
end
function mainCityView:onShackCallBack()
	print("摇一摇的回调~~~~~~")
	if #SoraDPanelManager > 0 then
		return
	end
	if SoraDIsGameGuide() ~= nil then
		print("有新手引导, 不搜集资源-----")
		return
	end
	local mainCityFunctions = include("mainCityFunctions")
	mainCityFunctions.autoCollectRes(self)
end
function mainCityView:enableShack()
	if SoraDConfigGet("Game:GameOptionsView:shake~bool") then
		print("启用摇一摇")
		SoraDShackON(self, handler(self, self.onShackCallBack))
	end
end
function mainCityView:disableShack()
	SoraDShackOFF(self)
end
function mainCityView:autoCollectBuildResSchedule()
	if self.timerCollectRes ~= nil then
		return
	else
		self.timerCollectRes = SoraDCreateTimerEx(self, handler(self, self.CollectBuildResUpdate), 0.25)
	end
end
function mainCityView:CollectBuildResUpdate(dt)
	local autoCollectBuildRes = function(cityBuild)
		if cityBuild and not cityBuild:getIsLocked() and cityBuild:getState() == "harvesting" then
			cityBuild:doHarvesting()
		end
	end
	if #self.collectBuilds > 0 then
		local buildIndex = table.remove(self.collectBuilds, 1)
		if 1100 <= buildIndex then
			local cellIndexName = "build_" .. buildIndex
			local buildBtn = self:getBufferNodeByName(cellIndexName)
			if buildBtn then
				local buildEntity = buildBtn:getChildByName("buildName")
				autoCollectBuildRes(buildEntity)
			end
		end
	else
		SoraDManagerRemoveTimer(self, self.timerCollectRes)
		self.timerCollectRes = nil
	end
end
function mainCityView:msgShowBulletInBoardMsg(target, data)
	mainCityMsg.msgShowBulletInBoardMsg(self, target, data)
end
function mainCityView:msgHideBulletInBoardMsg(target, data)
	mainCityMsg.msgHideBulletInBoardMsg(self, target, data)
end
function mainCityView:msgJump(target, data)
	mainCityMsg.msgJump(self, target, data)
end
function mainCityView:msgShowTopTipActivity(target, data)
	mainCityMsg.msgShowTopTipActivity(self, target, data)
end
function mainCityView:msgHideTopTipActivity(target, data)
	mainCityMsg.msgHideTopTipActivity(self, target, data)
end
function mainCityView:msgUpdatePetShow(target, data)
	effectMainCityView.msgUpdatePetShow(self, target, data)
end
function mainCityView:msgUpdatePetTipBox(target, data)
	mainCityMsg.msgUpdatePetTipBox(self, target, data)
end
function mainCityView:msgUpdateMagicLampTipBox(target, data)
	mainCityMsg.msgUpdateMagicLampTipBox(self, target, data)
end
function mainCityView:msgChangeQuality(target, data)
	mainCityMsg.msgChangeQuality(self, target, data)
end
function mainCityView:gameGuide_getTarget(itemName, parameters)
	if itemName == "index" then
		return self:getBuildBtnByIndex(parameters.index)
	elseif itemName == "build" then
		return self:getBuildBtnByBid(parameters.bid)
	elseif itemName == "tip" and self.currentSelectTip then
		if self.currentSelectTip:getBtnByOpName(parameters.key) then
			return self.currentSelectTip:getBtnByOpName(parameters.key).button
		end
		return nil
	elseif itemName == "pop" and self.containerView then
		if self:getBuildTipTop(parameters.bid) then
			return self:getBuildTipTop(parameters.bid).btn
		end
		return nil
	end
	return nil
end
function mainCityView:msgNewCollectItems(target, data)
	local items = data.items
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_SHOW_COLLECTITEMS"
	;(nil).items = items
	;(nil).actType = cityBuildConstDef.itemActType.actBag
	SoraDSendMessage(nil)
end
function mainCityView:msgUpdateCommunityView(target, data)
	effectMainCityView.updateCommunityView(self, target, data)
end
function mainCityView:msgUpdateBraveStatueView(target, data)
	effectMainCityView.updateStarBraveStatueView(self, target, data)
end
function mainCityView:msgUpdateBuildVisible(target, data)
	mainCityCreate.updateBuildBtnVisible(self, target, data)
end
function mainCityView:msgLoginFinish(target, data)
	mainCityMsg.msgLoginFinish(self, target, data)
end
function mainCityView:msgUpdateLion(target, data)
	mainCityMsg.msgUpdateLion(self, target, data)
end
function mainCityView:msgCastleGift(target, data)
	mainCityMsg.msgCastleGift(self, target, data)
end
function mainCityView:msgwillOpen(target, data)
	mainCityMsg.msgwillOpen(self, target, data)
end
function mainCityView:msgPlaySound(target, data)
	self:playSound(data.classify, data.index, data.tag, data.delay)
end
function mainCityView:playSound(classify, index, tag, delay)
	local fileName = gSoundDataList[classify] and gSoundDataList[classify][index] or "not found"
	print("fileName, classify, index, tag, delay = ", fileName, classify, index, tag, delay)
	if tag == cityBuildConstDef.ActionTag.Tag_Play_Click_Build_Sound then
		print("播放建筑声音--------")
		if self:getActionByTag(cityBuildConstDef.ActionTag.Tag_Play_Click_Default_Sound) then
			print("有在播放的默认声音，停止掉~~~")
			self:stopActionByTag(cityBuildConstDef.ActionTag.Tag_Play_Click_Default_Sound)
			self.curPlaySound = nil
		else
		end
	end
	self.curPlaySound = fileName
	local delay = cca.delay(delay or 0.001)
	local callFunc = cca.callFunc(function()
		SoraDPlaySound(classify, index)
		self.curPlaySound = nil
	end)
	_UPVALUE2_ = classify
	classify[1] = delay
	classify[2] = callFunc
	local seq = cca.seq(classify)
	seq:setTag(tag or 0)
	self:runAction(seq)
end
function mainCityView:msgHeroAppointTopTip(target, data)
	mainCityMsg.msgHeroAppointTopTip(self, target, data)
end
function mainCityView:msgAddNpcTopTip(target, data)
	mainCityMsg.msgAddNpcTopTip(self, target, data)
end
function mainCityView:msgRemoveNpcTopTip(target, data)
	mainCityMsg.msgRemoveNpcTopTip(self, target, data)
end
function mainCityView:msgAddCastleGiftTopTip(target, data)
	mainCityMsg.msgAddCastleGiftTopTip(self, target, data)
end
function mainCityView:msgRemoveCastleGiftTopTip(target, data)
	mainCityMsg.msgRemoveCastleGiftTopTip(self, target, data)
end
function mainCityView:msgUpdateArmyPromoteTopTip(target, data)
	mainCityMsg.msgUpdateArmyPromoteTopTip(self, target, data)
end
function mainCityView:msgRemoveArmyPromoteTopTip(target, data)
	mainCityMsg.msgRemoveArmyPromoteTopTip(self, target, data)
end
function mainCityView:msgUpdateEpicWarTopTip(target, data)
	mainCityMsg.msgUpdateEpicWarTopTip(self, target, data)
end
function mainCityView:msgRemoveEpicWarTopTip(target, data)
	mainCityMsg.msgRemoveEpicWarTopTip(self, target, data)
end
function mainCityView:msgUpdateFriendTopTip(target, data)
	mainCityMsg.msgUpdateFriendTopTip(self, target, data)
end
function mainCityView:msgUpdateEndlessTreasureTopTip(target, data)
	mainCityMsg.msgUpdateEndlessTreasureTopTip(self, target, data)
end
function mainCityView:msgRemoveEndlessTreasureTopTip(target, data)
	mainCityMsg.msgRemoveEndlessTreasureTopTip(self, target, data)
end
function mainCityView:msgUpdateAllianceTreasureTopTip(target, data)
	mainCityMsg.msgUpdateAllianceTreasureTopTip(self, target, data)
end
function mainCityView:msgRemoveAllianceTreasureTopTip(target, data)
	mainCityMsg.msgRemoveAllianceTreasureTopTip(self, target, data)
end
function mainCityView:msgAddArenaTopTip(target, data)
	mainCityMsg.msgAddArenaTopTip(self, target, data)
end
function mainCityView:msgRemoveArenaTopTip(target, data)
	mainCityMsg.msgRemoveArenaTopTip(self, target, data)
end
function mainCityView:msgAddShelterTopTip(target, data)
	mainCityMsg.msgAddShelterTopTip(self, target, data)
end
function mainCityView:msgRemoveShelterTopTip(target, data)
	mainCityMsg.msgRemoveShelterTopTip(self, target, data)
end
function mainCityView:msgMainCityDownloadSuccess(target, data)
	mainCityMsg.msgMainCityDownloadSuccess(self, target, data)
end
function mainCityView:msgCollectBatchRes(target, data)
	mainCityMsg.msgCollectBatchRes(self, target, data)
end
function mainCityView:msgKipchaksUpdate(target, data)
	mainCityMsg.msgKipchaksUpdate(self, target, data)
end
function mainCityView:msgUpdateMasteryCoolingPanel(target, data)
	mainCityMsg.msgUpdateMasteryCoolingPanel(self, target, data)
end
function mainCityView:msgUpdateMasteryTopTip(target, data)
	mainCityMsg.msgUpdateMasteryTopTip(self, target, data)
end
function mainCityView:msgCurrentShowViewHided(target, data)
	dump(data, "mainCityView:msgCurrentShowVIewHided")
	if data.data.view == self then
		if data.data.isVisible then
			mainCityABMManager:resumeCurABM()
		else
			mainCityABMManager:pauseCurABM()
		end
	end
end
function mainCityView:msgShowCommandHallBox(target, data)
	mainCityMsg.msgShowCommandHallBox(self, target, data)
end
return mainCityView
