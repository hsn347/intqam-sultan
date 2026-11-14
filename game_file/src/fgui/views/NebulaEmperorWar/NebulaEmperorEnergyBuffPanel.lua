local nebulaEmperorRead = include("nebulaEmperorRead")
local nebulaAllStarRead = include("nebulaAllStarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaEmperorEnergyBuffPanel = class("NebulaEmperorEnergyBuffPanel", baseFguiPanel)
function NebulaEmperorEnergyBuffPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaEmperorEnergyBuffPanel:ctor", self.viewName)
end
function NebulaEmperorEnergyBuffPanel:onInit()
	print("=======NebulaEmperorEnergyBuffPanel:onInit")
	local buffID = self.proxy.param.buffID
	local activityID = self.proxy.param.activityID
	local _ENV, cfg
	if activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		cfg = nebulaAllStarRead.getEnergyBuffConfig(buffID)
	else
		cfg = nebulaEmperorRead.getEnergyBuffConfig(buffID)
	end
	self.fields.title:setString(i18n(cfg.name))
	self.fields.icon:setURL(cfg.icon)
	self.fields.Text_des:setString(i18n(cfg.text))
	_ENV = i18n(cfg.text)
	i18n(cfg.text).num = math.floor(cfg.sustainTime[1] / 60)
	self.fields.Text_tip:setString(i18n("nebulaemperor_text_113", i18n(cfg.text)))
end
function NebulaEmperorEnergyBuffPanel:onShow()
	print("=======NebulaEmperorEnergyBuffPanel:onShow")
end
return NebulaEmperorEnergyBuffPanel
