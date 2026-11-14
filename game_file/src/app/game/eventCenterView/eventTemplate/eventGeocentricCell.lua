local eventGeocentricCell = class("eventGeocentricCell", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventGeocentricCell")
	end
	return target
end)
function eventGeocentricCell:ctor()
	self:initControls()
end
function eventGeocentricCell:initControls()
	self.nodeItem = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItems_item")
	self.frameSquare = SoraDGetChildByName(self, "frame_square_15_2")
	self.frameDiscount = SoraDGetChildByName(self, "frame_smsr_bq_1")
	self.txtDiscount = SoraDGetChildByName(self, "Text_1")
	self.frameBG = SoraDGetChildByName(self, "frame_sheer_items_3")
	self.txtNum = SoraDGetChildByName(self, "Text_num")
	self.nodeItem:setSwallowTouches(false)
	self.nodeItem:setPressedActionEnabled(false)
	self.nodeItem:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.target = nil
	self.itemsManagerHandle = nil
	self.itemId = 0
end
function eventGeocentricCell:initData(itemId, itemNum)
	_UPVALUE0_ = nil
	;(nil).itemID = itemId
	;(nil).itemCount = itemNum
	self.nodeItem:initData(nil)
	self.itemId = itemId
end
function eventGeocentricCell:setClickDelegate(handle)
	self.itemsManagerHandle = handle
end
function eventGeocentricCell:sendParentToButton(parent)
	self.target = parent
end
function eventGeocentricCell:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		SoraDPlaySound()
		if self.itemsManagerHandle then
			self.itemsManagerHandle(self)
		end
		if self.pFloor then
			self.pFloor:removeFromParent()
			self.pFloor = nil
		end
	elseif type == ccui.TouchEventType.began and not self.pFloor then
		local pos = self.target:convertToNodeSpace(button:getTouchBeganPosition())
		self:openItem(pos)
	end
end
function eventGeocentricCell:setTipsVisible(isVisible)
	if self.pFloor then
		self.pFloor:setVisible(isVisible)
	end
end
function eventGeocentricCell:openItem(pos)
	self.pFloor = SoraDCreatePanel("commonItemTips")
	self.pFloor:initData(self.itemId)
	if SoraDFIsRA() then
		if pos.x < 280 then
			self.pFloor:setPosition(pos.x + 280, pos.y + 40)
		else
			self.pFloor:setPosition(pos.x, pos.y + 40)
		end
	elseif pos.x > 360 then
		self.pFloor:setPosition(pos.x - 280, pos.y + 40)
	else
		self.pFloor:setPosition(pos.x, pos.y + 40)
	end
	if self.target then
		self.pFloor:addTo(self.target, 100)
	end
end
function eventGeocentricCell:setButtonEnable(bool)
	self.nodeItem:setTouchEnabled(bool)
end
function eventGeocentricCell:hideInChristmasTreeMaking()
	self.frameBG:setVisible(false)
	self.txtNum:setVisible(false)
end
function eventGeocentricCell:getItemID(...)
	return self.itemId
end
return eventGeocentricCell
