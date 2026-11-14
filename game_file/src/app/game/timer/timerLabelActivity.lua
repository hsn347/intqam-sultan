local timerLabelActivity = class("timerLabelActivity", function(target)
	if target == nil then
		return SoraDCreateBasePanel("timerLabelActivity")
	end
	if target ~= nil then
		local timerClass = include("timerLabel")
		target = timerClass.new(target)
	end
	return target
end)
function timerLabelActivity:ctor()
	self.time_node_cooling = SoraDGetChildByName(self, "time_node_cooling")
	_UPVALUE6_, self.numArray, _ENV, self.frame_LegendaryKing_countdown_12 = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_12"), SoraDGetChildByName(self, "frame_LegendaryKing_countdown_12"), SoraDGetChildByName(self, "frame_LegendaryKing_countdown_12"), SoraDGetChildByName(self, "frame_LegendaryKing_countdown_12")
	self.timePadding, SoraDGetChildByName(self, "frame_LegendaryKing_countdown_12")[1] = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_12"), 35
	self.timePadding, SoraDGetChildByName(self, "frame_LegendaryKing_countdown_12")[2] = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_12"), 40
	self.timePadding, SoraDGetChildByName(self, "frame_LegendaryKing_countdown_12")[3] = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_12"), 60
	self.timePadding, SoraDGetChildByName(self, "frame_LegendaryKing_countdown_12")[4] = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_12"), 38
	self.timePadding, SoraDGetChildByName(self, "frame_LegendaryKing_countdown_12")[5] = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_12"), 58
	self.timePadding, SoraDGetChildByName(self, "frame_LegendaryKing_countdown_12")[6] = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_12"), 38
	self:createTimeNode(7, self.timePadding)
	self:setViewLen(false)
end
local getCharNode = function()
	local numChar = cc.Label:createWithCharMap("fonts/icon_acitivity_num.png", 35, 46, 48)
	numChar:setAnchorPoint(cc.p(0, 0))
	numChar:setPosition(0, 0)
	return numChar
end
function timerLabelActivity:createTimeNode(numOfChar, paddingArray)
	local nodeParent = display.newNode()
	local _ENV, numArray
	for i = 1, numOfChar do
		local numChar = getCharNode()
		numChar:addTo(nodeParent)
		numChar:setContentSize(cc.size(35, 46))
		numChar:setFontSize(46)
		numArray[i] = numChar
	end
	SoraDAlignNodeArray(numArray, false, paddingArray)
	self.numArray = numArray
	nodeParent:addTo(self.time_node_cooling)
	nodeParent:setPosition(cc.p(-30, -23))
	nodeParent:setLocalZOrder(10)
	return nodeParent
end
function timerLabelActivity:updateLabel(timeNumber)
	self:setString(timeNumber)
end
function timerLabelActivity:setViewLen(viewLen)
	if viewLen == self.viewLen then
		return
	end
	self.viewLen = viewLen
	local time_node_cooling = self.time_node_cooling
	local frame_LegendaryKing_countdown_12 = self.frame_LegendaryKing_countdown_12
	if viewLen then
		time_node_cooling:setScale(0.9)
		frame_LegendaryKing_countdown_12:setVisible(true)
		time_node_cooling:setPositionX(70)
		self.numArray[1]:setVisible(true)
	else
		time_node_cooling:setScale(1.0)
		time_node_cooling:setPositionX(0)
		frame_LegendaryKing_countdown_12:setVisible(false)
		self.numArray[1]:setVisible(false)
	end
end
function timerLabelActivity:setString(secTime)
	local numArray = self.numArray
	local timeStr = _G.SoraDConvertSecondToStringNoDay(secTime)
	local splitTime = string.split(timeStr, ":")
	if string.len(splitTime[1]) >= 3 then
		self:setViewLen(true)
		if tonumber(splitTime[1]) > 999 then
			splitTime[1] = tostring(999)
		end
		_UPVALUE6_ = tostring(999)
		tostring(999)[1] = string.sub(timeStr, 1, 1)
		tostring(999)[2] = string.sub(timeStr, 2, 2)
		tostring(999)[3] = string.sub(timeStr, 3, 3)
		tostring(999)[4] = string.sub(timeStr, 5, 5)
		tostring(999)[5] = string.sub(timeStr, 6, 6)
		tostring(999)[6] = string.sub(timeStr, 8, 8)
		tostring(999)[7] = string.sub(timeStr, 9, 9)
		tostring(999)[8] = string.sub(timeStr, 9, 9)
		tostring(999)[9] = string.sub(timeStr, 9, 9)
		local tostring(999)[10], strArray = string.sub(timeStr, 9, 9)
		for i = 1, #strArray do
			if numArray[i] then
				numArray[i]:setString(strArray[i])
			end
		end
	else
		self:setViewLen(false)
		_UPVALUE5_ = self.setViewLen
		self.setViewLen[1] = string.sub(timeStr, 1, 1)
		self.setViewLen[2] = string.sub(timeStr, 2, 2)
		self.setViewLen[3] = string.sub(timeStr, 4, 4)
		self.setViewLen[4] = string.sub(timeStr, 5, 5)
		self.setViewLen[5] = string.sub(timeStr, 7, 7)
		self.setViewLen[6] = string.sub(timeStr, 8, 8)
		self.setViewLen[7] = string.sub(timeStr, 8, 8)
		self.setViewLen[8] = string.sub(timeStr, 8, 8)
		self.setViewLen[9] = string.sub(timeStr, 8, 8)
		local self.setViewLen[10], strArray = string.sub(timeStr, 8, 8)
		for i = 1, #strArray do
			if numArray[i + 1] then
				numArray[i + 1]:setString(strArray[i])
			end
		end
	end
end
function timerLabelActivity:showEffect()
	local pos = cc.p(32, 42)
	for i = 12, 18 do
		local frame = SoraDGetChildByName(self, "frame_LegendaryKing_countdown_" .. i)
		if frame then
			local effectNode = SoraDCreatAnimation("timerLabelActivityEffect")
			if effectNode then
				effectNode:addTo(frame)
				effectNode:setPosition(pos)
				effectNode:setScale(1.05)
			end
		end
	end
end
return timerLabelActivity
