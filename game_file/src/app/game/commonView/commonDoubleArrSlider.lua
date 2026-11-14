local commonDoubleArrSlider = class("commonDoubleArrSlider", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonDoubleArrSlider")
	end
	return target
end)
function commonDoubleArrSlider:ctor()
	self.panelMask = SoraDGetChildByName(self, "Panel_mask")
	self.panelTouch = SoraDGetChildByName(self, "Panel_touch")
	self.imgFrm = SoraDGetChildByName(self, "Image_frm")
	self.imgLoad = SoraDGetChildByName(self, "Image_load")
	self.txtMax = SoraDGetChildByName(self, "Text_max")
	self.txtMin = SoraDGetChildByName(self, "Text_min")
	self.txtLimit = SoraDGetChildByName(self, "Text_limit")
	self.btnLFlat = SoraDGetChildByName(self, "Button_lFlat")
	self.btnRFlat = SoraDGetChildByName(self, "Button_rFlat")
	self.btnLFlat:setSwallowTouches(false)
	self.btnRFlat:setSwallowTouches(false)
	self.panelTouch:addTouchEventListener(handler(self, self.panelTouchClick))
	self.imgDisLoad = SoraDGetChildByName(self, "Image_disLoad")
	SoraDSetGray(self.imgDisLoad, true)
	self.imgDisLoad:setVisible(false)
	self.realWidth = 248
	self.range, _ENV, self.startMove = self.imgDisLoad.setVisible, self.imgDisLoad.setVisible, 0
end
function commonDoubleArrSlider:init(long, min, max, handler, disRange)
	if long then
		self:setMeSize(long)
	end
	self:setRange(min, max)
	self:initView()
	if handler then
		self:setEndHandler(handler)
	end
	if disRange then
		self.imgDisLoad:setVisible(true)
		self.disRange = disRange
		self.txtLimit:setString(disRange.min)
		self:initDisRange()
	end
end
function commonDoubleArrSlider:initDisRange()
	if SoraDFIsRA() then
		local lQuarter = -self.realWidth / 2
		local RQuarter = -self.realWidth / 2 + (self.range.max - self.disRange.min) * self.range.dis
		self.panelMask:setPositionX(lQuarter)
		self.txtLimit:setPositionX(RQuarter)
		self.panelMask:setContentSize(cc.size(RQuarter - lQuarter, 18))
		self.disRange.disMax = RQuarter
	else
		local lQuarter = -self.realWidth / 2 + (self.disRange.min - 1) * self.range.dis
		local RQuarter = self.realWidth / 2
		self.panelMask:setPositionX(RQuarter)
		self.txtLimit:setPositionX(lQuarter)
		self.panelMask:setContentSize(cc.size(RQuarter - lQuarter, 18))
		self.imgDisLoad:setPositionX(RQuarter - lQuarter)
		self.disRange.disMax = lQuarter
	end
end
function commonDoubleArrSlider:setMeSize(long)
	self.panelTouch:setContentSize(cc.size(long + 32, 50))
	self.imgLoad:setContentSize(cc.size(long, 18))
	self.imgDisLoad:setContentSize(cc.size(long, 18))
	self.panelMask:setContentSize(cc.size(long, 20))
	if SoraDFIsRA() then
		self.imgDisLoad:setPositionX(0)
		self.txtMax:setPositionX(-long / 2)
		self.txtMin:setPositionX(long / 2)
	else
		self.imgDisLoad:setPositionX(long)
		self.txtMax:setPositionX(long / 2)
		self.txtMin:setPositionX(-long / 2)
	end
	self.imgFrm:setContentSize(cc.size(long + 8, 24))
	self.imgLoad:setPositionX(-long / 2)
	self.realWidth = long
end
function commonDoubleArrSlider:setRange(_min, _max)
	local dis = self.realWidth / (_max - _min)
	_UPVALUE0_ = _max - _min
	;(_max - _min).min = _min
	;(_max - _min).max = _max
	;(_max - _min).dis = dis
	;(_max - _min).minP = -self.realWidth / 2
	self.range, (_max - _min).maxP = _max - _min, self.realWidth / 2
	self.btnLFlat:setPositionX(-self.realWidth / 2)
	self.btnRFlat:setPositionX(self.realWidth / 2)
	self.txtMax:setString(self.range.max)
	self.txtMin:setString(self.range.min)
end
function commonDoubleArrSlider:setEndHandler(handl)
	self.endCallBackHand = handl
end
function commonDoubleArrSlider:initView(...)
	self.btnLFlat:addTouchEventListener(handler(self, self.btnLFlatClick))
	self.btnRFlat:addTouchEventListener(handler(self, self.btnRFlatClick))
end
function commonDoubleArrSlider:panelTouchClick(button, eventType)
	if eventType == ccui.TouchEventType.moved then
		if self.endCallBackHand then
			local min, max = self:getResult()
			self.endCallBackHand(min, max)
		end
	elseif (eventType == ccui.TouchEventType.canceled or eventType == ccui.TouchEventType.ended) and self.endCallBackHand then
		self:autoQuarter()
		local min, max = self:getResult()
		self.endCallBackHand(min, max)
	end
end
function commonDoubleArrSlider:getResult(...)
	local lPosX = self.btnLFlat:getPositionX()
	local rPosX = self.btnRFlat:getPositionX()
	local lRange = (lPosX - self.range.minP - self.range.dis / 2) / self.range.dis
	lRange = 0 < lRange and math.ceil(lRange) or 0
	local rRange = (rPosX - self.range.minP - self.range.dis / 2) / self.range.dis
	rRange = 0 < rRange and math.ceil(rRange) or 0
	print("lRange=", lRange, "rRange=", rRange)
	if SoraDFIsRA() then
		local min = self.range.max - rRange
		local max = self.range.max - lRange
		return min, max
	else
		local max = rRange + 1
		local min = lRange + 1
		return min, max
	end
end
function commonDoubleArrSlider:autoQuarter(...)
	local lPosX = self.btnLFlat:getPositionX()
	local rPosX = self.btnRFlat:getPositionX()
	local lRange = (lPosX - self.range.minP - self.range.dis / 2) / self.range.dis
	lRange = 0 < lRange and math.ceil(lRange) or 0
	local rRange = (rPosX - self.range.minP - self.range.dis / 2) / self.range.dis
	rRange = 0 < rRange and math.ceil(rRange) or 0
	self:setQuarter(lRange + 1, rRange + 1)
	return lRange + 1, rRange + 1
end
function commonDoubleArrSlider:setValueQuarter(min, max)
	if SoraDFIsRA() then
		local max = self.range.max - max + 1
		local min = self.range.max - min + 1
		self:setQuarter(max, min)
	else
		self:setQuarter(min, max)
	end
end
function commonDoubleArrSlider:setQuarter(lq, rq)
	print("lq=", lq, "rq=", rq)
	local lQuarter = -self.realWidth / 2 + (lq - 1) * self.range.dis
	self.btnLFlat:setPositionX(lQuarter)
	local neesSize = self.btnRFlat:getPositionX() - lQuarter
	self.imgLoad:setPositionX(lQuarter)
	self.imgLoad:setContentSize(cc.size(neesSize, 18))
	local RQuarter = -self.realWidth / 2 + (rq - 1) * self.range.dis
	self.btnRFlat:setPositionX(RQuarter)
	local neesSize = RQuarter - self.btnLFlat:getPositionX()
	self.imgLoad:setContentSize(cc.size(neesSize, 18))
end
function commonDoubleArrSlider:btnLMove2Left(ocx)
	local moveFun = function(val)
		ocx:setPositionX(val)
		local neesSize = self.btnRFlat:getPositionX() - val
		self.imgLoad:setPositionX(val)
		self.imgLoad:setContentSize(cc.size(neesSize, 18))
	end
	local pos = ocx:getTouchMovePosition()
	local setPos = self:convertToNodeSpace(pos)
	local divVal = self.btnRFlat:getPositionX()
	if SoraDFIsRA() and self.disRange then
		if divVal > setPos.x and setPos.x > self.disRange.disMax then
			moveFun(setPos.x)
		elseif setPos.x <= self.disRange.disMax then
			moveFun(self.disRange.disMax)
		elseif divVal <= setPos.x then
			moveFun(divVal)
		end
	elseif divVal > setPos.x and setPos.x > -self.realWidth / 2 then
		moveFun(setPos.x)
	elseif setPos.x <= -self.realWidth / 2 then
		moveFun(-self.realWidth / 2)
	elseif divVal <= setPos.x then
		moveFun(divVal)
	end
end
function commonDoubleArrSlider:btnRMove2Right(ocx)
	local moveFun = function(val)
		ocx:setPositionX(val)
		local neesSize = val - self.btnLFlat:getPositionX()
		self.imgLoad:setContentSize(cc.size(neesSize, 18))
	end
	local pos = ocx:getTouchMovePosition()
	local setPos = self:convertToNodeSpace(pos)
	local divVal = self.btnLFlat:getPositionX()
	if not SoraDFIsRA() and self.disRange then
		if divVal < setPos.x and setPos.x < self.disRange.disMax then
			moveFun(setPos.x)
		elseif setPos.x >= self.disRange.disMax then
			moveFun(self.disRange.disMax)
		elseif divVal >= setPos.x then
			moveFun(divVal)
		end
	elseif divVal < setPos.x and setPos.x < self.realWidth / 2 then
		moveFun(setPos.x)
	elseif setPos.x >= self.realWidth / 2 then
		moveFun(self.realWidth / 2)
	elseif divVal >= setPos.x then
		moveFun(divVal)
	end
end
function commonDoubleArrSlider:judgeWantForward(ocx)
	if self.startMove == 0 then
		local sPos = ocx:getTouchBeganPosition()
		local pos = ocx:getTouchMovePosition()
		local judgeX = sPos.x - pos.x
		if 5 < judgeX then
			self.startMove = 1
		elseif judgeX < -5 then
			self.startMove = -1
		end
	end
end
function commonDoubleArrSlider:btnLFlatClick(button, eventType)
	if eventType == ccui.TouchEventType.began then
		self.lBtnHold = true
	elseif eventType == ccui.TouchEventType.moved then
		if self.lBtnHold and self.rBtnHold then
			self:judgeWantForward(button)
			if self.startMove > 0 then
				self:btnLMove2Left(button)
			end
		else
			self:btnLMove2Left(button)
		end
	elseif eventType == ccui.TouchEventType.canceled or eventType == ccui.TouchEventType.ended then
		self.startMove = 0
		self.lBtnHold = false
	end
end
function commonDoubleArrSlider:btnRFlatClick(button, eventType)
	if eventType == ccui.TouchEventType.began then
		self.rBtnHold = true
	elseif eventType == ccui.TouchEventType.moved then
		if self.lBtnHold and self.rBtnHold then
			self:judgeWantForward(button)
			if self.startMove < 0 then
				self:btnRMove2Right(button)
			end
		else
			self:btnRMove2Right(button)
		end
	elseif eventType == ccui.TouchEventType.canceled or eventType == ccui.TouchEventType.ended then
		self.startMove = 0
		self.rBtnHold = false
	end
end
return commonDoubleArrSlider
