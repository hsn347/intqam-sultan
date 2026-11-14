local baseFguiPanel = require("fgui.base.baseFguiPanel")
local commonSpeedUpTypeViewPanel = class("commonSpeedUpTypeViewPanel", baseFguiPanel)
function commonSpeedUpTypeViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("commonSpeedUpTypeViewPanel:ctor", self.viewName)
end
function commonSpeedUpTypeViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function commonSpeedUpTypeViewPanel:onInit()
	self.view:fixChildrenPos()
	print("=======commonSpeedUpTypeViewPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("common_text_713"))
	self.fields.Text_sp:setString(i18n("accelerate_text_002"))
	self.fields.Text_bst:setString(i18n("accelerate_text_003"))
	self.fields.Button_chooseSp:addClickEventListener(handler(self, self.btnSpClick))
	self.fields.Button_chooseBst:addClickEventListener(handler(self, self.btnBstClick))
	self.fields.Button_ok:setTitle(i18n("common_text_204"))
	self.fields.Button_ok:addClickEventListener(handler(self, self.btnOkClick))
	_ENV = handler(self, self.btnOkClick)
	handler(self, self.btnOkClick).byUID = true
	self.chooseType = SoraDConfigGet("Game:commonSpeedUp:choose~integer", handler(self, self.btnOkClick)) or 1
	self:updateChooseType()
end
function commonSpeedUpTypeViewPanel:onShow()
	print("=======commonSpeedUpTypeViewPanel:onShow")
end
function commonSpeedUpTypeViewPanel:updateChooseType()
	self.fields.Button_chooseSp:setSelected(self.chooseType == 1)
	self.fields.Button_chooseBst:setSelected(self.chooseType == 2)
end
function commonSpeedUpTypeViewPanel:btnSpClick(button, event)
	SoraDPlaySound()
	self.chooseType = 1
	self:updateChooseType()
end
function commonSpeedUpTypeViewPanel:btnBstClick(button, event)
	SoraDPlaySound()
	self.chooseType = 2
	self:updateChooseType()
end
function commonSpeedUpTypeViewPanel:btnOkClick(button, event)
	SoraDPlaySound()
	self:close()
end
function commonSpeedUpTypeViewPanel:onHide()
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:commonSpeedUp:choose~integer", self.chooseType, nil)
	_ENV = "Game:commonSpeedUp:choose~integer"
	;("Game:commonSpeedUp:choose~integer").msg = "MESSAGE_ITEM_SPEED_UP_TYPE_CHOOSE"
	SoraDSendMessage("Game:commonSpeedUp:choose~integer")
end
return commonSpeedUpTypeViewPanel
