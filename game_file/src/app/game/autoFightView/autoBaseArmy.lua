local autoFightDefine = include("autoFightDefine")
local AutoBaseArmy = class("autoBaseArmy", function(soliderType, imgNameAngle)
	local target = include("baseView").new(cc.size(0, 0), false)
	target:setSwallowTouches(false)
	return target
end)
function AutoBaseArmy:ctor(soliderType, imgNameAngle)
	self.maxHp = 0
	self.currHp = 0
	self.location = cc.p(0, 0)
	self.armyRect = cc.rect(0, 0, 0, 0)
	self.state = SoldierState.SoldierStateNone
	self.soliderType = soliderType
	self.Rotation = -90
	local soliderName = "#" .. worldMapDefine.getSoliderImageNameByType(soliderType) .. "_yd_" .. imgNameAngle .. "_01.png"
	self.spriteArmy = display.newSprite(soliderName)
	self.spriteArmy:setPosition(0, 0)
	self.spriteArmy:addTo(self, 2)
	self:updateArmyAction()
end
function AutoBaseArmy:updateArmyRect(point)
	local curPoint = self.location
	local armySize = cc.size(20, 20)
	if point then
		curPoint = point:convertToNodeSpace(self:convertToWorldSpace(curPoint))
	end
	local curRect = cc.rect(curPoint.x, curPoint.y, armySize.width, armySize.height)
	if point == nil then
		self.armyRect = curRect
	end
	return curRect
end
function AutoBaseArmy:getArmyRect(point)
	return self:updateArmyRect(point)
end
function AutoBaseArmy:getState()
	return self.state
end
function AutoBaseArmy:runToLocation(point)
end
function AutoBaseArmy:updateSoldier(armyid)
end
function AutoBaseArmy:lookingForMonsters(dt)
end
function AutoBaseArmy:checkNearestMonster()
end
function AutoBaseArmy:attack()
end
function AutoBaseArmy:update(dt)
end
function AutoBaseArmy:runToDestination(destination, isAttacking)
end
function AutoBaseArmy:stopSoldierAnimation()
end
function AutoBaseArmy:checkDirection(point)
end
function AutoBaseArmy:checkDirectionForMonster()
end
function AutoBaseArmy:caculateTime(point)
end
function AutoBaseArmy:runToMonster()
end
function AutoBaseArmy:attackMonster(dt)
end
function AutoBaseArmy:updateArmyAction()
	self.spriteArmy:stopAllActions()
	self:updateRotation()
	local actionName, isFlipX, imgNameAngle = self:getArmyActionName()
	local animationName = "autoFight" .. tostring(self.soliderType) .. tostring(self.state) .. imgNameAngle
	local animation = display.getAnimationCache(animationName)
	if animation == nil then
		local frames = display.newFrames(actionName, 1, 8)
		animation = display.newAnimation(frames, 0.125)
		display.setAnimationCache(animationName, animation)
	end
	self.spriteArmy:setFlippedX(isFlipX)
	self.spriteArmy:playAnimationForever(animation)
end
function AutoBaseArmy:updateRotation()
	math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
	self.Rotation = math.random(self.Rotation - 45, self.Rotation + 45)
end
function AutoBaseArmy:getArmyActionName()
	local head = worldMapDefine.getSoliderImageNameByType(self.soliderType)
	local action = "_yd_"
	local imgNameAngle, isFlipX = worldMapFunction.getSoliderImgAngelByRotation(self.Rotation)
	if self.state == SoldierState.SoldierStateRun then
		action = "_yd_"
	elseif self.state == SoldierState.SoldierStateHit then
		action = "_gj_"
	elseif self.state == SoldierState.SoldierStateDeath then
		action = "_sw_"
	end
	return head .. action .. imgNameAngle .. "_0%d.png", isFlipX, imgNameAngle
end
return AutoBaseArmy
