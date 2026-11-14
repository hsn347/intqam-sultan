local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_2048_MainPanel = class("Activity_2048_MainPanel", baseFguiPanel)
function Activity_2048_MainPanel:ctor(...)
	Activity_2048_MainPanel.super.ctor(self, ...)
	print("Activity_2048_MainPanel:ctor", self.viewName)
	self.debug = true
	self.steps = 0
	self.mapDataCopy, Activity_2048_MainPanel, self.score = print, print, 0
end
function Activity_2048_MainPanel:onInit()
	print("=======Activity_2048_MainPanel:onInit")
	self.fields.Com_title:initData(i18n("2048"), handler(self, self.onClickClose))
	self.fields.Com_map:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onEventTouchBegin))
	self.fields.Com_map:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onEventTouchEnd))
	_UPVALUE1_ = self.fields.Com_map.addEventListener
	_UPVALUE5_, self.fields.Com_map.addEventListener[1] = cc.p(1, 1), cc.p(1, 1)
	_UPVALUE5_, self.fields.Com_map.addEventListener[2] = cc.p(1, 1), cc.p(2, 2)
	_UPVALUE5_, self.fields.Com_map.addEventListener[3] = cc.p(1, 1), cc.p(2, 2)
	_UPVALUE5_, self.fields.Com_map.addEventListener[4] = cc.p(1, 1), cc.p(2, 2)
	_UPVALUE5_, self.fields.Com_map.addEventListener[5] = cc.p(1, 1), cc.p(2, 2)
	_UPVALUE5_, self.fields.Com_map.addEventListener[6] = cc.p(1, 1), cc.p(2, 2)
	_UPVALUE5_, self.fields.Com_map.addEventListener[7] = cc.p(1, 1), cc.p(2, 2)
	_UPVALUE5_, self.fields.Com_map.addEventListener[8] = cc.p(1, 1), cc.p(2, 2)
	_UPVALUE5_, self.fields.Com_map.addEventListener[9] = cc.p(1, 1), cc.p(2, 2)
	local _UPVALUE5_, self.fields.Com_map.addEventListener[10], config = cc.p(1, 1), cc.p(2, 2)
	self.objMap, _ENV, cc.p(1, 1)[1] = 1, 1, 1
	self.objMap, _ENV, cc.p(1, 1)[2] = 1, 1, 1
	self.objMap, _ENV, cc.p(1, 1)[3] = 1, 1, 2
	self.objMap, _ENV, cc.p(1, 1)[4] = 1, 1, 3
	local self.objMap, _ENV, cc.p(1, 1)[5], config2 = 1, 1, 4, cc.p(1, 1)
	self.randomMax = 2
	for i, tilePos in ipairs(config) do
		_ENV = cc.p(2, 2)
		cc.p(2, 2).tilePos = tilePos
		cc.p(2, 2).value = config2[i]
		self:createObjSingle(cc.p(2, 2))
	end
	dump(self.objMap, "==self.objMap=111=")
	self:initCheatButtons()
	self:updateStepsAndScore()
end
function Activity_2048_MainPanel:onShow()
	print("=======Activity_2048_MainPanel:onShow")
end
function Activity_2048_MainPanel:initCheatButtons(...)
	self.fields.Button_cheat1:setString("返回上一步")
	self.fields.Button_cheat1:addClickListener(handler(self, self.onClickBtnCheat))
end
function Activity_2048_MainPanel:onClickBtnCheat(EventContext)
	SoraDPlaySound()
	local button = EventContext:getSender()
	if button == self.fields.Button_cheat1 then
		local preStep = self.steps - 1
		local mapData = self.mapDataCopy[preStep]
		if not mapData then
			return
		end
		self.mapDataCopy[preStep] = nil
		for __, obj in pairs(self.objMap) do
			obj:removeFromParent()
		end
		self.objMap, _ENV = pairs(self.objMap)
		for __, v in pairs(mapData.objData) do
			_ENV = nil
			;(nil).tilePos = v.tilePos
			;(nil).value = v.value
			self:createObjSingle(nil)
		end
		self.steps = mapData.steps
		self.score = mapData.score
		self:updateStepsAndScore()
	end
end
function Activity_2048_MainPanel:createObjSingle(data)
	local obj = fgui.UIPackage:createObject("Activity_9001638", "Com_bubble2")
	obj:addTo(self.fields.Com_map)
	local value = data.value or math.random(1, self.randomMax)
	self:updateObjValue(obj, value)
	obj.tilePos = data.tilePos
	obj:setPosition(self:tilePos2mapPos(obj.tilePos))
	self.objMap[self:getKey(obj.tilePos)] = obj
end
function Activity_2048_MainPanel:updateObjValue(obj, value)
	obj.value = value
	obj:setString(math.pow(2, obj.value - 1))
	obj:getChild("Image_color"):setColor(cc.c3b(100 + obj.value * 20, 0, 0))
	local randomMax = value - 6
	if randomMax > self.randomMax then
		self.randomMax = randomMax
	end
end
function Activity_2048_MainPanel:updateStepsAndScore(...)
	self.fields.Text_steps:setString("步数：" .. self.steps)
	self.fields.Text_score:setString("分数：" .. self.score)
end
function Activity_2048_MainPanel:onEventTouchBegin(context)
	context:captureTouch()
	self.beginPos = context:getInput():getPosition()
end
function Activity_2048_MainPanel:onEventTouchEnd(context)
	if not self.beginPos then
		return
	end
	local endPos = context:getInput():getPosition()
	local dir = "cc.p(0, 0)"
	local diff = cc.p(endPos.x - self.beginPos.x, endPos.y - self.beginPos.y)
	self.beginPos = nil
	if math.abs(diff.x) <= 5 and math.abs(diff.y) <= 5 then
		return
	end
	if math.abs(diff.x) > math.abs(diff.y) then
		if diff.x > 0 then
			dir = "cc.p(1, 0)"
		else
			dir = "cc.p(-1, 0)"
		end
	elseif diff.y > 0 then
		dir = "cc.p(0, 1)"
	else
		dir = "cc.p(0, -1)"
	end
	for __, obj in pairs(self.objMap) do
		obj.isChange = false
	end
	local _ENV, objData = (for generator), pairs(self.objMap)
	for key, obj in pairs(self.objMap) do
		_ENV = nil
		;(nil).tilePos = obj.tilePos
		objData[key], (nil).value = nil, obj.value
	end
	_ENV = pairs(self.objMap)
	pairs(self.objMap).objData = objData
	pairs(self.objMap).steps = self.steps
	self.mapDataCopy[self.steps], pairs(self.objMap).score = pairs(self.objMap)
	if dir == "cc.p(0, -1)" then
		self:onDirUp()
	elseif dir == "cc.p(0, 1)" then
		self:onDirDown()
	elseif dir == "cc.p(-1, 0)" then
		self:onDirLeft()
	elseif dir == "cc.p(1, 0)" then
		self:onDirRight()
	end
	local _ENV, randomList = self.onDirRight, self.onDirRight
	for x = 1, 4 do
		for y = 1, 4 do
			if not self.objMap[self:getKey(x, y)] then
				table.insert(randomList, cc.p(x, y))
			end
		end
	end
	if 0 < #randomList then
		local tilePos = randomList[math.random(1, #randomList)]
		_ENV = nil
		;(nil).tilePos = tilePos
		;(nil).value = math.random(1, self.randomMax)
		self:createObjSingle(nil)
	end
	self.steps = self.steps + 1
	self:updateStepsAndScore()
end
function Activity_2048_MainPanel:tilePos2mapPos(tilePos)
	return cc.p((tilePos.x - 1) * 80, (tilePos.y - 1) * 80)
end
function Activity_2048_MainPanel:getKey(x, y)
	if type(x) == "table" then
		return x.x .. "," .. x.y
	else
		return x .. "," .. y
	end
end
function Activity_2048_MainPanel:checkObjMap(obj, x, y)
	local pre_obj = self.objMap[self:getKey(x, y)]
	if not pre_obj then
		self.objMap[self:getKey(obj.tilePos)] = nil
		obj.tilePos = cc.p(x, y)
		obj:setPosition(self:tilePos2mapPos(obj.tilePos))
		self.objMap[self:getKey(x, y)] = obj
	else
		if obj.value == pre_obj.value and not pre_obj.isChange then
			self.objMap[self:getKey(obj.tilePos)] = nil
			local value = pre_obj.value + 1
			self:updateObjValue(pre_obj, value)
			pre_obj.isChange = true
			self.score = self.score + math.pow(2, obj.value - 1)
			obj:removeFromParent()
		end
		return true
	end
end
function Activity_2048_MainPanel:onDirUp(...)
	local checkObj = function(x, y)
		local obj = self.objMap[self:getKey(x, y)]
		if not obj then
			return
		end
		for _y = y - 1, 1, -1 do
			if self:checkObjMap(obj, x, _y) then
				break
			end
		end
	end
	for y = 2, 4 do
		for x = 1, 4 do
			checkObj(x, y)
		end
	end
end
function Activity_2048_MainPanel:onDirDown(...)
	local checkObj = function(x, y)
		local obj = self.objMap[self:getKey(x, y)]
		if not obj then
			return
		end
		for _y = y + 1, 4 do
			if self:checkObjMap(obj, x, _y) then
				break
			end
		end
	end
	for y = 3, 1, -1 do
		for x = 1, 4 do
			checkObj(x, y)
		end
	end
end
function Activity_2048_MainPanel:onDirLeft(...)
	local checkObj = function(x, y)
		local obj = self.objMap[self:getKey(x, y)]
		if not obj then
			return
		end
		for _x = x - 1, 1, -1 do
			if self:checkObjMap(obj, _x, y) then
				break
			end
		end
	end
	for x = 2, 4 do
		for y = 1, 4 do
			checkObj(x, y)
		end
	end
end
function Activity_2048_MainPanel:onDirRight(...)
	local checkObj = function(x, y)
		local obj = self.objMap[self:getKey(x, y)]
		if not obj then
			return
		end
		for _x = x + 1, 4 do
			if self:checkObjMap(obj, _x, y) then
				break
			end
		end
	end
	for x = 3, 1, -1 do
		for y = 1, 4 do
			checkObj(x, y)
		end
	end
end
return Activity_2048_MainPanel
