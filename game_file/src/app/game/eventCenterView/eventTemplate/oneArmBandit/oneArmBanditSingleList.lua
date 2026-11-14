local slotMachineRewardRead = include("slotMachineRewardRead")
local oneArmBanditSingleList = class("oneArmBanditSingleList", function(target)
	if target == nil then
		return display.newNode()
	end
	return target
end)
function oneArmBanditSingleList:ctor()
	self.nodeList, _UPVALUE0_ = nil, nil
	self.finalIndex = 0
	self.column = 0
	self.singleH = 100
	self.baseY = 0
	self:initWidget()
end
function oneArmBanditSingleList:initWidget()
	local singleH = self.singleH
	local baseY = self.baseY
	local node_main = display.newNode()
	node_main:addTo(self)
	node_main.posY = baseY
	node_main:setPositionY(node_main.posY)
	node_main.singleList, _ENV, node_main.row = node_main.setPositionY, node_main.setPositionY, 2
	self.node_main = node_main
	local node_copy = display.newNode()
	node_copy:addTo(self)
	node_copy.posY = baseY + singleH * 3
	node_copy:setPositionY(node_copy.posY)
	node_copy.singleList, _ENV, node_copy.row = node_copy.setPositionY, node_copy.setPositionY, 1
	_UPVALUE2_, self.node_copy = node_copy.setPositionY, node_copy
	self.nodeList, node_copy.setPositionY[1] = node_copy.setPositionY, self.node_main
	self.nodeList, node_copy.setPositionY[2] = node_copy.setPositionY, self.node_copy
	for i = 1, 3 do
		local single = SoraDCreatePanel("oneArmBanditSingle")
		single:addTo(self.node_main)
		single:setPosition(cc.p(0, i * singleH - singleH / 2))
		single:initData((i + 1) % 3 + 1)
		self[string.format("single_%d", i)] = single
		table.insert(self.node_main.singleList, single)
	end
	for i = 1, 3 do
		local single = SoraDCreatePanel("oneArmBanditSingle")
		single:addTo(self.node_copy)
		single:setPosition(cc.p(0, i * singleH - singleH / 2))
		single:initData(slotMachineRewardRead.getRandomImgIndex())
		self[string.format("single_%d", i + 3)] = single
		table.insert(self.node_copy.singleList, single)
	end
end
function oneArmBanditSingleList:runSlot()
	local delay = ONEARMBANDIT_SLOT_RUN_TIME
	local singleH = self.singleH
	local moveH = singleH * 3
	local baseY = self.baseY
	local runSlotSingle = function(node)
		delay = nil
		;(nil)[1] = cca.moveBy(delay, 0, -moveH)
		;(nil)[2] = cca.callFunc(function(...)
			if node:getPositionY() <= -moveH then
				node:setPositionY(baseY + moveH)
			end
		end)
		;(nil)[3] = cca.callFunc(function(...)
			if node:getPositionY() <= -moveH then
				node:setPositionY(baseY + moveH)
			end
		end)
		;(nil)[4] = cca.callFunc(function(...)
			if node:getPositionY() <= -moveH then
				node:setPositionY(baseY + moveH)
			end
		end)
		node:runAction(cca.repeatForever(cca.seq(nil)))
	end
	for i, v in ipairs(self.nodeList) do
		runSlotSingle(v)
	end
end
function oneArmBanditSingleList:stopSlot()
	local delay = ONEARMBANDIT_SLOT_STOP_TIME
	local singleH = self.singleH
	local moveH = singleH * 3
	local baseY = self.baseY
	local getSubIndex = function(index, num)
		local maxN = slotMachineRewardRead.getSlotShowNum()
		index = (index + num - 1) % maxN + 1
		return index
	end
	local showList = slotMachineRewardRead.getRandList(5)
	local randomIndex = self.finalIndex
	for i, v in ipairs(showList) do
		if v == randomIndex then
			randomIndex = i
			break
		end
	end
	randomIndex = getSubIndex(randomIndex, -2)
	local runSlotSingle = function(node)
		local row = node.row
		local moveBy1 = cca.moveBy(delay, 0, -moveH)
		local moveBy2 = cca.moveBy(delay, 0, -moveH)
		local moveBy3 = cca.moveBy(delay * 2, 0, -moveH)
		local moveBy4 = cca.moveBy(delay * 4, 0, -moveH)
		local callFunc1 = cca.callFunc(function(...)
			node:setPositionY(baseY + moveH)
			for i, v in ipairs(node.singleList) do
				v:initData(showList[randomIndex])
			end
		end)
		local callFunc2 = cca.callFunc(function(...)
			node:stopAllActions()
			if self.handle then
				self.handle(self.column)
				self.handle = nil
			end
		end)
		local callFunc3 = cca.callFunc(function(...)
		end)
		delay = nil
		;(nil)[1] = callFunc
		local seq = cca.seq(nil)
		if row == 1 then
			self = callFunc
			callFunc[1] = moveBy1
			callFunc[2] = moveBy2
			callFunc[3] = callFunc1
			callFunc[4] = moveBy3
			callFunc[5] = moveBy4
			callFunc[6] = callFunc1
			callFunc[7] = callFunc2
			seq = cca.seq(callFunc)
		elseif row == 2 then
			_UPVALUE8_ = callFunc
			callFunc[1] = moveBy1
			callFunc[2] = callFunc1
			callFunc[3] = moveBy2
			callFunc[4] = moveBy3
			callFunc[5] = callFunc1
			callFunc[6] = callFunc3
			callFunc[7] = moveBy4
			callFunc[8] = callFunc2
			seq = cca.seq(callFunc)
		end
		node:runAction(seq)
	end
	for i, v in ipairs(self.nodeList) do
		v:stopAllActions()
		v:setPositionY(v.posY)
		runSlotSingle(v)
	end
end
function oneArmBanditSingleList:setFinalShow(index)
	self.finalIndex = index
end
function oneArmBanditSingleList:setHandle(handle)
	self.handle = handle
end
function oneArmBanditSingleList:setColumn(column)
	self.column = column
end
return oneArmBanditSingleList
