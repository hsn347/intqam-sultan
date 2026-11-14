local buffCtrl = SoraDGetCtrl("buffCtrl")
local sultansBackCtrl = SoraDGetCtrl("sultansBackCtrl")
local sultansBackRead = include("sultansBackRead")
local sultansBackWelBackView = class("sultansBackWelBackView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("sultansBackWelBackView")
	end
	return target
end)
function sultansBackWelBackView:ctor()
	self.isAddToPopManager = true
	self.isReceived = false
	self.Image_tile = SoraDGetChildByName(self, "Image_tile")
	self.Image_tile:setFillType(1)
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("welcome_back_text01"))
	self.Text_buff = SoraDGetChildByName(self, "Text_buff")
	self.Text_buff:setString(i18n("welcome_back_text02"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("sultansBackWelBackSingle")
	self.Button_box = SoraDGetChildByName(self, "Button_box")
	self.Button_box:addTouchEventListener(handler(self, self.btnPreviewClick))
	self.Text_status = SoraDGetChildByName(self, "Text_status")
	self.Node_effect = SoraDGetChildByName(self, "Node_effect")
	SoraDCreatAnimation("animationWelBack"):addTo(self.Node_effect)
	self.Node_box = SoraDGetChildByName(self, "Node_box")
	self.Node_box:setPositionY(display.height >= 960 and -372 or -340)
	self.dh_huanyinghg = SoraDGetChildByName(self, "dh_huanyinghg")
	self.dh_hyhg = SoraDGetChildByName(self, "dh_hyhg")
	self.Particle_et = SoraDGetChildByName(self, "Particle_et")
	self:initData()
end
function sultansBackWelBackView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SULTANSBACK_WELCOME_REFRESH", handler(self, self.initData))
end
function sultansBackWelBackView:getBuffList()
	local sultansBackRead, buffList
	local buffArray = sultansBackRead.getWelBackBuff()
	for k, v in ipairs(buffArray) do
		local remainTime = buffCtrl:getRemainTimeByBuffID(v)
		if remainTime and 0 < remainTime then
			table.insert(buffList, v)
		end
	end
	return buffList
end
function sultansBackWelBackView:initData(target, data)
	SoraDCloseLoading(self)
	self.buffList = self:getBuffList()
	_ENV = nil
	;(nil).scroll = self.scroll
	self.scroll:updateScrollView(cc.size(566, 120), self.buffList, 1, nil)
	self.isReceived = sultansBackCtrl:isWelcomeBackReceived()
	self.Text_status:setString(self.isReceived and i18n("common_text_1892") or i18n("common_text_1146"))
	self.Text_status:setColor(self.isReceived and cc.c3b(255, 255, 0) or cc.c3b(0, 190, 40))
	self:setBoxEffect()
end
function sultansBackWelBackView:setBoxEffect()
	self.dh_huanyinghg:setVisible(not self.isReceived)
	self.dh_hyhg:setVisible(not self.isReceived)
	self.Particle_et:setVisible(not self.isReceived)
	if self.isReceived then
		self.dh_huanyinghg:stopAllActions()
		self.dh_hyhg:stopAllActions()
	else
		_UPVALUE3_ = self.dh_hyhg
		self.dh_hyhg[1] = cca.fadeTo(0.75, 0.65)
		self.dh_hyhg[2] = cca.fadeTo(0.9666666666666667, 1.0)
		self.dh_hyhg[3] = cca.fadeTo(0.7833333333333333, 0.65)
		self.dh_hyhg[4] = cca.fadeTo(0.9666666666666667, 1.0)
		self.dh_hyhg[5] = cca.fadeTo(0.9666666666666667, 1.0)
		self.dh_hyhg[6] = cca.fadeTo(0.9666666666666667, 1.0)
		local fadeSeq = cca.seq(self.dh_hyhg)
		self.dh_huanyinghg:runAction(cc.RepeatForever:create(fadeSeq))
		local frames = display.newFrames("dh_hyhg2_%.2d.png", 0, 11)
		frames[#frames + 1] = cc.SpriteFrameCache:getInstance():getSpriteFrame("bg_transparent.png")
		local animation = display.newAnimation(frames, 1.0 / #frames)
		self.dh_hyhg:playAnimationForever(animation, 2)
	end
end
function sultansBackWelBackView:btnPreviewClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isReceived then
			SoraDCreatePanel("sultansBackWelBackPreView"):show()
		else
			SoraDShowLoading(self)
			sultansBackCtrl:reqWelcomeReward()
		end
	end
end
return sultansBackWelBackView
