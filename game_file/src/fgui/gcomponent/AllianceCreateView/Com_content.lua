local gametop = gModuleMgr.getObject("gametop")
local allianceQuery = gametop.playertop_:getModule("allianceQuery")
local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_content = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceCreateView/Com_content", Com_content)
function Com_content:onInit()
	self:setScrollEnable(not IsArClient and commonCheck.ALLIANCE_CREATE_LANGUAGE)
	self.controllers.c1:setSelectedIndex(not IsArClient and commonCheck.ALLIANCE_CREATE_LANGUAGE and 1 or 0)
	self.fields.Text_name:setString(i18n("common_text_171"))
	self.fields.Text_nameNotice:setString(i18n("common_text_174"))
	_ENV = i18n("common_text_174")
	i18n("common_text_174").count = ALLIANCE_NAME_MAX
	self.fields.Text_errName:setString(i18n("common_text_364", i18n("common_text_174")))
	self.fields.Sprite_nameErr:setVisible(false)
	self.fields.TextField_name:setMaxLength(ALLIANCE_NAME_MAX)
	self.fields.TextField_name:addEventListener(fgui.UIEventType.Changed, handler(self, self.OnInputName))
	self.fields.TextField_name:addEventListener(fgui.UIEventType.Submit, handler(self, self.OnSubmit))
	self.fields.TextField_name:setAlign(SoraDFLabelR())
	self.fields.TextField_name:setPrompt(fguiHelper.getColorString("#746e65", i18n("common_text_175")))
	self.fields.Text_nickName:setString(i18n("common_text_172"))
	self.fields.Text_nickNameNotice:setString(i18n("common_text_176"))
	_ENV = i18n("common_text_176")
	i18n("common_text_176").count = ALLIANCE_NAME_MIN
	self.fields.Text_errNickName:setString(i18n("common_text_364", i18n("common_text_176")))
	self.fields.Sprite_nickNameErr:setVisible(false)
	self.fields.TextField_nickName:setMaxLength(ALLIANCE_NAME_MIN)
	self.fields.TextField_nickName:addEventListener(fgui.UIEventType.Changed, handler(self, self.OnInputNickName))
	self.fields.TextField_nickName:addEventListener(fgui.UIEventType.Submit, handler(self, self.OnSubmit))
	self.fields.TextField_nickName:setAlign(SoraDFLabelR())
	self.fields.TextField_nickName:setPrompt(fguiHelper.getColorString("#746e65", i18n("common_text_177")))
	self.fields.Text_slogan:setString(i18n("common_text_173"))
	_ENV = i18n("common_text_173")
	i18n("common_text_173").count = ALLIANCE_DES_MAX
	self.fields.Text_errSlogan:setString(i18n("common_text_364", i18n("common_text_173")))
	self.fields.TextField_slogan:setMaxLength(ALLIANCE_DES_MAX)
	self.fields.TextField_slogan:addEventListener(fgui.UIEventType.Changed, handler(self, self.OnInputSlogan))
	self.fields.TextField_slogan:setAlign(SoraDFLabelR())
	self.fields.TextField_slogan:setPrompt(fguiHelper.getColorString("#746e65", i18n("common_text_178")))
	self.tableLanguageList, _ENV, self.ownLanguage = self.fields.TextField_slogan.setPrompt, self.fields.TextField_slogan.setPrompt, nil
	if commonCheck.ALLIANCE_CREATE_LANGUAGE then
		self.fields.Text_alliance:setString(i18n("common_text_715"))
		self.fields.Text_alliance:setPositionY(479)
		self.fields.Text_alliance:setVisible(true)
		self.fields.List_language:setPositionY(514)
		self.fields.List_language:setVisible(true)
		self.fields.List_language:setItemRenderer(handler(self, self.onLanguageRenderer))
		self:initScroll()
	end
	self.fields.Text_name:fixPos()
	self.fields.Text_nickName:fixPos()
	self.fields.Text_slogan:fixPos()
	self.fields.Text_alliance:fixPos()
	self.fields.Sprite_nameErr:fixPos()
	self.fields.Sprite_nickNameErr:fixPos()
end
function Com_content:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_SELECT_LANGUAGE", handler(self, self.languageSelect))
end
function Com_content:languageSelect(target, data)
	self.ownLanguage = data.lid
	self.fields.List_language:setNumItems(#self.tableLanguageList)
end
function Com_content:onLanguageRenderer(index, obj)
	obj:initData(self.tableLanguageList[index + 1], self.ownLanguage)
end
function Com_content:onShow()
end
function Com_content:initData()
end
function Com_content:initScroll()
	self.tableLanguageList = permissionCtrl:getLanguageMenu()
	self.fields.List_language:setHeight(math.ceil(#self.tableLanguageList / 2) * 60)
	self:setHeight(462 + math.ceil(#self.tableLanguageList / 2) * 60 + 50)
	self.fields.List_language:setNumItems(#self.tableLanguageList)
end
function Com_content:OnInputName()
	local inputCount = string.len(self.fields.TextField_name:getText())
	_ENV = self.fields.TextField_name:getText()
	self.fields.TextField_name:getText().count = ALLIANCE_NAME_MAX - inputCount
	self.fields.Text_errName:setString(i18n("common_text_364", self.fields.TextField_name:getText()))
end
function Com_content:OnInputNickName()
	local inputCount = string.len(self.fields.TextField_nickName:getText())
	_ENV = self.fields.TextField_nickName:getText()
	self.fields.TextField_nickName:getText().count = ALLIANCE_NAME_MIN - inputCount
	self.fields.Text_errNickName:setString(i18n("common_text_364", self.fields.TextField_nickName:getText()))
end
function Com_content:OnInputSlogan()
	local inputCount = string.len(self.fields.TextField_slogan:getText())
	_ENV = self.fields.TextField_slogan:getText()
	self.fields.TextField_slogan:getText().count = ALLIANCE_DES_MAX - inputCount
	self.fields.Text_errSlogan:setString(i18n("common_text_364", self.fields.TextField_slogan:getText()))
end
function Com_content:OnSubmit()
	self.fields.Sprite_nameErr:setSpriteFrame("bg_main_task05.png")
	self.fields.Text_errName:setColor(cc.c3b(120, 120, 120))
	self.fields.Sprite_nickNameErr:setSpriteFrame("bg_main_task05.png")
	self.fields.Text_errNickName:setColor(cc.c3b(120, 120, 120))
	_ENV = self.fields.Text_errNickName
	self.fields.Text_errNickName.msg = "MESSAGE_ALLIANCE_CREATE_ERR_BACK"
	self.fields.Text_errNickName.err = gErrDef.Err_None
	SoraDSendMessage(self.fields.Text_errNickName)
	allianceQuery:reqCheckAllianceName(self.fields.TextField_name:getText())
	allianceQuery:reqCheckAllianceAbbr(self.fields.TextField_nickName:getText())
end
function Com_content:getInputContent()
	return self.fields.TextField_name:getText(), self.fields.TextField_nickName:getText(), self.fields.TextField_slogan:getText(), self.ownLanguage
end
function Com_content:updateErr(err, isName)
	self.fields.Sprite_nameErr:setVisible(true)
	self.fields.Sprite_nickNameErr:setVisible(true)
	if isName then
		if err == gErrDef.Err_None then
			self.fields.Sprite_nameErr:setSpriteFrame("bg_main_task05.png")
			self.fields.Text_errName:setColor(cc.c3b(120, 120, 120))
		else
			self.fields.Sprite_nameErr:setSpriteFrame("bg_main_task06.png")
			self.fields.Text_errName:setColor(cc.c3b(190, 40, 40))
			if err == gErrDef.Err_ALLIANCE_CREATE_INPUT_LENS then
				self.fields.Text_errName:setString(i18n("notice_0070"))
			elseif err == gErrDef.Err_ALLIANCE_CREATE_INPUT_IIIEGAL_CHARACTER or err == gErrDef.Err_ALLIANCE_NAME_ILLEGAL then
				self.fields.Text_errName:setString(i18n("notice_0153"))
			elseif err == gErrDef.Err_ALLIANCE_NAME_HAVE then
				self.fields.Text_errName:setString(i18n("notice_0072"))
			end
		end
	elseif err == gErrDef.Err_None then
		self.fields.Sprite_nickNameErr:setSpriteFrame("bg_main_task05.png")
		self.fields.Text_errNickName:setColor(cc.c3b(120, 120, 120))
	else
		self.fields.Sprite_nickNameErr:setSpriteFrame("bg_main_task06.png")
		self.fields.Text_errNickName:setColor(cc.c3b(190, 40, 40))
		if err == gErrDef.Err_ALLIANCE_CREATE_INPUT_LENS then
			self.fields.Text_errNickName:setString(i18n("notice_0074"))
		elseif err == gErrDef.Err_ALLIANCE_CREATE_INPUT_IIIEGAL_CHARACTER or err == gErrDef.Err_ALLIANCE_ABBR_ILLEGAL then
			self.fields.Text_errNickName:setString(i18n("notice_0154"))
		elseif err == gErrDef.Err_ALLIANE_ABBR_HAVE then
			self.fields.Text_errNickName:setString(i18n("notice_0155"))
		end
	end
end
return Com_content
