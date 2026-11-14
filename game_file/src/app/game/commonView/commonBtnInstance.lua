local longEventTime = 0.4
local longActTag = 100
local scaleActTag = 200
local commonBtnInstance = class("commonBtnInstance", function(target)
	return target
end)
function commonBtnInstance:ctor()
	self.offsetX = 0
	self.handle = false
	self.isIgnoreMove = false
	self.scroll = nil
	self.isClickAct = false
	self.customAct = nil
	self.soundData, _ENV, self.tipParent = nil, nil, nil
	self.isLongTouch = false
	self.isLong = false
	self.isSpecialEvent = false
	self.scale = self:getScale()
	self:setTouchEnabled(true)
	self:addTouchEventListener(handler(self, self.btnClickCallBack))
end
function commonBtnInstance:setTouchSwitch(ret)
	self:setTouchEnabled(ret)
end
function commonBtnInstance:openClickActSwitch(customAct)
	self.isClickAct = true
	self.customAct = customAct
	if tolua.type(self) == "ccui.Button" then
		self:setPressedActionEnabled(false)
	end
end
function commonBtnInstance:setScroll(scroll)
	self.scroll = scroll
end
function commonBtnInstance:setIgnoreMove()
	self.isIgnoreMove = true
end
function commonBtnInstance:setTipParent(parent)
	self.tipParent = parent
end
function commonBtnInstance:testClick()
	self:btnClickCallBack(self, ccui.TouchEventType.ended, true)
end
function commonBtnInstance:setHandle(handle)
	self.isSpecialEvent = true
	self.isLongTouch = false
	self.handle = handle
end
function commonBtnInstance:setLongHandle(handle)
	self.isLongTouch = true
	self.handle = handle
end
function commonBtnInstance:setSoundConfig(classify, index, delay)
	self.soundData.classify = classify
	self.soundData.index = index
	self.soundData.delay = delay
end
function commonBtnInstance:setItemInfo(parent, itemID, itemCount, isBuff)
	self.itemID = tonumber(itemID)
	self.itemCount = tonumber(itemCount)
	self.isLongTouch = true
	self.isBuff = isBuff or false
	self:setTipParent(parent)
end
function commonBtnInstance:getData()
	return self.itemID, self.itemCount
end
function commonBtnInstance:setOffsetX(offsetX)
	self.offsetX = offsetX
end
function commonBtnInstance:showItemTip(target)
	local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
	local ret, show, isShow = backpackltCtrl:getRandomGiftShowItems(self.itemID)
	if ret and next(ret) and isShow then
		_ENV = nil
		;(nil).itemID = self.itemID
		uiManager:show("CommonItemShowBox", nil)
		return
	end
	local isDressShow = backpackltCtrl:isSkinShow(self.itemID)
	if isDressShow then
		_ENV = self.itemID
		self.itemID.itemID = self.itemID
		uiManager:show("commonDressPreview", self.itemID)
		return
	end
	if self.itemID == gBuffEffect.LEV_29_INSTANT_BUILD_SPEED_BOOST then
		local panel = SoraDCreatePanel("princeGiftBuffPreviewPopView")
		panel:show()
		return
	end
	local sType = serviceFunctions.getIDType(self.itemID)
	local buffDesRead = include("buffDesRead")
	local parent = self.tipParent or self.scroll
	if tolua.isnull(parent) then
		return
	end
	if not self.pFloor or tolua.isnull(self.pFloor) then
		self.pFloor = SoraDCreatePanel("commonItemTips")
		self.pFloor:addTo(parent or self, 99)
	else
		self.pFloor:setVisible(true)
	end
	if self.isBuff and sType ~= gIDType.ITEM and buffDesRead.isBuff(self.itemID) then
		self.pFloor:setBuffInfo(self.itemID, self.itemCount)
	else
		self.pFloor:initData(self.itemID, self.itemCount)
	end
	local pos = cc.p(0, 0)
	local height = 0
	if self.tipParent then
		parent = self.tipParent
		pos = parent:convertToNodeSpace(target:getTouchBeganPosition())
		height = parent:getContentSize().height
	elseif self.scroll then
		parent = self.scroll
		pos = parent:getInnerContainer():convertToNodeSpace(target:getTouchBeganPosition())
		height = parent:getInnerContainerSize().height
	end
	if parent then
		local containerSize = parent:getContentSize()
		local size = self.pFloor:getBgSize()
		pos.x = SoraDFIsRA() and math.min(math.max(pos.x + 0.5 * size.width, size.width + self.offsetX), containerSize.width - self.offsetX) or math.max(self.offsetX, math.min(pos.x - 0.5 * size.width, containerSize.width - size.width - self.offsetX))
		pos.y = math.max(math.min(pos.y + size.height, height), size.height)
	end
	self.pFloor:setPosition(pos)
end
function commonBtnInstance:runCustomAct()
	if self.isClickAct then
		self:stopActionByTag(scaleActTag)
		self:setScale(self.scale)
		_ENV = self
		self[1] = cc.EaseBackOut:create(cca.scaleTo(0.16666666666666666, self.scale + 0.1))
		self[2] = cc.EaseBounceOut:create(cca.scaleTo(0.5, self.scale))
		self[3] = cc.EaseBounceOut:create(cca.scaleTo(0.5, self.scale))
		self[4] = cc.EaseBounceOut:create(cca.scaleTo(0.5, self.scale))
		self[5] = cc.EaseBounceOut:create(cca.scaleTo(0.5, self.scale))
		self[6] = cc.EaseBounceOut:create(cca.scaleTo(0.5, self.scale))
		local seq = cca.seq(self)
		local action = self.customAct or seq
		action:setTag(scaleActTag)
		self:runAction(action)
	end
end
function commonBtnInstance:btnClickCallBack(target, event, isTest)
	if self.isLongTouch then
		if event == ccui.TouchEventType.began then
			if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll, event) then
				print("node is not on view")
				return
			end
			if not isTest then
				SoraDPlaySound(self.soundData.classify, self.soundData.index, self.soundData.delay)
			end
			self.isLong = false
			longEventTime = self.soundData.classify
			self.soundData.classify[1] = cca.delay(longEventTime)
			self.soundData.classify[2] = cca.callFunc(function()
				self.isLong = true
				if self.itemID then
					self:showItemTip(target)
				elseif self.handle then
					self.handle(target, event, self.itemID)
				end
			end)
			self.soundData.classify[3] = cca.callFunc(function()
				self.isLong = true
				if self.itemID then
					self:showItemTip(target)
				elseif self.handle then
					self.handle(target, event, self.itemID)
				end
			end)
			self.soundData.classify[4] = cca.callFunc(function()
				self.isLong = true
				if self.itemID then
					self:showItemTip(target)
				elseif self.handle then
					self.handle(target, event, self.itemID)
				end
			end)
			local seqLong = cca.seq(self.soundData.classify)
			seqLong:setTag(longActTag)
			self:runAction(seqLong)
		elseif event == ccui.TouchEventType.ended then
			self:stopActionByTag(longActTag)
			if self.pFloor and not tolua.isnull(self.pFloor) then
				self.pFloor:setVisible(false)
			end
			if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll, event) then
				print("node is not on view")
				return
			end
			if not self.isLong and self.isSpecialEvent and self.handle then
				self.handle(target, event, self.itemID)
			end
		elseif event == ccui.TouchEventType.moved then
			local touchBeganPoint = target:getTouchBeganPosition()
			local touchmovePoint = target:getTouchMovePosition()
			local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
			if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
				self:stopActionByTag(longActTag)
			end
		elseif event == ccui.TouchEventType.canceled then
			self:stopActionByTag(longActTag)
			if self.pFloor and not tolua.isnull(self.pFloor) then
				self.pFloor:setVisible(false)
			end
		end
		return
	end
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll, event) then
			print("node is not on view")
			return
		end
		if not self.isIgnoreMove and self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if not isTest then
			SoraDPlaySound(self.soundData.classify, self.soundData.index, self.soundData.delay)
		end
		if self.handle then
			self.handle(target, event, self.itemID)
		elseif self.itemID and self.isTouchShow then
			if self:checkIsSpecialItemShow() then
				self:showItemTip(target)
			elseif not tolua.isnull(self.pFloor) then
				self.pFloor:setVisible(false)
			end
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
		if self.pFloor and self.isTouchShow then
			self.pFloor:setVisible(false)
		end
	elseif event == ccui.TouchEventType.began then
		self.singleIsMoved = false
		if self.isTouchShow and self.itemID and not self:checkIsSpecialItemShow() then
			self:showItemTip(target)
		end
		self:runCustomAct()
	end
end
function commonBtnInstance:checkIsSpecialItemShow()
	local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
	local ret, show, isShow = backpackltCtrl:getRandomGiftShowItems(self.itemID)
	local isDressShow = backpackltCtrl:isSkinShow(self.itemID)
	print("and self.isTouchShow", isShow, isDressShow)
	return ret and next(ret) and isShow or isDressShow
end
function commonBtnInstance:setTouchShowTips(isTouchShow)
	self.isTouchShow = isTouchShow
	self.isLongTouch = false
	self.isIgnoreMove = true
end
return commonBtnInstance
