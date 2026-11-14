local baseComponent = require("fgui.base.baseComponent")
local Com_9001705_game = fgui.extension_class(fgui.GComponent, baseComponent)
local constantRead = include("constantRead")
local activity_9001705_Ctrl = SoraDGetCtrl("activity_9001705_Ctrl")
local activity_9001705_Read = include("activity_9001705_Read")
fgui.register_extension("ui://Activity_9001705/Com_9001705_game", Com_9001705_game)
local devicePerformanceUtil = require("app.devicePerformanceUtil")
local minX = 80
local maxX = 640 - minX
_UPVALUE3_ = nil
;(nil)[1] = 140.0
;(nil)[2] = 320.0
local (nil)[3], posList = 500.0, nil
function Com_9001705_game:onInit()
	self.role = self.fields.Com_9001705_role
	self.fields.touch_area:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onAreaTouchBegin))
	self.fields.touch_area:addEventListener(fgui.UIEventType.TouchMove, handler(self, self.onAreaTouchMove))
	self.fields.touch_area:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onAreaTouchEnd))
	self.rules = activity_9001705_Read.getRuleCfgs()
	self.distanceGroupCfg = activity_9001705_Read.getDistanceGroupCfg()
	self.isCanCheat = device.platform == "mac" or userSDKManager.isBeta() or userSDKManager.isGameDevelop()
	self.controllers.c1:setSelectedIndex(self.isCanCheat and 1 or 0)
	if self.isCanCheat then
		self.fields.text_cheat:setString("体能、幸运、速度、加能量、减能量、星星速度、星星时间、道具距离、能量消耗(100,50,150,30,20,50,6,200,1,5)")
		self.fields.cheat:setTitle("测试重新开始")
		self.fields.cheat:addClickEventListener(function()
			self:startGame(self.resultCallback, true)
		end)
	end
end
function Com_9001705_game:onShow()
	self.timer = SoradCreateTimer(self, handler(self, self.updateGame), true)
	SoraDAddMessage(self, "MESSAGE_SERVER_GUIDE_LAST_FINISH", handler(self, self.msgGuideEnd))
end
function Com_9001705_game:msgGuideEnd()
	activity_9001705_Ctrl = nil
	;(nil).callback = function()
		self.isGameStart = true
		self.role:setVisible(true)
		activity_9001705_Ctrl:reqSnowCompetitionBegin()
	end
	self.fields.time_pull:startGame(nil)
end
function Com_9001705_game:startGame(callback, isCheat)
	devicePerformanceUtil.setFPS(60)
	self.addX = (self:getWidth() - 640) / 2
	self.isGameStart = false
	self.items, devicePerformanceUtil, self.resultCallback = (self:getWidth() - 640) / 2, (self:getWidth() - 640) / 2, callback
	for i = 1, 12 do
		local item = self.fields["item" .. i]
		table.insert(self.items, item)
		item:setVisible(false)
		item:setY(-item:getHeight() / 2)
	end
	for i = 1, 3 do
		local bg = self.fields["bg" .. i]
		local y = self:getHeight() - bg:getHeight() * i
		bg:setY(y)
	end
	self.fields.text_add:setVisible(false)
	self.fields.text_min:setVisible(false)
	self.fields.icon_shine:setVisible(false)
	self.fields.icon_shine2:setVisible(false)
	self.showingItems, devicePerformanceUtil, self.isPause = self.fields.icon_shine2.setVisible, self.fields.icon_shine2.setVisible, false
	self.role:setPositionX(320 - self.role:getWidth() / 2 + self.addX)
	self.roleEnergy = activity_9001705_Ctrl:getAttValue("power")
	self.roleLuckValue = activity_9001705_Ctrl:getAttValue("lucky")
	self.roleSpeed = activity_9001705_Ctrl:getAttValue("speed")
	self.energy = constantRead.getConstValue("SKY_COMPETITION_ENERGY_INCREASE", 30)
	self.obstacle = constantRead.getConstValue("SKY_COMPETITION_OBSTACLE_REDUCE", 20)
	self.luckyStarSpeed = constantRead.getConstValue("SKY_COMPETITION_LUCKYSTAR_SPEED", 50)
	self.luckyStarTime = constantRead.getConstValue("SKY_COMPETITION_LUCKYSTAR_TIME", 6)
	self.itemGenerateDistance = constantRead.getConstValue("SKY_COMPETITION_ITEM_GENERATE_DISTANCE", 200)
	activity_9001705_Ctrl = 200
	;(200)[1] = 1
	;(200)[2] = 5
	local energyComsue = constantRead.getConstValueArray("SKY_COMPETITION_ENERGY_CONSUME", 200)
	if self.isCanCheat then
		local cheatStr = self.fields.input_cheat:getText()
		local isInCheat = false
		if cheatStr ~= "" and isCheat then
			local values = string.split(cheatStr, ",")
			if #values == 10 then
				self.roleEnergy = tonumber(values[1])
				self.roleLuckValue = tonumber(values[2])
				self.roleSpeed = tonumber(values[3])
				self.energy = tonumber(values[4])
				self.obstacle = tonumber(values[5])
				self.luckyStarSpeed = tonumber(values[6])
				self.luckyStarTime = tonumber(values[7])
				_ENV, self.itemGenerateDistance = tonumber(values[8]), tonumber(values[8])
				energyComsue, tonumber(values[8])[1] = tonumber(values[8]), tonumber(values[9])
				energyComsue, tonumber(values[8])[2] = tonumber(values[8]), tonumber(values[10])
				energyComsue, tonumber(values[8])[3] = tonumber(values[8]), tonumber(values[10])
				energyComsue, tonumber(values[8])[4] = tonumber(values[8]), tonumber(values[10])
				energyComsue, tonumber(values[8])[5] = tonumber(values[8]), tonumber(values[10])
				energyComsue, tonumber(values[8])[6] = tonumber(values[8]), tonumber(values[10])
				energyComsue, tonumber(values[8])[7] = tonumber(values[8]), tonumber(values[10])
				energyComsue, tonumber(values[8])[8] = tonumber(values[8]), tonumber(values[10])
				energyComsue, tonumber(values[8])[9] = tonumber(values[8]), tonumber(values[10])
				energyComsue, tonumber(values[8])[10] = tonumber(values[8]), tonumber(values[10])
				energyComsue, tonumber(values[8])[11] = tonumber(values[8]), tonumber(values[10])
				energyComsue, tonumber(values[8])[12] = tonumber(values[8]), tonumber(values[10])
				energyComsue, tonumber(values[8])[13] = tonumber(values[8]), tonumber(values[10])
				energyComsue, tonumber(values[8])[14] = tonumber(values[8]), tonumber(values[10])
				energyComsue, tonumber(values[8])[15] = tonumber(values[8]), tonumber(values[10])
				energyComsue, tonumber(values[8])[16] = tonumber(values[8]), tonumber(values[10])
				energyComsue, tonumber(values[8])[17] = tonumber(values[8]), tonumber(values[10])
				isInCheat = true
			end
		end
		if not isInCheat then
			cheatStr = self.roleEnergy .. "," .. self.roleLuckValue .. "," .. self.roleSpeed .. "," .. self.energy .. "," .. self.obstacle .. "," .. self.luckyStarSpeed .. "," .. self.luckyStarTime .. "," .. self.itemGenerateDistance .. "," .. energyComsue[1] .. "," .. energyComsue[2]
			self.fields.input_cheat:setText(cheatStr)
		end
	end
	_UPVALUE4_, self.runDistance = self.roleEnergy .. "," .. self.roleLuckValue .. "," .. self.roleSpeed .. "," .. self.energy .. "," .. self.obstacle .. "," .. self.luckyStarSpeed .. "," .. self.luckyStarTime .. "," .. self.itemGenerateDistance .. "," .. energyComsue[1] .. "," .. energyComsue[2], 0
	self.hitItemRecount, (self.roleEnergy .. "," .. self.roleLuckValue .. "," .. self.roleSpeed .. "," .. self.energy .. "," .. self.obstacle .. "," .. self.luckyStarSpeed .. "," .. self.luckyStarTime .. "," .. self.itemGenerateDistance .. "," .. energyComsue[1] .. "," .. energyComsue[2])[1] = self.roleEnergy .. "," .. self.roleLuckValue .. "," .. self.roleSpeed .. "," .. self.energy .. "," .. self.obstacle .. "," .. self.luckyStarSpeed .. "," .. self.luckyStarTime .. "," .. self.itemGenerateDistance .. "," .. energyComsue[1] .. "," .. energyComsue[2], 0
	self.hitItemRecount, (self.roleEnergy .. "," .. self.roleLuckValue .. "," .. self.roleSpeed .. "," .. self.energy .. "," .. self.obstacle .. "," .. self.luckyStarSpeed .. "," .. self.luckyStarTime .. "," .. self.itemGenerateDistance .. "," .. energyComsue[1] .. "," .. energyComsue[2])[2] = self.roleEnergy .. "," .. self.roleLuckValue .. "," .. self.roleSpeed .. "," .. self.energy .. "," .. self.obstacle .. "," .. self.luckyStarSpeed .. "," .. self.luckyStarTime .. "," .. self.itemGenerateDistance .. "," .. energyComsue[1] .. "," .. energyComsue[2], 0
	self.hitItemRecount, (self.roleEnergy .. "," .. self.roleLuckValue .. "," .. self.roleSpeed .. "," .. self.energy .. "," .. self.obstacle .. "," .. self.luckyStarSpeed .. "," .. self.luckyStarTime .. "," .. self.itemGenerateDistance .. "," .. energyComsue[1] .. "," .. energyComsue[2])[3] = self.roleEnergy .. "," .. self.roleLuckValue .. "," .. self.roleSpeed .. "," .. self.energy .. "," .. self.obstacle .. "," .. self.luckyStarSpeed .. "," .. self.luckyStarTime .. "," .. self.itemGenerateDistance .. "," .. energyComsue[1] .. "," .. energyComsue[2], 0
	self.hitItemRecount, (self.roleEnergy .. "," .. self.roleLuckValue .. "," .. self.roleSpeed .. "," .. self.energy .. "," .. self.obstacle .. "," .. self.luckyStarSpeed .. "," .. self.luckyStarTime .. "," .. self.itemGenerateDistance .. "," .. energyComsue[1] .. "," .. energyComsue[2])[4] = self.roleEnergy .. "," .. self.roleLuckValue .. "," .. self.roleSpeed .. "," .. self.energy .. "," .. self.obstacle .. "," .. self.luckyStarSpeed .. "," .. self.luckyStarTime .. "," .. self.itemGenerateDistance .. "," .. energyComsue[1] .. "," .. energyComsue[2], 0
	self.passTime = 0
	constantRead, constantRead, self.roleLuckyTime = 0, self.roleEnergy .. "," .. self.roleLuckValue .. "," .. self.roleSpeed .. "," .. self.energy .. "," .. self.obstacle .. "," .. self.luckyStarSpeed .. "," .. self.luckyStarTime .. "," .. self.itemGenerateDistance .. "," .. energyComsue[1] .. "," .. energyComsue[2], 0
	constantRead, (0)[1] = 0, 0
	constantRead, (0)[2] = 0, 0
	constantRead, (0)[3] = 0, 0
	constantRead, (0)[1] = 0, 0
	constantRead, (0)[2] = 0, 0
	constantRead, (0)[3] = 0, 0
	;(0)[1] = 0
	;(0)[2] = 0
	;(0)[3] = 0
	constantRead, constantRead, self.resetRound, (self.roleEnergy .. "," .. self.roleLuckValue .. "," .. self.roleSpeed .. "," .. self.energy .. "," .. self.obstacle .. "," .. self.luckyStarSpeed .. "," .. self.luckyStarTime .. "," .. self.itemGenerateDistance .. "," .. energyComsue[1] .. "," .. energyComsue[2])[1] = 0, self.roleEnergy .. "," .. self.roleLuckValue .. "," .. self.roleSpeed .. "," .. self.energy .. "," .. self.obstacle .. "," .. self.luckyStarSpeed .. "," .. self.luckyStarTime .. "," .. self.itemGenerateDistance .. "," .. energyComsue[1] .. "," .. energyComsue[2], self.roleEnergy .. "," .. self.roleLuckValue .. "," .. self.roleSpeed .. "," .. self.energy .. "," .. self.obstacle .. "," .. self.luckyStarSpeed .. "," .. self.luckyStarTime .. "," .. self.itemGenerateDistance .. "," .. energyComsue[1] .. "," .. energyComsue[2], 0
	constantRead, constantRead, self.resetRound, (self.roleEnergy .. "," .. self.roleLuckValue .. "," .. self.roleSpeed .. "," .. self.energy .. "," .. self.obstacle .. "," .. self.luckyStarSpeed .. "," .. self.luckyStarTime .. "," .. self.itemGenerateDistance .. "," .. energyComsue[1] .. "," .. energyComsue[2])[2] = 0, self.roleEnergy .. "," .. self.roleLuckValue .. "," .. self.roleSpeed .. "," .. self.energy .. "," .. self.obstacle .. "," .. self.luckyStarSpeed .. "," .. self.luckyStarTime .. "," .. self.itemGenerateDistance .. "," .. energyComsue[1] .. "," .. energyComsue[2], self.roleEnergy .. "," .. self.roleLuckValue .. "," .. self.roleSpeed .. "," .. self.energy .. "," .. self.obstacle .. "," .. self.luckyStarSpeed .. "," .. self.luckyStarTime .. "," .. self.itemGenerateDistance .. "," .. energyComsue[1] .. "," .. energyComsue[2], 0
	constantRead, constantRead, self.resetRound, (self.roleEnergy .. "," .. self.roleLuckValue .. "," .. self.roleSpeed .. "," .. self.energy .. "," .. self.obstacle .. "," .. self.luckyStarSpeed .. "," .. self.luckyStarTime .. "," .. self.itemGenerateDistance .. "," .. energyComsue[1] .. "," .. energyComsue[2])[3] = 0, self.roleEnergy .. "," .. self.roleLuckValue .. "," .. self.roleSpeed .. "," .. self.energy .. "," .. self.obstacle .. "," .. self.luckyStarSpeed .. "," .. self.luckyStarTime .. "," .. self.itemGenerateDistance .. "," .. energyComsue[1] .. "," .. energyComsue[2], self.roleEnergy .. "," .. self.roleLuckValue .. "," .. self.roleSpeed .. "," .. self.energy .. "," .. self.obstacle .. "," .. self.luckyStarSpeed .. "," .. self.luckyStarTime .. "," .. self.itemGenerateDistance .. "," .. energyComsue[1] .. "," .. energyComsue[2], 0
	constantRead, (0)[1] = 0, 0
	constantRead, (0)[2] = 0, 0
	constantRead, (0)[3] = 0, 0
	constantRead, (0)[1] = 0, 0
	constantRead, (0)[2] = 0, 0
	constantRead, (0)[3] = 0, 0
	;(0)[1] = 0
	;(0)[2] = 0
	;(0)[3] = 0
	self.changeRound, (self.roleEnergy .. "," .. self.roleLuckValue .. "," .. self.roleSpeed .. "," .. self.energy .. "," .. self.obstacle .. "," .. self.luckyStarSpeed .. "," .. self.luckyStarTime .. "," .. self.itemGenerateDistance .. "," .. energyComsue[1] .. "," .. energyComsue[2])[1] = self.roleEnergy .. "," .. self.roleLuckValue .. "," .. self.roleSpeed .. "," .. self.energy .. "," .. self.obstacle .. "," .. self.luckyStarSpeed .. "," .. self.luckyStarTime .. "," .. self.itemGenerateDistance .. "," .. energyComsue[1] .. "," .. energyComsue[2], 0
	self.changeRound, (self.roleEnergy .. "," .. self.roleLuckValue .. "," .. self.roleSpeed .. "," .. self.energy .. "," .. self.obstacle .. "," .. self.luckyStarSpeed .. "," .. self.luckyStarTime .. "," .. self.itemGenerateDistance .. "," .. energyComsue[1] .. "," .. energyComsue[2])[2] = self.roleEnergy .. "," .. self.roleLuckValue .. "," .. self.roleSpeed .. "," .. self.energy .. "," .. self.obstacle .. "," .. self.luckyStarSpeed .. "," .. self.luckyStarTime .. "," .. self.itemGenerateDistance .. "," .. energyComsue[1] .. "," .. energyComsue[2], 0
	self.changeRound, (self.roleEnergy .. "," .. self.roleLuckValue .. "," .. self.roleSpeed .. "," .. self.energy .. "," .. self.obstacle .. "," .. self.luckyStarSpeed .. "," .. self.luckyStarTime .. "," .. self.itemGenerateDistance .. "," .. energyComsue[1] .. "," .. energyComsue[2])[3] = self.roleEnergy .. "," .. self.roleLuckValue .. "," .. self.roleSpeed .. "," .. self.energy .. "," .. self.obstacle .. "," .. self.luckyStarSpeed .. "," .. self.luckyStarTime .. "," .. self.itemGenerateDistance .. "," .. energyComsue[1] .. "," .. energyComsue[2], 0
	self.curRound = 0
	self.lastHitItemRound = 0
	self.maxRoleEnergy = self.roleEnergy
	self.fields.Com_9001705_bar:setMax(self.maxRoleEnergy)
	self.energyComsue = energyComsue[2] / energyComsue[1]
	self.lastItemGenerateDistance = self.itemGenerateDistance
	self.role:setVisible(false)
	self.role:resetRole()
	if activity_9001705_Ctrl:getIsNeedGuide() then
		devicePerformanceUtil = activity_9001705_Ctrl
		activity_9001705_Ctrl.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		activity_9001705_Ctrl.step = 9991510
		SoraDSendMessage(activity_9001705_Ctrl)
	else
		devicePerformanceUtil = false
		;(false).callback = function()
			self.isGameStart = true
			self.role:setVisible(true)
			activity_9001705_Ctrl:reqSnowCompetitionBegin()
		end
		self.fields.time_pull:startGame(false)
	end
	self:updateValues(0)
end
function Com_9001705_game:onAreaTouchBegin(eventContext)
	if not self.isGameStart or self.isPause then
		return
	end
	self.lastTouchMovePoint = eventContext:getInput():getPosition()
	eventContext:captureTouch()
end
function Com_9001705_game:onAreaTouchMove(eventContext)
	if not self.isGameStart or self.isPause then
		return
	end
	local touchmovePoint = eventContext:getInput():getPosition()
	local moveX = touchmovePoint.x - self.lastTouchMovePoint.x
	local finalX = math.clamp(self.role:getPositionX() + moveX, minX + self.addX, maxX - self.role:getWidth() + self.addX)
	self.role:setPositionX(finalX)
	self.lastTouchMovePoint = eventContext:getInput():getPosition()
end
function Com_9001705_game:onAreaTouchEnd(eventContext)
end
function Com_9001705_game:updateGame(dt)
	if not self.isGameStart or self.isPause then
		return
	end
	self:updateBgMove(dt)
	self:updateItem(dt)
	self:updateRole(dt)
	self:updateValues(dt)
end
function Com_9001705_game:updateBgMove(dt)
	for i = 1, 3 do
		local bg = self.fields["bg" .. i]
		local y = bg:getPositionY()
		if y >= self:getHeight() then
			local preBg = self.fields["bg" .. (i == 1 and 3 or i - 1)]
			y = preBg:getY() - preBg:getHeight()
			if i == 1 then
				y = y + dt * self:getSpeed()
			end
		else
			y = y + dt * self:getSpeed()
		end
		bg:setY(y)
	end
end
_ENV, Com_9001705_game.updateItem = function(self, dt)
	local count = #self.showingItems
	for i = count, 1, -1 do
		local item = self.showingItems[i]
		local y = item:getPositionY() + dt * self:getSpeed()
		if y >= self:getHeight() then
			table.remove(self.showingItems, i)
			table.insert(self.items, item)
			item:setVisible(false)
			y = -item:getHeight() / 2
			local itemBase = item:getItemBase()
			if itemBase ~= nil then
				itemBase:setVisible(false)
				item:setItemBase(nil)
				table.insert(self.itemBases, itemBase)
			end
		end
		item:updateXY(dt, y)
	end
end, function(self, dt)
	local count = #self.showingItems
	for i = count, 1, -1 do
		local item = self.showingItems[i]
		local y = item:getPositionY() + dt * self:getSpeed()
		if y >= self:getHeight() then
			table.remove(self.showingItems, i)
			table.insert(self.items, item)
			item:setVisible(false)
			y = -item:getHeight() / 2
			local itemBase = item:getItemBase()
			if itemBase ~= nil then
				itemBase:setVisible(false)
				item:setItemBase(nil)
				table.insert(self.itemBases, itemBase)
			end
		end
		item:updateXY(dt, y)
	end
end
;(function(self, dt)
	local count = #self.showingItems
	for i = count, 1, -1 do
		local item = self.showingItems[i]
		local y = item:getPositionY() + dt * self:getSpeed()
		if y >= self:getHeight() then
			table.remove(self.showingItems, i)
			table.insert(self.items, item)
			item:setVisible(false)
			y = -item:getHeight() / 2
			local itemBase = item:getItemBase()
			if itemBase ~= nil then
				itemBase:setVisible(false)
				item:setItemBase(nil)
				table.insert(self.itemBases, itemBase)
			end
		end
		item:updateXY(dt, y)
	end
end)[1] = true
local (function(self, dt)
	local count = #self.showingItems
	for i = count, 1, -1 do
		local item = self.showingItems[i]
		local y = item:getPositionY() + dt * self:getSpeed()
		if y >= self:getHeight() then
			table.remove(self.showingItems, i)
			table.insert(self.items, item)
			item:setVisible(false)
			y = -item:getHeight() / 2
			local itemBase = item:getItemBase()
			if itemBase ~= nil then
				itemBase:setVisible(false)
				item:setItemBase(nil)
				table.insert(self.itemBases, itemBase)
			end
		end
		item:updateXY(dt, y)
	end
end)[2], needAddLuckyValue = true, function(self, dt)
	local count = #self.showingItems
	for i = count, 1, -1 do
		local item = self.showingItems[i]
		local y = item:getPositionY() + dt * self:getSpeed()
		if y >= self:getHeight() then
			table.remove(self.showingItems, i)
			table.insert(self.items, item)
			item:setVisible(false)
			y = -item:getHeight() / 2
			local itemBase = item:getItemBase()
			if itemBase ~= nil then
				itemBase:setVisible(false)
				item:setItemBase(nil)
				table.insert(self.itemBases, itemBase)
			end
		end
		item:updateXY(dt, y)
	end
end
function Com_9001705_game:createRandomItem()
	self.lastItemGenerateDistance = 0
	self.curRound = self.curRound + 1
	local ruleCfgs = self:getCurRule(self.runDistance)
	local _ENV, rules = self, self
	local _ENV, itemCountIdxs = self.runDistance, self.runDistance
	local _ENV, monsterCountIdxs
	local isLastRuleType4 = false
	for i = 1, 3 do
		if not isLastRuleType4 then
			local _ENV, randomParam
			for _, v in ipairs(ruleCfgs) do
				if i ~= 3 or i == 3 and v.type ~= 4 then
					local resetRound = self.resetRound[i][v.type]
					local baseWeight = v.weight
					if v.round ~= 0 and resetRound ~= 0 then
						baseWeight = 0
						self.resetRound[i][v.type] = resetRound - 1
					else
						if needAddLuckyValue[v.type] then
							baseWeight = baseWeight + self.roleLuckValue
						end
						local changeRound = self.changeRound[i][v.type] or 0
						baseWeight = baseWeight + changeRound * v.change
					end
					table.insert(randomParam, baseWeight)
				end
			end
			local sumWeight = 0
			for _, v in ipairs(randomParam) do
				sumWeight = sumWeight + v
			end
			if sumWeight ~= 0 then
				local randIndex = SoraDRandomItem(randomParam)
				local rule = ruleCfgs[randIndex]
				for changeType, v in pairs(self.changeRound[i]) do
					if changeType ~= rule.type then
						self.changeRound[i][changeType] = v + 1
					else
						self.changeRound[i][changeType] = 0
					end
				end
				rules[i] = rule
				if rule.type == 1 or rule.type == 2 then
					table.insert(itemCountIdxs, i)
				elseif rule.type == 3 then
					table.insert(monsterCountIdxs, i)
				elseif rule.type == 4 then
					isLastRuleType4 = true
				end
			end
		else
			isLastRuleType4 = false
		end
	end
	local rdItemIdx = 0 < #itemCountIdxs and math.random(1, #itemCountIdxs)
	local rdMonsterIdx = 3 <= #monsterCountIdxs and math.random(1, #monsterCountIdxs)
	for i, rule in ipairs(rules) do
		if rule.type ~= 0 and (rule.type ~= 3 and i == itemCountIdxs[rdItemIdx] or rule.type == 3 and i ~= monsterCountIdxs[rdMonsterIdx] or rule.type == 4) then
			local item = self.items[1]
			if item == nil then
				return
			end
			item:setVisible(true)
			item:initData(rule.type, self.curRound)
			table.remove(self.items, 1)
			table.insert(self.showingItems, item)
			if rule.type == 4 then
				item:setStartX((posList[i] + posList[i + 1]) / 2 - item:getWidth() / 2 + self.addX)
			else
				item:setPositionX(posList[i] - item:getWidth() / 2 + self.addX)
			end
			if rule.type ~= 0 then
				self.resetRound[i][rule.type] = rule.round
			end
		end
	end
end
function Com_9001705_game:updateRole(dt)
	local roleRect = self.role:getBoundingBox()
	local count = #self.showingItems
	for i = count, 1, -1 do
		local item = self.showingItems[i]
		if item:getY() >= 700 then
			local itemRect = item:getBoundingBox()
			if cc.rectIntersectsRect(roleRect, itemRect) then
				table.remove(self.showingItems, i)
				table.insert(self.items, item)
				item:setVisible(false)
				item:updateXY(0, -item:getHeight() / 2)
				local itemBase = item:getItemBase()
				if itemBase ~= nil then
					itemBase:setVisible(false)
					item:setItemBase(nil)
					table.insert(self.itemBases, itemBase)
				end
				self:hitItem(item)
				break
			end
		end
	end
end
function Com_9001705_game:hitItem(item)
	local itemType = item:getItemType()
	local addHitNum = 1
	if itemType == 1 then
		self.roleEnergy = math.min(self.roleEnergy + self.energy, self.maxRoleEnergy)
		self.fields.text_add:setVisible(true)
		self.fields.text_add:setString("+" .. self.energy)
		self.transitions.add:play()
	elseif itemType == 2 then
		self.roleLuckyTime = self.luckyStarTime
		self.fields.icon_shine:setVisible(true)
		self.fields.icon_shine2:setVisible(true)
	elseif itemType == 3 or itemType == 4 then
		if self.roleLuckyTime <= 0 then
			self.roleEnergy = self.roleEnergy - self.obstacle
			self.fields.text_min:setVisible(true)
			self.fields.text_min:setString("-" .. self.obstacle)
			self.transitions.min:play()
		else
			addHitNum = 0
		end
	end
	self.hitItemRecount[itemType] = self.hitItemRecount[itemType] + addHitNum
	if addHitNum ~= 0 then
		self.role:hitItem(itemType)
	end
end
function Com_9001705_game:updateValues(dt)
	self.roleEnergy = self.roleEnergy - dt * self.energyComsue
	self.runDistance = self.runDistance + dt * self:getSpeed()
	self.passTime = self.passTime + dt
	self.fields.Com_9001705_bar:setValue(math.max(math.floor(self.roleEnergy), 0))
	self.fields.Com_9001705_bar2:initData(math.floor(self.runDistance))
	if self.roleEnergy <= 0 then
		self:finishGame()
		return
	end
	_ENV = math.floor(self.runDistance)
	_ENV, _ENV, math.floor(self.runDistance).num = self.runDistance, math.floor(self.runDistance), math.floor(self.runDistance)
	math.floor(self.runDistance).num, self.runDistance.color = self.runDistance, "#F0E6D2"
	self.fields.text_curMile:setString(i18n_html("snow_competition_text_23", math.floor(self.runDistance)))
	if 0 < self.roleLuckyTime then
		self.roleLuckyTime = self.roleLuckyTime - dt
	elseif 0 > self.roleLuckyTime then
		self.roleLuckyTime = 0
		self.fields.icon_shine:setVisible(false)
		self.fields.icon_shine2:setVisible(false)
	end
	if 0 < self.roleLuckyTime and self.roleLuckyTime <= 2.0 then
		self.role:nearTimeOver(self.roleLuckyTime)
	end
	self.lastItemGenerateDistance = self.lastItemGenerateDistance + dt * self:getSpeed()
	if self.lastItemGenerateDistance >= self.itemGenerateDistance then
		self:createRandomItem()
	end
	local passTime = math.floor(self.passTime)
	if self.lastPassTime ~= passTime then
		_UPVALUE4_, self.lastPassTime = self.lastPassTime, passTime
		self.lastPassTime[1] = math.floor(self.runDistance)
		self.lastPassTime[2] = self.hitItemRecount[2]
		self.lastPassTime[3] = self.hitItemRecount[1]
		local self.lastPassTime[4], recordTable = self.hitItemRecount[3], self.lastPassTime
		_ENV = self.hitItemRecount[3]
		self.hitItemRecount[3].byUID = true
		SoraDConfigSet("Game:Com_9001705_game:recordTable~table", recordTable, self.hitItemRecount[3])
	end
end
function Com_9001705_game:pauseGame(isPause)
	self.isPause = isPause
end
function Com_9001705_game:finishGame()
	devicePerformanceUtil.resetQuality()
	self.isGameStart = false
	self.isPause = false
	self.isGameStart = false
	devicePerformanceUtil = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:Com_9001705_game:recordTable~table", nil, nil)
	if self.resultCallback then
		self.resultCallback(self.passTime, self.runDistance, self.hitItemRecount)
	end
end
function Com_9001705_game:getSpeed()
	return self.roleLuckyTime > 0 and self.luckyStarSpeed or self.roleSpeed
end
function Com_9001705_game:getIsGameStart()
	return self.isGameStart
end
function Com_9001705_game:getCurRule(distance)
	for i, v in ipairs(self.distanceGroupCfg) do
		if distance >= v.distance[1] and distance <= v.distance[2] then
			return self.rules[v.index]
		end
	end
	return self.rules[#self.rules]
end
return Com_9001705_game
