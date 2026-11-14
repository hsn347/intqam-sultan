local itemDesRead = include("itemDesRead")
local materialSingle = class("materialSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("materialSingle")
	end
	return target
end)
function materialSingle:ctor()
	self.materialID = nil
	self.isShort = false
	self.btnMaterial = SoraDGetChildByName(self, "Button_material")
	self.labelNum = SoraDGetChildByName(self, "Text_num")
	self.btnMaterial:setSwallowTouches(false)
	self.btnMaterial:setPressedActionEnabled(false)
	self.labelNum:setVisible(false)
	self.spriteBg = SoraDGetChildByName(self, "Sprite_bg")
	self.spriteIcon = SoraDGetChildByName(self, "Sprite_icon")
	self.btnMaterial:addTouchEventListener(handler(self, self.btnClickCallBack))
end
function materialSingle:initData(mid, isLight)
	self.materialID = mid
	self.isShort = isLight or false
	self:initView()
end
function materialSingle:initSuitForgeMaterial(mid, needCount, ownCount, quality, needFlicker)
	_ENV = nil
	;(nil).mid = mid
	;(nil).needCount = needCount
	;(nil).ownCount = ownCount
	_ENV, (nil).quality = nil, quality
	;(nil).gray = needFlicker
	;(nil).rotate = true
	;(nil).touch = mid
	;(nil).type = gEquipMaterialType.MATERIAL
	self:initSuitData(nil, nil)
end
function materialSingle:initSuitData(data, other)
	self.data = data
	if other ~= nil then
		self.other = other
	end
	self:initView()
	if self.data.needCount and self.data.ownCount then
		self.labelNum:setVisible(true)
		if self.data.ownCount <= 0 or self.data.ownCount < self.data.needCount then
			self.labelNum:setColor(cc.c3b(255, 0, 0))
		else
			self.labelNum:setColor(cc.c3b(255, 255, 255))
		end
		self.labelNum:setString(string.format("%d/%d", self.data.ownCount, self.data.needCount))
	end
	self:initRotate()
	self:initTouch()
end
function materialSingle:initView()
	if self.materialID then
		self.spriteBg:setSpriteFrame(itemDesRead.getBg(self.materialID))
		self.spriteIcon:setSpriteFrame(itemDesRead.getIcon(self.materialID))
		self.spriteIcon:setScale(0.6)
	elseif self.data and self.data.mid then
		self.spriteBg:setSpriteFrame(itemDesRead.getBg(self.data.mid))
		self.spriteIcon:setSpriteFrame(itemDesRead.getIcon(self.data.mid))
		self.spriteIcon:setScale(0.6)
	else
		self.spriteIcon:setSpriteFrame("frame_equip_09.png")
		self.spriteIcon:setScale(0.85)
	end
	self:initGray()
end
function materialSingle:initGray()
	self.spriteIcon:stopAllActions()
	if self.isShort then
		if self.spriteGray == nil then
			self.spriteGray = display.newGraySprite(itemDesRead.getIcon(self.materialID, true))
			self.spriteGray:setAnchorPoint(cc.p(0.5, 0.5))
			self.spriteGray:setPosition(cc.p(0, 0))
			self.spriteGray:setScale(0.6)
			self.spriteGray:setOpacity(0)
			self.spriteGray:addTo(self)
		else
			self.spriteGray:stopAllActions()
		end
		self.spriteIcon:setSpriteFrame("icon_add.png")
		self.spriteIcon:setScale(1)
		_UPVALUE4_ = cc.p(0, 0)
		cc.p(0, 0)[1] = cca.delay(1.3)
		cc.p(0, 0)[2] = cca.fadeIn(0.8)
		cc.p(0, 0)[3] = cca.delay(0.5)
		cc.p(0, 0)[4] = cca.fadeOut(0.8)
		cc.p(0, 0)[5] = cca.delay(0.8)
		cc.p(0, 0)[6] = cca.delay(0.8)
		self.spriteGray:runAction(cca.repeatForever(cca.seq(cc.p(0, 0))))
		_UPVALUE3_ = cca.repeatForever(cca.seq(cc.p(0, 0)))
		cca.repeatForever(cca.seq(cc.p(0, 0)))[1] = cca.delay(0.5)
		cca.repeatForever(cca.seq(cc.p(0, 0)))[2] = cca.fadeOut(0.8)
		cca.repeatForever(cca.seq(cc.p(0, 0)))[3] = cca.delay(2.1)
		cca.repeatForever(cca.seq(cc.p(0, 0)))[4] = cca.fadeIn(0.8)
		cca.repeatForever(cca.seq(cc.p(0, 0)))[5] = cca.fadeIn(0.8)
		cca.repeatForever(cca.seq(cc.p(0, 0)))[6] = cca.fadeIn(0.8)
		self.spriteIcon:runAction(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cc.p(0, 0))))))
		self.spriteBg:setVisible(false)
	else
		if self.spriteGray then
			self.spriteGray:removeFromParent()
			self.spriteGray = nil
		end
		self.spriteBg:setVisible(true)
		self.spriteIcon:setVisible(true)
		self.spriteIcon:setOpacity(255)
	end
end
function materialSingle:initRotate()
	if self.other and self.other.rotate then
		self.spriteBg:setPositionX(-1)
		self.spriteIcon:setPositionX(-1)
		self.btnMaterial:setRotation(0)
	else
		self.spriteBg:setPositionX(0)
		self.spriteIcon:setPositionX(0)
		self.btnMaterial:setRotation(90)
	end
end
function materialSingle:initTouch()
	if self.other and self.other.touch then
		self.btnMaterial:setTouchEnabled(true)
		self.btnMaterial:setSwallowTouches(false)
	else
		self.btnMaterial:setTouchEnabled(false)
	end
end
function materialSingle:setTouchEnabled(ret)
	self.btnMaterial:setTouchEnabled(ret)
end
function materialSingle:setHandle(handle)
	self.handle = handle
end
function materialSingle:btnClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.handle then
			if self.materialID then
				self.handle(self.materialID, self)
			else
				self.handle(self.data.mid, self)
			end
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if self.scroll and tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self:stopAllActions()
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return materialSingle
