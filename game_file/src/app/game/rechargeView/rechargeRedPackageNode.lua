local rechargeRedPackageNode = class("rechargeRedPackageNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("rechargeRedPackageNode")
	end
	return target
end)
function rechargeRedPackageNode:ctor()
	self.btn_box = SoraDGetChildByName(self, "btn_box")
	self.btn_box:setSwallowTouches(false)
	self.img_box = SoraDGetChildByName(self, "img_box")
	self.btn_box:addTouchEventListener(handler(self, self.OnBtnClick))
	self:initAct()
end
function rechargeRedPackageNode:initAct()
	_UPVALUE4_ = nil
	;(nil)[1] = cca.delay(2)
	;(nil)[2] = cca.moveBy(0.4, 0, 10)
	;(nil)[3] = cca.moveBy(0.4, 0, -10)
	;(nil)[4] = cca.moveBy(0.15, 0, 5)
	;(nil)[5] = cca.moveBy(0.15, 0, -5)
	;(nil)[6] = cca.moveBy(0.15, 0, -5)
	;(nil)[7] = cca.moveBy(0.15, 0, -5)
	;(nil)[8] = cca.moveBy(0.15, 0, -5)
	local seq = cca.seq(nil)
	self.img_box:runAction(cca.repeatForever(seq))
end
function rechargeRedPackageNode:OnBtnClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowMsgTip(i18n("common_text_4106"))
	end
end
return rechargeRedPackageNode
