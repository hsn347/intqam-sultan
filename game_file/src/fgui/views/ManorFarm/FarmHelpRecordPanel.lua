local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local FarmHelpRecordPanel = class("FarmHelpRecordPanel", baseFguiPanel)
function FarmHelpRecordPanel:ctor(...)
	self.isLRU = true
	FarmHelpRecordPanel.super.ctor(self, ...)
	print("FarmHelpRecordPanel:ctor", self.viewName)
end
function FarmHelpRecordPanel:onInit()
	print("=======FarmHelpRecordPanel:onInit")
	self.fields.txtTip:setString(i18n("Socialize_text_09"))
	self.fields.list:setVirtual()
	self.fields.list:setItemRenderer(handler(self, self.itemRenderer_list))
	self.fields.Panel_bg1:setString(i18n("Socialize_text_07"))
	self.fields.txtEmpty:setVisible(false)
	self.fields.txtEmpty:setString(i18n("Socialize_text_50"))
end
function FarmHelpRecordPanel:endShow()
	print("=======FarmHelpRecordPanel:endShow")
	self:initData()
end
function FarmHelpRecordPanel:itemRenderer_list(index, obj)
	local data = self.data[index + 1]
	obj:initData(data)
end
function FarmHelpRecordPanel:initData()
	self.data = manorCityCtrl:getFarmHelpRecord()
	self.fields.list:setNumItems(#self.data)
	self.fields.txtEmpty:setVisible(#self.data == 0)
end
return FarmHelpRecordPanel
