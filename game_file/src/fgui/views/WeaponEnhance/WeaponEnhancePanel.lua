local equipmentMgr = include("equipmentMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WeaponEnhancePanel = class("WeaponEnhancePanel", baseFguiPanel)
function WeaponEnhancePanel:ctor(...)
	self.super.ctor(self, ...)
	print("WeaponEnhancePanel:ctor", self.viewName)
end
function WeaponEnhancePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function WeaponEnhancePanel:onInit()
	print("=======WeaponEnhancePanel:onInit")
	self.fields.Panel_bg:setString(i18n("strengthen_resonance_1"))
	self.fields.Text_tip:setString(i18n("strengthen_resonance_2"))
	self.fields.Btn_go:setString(i18n("strengthen_resonance_9"))
	self.fields.Btn_go:addClickListener(handler(self, self.onBtnGoClick))
end
function WeaponEnhancePanel:onShow()
	print("=======WeaponEnhancePanel:onShow")
	local ret, qTable = equipmentMgr.isWearWeaponEnhance()
	local nIndex = table.nums(qTable)
	self.controllers.c1:setSelectedIndex(nIndex - 1)
	self.qualityTb, _ENV, self.data, _ENV = self.controllers.c1.setSelectedIndex, self.controllers.c1.setSelectedIndex, self.controllers.c1.setSelectedIndex, self.controllers.c1.setSelectedIndex
	for quality, v in pairs(qTable) do
		table.insert(self.qualityTb, quality)
		if not self.data[quality] then
			self.data[quality], _ENV = self.qualityTb, self.qualityTb
		end
		for level, slv in pairs(v) do
			_ENV = nil
			;(nil).level = level
			;(nil).slv = slv
			table.insert(self.data[quality], nil)
		end
	end
	table.sort(self.qualityTb, function(a, b)
		return b < a
	end)
	for i = 1, nIndex do
		self.fields["com_" .. i]:initData(self.qualityTb[i], self.data[self.qualityTb[i]])
	end
end
function WeaponEnhancePanel:onBtnGoClick()
	SoraDPlaySound()
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	_ENV = nil
	;(nil).id = 2
	mildGuideManager:starToEquip(nil)
	SoraDRemoveAllPanelFromManager()
end
return WeaponEnhancePanel
