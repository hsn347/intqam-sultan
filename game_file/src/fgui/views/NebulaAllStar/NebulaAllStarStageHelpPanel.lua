local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local nebulaAllStarRead = include("nebulaAllStarRead")
local NEBULA_ALL_STAR_STATE = nebulaAllStarRead.NEBULA_ALL_STAR_STATE
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAllStarStageHelpPanel = class("NebulaAllStarStageHelpPanel", baseFguiPanel)
function NebulaAllStarStageHelpPanel:ctor(...)
	NebulaAllStarStageHelpPanel.super.ctor(self, ...)
	print("NebulaAllStarStageHelpPanel:ctor", self.viewName)
end
function NebulaAllStarStageHelpPanel:onInit()
	print("=======NebulaAllStarStageHelpPanel:onInit")
	self.fields.Panel_bg:setString(i18n("NebulaAllstar_18"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function NebulaAllStarStageHelpPanel:onShow()
	print("=======NebulaAllStarStageHelpPanel:onShow")
	_ENV, _ENV = "=======NebulaAllStarStageHelpPanel:onShow", print
	;("=======NebulaAllStarStageHelpPanel:onShow").title = i18n("NebulaAllstar_19")
	;("=======NebulaAllStarStageHelpPanel:onShow").state1 = NEBULA_ALL_STAR_STATE.BEGIN
	_ENV, print[1], ("=======NebulaAllStarStageHelpPanel:onShow").state2 = "=======NebulaAllStarStageHelpPanel:onShow", "=======NebulaAllStarStageHelpPanel:onShow", NEBULA_ALL_STAR_STATE.ALL_STAR_TEAM
	;("=======NebulaAllStarStageHelpPanel:onShow").title = i18n("NebulaAllstar_20")
	;("=======NebulaAllStarStageHelpPanel:onShow").state1 = NEBULA_ALL_STAR_STATE.BEGIN
	_ENV, print[2], ("=======NebulaAllStarStageHelpPanel:onShow").state2 = "=======NebulaAllStarStageHelpPanel:onShow", "=======NebulaAllStarStageHelpPanel:onShow", NEBULA_ALL_STAR_STATE.BACKUP_GROUP_TEAM
	;("=======NebulaAllStarStageHelpPanel:onShow").title = i18n("NebulaAllstar_21")
	;("=======NebulaAllStarStageHelpPanel:onShow").state1 = NEBULA_ALL_STAR_STATE.ENTER_ROOM
	_ENV, print[3], ("=======NebulaAllStarStageHelpPanel:onShow").state2 = "=======NebulaAllStarStageHelpPanel:onShow", "=======NebulaAllStarStageHelpPanel:onShow", NEBULA_ALL_STAR_STATE.BATTLE
	;("=======NebulaAllStarStageHelpPanel:onShow").title = i18n("NebulaAllstar_22")
	;("=======NebulaAllStarStageHelpPanel:onShow").state1 = NEBULA_ALL_STAR_STATE.BATTLE
	_ENV, print[4], ("=======NebulaAllStarStageHelpPanel:onShow").state2 = "=======NebulaAllStarStageHelpPanel:onShow", "=======NebulaAllStarStageHelpPanel:onShow", NEBULA_ALL_STAR_STATE.SETTLE
	;("=======NebulaAllStarStageHelpPanel:onShow").title = i18n("NebulaAllstar_23")
	;("=======NebulaAllStarStageHelpPanel:onShow").state1 = NEBULA_ALL_STAR_STATE.SETTLE
	print[5], ("=======NebulaAllStarStageHelpPanel:onShow").state2 = "=======NebulaAllStarStageHelpPanel:onShow", NEBULA_ALL_STAR_STATE.FINISH
	local config = print
	for __, cfg in ipairs(config) do
		local time1 = nebulaAllStarCtrl:getStateBeginTime(cfg.state1)
		time1 = os.date("!%Y-%m-%d %H:%M:%S", time1)
		local time2 = nebulaAllStarCtrl:getStateBeginTime(cfg.state2)
		time2 = os.date("!%Y-%m-%d %H:%M:%S", time2)
		cfg.timeStr = string.format("UTC+0 %s - UTC+0 %s", time1, time2)
	end
	self.config = config
	self.fields.List:setNumItems(#self.config)
end
function NebulaAllStarStageHelpPanel:onItemRederer(index, obj)
	local cfg = self.config[index + 1]
	local _fields = fguiHelper.get_fields(obj)
	_fields.Image_bg:setVisible(index % 2 ~= 0)
	_fields.Text_title:setString(cfg.title)
	_fields.Text_time:setString(cfg.timeStr)
end
return NebulaAllStarStageHelpPanel
