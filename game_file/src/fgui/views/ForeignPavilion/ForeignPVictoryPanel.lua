local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ForeignPVictoryPanel = class("ForeignPVictoryPanel", baseFguiPanel)
local exoticPavilionCtrl = SoraDGetCtrl("exoticPavilionCtrl")
function ForeignPVictoryPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ForeignPVictoryPanel:ctor", self.viewName)
	self.debug = true
end
function ForeignPVictoryPanel:getPackageList()
	if not self._packageList then
		_UPVALUE6_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ForeignPavilion"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[5] = self._packageList, "CommonUI1"
		self._packageList, self._packageList[6] = self._packageList, "fonts"
	end
	return self._packageList
end
function ForeignPVictoryPanel:onInit()
	self.fields.text:setString(i18n("exitic_pavillion_text_0113"))
	print("=======ForeignPVictoryPanel:onInit")
end
function ForeignPVictoryPanel:onShow()
	print("=======ForeignPVictoryPanel:onShow")
	SoraDPlaySound("elimiateGame", 5)
	self.fields.Usm_1:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	self.fields.Usm_1:setEffectPath(SoraDFIsRA() and "dunpai5.usm" or "dunpai4.usm", false)
end
function ForeignPVictoryPanel:onHide()
	print("=======ForeignPVictoryPanel:onHide")
end
function ForeignPVictoryPanel:onDispose()
	print("=======ForeignPVictoryPanel:onDispose")
end
return ForeignPVictoryPanel
