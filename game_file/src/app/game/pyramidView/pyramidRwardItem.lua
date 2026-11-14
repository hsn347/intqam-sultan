local pyramidRwardItem = class("pyramidRwardItem", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("pyramidRwardItem")
	end
	if target ~= nil then
		target = include("commonItemAward").new(target)
	end
	return target
end)
function pyramidRwardItem:ctor()
	local imgEffect = SoraDGetChildByName(self, "Sprite_effect")
	_G.SoraDMixtureGLONE(imgEffect)
	self.Text_multiple = SoraDGetChildByName(self, "Text_multiple")
	self.Text_multiple:setVisible(false)
end
function pyramidRwardItem:initItem(data)
	local multiple = data.multiple or 1
	self.Text_multiple:setVisible(1 < multiple)
	self.Text_multiple:setString("x" .. data.multiple)
	self:initData(data.id, math.floor(data.count / multiple))
	local index = data.index or 1
	local delayTime = 0.0 + index * 10 / 60
	self:setVisible(false)
	_UPVALUE1_ = self
	self[1] = cca.delay(delayTime)
	self[2] = cca.callFunc(function()
		self:setVisible(true)
		SoraDCreatAnimation("pyramidRwardItem", self, false)
	end)
	self[3] = cca.callFunc(function()
		self:setVisible(true)
		SoraDCreatAnimation("pyramidRwardItem", self, false)
	end)
	local seq = cca.seq(self)
	self:runAction(seq)
end
return pyramidRwardItem
