local baseComponent = require("fgui.base.baseComponent")
local Com_9001676_game = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001676_Read = include("activity_9001676_Read")
local activity_9001676_Ctrl = SoraDGetCtrl("activity_9001676_Ctrl")
fgui.register_extension("ui://Activity_9001676/Com_9001676_game", Com_9001676_game)
local Activity_9001676_AI = require("fgui.gcomponent.Activity_9001676.Activity_9001676_AI")
_ENV = "fgui.gcomponent.Activity_9001676.Activity_9001676_AI"
;("fgui.gcomponent.Activity_9001676.Activity_9001676_AI").WHITE = 0
;("fgui.gcomponent.Activity_9001676.Activity_9001676_AI").BLACK = 1
;("fgui.gcomponent.Activity_9001676.Activity_9001676_AI").RED = 2
;("fgui.gcomponent.Activity_9001676.Activity_9001676_AI").STRIKER = 3
local _ENV, ("fgui.gcomponent.Activity_9001676.Activity_9001676_AI").BOARD, COIN_TAG = Com_9001676_game, 4, "fgui.gcomponent.Activity_9001676.Activity_9001676_AI"
Com_9001676_game.P1 = 0
local _ENV, Com_9001676_game.P2, PLAYER = nil, 1, Com_9001676_game
;(nil).SINGLE_ONE = 1
;(nil).SINGLE_FIVE = 5
;(nil).MATCH = 2
local (nil).ROOM, PLAY_MODE = 3, nil
local GUIDE_ACTION = 965
_UPVALUE18_ = nil
;(nil)[1] = "RedCoin"
;(nil)[2] = "WhiteCoin9"
;(nil)[3] = "BlackCoin9"
;(nil)[4] = "WhiteCoin8"
;(nil)[5] = "BlackCoin2"
;(nil)[6] = "WhiteCoin7"
;(nil)[7] = "BlackCoin7"
;(nil)[8] = "WhiteCoin4"
;(nil)[9] = "BlackCoin3"
;(nil)[10] = "WhiteCoin5"
;(nil)[11] = "BlackCoin5"
;(nil)[12] = "WhiteCoin2"
;(nil)[13] = "BlackCoin6"
;(nil)[14] = "WhiteCoin6"
;(nil)[15] = "BlackCoin1"
;(nil)[16] = "WhiteCoin3"
;(nil)[17] = "BlackCoin4"
;(nil)[18] = "WhiteCoin1"
local (nil)[19], searchPos = "BlackCoin8", nil
local MinMagnitudeVelocity = 20
function Com_9001676_game:onInit()
	self.boardFields = fguiHelper.get_fields(self.fields.Com_9001676_Board)
	self.striker = self.boardFields.Striker
	self.striker:setTag(COIN_TAG.STRIKER)
	self.redCoin = self.boardFields.RedCoin
	self.redCoin:setTag(COIN_TAG.RED)
	self.coinR = self.redCoin:getSize().width / 2 - 1
	self.strikerR = self.striker:getSize().width / 2
	self.strikerPos = self.fields.StrikerPos
	self.strikerPos:addTouchEventListener(handler(self, self.onStrikePosEvent))
	self.minStrikeX = self.fields.StrikerRect:getX() + 20
	self.maxStrikeX = self.minStrikeX + self.fields.StrikerRect:getWidth() - 35
	self.striker:setGameComp(self)
end
function Com_9001676_game:onHide()
	self.physicsWorld:removeTrueSyncManager()
end
function Com_9001676_game:onShow()
	self.physicsWorld = cc.Director:getInstance():getRunningScene():getTSPhysicsWorld()
	self.physicsWorld:createTrueSyncManager()
	self.holePositions, _ENV, self.blackCoins, _ENV, self.whiteCoins, _ENV, self.boards, _ENV, self.searchCenterPos, _ENV, self.allCoins, _ENV = self.physicsWorld.createTrueSyncManager, self.physicsWorld.createTrueSyncManager, self.physicsWorld.createTrueSyncManager, self.physicsWorld.createTrueSyncManager, self.physicsWorld.createTrueSyncManager, self.physicsWorld.createTrueSyncManager, self.physicsWorld.createTrueSyncManager, self.physicsWorld.createTrueSyncManager, self.physicsWorld.createTrueSyncManager, self.physicsWorld.createTrueSyncManager, self.physicsWorld.createTrueSyncManager, self.physicsWorld.createTrueSyncManager
	table.insert(self.allCoins, self.redCoin)
	for i = 1, 9 do
		self.whiteCoins[i] = self.boardFields["WhiteCoin" .. i]
		self.whiteCoins[i]:setTag(COIN_TAG.WHITE)
		self.blackCoins[i] = self.boardFields["BlackCoin" .. i]
		self.blackCoins[i]:setTag(COIN_TAG.BLACK)
		table.insert(self.allCoins, self.whiteCoins[i])
		table.insert(self.allCoins, self.blackCoins[i])
	end
	for i = 1, 4 do
		self.boards[i] = self.boardFields["board" .. i]
		local box = cc.TSPhysicsBody:createBox(self.boards[i]:getSize(), nil, cc.p(self.boards[i]:getSize().width / 2, -self.boards[i]:getSize().height / 2))
		box:setDynamic(false)
		box:getShape(0):setFriction(0)
		box:getShape(0):setRestitution(1.0)
		box:setCollisionDetectionMode(true)
		self.boards[i]:setTag(COIN_TAG.BOARD)
		self.boards[i]:setTSPhysicsBody(box)
	end
	for i, v in ipairs(self.allCoins) do
		local circle = cc.TSPhysicsBody:createCircle(self.coinR, nil, cc.p(0.5, 0.5))
		circle:setMass(1)
		circle:setCollisionDetectionMode(true)
		circle:getShape(0):setFriction(0)
		circle:getShape(0):setRestitution(1.0)
		circle:setDynamic(true)
		v:setTSPhysicsBody(circle)
		circle:setLinearDamping(2)
		circle:setCollisionEventCallback(handler(self, self.onBallCollisionEventCallback))
		v.physicsBody = circle
	end
	for i = 1, 4 do
		local v = self.boardFields["Hole" .. i]
		local circle = cc.TSPhysicsBody:createCircle(v:getWidth() / 2, nil, cc.p(0.5, 0.5))
		circle:setCollisionDetectionMode(true)
		v:setTSPhysicsBody(circle)
		circle:setTriggerEventCalback(handler(self, self.onHoleTriggerEventCallback))
		circle:setDynamic(false)
		circle:getShape(0):setTrigger(true)
		circle:updateTransform2D()
		table.insert(self.holePositions, v:getPosition())
		self.boardFields["Hole" .. i .. "_Ani"]:setVisible(false)
	end
	for i, v in ipairs(searchPos) do
		table.insert(self.searchCenterPos, self.boardFields[v]:getPosition())
	end
	self:initPhysics()
end
function Com_9001676_game:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001676_UPDATE", handler(self, self.onUpdateData))
end
function Com_9001676_game:onUpdateData(target, data)
	if data.msgType == "Shot" and data.data and type(data.data) == "string" then
		self:stopGuideTips()
		local strs = string.split(data.data, ",")
		local pos = cc.p(tonumber(strs[1]), tonumber(strs[2]))
		local velocity = cc.p(tonumber(strs[3]), tonumber(strs[4]))
		self.striker:onReqFireSuccess(pos, velocity, data.isNotify)
	end
end
function Com_9001676_game:setRotateBoard(myPlayer)
	self.isRotatedBoard = myPlayer ~= PLAYER.P1
	if self.isRotatedBoard then
		self.fields.Com_9001676_Board:setRotation(180)
	end
end
function Com_9001676_game:startGame(playMode, myPlayer)
	self.isInGame = true
	local isAI = playMode == PLAY_MODE.SINGLE_ONE or playMode == PLAY_MODE.SINGLE_FIVE
	self.isAIPlayer = isAI
	self.player = PLAYER.P1
	self.lastPlayer = self.player
	self.myPlayer = myPlayer
	self.p1Color = nil
	self.p2Color = nil
	self.isP1OneShotClear = not activity_9001676_Ctrl:getIsOneShotClear()
	PLAY_MODE, self.isP2OneShotClear = not activity_9001676_Ctrl:getIsOneShotClear(), not activity_9001676_Ctrl:getIsOneShotClear()
	;(not activity_9001676_Ctrl:getIsOneShotClear())[COIN_TAG.WHITE] = 9
	self.goalCoins, PLAY_MODE, self.coinCount, (not activity_9001676_Ctrl:getIsOneShotClear())[COIN_TAG.BLACK] = not activity_9001676_Ctrl:getIsOneShotClear(), not activity_9001676_Ctrl:getIsOneShotClear(), not activity_9001676_Ctrl:getIsOneShotClear(), 9
	PLAY_MODE = COIN_TAG.BLACK
	COIN_TAG.BLACK.nextPlayer = self.player
	self.hitResultCallback(COIN_TAG.BLACK)
	self:beginTime()
end
function Com_9001676_game:initPhysics(...)
	self.physicsWorld:setAutoStep(false)
end
function Com_9001676_game:beginTime()
	self.delayFrame = 20
	self:stopTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime), true)
	self:updateTime(0.0)
end
function Com_9001676_game:stopTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
end
function Com_9001676_game:updateTime(dt)
	local count = math.ceil(dt / 0.016666666666666666)
	if not self.isInGame then
		return
	end
	for i = 1, count do
		local isInMinVelocity = self.striker:updateTime()
		if isInMinVelocity and self.isWaitingShotEnd then
			local isAllCoinInMinVelocity = true
			for i, v in ipairs(self.allCoins) do
				local value = v:isVisible() and v.physicsBody and v.physicsBody:getVelocityMagnitude() or 0
				if value >= MinMagnitudeVelocity then
					isAllCoinInMinVelocity = false
				end
				if value < MinMagnitudeVelocity and value ~= 0 then
					v.physicsBody:resetCPBody()
				end
			end
			if isAllCoinInMinVelocity then
				self:shotEnd()
			end
		end
		self.striker.physicsBody:updateTransform2D()
		for i, v in ipairs(self.allCoins) do
			if v.physicsBody then
				v.physicsBody:updateTransform2D()
			end
		end
		if 0 >= self.delayFrame then
			self.physicsWorld:step(0)
		end
		self.delayFrame = self.delayFrame - 1
	end
	if self.isSearchingAIStrikerPos then
		self.AISearchingCount = self.AISearchingCount + 1
		if self.striker.isCanFire or self.AISearchingCount >= 240 then
			_UPVALUE2_ = count
			count[1] = self.striker.isCanFire
			count[2] = self.AISearchingCount
			dump(count, "self.striker.isCanFire, self.AISearchingCount")
			self:searchAITarget()
		else
			self.AIStrikerPos.x = self.AIStrikerPos.x + 2
			if self.AIStrikerPos.x > self.maxStrikeX then
				self.AIStrikerPos.x = self.minStrikeX
				self.striker:setPositionX(self.AIStrikerPos.x)
				self.striker.physicsBody:updateTransform2D()
			end
		end
	end
end
function Com_9001676_game:onStrikePosEvent(target, eventType)
	if self.striker.fired or not self.isMyTurn then
		return
	end
	if eventType == ccui.TouchEventType.began then
		self.strikerPos:setPositionX(math.floor(self.striker:getX()))
		self:stopGuideTips()
	elseif eventType == ccui.TouchEventType.moved then
		local touchMovePos = target:getTouchMovePosition()
		touchMovePos = target:getParent():convertToNodeSpace(touchMovePos)
		local x = math.floor(math.clamp(touchMovePos.x, self.minStrikeX, self.maxStrikeX))
		self.strikerPos:setPositionX(x)
		x = self.isRotatedBoard and 610 - x or x
		self.striker:setPositionX(x)
	else
		self:startShowGuideAction()
	end
end
function Com_9001676_game:onBallCollisionEventCallback(eventType, name, name2, relativeVelocityMagnitude)
	if eventType == fgui.PhysicsEvent.CollisionEnter and 150 < relativeVelocityMagnitude then
		SoraDPlaySound("activity_9001676", "krone_strike")
	end
end
function Com_9001676_game:onHoleTriggerEventCallback(eventType, name, triggerName)
	if eventType == fgui.PhysicsEvent.TriggerEnter then
		if not self.goalCoins then
			_ENV = self.goalCoins
		end
		self.goalCoins = self.goalCoins
		local holeCoin = self.boardFields[name]
		local tag = holeCoin:getTag()
		if tag == COIN_TAG.BOARD then
			return
		elseif tag == COIN_TAG.STRIKER then
			return
		else
			table.insert(self.goalCoins, holeCoin)
		end
		self.boardFields[name].physicsBody:resetCPBody()
		self.boardFields[name].physicsBody:getShape(0):setTrigger(true)
		self.boardFields[name]:setVisible(false)
		self.boardFields[triggerName .. "_Ani"]:setAllFrameNameOnce("G_9001676_boom_%02d.png", 1, false)
	end
end
function Com_9001676_game:genPenaltyCoin(addCoinTag)
	local usefulPos = self:searchUsefulPos() or self.searchCenterPos[1]
	self.redCoin:updateXYByDisplayObject()
	self.redCoin.physicsBody:resetCPBody()
	self.redCoin:setPosition(usefulPos)
	self.redCoin:setVisible(true)
	self.redCoin.physicsBody:getShape(0):setTrigger(false)
	if addCoinTag == nil then
		return
	end
	local coins = addCoinTag == COIN_TAG.WHITE and self.whiteCoins or self.blackCoins
	local addCoin
	for i, v in ipairs(coins) do
		if not v:isVisible() then
			addCoin = v
			break
		end
	end
	if addCoin == nil then
		return
	end
	usefulPos = self:searchUsefulPos() or self.searchCenterPos[2]
	addCoin:updateXYByDisplayObject()
	addCoin.physicsBody:resetCPBody()
	addCoin:setPosition(usefulPos)
	addCoin:setVisible(true)
	addCoin.physicsBody:getShape(0):setTrigger(false)
end
function Com_9001676_game:searchUsefulPos()
	local usefulPos
	for _, pos in ipairs(self.searchCenterPos) do
		local isCanUse = true
		for _, v in ipairs(self.allCoins) do
			if v:isVisible() then
				local coinPos = v:getPosition()
				local distance = cc.pGetDistance(pos, coinPos)
				if distance < 30 then
					isCanUse = false
					break
				end
			end
		end
		if isCanUse then
			usefulPos = pos
			break
		end
	end
	dump(usefulPos, "Com_9001676_game:searchUsefulPos")
	return usefulPos
end
function Com_9001676_game:shotEnd(isTimeUp)
	if not self.isInGame then
		return
	end
	local nextPlayer = self.player
	local isGameOver = false
	local rightCoinTag = self.player == PLAYER.P1 and self.p1Color or self.p2Color
	local isGenPenaltyCoin = false
	local genPenaltyCoinTag
	if not isTimeUp then
		for i, v in ipairs(self.allCoins) do
			v.physicsBody:resetCPBody()
		end
		local isRedCoinGoal = false
		local isPlayerRightGoal = false
		for i, v in ipairs(self.goalCoins) do
			local tag = v:getTag()
			if tag == COIN_TAG.RED then
				isRedCoinGoal = true
				if rightCoinTag and self.coinCount[rightCoinTag] <= 0 then
					isGameOver = true
					break
				end
			else
				if self.p1Color == nil then
					if self.player == PLAYER.P1 then
						self.p1Color = tag
						self.p2Color = (tag + 1) % 2
					else
						self.p2Color = tag
						self.p1Color = (tag + 1) % 2
					end
					rightCoinTag = self.player == PLAYER.P1 and self.p1Color or self.p2Color
					isPlayerRightGoal = true
				end
				if not isPlayerRightGoal and tag == rightCoinTag then
					isPlayerRightGoal = true
				end
				self.coinCount[tag] = self.coinCount[tag] - 1
				if isRedCoinGoal and self.coinCount[tag] <= 0 then
					isGameOver = true
				end
			end
		end
		self.goalCoins, PLAYER = ipairs(self.goalCoins)
		if isGameOver then
			self:stopTime()
			self.isInGame = false
		else
			if isRedCoinGoal then
				isGenPenaltyCoin = true
				if rightCoinTag and self.coinCount[rightCoinTag] < 9 then
					genPenaltyCoinTag = rightCoinTag
					self.coinCount[rightCoinTag] = self.coinCount[rightCoinTag] + 1
				end
			end
			if isRedCoinGoal or not isPlayerRightGoal then
				nextPlayer = (self.player + 1) % 2
			end
		end
	else
		nextPlayer = (self.player + 1) % 2
	end
	PLAYER = self.player + 1
	;(self.player + 1).p1Color = self.p1Color
	;(self.player + 1).p2Color = self.p2Color
	;(self.player + 1).coinCount = self.coinCount
	;(self.player + 1).nextPlayer = nextPlayer
	;(self.player + 1).isGameOver = isGameOver
	local (self.player + 1).isMyTurn, resultData = self.isMyTurn, self.player + 1
	local PLAYER, PLAYER, winPlayer = self.coinCount[rightCoinTag] + 1, self.player + 1, isGameOver and self.player or nil
	;(self.coinCount[rightCoinTag] + 1).queen = winPlayer == PLAYER.P1 and 1 or 0
	PLAYER, (self.player + 1).host, (self.coinCount[rightCoinTag] + 1).normal = self.coinCount[rightCoinTag] + 1, self.coinCount[rightCoinTag] + 1, self.p1Color and 9 - self.coinCount[self.p1Color] or 0
	;(self.coinCount[rightCoinTag] + 1).queen = winPlayer == PLAYER.P2 and 1 or 0
	;(self.player + 1).guest, (self.coinCount[rightCoinTag] + 1).normal = self.coinCount[rightCoinTag] + 1, self.p2Color and 9 - self.coinCount[self.p2Color] or 0
	;(self.player + 1).nextPlayer = nextPlayer
	;(self.player + 1).gameOver = isGameOver
	;(self.player + 1).isGenPenaltyCoin = isGenPenaltyCoin
	local (self.player + 1).genPenaltyCoinTag, msgData = genPenaltyCoinTag, self.player + 1
	if isGameOver then
		if self.player == PLAYER.P1 and self.isP1OneShotClear then
			msgData.oneShotClear = true
		elseif self.player == PLAYER.P2 and self.isP2OneShotClear and not self.isAIPlayer then
			msgData.oneShotClear = true
		end
	end
	self.hitResultCallback(resultData, msgData)
	self:setIsWaitingShotEnd(false)
	if self.nextPlayerTurnParam ~= nil then
		self:showNextPlayerTurn(self.nextPlayerTurnParam[1], self.nextPlayerTurnParam[2], self.nextPlayerTurnParam[3])
		self.nextPlayerTurnParam = nil
	end
end
function Com_9001676_game:showNextPlayerTurn(nextPlayer, isGenPenaltyCoin, genPenaltyCoinTag)
	if self.isWaitingShotEnd then
		_UPVALUE3_ = self.isWaitingShotEnd
		self.nextPlayerTurnParam, self.isWaitingShotEnd[1] = self.isWaitingShotEnd, nextPlayer
		self.nextPlayerTurnParam, self.isWaitingShotEnd[2] = self.isWaitingShotEnd, isGenPenaltyCoin
		self.nextPlayerTurnParam, self.isWaitingShotEnd[3] = self.isWaitingShotEnd, genPenaltyCoinTag
		return
	end
	for i, v in ipairs(self.allCoins) do
		if v:isVisible() then
			v:updateXYByDisplayObject()
			local x, y = v:getX(), v:getY()
			if x < 0 or 610 < x or y < 0 or 610 < y then
				local pos = self:searchUsefulPos() or self.searchCenterPos[3]
				v:setPosition(pos)
			end
		end
	end
	if self.nexPlayerTurnCallback then
		self.nexPlayerTurnCallback(nextPlayer)
	end
	if isGenPenaltyCoin then
		self:genPenaltyCoin(genPenaltyCoinTag)
	end
	self.player = nextPlayer
	if self.lastPlayer ~= self.player then
		if self.lastPlayer == PLAYER.P1 then
			self.isP1OneShotClear = false
		elseif self.lastPlayer == PLAYER.P2 then
			self.isP2OneShotClear = false
		end
	end
	self.lastPlayer = self.player
	self.isMyTurn = self.player == self.myPlayer
	self.striker:resetStriker(self.isMyTurn, self.player)
	self.strikerPos:setPositionX(self.striker:getX())
	if not self.isMyTurn then
		self:checkAI()
		self:stopGuideTips()
	else
		self:startShowGuideAction()
	end
end
function Com_9001676_game:checkAI()
	if not self.isAIPlayer then
		return
	end
	for i, v in ipairs(self.allCoins) do
		if v:isVisible() then
			v:updateXYByDisplayObject()
		end
	end
	self.isSearchingAIStrikerPos = true
	self.AISearchingCount = 0
	self.AICfg = activity_9001676_Read.getRandomAICfg()
	self.AIStrikerPos = self.striker:getPosition()
	self.AIStrikerPos.x = math.floor(math.random(self.AICfg.cue_ball_pos[1], self.AICfg.cue_ball_pos[2]) / 100 * (self.maxStrikeX - self.minStrikeX) + self.minStrikeX)
	self.striker:setPosition(self.AIStrikerPos)
end
function Com_9001676_game:searchAITarget()
	self.isSearchingAIStrikerPos = false
	local AICoinTag = self.player == PLAYER.P1 and self.p1Color or self.p2Color
	local coins = AICoinTag == COIN_TAG.WHITE and self.whiteCoins or AICoinTag == COIN_TAG.BLACK and self.blackCoins or self.allCoins
	local strikePos = self.AIStrikerPos
	local nowDistance = 100000
	local targetCoinPos = self.redCoin:getPosition()
	local target = self.redCoin
	if AICoinTag == nil or self.coinCount[AICoinTag] > 0 then
		for i, v in ipairs(coins) do
			if v:isVisible() and v ~= self.redCoin then
				local coinPos = v:getPosition()
				local distance = cc.pGetDistance(strikePos, coinPos)
				print("distance2: ", distance)
				if nowDistance > distance then
					nowDistance = distance
					target = v
					targetCoinPos = v:getPosition()
				end
			end
		end
	end
	local velocity = Activity_9001676_AI:getAIVelocity(self.holePositions, targetCoinPos, self.coinR, strikePos, self.strikerR)
	dump(velocity, "checkAI velocity2")
	_UPVALUE7_ = velocity
	velocity[1] = target:getName()
	velocity[2] = self.holePositions
	velocity[3] = targetCoinPos
	velocity[4] = self.coinR
	velocity[5] = strikePos
	velocity[6] = self.strikerR
	velocity[7] = velocity
	dump(velocity, "checkAI velocity1")
	self.striker:showAITarget(strikePos, velocity, self.AICfg)
end
function Com_9001676_game:setHitResultCallback(hitResultCallback)
	self.hitResultCallback = hitResultCallback
end
function Com_9001676_game:setNexPlayerTurnCallback(nexPlayerTurnCallback)
	self.nexPlayerTurnCallback = nexPlayerTurnCallback
end
function Com_9001676_game:setFireCallback(callback)
	self.striker:setFireCallback(callback)
end
function Com_9001676_game:sendFireData(str)
	self.striker:sendFireData(str)
end
function Com_9001676_game:onTimeUp()
	self.striker:onTimeUp()
end
function Com_9001676_game:setIsWaitingShotEnd(isWaiting)
	self.isWaitingShotEnd = isWaiting
end
function Com_9001676_game:stopGuideTips()
	print("Com_9001676_game:stopGuideTips")
	self:stopActionByTag(GUIDE_ACTION)
	self:hideGuideTips()
end
function Com_9001676_game:startShowGuideAction()
	print("Com_9001676_game:startShowGuideAction")
	local seq = ffa.seq(ffa.delay(5), ffa.callFunc(handler(self, self.showGuideTips)))
	seq:setTag(GUIDE_ACTION)
	self:runAction(seq)
end
function Com_9001676_game:showGuideTips()
	if not self.guideTips1 then
		_ENV = "gameGuideView"
		;("gameGuideView").str = i18n("Korean_chess_newguide_1")
		;("gameGuideView").size = cc.size(300, 80)
		;("gameGuideView").offset = cc.p(0, 0)
		;("gameGuideView").arr = "bottom"
		;("gameGuideView").touchRect = self.strikerPos:getBoundingBox()
		self.guideTips1 = include("gameGuideView").createTipFrame("gameGuideView")
		self.guideTips1:setName("guideTips1")
		self.guideTips1:addTo(self, 10)
	end
	if not self.guideTips2 then
		_ENV = "gameGuideView"
		;("gameGuideView").str = i18n("Korean_chess_newguide_2")
		;("gameGuideView").size = cc.size(300, 80)
		;("gameGuideView").offset = cc.p(0, 156)
		;("gameGuideView").arr = "bottom"
		;("gameGuideView").touchRect = self.strikerPos:getBoundingBox()
		self.guideTips2 = include("gameGuideView").createTipFrame("gameGuideView")
		self.guideTips2:setName("guideTips2")
		self.guideTips2:addTo(self, 10)
	end
end
function Com_9001676_game:hideGuideTips()
	if self.guideTips1 then
		self.guideTips1:removeFromParent()
		self.guideTips1 = nil
	end
	if self.guideTips2 then
		self.guideTips2:removeFromParent()
		self.guideTips2 = nil
	end
end
return Com_9001676_game
