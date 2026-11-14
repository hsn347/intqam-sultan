local equipmentltCtrl = include("equipmentltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local equipOverduePreViewPanel = class("equipOverduePreViewPanel", baseFguiPanel)
function equipOverduePreViewPanel:ctor(...)
	self.isLRU = true
	equipOverduePreViewPanel.super.ctor(self, ...)
	print("equipOverduePreViewPanel:ctor", self.viewName)
end
function equipOverduePreViewPanel:onInit()
	print("=======equipOverduePreViewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("legend_equip_return_002"))
	self.fields.Label_title:setString(i18n("legend_equip_return_010"))
	self.fields.Text_tip:setString(i18n("legend_equip_return_006"))
	self.fields.Text_name:setString(i18n("legend_equip_return_003"))
	self.fields.Text_lv:setString(i18n("legend_equip_return_004"))
	self.fields.Text_pro:setString(i18n("legend_equip_return_005"))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_name:fixPos()
	self.fields.Text_lv:fixPos()
	self.fields.Text_pro:fixPos()
	self.fields.line1:fixPos()
	self.fields.line2:fixPos()
end
function equipOverduePreViewPanel:onItemRenderer(index, obj)
	local _fields = fguiHelper.get_fields(obj)
	obj:fixChildrenPos()
	_fields.bg:setVisible(index % 2 == 0)
	local cfg = self.showCfg[index + 1]
	_fields.Text_name:setString(i18n(cfg.equipName))
	_ENV = i18n(cfg.equipName)
	i18n(cfg.equipName).lv = cfg.equipLv
	_fields.Text_lv:setString(i18n("common_text_100", i18n(cfg.equipName)))
	_fields.Text_pro:setString(cfg.returnProp .. "%")
end
function equipOverduePreViewPanel:endShow()
	print("=======equipOverduePreViewPanel:endShow")
	self.showCfg = equipmentltCtrl.getLegendEquipReturnShowCfg()
	self.fields.List:setNumItems(#self.showCfg)
	self.fields.List:setScrollEnable(#self.showCfg > 5)
end
return equipOverduePreViewPanel
