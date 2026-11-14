local baseComponent = require("fgui.base.baseComponent")
local ForeignPavilionBg = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ForeignPavilion/ForeignPavilionBg", ForeignPavilionBg)
function ForeignPavilionBg:onInit()
	self.maxX = 490
	self.minX = 150
	self.maxY = display.height / 2 + 150
	self.minY = display.height / 2 - 150
	self.fields.focus:setString("+")
end
function ForeignPavilionBg:onShow()
	self.size = self.fields.bg:getSize()
	self.fields.clip:setVisible(false)
	self.fields.focus:setVisible(false)
	self:startAction()
end
function ForeignPavilionBg:setShow(isShow)
	self:setVisible(isShow)
	if isShow then
		self:updateClipPos(display.width / 2, display.height / 2)
		self:startAction()
	else
		self.fields.clip:stopAllActions()
		self.fields.focus:stopAllActions()
	end
end
function ForeignPavilionBg:gameStart()
	self.fields.bg:gameStart()
end
function ForeignPavilionBg:setData(lastPoint, movePoint)
	local addX = movePoint.x - lastPoint.x
	local addY = movePoint.y - lastPoint.y
	local nowPos = self.fields.clip:getPosition()
	local finalX = nowPos.x + addX * 2
	finalX = math.min(self.maxX, math.max(finalX, self.minX))
	local finalY = nowPos.y + addY * 2
	finalY = math.min(self.maxY, math.max(finalY, self.minY))
	self:updateClipPos(finalX, finalY)
end
function ForeignPavilionBg:updateClipPos(finalX, finalY)
	self.fields.clip:setPosition(finalX, finalY)
	self.fields.focus:setPosition(finalX, finalY)
	local bgScale = self.fields.bg:getScale()
	local lastBgPosX = self.fields.bg:getPositionX()
	local lastBgPosY = self.fields.bg:getPositionY()
	local bgAnchorX = self.fields.bg:getPivot().x
	local bgAnchorY = self.fields.bg:getPivot().y
	local finalAnchorX = finalX / display.width
	local finalAnchorY = finalY / display.height
	self.fields.bg:setPivot(finalAnchorX, finalAnchorY, true)
	self.fields.bg:setPosition(lastBgPosX + (finalAnchorX - bgAnchorX) * lastBgPosY, lastBgPosY + (finalAnchorY - bgAnchorY) * lastBgPosY)
end
function ForeignPavilionBg:startAction()
	do return end
	self.fields.clip:stopAllActions()
	self.fields.focus:stopAllActions()
	local clipPos = self.fields.clip:getPosition()
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.moveBy(1, cc.p(0, 30))
	;(nil)[2] = ffa.moveBy(1, cc.p(0, -30))
	;(nil)[3] = ffa.moveBy(1, cc.p(0, -30))
	;(nil)[4] = ffa.moveBy(1, cc.p(0, -30))
	;(nil)[5] = ffa.moveBy(1, cc.p(0, -30))
	;(nil)[6] = ffa.moveBy(1, cc.p(0, -30))
	;(nil)[7] = ffa.moveBy(1, cc.p(0, -30))
	;(nil)[8] = ffa.moveBy(1, cc.p(0, -30))
	local seq = ffa.seq(nil)
	self.fields.clip:runAction(ffa.repeatForever(ffa.seq(seq)))
	local clipPos = self.fields.focus:getPosition()
	_UPVALUE1_ = ffa.repeatForever(ffa.seq(seq))
	ffa.repeatForever(ffa.seq(seq))[1] = ffa.moveBy(1, cc.p(0, 30))
	ffa.repeatForever(ffa.seq(seq))[2] = ffa.moveBy(1, cc.p(0, -30))
	ffa.repeatForever(ffa.seq(seq))[3] = ffa.moveBy(1, cc.p(0, -30))
	ffa.repeatForever(ffa.seq(seq))[4] = ffa.moveBy(1, cc.p(0, -30))
	ffa.repeatForever(ffa.seq(seq))[5] = ffa.moveBy(1, cc.p(0, -30))
	ffa.repeatForever(ffa.seq(seq))[6] = ffa.moveBy(1, cc.p(0, -30))
	local seq2 = ffa.seq(ffa.repeatForever(ffa.seq(seq)))
	self.fields.focus:runAction(ffa.repeatForever(ffa.seq(seq2)))
end
return ForeignPavilionBg
