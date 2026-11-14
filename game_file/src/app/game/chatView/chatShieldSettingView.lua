local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local chatThemeMgr = gChatMgrs:getMgr("chatThemeMgr")
local settingCtrl = SoraDGetCtrl("settingCtrl")
local chatShieldSettingView = class("chatShieldSettingView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("chatShieldSettingView")
	end
	return target
end)
function chatShieldSettingView:onExitPanel()
	local level = tonumber(self.editbox_level:getText()) or CASTLE_LV10_LIMITED
	level = math.min(level, CASTLE_LV30_LIMITED)
	level = math.max(level, CASTLE_LV10_LIMITED)
	_ENV = CASTLE_LV10_LIMITED
	CASTLE_LV10_LIMITED.byUID = true
	local lastLevel = SoraDConfigGet("Game:chat:castleLv~integer", CASTLE_LV10_LIMITED)
	local isChanged = false
	if lastLevel ~= level then
		_ENV = self.editbox_level:getText()
		self.editbox_level:getText().byUID = true
		SoraDConfigSet("Game:chat:castleLv~integer", level, self.editbox_level:getText())
		isChanged = true
	end
	local level0 = tonumber(self.editbox_level0:getText()) or 0
	level0 = math.min(level0, 70)
	level0 = math.max(level0, 0)
	_ENV = 0
	;(0).byUID = true
	local lastLevel0 = SoraDConfigGet("Game:chat:castleStarLv~integer", 0)
	if lastLevel0 ~= level0 then
		_ENV = self.editbox_level0:getText()
		self.editbox_level0:getText().byUID = true
		SoraDConfigSet("Game:chat:castleStarLv~integer", level0, self.editbox_level0:getText())
		isChanged = true
	end
	if isChanged then
		SoraDShowMsgTip(i18n("common_text_4131"))
		_ENV = i18n("common_text_4131")
		i18n("common_text_4131").msg = "MESSAGE_CHAT_SET_SHIELD_MESSAGE"
		SoraDSendMessage(i18n("common_text_4131"))
	end
	if lordInfoCtrl:getShiledStranger() ~= self.checkBoxShield:isSelected() then
		_ENV = self.checkBoxShield
		self.checkBoxShield.shiledStranger = self.checkBoxShield:isSelected()
		lordInfoCtrl:shieldStranger(self.checkBoxShield)
	end
	if settingCtrl:checkValue(gSettingKeyType.chatTitleShow) ~= self.checkBoxAt:isSelected() then
		if self.checkBoxAt:isSelected() then
			settingCtrl:setKeyValue(gSettingKeyType.chatTitleShow, gStatus.YES)
		else
			settingCtrl:setKeyValue(gSettingKeyType.chatTitleShow, gStatus.NO)
		end
	end
end
function chatShieldSettingView:ctor()
	self.isHaveTextField = true
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	settingCtrl = "Center_Node"
	;("Center_Node")[1] = "Node_Title"
	;("Center_Node")[2] = "text_mail_title"
	SoraDGetChildByFullPath(self.centerNode, "Center_Node"):setString(i18n("chat_text_62"))
	local scroll = SoraDGetChildByName(self, "ScrollView")
	settingCtrl = i18n("chat_text_62")
	i18n("chat_text_62")[1] = "Node_ShieldTitle"
	i18n("chat_text_62")[2] = "Text_Title"
	SoraDGetChildByFullPath(scroll, i18n("chat_text_62")):setString(i18n("chat_text_63"))
	settingCtrl = i18n("chat_text_63")
	i18n("chat_text_63")[1] = "Node_BgTitle"
	i18n("chat_text_63")[2] = "Text_Title"
	SoraDGetChildByFullPath(scroll, i18n("chat_text_63")):setString(i18n("chat_text_67"))
	settingCtrl = i18n("chat_text_67")
	i18n("chat_text_67")[1] = "Node_GoTitle"
	i18n("chat_text_67")[2] = "Text_Title"
	SoraDGetChildByFullPath(scroll, i18n("chat_text_67")):setString(i18n("chat_text_74"))
	SoraDGetChildByName(self, "Text_info"):setString(i18n("chat_text_64"))
	SoraDGetChildByName(self, "Text_info_0"):setString(i18n("chat_msg_01"))
	SoraDGetChildByName(self, "Text_ShieldTip"):setTextAreaSize(cc.size(300, 60))
	SoraDGetChildByName(self, "Text_ShieldTip"):setString(i18n("chat_text_65"))
	SoraDGetChildByName(self, "Text_GoTip"):setString(i18n("chat_text_75"))
	self.nodeCastle = SoraDGetChildByName(self, "Node_castle")
	self.btnAdd = SoraDGetChildByName(self.nodeCastle, "Button_Add")
	self.btnAdd:addTouchEventListener(handler(self, self.btnClickAdd))
	self.btnSub = SoraDGetChildByName(self.nodeCastle, "Button_Sub")
	self.btnSub:addTouchEventListener(handler(self, self.btnClickSub))
	self.nodeCastle0 = SoraDGetChildByName(self, "Node_castle_0")
	self.btnAdd0 = SoraDGetChildByName(self.nodeCastle0, "Button_Add")
	self.btnAdd0:addTouchEventListener(handler(self, self.btnClickAdd))
	self.btnSub0 = SoraDGetChildByName(self.nodeCastle0, "Button_Sub")
	self.btnSub0:addTouchEventListener(handler(self, self.btnClickSub))
	self.btnGo = SoraDGetChildByName(self, "Button_Goto")
	self.btnGo:setTitleText(i18n("common_text_678"))
	self.btnGo:addTouchEventListener(handler(self, self.btnClickGo))
	self.checkBoxShield = SoraDGetChildByName(self, "CheckBox_Shield")
	print("lordInfoCtrl:getShiledStranger()", lordInfoCtrl:getShiledStranger())
	self.checkBoxShield:setSelected(lordInfoCtrl:getShiledStranger())
	self.checkBoxShield:addEventListener(handler(self, self.btnCheckShieldClick))
	self.selectedImage = SoraDGetChildByName(self, "Image_Selected")
	self.imgNight = SoraDGetChildByName(self, "Image_Night")
	self.imgNight:setTouchEnabled(true)
	self.imgNight:addTouchEventListener(handler(self, self.onClickImg))
	self.imgLight = SoraDGetChildByName(self, "Image_Light")
	self.imgLight:setTouchEnabled(true)
	self.imgLight:addTouchEventListener(handler(self, self.onClickImg))
	self.checkBoxLight = SoraDGetChildByName(self, "CheckBox_Light")
	self.checkBoxNight = SoraDGetChildByName(self, "CheckBox_Night")
	self.checkBoxLight:setTouchEnabled(false)
	self.checkBoxNight:setTouchEnabled(false)
	SoraDToCenter(SoraDGetChildByName(self, "Node_Shield"), 10, false)
	local bgsp = display.newSprite("#frame_gouxuankuang01.png")
	bgsp:addTo(SoraDGetChildByName(self, "Node_Shield"), -1)
	bgsp:setPosition(self.checkBoxShield:getPosition())
	local Node_at = SoraDGetChildByName(self, "Node_at")
	SoraDGetChildByName(Node_at, "Text_Title"):setString(i18n("chat_text_86"))
	SoraDGetChildByName(Node_at, "Text_atTip"):setString(i18n("chat_text_81"))
	self.checkBoxAt = SoraDGetChildByName(Node_at, "CheckBox_at")
	if settingCtrl:checkValue(gSettingKeyType.chatTitleShow) then
		self.checkBoxAt:setSelected(true)
	else
		self.checkBoxAt:setSelected(false)
	end
	self.checkBoxAt:addEventListener(handler(self, self.btnCheckShieldClick))
	if gCurrentChatTheme == gChatTheme.normal then
		self.checkBoxNight:setSelected(false)
		self.checkBoxLight:setSelected(true)
		self.imgLight:setTouchEnabled(false)
		self.imgNight:setTouchEnabled(true)
		self.selectedImage:setPositionX(SoraDFPosX(-90, 0))
	else
		self.checkBoxNight:setSelected(true)
		self.checkBoxLight:setSelected(false)
		self.imgNight:setTouchEnabled(false)
		self.imgLight:setTouchEnabled(true)
		self.selectedImage:setPositionX(SoraDFPosX(90, 0))
	end
	_ENV = self.nodeCastle
	self.nodeCastle.inputMode = cc.EDITBOX_INPUT_MODE_NUMERIC
	self.nodeCastle.func = handler(self, self.OnInputLevel)
	self.editbox_level = SoraDChangeToEditBox(SoraDGetChildByName(self.nodeCastle, "TextField_level"), self.nodeCastle)
	_ENV = self.nodeCastle0
	self.nodeCastle0.inputMode = cc.EDITBOX_INPUT_MODE_NUMERIC
	self.nodeCastle0.func = handler(self, self.OnInputLevel)
	self.editbox_level0 = SoraDChangeToEditBox(SoraDGetChildByName(self.nodeCastle0, "TextField_level"), self.nodeCastle0)
	self:initData()
	self:initAnimation()
end
function chatShieldSettingView:initAnimation()
	SoraDGetChildByName(self, "Node_Bg"):setVisible(false)
	SoraDGetChildByName(self, "Center_Node"):setOpacity(0)
	local animation = cc.criSprite.createCriSprite("luomazhanhunzhi.usm", false, false, function(target)
		target:start()
		self = nil
		;(nil)[1] = cca.delay(0.35)
		;(nil)[2] = cca.fadeTo(0.5, 1)
		;(nil)[3] = cca.fadeTo(0.5, 1)
		;(nil)[4] = cca.fadeTo(0.5, 1)
		SoraDGetChildByName(self, "Center_Node"):runAction(cca.seq(nil))
	end)
	animation:addTo(SoraDGetChildByName(self, "Center_Node_Effect"))
	animation:setPosition(0, 20)
end
function chatShieldSettingView:initData()
	_ENV = nil
	;(nil).byUID = true
	local level = SoraDConfigGet("Game:chat:castleLv~integer", nil) or 0
	level = 0 < level and level or CASTLE_LV10_LIMITED
	self.editbox_level:setText(level)
	self:updateBtnState(level, self.editbox_level)
	_ENV = level
	level.byUID = true
	local level0 = SoraDConfigGet("Game:chat:castleStarLv~integer", level) or 0
	level0 = 0 < level0 and level0 or 0
	self.editbox_level0:setText(level0)
	self:updateBtnState(level0, self.editbox_level0)
end
function chatShieldSettingView:OnInputLevel(eventType, editBox)
	local inputLv = tonumber(editBox:getText())
	print("chatShieldSettingView:OnInputLevel", eventType, inputLv)
	if eventType == "return" or eventType == "ended" then
		local maxLevel = editBox == self.editbox_level and CASTLE_LV30_LIMITED or 70
		local minLevel = editBox == self.editbox_level and CASTLE_LV10_LIMITED or 0
		SoraDDelayCallOnce(self, function()
			if inputLv and inputLv <= minLevel or not inputLv then
				if editBox then
					self:updateBtnState(minLevel, editBox)
				end
			elseif inputLv and inputLv > maxLevel then
				if editBox then
					self:updateBtnState(maxLevel, editBox)
				end
			elseif inputLv and editBox then
				self:updateBtnState(inputLv, editBox)
			end
		end)
	end
end
function chatShieldSettingView:updateBtnState(level, editBox)
	level = level or 0
	local maxLevel = editBox == self.editbox_level and CASTLE_LV30_LIMITED or 70
	local minLevel = editBox == self.editbox_level and CASTLE_LV10_LIMITED or 0
	local btnAdd = editBox == self.editbox_level and self.btnAdd or self.btnAdd0
	local btnSub = editBox == self.editbox_level and self.btnSub or self.btnSub0
	btnAdd:setBright(level ~= maxLevel)
	btnSub:setBright(level ~= minLevel)
	if editBox == self.editbox_level and level < CASTLE_LV30_LIMITED then
		self:updateBtnState(0, self.editbox_level0)
	elseif editBox == self.editbox_level0 and 0 < level then
		self:updateBtnState(CASTLE_LV30_LIMITED, self.editbox_level)
	end
	if editBox and editBox:getText() ~= tostring(level) then
		editBox:setText(level)
	end
	print("level == minLevel", minLevel)
end
function chatShieldSettingView:btnClickAdd(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local maxLevel = button == self.btnAdd and CASTLE_LV30_LIMITED or 70
		local minLevel = button == self.btnAdd and CASTLE_LV10_LIMITED or 0
		local editBox = button == self.btnAdd and self.editbox_level or self.editbox_level0
		local level = tonumber(editBox:getText()) or minLevel
		if maxLevel <= level then
			editBox:setText(maxLevel)
		else
			editBox:setText(level + 1)
			self:updateBtnState(level + 1, editBox)
		end
	end
end
function chatShieldSettingView:btnClickSub(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local maxLevel = button == self.btnSub and CASTLE_LV30_LIMITED or 70
		local minLevel = button == self.btnSub and CASTLE_LV10_LIMITED or 0
		local editBox = button == self.btnSub and self.editbox_level or self.editbox_level0
		local level = tonumber(editBox:getText()) or minLevel
		if minLevel >= level then
			editBox:setText(minLevel)
		else
			editBox:setText(level - 1)
			self:updateBtnState(level - 1, editBox)
		end
	end
end
function chatShieldSettingView:onClickImg(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if button == self.imgLight then
			self.imgLight:setTouchEnabled(false)
			self.imgNight:setTouchEnabled(true)
			self.selectedImage:setPositionX(SoraDFPosX(-90, 0))
			self.checkBoxLight:setSelected(true)
			self.checkBoxNight:setSelected(false)
			chatThemeMgr:changeToChatTheme(gChatTheme.normal)
		else
			self.imgNight:setTouchEnabled(false)
			self.imgLight:setTouchEnabled(true)
			self.selectedImage:setPositionX(SoraDFPosX(90, 0))
			self.checkBoxNight:setSelected(true)
			self.checkBoxLight:setSelected(false)
			chatThemeMgr:changeToChatTheme(gChatTheme.dark)
		end
	end
end
function chatShieldSettingView:btnCheckShieldClick(target, eventType)
	SoraDPlaySound()
	if eventType == ccui.CheckBoxEventType.selected then
	elseif eventType == ccui.CheckBoxEventType.unselected then
	end
end
function chatShieldSettingView:btnClickGo(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDRemoveAllPrePanelFromManager(self)
		local xOffset = display.size.width * 0.5
		xOffset = xOffset + 60
		local showCastleChangeView = function(isFromWorld)
			local dressCtrl = SoraDGetCtrl("dressCtrl")
			_ENV = nil
			;(nil).isFromWorld = isFromWorld
			;(nil).dressID = dressCtrl:getCurDressID(gDressType.CHAT_TEXT_FRAME) or 9002410
			uiManager:show("castleChangeView", nil)
		end
		local currentScene = display.getRunningScene()
		local currentView = currentScene:currentSceneShowView()
		local scale = 0.4
		if currentView.__cname == "worldMapView" then
			showCastleChangeView(true)
		else
			showCastleChangeView(false)
			_ENV = false
			;(false).msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
			;(false).offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
			;(false).scale = scale
			;(false).xOffset = xOffset
			;(false).yOffset = display.rheight - 375
			;(false).buildIndex = 1050
			;(false).noOffsetDuration = true
			;(false).noScaleDuration = true
			SoraDSendMessage(false)
		end
	end
end
return chatShieldSettingView
