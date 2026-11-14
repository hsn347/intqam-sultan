local WorldMapKingdomCityChangeNamePop = class("worldMapKingdomCityChangeNamePop", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapKingdomCityChangeNamePop")
	end
	return target
end)
function WorldMapKingdomCityChangeNamePop:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.txtDefault = ""
	self.isValid = false
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_1179"))
	self.txtTip = SoraDGetChildByName(self, "Text_tip")
	self.txtWarn = SoraDGetChildByName(self, "Text_warn")
	self.imgYesNo = SoraDGetChildByName(self, "Image_yesno")
	self.imgYesNo:setVisible(false)
	self.labelWarn = SoraDGetChildByName(self, "Text_warn")
	self.btnRename = SoraDGetChildByName(self, "Button_rename")
	self.btnRename:setTitleText(i18n("common_text_204"))
	self.btnRename:addTouchEventListener(handler(self, self.btnRenameClick))
	self.tfdRename = SoraDGetChildByName(self, "TextField_rename")
	self.tfdRename:setPlaceHolder(i18n("common_text_362"))
	self.tfdRename:setTextColor(cc.c4b(0, 0, 0, 255))
	self.tfdRename:setPlaceHolderColor(cc.c3b(50, 40, 40))
	self.tfdRename:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
	self.tfdRename:addEventListener(handler(self, self.OnInputChangeEnd))
	self.txtTip:setString(i18n("common_text_1180"))
	self.txtWarn:setString(i18n("common_text_1181"))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMNAME_CHANGED", handler(self, self.successChanged))
	self:initData()
end
function WorldMapKingdomCityChangeNamePop:initData(...)
	local gametop = gModuleMgr.getObject("gametop")
	local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
	self.txtDefault = KWKingdomCtrl:getKingdomName(true)
	self:initView()
end
function WorldMapKingdomCityChangeNamePop:initView(...)
	self.tfdRename:setPlaceHolder(self.txtDefault)
	self:changeToEditBox()
end
function WorldMapKingdomCityChangeNamePop:OnInputChangeEnd(extField, eventType)
	self.imgYesNo:setVisible(false)
	if eventType == ccui.TextFiledEventType.detach_with_ime then
		self:updateView()
	end
end
function WorldMapKingdomCityChangeNamePop:changeToEditBox()
	if self.tfdRename then
		local size = self.tfdRename:getContentSize()
		local pos = cc.p(self.tfdRename:getPositionX(), self.tfdRename:getPositionY())
		local ap = self.tfdRename:getAnchorPoint()
		local editBox = ccui.EditBox:create(size, "bg_transparent.png", ccui.TextureResType.plistType)
		editBox:setPosition(pos)
		editBox:setAnchorPoint(ap)
		editBox:setFontColor(display.COLOR_BLACK)
		editBox:setMaxLength(self.tfdRename:getMaxLength())
		editBox:addTouchEventListener(handler(self, self.OnEditBoxTouch))
		editBox:addTo(self.tfdRename:getParent())
		editBox:registerScriptEditBoxHandler(handler(self, self.OnInputChangeByEditBoxEnd))
		editBox:setPlaceHolder(self.tfdRename:getPlaceHolder())
		editBox:setPlaceholderFontColor(cc.c3b(50, 40, 40))
		editBox:setPlaceholderFontSize(20)
		self.tfdRename:removeFromParent()
		self.tfdRename = editBox
	end
end
function WorldMapKingdomCityChangeNamePop:OnEditBoxTouch(target, type)
	if type == ccui.TouchEventType.ended then
		target:touchDownAction(target, type)
	end
end
function WorldMapKingdomCityChangeNamePop:OnInputChangeByEditBoxEnd(event, editBox)
	if event == "began" then
	elseif event == "changed" then
		self:updateView()
	elseif event == "ended" or event == "return" then
	end
end
function WorldMapKingdomCityChangeNamePop:updateView()
	local returnName = self.tfdRename:getText()
	local nameLen = string.utf8len(returnName)
	self.imgYesNo:setVisible(true)
	local namkVailidCheck = function(nickName)
		local __err
		if nickName then
			if string.utf8len(nickName) > MAX_KINGDOM_NAME_LEN then
				__err = gErrDef.Err_NICKNAME
			elseif string.sub(nickName, 1, 1) == "(" then
				__err = gErrDef.Err_NICKNAME_BRACKET
			elseif string.match(nickName, "$SoarDragon&") then
				__err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
			elseif string.match(nickName, "[%%%*%^%$%[%]%*%+%-%?#&]+") then
				__err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
			elseif string.match(nickName, "\n") then
				__err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
			elseif string.match(nickName, "\r") then
				__err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
			else
				__err = gErrDef.Err_None
			end
		else
			__err = gErrDef.Err_NICKNAME
		end
		return __err
	end
	local err = namkVailidCheck(returnName)
	if gModuleMgr.sharedMgr("shieldedWordsltCtrl"):isNameShieldWord(returnName) then
		err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
	end
	if gModuleMgr.sharedMgr("shieldedWordsltCtrl"):hasShieldedWord(returnName) then
		err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
	end
	if gModuleMgr.sharedMgr("shieldedWordsltCtrl"):hasShieldedEmoji(returnName) then
		err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
	end
	if err == gErrDef.Err_None then
		self.imgYesNo:loadTexture("icon_czhl_g.png", ccui.TextureResType.plistType)
		self.labelWarn:setColor(cc.c3b(50, 20, 0))
		_ENV = cc.c3b(50, 20, 0)
		cc.c3b(50, 20, 0).count = MAX_KINGDOM_NAME_LEN - nameLen
		self.labelWarn:setString(i18n("common_text_364", cc.c3b(50, 20, 0)))
		self.isValid = true
	else
		if err == gErrDef.Err_NICKNAME_MIN_SIZE then
			_ENV = i18n("common_text_364", cc.c3b(50, 20, 0))
			i18n("common_text_364", cc.c3b(50, 20, 0)).num = MIN_FLAGTEAM_NAME_LEN
			self.labelWarn:setString(i18n("common_text_1442", i18n("common_text_364", cc.c3b(50, 20, 0))))
		else
			self.labelWarn:setString(i18n("common_text_366"))
		end
		self.labelWarn:setColor(display.COLOR_RED)
		self.imgYesNo:loadTexture("icon_czhl_x.png", ccui.TextureResType.plistType)
		self.isValid = false
	end
end
function WorldMapKingdomCityChangeNamePop:btnRenameClick(button, type)
	if type == ccui.TouchEventType.ended then
		self:updateView()
		if self.isValid then
			SoraDPlaySound()
			_ENV = nil
			;(nil).name = self.tfdRename:getText()
			SoraDShowMsgBox(i18n("common_text_1182", nil), i18n("common_text_204"), nil, function(type)
				if MSGBOX_CALLBACK_YES == type then
					if tolua.isnull(self) then
						return
					end
					local nowName = self.tfdRename:getText()
					local gametop = gModuleMgr.getObject("gametop")
					local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
					KWKingdomCtrl:changeName(nowName)
					button:setBright(false)
					button:setTouchEnabled(false)
					print(nowName)
				end
			end)
		end
	end
end
function WorldMapKingdomCityChangeNamePop:successChanged(target, data)
	if data then
		SoraDShowMsgTip(i18n("common_text_1443"))
		self:removeFromParent()
	end
end
return WorldMapKingdomCityChangeNamePop
