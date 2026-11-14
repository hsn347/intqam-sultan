local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local equipmentltCtrl = include("equipmentltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local equipOverdueGainViewPanel = class("equipOverdueGainViewPanel", baseFguiPanel)
function equipOverdueGainViewPanel:ctor(...)
	self.isLRU = true
	equipOverdueGainViewPanel.super.ctor(self, ...)
	print("equipOverdueGainViewPanel:ctor", self.viewName)
end
function equipOverdueGainViewPanel:onInit()
	print("=======equipOverdueGainViewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("legend_equip_return_001"))
	self.fields.Label_title:setString(i18n("legend_equip_return_008"))
	self.fields.Text_tip:setString(i18n("legend_equip_return_007"))
	self.fields.Button_gain:setString(i18n("summoned_btn_01"))
	self.fields.Button_gain:addClickListener(handler(self, self.btnGainClick))
	self.fields.List_equip:setItemRenderer(handler(self, self.onEquipRenderer))
	self.fields.List_item:setItemRenderer(handler(self, self.onItemRenderer))
end
function equipOverdueGainViewPanel:onEquipRenderer(index, obj)
	obj:initDataEX(self.equipList[index + 1])
end
function equipOverdueGainViewPanel:onItemRenderer(index, obj)
	obj:initData(self.backList[index + 1].id, self.backList[index + 1].count)
end
function equipOverdueGainViewPanel:endShow()
