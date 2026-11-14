local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RomanChallengeSelectPanel = class("RomanChallengeSelectPanel", baseFguiPanel)
function RomanChallengeSelectPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RomanChallengeSelectPanel:ctor", self.viewName)
end
function RomanChallengeSelectPanel:getPackageList()
	if not self._packageList then
		_UPVALUE3_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "RomanSoulNew"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function RomanChallengeSelectPanel:onInit()
	print("=======RomanChallengeSelectPanel:onInit")
	self.fields.Text_title:setString(i18n("common_text_1247"))
	_ENV = i18n("common_text_1247")
	i18n("common_text_1247").color1 = "#FFFAD3"
	i18n("common_text_1247").color2 = "#FFFAD3"
	self.fields.Text_tip:setString(i18n("common_text_1248", i18n("common_text_1247")))
	self.fields.Button_help:addClickListener(handler(self, self.onClickHelp))
	self.fields.Com_challenge:initData()
end
function RomanChallengeSelectPanel:eventArrived()
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	SoraDGotoWorldMapPoint(cityCtrl:getCurCityPos(), false)
	SoraDRemoveAllPrePanelFromManager(self)
end
function RomanChallengeSelectPanel:onClickHelp()
	SoraDPlaySound()
	uiManager:show("RomanPointExplain"):setOwnerKey(self)
end
function RomanChallengeSelectPanel:onShow()
	print("=======RomanChallengeSelectPanel:onShow")
end
function RomanChallengeSelectPanel:onHide()
	print("=======RomanChallengeSelectPanel:onHide")
end
function RomanChallengeSelectPanel:onDispose()
	print("=======RomanChallengeSelectPanel:onDispose")
end
return RomanChallengeSelectPanel
