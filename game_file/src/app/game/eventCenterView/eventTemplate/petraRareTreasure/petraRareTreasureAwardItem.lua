local petraRareTreasureAwardItem = class("petraRareTreasureAwardItem", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("petraRareTreasureAwardItem")
	end
	if target ~= nil then
		local timerClass = include("commonItemAward")
		target = timerClass.new(target)
	end
	return target
end)
function petraRareTreasureAwardItem:ctor()
	local imgEffect = SoraDGetChildByName(self, "Sprite_effect")
	_G.SoraDMixtureGLONE(imgEffect)
	self.Text_lv = SoraDGetChildByName(self, "Text_lv")
end
function petraRareTreasureAwardItem:initItem(data)
	_ENV = nil
	;(nil).num = data.index or 1
	self.Text_lv:setString(i18n("petra_text_07", nil))
	self:initData(data.id, data.count)
	local index = (data.index or 1) - 1
	local delayTime = 0.0 + index * 0.1
	if index == 0 then
		delayTime = 0.02
	end
	local petraRareTreasureDef = include("petraRareTreasureDef")
	if data.itemIndex == petraRareTreasureDef.BEST_TREASURE then
		_UPVALUE1_ = petraRareTreasureDef.BEST_TREASURE
		petraRareTreasureDef.BEST_TREASURE[1] = cca.delay(delayTime + 1.0)
		petraRareTreasureDef.BEST_TREASURE[2] = cca.callFunc(function()
			self:showCoolSquare()
		end)
		petraRareTreasureDef.BEST_TREASURE[3] = cca.callFunc(function()
			self:showCoolSquare()
		end)
		local seq = cca.seq(petraRareTreasureDef.BEST_TREASURE)
		self:runAction(seq)
	end
	self:setVisible(false)
	_UPVALUE1_ = self
	self[1] = cca.delay(delayTime)
	self[2] = cca.callFunc(function()
		self:setVisible(true)
		SoraDCreatAnimation("petraRareTreasureAwardItem", self, false)
	end)
	self[3] = cca.callFunc(function()
		self:setVisible(true)
		SoraDCreatAnimation("petraRareTreasureAwardItem", self, false)
	end)
	local seq = cca.seq(self)
	_UPVALUE2_ = cca.delay(delayTime)
	cca.delay(delayTime)[1] = delayTime
	cca.delay(delayTime)[2] = data.index
	dump(cca.delay(delayTime), "petraRareTreasureAwardItem:initItem")
	self:runAction(seq)
end
return petraRareTreasureAwardItem
