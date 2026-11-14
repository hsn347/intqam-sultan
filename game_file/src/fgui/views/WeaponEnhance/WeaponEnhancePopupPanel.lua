local equipmentltCtrl = include("equipmentltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WeaponEnhancePopupPanel = class("WeaponEnhancePopupPanel", baseFguiPanel)
function WeaponEnhancePopupPanel:ctor(...)
	self.super.ctor(self, ...)
	print("WeaponEnhancePopupPanel:ctor", self.viewName)
end
function WeaponEnhancePopupPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function WeaponEnhancePopupPanel:onInit()
	print("=======WeaponEnhancePopupPanel:onInit")
	_ENV = print
	print[gQualityDef.LEGEND] = i18n("equipment_training_text_07")
	print[gQualityDef.NEBULA] = i18n("common_text_4621")
	self.titleCfg, print[gQualityDef.ORANGE] = print, i18n("equipment_training_text_06")
	self.fields.Panel_bg:setString(i18n("strengthen_resonance_5"))
	_ENV = i18n("strengthen_resonance_5")
	i18n("strengthen_resonance_5").lv = self.param.lv
	i18n("strengthen_resonance_5").name = self.titleCfg[self.param.quality]
	self.fields.Text_tip:setString(i18n("strengthen_resonance_6", i18n("strengthen_resonance_5")))
	self.fields.Text_lv:setString(i18n("strengthen_resonance_7"))
	self.fields.Text_attr:setString(i18n("strengthen_resonance_8"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_lv:fixPos()
	self.fields.Text_attr:fixPos()
	self.fields.n11:fixPos()
end
function WeaponEnhancePopupPanel:onItemRenderer(index, obj)
	local sumLv
	for k, v in ipairs(self.data) do
		if v.sumLv <= self.param.slv then
			sumLv = v.sumLv
		end
	end
	obj:initData(self.data[index + 1], index + 1, sumLv)
end
function WeaponEnhancePopupPanel:onShow()
	print("=======WeaponEnhancePopupPanel:onShow")
	self.data = equipmentltCtrl.getResonanceCfg(self.param.quality, self.param.lv)
	self.fields.List:setNumItems(#self.data)
end
return WeaponEnhancePopupPanel
