local itemDesRead = include("itemDesRead")
local equipDesRead = include("equipDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
local MaterialsListSingle = class("materialsListSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("newMaterialsListSingle")
	end
	return target
end)
function MaterialsListSingle:ctor()
	self.tableData, (nil).other, equipmentltCtrl, (nil).data, equipmentltCtrl, equipmentltCtrl = nil, nil, nil, nil, nil, nil
	self.handle = nil
	self.itemsPressHandle = nil
	self.scroll = nil
	self.singleIsMoved = false
	self.pressDelay = 0.2
	self.maxSLV = equipmentltCtrl.getStrengthenMaxLv()
	self.btnMaterial = SoraDGetChildByName(self, "Button_material")
	self.spriteBg = SoraDGetChildByName(self, "Sprite_bg")
	self.spriteIcon = SoraDGetChildByName(self, "Sprite_icon")
	self.labelNum = SoraDGetChildByName(self, "Text_num")
	self.imgNum = SoraDGetChildByName(self, "Image_textNum")
	self.imgTopNum = SoraDGetChildByName(self, "Image_topNum")
	self.labelTopNum = SoraDGetChildByName(self, "Text_topNum")
	self.nodeLimitTime = SoraDGetChildByName(self, "Node_limitTime")
	self.txtLimitTime = SoraDGetChildByName(self, "Text_timer")
	self.txtLimitTime = SoraDCreateTimerLabel(self, self.txtLimitTime)
	self.nodeRingLimitTime = SoraDGetChildByName(self, "Node_RingTime")
	self.txtRingLimitTime = SoraDGetChildByName(self, "Text_Ring_Time")
	self.txtRingLimitTime = SoraDCreateTimerLabel(self, self.txtRingLimitTime)
	self.spriteTip = nil
	self.spriteGray = nil
	self.btnMaterial:setTouchEnabled(false)
	self.labelNum:setVisible(false)
	self.imgNum:setVisible(false)
	self.imgTopNum:setVisible(false)
	self.labelTopNum:setVisible(false)
	if self.nodeLimitTime then
		self.nodeLimitTime:setVisible(false)
	end
	if self.nodeRingLimitTime then
		self.nodeRingLimitTime:setVisible(false)
	end
	self.btnMaterial:setPressedActionEnabled(false)
	self.btnMaterial:addTouchEventListener(handler(self, self.btnClickCallBack))
end
function MaterialsListSingle:initData(data, other)
	self.tableData.data = data
	if other ~= nil then
		self.tableData.other = other
	end
	self:initBaseView()
	self:initNum()
	self:initTopNum()
	self:initRotate()
	self:initTouch()
	self:initGray()
	self:initTip()
end
function MaterialsListSingle:setLabelColor(color)
	if color.num then
		self.labelNum:setColor(color.num)
	end
	if color.topNum then
	end
end
function MaterialsListSingle:initShowLimitTime(...)
	local showTime = function(bool, ticket)
		if bool then
			if self.nodeLimitTime then
				if self.tableData.other and self.tableData.other.showTimeTicket == false then
					self.nodeLimitTime:setVisible(false)
				else
					self.nodeLimitTime:setVisible(true)
					self.txtLimitTime:beginTime(ticket)
				end
			end
		elseif self.nodeLimitTime then
			self.nodeLimitTime:setVisible(false)
		end
	end
	if self.tableData.data then
		local endTime = self.tableData.data:getEquipmentEndTimeProperty()
		if endTime and 0 < endTime then
			showTime(true, endTime - serviceFunctions.systemTime())
		else
			showTime(false)
		end
	else
		showTime(false)
	end
end
function MaterialsListSingle:initShowRingLimitTime(...)
	local showTime = function(bool, ticket)
		if bool then
			if self.nodeRingLimitTime then
				if self.tableData.data:getEquipmentPart() == gEquipmentPart.RING or self.tableData.data:getEquipmentPart() == gEquipmentPart.NECKLACE then
					self.nodeRingLimitTime:setVisible(true)
					self.txtRingLimitTime:beginTime(ticket)
				else
					self.nodeRingLimitTime:setVisible(false)
				end
			end
		elseif self.nodeRingLimitTime then
			self.nodeRingLimitTime:setVisible(false)
		end
	end
	if self.tableData.data then
		local endTime = self.tableData.data:getEquipmentEndTimeProperty()
		if endTime and 0 < endTime then
			showTime(true, endTime - serviceFunctions.systemTime())
		else
			showTime(false)
		end
	else
		showTime(false)
	end
end
function MaterialsListSingle:initIsLegend(...)
	local checkEffect = function(bool)
		local effectFrame = self:getChildByName("legend_effect_frame")
		if effectFrame then
			effectFrame:setVisible(bool)
		elseif bool then
			local _x, _y = self.spriteBg:getPosition()
			local effectUI = include("effectUI")
			local effectNode = effectUI.getCoolSuqare()
			effectNode:setName("legend_effect_frame")
			effectNode:setPosition(_x, _y + 2.5)
			effectNode:addTo(self)
			effectNode:setScale(1.05)
			effectNode:setLocalZOrder(99)
		end
	end
	if self.tableData.data then
		local eType = self.tableData.data:getEquipmentType()
		if gEquipTypeDef.EQUIP_LEGEND == eType or gEquipTypeDef.EQUIP_NEBULA == eType then
			checkEffect(true)
		else
			checkEffect(false)
		end
	else
		checkEffect(false)
	end
end
function MaterialsListSingle:initBaseView()
	self.spriteIcon:setScale(0.6)
	if self.tableData.other.type == gEquipMaterialType.MATERIAL and self.tableData.data.mid then
		self.spriteBg:loadTexture(itemDesRead.getBg(self.tableData.data.mid), ccui.TextureResType.plistType)
		self.spriteIcon:setSpriteFrame(itemDesRead.getIcon(self.tableData.data.mid))
	elseif self.tableData.other.type == gEquipMaterialType.EQUIP and self.tableData.data then
		self.spriteBg:loadTexture(equipDesRead.getBg(self.tableData.data:getEquipmentQuality()), ccui.TextureResType.plistType)
		self.spriteIcon:setSpriteFrame(equipDesRead.getIcon(self.tableData.data:getEID()))
	elseif self.tableData.other.spareSprite then
		self.spriteIcon:setSpriteFrame(self.tableData.other.spareSprite)
	else
		self.spriteIcon:setSpriteFrame("frame_equip_09.png")
		self.spriteIcon:setScale(0.85)
	end
end
function MaterialsListSingle:initNum(num)
	if self.tableData.other.num then
		self.labelNum:setVisible(true)
		self.imgNum:setVisible(true)
		self.labelNum:setString(num or self.tableData.other.num)
	else
		self.labelNum:setVisible(false)
		self.imgNum:setVisible(false)
	end
end
function MaterialsListSingle:initTopNum(num)
	if self.tableData.other.topNum then
		self.imgTopNum:setVisible(true)
		self.labelTopNum:setVisible(true)
		self.labelTopNum:setString(num or self.tableData.other.topNum)
	else
		self.imgTopNum:setVisible(false)
		self.labelTopNum:setVisible(false)
	end
end
function MaterialsListSingle:initRotate()
	if self.tableData.other.rotate then
		self.spriteBg:setPositionX(-1)
		self.spriteIcon:setPositionX(-1)
		self.btnMaterial:setRotation(0)
	else
		self.spriteBg:setPositionX(0)
		self.spriteIcon:setPositionX(0)
		self.btnMaterial:setRotation(90)
	end
end
function MaterialsListSingle:initTouch()
	if self.tableData.other.touch then
		self.btnMaterial:setTouchEnabled(true)
		self.btnMaterial:setSwallowTouches(false)
	else
		self.btnMaterial:setTouchEnabled(false)
	end
end
function MaterialsListSingle:initGray()
	self.spriteIcon:stopAllActions()
	if self.tableData.other.gray then
		if self.spriteGray == nil then
			self.spriteGray = display.newGraySprite(itemDesRead.getIcon(self.tableData.data.mid, true))
			self.spriteGray:setAnchorPoint(cc.p(0.5, 0.5))
			self.spriteGray:setPosition(cc.p(0, 62))
			self.spriteGray:setScale(0.6)
			self.spriteGray:setOpacity(0)
			self.spriteGray:addTo(self)
		else
			self.spriteGray:stopAllActions()
		end
		self.spriteIcon:setSpriteFrame("icon_add.png")
		self.spriteIcon:setScale(1)
		_UPVALUE4_ = cc.p(0, 62)
		cc.p(0, 62)[1] = cca.delay(1.3)
		cc.p(0, 62)[2] = cca.fadeIn(0.8)
		cc.p(0, 62)[3] = cca.delay(0.5)
		cc.p(0, 62)[4] = cca.fadeOut(0.8)
		cc.p(0, 62)[5] = cca.delay(0.8)
		cc.p(0, 62)[6] = cca.delay(0.8)
		self.spriteGray:runAction(cca.repeatForever(cca.seq(cc.p(0, 62))))
		_UPVALUE3_ = cca.repeatForever(cca.seq(cc.p(0, 62)))
		cca.repeatForever(cca.seq(cc.p(0, 62)))[1] = cca.delay(0.5)
		cca.repeatForever(cca.seq(cc.p(0, 62)))[2] = cca.fadeOut(0.8)
		cca.repeatForever(cca.seq(cc.p(0, 62)))[3] = cca.delay(2.1)
		cca.repeatForever(cca.seq(cc.p(0, 62)))[4] = cca.fadeIn(0.8)
		cca.repeatForever(cca.seq(cc.p(0, 62)))[5] = cca.fadeIn(0.8)
		cca.repeatForever(cca.seq(cc.p(0, 62)))[6] = cca.fadeIn(0.8)
		self.spriteIcon:runAction(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cc.p(0, 62))))))
		self.spriteBg:setVisible(false)
	elseif self.spriteGray and not self.tableData.other.gray then
		self.spriteGray:removeFromParent()
		self.spriteGray = nil
		self.spriteBg:setVisible(true)
		self.spriteIcon:setVisible(true)
		self.spriteIcon:setOpacity(255)
	end
end
function MaterialsListSingle:initTip(tip)
	if self.tableData.other.tip then
		if self.spriteTip == nil then
			self.spriteTip = display.newSprite(tip ~= nil and tip or self.tableData.other.tip)
			self.spriteTip:setPosition(cc.p(-1, 62))
			self.spriteTip:addTo(self, 1)
		end
		self.spriteTip:setVisible(true)
	elseif self.spriteTip then
		self.spriteTip:setVisible(false)
	end
end
function MaterialsListSingle:setHandle(handle)
	self.handle = handle
end
function MaterialsListSingle:getIsNeedShowTime(...)
	if self.tableData.data then
		local endTime = self.tableData.data.getEquipmentEndTimeProperty and self.tableData.data:getEquipmentEndTimeProperty() or 0
		if endTime and 0 < endTime then
			return endTime - serviceFunctions.systemTime()
		else
			return false
		end
	else
		return false
	end
end
function MaterialsListSingle:setItemPressOnBack(handle, pressDelay)
	self.itemsPressHandle = handle
	self.pressDelay = pressDelay and pressDelay or 0.2
end
function MaterialsListSingle:setScroll(scroll)
	self.scroll = scroll
end
function MaterialsListSingle:initWearEquip(data, touch, showTimeTicket)
	local tag = self:getTag()
	if data == nil then
		self.spriteBg:setVisible(false)
		equipDesRead = nil
		;(nil).spareSprite = equipDesRead.getPartGrayIcon(tag)
		;(nil).touch = touch
		;(nil).showTimeTicket = showTimeTicket
		;(nil).type = gEquipMaterialType.EQUIP
		self:initData(data, nil)
		self.spriteIcon:setScale(98 / self.spriteIcon:getContentSize().height)
	else
		local showSLV = data:getEquipmentSLV()
		local isSuitEquip = equipmentltCtrl.judgeSuitEquipByEid(data:getEID())
		local equipLv = data:getEquipmentLV()
		if isSuitEquip then
			equipLv = equipLv % 100
		end
		self.maxSLV = equipmentltCtrl.getStrengthenMaxLv(data:getEquipmentLV(), data:getEquipmentType())
		self.spriteBg:setVisible(true)
		local topNum = showSLV >= self.maxSLV and "MAX" or "+" .. showSLV
		equipDesRead = data:getEquipmentType()
		data:getEquipmentType().lv = equipLv
		local numStr = i18n("common_text_100", data:getEquipmentType())
		if data:getEquipmentPart() == gEquipmentPart.RING or data:getEquipmentPart() == gEquipmentPart.NECKLACE then
			topNum = nil
			numStr = nil
		end
		equipDesRead = data:getEquipmentType()
		data:getEquipmentType().touch = touch
		data:getEquipmentType().showTimeTicket = showTimeTicket
		data:getEquipmentType().num = numStr
		data:getEquipmentType().topNum = topNum
		data:getEquipmentType().type = gEquipMaterialType.EQUIP
		self:initData(data, data:getEquipmentType())
	end
	self.btnMaterial:setSwallowTouches(touch)
	self:initShowLimitTime()
	self:initShowRingLimitTime()
	self:initIsLegend()
end
function MaterialsListSingle:initMaterialSingle(mData)
	_ENV = nil
	;(nil).num = mData.count
	;(nil).rotate = true
	;(nil).touch = true
	;(nil).type = gEquipMaterialType.MATERIAL
	self:initData(mData, nil)
end
function MaterialsListSingle:initEquipSingle(eData)
	local showSLV = eData:getEquipmentSLV()
	self.maxSLV = equipmentltCtrl.getStrengthenMaxLv(eData:getEquipmentLV(), eData:getEquipmentType())
	equipmentltCtrl = eData:getEquipmentType()
	equipmentltCtrl = eData:getEquipmentType()
	eData:getEquipmentType().lv = eData:getEquipmentLV()
	eData:getEquipmentType().num = i18n("common_text_100", eData:getEquipmentType())
	eData:getEquipmentType().topNum = showSLV >= self.maxSLV and "MAX" or "+" .. showSLV
	eData:getEquipmentType().rotate = true
	eData:getEquipmentType().touch = true
	eData:getEquipmentType().type = gEquipMaterialType.EQUIP
	eData:getEquipmentType().tip = eData:isWearing() and "#icon_yes2.png" or nil
	self:initData(eData, eData:getEquipmentType())
end
function MaterialsListSingle:initIntensifyEquipSingle(eData, showSLV)
	local showSLV = showSLV or eData:getEquipmentSLV()
	self.maxSLV = equipmentltCtrl.getStrengthenMaxLv(eData:getEquipmentLV(), eData:getEquipmentType())
	equipmentltCtrl = eData:getEquipmentType()
	eData:getEquipmentType().topNum = showSLV >= self.maxSLV and "MAX" or "+" .. showSLV
	eData:getEquipmentType().type = gEquipMaterialType.EQUIP
	eData:getEquipmentType().showTimeTicket = false
	self:initData(eData, eData:getEquipmentType())
	self:initShowLimitTime()
	self:initIsLegend()
end
function MaterialsListSingle:initForgeMaterial(mid, needFlicker)
	_ENV = nil
	_ENV, (nil).mid = nil, mid
	;(nil).gray = needFlicker
	;(nil).rotate = true
	;(nil).touch = mid
	;(nil).type = gEquipMaterialType.MATERIAL
	self:initData(nil, nil)
end
function MaterialsListSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if self.itemsPressHandle then
			self:stopAllActions()
			self.itemsPressHandle(nil)
		end
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.handle then
			self.handle(self.tableData.data, self, button)
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if self.scroll and tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self:stopAllActions()
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		if self.itemsPressHandle then
			self.itemsPressHandle(nil)
		end
		self.singleIsMoved = false
	elseif type == ccui.TouchEventType.began then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll, type) then
			print("node is not on view")
			return
		end
		if self.itemsPressHandle then
			_UPVALUE1_ = type
			type[1] = cca.delay(self.pressDelay)
			type[2] = cca.callFunc(function(...)
				self.itemsPressHandle(self.tableData.data, self, button)
				self.singleIsMoved = true
			end)
			type[3] = cca.callFunc(function(...)
				self.itemsPressHandle(self.tableData.data, self, button)
				self.singleIsMoved = true
			end)
			self:runAction(cca.seq(type))
		end
	end
end
return MaterialsListSingle
