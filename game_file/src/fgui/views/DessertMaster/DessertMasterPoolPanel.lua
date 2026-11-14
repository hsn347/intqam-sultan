local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DessertMasterPoolPanel = class("DessertMasterPoolPanel", baseFguiPanel)
function DessertMasterPoolPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function DessertMasterPoolPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CoffeeCraftsman"
	end
	return self._packageList
end
function DessertMasterPoolPanel:onInit()
	self.fields.List_pool:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.Panel_normal:setString(i18n("coffeeCraftsman_text_30"))
	self.fields.Text_tip:setString(i18n("coffeeCraftsman_text_31"))
end
function DessertMasterPoolPanel:onItemRederer(index, obj)
	obj:initData(index + 1)
end
function DessertMasterPoolPanel:onShow()
	self:updateView()
end
function DessertMasterPoolPanel:updateView()
	self.fields.List_pool:setNumItems(4)
end
return DessertMasterPoolPanel
