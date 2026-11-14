local _ENV, cityBuildNodeCreator
local instanceCacheMgr = include("instanceCacheMgr")
function cityBuildNodeCreator:createNode(nodeItem)
	local nodeType = nodeItem.nodeType
	if nodeType == "sprite" then
		return self:createNode_Sprite(nodeItem)
	elseif nodeType == "animation" then
		return self:createNode_Animation(nodeItem)
	elseif nodeType == "layout" then
		return self:createNode_Layout(nodeItem)
	elseif nodeType == "text" then
		return self:createNode_Text(nodeItem)
	elseif nodeType == "action" then
		return self:createNode_Action(nodeItem)
	elseif nodeType == "ownAction" then
		return self:createNode_OwnAction(nodeItem)
	elseif nodeType == "particle" then
		return self:createNode_Particle(nodeItem)
	elseif nodeType == "spine" then
		return self:createNode_Spine(nodeItem)
	elseif nodeType == "csd" then
		return self:createNode_Csd(nodeItem)
	else
		print("未定义生成~~: cityBuildNodeCreator:createNode(nodeItem) createnodeTye = ", nodeType)
	end
end
function cityBuildNodeCreator:getNodeFromCache(nodeItem)
	local nodeType = nodeItem.nodeType
	local node = instanceCacheMgr.getInstance("cityBuildNode" .. nodeType)
	if node == nil or tolua.isnull(node) then
		return
	end
	node:resetObject()
	if nodeType == "sprite" then
	elseif nodeType == "animation" then
		node:stopAllActions()
	elseif nodeType == "layout" then
	elseif nodeType == "text" then
		node:setString("")
		node:setFontSize(20)
		node:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		node:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	else
		if nodeType == "action" then
			node:ignoreContentAdaptWithSize(true)
		else
		end
	end
	return node
end
function cityBuildNodeCreator:applyBaseAttributeToNode(node, nodeItemCfg)
	if node == nil or nodeItemCfg == nil then
		return
	end
	if nodeItemCfg.size then
		node:setContentSize(cc.size(nodeItemCfg.size.width, nodeItemCfg.size.height))
	end
	if nodeItemCfg.scale then
		if nodeItemCfg.nodeImg and nodeItemCfg.nodeImg == "icon_saleRoom_symbol.png" then
			node:setScale(0.8)
		elseif type(nodeItemCfg.scale) == "table" then
			node:setScaleX(nodeItemCfg.scale[1])
			node:setScaleY(nodeItemCfg.scale[2])
		else
			node:setScale(nodeItemCfg.scale)
		end
	end
	if nodeItemCfg.scaleX then
		node:setScaleX(nodeItemCfg.scaleX)
	end
	if nodeItemCfg.scaleY then
		node:setScaleY(nodeItemCfg.scaleY)
	end
	if nodeItemCfg.anchor ~= nil then
		node:ignoreAnchorPointForPosition(false)
		node:setAnchorPoint(nodeItemCfg.anchor)
	end
	if nodeItemCfg.isFlipX ~= nil then
		node:setFlippedX(nodeItemCfg.isFlipX)
	end
	if nodeItemCfg.isFlipY ~= nil then
		node:setFlippedY(nodeItemCfg.isFlipY)
	end
	if nodeItemCfg.skewX ~= nil then
		node:setSkewX(nodeItemCfg.skewX)
	end
	if nodeItemCfg.skewY ~= nil then
		node:setSkewY(nodeItemCfg.skewY)
	end
	if nodeItemCfg.rotation ~= nil then
		node:setRotation(nodeItemCfg.rotation)
	end
	if nodeItemCfg.color and node.setColor ~= nil then
		if nodeItemCfg.color.r and nodeItemCfg.color.g and nodeItemCfg.color.b then
			node:setColor(nodeItemCfg.color)
		else
			node:setColor(cc.c3b(nodeItemCfg.color[1], nodeItemCfg.color[2], nodeItemCfg.color[3]))
		end
	end
	if nodeItemCfg.opacity and node.setOpacity ~= nil then
		node:setOpacity(nodeItemCfg.opacity)
	end
	if nodeItemCfg.offset ~= nil then
		if nodeItemCfg.nodeImg and nodeItemCfg.nodeImg == "icon_saleRoom_symbol.png" then
			node:setPosition(cc.p(0, 5))
		else
			node:setPosition(nodeItemCfg.offset)
		end
	end
	if nodeItemCfg.zOrder ~= nil then
		node:setLocalZOrder(nodeItemCfg.zOrder)
	end
	if nodeItemCfg.glone == true then
		SoraDMixtureGLONE(node)
	end
end
function cityBuildNodeCreator:createNode_Sprite(nodeItem)
	local sprite
	local nodeImg = nodeItem.nodeImg and nodeItem.nodeImg or ""
	local spriteName = "#" .. nodeImg
	local isFromCache = true
	sprite = self:getNodeFromCache(nodeItem)
	if sprite == nil then
		isFromCache = false
		sprite = display.newSprite(spriteName)
	else
		sprite:setSpriteFrame(nodeImg)
		sprite:ignoreContentAdaptWithSize(true)
	end
	if nodeItem.isGray then
		sprite:setGrayed(nodeItem.isGray)
	end
	self:applyBaseAttributeToNode(sprite, nodeItem)
	return sprite, isFromCache
end
function cityBuildNodeCreator:createNode_Animation(nodeItem)
	local animNode
	local imgName = string.format(nodeItem.nodeFormat, nodeItem.nodeStart)
	local spriteName = "#" .. imgName
	local isFromCache = true
	animNode = self:getNodeFromCache(nodeItem)
	if animNode == nil then
		isFromCache = false
		animNode = display.newSprite(spriteName)
	else
		animNode:setSpriteFrame(imgName)
		animNode:ignoreContentAdaptWithSize(true)
	end
	local frames = display.newFrames(nodeItem.nodeFormat, nodeItem.nodeStart, nodeItem.nodeEnd)
	local actTime = nodeItem.actTime or 0.16666666666666666
	if nodeItem.nodeFormat == "bybubing_%02d.png" then
		actTime = 0.1
	end
	local delay = nodeItem.delay or 0
	local animation = display.newAnimation(frames, actTime)
	animNode:playAnimationForever(animation, delay)
	self:applyBaseAttributeToNode(animNode, nodeItem)
	return animNode, isFromCache
end
function cityBuildNodeCreator:createNode_Layout(nodeItem)
	local layout
	local isFromCache = true
	layout = self:getNodeFromCache(nodeItem)
	if layout == nil then
		isFromCache = false
		layout = ccui.Layout:create()
		layout:setAnchorPoint(cc.p(0.5, 0.5))
	end
	layout:setContentSize(cc.size(nodeItem.size[1], nodeItem.size[2]))
	if nodeItem.color ~= nil then
		layout:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
		layout:setBackGroundColor(nodeItem.color)
		if nodeItem.opacity ~= nil then
			layout:setBackGroundColorOpacity(nodeItem.opacity)
		end
	end
	self:applyBaseAttributeToNode(layout, nodeItem)
	return layout, isFromCache
end
function cityBuildNodeCreator:createNode_Text(nodeItem)
	local node
	local isFromCache = true
	node = self:getNodeFromCache(nodeItem)
	if node == nil then
		isFromCache = false
		node = ccui.Text:create()
	end
	if nodeItem.default then
		node:setString(nodeItem.default)
	end
	if nodeItem.fontSize then
		node:setFontSize(nodeItem.fontSize)
	end
	if nodeItem.hAlign then
		node:setTextHorizontalAlignment(nodeItem.hAlign)
	end
	if nodeItem.vAlign then
		node:setTextVerticalAlignment(nodeItem.vAlign)
	end
	self:applyBaseAttributeToNode(node, nodeItem)
	return node, isFromCache
end
function cityBuildNodeCreator:createNode_Action(nodeItem)
	local sprite
	local spriteName = "#" .. nodeItem.nodeImg
	local isFromCache = true
	sprite = self:getNodeFromCache(nodeItem)
	if sprite == nil then
		isFromCache = false
		sprite = display.newSprite(spriteName)
	else
		sprite:setSpriteFrame(nodeItem.nodeImg)
		sprite:ignoreContentAdaptWithSize(true)
	end
	self:applyBaseAttributeToNode(sprite, nodeItem)
	return sprite, isFromCache
end
function cityBuildNodeCreator:createNode_OwnAction(nodeItem)
	local action, isFromCache = self:createAction(nodeItem.actionKey)
	return action, isFromCache
end
function cityBuildNodeCreator:createNode_Spine(nodeItem)
	local spineNode = sp.SkeletonAnimation:create(string.format("spine/%s.skel", nodeItem.nodeImg), string.format("spine/%s.atlas", nodeItem.nodeImg), nodeItem.scale or 1)
	spineNode:setAnimation(0, "animation", true)
	self:applyBaseAttributeToNode(spineNode, nodeItem)
	return spineNode
end
function cityBuildNodeCreator:createNode_Particle(nodeItem)
	local particle = cc.ParticleSystemQuad:create("Particle/" .. nodeItem.particleFile)
	if nodeItem.positionType == "relative" then
		particle:setPositionType(cc.POSITION_TYPE_RELATIVE)
	elseif nodeItem.positionType == "free" then
		particle:setPositionType(cc.POSITION_TYPE_FREE)
	elseif nodeItem.positionType == "grouped" then
		particle:setPositionType(cc.POSITION_TYPE_GROUPED)
	end
	self:applyBaseAttributeToNode(particle, nodeItem)
	return particle
end
function cityBuildNodeCreator:createAction(actionKey, ...)
	local createFunc = "createAction" .. "_" .. actionKey
	return self[createFunc](self, ...)
end
function cityBuildNodeCreator:createAction_zAction(...)
	local pointOri = (...)
	local offsetX = 50
	local offsetY = 40
	local _ENV, actionSeq1
	do
		local actionMoveTo = cca.moveTo(0, pointOri.x, pointOri.y)
		local actionFadeTo = cca.fadeTo(0, 1)
		local actionRotateTo = cca.rotateTo(0, 0)
		local actionMoveBy = cca.moveBy(1.6, offsetX, offsetY)
		local actionFadeTo2 = cca.fadeTo(1.6, 0.5)
		local actionRotateBy = cca.rotateBy(1.6, 30)
		_UPVALUE3_ = 30
		;(30)[1] = actionMoveBy
		;(30)[2] = actionFadeTo2
		;(30)[3] = actionRotateBy
		local actionSpawn = cca.spawn(30)
		_UPVALUE4_ = actionMoveBy
		actionMoveBy[1] = actionMoveTo
		actionMoveBy[2] = actionFadeTo
		actionMoveBy[3] = actionRotateTo
		actionMoveBy[4] = actionSpawn
		actionSeq1 = cca.seq(actionMoveBy)
	end
	local actionDelay1 = cca.delay(0.2)
	_UPVALUE3_ = cca.rotateTo(0, 0)
	_UPVALUE2_ = 0
	;(0)[1] = cca.moveBy(1.6, offsetX, offsetY)
	;(0)[2] = cca.fadeTo(1.6, 0.5)
	;(0)[3] = cca.rotateBy(1.6, -30)
	;(0)[4] = cca.rotateBy(1.6, -30)
	;(0)[5] = cca.rotateBy(1.6, -30)
	;(0)[6] = cca.rotateBy(1.6, -30)
	;(0)[7] = cca.rotateBy(1.6, -30)
	cca.rotateTo(0, 0)[1] = cca.moveTo(0.0, pointOri.x, pointOri.y)
	cca.rotateTo(0, 0)[2] = cca.fadeTo(0, 1)
	cca.rotateTo(0, 0)[3] = cca.rotateTo(0, 0)
	cca.rotateTo(0, 0)[4] = cca.spawn(0)
	cca.rotateTo(0, 0)[5] = cca.spawn(0)
	cca.rotateTo(0, 0)[6] = cca.spawn(0)
	cca.rotateTo(0, 0)[7] = cca.spawn(0)
	cca.rotateTo(0, 0)[8] = cca.spawn(0)
	cca.rotateTo(0, 0)[9] = cca.spawn(0)
	cca.rotateTo(0, 0)[10] = cca.spawn(0)
	cca.rotateTo(0, 0)[11] = cca.spawn(0)
	cca.rotateTo(0, 0)[12] = cca.spawn(0)
	local actionSeq2 = cca.seq((cca.rotateTo(0, 0)))
	local actionDelay2 = cca.delay(0.2)
	_UPVALUE3_ = cca.fadeTo(0, 1)
	_UPVALUE2_ = 0
	;(0)[1] = cca.moveBy(1.6, offsetX, offsetY)
	;(0)[2] = cca.fadeTo(1.6, 0.0)
	;(0)[3] = cca.rotateBy(1.6, 30)
	;(0)[4] = cca.rotateBy(1.6, 30)
	;(0)[5] = cca.rotateBy(1.6, 30)
	cca.fadeTo(0, 1)[1] = cca.moveTo(0.0, pointOri.x, pointOri.y)
	cca.fadeTo(0, 1)[2] = cca.fadeTo(0, 1)
	cca.fadeTo(0, 1)[3] = cca.rotateTo(0, 0)
	cca.fadeTo(0, 1)[4] = cca.spawn(0)
	cca.fadeTo(0, 1)[5] = cca.spawn(0)
	cca.fadeTo(0, 1)[6] = cca.spawn(0)
	cca.fadeTo(0, 1)[7] = cca.spawn(0)
	cca.fadeTo(0, 1)[8] = cca.spawn(0)
	cca.fadeTo(0, 1)[9] = cca.spawn(0)
	cca.fadeTo(0, 1)[10] = cca.spawn(0)
	local actionSeq3 = cca.seq((cca.fadeTo(0, 1)))
	local actionDelay3 = cca.delay(3.8)
	_UPVALUE6_ = cca.fadeTo(0, 1)
	cca.fadeTo(0, 1)[1] = actionSeq1
	cca.fadeTo(0, 1)[2] = actionDelay1
	cca.fadeTo(0, 1)[3] = actionSeq2
	cca.fadeTo(0, 1)[4] = actionDelay2
	cca.fadeTo(0, 1)[5] = actionSeq3
	cca.fadeTo(0, 1)[6] = actionDelay3
	local actionSeq4 = cca.seq((cca.fadeTo(0, 1)))
	local actionRepeat = cca.repeatForever(actionSeq4)
	return actionRepeat
end
function cityBuildNodeCreator:createAction_topTipEffect(...)
	local rotateByRight = cca.rotateBy(0.1, 15)
	local rotateByToLeft = cca.rotateBy(0.2, -30)
	local rotateBack = cca.rotateBy(0.1, 15)
	local rotateByRight2 = cca.rotateBy(0.08, 8)
	local rotateByToLeft2 = cca.rotateBy(0.16, -16)
	local rotateBack2 = cca.rotateBy(0.08, 8)
	local rotateByRight3 = cca.rotateBy(0.05, 5)
	local rotateByToLeft3 = cca.rotateBy(0.1, -10)
	local rotateBack3 = cca.rotateBy(0.05, 5)
	local delayTime = cca.delay(2.5)
	_UPVALUE10_ = nil
	;(nil)[1] = rotateByRight
	;(nil)[2] = rotateByToLeft
	;(nil)[3] = rotateBack
	;(nil)[4] = rotateByRight2
	;(nil)[5] = rotateByToLeft2
	;(nil)[6] = rotateBack2
	;(nil)[7] = rotateByRight3
	;(nil)[8] = rotateByToLeft3
	;(nil)[9] = rotateBack3
	;(nil)[10] = delayTime
	local seqA = cca.seq(nil)
	local repeatA = cca.repeatForever(seqA)
	return repeatA
end
function cityBuildNodeCreator:createAction_Glow(...)
	local actionFadeTo = cca.fadeTo(0.7, 0.5)
	local actionDelay = cca.delay(0.4)
	local actionFadeBack = cca.fadeTo(0.8, 1)
	_UPVALUE3_ = nil
	;(nil)[1] = actionFadeTo
	;(nil)[2] = actionDelay
	;(nil)[3] = actionFadeBack
	local actionRepeat = cca.repeatForever(cca.seq(nil))
	return actionRepeat
end
function cityBuildNodeCreator:createNode_Csd(nodeItem)
	local effectNode = SoraDCreatAnimation(nodeItem.csdName)
	self:applyBaseAttributeToNode(effectNode, nodeItem)
	return effectNode
end
function cityBuildNodeCreator:recycleNode(nodeItems)
	if nodeItems == nil then
		return
	end
	for k, v in pairs(nodeItems) do
		for _, node in ipairs(v) do
			if k == "sprite" or k == "animation" or k == "layout" or k == "text" or k == "action" then
				if not tolua.isnull(node) then
					if node.setSpriteFrame then
						node:setSpriteFrame(nil)
					end
					instanceCacheMgr.addNormalNodeByType(node, "cityBuildNode" .. k)
					node:removeFromParent(false)
				end
			elseif node.removeFromParent then
				node:removeFromParent()
			end
		end
	end
end
return cityBuildNodeCreator
