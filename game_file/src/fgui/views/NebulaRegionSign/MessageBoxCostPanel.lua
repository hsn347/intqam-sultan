local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MessageBoxCostPanel = class("MessageBoxCostPanel", baseFguiPanel)
function MessageBoxCostPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MessageBoxCostPanel:ctor", self.viewName)
end
function MessageBoxCostPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MessageBoxCostPanel:onInit()
	print("=======MessageBoxCostPanel:onInit")
	self.fields.Button_cost:addClickListener(handler(self, self.onBtnClick))
end
function MessageBoxCostPanel:onShow()
	print("=======MessageBoxCostPanel:onShow")
	local param = self.proxy.param
	self.fields.Text_content:setString(i18n(param.content))
	self.fields.Button_cost:setTitleText(i18n(param.btnTitle))
	self.fields.Button_cost:setCostNum(param.num, param.haveGold)
	self.callBackFunc = param.btnHandle
end
function MessageBoxCostPanel:onBtnClick()
	SoraDPlaySound()
	self.callBackFunc()
	self:removeFromParent()
end
return MessageBoxCostPanel
