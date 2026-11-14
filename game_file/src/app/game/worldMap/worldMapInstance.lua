local worldMapDefine = include("worldMapDefine")
local worldMapBuildFireEffect = include("worldMapBuildFireEffect")
local worldMapBuildEmoji = include("worldMapBuildEmoji")
local worldMapInstanceLod = include("worldMapInstanceLod")
local worldMapInstance = class("worldMapInstance", function(target)
	target = worldMapInstanceLod.new(target)
	worldMapBuildEmoji.new(target)
	worldMapBuildFireEffect.new(target)
	return target
end)
worldMapInstance.addFireEffect = worldMapBuildFireEffect.addFireEffect
worldMapInstance.showInstance = worldMapInstanceLod.showInstance
local DEFAULT_TILE_POINT = cc.p(0, 0)
local Z_ORDER = worldMapDefine.Z_ORDER
local GROU_ID = worldMapDefine.GROU_ID
local _ENV, TABLE_EMPTY
function worldMapInstance:ctor()
	self.instanceLevel = 0
	self.tilesArray = TABLE_EMPTY
	self.ignoreRequest = false
end
function worldMapInstance:getInstanceLevel()
	return self.instanceLevel
end
function worldMapInstance:setTilesArray(tilesArray)
	self.tilesArray = tilesArray
end
function worldMapInstance:getTilesArray()
	return self.tilesArray
end
function worldMapInstance:setBatchNodeGroupID(groupID)
end
function worldMapInstance:beginAttack(facePoint)
	print("worldMapInstance:beginAttack")
end
function worldMapInstance:endAttack()
	print("worldMapInstance:endAttack")
end
function worldMapInstance:onShowWorldMapTip(onShowView)
	local showRolygon = true
	local halfInstace = (self:getHoldInstace() - 1) * 0.5
	local showTilePoint = cc.p(self.tilePoint.x + halfInstace, self.tilePoint.y + halfInstace)
	local selectShowPanel = include("worldMapTip").new(self.kingdomID)
	selectShowPanel:setTilePoint(showTilePoint, self.tilePoint)
	selectShowPanel:setWorldMapCell(self.worldMapCell)
	selectShowPanel:initInstanceData(self)
	local screenPoint = SoraDConvertoScreenPos2DOr3D(self, DEFAULT_TILE_POINT)
	local coverShowPoint = onShowView:convertToNodeSpace(screenPoint)
	selectShowPanel:setPosition(coverShowPoint)
	selectShowPanel:addTo(onShowView, Z_ORDER.selectView)
	local favoriteName = self:getFavoriteName()
	selectShowPanel:setFavoriteName(favoriteName)
	return selectShowPanel, showRolygon
end
function worldMapInstance:onClickInstance(onShowView)
	self:playClickSound()
	return self:onShowWorldMapTip(onShowView)
end
function worldMapInstance:playClickSound()
end
function worldMapInstance:onClickTipButton(...)
	return false
end
function worldMapInstance:getFavoriteName()
	local mapObjUtil = include("mapObjUtil")
	local favoriteName = mapObjUtil.getBuildName(self.instanceType, self.siteClassID)
	return favoriteName
end
function worldMapInstance:getInstanceOp(isSelfKindom)
end
function worldMapInstance:addCacheInstanceBefore()
	worldMapInstanceLod.addCacheInstanceBefore(self)
	self.tilesArray = TABLE_EMPTY
	self:resetBuildEmoji()
	self:resetFireEffect()
end
function worldMapInstance:getOrCreateWallWarningTips()
	if not self.tipsNode then
		self.tipsNode = display.newNode()
		local bgImage = ccui.ImageView:create("frame_main_text.png", ccui.TextureResType.plistType)
		bgImage:setScale9Enabled(true)
		bgImage:addTo(self.tipsNode)
		bgImage:setPosition(cc.p(0, 5))
		bgImage:setAnchorPoint(cc.p(0.5, 0))
		bgImage:setContentSize(cc.size(420, 120))
		bgImage:setFlippedX(true)
		bgImage:setGroupID(GROU_ID.group_animate_object_fg)
		bgImage:setTouchEnabled(true)
		bgImage:setName("bgImage")
		bgImage:addTouchEventListener(function(button, eventType)
			if eventType == ccui.TouchEventType.ended and self.tipsHandler then
				self.tipsHandler()
			end
		end)
		local tipText = ccui.Text:create()
		tipText:setFontSize(24)
		tipText:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		tipText:setTextVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		tipText:setColor(cc.c3b(0, 0, 0))
		tipText:setAnchorPoint(cc.p(0.5, 0.5))
		tipText:setPosition(cc.p(0, 60))
		local size = cc.size(400, 110)
		SoraDSetTextWidthHeight(tipText, size)
		tipText:addTo(self.tipsNode)
		tipText:setGroupID(GROU_ID.group_animate_object_fg)
		tipText:setGroupAuto(true)
		tipText:setName("tipText")
		self.tipsNode:addTo(self)
		self.tipsNode:setPositionY(50)
	end
	return self.tipsNode
end
function worldMapInstance:showWarningTip(tipInfo, eventHandle, delay)
	local tipsNode = self:getOrCreateWallWarningTips()
	delay = delay or 0
	tipsNode:setVisible(false)
	_UPVALUE5_ = tipsNode
	tipsNode[1] = cca.hide()
	tipsNode[2] = cca.delay(delay)
	tipsNode[3] = cca.show()
	tipsNode[4] = cca.scaleTo(0.5, 1)
	tipsNode[5] = cca.delay(7)
	tipsNode[6] = cca.scaleTo(0.5, 0)
	tipsNode[7] = cca.scaleTo(0.5, 0)
	tipsNode[8] = cca.scaleTo(0.5, 0)
	local seq = cca.seq(tipsNode)
	tipsNode:stopAllActions()
	tipsNode:runAction(seq)
	tipsNode:getChildByName("tipText"):setString(i18n(tipInfo))
	self.tipsHandler = eventHandle
end
function worldMapInstance:onShowBuildTips(target, data)
	local targetTile = data.tilePoint
	local tipsInfo = data.tipsInfo
	local delay = data.delay or 0
	if targetTile.x == self:getTilePoint().x and targetTile.y == self:getTilePoint().y then
		self:showWarningTip(tipsInfo, nil, delay)
	end
end
function worldMapInstance:updateShot(params)
end
function worldMapInstance:updateScoreTips(params)
	if params and params.camp then
		local posY = 50
		if self.instanceType == gMapObjTypeDef.mapObjTypeRemainsWar then
			posY = 200
		elseif self.instanceType == gMapObjTypeDef.mapObjTypeBoss then
			posY = 100
		end
		local pos = cc.p(self.centerPoint.x, self.centerPoint.y + posY)
		self:onAddScoreTips(params.value, params.camp, pos)
	end
end
local SoraDCreateWaveNode = function(text, parent, params)
	text = text or "NA"
	if params == nil then
		params, _ENV = nil, nil
	end
	local color = params.color or display.COLOR_GREEN
	local pos = params.pos or cc.p(0, 0)
	local zOrder = params.zOrder or 1
	local fontsize = params.fontSize or 24
	local dt = params.duration or 1
	local moveH = params.moveH or 80
	local hideImage = params.hideImage or false
	local score_action = parent:getChildByName("score_action")
	if score_action then
		local offset = 25
		if offset >= math.abs(score_action:getPositionY() - pos.y) then
			pos.y = pos.y - offset
		end
	end
	local node = display.newNode()
	node:setName("score_action")
	node:addTo(parent, zOrder)
	node:setPosition(pos)
	_ENV = node
	node.text = text
	node.color = color
	node.size = fontsize
	local waveLabel = display.newTTFLabel(node)
	waveLabel:addTo(node, zOrder)
	local imageBg = display.newSprite("#icon_remains_score.png")
	local size = waveLabel:getContentSize()
	imageBg:setPosition(cc.p(-size.width * 0.5 - 30, size.height * 0.5 - 15))
	imageBg:addTo(node)
	imageBg:setScale(0.7)
	if hideImage then
		imageBg:setVisible(false)
	end
	local moveBy = cca.moveBy(dt, 0, moveH)
	local callFunc = cca.callFunc(function()
		node:removeFromParent()
	end)
	_UPVALUE2_ = moveH
	moveH[1] = moveBy
	moveH[2] = callFunc
	local seq = cca.seq(moveH)
	node:runAction(seq)
	return node
end
function worldMapInstance:onAddScoreTips(score, camp, position)
	score = score or 0
	local color
	if camp then
		if worldMapDefine.isInSimulatedDrill() then
			local simulatedDrillUtil = include("simulatedDrillUtil")
			color = simulatedDrillUtil.getCampColor(camp)
		else
			local remainsWarRead = include("remainsWarRead")
			color = remainsWarRead.getCampColor(camp)
		end
	end
	if not self.scoreTips then
		self.scoreTips = display.newNode()
		self.scoreTips:addTo(self)
		self.scoreTips:setGroupID(GROU_ID.group_animate_object_top)
		self.scoreTips:setGroupAuto(true)
	end
	self.scoreTips:setPosition(position)
	worldMapDefine = score
	score.color = color
	score.parentAction = true
	score.zOrder = 1000
	SoraDCreateWaveNode(string.format("+ %s", score), self.scoreTips, score)
end
function worldMapInstance:updateHpTips(params)
	if params and params.value then
		params.pos = cc.p(self.centerPoint.x, self.centerPoint.y + 50)
		self:onAddHpTips(params)
	end
end
function worldMapInstance:onAddHpTips(params)
	local hp = params.value or 0
	local color = params.color or cc.c3b(190, 40, 40)
	if not color then
		if 0 < hp then
			color = cc.c3b(40, 190, 40)
		else
			color = cc.c3b(190, 40, 40)
		end
	end
	local position = params.pos or cc.p(0, 0)
	local isCrit = params.isCrit or false
	if not self.scoreTips then
		self.scoreTips = display.newNode()
		self.scoreTips:addTo(self)
		self.scoreTips:setGroupID(GROU_ID.group_animate_object_top)
		self.scoreTips:setGroupAuto(true)
	end
	self.scoreTips:setPosition(position)
	local hpStr
	if 0 < hp then
		hpStr = string.format("+ %s", string.formatnumberthousands(hp))
	else
		hpStr = string.format("- %s", string.formatnumberthousands(math.abs(hp)))
	end
	if isCrit then
		hpStr = string.format("%s %s", i18n("god_beast_text_43"), hpStr)
	end
	_ENV = hpStr
	hpStr.color = color
	hpStr.parentAction = true
	hpStr.zOrder = 1000
	hpStr.hideImage = true
	hpStr.fontSize = 36
	SoraDCreateWaveNode(hpStr, self.scoreTips, hpStr)
end
function worldMapInstance:updateAllianceCounterAtkEffect(target, data)
	if self.playerID and SoraDGetCtrl("allianceCounterSysCtrl"):checkAllianceEnemy(self.playerID) then
		self:addAllianceEnemyCastleEffect()
	else
		self:removeAllianceEnemyCastleEffect()
	end
end
function worldMapInstance:addAllianceEnemyCastleEffect()
	if self:getChildByName("et_node_alliance_enemy") then
		return
	end
	local et_node = _G.SoraDCreatAnimationEx("Node_effect_alliance_countrt_sys", nil, true)
	et_node:setName("et_node_alliance_enemy")
	et_node:addTo(self)
end
function worldMapInstance:removeAllianceEnemyCastleEffect()
	if self:getChildByName("et_node_alliance_enemy") then
		self:removeChildByName("et_node_alliance_enemy", true)
	end
end
function worldMapInstance:checkHasArmy()
	local gametop = gModuleMgr.getObject("gametop")
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local hasArmy, queueId = kingdomMapCtrl:hasQueue2MapObj(self.instanceID, gMapMoveLineType.moveLineTypecapture, gMapMoveLineStatusType.moveLineStatusTypeWorking)
	if not hasArmy then
		hasArmy, queueId = kingdomMapCtrl:hasQueue2MapObj(self.instanceID, gMapMoveLineType.moveLineTypeArmyHelp, gMapMoveLineStatusType.moveLineStatusTypeWorking)
	end
	return hasArmy, queueId
end
return worldMapInstance
