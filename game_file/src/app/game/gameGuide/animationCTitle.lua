local animationCTitle = class("animationCTitle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("animationCTitle")
	end
	return target
end)
function animationCTitle:ctor()
	self.Panel_cut = SoraDGetChildByName(self, "Panel_cut")
	self.Frame_target = SoraDGetChildByName(self, "framer_zjrw")
end
function animationCTitle:initAni(pngName, delay)
	self.delay = delay or 0
	self.Frame_target:setSpriteFrame(pngName)
	self.size = self.Frame_target:getContentSize()
	self.Panel_cut:setContentSize(self.size)
	self.Panel_cut:setAnchorPoint(cc.p(SoraDFIsRA() and 1 or 0, 0.5))
	self.Panel_cut:setPosition(SoraDFIsRA() and self.size.width / 2 or -self.size.width / 2, 0)
	self.Frame_target:setAnchorPoint(cc.p(SoraDFIsRA() and 1 or 0, 0.5))
	self.Frame_target:setPosition(SoraDFIsRA() and self.size.width or 0, self.size.height / 2)
	self.len = 0
	self.dt_len = self.size.width / 50
	self.Panel_cut:setContentSize(cc.size(0, self.size.height))
	self.Frame_target:setPositionX(0)
	_UPVALUE1_ = cc.size(0, self.size.height)
	cc.size(0, self.size.height)[1] = cca.delay(self.delay)
	cc.size(0, self.size.height)[2] = cca.callFunc(function()
		self.timer = SoradCreateTimer(self, handler(self, self.update), true)
	end)
	cc.size(0, self.size.height)[3] = cca.callFunc(function()
		self.timer = SoradCreateTimer(self, handler(self, self.update), true)
	end)
	self:runAction(cca.seq(cc.size(0, self.size.height)))
end
function animationCTitle:update(dt)
	if self.len >= self.size.width then
		if self.timer then
			SoraDManagerRemoveTimer(self, self.timer)
			self.timer = nil
		end
		return
	end
	self.len = self.len + self.dt_len
	self.Panel_cut:setContentSize(cc.size(self.len, self.size.height))
	self.Frame_target:setPositionX(SoraDFIsRA() and self.len or 0)
end
return animationCTitle
