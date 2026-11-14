local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local nebulaAllStarRead = include("nebulaAllStarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAllStarHospitalHelpPanel = class("NebulaAllStarHospitalHelpPanel", baseFguiPanel)
function NebulaAllStarHospitalHelpPanel:ctor(...)
	NebulaAllStarHospitalHelpPanel.super.ctor(self, ...)
	print("NebulaAllStarHospitalHelpPanel:ctor", self.viewName)
end
function NebulaAllStarHospitalHelpPanel:onInit()
	print("=======NebulaAllStarHospitalHelpPanel:onInit")
	local total = nebulaAllStarRead.getFreeSoldierNum()
	_ENV = nil
	;(nil).num = ""
	self.fields.Text_total:setString(i18n("NebulaAllstar_141", nil))
	self.fields.Text_total2:setString(string.formatnumberthousands(total))
	_ENV = string.formatnumberthousands(total)
	string.formatnumberthousands(total).num = ""
	self.fields.Text_in:setString(i18n("NebulaAllstar_142", string.formatnumberthousands(total)))
	_ENV = i18n("NebulaAllstar_142", string.formatnumberthousands(total))
	i18n("NebulaAllstar_142", string.formatnumberthousands(total)).num = ""
	self.fields.Text_out:setString(i18n("NebulaAllstar_143", i18n("NebulaAllstar_142", string.formatnumberthousands(total))))
	_ENV = i18n("NebulaAllstar_143", i18n("NebulaAllstar_142", string.formatnumberthousands(total)))
	i18n("NebulaAllstar_143", i18n("NebulaAllstar_142", string.formatnumberthousands(total))).num = ""
	self.fields.Text_cure:setString(i18n("NebulaAllstar_144", i18n("NebulaAllstar_143", i18n("NebulaAllstar_142", string.formatnumberthousands(total)))))
	if not SoraDFIsRA() then
		self.view:fixChildrenPos()
	end
end
function NebulaAllStarHospitalHelpPanel:onShow()
	print("=======NebulaAllStarHospitalHelpPanel:onShow")
	self:updateTotalArmy()
	self:updateCureArmy()
end
function NebulaAllStarHospitalHelpPanel:updateTotalArmy(...)
	local totalArmy = nebulaAllStarCtrl:getTotalArmy()
	local woundedArmy = nebulaAllStarCtrl:getWoundedArmy()
	local total = nebulaAllStarRead.getFreeSoldierNum()
	local outArmy = math.max(0, total - totalArmy - woundedArmy)
	self.fields.Text_in2:setString(string.formatnumberthousands(totalArmy))
	self.fields.Text_out2:setString(string.formatnumberthousands(outArmy))
end
function NebulaAllStarHospitalHelpPanel:updateCureArmy(...)
	local woundedArmy = nebulaAllStarCtrl:getWoundedArmy()
	self.fields.Text_cure2:setString(string.formatnumberthousands(woundedArmy))
end
return NebulaAllStarHospitalHelpPanel
