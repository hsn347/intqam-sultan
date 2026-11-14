local ClowBoxView = class("clowBoxView", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("clowBoxView")
	end
	return target
end)
function ClowBoxView:ctor()
	self:setBackGround(204.0)
	self.isHidePrePanel = false
	self:setLocalZOrder(50)
	self.tableResult, _ENV = self.setLocalZOrder, self.setLocalZOrder
	self.isShow = false
	self.spriteBox = nil
	self.spriteClow = nil
	self:addTouchEventListener(handler(self, self.btnClickCallBack))
	if display.getAnimationCache("clowBoxAnimation") == nil then
		local frames = display.newFrames("et_clown_box_%.2d.png", 1, 12)
		local animation = display.newAnimation(frames, 0.1)
		display.setAnimationCache("clowBoxAnimation", animation)
	end
	if display.getAnimationCache("clowAnimation") == nil then
		local frames = display.newFrames("et_clown_red_%.2d.png", 1, 11)
		local animation = display.newAnimation(frames, 0.1)
		display.setAnimationCache("clowAnimation", animation)
	end
end
function ClowBoxView:initData(result)
	self.tableResult = result
	if self.tableResult and #self.tableResult >= 1 then
		self:showBox()
	else
		self:showClow()
	end
end
function ClowBoxView:showResult()
	local _ENV, list
	if self.tableResult and #self.tableResult == 1 then
		SoraDPopGainItem(self.tableResult[1].id, self.tableResult[1].count)
	elseif self.tableResult and #self.tableResult > 1 then
		for _, item in ipairs(self.tableResult) do
			list[item.id] = item.count
		end
		SoraDOpenGiftView(list)
	elseif self.spriteBox == nil and self.spriteClow == nil then
		SoraDShowMsgTip(i18n("common_text_2769"))
	else
		local spriteNotice = display.newSprite("#frame_guide_05.png", display.cx, display.cy + 190)
		spriteNotice:setScaleX(0.7)
		spriteNotice:setScaleY(0.6)
		spriteNotice:addTo(self)
		spriteNotice:setOpacity(0)
		spriteNotice:runAction(cca.fadeIn(0.5))
		_ENV = spriteNotice
		spriteNotice.text = i18n("common_text_2769")
		spriteNotice.size = 22
		spriteNotice.color = cc.c3b(55, 30, 5)
		spriteNotice.align = SoraDFLabelR()
		spriteNotice.valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
		spriteNotice.dimensions = cc.size(300, 100)
		spriteNotice.x = display.cx
		spriteNotice.y = display.cy + 190
		local labelTitle = display.newTTFLabel(spriteNotice)
		labelTitle:addTo(self, 1)
		labelTitle:setOpacity(0)
		_UPVALUE1_ = 1
		;(1)[1] = cca.delay(0.3)
		;(1)[2] = cca.fadeIn(0.3)
		;(1)[3] = cca.fadeIn(0.3)
		labelTitle:runAction(cca.seq(1))
	end
	if self.spriteBox and self.spriteClow == nil then
		_UPVALUE1_ = labelTitle
		labelTitle[1] = cca.delay(2)
		labelTitle[2] = cca.callFunc(function(...)
			self:removeFromParent()
		end)
		labelTitle[3] = cca.callFunc(function(...)
			self:removeFromParent()
		end)
		labelTitle[4] = cca.callFunc(function(...)
			self:removeFromParent()
		end)
		labelTitle[5] = cca.callFunc(function(...)
			self:removeFromParent()
		end)
		self:runAction(cca.seq(labelTitle))
	end
end
function ClowBoxView:showClow()
	self.spriteBox = display.newSprite("#et_clown_box_01.png")
	self.spriteBox:setPosition(cc.p(display.cx - 25, display.cy))
	self:addChild(self.spriteBox)
	_UPVALUE7_ = self
	self[1] = cca.delay(0.1)
	self[2] = cca.callFunc(function(...)
		self.spriteBox:playAnimationOnce(display.getAnimationCache("clowBoxAnimation"))
	end)
	self[3] = cca.delay(0.1)
	self[4] = cca.callFunc(function()
		local et_node = self:getChildByName("et_node")
		if et_node then
			SoraDResetEffectNode(et_node)
		else
			local posX = self.spriteBox:getPositionX()
			local posY = self.spriteBox:getPositionY()
			self, self = nil, self.spriteBox
			self, (nil).plist = nil, "et_xiaochouyan_01.plist"
			;(nil).x = posX + 17
			;(nil).pos, (nil).y = nil, posY - 85
			self, self.spriteBox[1], (nil).scale = nil, nil, 1.5
			self, (nil).plist = nil, "et_xiaochouyan_02.plist"
			;(nil).x = posX + 10
			;(nil).pos, (nil).y = nil, posY - 87
			self, self.spriteBox[2], (nil).scale = nil, nil, 1.2
			self, (nil).plist = nil, "et_xiaochouParticle_01.plist"
			;(nil).x = posX + 14
			self, self.spriteBox[3], (nil).pos, (nil).y = nil, nil, nil, posY - 90
			self, (nil).plist = nil, "et_xiaochouParticle_02.plist"
			;(nil).x = posX + 12
			self, self.spriteBox[4], (nil).pos, (nil).y = nil, nil, nil, posY - 92
			self, (nil).plist = nil, "et_xiaochouParticle_03.plist"
			;(nil).x = posX + 11
			self.spriteBox[5], (nil).pos, (nil).y = nil, nil, posY - 100
			local param = self.spriteBox
			local et_node = SoraDCreateEffectNode(param)
			et_node:setName("et_node")
			et_node:addTo(self, 99)
		end
	end)
	self[5] = cca.delay(0.1)
	self[6] = cca.callFunc(function(...)
		self.spriteClow = display.newSprite("#et_clown_red_01.png")
		self.spriteClow:setPosition(cc.p(display.cx - 25, display.cy))
		self:addChild(self.spriteClow, 1)
		self.spriteClow:playAnimationOnce(display.getAnimationCache("clowAnimation"))
	end)
	self[7] = cca.delay(1)
	self[8] = cca.callFunc(function(...)
		self.isShow = true
		self:showResult()
	end)
	self[9] = cca.callFunc(function(...)
		self.isShow = true
		self:showResult()
	end)
	local seq = cca.seq(self)
	self.spriteBox:runAction(seq)
end
function ClowBoxView:showBox()
	self.spriteBox = display.newSprite("#et_clown_box_01.png")
	self.spriteBox:setPosition(cc.p(display.cx - 25, display.cy))
	self:addChild(self.spriteBox)
	_UPVALUE3_ = self
	self[1] = cca.delay(0.1)
	self[2] = cca.callFunc(function(...)
		self.spriteBox:playAnimationOnce(display.getAnimationCache("clowBoxAnimation"))
	end)
	self[3] = cca.delay(0.5)
	self[4] = cca.callFunc(function(...)
		self.isShow = true
		self:showResult()
	end)
	self[5] = cca.callFunc(function(...)
		self.isShow = true
		self:showResult()
	end)
	local seq = cca.seq(self)
	self.spriteBox:runAction(seq)
end
function ClowBoxView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.spriteBox then
			self.spriteBox:stopAllActions()
			self.spriteBox:removeFromParent()
			self.spriteBox = nil
		end
		if self.spriteClow then
			self.spriteClow:stopAllActions()
			self.spriteClow:removeFromParent()
			self.spriteClow = nil
		end
		self:stopAllActions()
		if not self.isShow then
			self:showResult()
		end
		self:removeFromParent()
	end
end
function ClowBoxView:onExitPanel()
	display.removeAnimationCache("clowBoxAnimation")
	display.removeAnimationCache("clowAnimation")
end
return ClowBoxView
