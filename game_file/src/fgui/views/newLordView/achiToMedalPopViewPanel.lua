local achiDesRead = include("achiDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local achiToMedalPopViewPanel = class("achiToMedalPopViewPanel", baseFguiPanel)
function achiToMedalPopViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("achiToMedalPopViewPanel:ctor", self.viewName)
end
function achiToMedalPopViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function achiToMedalPopViewPanel:onInit()
	print("=======achiToMedalPopViewPanel:onInit")
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.onGoClick))
	self.fields.achi:fixPos()
	self.fields.Text_upTxt:fixPos()
end
function achiToMedalPopViewPanel:onShow()
	print("=======achiToMedalPopViewPanel:onShow")
	self.singleInfo = self.param.myIconData
	self.fields.Panel_bg:setString(i18n(achiDesRead.getMedalById(self.singleInfo.medalID).medalName))
	local _aid = math.floor(self.singleInfo.otherInfo.curID / 1000) * 1000 + 3
	local _achiName = achiDesRead.getInfoById(_aid).achiName
	local _str, _num = achiDesRead.getTheFirstBuff(_aid)
	_ENV = i18n(achiDesRead.getMedalById(self.singleInfo.medalID).medalName)
	i18n(achiDesRead.getMedalById(self.singleInfo.medalID).medalName).achi = i18n(_achiName)
	self.fields.Text_upTxt:setString(i18n("common_text_2008", i18n(achiDesRead.getMedalById(self.singleInfo.medalID).medalName)))
	_ENV = i18n("common_text_2008", i18n(achiDesRead.getMedalById(self.singleInfo.medalID).medalName))
	i18n("common_text_2008", i18n(achiDesRead.getMedalById(self.singleInfo.medalID).medalName)).num = _num
	i18n("common_text_2008", i18n(achiDesRead.getMedalById(self.singleInfo.medalID).medalName)).str = _str
	self.fields.Text_downTxt:setString(i18n("common_text_1990", i18n("common_text_2008", i18n(achiDesRead.getMedalById(self.singleInfo.medalID).medalName))))
	self.fields.achi:initPopData(self.singleInfo)
end
function achiToMedalPopViewPanel:onGoClick(target, event)
	SoraDPlaySound()
	_ENV = nil
	;(nil).isToAchi = true
	;(nil).jumpID = self.singleInfo.medalID
	uiManager:show("honourWallView", nil)
	self:close()
end
return achiToMedalPopViewPanel
