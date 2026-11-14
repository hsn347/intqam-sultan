local heroTrialFinish = class("heroTrialFinish", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroTrialFinish")
	end
	return target
end)
function heroTrialFinish:ctor()
	self.text = SoraDGetChildByName(self, "text")
	self.confirmBtn = SoraDGetChildByName(self, "confirmBtn")
	self.node = SoraDGetChildByName(self, "node")
	self.confirmBtn:addTouchEventListener(handler(self, self.onConfirm))
	self.confirmBtn:setTitleText(i18n("common_text_054"))
	self:setBackGround(204.0)
	self.isHidePrePanel = false
end
function heroTrialFinish:initData(type, cb)
	self.cb = cb
	if type == "winEn" then
		self:initWinEn()
	elseif type == "winAr" then
		self:initWinAr()
	elseif type == "loseEn" then
		self:initLoseEn()
	elseif type == "loseAr" then
		self:initLoseAr()
	end
end
function heroTrialFinish:initWinEn()
	local node = SoraDCreatAnimation("heroTrialWinEn", nil, false)
	self.node:addChild(node)
	self.text:setString(i18n("common_text_1748"))
	self.text:setColor(cc.c3b(255, 225, 109))
end
function heroTrialFinish:initWinAr()
	local node = SoraDCreatAnimation("heroTrialWinAr", nil, false)
	self.node:addChild(node)
	self.text:setString(i18n("common_text_1748"))
	self.text:setColor(cc.c3b(255, 225, 109))
end
function heroTrialFinish:initLoseEn()
	local node = SoraDCreatAnimation("heroTrialLoseEn", nil, false)
	self.node:addChild(node)
	self.text:setString(i18n("common_text_1718"))
	self.text:setColor(cc.c3b(214, 210, 209))
end
function heroTrialFinish:initLoseAr()
	local node = SoraDCreatAnimation("heroTrialLoseAr", nil, false)
	self.node:addChild(node)
	self.text:setString(i18n("common_text_1718"))
	self.text:setColor(cc.c3b(214, 210, 209))
end
function heroTrialFinish:onConfirm(sender, type)
	if type == ccui.TouchEventType.ended and self.cb then
		self.cb()
	end
end
return heroTrialFinish
