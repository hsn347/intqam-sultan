local baseFguiPanel = require("fgui.base.baseFguiPanel")
local newServerPetCtrl = SoraDGetCtrl("newServerPetCtrl")
local caracalTackPanel = class("caracalTackPanel", baseFguiPanel)
function caracalTackPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isCantCloseByReturn = true
	print("caracalTackPanel:ctor", self.viewName)
end
function caracalTackPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function caracalTackPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	print("=======caracalTackPanel:onInit")
	self.fields.Text_des:setString(i18n("return_lcks_text_001"))
	self.fields.Button_adopt:setTitle(i18n("return_lcks_text_002"))
	self.fields.Button_adopt:addClickListener(handler(self, self.btnAdoptClick))
end
function caracalTackPanel:onShow()
	print("=======caracalTackPanel:onShow")
end
function caracalTackPanel:onHide()
	print("=======caracalTackPanel:onHide")
end
function caracalTackPanel:onDispose()
	print("=======caracalTackPanel:onDispose")
end
function caracalTackPanel:btnAdoptClick()
	SoraDPlaySound()
	SoraDRemoveAllAfterPanelFromManager(self)
	newServerPetCtrl:sendReqAdopt()
end
return caracalTackPanel
