local heroUpgradeNode = class("heroUpgradeNode", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("heroUpgradeNode")
end)
function heroUpgradeNode:ctor(properties)
	self:setCascadeOpacityEnabled(true)
	self.nodeNext = SoraDGetExtendChildFromCCSByName(self, "CCS_heroShowItem_next")
	self.nodeNext:setScale(0.9)
	self.nodeNow = SoraDGetExtendChildFromCCSByName(self, "CCS_heroShowItem_now")
	self.nodeNow:setScale(0.9)
	_ENV, self.tableArrowOpacity, _ENV, self.nodeArrow = SoraDGetChildByName(self, "Node_arrow"), SoraDGetChildByName(self, "Node_arrow"), SoraDGetChildByName(self, "Node_arrow"), SoraDGetChildByName(self, "Node_arrow")
	SoraDGetChildByName(self, "Node_arrow")[1] = SoraDGetChildByName(self, "Sprite_arrow_1")
	SoraDGetChildByName(self, "Node_arrow")[2] = SoraDGetChildByName(self, "Sprite_arrow_2")
	self.tableArrow, SoraDGetChildByName(self, "Node_arrow")[3] = SoraDGetChildByName(self, "Node_arrow"), SoraDGetChildByName(self, "Sprite_arrow_3")
	self:flashingAnimation()
end
function heroUpgradeNode:flashingAnimation()
	local isQuick
	local delay = isQuick and 0.2 or 1
	for i, v in ipairs(self.tableArrow) do
		table.insert(self.tableArrowOpacity, v:getOpacity() / 255)
	end
	for i, v in ipairs(self.tableArrow) do
		v:stopAllActions()
		v:setOpacity(self.tableArrowOpacity[i])
		_UPVALUE3_ = nil
		;(nil)[1] = cca.delay((i - 1) * 0.2 * delay)
		;(nil)[2] = cca.fadeTo(0.1 * delay, self.tableArrowOpacity[i])
		;(nil)[3] = cca.delay((#self.tableArrow - i) * 0.2 * delay + 0.3 * delay)
		;(nil)[4] = cca.fadeTo(0.2 * delay, 0)
		;(nil)[5] = cca.fadeTo(0.2 * delay, 0)
		;(nil)[6] = cca.fadeTo(0.2 * delay, 0)
		v:runAction(cca.repeatForever(cca.seq(nil)))
	end
end
function heroUpgradeNode:initData(data)
	dump(data, "eroUpgradeNode:initData")
	self.nodeNow:initData(data.heroID)
	self.nodeNow:setHeadBg(data.quality - 1)
	self.nodeNext:initData(data.heroID)
	self.nodeNext:setHeadBg(data.quality)
end
return heroUpgradeNode
