local AutoBaseMap = class("autoBaseMap", function()
	local view = SoraDTMXTiledMap:create("tileMaps/heroTrialMap/WorldMap1.tmx")
	return view
end)
function AutoBaseMap:ctor()
	self.tableGroupLifeTime, _ENV, self.tableGroup, _ENV = nil, nil, nil, nil
	self.checkRectTimer = nil
	self.mapViewSize = self:getContentSize()
	self.touchlayer = ccui.Layout:create()
	self.touchlayer:setContentSize(self.mapViewSize)
	self.touchlayer:ignoreAnchorPointForPosition(false)
	self.touchlayer:setAnchorPoint(cc.p(0.5, 0.5))
	self.touchlayer:setPosition(cc.p(self.mapViewSize.width / 2, self.mapViewSize.height / 2))
	self.touchlayer:addTo(self, 2)
	self.touchlayer:setTouchEnabled(true)
	self.touchlayer:setSwallowTouches(false)
	self.touchlayer:addTouchEventListener(function(touchlayer, type)
		local pos = self.touchlayer:getTouchBeganPosition()
	end)
	self.groupNode = display.newNode()
	self.groupNode:setPosition(cc.p(0, 0))
	self.groupNode:addTo(self, 5)
	self:initGroupLifeTime()
	self:setMapData()
end
function AutoBaseMap:setMapData(data)
	self:initGroup()
end
function AutoBaseMap:initGroup()
	for i = 1, 10 do
		local singleGroup = include("autoBaseGroup").new()
		singleGroup:updateGroup(501)
		singleGroup:addTo(self.groupNode)
		singleGroup:setPosition(cc.p(1800 + (i - 1) % 5 * 200, 700 + i * 30 + math.floor((i - 1) / 5) * 300))
		singleGroup:setGroupType(i <= 5 and GroupType.Attack or GroupType.Defense)
		singleGroup:setTag(i)
		singleGroup:setMapPoint(self)
		table.insert(self.tableGroup, singleGroup)
	end
	for i, v in ipairs(self.tableGroup) do
		if v:getGroupType() == GroupType.Attack then
			v:lookingForEnemy()
		end
	end
	self.checkRectTimer = SoraDCreateTimerEx(self, handler(self, self.checkGroupRect), 0.2)
end
function AutoBaseMap:starWar()
	_UPVALUE1_ = nil
	;(nil)[1] = cca.delay(5)
	;(nil)[2] = cca.callFunc(function(...)
		for i, v in ipairs(self.tableGroup) do
			if v:getState() ~= GroupState.GroupStateDeath then
				self:delGroupLifeTime(v:getTag())
			end
		end
		for i, v in ipairs(self.tableGroup) do
			if v:getState() == GroupState.GroupStateHit and self:getGroupLifeTime(v:getTag()) <= 0 then
				v:beKilled()
			end
		end
	end)
	;(nil)[3] = cca.callFunc(function(...)
		for i, v in ipairs(self.tableGroup) do
			if v:getState() ~= GroupState.GroupStateDeath then
				self:delGroupLifeTime(v:getTag())
			end
		end
		for i, v in ipairs(self.tableGroup) do
			if v:getState() == GroupState.GroupStateHit and self:getGroupLifeTime(v:getTag()) <= 0 then
				v:beKilled()
			end
		end
	end)
	self:runAction(cca.repeatForever(cca.seq(nil)))
end
function AutoBaseMap:checkGroupRect()
	for i, curGroup in ipairs(self.tableGroup) do
		local curGroupState = curGroup:getState()
		if curGroupState ~= GroupState.GroupStateHit and curGroupState ~= GroupState.GroupStateDeath then
			for j, toGroup in ipairs(self.tableGroup) do
				if i ~= j and curGroup:getGroupType() ~= toGroup:getGroupType() then
					local toGroupState = toGroup:getState()
					if toGroupState ~= GroupState.GroupStateDeath and cc.rectIntersectsRect(curGroup:getGroupRect(), toGroup:getGroupRect()) then
						curGroup:showLog("碰到啦！", toGroup)
						toGroup:showLog("碰到啦！", curGroup)
						curGroup:setNearestGroup(toGroup)
						if toGroupState ~= GroupState.GroupStateHit then
							toGroup:setNearestGroup(curGroup)
						end
						break
					end
				end
			end
		end
	end
end
function AutoBaseMap:getNearestEnemyGroupByType(group)
	local enemyIndex = 0
	local minDistance
	local starPoint = group:getCurPos()
	local ownGroupType = group:getGroupType()
	for i, v in ipairs(self.tableGroup) do
		if v:getGroupType() ~= ownGroupType and v:getState() ~= GroupState.GroupStateDeath and 0 < self:getGroupLifeTime(v:getTag()) then
			if minDistance == nil then
				minDistance = cc.pGetDistance(starPoint, v:getCurPos())
				enemyIndex = i
			else
				local curDistance = cc.pGetDistance(starPoint, v:getCurPos())
				if minDistance > curDistance then
					minDistance = curDistance
					enemyIndex = i
				end
			end
		end
	end
	if 0 < enemyIndex then
		return self.tableGroup[enemyIndex]
	else
		return nil
	end
end
function AutoBaseMap:getGroupLifeTime(tag)
	print("" .. tag .. "寿命为 " .. self.tableGroupLifeTime[tag])
	return self.tableGroupLifeTime[tag]
end
function AutoBaseMap:delGroupLifeTime(tag)
	self.tableGroupLifeTime[tag] = self.tableGroupLifeTime[tag] - 1
	print("" .. tag .. "寿命减少到 " .. self.tableGroupLifeTime[tag])
	return self.tableGroupLifeTime[tag]
end
function AutoBaseMap:initGroupLifeTime()
	_UPVALUE0_ = nil
	;(nil)[1] = 1
	;(nil)[2] = 2
	;(nil)[3] = 1
	;(nil)[4] = 3
	;(nil)[5] = 1
	;(nil)[6] = 4
	;(nil)[7] = 1
	;(nil)[8] = 2
	;(nil)[9] = 1
	self.tableGroupLifeTime, (nil)[10] = nil, 2
end
function AutoBaseMap:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		print("btn click")
	end
end
return AutoBaseMap
