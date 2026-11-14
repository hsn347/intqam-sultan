local slotMachineRewardRead = include("slotMachineRewardRead")
local oneArmBanditRewardPopView = class("oneArmBanditRewardPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("oneArmBanditRewardPopView")
	end
	return target
end)
function oneArmBanditRewardPopView:ctor()
	self.isAddToPopManager = true
	self:bandWidget()
end
function oneArmBanditRewardPopView:bandWidget()
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Text_1"
	SoraDGetChildByFullPath(self.Center_Node, "Center_Node"):setString(i18n("common_text_316"))
	_UPVALUE1_ = i18n("common_text_316")
	i18n("common_text_316")[1] = "Text_2"
	SoraDGetChildByFullPath(self.Center_Node, i18n("common_text_316")):setString(i18n("slot_machine_text_05"))
	_UPVALUE1_ = i18n("slot_machine_text_05")
	i18n("slot_machine_text_05")[1] = "Image_2"
	self.Image_2 = SoraDGetChildByFullPath(self.Center_Node, i18n("slot_machine_text_05"))
	_UPVALUE1_ = i18n("slot_machine_text_05")
	i18n("slot_machine_text_05")[1] = "Image_gold"
	self.Image_gold = SoraDGetChildByFullPath(self.Center_Node, i18n("slot_machine_text_05"))
	_UPVALUE1_ = i18n("slot_machine_text_05")
	i18n("slot_machine_text_05")[1] = "BitmapFontLabel_gold"
	self.labGold = SoraDGetChildByFullPath(self.Center_Node, i18n("slot_machine_text_05"))
	self.labGold = SoraDCreateScoreLabel(self.labGold, true)
	self.labGold:setString(0)
	_UPVALUE1_ = 0
	;(0)[1] = "Button_l"
	self.Button_l = SoraDGetChildByFullPath(self.Center_Node, 0)
	self.Button_l:setTitleText(i18n("slot_machine_text_06"))
	SoraDAutoSizeButtonText(self.Button_l)
	self.Button_l:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		self:closePanel()
	end)
	function _UPVALUE1_(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		self:closePanel()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		self:closePanel()
	end)[1] = "Button_r"
	self.Button_r = SoraDGetChildByFullPath(self.Center_Node, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		self:closePanel()
	end)
	self.Button_r:setTitleText(i18n("slot_machine_text_07"))
	SoraDAutoSizeButtonText(self.Button_r)
	self.Button_r:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		if self.handle then
			self.handle()
		end
	end)
	self:setSlotEffect()
end
function oneArmBanditRewardPopView:initData(data)
	local reward = data.data
	local count = reward.gold
	if count <= 0 then
		self.labGold:setString(0)
		self.labGold:setVisible(false)
		self.Image_gold:setVisible(false)
		self.Image_2:setVisible(false)
		if reward.item and next(reward.item) then
			local itemCount = #reward.item
			local offsetx = (itemCount - 1) * 110 / 2
			for i, v in ipairs(reward.item) do
				local singleItem = include("itemSingleView").new()
				singleItem:addTo(self.Center_Node)
				singleItem:setScale(0.65)
				singleItem:setPosition(cc.p(270 + 110 * (i - 1) - offsetx, -90))
				singleItem:setItemClickCallback(handler(self, self.showDetail))
				_ENV, _ENV = handler(self, self.showDetail)
				handler(self, self.showDetail).id = v.id
				handler(self, self.showDetail).itemData, handler(self, self.showDetail).count = handler(self, self.showDetail)
				singleItem:initData(handler(self, self.showDetail))
				singleItem:setButtonTag(v.id)
			end
		end
	else
		self.labGold:setString(count)
		local offsetx = (self.labGold:getContentSize().width - self.Image_gold:getContentSize().width) / 2
		self.labGold:setPositionX(325 - offsetx)
		self.Image_gold:setPositionX(315 - self.Image_gold:getContentSize().width / 2 - offsetx)
		self.labGold:setString(0)
		self.labGold:runScoreAnimation(0, count, 0.5)
	end
	SoraDPlaySound("slotmachine", 2)
	if reward.id then
		local showType = slotMachineRewardRead.getShowType(reward.id)
		if showType == 1 then
			self.particle:setVisible(true)
			SoraDPlaySound("slotmachine", 3, true)
		else
			self.particle:setVisible(false)
		end
	end
	self.handle = data.handle
end
function oneArmBanditRewardPopView:showDetail(button, type)
	if type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		SoraDPlaySound()
		button:stopAllActions()
		if self.tips then
			self.tips:removeFromParent()
			self.tips = nil
		end
	elseif type == ccui.TouchEventType.began then
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(0.2)
		;(nil)[2] = cca.callFunc(function()
			self.tips = SoraDCreatePanel("commonItemTips")
			self.tips:initData(button:getTag())
			local dt = 140
			if not SoraDFIsRA() then
				dt = -140
			end
			self.tips:setPosition(cc.p(320 + dt, display.cy + 80))
			self.tips:addTo(self, 99)
		end)
		;(nil)[3] = cca.callFunc(function()
			self.tips = SoraDCreatePanel("commonItemTips")
			self.tips:initData(button:getTag())
			local dt = 140
			if not SoraDFIsRA() then
				dt = -140
			end
			self.tips:setPosition(cc.p(320 + dt, display.cy + 80))
			self.tips:addTo(self, 99)
		end)
		button:runAction(cca.seq(nil))
	end
end
function oneArmBanditRewardPopView:setSlotEffect(...)
	local effectNode = SoraDCreatAnimation("dandujiesuan_up")
	effectNode:setPosition(cc.p(365, -60))
	self.Center_Node:addChild(effectNode)
	_UPVALUE2_ = self.Center_Node
	self.Center_Node[1] = "dh_jinbidiaoxl_09_1"
	self.Center_Node[2] = "Sprite_1"
	for i, v in ipairs(self.Center_Node) do
		local sp = SoraDGetChildByName(effectNode, v)
		if sp:isOpacityModifyRGB() then
			sp:setBlendFunc(gl.ONE, gl.ONE)
		else
			sp:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
		end
	end
	local particle = SoraDGetChildByName(effectNode, "Particle_1")
	self.particle = particle
	local offsetY = display.height - 960
	if 0 < offsetY then
		particle:setPositionY(particle:getPositionY() + offsetY / 2)
	else
		_UPVALUE3_ = particle
		particle[1] = "Particle_5"
		particle[2] = "Particle_7"
		particle[3] = "Particle_1"
		for i, v in ipairs(particle) do
			local sp = SoraDGetChildByName(effectNode, v)
			sp:setPositionY(sp:getPositionY() + offsetY * 2 / 3)
		end
	end
	local effectNode = SoraDCreatAnimation("dandujiesuan_down")
	effectNode:setPosition(cc.p(365, -60))
	self.Center_Node:addChild(effectNode, -1)
end
return oneArmBanditRewardPopView
