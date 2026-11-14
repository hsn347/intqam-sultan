local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local atlantisWarUtil = include("atlantisWarUtil")
local atlantisBossAppear = class("atlantisBossAppear", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("atlantisBossAppear")
	end
	return target
end)
function atlantisBossAppear:ctor()
	self:setBackGround(0)
	self.enableTouchCloseSelf = true
	self.isCantCloseByReturn = true
	self:initWidget()
end
function atlantisBossAppear:test(...)
	_UPVALUE0_ = nil
	;(nil).bossClassID = 32
	self:initData(nil)
end
function atlantisBossAppear:initWidget(...)
	SoraDGetAllChildFromWidget(self._ccsView, self)
	self.Button_close:addTouchEventListener(handler(self, self.close))
	self.Button_go:addTouchEventListener(handler(self, self.btnGoClick))
	self.Button_go:setTitleText(i18n("common_text_477"))
	SoraDAutoSizeButtonTextByContent(self.Button_go)
end
function atlantisBossAppear:initData(data)
	self.bossClassID = data.bossClassID
	if data.isAppear then
		self:initBossAppear()
	else
		self:initBossCountDown()
	end
end
function atlantisBossAppear:initBossCountDown(...)
	if self.bossClassID == gBossType.atlantisWarWlyn then
		self.Text_tip:setString(i18n("atlantiswar_text_0166"))
	elseif self.bossClassID == gBossType.atlantisWarSd then
		self.Text_tip:setString(i18n("atlantiswar_text_0171"))
	end
	self.Button_go:setVisible(false)
	self:showEffect()
	_UPVALUE1_ = i18n("atlantiswar_text_0171")
	i18n("atlantiswar_text_0171")[1] = cca.delay(4.083333333333333)
	i18n("atlantiswar_text_0171")[2] = cca.callFunc(function(...)
		self:showBossAppear()
	end)
	i18n("atlantiswar_text_0171")[3] = cca.callFunc(function(...)
		self:showBossAppear()
	end)
	self:runAction(cca.seq(i18n("atlantiswar_text_0171")))
end
function atlantisBossAppear:showEffect()
	local effectlrcx = SoraDCreatAnimationEx("atlantis_lrcx", nil, false)
	effectlrcx:setPosition(cc.p(320, 0))
	self.Center_Node:addChild(effectlrcx, -1)
	self.effectlrcx = effectlrcx
	self.img1 = SoraDGetChildByName(effectlrcx, "banshenxiang_1")
	self.img2 = SoraDGetChildByName(effectlrcx, "banshenxiang_2")
	local image = worldMapDefine.getWorldBossShow(self.bossClassID).image
	self.img1:setSpriteFrame(image)
	self.img2:setSpriteFrame(image)
	self.Panel_black = SoraDGetChildByName(effectlrcx, "Panel_black")
	self.Panel_black:setContentSize(display.size)
end
function atlantisBossAppear:initBossAppear(...)
	self:showBossAppear()
	self:showEffect()
	self.effectlrcx:stopAction(self.effectlrcx.action)
	self.effectlrcx.action:gotoFrameAndPlay(245)
end
function atlantisBossAppear:showBossAppear(...)
	if self.bossClassID == gBossType.atlantisWarWlyn then
		self.Text_tip:setString(i18n("atlantiswar_text_0167"))
	elseif self.bossClassID == gBossType.atlantisWarSd then
		self.Text_tip:setString(i18n("atlantiswar_text_0172"))
	end
	self.Button_go:setVisible(true)
end
function atlantisBossAppear:btnGoClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		atlantisWarUtil.jumpToBoss(self.bossClassID)
		SoraDRemoveAllPanelFromManager()
	end
end
return atlantisBossAppear
