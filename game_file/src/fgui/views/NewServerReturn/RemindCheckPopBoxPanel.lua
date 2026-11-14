local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RemindCheckPopBoxPanel = class("RemindCheckPopBoxPanel", baseFguiPanel)
function RemindCheckPopBoxPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RemindCheckPopBoxPanel:ctor", self.viewName)
end
function RemindCheckPopBoxPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RemindCheckPopBoxPanel:onInit()
	print("=======RemindCheckPopBoxPanel:onInit")
	self.fields.Check_tick:fixPos()
	self.fields.Text_reminder:fixPos()
	self.isClick = false
	self.fields.Button_buy:setTitleText(i18n("common_text_204"))
	self.fields.Button_buy:addClickListener(handler(self, self.onClickBuy))
	self.fields.Check_tick:addClickListener(handler(self, self.onClickReminder))
end
function RemindCheckPopBoxPanel:initData(data)
	dump(data, "RemindCheckPopBoxPanel:initData")
	self.fields.Text_tip:setString(data.Text_tip)
	self.fields.Text_reminder:setString(data.Text_reminder)
	self.btnHandle = data.btnHandle
	self.remindHandle = data.remindHandle
end
function RemindCheckPopBoxPanel:onClickBuy()
	SoraDPlaySound()
	self.btnHandle(self.isClick)
	self:close()
end
function RemindCheckPopBoxPanel:onClickReminder()
	SoraDPlaySound()
	self.isClick = true
end
function RemindCheckPopBoxPanel:onShow()
	print("=======RemindCheckPopBoxPanel:onShow")
	self:initData(self.proxy.param)
end
function RemindCheckPopBoxPanel:onHide()
	print("=======RemindCheckPopBoxPanel:onHide")
end
function RemindCheckPopBoxPanel:onDispose()
	print("=======RemindCheckPopBoxPanel:onDispose")
end
return RemindCheckPopBoxPanel
