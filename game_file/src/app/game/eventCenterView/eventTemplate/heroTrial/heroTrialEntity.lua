local heroTrialCommon = include("heroTrialCommon")
local heroTrialEntity = class("heroTrialEntity", function()
	return cc.Node:create()
end)
function heroTrialEntity:ctor()
	self.isCurLevel = false
	self.node = nil
	self.levelBg = nil
	self.attackFlag = nil
	_UPVALUE0_, self.occupyFlag = nil, nil
	;(nil).lock = 1
	;(nil).unlock = 2
	;(nil).attack = 3
	self.state, (nil).occupy = nil, 4
	self.curState = self.state.lock
end
function heroTrialEntity:initData(data, levelBg, levelId, curMap)
	self.levelBg = levelBg
	self.typeName = data.typeName
	self.levelId = levelId
	self.curMap = curMap
	self.data = data
	if data.typeName == "city" then
		self.node = worldMapDefine.createCityImageWithLevel(data.data)
	elseif data.typeName == "animation" then
		self.node = display.newSprite("#" .. data.data .. "_01.png")
		self.animationData = util.split(data.data, "_")
	elseif data.typeName == "sprite" then
		self.node = display.newSprite("#" .. data.data)
	end
	self.scaleX = math.abs(data.scaleX)
	self.scaleY = math.abs(data.scaleY)
	self.node:setScaleX(self.scaleX)
	self.node:setScaleY(self.scaleY)
	self.node:setFlippedX(data.flipX)
	if not data.flipX and data.scaleX < 0 then
		self.node:setFlippedX(true)
	end
	self.node.levelId = levelId
	self:setPosition(data.pos)
	self:addChild(self.node)
	local rect = self.node:getTextureRect()
	local offset = self.node:getOffsetPosition()
	self.size = self.node:getContentSize()
	self.topPos = cc.p(self.size.width / 2, offset.y + rect.height)
	local cityRects = require("app." .. LocalTblPath .. ".config_client.heroTrialCityRect")
	local rectdata = cityRects[data.data]
	if rectdata then
		self.touchLayer = cc.Node:create()
		self.touchLayer:setPosition(cc.p(rectdata.x, rectdata.y))
		self.touchLayer:setContentSize(cc.size(rectdata.width, rectdata.height))
		self.node:addChild(self.touchLayer)
		local layerSize = self.touchLayer:getContentSize()
		local layerPos = cc.p(self.touchLayer:getPosition())
		self.topPos.y = layerPos.y + layerSize.height + 10
		if rectdata.offsetX then
			self.topPos.x = self.topPos.x + rectdata.offsetX
		end
	end
end
function heroTrialEntity:updateState()
	if self.levelId == nil or self.curMap == nil or self.curMap.curUnlockId == nil then
		return
	end
	if self.levelId > self.curMap.curUnlockId then
		self.curState = self.state.lock
	else
		self.curState = self.state.unlock
	end
	if self.curState == self.state.unlock then
		if self.levelId < self.curMap.curStageId then
			self.curState = self.state.occupy
		elseif self.levelId == self.curMap.curStageId then
			self.curState = self.state.attack
		end
		if self.levelId == self.curMap.curStageId and self.curMap.isMapWin then
			self.curState = self.state.occupy
		end
	end
	if self.stateNode and self.stateNode.state == self.curState then
		return
	end
	if not tolua.isnull(self.stateNode) then
		self.stateNode:removeFromParent()
	end
	self.stateNode = nil
	if not tolua.isnull(self.stateNode1) then
		self.stateNode1:removeFromParent()
	end
	self.stateNode1 = nil
	local num = heroTrialCommon.convertLevelToNum(self.levelId)
	if num % 10 == 5 then
		self.levelBg:loadTexture("title_herotrial_02.png", ccui.TextureResType.plistType)
	elseif num % 10 == 0 then
		self.levelBg:loadTexture("title_herotrial_03.png", ccui.TextureResType.plistType)
	else
		self.levelBg:loadTexture("title_herotrial_01.png", ccui.TextureResType.plistType)
	end
	local pos, pos1
	if self.curState == self.state.lock then
		self.stateNode = self.levelBg:clone()
		local levelText = SoraDGetChildByName(self.stateNode, "levelText")
		_ENV = nil
		;(nil).level = num
		levelText:setString(i18n("common_text_1721", nil))
		pos = self.topPos
	elseif self.curState == self.state.unlock then
		self.stateNode = self.levelBg:clone()
		local levelText = SoraDGetChildByName(self.stateNode, "levelText")
		_ENV = i18n("common_text_1721", nil)
		i18n("common_text_1721", nil).level = num
		levelText:setString(i18n("common_text_1721", i18n("common_text_1721", nil)))
		pos = self.topPos
	elseif self.curState == self.state.attack then
		self.stateNode = self.levelBg:clone()
		local levelText = SoraDGetChildByName(self.stateNode, "levelText")
		_ENV = i18n("common_text_1721", i18n("common_text_1721", nil))
		i18n("common_text_1721", i18n("common_text_1721", nil)).level = num
		levelText:setString(i18n("common_text_1721", i18n("common_text_1721", i18n("common_text_1721", nil))))
		pos = self.topPos
		self.stateNode1 = SoraDGetFightingEffect()
		pos1 = cc.p(self.topPos.x, self.topPos.y + 50)
	elseif self.curState == self.state.occupy then
		self.stateNode = cc.uiloader:load(getCCSPath("heroTrialOccupyFx"))
		pos = self.topPos
		local winAr = SoraDGetChildByName(self.stateNode, "winAr")
		local winEn = SoraDGetChildByName(self.stateNode, "winEn")
		if SoraDFIsRA() then
			winAr:setVisible(true)
			winEn:setVisible(false)
			if userSDKManager.getChannel() == "fa" then
				winAr:setSpriteFrame("icon_herotrial_victory_fa.png")
			end
		else
			winAr:setVisible(false)
			winEn:setVisible(true)
		end
	end
	if self.stateNode then
		self.stateNode.state = self.curState
		pos = cc.p(self:getContentSize().width / 2, 50)
		self.stateNode:setPosition(pos)
		self.stateNode:addTo(self, 1001)
	end
	if self.stateNode1 then
		pos1 = cc.p(self:getContentSize().width / 2, 100)
		self.stateNode:setPosition(pos1)
		self.stateNode:addTo(self, 1001)
	end
end
function heroTrialEntity:idle()
	self:updateState()
	if (self.typeName == "city" or self.typeName == "sprite") and self.fireNode then
		self.fireNode:removeFromParent(true)
		self.fireNode = nil
	elseif self.typeName == "animation" then
		self.node:stopAllActions()
		local frames = display.newFrames(self.animationData[1] .. "_dj_" .. self.animationData[3] .. "_0%d.png", 1, 8)
		local animation = display.newAnimation(frames, 0.15)
		self.node:playAnimationForever(animation)
	end
end
function heroTrialEntity:dead()
	self:updateState()
	if (self.typeName == "city" or self.typeName == "sprite") and self.fireNode then
		self.fireNode:removeFromParent(true)
		self.fireNode = nil
	elseif self.typeName == "animation" then
		self.node:stopAllActions()
		local frames = display.newFrames(self.animationData[1] .. "_sw_ws" .. "_0%d.png", 1, 8)
		local animation = display.newAnimation(frames, 0.125)
		self.node:playAnimationOnce(animation)
	end
end
function heroTrialEntity:deadEnd()
	self:updateState()
	if (self.typeName == "city" or self.typeName == "sprite") and self.fireNode then
		self.fireNode:removeFromParent(true)
		self.fireNode = nil
	elseif self.typeName == "animation" then
		self.node:stopAllActions()
		self.node:setSpriteFrame(self.animationData[1] .. "_sw_ws" .. "_08.png")
	end
end
function heroTrialEntity:attack()
	self:updateState()
	SoraDPlaySound("worldmap", 3)
	if self.typeName == "animation" then
		self.node:stopAllActions()
		self:monsterFightingAnimation(self.node, self.animationData[1], self.animationData[3])
	elseif self.typeName == "city" or self.typeName == "sprite" then
		_ENV, _ENV = self, self.typeName
		_ENV, self.plist = self.node, "et_castle_attack_yan_01.plist"
		self.node.x = 0.74
		_ENV, self.typeName[1], self.scale, self.node.y = self, self, self.node, 0.74
		_ENV, self.plist = self.node, "et_castle_attack_yan_02.plist"
		self.node.x = -11.82
		_ENV, self.pos, self.node.y = self.node, self.node, -2.1
		self.node.x = 1.27
		self.typeName[2], self.scale, self.node.y = self, self.node, 1.15
		local param = self.typeName
		self.fireNode = SoraDCreateEffectNode(param)
		self.fireNode:setPosition(cc.p(self.size.width / 2, self.size.height / 2))
		self.node:addChild(self.fireNode)
	end
end
function heroTrialEntity:cityFightAnimation()
	local x, y = self:getPosition()
	local beginPoint = cc.p(x, y + 30)
	local endPoint = cc.p(0, 0)
	local angle = SoraDGetAngleByPos(beginPoint, endPoint)
	local radius = 80
	for index = 1, 45 do
		local bulletSprite = display.newSprite("#icon_battle_jian_4.png")
		local randomPointX = math.random(-20, 20)
		local randomPointY = math.random(-20, 20)
		local randomAngle = math.random(-50, 50)
		local randomDistence = radius + math.random(-30, 30)
		local newAngle = angle + randomAngle
		local radian = math.angle2radian(newAngle)
		local pointX = randomDistence * math.cos(radian)
		local pointY = randomDistence * math.sin(radian)
		local point1 = cc.p(randomPointX, randomPointY)
		local point2 = cc.p(pointX, pointY)
		bulletSprite:setPosition(point1)
		bulletSprite:setScale(0.5)
		self:addChild(bulletSprite, 1)
		local delayTime = math.random(0, 5) / 10
		worldMapFunction.createThrowAction(bulletSprite, point1, point2, delayTime)
	end
	local _ENV, actionsArray = (for index), 1
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(3.0)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		self:cityFightAnimation()
	end)
	local actions = transition.sequence(actionsArray)
	self:runAction(actions)
end
function heroTrialEntity:monsterFightingAnimation(monster, monsterName, monsterDir)
	local frames = display.newFrames(monsterName .. "_gj_" .. monsterDir .. "_0%d.png", 1, 8)
	local animation = display.newAnimation(frames, 0.15)
	monster:playAnimationOnce(animation)
	local index = worldMapDefine.getBeginAnimationByName(monsterName)
	local _ENV, actionsArray = monsterName, monsterName
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(0.1 * index)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		self:addFightEffect(monsterName, monsterDir)
	end)
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(1.2 - 0.1 * index)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		self:monsterFightingAnimation(monster, monsterName, monsterDir)
	end)
	local actions = transition.sequence(actionsArray)
	monster:runAction(actions)
end
function heroTrialEntity:addFightEffect(monsterName, monsterDir)
	local effectSource = worldMapDefine.getEffectByNameAndDir(monsterName, monsterDir)
	if effectSource and next(effectSource) then
		if monsterName == "mny" then
			if self:getChildByName("sp_mny") then
				self:removeChildByName("sp_mny", true)
			end
			local sp_mny = display.newSprite("#et_mny_attack_" .. monsterDir .. "_01.png")
			sp_mny:setPosition(cc.p(effectSource.x, effectSource.y))
			sp_mny:setName("sp_mny")
			sp_mny:setFlippedX(self.fightingIsFlipX)
			self:addChild(sp_mny, 5)
			local frames = display.newFrames("et_mny_attack_" .. monsterDir .. "_%.2d.png", 1, 2)
			local animation = display.newAnimation(frames, 0.15)
			sp_mny:playAnimationOnce(animation, 0.6)
		else
			local et_node = self:getChildByName("attackNode")
			if et_node then
				SoraDResetEffectNode(et_node)
			else
				local attackNode = SoraDCreateEffectNode(effectSource)
				attackNode:setName("attackNode")
				local scaleX = 1
				local moveY = 1
				if self.node:isFlippedX() then
					scaleX = -1
				end
				if monsterDir == "ws" then
					moveY = -1
				end
				attackNode:setScaleX(scaleX)
				self:addChild(attackNode, 5)
				if monsterName == "b" then
					attackNode:runAction(cca.moveBy(0.5, -50 * scaleX, 50 * moveY))
				end
			end
		end
	end
end
function heroTrialEntity:hitTest(pos)
	local node
	if self.touchLayer then
		node = self.touchLayer
	else
		node = self.node
	end
	return util.hitTest(node, pos)
end
return heroTrialEntity
