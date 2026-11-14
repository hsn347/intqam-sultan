local gametop = gModuleMgr.getObject("gametop")
local allianceWarCtrl = gametop.playertop_:getModule("allianceWarCtrl")
local checknumber = _G.checknumber
local worldMapPyramidScore = class("worldMapPyramidScore", function()
	return SoraDCreateBasePanel("worldMapPyramidScore")
end)
function worldMapPyramidScore:ctor()
	self.Node_progress_south = SoraDGetChildByName(self, "Node_progress_south")
	self.Node_progress_north = SoraDGetChildByName(self, "Node_progress_north")
	self.lab_points_south = SoraDGetChildByName(self, "Text_point_south")
	self.lab_points_north = SoraDGetChildByName(self, "Text_point_north")
	self.isWin = false
	self:updateStatus()
	self:updateData()
end
function worldMapPyramidScore:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_CAMP_DATA", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_STATECHANGED", handler(self, self.updateStatus))
end
function worldMapPyramidScore:updateData()
	self.southData, allianceWarCtrl, self.northData, allianceWarCtrl = nil, nil, nil, nil
	local data = allianceWarCtrl:getAllianceWarCampData(worldMapDefine.currentMapKindomID)
	for k, v in pairs(data) do
		if tonumber(k) == gAllianceWarCampType.red then
			self.southData = v
		elseif tonumber(k) == gAllianceWarCampType.blue then
			self.northData = v
		end
	end
	self:updatePoints()
end
function worldMapPyramidScore:updatePoints()
	local point_south = checknumber(self.southData.points)
	local point_north = checknumber(self.northData.points)
	self.lab_points_south:setString(tostring(point_south))
	self.lab_points_north:setString(tostring(point_north))
	if point_south == point_north then
		self:addEqualAction()
	else
		local bSouthWin = point_south > point_north and true or false
		self:addWinAction(bSouthWin)
	end
end
function worldMapPyramidScore:updateStatus()
	local warStatus = allianceWarCtrl:getWarData(worldMapDefine.currentMapKindomID).warStatus
	print("warStatus=", warStatus)
	if warStatus and warStatus == gKingdomWarStatusType.inWar then
		self:setVisible(true)
	else
		self:setVisible(false)
	end
end
function worldMapPyramidScore:createAction(data)
	local _ENV, actionsArray
	local south = data.isSouth or false
	local node = south and self.Node_progress_south or self.Node_progress_north
	local posY = node:getPositionY()
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(data.delayTime)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		node:setPositionX(data.posX)
	end)
	for _, v in ipairs(data.move) do
		actionsArray[#actionsArray + 1] = cc.MoveTo:create(v.time, cc.p(v.posX, posY))
	end
	local actions = transition.sequence(actionsArray)
	return actions
end
local TIME_DELAY = 0.1
function worldMapPyramidScore:createWinAction(south)
	local timeOne = 0.11666666666666667
	local timeSecend = 0.06666666666666667
	local timeThree = 0.11666666666666667
	local actionData
	if south then
		TIME_DELAY = nil
		TIME_DELAY, _UPVALUE3_, (nil).posX = nil, nil, 75
		;(nil).time = timeOne
		TIME_DELAY, (nil).posX = nil, 90
		;(nil).time = timeSecend
		TIME_DELAY, (nil).posX = nil, 107
		;(nil).time = timeThree
		;(nil).posX = 105
		actionData, (nil).move, (nil)[1] = nil, nil, nil
		actionData, (nil).move, (nil)[2] = nil, nil, nil
		actionData, (nil).move, (nil)[3] = nil, nil, nil
	else
		TIME_DELAY = nil
		TIME_DELAY, _UPVALUE3_, (nil).posX = nil, nil, 275
		;(nil).time = timeOne
		TIME_DELAY, (nil).posX = nil, 260
		;(nil).time = timeSecend
		TIME_DELAY, (nil).posX = nil, 243
		;(nil).time = timeThree
		;(nil).posX = 245
		actionData, (nil).move, (nil)[1] = nil, nil, nil
		actionData, (nil).move, (nil)[2] = nil, nil, nil
		actionData, (nil).move, (nil)[3] = nil, nil, nil
	end
	actionData.delayTime = TIME_DELAY
	actionData.isSouth = south
	local actionsArray = self:createAction(actionData)
	return actionsArray
end
function worldMapPyramidScore:createEqualAction(south)
	local timeOne = 0.13333333333333333
	local timeSecend = 0.06666666666666667
	local actionData
	if south then
		TIME_DELAY = nil
		TIME_DELAY, _UPVALUE2_, (nil).posX = nil, nil, 105
		;(nil).time = timeOne
		TIME_DELAY, (nil).posX = nil, 73
		;(nil).time = timeSecend
		;(nil).posX = 75
		actionData, (nil).move, (nil)[1] = nil, nil, nil
		actionData, (nil).move, (nil)[2] = nil, nil, nil
	else
		TIME_DELAY = nil
		TIME_DELAY, _UPVALUE2_, (nil).posX = nil, nil, 245
		;(nil).time = timeOne
		TIME_DELAY, (nil).posX = nil, 277
		;(nil).time = timeSecend
		;(nil).posX = 275
		actionData, (nil).move, (nil)[1] = nil, nil, nil
		actionData, (nil).move, (nil)[2] = nil, nil, nil
	end
	actionData.delayTime = TIME_DELAY
	actionData.isSouth = south
	local actionsArray = self:createAction(actionData)
	return actionsArray
end
local ACTION_TYPE_WIN = 1
local ACTION_TYPE_EQUAL = 2
local ACTION_TYPE_BOTH = 3
function worldMapPyramidScore:addAction_imp(node, actionType)
	local actions
	local south = node == self.Node_progress_south
	if actionType == ACTION_TYPE_BOTH then
		local actionEqual = self:createEqualAction(south)
		local actionWin = self:createWinAction(south)
		actions = cc.Sequence:create(actionEqual, actionWin)
	elseif actionType == ACTION_TYPE_WIN then
		actions = self:createWinAction(south)
	elseif actionType == ACTION_TYPE_EQUAL then
		actions = self:createEqualAction(south)
	end
	if actions then
		node:stopAllActions()
		node:runAction(actions)
	end
end
function worldMapPyramidScore:addWinAction(bSouthWin)
	if not self.isWin then
		self:addAction_imp(self.Node_progress_north, ACTION_TYPE_WIN)
		self:addAction_imp(self.Node_progress_south, ACTION_TYPE_WIN)
	else
		self:addAction_imp(self.Node_progress_north, ACTION_TYPE_BOTH)
		self:addAction_imp(self.Node_progress_south, ACTION_TYPE_BOTH)
	end
	if bSouthWin then
		self.Node_progress_north:setLocalZOrder(-30)
		self.Node_progress_south:setLocalZOrder(-20)
	else
		self.Node_progress_north:setLocalZOrder(-20)
		self.Node_progress_south:setLocalZOrder(-30)
	end
	self.isWin = true
end
function worldMapPyramidScore:addEqualAction()
	if self.isWin then
		self:addAction_imp(self.Node_progress_north, ACTION_TYPE_EQUAL)
		self:addAction_imp(self.Node_progress_south, ACTION_TYPE_EQUAL)
	end
	self.isWin = false
end
return worldMapPyramidScore
