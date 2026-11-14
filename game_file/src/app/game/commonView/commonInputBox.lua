local CommonInputBox = class("commonInputBox", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("commonInputBox")
	end
	return target
end)
function CommonInputBox:ctor()
	self.isHaveTextField = true
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.btnOk = SoraDGetChildByName(self, "Button_ok")
	self.txtContent = SoraDGetChildByName(self, "TextField_content")
	self.txtDetail = SoraDGetChildByName(self, "Text_detail")
	self.btnOk:setTitleText(i18n("common_text_204"))
	self.btnOk:addTouchEventListener(handler(self, self.btnOkClick))
end
function CommonInputBox:initData(title, default, detail, maxCharLen, handl, noUseDefault)
	_UPVALUE0_ = nil
	;(nil).title = title
	;(nil).default = default
	;(nil).detail = detail
	;(nil).maxCharLen = maxCharLen
	self.bringData, (nil).noUseDefault = nil, noUseDefault
	self.handl = handl
	self:initView()
end
function CommonInputBox:initView()
	self:changeToEditBox(self.bringData.default, self.bringData.maxCharLen)
	self.ccs_bg:setTitleName(self.bringData.title or "")
	self.txtDetail:setString(self.bringData.detail or "")
end
function CommonInputBox:changeToEditBox(default, maxCharLen)
	if self.txtContent then
		local size = self.txtContent:getContentSize()
		local pos = cc.p(self.txtContent:getPositionX(), self.txtContent:getPositionY())
		local ap = self.txtContent:getAnchorPoint()
		local editBox = ccui.EditBox:create(size, "bg_transparent.png", ccui.TextureResType.plistType)
		editBox:setPosition(pos)
		editBox:setAnchorPoint(ap)
		editBox:setFontColor(display.COLOR_BLACK)
		if maxCharLen then
			editBox:setMaxLength(maxCharLen)
		end
		editBox:addTouchEventListener(handler(self, self.OnEditBoxTouch))
		editBox:addTo(self.txtContent:getParent())
		editBox:registerScriptEditBoxHandler(handler(self, self.OnInputChangeByEditBoxEnd))
		editBox:setPlaceHolder(default or "")
		editBox:setPlaceholderFontColor(cc.c3b(170, 170, 170))
		editBox:setPlaceholderFontSize(28)
		self.txtContent:removeFromParent()
		self.txtContent = editBox
	end
end
function CommonInputBox:btnOkClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.handl then
			local outContent = self.txtContent:getText()
			if outContent ~= "" then
				self.handl(outContent)
			elseif self.bringData.noUseDefault then
				self.handl()
			else
				self.handl(self.bringData.default or "")
			end
			self:removeFromParent()
		end
	end
end
function CommonInputBox:OnEditBoxTouch(target, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		target:touchDownAction(target, type)
	end
end
function CommonInputBox:OnInputChangeByEditBoxEnd(event, editBox)
	if event == "began" then
	elseif event == "changed" then
	elseif event == "ended" or event == "return" then
	end
end
return CommonInputBox
