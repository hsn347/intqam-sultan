local ramadanAccuRechargeltCtrl = include("ramadanAccuRechargeltCtrl")
local ramadanAccuRechargeCtrl = SoraDGetCtrl("ramadanAccuRechargeCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RamadanAccuDetailPanel = class("RamadanAccuDetailPanel", baseFguiPanel)
function RamadanAccuDetailPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("RamadanAccuDetailPanel:ctor", self.viewName)
end
function RamadanAccuDetailPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RamadanAccuDetailPanel:onInit()
	self.fields.Text_point:fixPos()
	self.fields.Text_cost:fixPos()
	print("=======RamadanAccuDetailPanel:onInit")
	self.fields.Panel_bg:setString(i18n("accumulated_text03"))
	self.fields.Text_cost:setString(i18n("accumulated_text05"))
	self.fields.Text_point:setString(i18n("common_text_3156"))
	self.fields.Text_tip:setString(i18n("accumulated_text02"))
	self.classtype = ramadanAccuRechargeCtrl:getClassType()
	self.rechargeInfo = ramadanAccuRechargeltCtrl.getRechargeInfoDataByClassType(self.classtype)
	self.fields.List_detail:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_detail:setNumItems(table.nums(self.rechargeInfo))
end
function RamadanAccuDetailPanel:onItemRenderer(index, obj)
	obj:initData(index + 1, self.rechargeInfo[index + 1].activityPoint[1] .. "", paymentManager.getRealPrice(nil, self.rechargeInfo[index + 1].rechargePoint) .. "")
end
function RamadanAccuDetailPanel:onShow()
	print("=======RamadanAccuDetailPanel:onShow")
end
function RamadanAccuDetailPanel:onHide()
	print("=======RamadanAccuDetailPanel:onHide")
end
function RamadanAccuDetailPanel:onDispose()
	print("=======RamadanAccuDetailPanel:onDispose")
end
return RamadanAccuDetailPanel
