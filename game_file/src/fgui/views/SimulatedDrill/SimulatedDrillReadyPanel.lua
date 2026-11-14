local worldMapWarDef = include("worldMapWarDef")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SimulatedDrillReadyPanel = class("SimulatedDrillReadyPanel", baseFguiPanel)
function SimulatedDrillReadyPanel:ctor(...)
	SimulatedDrillReadyPanel.super.ctor(self, ...)
	print("SimulatedDrillReadyPanel:ctor", self.viewName)
	self.isCantCloseByReturn = true
end
function SimulatedDrillReadyPanel:onInit()
	print("=======SimulatedDrillReadyPanel:onInit")
	self.fields.Text_camp1:setString(i18n("simulated_drill_title_02"))
	self.fields.Text_camp2:setString(i18n("simulated_drill_title_03"))
	local strTips = worldMapWarDef.getKingdomClassTips(gKingdomClassType.simulatedDrill)
	self.fields.Text_waiting:setString(strTips)
	self.fields.mv_vs:setAllFrameName("dh_wangguozfz_%02d.png", 1)
end
function SimulatedDrillReadyPanel:endShow()
	print("=======SimulatedDrillReadyPanel:endShow")
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(10)
	;(nil)[2] = ffa.callFunc(function()
		self:close()
	end)
	;(nil)[3] = ffa.callFunc(function()
		self:close()
	end)
	self.view:runAction(ffa.seq(nil))
end
return SimulatedDrillReadyPanel
