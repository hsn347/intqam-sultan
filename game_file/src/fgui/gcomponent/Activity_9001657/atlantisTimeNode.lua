local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseComponent = require("fgui.base.baseComponent")
local atlantisTimeNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001657/atlantisTimeNode", atlantisTimeNode)
function atlantisTimeNode:onInit()
	self.numArray, _ENV = nil, nil
	self.nodeTimeCooling = self.fields.Node_TimeCooling
	self.nodeTimeCooling:setScale(0.9)
	local _fields = fguiHelper.get_fields(self.nodeTimeCooling)
	self.spCountdown = _fields.frame_countdown_7
	self.nodeNum = _fields.Node_Num
	self:initData()
end
function atlantisTimeNode:onShow()
end
function atlantisTimeNode:initData()
	for i = 1, 7 do
		local numChar = cc.Label:createWithCharMap("fonts/icon_acitivity_num.png", 35, 46, 48)
		numChar:setAnchorPoint(cc.p(0.5, 0.5))
		numChar:setPosition(0, 0)
		numChar:addTo(self.nodeNum)
		numChar:setContentSize(cc.size(35, 46))
		self.numArray[i] = numChar
	end
	_UPVALUE6_ = nil
	;(nil)[1] = 49
	;(nil)[2] = 49
	;(nil)[3] = 85
	;(nil)[4] = 49
	;(nil)[5] = 85
	;(nil)[6] = 49
	SoraDAlignNodeArray(self.numArray, false, nil)
end
function atlantisTimeNode:setTime(endTime)
	if not endTime then
		return
	end
	local timeStr = SoraDConvertSecondToStringNoDay(endTime)
	local splitTime = string.split(timeStr, ":")
	if string.len(splitTime[1]) >= 3 then
		if tonumber(splitTime[1]) and tonumber(splitTime[1]) > 999 then
			splitTime[1] = tostring(999)
		end
		self.spCountdown:setVisible(true)
		self.numArray[1]:setVisible(true)
		self.nodeTimeCooling:setPositionX(42)
		_UPVALUE6_ = self.nodeTimeCooling.setPositionX
		self.nodeTimeCooling.setPositionX[1] = string.sub(splitTime[1], 1, 1)
		self.nodeTimeCooling.setPositionX[2] = string.sub(splitTime[1], 2, 2)
		self.nodeTimeCooling.setPositionX[3] = string.sub(splitTime[1], 3, 3)
		self.nodeTimeCooling.setPositionX[4] = string.sub(splitTime[2], 1, 1)
		self.nodeTimeCooling.setPositionX[5] = string.sub(splitTime[2], 2, 2)
		self.nodeTimeCooling.setPositionX[6] = string.sub(splitTime[3], 1, 1)
		self.nodeTimeCooling.setPositionX[7] = string.sub(splitTime[3], 2, 2)
		self.nodeTimeCooling.setPositionX[8] = string.sub(splitTime[3], 2, 2)
		self.nodeTimeCooling.setPositionX[9] = string.sub(splitTime[3], 2, 2)
		local self.nodeTimeCooling.setPositionX[10], strArray = string.sub(splitTime[3], 2, 2)
		for i = 1, #strArray do
			if self.numArray[i] then
				self.numArray[i]:setString(strArray[i])
			end
		end
	else
		self.nodeTimeCooling:setPositionX(0)
		self.spCountdown:setVisible(false)
		self.numArray[1]:setVisible(false)
		_UPVALUE5_ = self.numArray[1].setVisible
		self.numArray[1].setVisible[1] = string.sub(timeStr, 1, 1)
		self.numArray[1].setVisible[2] = string.sub(timeStr, 2, 2)
		self.numArray[1].setVisible[3] = string.sub(timeStr, 4, 4)
		self.numArray[1].setVisible[4] = string.sub(timeStr, 5, 5)
		self.numArray[1].setVisible[5] = string.sub(timeStr, 7, 7)
		self.numArray[1].setVisible[6] = string.sub(timeStr, 8, 8)
		self.numArray[1].setVisible[7] = string.sub(timeStr, 8, 8)
		self.numArray[1].setVisible[8] = string.sub(timeStr, 8, 8)
		self.numArray[1].setVisible[9] = string.sub(timeStr, 8, 8)
		local self.numArray[1].setVisible[10], strArray = string.sub(timeStr, 8, 8)
		for i = 1, #strArray do
			if self.numArray[i + 1] then
				self.numArray[i + 1]:setString(strArray[i])
			end
		end
	end
end
function atlantisTimeNode:setTimeScale(scale)
	self.nodeTimeCooling:setScale(scale)
end
function atlantisTimeNode:initActivityData(activityID)
	self.activityID = activityID
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self:openTimeUp()
end
function atlantisTimeNode:openTimeUp()
	local time = activityShowCtrl:getRemainTime(self.activityID)
	self:setTime(time)
end
return atlantisTimeNode
