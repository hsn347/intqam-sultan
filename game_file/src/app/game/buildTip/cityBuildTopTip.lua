local cityBuildTopTip = class("cityBuildTopTip", function(cssFile)
	local view = include("ccsView")
	return view.new(cssFile)
end)
function cityBuildTopTip:ctor()
	self.btnTip = SoraDGetChildByName(self, "BtnTip")
	if self.btnTip then
		self.btnTip:setPressedActionEnabled(true)
	end
	self.tipText = SoraDGetChildByName(self, "tipText")
end
function cityBuildTopTip:showTopTipEffect()
	self:stopAllActions()
	self:setRotation(0)
	self:ignoreAnchorPointForPosition(false)
	self:setAnchorPoint(cc.p(0.5, 0))
	local rotateByRight = cca.rotateBy(0.1, 15)
	local rotateByToLeft = cca.rotateBy(0.2, -30)
	local rotateBack = cca.rotateBy(0.1, 15)
	local rotateByRight2 = cca.rotateBy(0.08, 8)
	local rotateByToLeft2 = cca.rotateBy(0.16, -16)
	local rotateBack2 = cca.rotateBy(0.08, 8)
	local rotateByRight3 = cca.rotateBy(0.05, 5)
	local rotateByToLeft3 = cca.rotateBy(0.1, -10)
	local rotateBack3 = cca.rotateBy(0.05, 5)
	local delayTime = cca.delay(2.5)
	_UPVALUE10_ = cc.p(0.5, 0)
	cc.p(0.5, 0)[1] = rotateByRight
	cc.p(0.5, 0)[2] = rotateByToLeft
	cc.p(0.5, 0)[3] = rotateBack
	cc.p(0.5, 0)[4] = rotateByRight2
	cc.p(0.5, 0)[5] = rotateByToLeft2
	cc.p(0.5, 0)[6] = rotateBack2
	cc.p(0.5, 0)[7] = rotateByRight3
	cc.p(0.5, 0)[8] = rotateByToLeft3
	cc.p(0.5, 0)[9] = rotateBack3
	cc.p(0.5, 0)[10] = delayTime
	local seqA = cca.seq(cc.p(0.5, 0))
	local repeatA = cca.repeatForever(seqA)
	self:runAction(repeatA)
end
function cityBuildTopTip:hideTopTipEffect()
	self:stopAllActions()
	self:setRotation(0)
	self:removeFromParent()
end
function cityBuildTopTip:onEnter()
	self:showTopTipEffect()
end
function cityBuildTopTip:setTipText(strTip)
	if self.tipText then
		self.tipText:setString(strTip)
	end
end
return cityBuildTopTip
