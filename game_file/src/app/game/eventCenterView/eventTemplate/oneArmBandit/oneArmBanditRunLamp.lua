local oneArmBanditRunLamp = class("oneArmBanditRunLamp", function(target)
	if target == nil then
		return display.newNode()
	end
	return target
end)
function oneArmBanditRunLamp:ctor()
	self:initWidget()
end
function oneArmBanditRunLamp:initWidget()
	self.spList, _ENV = nil, nil
	for i = 1, 38 do
		local sp = self:createRunLampSingle(i)
		self.spList[i] = sp
		sp:addTo(self)
		sp:setPositionY(-232)
		sp:setPositionX(15 * i + 28)
	end
	for i = 1, 38 do
		local sp = self:createRunLampSingle(i)
		table.insert(self.spList, sp)
		sp:addTo(self)
		sp:setPositionY(-486)
		sp:setPositionX(15 * (39 - i) + 28)
	end
end
function oneArmBanditRunLamp:createRunLampSingle(index)
	local sp = display.newSprite("#slotmachine_red2.png")
	sp.index = index
	sp.isRunning = false
	function sp.initType()
		if sp.index % 2 == 1 then
			sp.type = 1
			sp.imgType = 1
		else
			sp.type = 2
			sp.imgType = 2
		end
		if not sp.isRunning then
			sp.type = 2
		end
	end
	function sp.initSprite(needScale)
		if sp.imgType == 1 then
			if sp.type == 1 then
				sp:setSpriteFrame("slotmachine_red1.png")
			elseif sp.type == 2 then
				sp:setSpriteFrame("slotmachine_red2.png")
			end
		elseif sp.imgType == 2 then
			if sp.type == 1 then
				sp:setSpriteFrame("slotmachine_yellow1.png")
			elseif sp.imgType == 2 then
				sp:setSpriteFrame("slotmachine_yellow2.png")
			end
		end
		if needScale then
			if sp.type == 1 then
				sp:setScale(0.8)
			elseif sp.type == 2 then
				sp:setScale(1.25)
			end
			sp:runAction(cca.scaleTo(0.15, 1.0))
		end
	end
	function sp.runSlot()
		sp.isRunning = true
		sp:stopAllActions()
		sp.initType()
		local delay = ONEARMBANDIT_LAMP_SLOT_TIME
		_ENV = nil
		;(nil)[1] = cca.delay(delay)
		;(nil)[2] = cca.callFunc(function(...)
			sp.type = sp.type % 2 + 1
			sp.initSprite(true)
		end)
		;(nil)[3] = cca.callFunc(function(...)
			sp.type = sp.type % 2 + 1
			sp.initSprite(true)
		end)
		sp:runAction(cca.repeatForever(cca.seq(nil)))
	end
	function sp.stopSlot()
		sp.isRunning = false
		sp:stopAllActions()
	end
	sp.initType()
	sp.initSprite()
	return sp
end
function oneArmBanditRunLamp:runLampNormal(...)
	for i, sp in ipairs(self.spList) do
		sp.stopSlot()
	end
	local delay = ONEARMBANDIT_LAMP_NORMAL_TIME
	self.spListIndex = 1
	_UPVALUE1_ = sp.stopSlot
	sp.stopSlot[1] = cca.delay(delay)
	sp.stopSlot[2] = cca.callFunc(function(...)
		local index = self.spListIndex
		for i, sp in ipairs(self.spList) do
			if (i - 1) % 10 + 1 == index then
				sp.type = 1
				sp.initSprite(true)
			else
				sp.type = 2
				sp.initSprite(false)
			end
		end
		self.spListIndex = self.spListIndex % 10 + 1
	end)
	sp.stopSlot[3] = cca.callFunc(function(...)
		local index = self.spListIndex
		for i, sp in ipairs(self.spList) do
			if (i - 1) % 10 + 1 == index then
				sp.type = 1
				sp.initSprite(true)
			else
				sp.type = 2
				sp.initSprite(false)
			end
		end
		self.spListIndex = self.spListIndex % 10 + 1
	end)
	self:runAction(cca.repeatForever(cca.seq(sp.stopSlot)))
end
function oneArmBanditRunLamp:runLampSlot(...)
	self:stopAllActions()
	for i, sp in ipairs(self.spList) do
		sp.runSlot()
	end
end
return oneArmBanditRunLamp
