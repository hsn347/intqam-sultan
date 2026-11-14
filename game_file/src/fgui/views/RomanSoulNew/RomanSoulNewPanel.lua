local gametop = gModuleMgr.getObject("gametop")
local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
local romeActivityltCtrl = include("romeActivityltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RomanSoulNewPanel = class("RomanSoulNewPanel", baseFguiPanel)
function RomanSoulNewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("RomanSoulNewPanel:ctor", self.viewName)
end
function RomanSoulNewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE3_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "RomanSoulNew"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function RomanSoulNewPanel:onInit()
	romeActivityCtrl:reqMemScoreAndAllScore()
	print("=======RomanSoulNewPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_1221"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self:initData()
end
function RomanSoulNewPanel:initData()
	romeActivityCtrl:reqMemScoreAndAllScore()
	self.fields.Com_entrance:initData()
end
function RomanSoulNewPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("common_text_1249")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function RomanSoulNewPanel:onShow()
	print("=======RomanSoulNewPanel:onShow")
end
function RomanSoulNewPanel:onHide()
	print("=======RomanSoulNewPanel:onHide")
end
function RomanSoulNewPanel:onDispose()
	print("=======RomanSoulNewPanel:onDispose")
end
return RomanSoulNewPanel
