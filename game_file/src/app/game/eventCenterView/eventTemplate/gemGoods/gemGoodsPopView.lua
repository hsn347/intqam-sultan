local gemGoodsPopView = class("gemGoodsPopView", function()
	return SoraDCreateTouchPanel("gemGoodsPopView")
end)
function gemGoodsPopView:ctor()
	self.isIgnore = false
	self.enableTouchCloseSelf = true
	self.handle = nil
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:hideTitle()
	self.Text_msg = SoraDGetChildByName(self, "Text_msg")
	self.Image_ok = SoraDGetChildByName(self, "Image_ok")
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("common_text_2273"))
	self.Button_touch = SoraDGetChildByName(self, "Button_touch")
	self.Button_yes = SoraDGetChildByName(self, "Button_yes")
	self.Button_yes:setTitleText(i18n("common_text_054"))
	self.Button_no = SoraDGetChildByName(self, "Button_no")
	self.Button_no:setTitleText(i18n("common_text_185"))
	self.Button_touch:addTouchEventListener(handler(self, self.btnTouchClick))
	self.Button_yes:addTouchEventListener(handler(self, self.btnYesClick))
	self.Button_no:addTouchEventListener(handler(self, self.btnNoClick))
end
function gemGoodsPopView:initData(lang, isBuy, handle)
	self.handle = handle
	self.isBuy = isBuy
	self.Text_msg:setString(lang)
	self.Image_ok:setVisible(self.isIgnore)
end
function gemGoodsPopView:btnTouchClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.isIgnore = not self.isIgnore
		self.Image_ok:setVisible(self.isIgnore)
	end
end
function gemGoodsPopView:btnYesClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isIgnore then
			if self.isBuy then
				_ENV = nil
				;(nil).byUID = true
				SoraDConfigSet("Game:gemGoodsView:buyTip~bool", false, nil)
			else
				_ENV = nil
				;(nil).byUID = true
				SoraDConfigSet("Game:gemGoodsView:refreshTip~bool", false, nil)
			end
		end
		if self.handle then
			self.handle()
		end
		self:removeFromParent()
	end
end
function gemGoodsPopView:btnNoClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isIgnore then
			if self.isBuy then
				_ENV = nil
				;(nil).byUID = true
				SoraDConfigSet("Game:gemGoodsView:buyTip~bool", false, nil)
			else
				_ENV = nil
				;(nil).byUID = true
				SoraDConfigSet("Game:gemGoodsView:refreshTip~bool", false, nil)
			end
		end
		self:removeFromParent()
	end
end
return gemGoodsPopView
