local payBackCtrl = SoraDGetCtrl("payBackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BackMoneyListPanel = class("BackMoneyListPanel", baseFguiPanel)
function BackMoneyListPanel:ctor(...)
	self.super.ctor(self, ...)
	print("BackMoneyListPanel:ctor", self.viewName)
end
function BackMoneyListPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "BackMoney"
	end
	return self._packageList
end
function BackMoneyListPanel:onInit()
	print("=======BackMoneyListPanel:onInit")
	self.fields.bg:setTitle(i18n("PayBack_Text_07"))
	self.fields.Text_sure:setString(i18n("PayBack_Text_15"))
	self.fields.Check_tick:setSelected(true)
	self.fields.Check_tick:addClickListener(function()
		SoraDPlaySound()
		self.fields.List:setNumItems(#self.itemList)
	end)
	self.fields.Text_tip:setString(i18n("PayBack_Text_16"))
end
function BackMoneyListPanel:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1], self.fields.Check_tick:isSelected())
end
function BackMoneyListPanel:onShow()
	print("=======BackMoneyListPanel:onShow")
	self.itemList = payBackCtrl:getBackGiftList()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setNumItems(#self.itemList)
	_ENV = handler(self, self.onItemRenderer)
	handler(self, self.onItemRenderer).num = fguiHelper.getColorString("#FFC864", "$" .. payBackCtrl:getPrice())
	self.fields.Text_needPay:setString(i18n("PayBack_Text_04", handler(self, self.onItemRenderer)))
	_ENV = i18n("PayBack_Text_04", handler(self, self.onItemRenderer))
	i18n("PayBack_Text_04", handler(self, self.onItemRenderer)).num = fguiHelper.getColorString("#FFC864", "$" .. payBackCtrl:getTotalPrice())
	self.fields.Text_payed:setString(i18n("PayBack_Text_18", i18n("PayBack_Text_04", handler(self, self.onItemRenderer))))
end
function BackMoneyListPanel:onHide()
	print("=======BackMoneyListPanel:onHide")
end
function BackMoneyListPanel:onDispose()
	print("=======BackMoneyListPanel:onDispose")
end
return BackMoneyListPanel
