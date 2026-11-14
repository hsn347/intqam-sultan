local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local castleChangeSettingViewPanel = class("castleChangeSettingViewPanel", baseFguiPanel)
function castleChangeSettingViewPanel:ctor(...)
	self.isLRU = true
	castleChangeSettingViewPanel.super.ctor(self, ...)
	print("castleChangeSettingViewPanel:ctor", self.viewName)
end
function castleChangeSettingViewPanel:onInit()
	print("=======castleChangeSettingViewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("castle_skin_btn_02"))
	self.fields.List:setItemRenderer(handler(self, self.onSingleRenderer))
end
function castleChangeSettingViewPanel:onSingleRenderer(index, obj)
	obj:initData(self.settingCfg[index + 1])
end
function castleChangeSettingViewPanel:endShow()
	print("=======castleChangeSettingViewPanel:endShow")
	_ENV, _ENV = "=======castleChangeSettingViewPanel:endShow", print
	;("=======castleChangeSettingViewPanel:endShow").handle = handler(self, self.btnWarCallBack)
	;("=======castleChangeSettingViewPanel:endShow").title = i18n("set_text_01")
	;("=======castleChangeSettingViewPanel:endShow").des = i18n("set_text_02")
	;("=======castleChangeSettingViewPanel:endShow").isShow = handler(self, self.isShowWarLvEffectFun)
	_ENV, print[1], ("=======castleChangeSettingViewPanel:endShow").tag = "=======castleChangeSettingViewPanel:endShow", "=======castleChangeSettingViewPanel:endShow", 1
	;("=======castleChangeSettingViewPanel:endShow").handle = handler(self, self.btnOfficeCallBack)
	;("=======castleChangeSettingViewPanel:endShow").title = i18n("set_text_05")
	;("=======castleChangeSettingViewPanel:endShow").des = i18n("set_text_06")
	;("=======castleChangeSettingViewPanel:endShow").isShow = handler(self, self.isShowOfficeIconFun)
	_ENV, print[2], ("=======castleChangeSettingViewPanel:endShow").tag = "=======castleChangeSettingViewPanel:endShow", "=======castleChangeSettingViewPanel:endShow", 2
	;("=======castleChangeSettingViewPanel:endShow").handle = handler(self, self.btnPrisonHeroBack)
	;("=======castleChangeSettingViewPanel:endShow").title = i18n("ice_carnival_text20")
	;("=======castleChangeSettingViewPanel:endShow").des = i18n("ice_carnival_text21")
	;("=======castleChangeSettingViewPanel:endShow").isShow = handler(self, self.isShowPrisonHeroFun)
	self.settingCfg, print[3], ("=======castleChangeSettingViewPanel:endShow").tag = print, "=======castleChangeSettingViewPanel:endShow", 3
	self.fields.List:setNumItems(#self.settingCfg)
	self.fields.List:setScrollEnable(#self.settingCfg > 3)
end
function castleChangeSettingViewPanel:btnWarCallBack(isSelected)
	SoraDPlaySound()
	lordInfoCtrl:setIsHideWarLvEffect(not isSelected)
end
function castleChangeSettingViewPanel:isShowWarLvEffectFun()
	return not lordInfoCtrl:isHideWarLvEffect()
end
function castleChangeSettingViewPanel:btnOfficeCallBack(isSelected)
	SoraDPlaySound()
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:worldMapOfficeIcon:OfficeIcon~bool", isSelected, nil)
	SoraDShowMsgTip(isSelected and i18n("set_text_08") or i18n("set_text_07"))
	_ENV = isSelected and i18n("set_text_08") or i18n("set_text_07")
	;(isSelected and i18n("set_text_08") or i18n("set_text_07")).msg = "MESSAGE_WORLD_MAP_CASTLE_OFFICEICON"
	SoraDSendMessage(isSelected and i18n("set_text_08") or i18n("set_text_07"))
end
function castleChangeSettingViewPanel:isShowOfficeIconFun()
	_ENV = nil
	;(nil).byUID = true
	local isShow = SoraDConfigGet("Game:worldMapOfficeIcon:OfficeIcon~bool", nil)
	if isShow == nil then
		isShow = true
	end
	return isShow
end
function castleChangeSettingViewPanel:btnPrisonHeroBack(isSelected)
	SoraDPlaySound()
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:castleChangeSetting:PrisonHeroIcon~bool", isSelected, nil)
	_ENV = "Game:castleChangeSetting:PrisonHeroIcon~bool"
	;("Game:castleChangeSetting:PrisonHeroIcon~bool").msg = "MESSAGE_WORLD_MAP_CASTLE_PRISIONICON"
	SoraDSendMessage("Game:castleChangeSetting:PrisonHeroIcon~bool")
end
function castleChangeSettingViewPanel:isShowPrisonHeroFun()
	_ENV = nil
	;(nil).byUID = true
	local isShow = SoraDConfigGet("Game:castleChangeSetting:PrisonHeroIcon~bool", nil)
	if isShow == nil then
		isShow = true
	end
	return isShow
end
return castleChangeSettingViewPanel
