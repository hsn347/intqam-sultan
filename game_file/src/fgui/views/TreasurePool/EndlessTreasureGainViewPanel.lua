local endlessTreasureRead = include("endlessTreasureRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local EndlessTreasureGainViewPanel = class("EndlessTreasureGainViewPanel", baseFguiPanel)
function EndlessTreasureGainViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("EndlessTreasureGainViewPanel:ctor", self.viewName)
end
function EndlessTreasureGainViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function EndlessTreasureGainViewPanel:onInit()
	self.isCanCloseSelf = false
	if not SoraDFIsRA() then
		self.view:fixChildrenPos()
	end
	print("=======EndlessTreasureGainViewPanel:onInit")
	self.fields.Button_go:setTitle(i18n("common_text_477"))
	self.fields.Button_go:addClickEventListener(handler(self, self.btnGOClick))
	self.fields.Button_ok:setTitle(i18n("common_text_204"))
	self.fields.Button_ok:addClickEventListener(handler(self, self.btnOKClick))
end
function EndlessTreasureGainViewPanel:onShow()
	print("=======EndlessTreasureGainViewPanel:onShow")
end
function EndlessTreasureGainViewPanel:initData(tID)
	_ENV = nil
	;(nil).name = endlessTreasureRead.getTreasureName(tID)
	self.fields.Text_tip:setString(i18n("endless_treasures_text_39", nil))
end
function EndlessTreasureGainViewPanel:btnGOClick(button, event)
	SoraDPlaySound()
	uiManager:show("EndlessTreasureView")
	self:close()
end
function EndlessTreasureGainViewPanel:btnOKClick(button, event)
	SoraDPlaySound()
	self:close()
end
return EndlessTreasureGainViewPanel
