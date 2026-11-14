local autoFightDefine = include("autoFightDefine")
local AutoBaseGroup = class("autoBaseGroup", function(target)
	local target = include("baseView").new(cc.size(0, 0), false)
	target:setSwallowTouches(false)
	return target
end)
function AutoBaseGroup:ctor()
	self.maxCount = 1
	self.currCount = 1
	self.baseCount = 1
	self.location = cc.p(0, 0)
	self.tableArmy, _ENV, self.groupRect = cc.rect(0, 0, 0, 0), cc.rect(0, 0, 0, 0), cc.rect(0, 0, 0, 0)
	self.state = GroupState.GroupState
	self.groupType = GroupType.None
	self.siteIndex = 1
	self.nearestGroup = nil
	self.lookingForEnemyTimer = nil
	self.enemyStateUpdateTimer = nil
	self.mapPoint = nil
	self.enemyStateUpdateTimer = SoradCreateTimer(self, handler(self, self.enemyStateUpdate), true)
end
function AutoBaseGroup:updateGroup(armyData)
	self:initSolider()
end
function AutoBaseGroup:initSolider()
	local singleW = worldMapDefine.armySize[worldMapDefine.soldierType_GongjianBing]
	for i = 1, 20 do
		local singleArmy = include("autoBaseArmy").new(worldMapDefine.soldierType_GongjianBing, "w")
		singleArmy:setPosition(cc.p(-2 * singleW + i % 5 * singleW, -2 * singleW + math.floor((i - 1) / 5) * singleW))
		self:addChild(singleArmy, 1)
		table.insert(self.tableArmy, singleArmy)
	end
end
function AutoBaseGroup:updateGroupRect()
	local curRect = cc.rect(self.location.x, self.location.y, 0, 0)
	if self:getState() ~= GroupState.GroupStateDeath and 0 < #self.tableArmy then
		for i, v in ipairs(self.tableArmy) do
			if v:getState() ~= SoldierState.SoldierStateDeath then
				curRect = SoraDRectMerge(curRect, v:getArmyRect(self:getParent()))
			end
		end
	end
	self.groupRect = curRect
end
function AutoBaseGroup:getGroupRect()
	self:updateGroupRect()
	return self.groupRect
end
function AutoBaseGroup:getState()
	return self.state
end
function AutoBaseGroup:runToLocation(point)
	if self:getState() ~= GroupState.GroupStateDeath then
		self:stopAllActions()
		self:cleanAllTimer()
		self:setState(GroupState.GroupStateRun)
		local actionDelay = 2
		_UPVALUE1_ = nil
		;(nil)[1] = cca.moveTo(actionDelay, point.x, point.y)
		;(nil)[2] = cca.callFunc(function()
			self:setState(GroupState.GroupStateWait)
			if self.lookingForEnemyTimer == nil then
				self.lookingForEnemyTimer = SoradCreateTimer(self, handler(self, self.lookingForEnemy))
			end
		end)
		;(nil)[3] = cca.callFunc(function()
			self:setState(GroupState.GroupStateWait)
			if self.lookingForEnemyTimer == nil then
				self.lookingForEnemyTimer = SoradCreateTimer(self, handler(self, self.lookingForEnemy))
			end
		end)
		;(nil)[4] = cca.callFunc(function()
			self:setState(GroupState.GroupStateWait)
			if self.lookingForEnemyTimer == nil then
				self.lookingForEnemyTimer = SoradCreateTimer(self, handler(self, self.lookingForEnemy))
			end
		end)
		self:runAction(cca.seq(nil))
	end
end
function AutoBaseGroup:cleanAllTimer()
	if self.lookingForEnemyTimer then
		SoraDManagerRemoveTimer(self, self.lookingForEnemyTimer)
		self.lookingForEnemyTimer = nil
	end
end
function AutoBaseGroup:getGroupType()
	return self.groupType
end
function AutoBaseGroup:setGroupType(groupType)
	self.groupType = groupType
end
function AutoBaseGroup:getCurPos()
	self.location = cc.p(self:getPositionX(), self:getPositionY())
	return self.location
end
function AutoBaseGroup:lookingForEnemy(dt)
	self:showLog("开始搜寻敌人")
	self:setState(GroupState.GroupStateWait)
	self:findNearestEnemy()
	if self.nearestGroup then
		self:attack()
	end
end
function AutoBaseGroup:setMapPoint(mapPoint)
	_ENV = nil
	;(nil).text = tostring(self:getTag())
	;(nil).font = "res/Default/defaultBMFont.fnt"
	;(nil).align = SoraDFLabelR()
	;(nil).x = 0
	;(nil).y = 0
	local labelNum = display.newBMFontLabel(nil)
	labelNum:addTo(self, 2)
	self.location = cc.p(self:getPositionX(), self:getPositionY())
	self.mapPoint = mapPoint
end
function AutoBaseGroup:findNearestEnemy()
	self.nearestGroup = nil
	if self.mapPoint == nil then
		return
	end
	if not self.mapPoint.__cname then
		return
	end
	self.nearestGroup = self.mapPoint:getNearestEnemyGroupByType(self)
	if self.nearestGroup and self.nearestGroup.nearestGroup == nil then
		self:showLog("找到了敌人 是", self.nearestGroup)
		self.nearestGroup:runToEnemyByEnemy(self)
	end
end
function AutoBaseGroup:updateToward(point)
	if point then
		self:runAction(cca.rotateTo(0.5, SoraDGetAngleByPos(self:getCurPos(), point)))
	else
		self:runAction(cca.rotateTo(0.5, 0))
	end
end
function AutoBaseGroup:setNearestGroup(nearestGroup)
	self:showLog("被强行设置仇恨 目标：", nearestGroup)
	self:stopAllActions()
	self:cleanAllTimer()
	self.nearestGroup = nearestGroup
	self:updateToward(self.nearestGroup:getCurPos())
	self:attackEnemy()
end
function AutoBaseGroup:runToEnemyByEnemy(nearestGroup)
	self:showLog("被强行设置仇恨 目标：", nearestGroup)
	self:cleanAllTimer()
	self.nearestGroup = nearestGroup
	self:runToEnemy(true)
end
function AutoBaseGroup:attack()
	self:cleanAllTimer()
	self:runToEnemy()
end
function AutoBaseGroup:runToEnemy(isHalf)
	local toPoint = cc.p(0, 0)
	if self.nearestGroup.nearestGroup then
		if isHalf or self.nearestGroup.nearestGroup == self then
			toPoint = cc.pMidpoint(self.location, self.nearestGroup:getCurPos())
		else
			toPoint = self.nearestGroup.nearestGroup:getCurPos()
		end
	else
		print("err 找到了没有目标的目标")
	end
	self:updateToward(self.nearestGroup:getCurPos())
	self:setState(GroupState.GroupStateRun)
	local actionDelay = self:caculateTime(toPoint)
	self:stopAllActions()
	self:showLog("原坐标 " .. self.location.x .. "  " .. self.location.x)
	self:showLog("前往目的地 " .. toPoint.x .. "  " .. toPoint.x .. " 目标：", self.nearestGroup)
	_UPVALUE1_ = self.nearestGroup
	self.nearestGroup[1] = cca.moveTo(actionDelay, toPoint.x, toPoint.y)
	self.nearestGroup[2] = cca.callFunc(function()
		self:attackEnemy()
	end)
	self.nearestGroup[3] = cca.callFunc(function()
		self:attackEnemy()
	end)
	self.nearestGroup[4] = cca.callFunc(function()
		self:attackEnemy()
	end)
	self:runAction(cca.seq(self.nearestGroup))
end
function AutoBaseGroup:setState(state)
	self.state = state
end
function AutoBaseGroup:checkDirectionForEnemy()
	return true
end
function AutoBaseGroup:attackEnemy(dt)
	self:setState(GroupState.GroupStateHit)
	self:showLog("攻击啦！！！", self.nearestGroup)
end
function AutoBaseGroup:beKilled()
	self:cleanAllTimer()
	self:stopAllActions()
	self:setState(GroupState.GroupStateDeath)
	self:setVisible(false)
end
function AutoBaseGroup:caculateTime(point)
	return 5
end
function AutoBaseGroup:enemyStateUpdate(dt)
	if self.nearestGroup and self.nearestGroup:getState() == GroupState.GroupStateDeath then
		self:showLog("对手死亡 ", self.nearestGroup)
		self.nearestGroup = nil
		self:stopAllActions()
		self:lookingForEnemy()
	end
end
function AutoBaseGroup:showLog(msg, target)
	local toTarget = ""
	if target then
		toTarget = tostring(target:getTag())
	end
	print("" .. self:getTag() .. "号军团 " .. msg .. toTarget)
end
return AutoBaseGroup
