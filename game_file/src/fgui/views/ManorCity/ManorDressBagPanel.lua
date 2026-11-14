local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ManorDressBagPanel = class("ManorDressBagPanel", baseFguiPanel)
function ManorDressBagPanel:ctor(...)
	self.isLRU = true
	ManorDressBagPanel.super.ctor(self, ...)
	print("ManorDressBagPanel:ctor", self.viewName)
end
function ManorDressBagPanel:onInit()
	print("=======ManorDressBagPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Panel_bg:setString(i18n("garden_btn_06"))
	self.fields.Lab_noData:setString(i18n("decoration_text_32"))
end
function ManorDressBagPanel:endShow()
	print("=======ManorDressBagPanel:endShow")
	self.backpackData = manorCityCtrl:getBackpackData()
	self.fields.List:setNumItems(#self.backpackData)
	self.fields.Lab_noData:setVisible(#self.backpackData == 0)
end
function ManorDressBagPanel:itemRenderer_List(index, obj)
	local data = self.backpackData[index + 1]
	obj:initData(data.id, data.count)
end
return ManorDressBagPanel
