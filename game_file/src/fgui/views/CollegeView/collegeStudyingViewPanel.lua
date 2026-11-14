local baseFguiPanel = require("fgui.base.baseFguiPanel")
local collegeStudyingViewPanel = class("collegeStudyingViewPanel", baseFguiPanel)
function collegeStudyingViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("collegeStudyingViewPanel:ctor", self.viewName)
end
function collegeStudyingViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function collegeStudyingViewPanel:onInit()
	print("=======collegeStudyingViewPanel:onInit")
	_ENV = print
	_ENV = nil
	;(nil).scroll = "collegeResScrollView"
	;(nil).title = i18n("common_text_123")
	print[TECHNOLOGY_ATTR.resource], (nil).tab = nil, 0
	_ENV = nil
	;(nil).scroll = "collegeDevelopScrollView"
	;(nil).title = i18n("common_text_331")
	print[TECHNOLOGY_ATTR.cityDevelop], (nil).tab = nil, 1
	_ENV = nil
	;(nil).scroll = "collegeHeroScrollView"
	;(nil).title = i18n("common_name_01")
	print[TECHNOLOGY_ATTR.hero], (nil).tab = nil, 2
	_ENV = nil
	;(nil).scroll = "collegeDefScrollView"
	;(nil).title = i18n("common_text_332")
	print[TECHNOLOGY_ATTR.anchor], (nil).tab = nil, 3
	_ENV = nil
	;(nil).scroll = "collegeWarScrollView"
	;(nil).title = i18n("common_text_045")
	print[TECHNOLOGY_ATTR.military], (nil).tab = nil, 4
	_ENV = nil
	;(nil).scroll = "collegeSpecialScrollView"
	;(nil).title = i18n("common_text_1962")
	print[TECHNOLOGY_ATTR.special], (nil).tab = nil, 5
	_ENV = nil
	;(nil).scroll = "collegeAdvancedMilitaryScrollView"
	;(nil).title = i18n("common_name_02")
	print[TECHNOLOGY_ATTR.advancedmilitary], (nil).tab = nil, 6
	_ENV = nil
	;(nil).scroll = "collegeSoldierScrollView"
	;(nil).title = i18n("common_text_3772")
	print[TECHNOLOGY_ATTR.soldier], (nil).tab = nil, 7
	_ENV = nil
	;(nil).scroll = "collegeCommanderScrollView"
	;(nil).title = i18n("common_text_4055")
	self.techTreeCfg, print[TECHNOLOGY_ATTR.leader], (nil).tab = print, nil, 8
	self.fields.Com_title:initData("", handler(self, self.onClickClose))
	self.fields.Button_close_right:addClickListener(handler(self, self.btnClick))
end
function collegeStudyingViewPanel:onShow()
	print("=======collegeStudyingViewPanel:onShow")
	self.techType = self.param.techType or TECHNOLOGY_ATTR.resource
	self.jumpTid = self.param and self.param.jumpTid
	self.fields.Com_title:updateTitle(self.techTreeCfg[self.techType].title)
	self.controllers.c1:setSelectedIndex(self.techTreeCfg[self.techType].tab)
	self:initData()
end
function collegeStudyingViewPanel:initData()
	self.fields[self.techTreeCfg[self.techType].scroll]:initData(self.techType)
	if self.jumpTid then
		self.fields[self.techTreeCfg[self.techType].scroll]:getCollegeSingleById(self.jumpTid)
	end
end
function collegeStudyingViewPanel:btnClick()
	SoraDPlaySound()
	SoraDRemoveAllPanelFromManager()
end
function collegeStudyingViewPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "collegeScrollSingle" then
		local target = self.fields[self.techTreeCfg[self.techType].scroll]:getCollegeSingleById(parameters.tid)
		if target then
			return target
		end
	end
	return self.fields[itemName]
end
return collegeStudyingViewPanel
