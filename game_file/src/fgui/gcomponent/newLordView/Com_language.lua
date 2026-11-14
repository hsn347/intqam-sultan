local gametop = gModuleMgr.getObject("gametop")
local settingCtrl = gametop.playertop_:getModule("settingCtrl")
local translateCtrl = gametop.playertop_:getModule("translateCtrl")
local langAbbrRead = include("langAbbrRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_language = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_language", Com_language)
function Com_language:onInit()
	self.defaultLang = GameLanguageCopy
	self.dataTbl, _ENV, self.isTransChange = GameLanguageCopy, GameLanguageCopy, false
	self.fields.List:autoFix()
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List:setNeedAutoFix(false)
	self.fields.Com_centerChoose:fixChildrenPos()
	self.fields.Com_centerChoose:getChild("title"):setString(i18n("common_text_4294"))
	self.fields.Com_centerChoose:getChild("Check_tick"):addClickListener(handler(self, self.autoTranlsateClick))
	self.fields.Com_centerChoose:getChild("Check_tick"):setSelected(settingCtrl:isAutoTranslateSwitchOn())
end
_ENV, _UPVALUE3_, Com_language.onShow = "ui://newLordView/Com_language", function(self)
end, function(self)
end
;("ui://newLordView/Com_language").title = "common_text_254"
_ENV, ("ui://newLordView/Com_language").des = Com_language, " "
Com_language.title = "common_text_1667"
_ENV, Com_language.des = nil, "common_text_1666"
;(nil).title = "common_text_1537_s"
;(nil).des = "common_text_1542"
;(function(self)
end)[1] = "ui://newLordView/Com_language"
;(function(self)
end)[2] = Com_language
local (function(self)
end)[3], config = nil, function(self)
end
function Com_language:initData(index)
	self.showType = index
	self.controllers.c1:setSelectedIndex(index)
	self.fields.Text_title:setString(i18n(config[index + 1].title))
	self.fields.Text_des:setString(i18n(config[index + 1].des))
	if self.showType == 0 then
		self:initLanguage()
	elseif self.showType == 1 then
		self:initTransTo()
	elseif self.showType == 2 then
		self:initTrans()
	end
	self:setHeight(self.fields.List:getPositionY() + self.fields.List:getHeight())
end
function Com_language:initLanguage()
	local lang = userSDKManager.getChannel()
	local _ENV, langCfg
	if userSDKManager.isAR() then
		_ENV = userSDKManager.isAR()
		userSDKManager.isAR().ar = "العربية"
		langCfg, userSDKManager.isAR().en = userSDKManager.isAR(), "English"
	elseif userSDKManager.isEN() then
		_ENV = userSDKManager.isEN()
		userSDKManager.isEN().en = "English"
		userSDKManager.isEN().es = "Español"
		userSDKManager.isEN().tr = "Türkçe"
		userSDKManager.isEN().de = "Deutsch"
		userSDKManager.isEN().fr = "français"
		userSDKManager.isEN().it = "Italiano"
		userSDKManager.isEN().pt = "Português"
		userSDKManager.isEN().ru = "Русский язык"
		userSDKManager.isEN().pl = "Polski"
		userSDKManager.isEN().ro = "Română"
		userSDKManager.isEN().ja = "日本語"
		userSDKManager.isEN().id = "Bahasa Indonesia"
		userSDKManager.isEN().vi = "Tiếng Việt"
		userSDKManager.isEN().nl = "Nederlands"
		userSDKManager.isEN()["zh-CN"] = "简体中文"
		userSDKManager.isEN()["zh-TW"] = "繁體中文"
		langCfg, userSDKManager.isEN().ko = userSDKManager.isEN(), "한국어"
	elseif userSDKManager.isKO() then
		_ENV = userSDKManager.isKO()
		userSDKManager.isKO().ko = "한국어"
		langCfg, userSDKManager.isKO().en = userSDKManager.isKO(), "English"
	end
	local languageConfig = include("languageConfig")
	local clientLangList = languageConfig:getClientLanguageArray()
	dump(clientLangList, "客户端语言")
	local lang = userSDKManager.getChannel()
	self.dataTbl, _ENV = clientLangList, clientLangList
	for i, v in ipairs(clientLangList) do
		_ENV = nil
		;(nil).isSelected = v == self.defaultLang
		;(nil).short = v
		;(nil).name = langCfg[v] or "undefined"
		table.insert(self.dataTbl, nil)
	end
	self.fields.List:setNumItems(#self.dataTbl)
	self.fields.List:resizeToFit(#self.dataTbl)
end
function Com_language:initTransTo()
	local TL = translateCtrl:getTranslateTLArray()
	self.transToLang = settingCtrl:getTranslateLanguage()
	dump(self.transToLang, "self.transToLang")
	self.dataTbl, translateCtrl = dump, dump
	for i, v in ipairs(TL) do
		translateCtrl = nil
		;(nil).isSelected = v == self.transToLang
		;(nil).short = v
		;(nil).name = i18n(langAbbrRead.getAbbrName(v))
		table.insert(self.dataTbl, nil)
	end
	dump(self.dataTbl, "self.transToTbl")
	self.fields.List:setNumItems(#self.dataTbl)
	self.fields.List:resizeToFit(#self.dataTbl)
end
function Com_language:initTrans()
	local Sl = translateCtrl:getSupportTLArray()
	local clientList = settingCtrl:getTLList()
	self.dataTbl, translateCtrl = settingCtrl, settingCtrl
	for i, v in ipairs(Sl) do
		translateCtrl = nil
		;(nil).isSelected = clientList[v] and true or false
		;(nil).short = v
		;(nil).name = i18n(langAbbrRead.getAbbrName(v))
		table.insert(self.dataTbl, nil)
	end
	dump(self.dataTbl, "self.transTbl")
	self.fields.List:setNumItems(#self.dataTbl)
	self.fields.List:resizeToFit(#self.dataTbl)
end
function Com_language:onItemRederer(index, target)
	target:fixChildrenPos()
	target:getChild("title"):setString(i18n(self.dataTbl[index + 1].name))
	target:getChild("Check_tick"):addClickListener(handlerEx(self, self.checkClick, index + 1))
	function target.setSelected(_, isSelected)
		target:getChild("Check_tick"):setSelected(isSelected)
	end
	target:setSelected(self.dataTbl[index + 1].isSelected)
end
function Com_language:autoTranlsateClick(EventContext)
	SoraDPlaySound()
	local button = EventContext:getSender()
	local isSelected = button:isSelected()
	print("自动翻译 = ", isSelected)
	local num = self.fields.List:numChildren()
	for i = 0, num - 1 do
		if self.fields.List:getChildAt(i).setSelected then
			self.fields.List:getChildAt(i):setSelected(isSelected)
		end
	end
	if isSelected then
		settingCtrl:setAutoTranslateSwitchOn()
	else
		settingCtrl:setAutoTranslateSwitchOff()
	end
	self.isTransChange = true
end
function Com_language:checkClick(index, EventContext)
	SoraDPlaySound()
	local button = EventContext:getSender()
	local data = self.dataTbl[index]
	if self.showType == 0 then
		button:setSelected(not button:isSelected())
		_ENV = button
		button.lang = data.name
		SoraDShowMsgBox(i18n("common_text_1178", button), i18n("common_text_204"), i18n("common_text_185"), function(type)
			if MSGBOX_CALLBACK_YES == type then
				SoraDConfigSet("System:GameLanguageView:language~string", data.short)
				SoraDGetDefaultLanguage()
				uiManager:initLanguage()
				local gametop = gModuleMgr.getObject("gametop")
				local noticeCtrl = gametop.playertop_:getModule("noticeCtrl")
				noticeCtrl:setLanguage(GameLanguageCopy)
				gametop:Logout()
				SoraDShowLoginView()
			end
		end)
	elseif self.showType == 1 then
		local num = self.fields.List:numChildren()
		for i = 0, num - 1 do
			self.fields.List:getChildAt(i):setSelected(false)
		end
		button:setSelected(true)
		local gametop = gModuleMgr.getObject("gametop")
		local settingCtrl = gametop.playertop_:getModule("settingCtrl")
		settingCtrl:setTranslateTL(data.short)
		self.isTransChange = true
	elseif self.showType == 2 then
		if not settingCtrl:isAutoTranslateSwitchOn() then
			SoraDShowMsgTip(i18n("commom_text_4301"))
			button:setSelected(false)
			return
		end
		self.isTransChange = true
	end
end
function Com_language:onHide()
	local settingCtrl, checkList
	if self.isTransChange then
		local isAutoTranslateOn = settingCtrl:isAutoTranslateSwitchOn()
		if isAutoTranslateOn and self.showType == 2 then
			for i, data in ipairs(self.dataTbl) do
				checkList[data.short] = self.fields.List:getChildAt(i - 1):getChild("Check_tick"):isSelected()
			end
			settingCtrl:setTranslateLanguage(checkList)
		end
		print("选项内容发生了变化，通知sdk和聊天模块进行刷新")
		local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
		chatDataMgr:refreshLanguage()
	end
end
return Com_language
