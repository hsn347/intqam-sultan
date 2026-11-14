local gametop = gModuleMgr.getObject("gametop")
local allianceQuery = gametop.playertop_:getModule("allianceQuery")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceCreateViewPanel = class("allianceCreateViewPanel", baseFguiPanel)
function allianceCreateViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceCreateViewPanel:ctor", self.viewName)
end
function allianceCreateViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceCreateViewPanel:onInit()
	print("=======allianceCreateViewPanel:onInit")
	self.isHidePrePanel = false
	self.isHaveTextField = true
	self.isEnableName = true
	self.isEnableabbr = true
	self.fields.Panel_bg:setString(i18n("common_text_168"))
	self.fields.Button_create:addClickListener(handler(self, self.btnClickCallBack))
end
function allianceCreateViewPanel:onShow()
	print("=======allianceCreateViewPanel:onShow")
	self:initData()
end
function allianceCreateViewPanel:initData()
	self.fields.Button_create:setEnabled(false)
	self:updateCreateBtn()
	self.fields.Com_content:initData()
end
function allianceCreateViewPanel:updateCreateBtn()
	self.fields.Button_create:initData(SoraDGetCastleLv() >= CASTLE_LV6_LIMITED)
end
function allianceCreateViewPanel:createSuccess(target, data)
	SoraDCloseLoading(self)
	_ENV = nil
	;(nil).allianceName = data.content.data.name
	SoraDShowMsgBox(i18n("common_text_649", nil), i18n("common_text_204"), nil, function(...)
		SoraDRemoveAllPrePanelFromManager(self)
		if GLOBAL_GAME_ALLIANCE_MODE then
			_ENV = nil
			;(nil).isNeedGuide = true
			uiManager:show("allianceMainView", nil)
		else
			local panel = SoraDCreatePanel("allianceMainView")
			panel:show()
			panel:click2View()
		end
	end)
end
function allianceCreateViewPanel:allianceInputErr(target, data)
	SoraDCloseLoading(self)
	local isName = data.err == gErrDef.Err_ALLIANCE_NAME_ILLEGAL or data.err == gErrDef.Err_ALLIANCE_NAME_LENGTH or data.err == gErrDef.Err_ALLIANCE_NAME_HAVE
	self.isEnableName = true
	self.isEnableabbr = true
	self.fields.Com_content:updateErr(data.err, isName)
	if data.type == "name" then
		self.isEnableName = data.err == gErrDef.Err_None
	end
	if data.type == "abbr" then
		self.isEnableabbr = data.err == gErrDef.Err_None
	end
	self.fields.Button_create:setEnabled(self.isEnableName and self.isEnableabbr)
end
function allianceCreateViewPanel:btnClickCallBack()
	SoraDPlaySound()
	local name, abbr, slogan, language = self.fields.Com_content:getInputContent()
	print("xxxxxxxx====", name, abbr, slogan, language)
	if not IsArClient and not language then
		SoraDShowMsgTip(i18n("alliance_text_12_ros"))
		return
	end
	if SoraDGetCastleLv() >= CASTLE_LV6_LIMITED or SoraDEnoughGold(gConstValue.ALLIANCE_CREATE_ALLIANCE_GOLD) then
		allianceMgr:reqCreateAlliance(name, abbr, slogan, language)
		SoraDShowLoading(self)
	end
end
return allianceCreateViewPanel
