local gametop = gModuleMgr.getObject("gametop")
local propCtrl = gametop.playertop_:getModule("propCtrl")
local itemDesRead = include("itemDesRead")
local HalloweenView = class("halloweenView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("halloweenView")
	end
	return target
end)
function HalloweenView:ctor()
	self.jokeData, _ENV = nil, nil
	self.isPress = false
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.layerTouch = SoraDGetChildByName(self, "Panel_touch")
	self.imgBg = SoraDGetChildByName(self, "Image_bg")
	self.imgBg:setFillType(1)
	self.spriteFireR = SoraDGetChildByName(self, "Sprite_fireR")
	self.spriteFireL = SoraDGetChildByName(self, "Sprite_fireL")
	self.btnGood = SoraDGetChildByName(self, "Button_good")
	self.labelGood = SoraDGetChildByName(self, "Text_good")
	self.btnBad = SoraDGetChildByName(self, "Button_bad")
	self.labelBad = SoraDGetChildByName(self, "Text_bad")
	self.btnCopy = SoraDGetChildByName(self, "Button_copy")
	self.labelCopy = SoraDGetChildByName(self, "Text_copy")
	self.spritePumpkinL = SoraDGetChildByName(self, "Sprite_pumpkinL")
	self.spritePumpkinR = SoraDGetChildByName(self, "Sprite_pumpkinR")
	self.spriteSilk = SoraDGetChildByName(self, "Sprite_silk")
	self.spriteSpider = SoraDGetChildByName(self, "Sprite_spider")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.labelNum = SoraDGetChildByName(self, "Text_num")
	self.labelNum:setVisible(false)
	self.labelNum:setString("+1")
	self.labelCopy:setString(i18n("common_text_078"))
	self.btnBad:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnCopy:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnGood:addTouchEventListener(handler(self, self.btnClickCallBack))
	self:pumpkinEffect()
	_UPVALUE1_ = handler(self, self.btnClickCallBack)
	handler(self, self.btnClickCallBack)[1] = cca.scaleTo(1.5, 1, 4.5)
	handler(self, self.btnClickCallBack)[2] = cca.scaleTo(1.5, 1, 3.5)
	handler(self, self.btnClickCallBack)[3] = cca.scaleTo(1.5, 1, 3.5)
	handler(self, self.btnClickCallBack)[4] = cca.scaleTo(1.5, 1, 3.5)
	handler(self, self.btnClickCallBack)[5] = cca.scaleTo(1.5, 1, 3.5)
	self.spriteSilk:runAction(cca.repeatForever(cca.seq(handler(self, self.btnClickCallBack))))
	_UPVALUE1_ = cca.repeatForever(cca.seq(handler(self, self.btnClickCallBack)))
	cca.repeatForever(cca.seq(handler(self, self.btnClickCallBack)))[1] = cca.moveBy(1.5, 0, -32)
	cca.repeatForever(cca.seq(handler(self, self.btnClickCallBack)))[2] = cca.moveBy(1.5, 0, 32)
	cca.repeatForever(cca.seq(handler(self, self.btnClickCallBack)))[3] = cca.moveBy(1.5, 0, 32)
	cca.repeatForever(cca.seq(handler(self, self.btnClickCallBack)))[4] = cca.moveBy(1.5, 0, 32)
	cca.repeatForever(cca.seq(handler(self, self.btnClickCallBack)))[5] = cca.moveBy(1.5, 0, 32)
	self.spriteSpider:runAction(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(handler(self, self.btnClickCallBack))))))
end
function HalloweenView:initData(jokeData)
	self.jokeData = jokeData
	self.labelDes:setString(itemDesRead.getJokeDes(self.jokeData.jokeID))
	itemDesRead = itemDesRead.getJokeDes(self.jokeData.jokeID)
	itemDesRead.getJokeDes(self.jokeData.jokeID).count = self.jokeData.unlikeNum
	self.labelBad:setString(i18n("common_text_2227", itemDesRead.getJokeDes(self.jokeData.jokeID)))
	itemDesRead = i18n("common_text_2227", itemDesRead.getJokeDes(self.jokeData.jokeID))
	i18n("common_text_2227", itemDesRead.getJokeDes(self.jokeData.jokeID)).count = self.jokeData.likeNum
	self.labelGood:setString(i18n("common_text_2228", i18n("common_text_2227", itemDesRead.getJokeDes(self.jokeData.jokeID))))
end
function HalloweenView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if button == self.btnCopy then
			SoraDCopyText(self.labelDes:getString())
			SoraDShowMsgTip(i18n("common_text_1062"), itemDesRead.getIcon(802601, true), button)
		elseif not self.isPress then
			if button == self.btnBad then
				self.labelNum:setColor(display.COLOR_RED)
				_ENV = true
				;(true).count = self.jokeData.unlikeNum + 1
				self.labelBad:setString(i18n("common_text_2227", true))
				propCtrl:unlikeJoke(self.jokeData.jokeID)
			elseif button == self.btnGood then
				self.labelNum:setColor(display.COLOR_GREEN)
				_ENV = i18n("common_text_2227", true)
				i18n("common_text_2227", true).count = self.jokeData.likeNum + 1
				self.labelGood:setString(i18n("common_text_2228", i18n("common_text_2227", true)))
				propCtrl:likeJoke(self.jokeData.jokeID)
			end
			self.btnGood:setTouchEnabled(false)
			self.btnGood:setBright(false)
			self.btnBad:setTouchEnabled(false)
			self.btnBad:setBright(false)
			self.labelNum:setVisible(true)
			self.labelNum:setPosition(cc.p(button:getPositionX(), button:getPositionY() + 45))
			itemDesRead = cc.p(button:getPositionX(), button:getPositionY() + 45)
			cc.p(button:getPositionX(), button:getPositionY() + 45)[1] = cca.moveBy(0.8, 0, 15)
			cc.p(button:getPositionX(), button:getPositionY() + 45)[2] = cca.fadeOut(0.5)
			cc.p(button:getPositionX(), button:getPositionY() + 45)[3] = cca.fadeOut(0.5)
			cc.p(button:getPositionX(), button:getPositionY() + 45)[4] = cca.fadeOut(0.5)
			self.labelNum:runAction(cca.seq(cc.p(button:getPositionX(), button:getPositionY() + 45)))
			self.isPress = true
		end
	end
end
function HalloweenView:pumpkinEffect()
	local l = self.spritePumpkinL:getChildByName("et_nangua_light")
	local r = self.spritePumpkinR:getChildByName("et_nangua_light")
	_ENV = nil
	;(nil).beginOpacity = 0.5
	;(nil).endOpacity = 1
	;(nil).fadeIn = 2
	;(nil).fadeOut = 2
	;(nil).delay = 0
	SoraDFadeINOUT(l, nil)
	_ENV = nil
	;(nil).beginOpacity = 0.5
	;(nil).endOpacity = 1
	;(nil).fadeIn = 2
	;(nil).fadeOut = 2
	;(nil).delay = 0
	SoraDFadeINOUT(r, nil)
end
function HalloweenView:onEnterPanel()
	local panel = SoraDCreatePanel("halloweenActionView")
	panel:initData(true)
	panel:show()
end
return HalloweenView
