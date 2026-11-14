local GameGoogleLoginView = class("gameGoogleLoginView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("gameGoogleLoginView")
	end
	return target
end)
function GameGoogleLoginView:ctor()
	SoraDGetChildByName(self, "Image_bg1"):setFillType(1)
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.layoutTouch = SoraDGetChildByName(self, "Panel_touch")
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelLogin = SoraDGetChildByName(self, "Text_login")
	self.btnUnLogin = SoraDGetChildByName(self, "Button_unLogin")
	self.btnLogin = SoraDGetChildByName(self, "Button_login")
	self.spriteIcon = SoraDGetChildByName(self, "Sprite_icon")
	self.btnUnLogin:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnLogin:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.labelNotice:setString(i18n("common_text_1690"))
	self.spriteIcon:setSpriteFrame("icon_google_login.png")
	self.labelLogin:setString(i18n("common_text_1691"))
	self.btnUnLogin:setTitleText(i18n("common_text_1692"))
	self.layoutTouch:setPositionX(280 - SoraDFSign(-640))
	print("self.layoutTouch:getPositionX()  " .. self.layoutTouch:getPositionX())
	self.spriteGirl = SoraDCreateGuideNPC(1, nil, SoraDFIsRA())
	self.spriteGirl:setPosition(cc.p(SoraDFSign(-display.width), -display.cy - 80))
	self.spriteGirl:addTo(self.centerNode, 1)
end
function GameGoogleLoginView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:close(button, type)
	end
end
function GameGoogleLoginView:onEnterPanel()
	self.layoutTouch:runAction(cca.moveTo(0.5, 320 + SoraDFSign(40), self.layoutTouch:getPositionY()))
	self.spriteGirl:runAction(cca.moveTo(0.5, SoraDFSign(-250), self.spriteGirl:getPositionY()))
end
return GameGoogleLoginView
