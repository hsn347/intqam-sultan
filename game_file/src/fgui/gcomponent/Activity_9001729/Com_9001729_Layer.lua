local activity_9001729_Ctrl = SoraDGetCtrl("activity_9001729_Ctrl")
local activity_9001729_Read = include("activity_9001729_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001729_Layer = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001729/Com_9001729_Layer", Com_9001729_Layer)
function Com_9001729_Layer:onInit()
	self.grid, _ENV, self.activityID = gActivityTimeActivityID.CRESCENT_TREASURE_ACTIVITY, gActivityTimeActivityID.CRESCENT_TREASURE_ACTIVITY, gActivityTimeActivityID.CRESCENT_TREASURE_ACTIVITY
	for i = 1, 27 do
		table.insert(self.grid, self.fields["g" .. i])
	end
	self.fields.effect1:setAllFrameNameOnce("hudie%02d.png", 1, true)
	self.fields.effect2:setAllFrameNameOnce("G_ygg_light_%02dsd.png", 1, true)
	self.fields.effect3:setAllFrameNameOnce("G_ygg_light_%02dsd.png", 1, true)
	self.fields.effect4:setAllFrameNameOnce("hudie%02d.png", 1, true)
end
function Com_9001729_Layer:onShow()
end
function Com_9001729_Layer:initData(activityId)
	local mapData = activity_9001729_Read.getMapData(activityId)
	for i, v in ipairs(mapData) do
		self.grid[i]:initData(v)
	end
	self:InitPlayer()
end
function Com_9001729_Layer:InitPlayer()
	local curPos = activity_9001729_Ctrl:getCurPosIndex() or 1
	local pos = self.grid[curPos]:getPosition()
	self.fields.player:setPosition(pos)
	local nextIndex = curPos + 1
	if nextIndex > #self.grid then
		nextIndex = nextIndex - #self.grid
	end
	local lastPos = pos
	local targetPos = self.grid[nextIndex]:getPosition()
	self:updateDirection(targetPos, lastPos)
end
function Com_9001729_Layer:playerMove(actions, startIndex, length, callback, pauseTime)
	local pos = self.grid[startIndex]:getPosition()
	local lastIndex = startIndex
	for i = 1, length do
		do
			local index = startIndex + i
			index = self:clampIndex(index)
			local lastPos = self.grid[lastIndex]:getPosition()
			local targetPos = self.grid[index]:getPosition()
			table.insert(actions, ffa.callFunc(function()
				self:updateDirection(targetPos, lastPos)
			end))
			table.insert(actions, ffa.moveTo(0.3 / self.speed, targetPos.x, targetPos.y))
			lastIndex = index
		end
	end
	table.insert(actions, ffa.callFunc(function()
		local nextIndex = startIndex + length
		nextIndex = self:clampIndex(nextIndex)
		self.grid[nextIndex]:ShowEffect()
	end))
	table.insert(actions, ffa.callFunc(function()
		local nextIndex = startIndex + length + 1
		nextIndex = self:clampIndex(nextIndex)
		local lastPos = self.grid[lastIndex]:getPosition()
		local targetPos = self.grid[nextIndex]:getPosition()
		self:updateDirection(targetPos, lastPos)
	end))
	table.insert(actions, ffa.callFunc(function()
		if callback then
			callback()
		end
	end))
	if pauseTime and 0 < pauseTime then
		table.insert(actions, ffa.delay(pauseTime / self.speed))
	end
	return startIndex + length > #self.grid and startIndex + length - #self.grid or startIndex + length
end
function Com_9001729_Layer:onThrowDice(data)
	self.speed = 1
	local proxy = uiManager:getProxy("Activity_9001729_View")
	local isAuto = proxy.view.fields.comSkip:getIsAuto()
	if proxy then
		self.speed = isAuto and 2 or 1.4
	end
	local panel = SoraDCreatePanel("pyramidDiceView")
	_ENV = nil
	;(nil).num1 = data.steps[1]
	;(nil).num2 = data.steps[2]
	panel:initExData(nil, function()
		local data, actions
		local totalLengh = (data.steps[1] or 0) + (data.steps[2] or 0)
		local lastStartIndex = activity_9001729_Ctrl:getCurPosIndex() - totalLengh
		lastStartIndex = self:clampIndex(lastStartIndex)
		local nowIndex = lastStartIndex
		if data.roundReward and 0 < #data.roundReward then
			nowIndex = self:playerMove(actions, lastStartIndex, self:clampIndex(1 - lastStartIndex), function()
				self:showRoundEffect(data.roundIds, function()
					SoraDMailGainItems(data.roundReward, true)
				end)
			end, self:getPauseTime())
		end
		if data.eventType == 0 then
			local curIndex = activity_9001729_Ctrl:getCurPosIndex()
			if nowIndex ~= curIndex then
				nowIndex = self:playerMove(actions, nowIndex, curIndex - nowIndex, function()
					local proxy = uiManager:getProxy("Activity_9001729_View")
					if proxy then
						proxy.view:updateDice()
					end
					self.grid[curIndex]:updateLv()
					SoraDMailGainItems(data.blockReward, true)
				end)
			end
		else
			local curIndex = activity_9001729_Ctrl:getCurPosIndex()
			nowIndex = self:playerMove(actions, nowIndex, curIndex - nowIndex, function()
				self:pauseGame()
				self = nil
				;(nil).eventType = data.eventType
				;(nil).isAuto = isAuto
				;(nil).callback = function()
					self:continueGame()
					local proxy = uiManager:getProxy("Activity_9001729_View")
					if proxy then
						proxy.view:updateDice()
					end
				end
				uiManager:show("Activity_9001729_CardFlop", nil)
			end)
		end
		table.insert(actions, ffa.callFunc(function()
			local proxy = uiManager:getProxy("Activity_9001729_View")
			if proxy then
				proxy.view:enableDices(true)
			end
		end))
		table.insert(actions, ffa.delay(0.5))
		table.insert(actions, ffa.callFunc(function()
			for i, v in ipairs(self.grid) do
				v:updateLv()
			end
			local proxy = uiManager:getProxy("Activity_9001729_View")
			if proxy then
				proxy.view:tryAutoThrow()
			end
		end))
		self.fields.player:runAction(ffa.seq(actions))
	end, "2026TZ_dh_%02d.png", nil, nil, "2026TZ_00", self.speed)
	panel:setClickCallBack(function()
		local proxy = uiManager:getProxy("Activity_9001729_View")
		if proxy then
			proxy.view.fields.comSkip:closeAuto()
		end
	end)
	panel:show()
end
function Com_9001729_Layer:updateDirection(targetPos, lastPos)
	local deltaX = targetPos.x - lastPos.x
	local deltaY = targetPos.y - lastPos.y
	if 0 < deltaY then
		self.fields.player:setFrames("xyxbNPC_yd_ws_%02d.png", true)
	else
		self.fields.player:setFrames("xyxbNPC_yd_wn_%02d.png", true)
	end
	if 0 < deltaX then
		self.fields.player:setScaleX(-1)
	else
		self.fields.player:setScaleX(1)
	end
end
function Com_9001729_Layer:clampIndex(index)
	if index > #self.grid then
		index = index - #self.grid
	end
	if index <= 0 then
		index = index + #self.grid
	end
	return index
end
function Com_9001729_Layer:pauseGame()
	self.fields.player:pause()
	self.fields.player:getActionManager():pauseTarget(self.fields.player)
end
function Com_9001729_Layer:continueGame()
	self.fields.player:resume()
	self.fields.player:getActionManager():resumeTarget(self.fields.player)
end
local interval = 0.02
function Com_9001729_Layer:showRoundEffect(gridIds, callback)
	for i, v in ipairs(self.grid) do
		if 1 < i then
			v:ShowEffect((i - 1) * interval)
		end
	end
	for k, id in pairs(gridIds) do
		self.grid[id]:ShowEffect(interval * #self.grid + 1, k == 1 and callback or nil)
	end
end
function Com_9001729_Layer:getPauseTime()
	return interval * #self.grid + 1
end
return Com_9001729_Layer
