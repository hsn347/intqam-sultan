local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarScoreDetailPanel = class("NebulaWarScoreDetailPanel", baseFguiPanel)
function NebulaWarScoreDetailPanel:ctor(...)
	NebulaWarScoreDetailPanel.super.ctor(self, ...)
	print("NebulaWarScoreDetailPanel:ctor", self.viewName)
end
function NebulaWarScoreDetailPanel:onInit()
	print("=======NebulaWarScoreDetailPanel:onInit")
	self.fields.Panel_bg:setString(i18n("atlantiswar_text_0246"))
	self.fields.List:setItemProvider(handler(self, self.onItemProvider))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	_ENV, _ENV = self.fields.List, self.fields.List.setItemRenderer
	self.fields.List.type = 0
	self.fields.List.setItemRenderer[1], self.fields.List.des = self.fields.List, "nebula_war_text_0597"
	local ret = self.fields.List.setItemRenderer
	local config = require_data("nebula_war_kill_des", false, true).data
	for __, v in ipairs(config) do
		table.insert(ret, v)
	end
	self.tabConfigs = ret
	self.fields.List:setNumItems(#self.tabConfigs)
end
function NebulaWarScoreDetailPanel:onShow()
	print("=======NebulaWarScoreDetailPanel:onShow")
end
function NebulaWarScoreDetailPanel:onItemProvider(index)
	local cfg = self.tabConfigs[index + 1]
	if cfg.type == 0 then
		return "ui://NebulaWarNew/NebulaWarScoreDetail_type0"
	elseif cfg.type == 1 then
		return "ui://NebulaWarNew/NebulaWarScoreDetail_type1"
	elseif cfg.type == 2 then
		return "ui://NebulaWarNew/NebulaWarScoreDetail_type2"
	end
end
function NebulaWarScoreDetailPanel:onItemRenderer(index, obj)
	local cfg = self.tabConfigs[index + 1]
	if cfg.type == 0 then
		obj:setString(i18n(cfg.des))
	elseif cfg.type == 1 then
		obj:setString(i18n(cfg.des))
	elseif cfg.type == 2 then
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
		local _fields = fguiHelper.get_fields(obj)
		local _ENV, des = obj, obj
		for k, v in pairs(cfg.des) do
			if type(k) == "string" then
				des[k] = string.formatnumberthousands(v)
			else
				des[k] = v
			end
		end
		_fields.Text_title:setString(i18n(des))
		_fields.Text_value:setString(string.formatnumberthousands(cfg.score))
	end
end
return NebulaWarScoreDetailPanel
