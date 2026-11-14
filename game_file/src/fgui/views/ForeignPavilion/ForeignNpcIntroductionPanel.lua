local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ForeignNpcIntroductionPanel = class("ForeignNpcIntroductionPanel", baseFguiPanel)
function ForeignNpcIntroductionPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ForeignNpcIntroductionPanel:ctor", self.viewName)
end
function ForeignNpcIntroductionPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ForeignPavilion"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function ForeignNpcIntroductionPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	print("=======ForeignNpcIntroductionPanel:onInit")
	self.fields.name:setString(i18n("exitic_pavillion_text_0046"))
	self.fields.age:setString(i18n("exitic_pavillion_text_0040"))
	self.fields.birth:setString(i18n("exitic_pavillion_text_0041"))
	self.fields.height:setString(i18n("exitic_pavillion_text_0042"))
	self.fields.profession:setString(i18n("exitic_pavillion_text_0043"))
	self.fields.hobby:setString(i18n("exitic_pavillion_text_0044"))
	self.fields.introduction:setString(i18n("exitic_pavillion_text_0045"))
end
function ForeignNpcIntroductionPanel:onShow()
	print("=======ForeignNpcIntroductionPanel:onShow")
end
function ForeignNpcIntroductionPanel:onHide()
	print("=======ForeignNpcIntroductionPanel:onHide")
end
function ForeignNpcIntroductionPanel:onDispose()
	print("=======ForeignNpcIntroductionPanel:onDispose")
end
return ForeignNpcIntroductionPanel
