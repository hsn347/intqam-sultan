local legendTeamDef = include("legendTeamDef")
local legendTeamCtrl = SoraDGetCtrl("legendTeamCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local legendaryKingCommanderPanel = class("legendaryKingCommanderPanel", baseFguiPanel)
function legendaryKingCommanderPanel:ctor(...)
	legendaryKingCommanderPanel.super.ctor(self, ...)
	print("legendaryKingCommanderPanel:ctor", self.viewName)
end
function legendaryKingCommanderPanel:onInit()
	print("=======legendaryKingCommanderPanel:onInit")
	self.commanders, _ENV = print, print
	self.fields.Text_tip:setString(i18n("legendary_commander_text8"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function legendaryKingCommanderPanel:onItemRenderer(index, obj)
	local uid = self.commanders[index + 1] and self.commanders[index + 1].uid
	obj:initData(uid)
end
function legendaryKingCommanderPanel:onShow()
	print("=======legendaryKingCommanderPanel:onShow")
	self:initView()
end
function legendaryKingCommanderPanel:initView()
	self.commanders, legendTeamCtrl = nil, nil
	local commanders = legendTeamCtrl:getCommanders()
	for k, v in pairs(commanders) do
		legendTeamCtrl = nil
		;(nil).uid = tonumber(k)
		table.insert(self.commanders, nil)
	end
	table.sort(self.commanders, function(a, b)
		return a.uid < b.uid
	end)
	local maxCommanders = legendTeamDef.APPLY_TEAM_COMMANDERS_MAX
	legendTeamCtrl = table.insert
	table.insert.var1 = legendTeamCtrl:getCommanderCount()
	table.insert.var2 = maxCommanders
	self.fields.Panel_bg:setString(i18n("legendary_commander_text2", table.insert))
	self.fields.List:setNumItems(maxCommanders)
	self.fields.List:setScrollEnable(maxCommanders * 105 > self.fields.List:getHeight())
end
return legendaryKingCommanderPanel
