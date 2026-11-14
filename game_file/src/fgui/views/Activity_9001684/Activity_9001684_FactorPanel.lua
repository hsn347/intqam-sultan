local activity_9001684_Read = include("activity_9001684_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001684_FactorPanel = class("Activity_9001684_FactorPanel", baseFguiPanel)
function Activity_9001684_FactorPanel:ctor(...)
	self.isLRU = true
	Activity_9001684_FactorPanel.super.ctor(self, ...)
	print("Activity_9001684_FactorPanel:ctor", self.viewName)
end
function Activity_9001684_FactorPanel:onInit()
	print("=======Activity_9001684_FactorPanel:onInit")
	self.fields.Panel_bg:setString(i18n("collect_activity_024"))
	self.fields.Text_factor:setString(i18n("collect_activity_026"))
	self.fields.Text_range:setString(i18n("collect_activity_025"))
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
	self.fields.Text_factor:fixPos()
	self.fields.Text_range:fixPos()
	self.fields.line:fixPos()
end
function Activity_9001684_FactorPanel:onListRenderer(index, obj)
	obj:initData(self.list[index + 1], index + 1)
end
function Activity_9001684_FactorPanel:endShow()
	print("=======Activity_9001684_FactorPanel:endShow")
	local list = activity_9001684_Read.getFactorCfg()
	self.list, _ENV = "=======Activity_9001684_FactorPanel:endShow", "=======Activity_9001684_FactorPanel:endShow"
	for k, v in ipairs(list) do
		if k < #list then
			_ENV = nil
			;(nil).interval = v.collectInterval[1] .. "~" .. v.collectInterval[2]
			;(nil).damageFactor = v.damageFactor / 10 .. "%"
			table.insert(self.list, nil)
		else
			_ENV = nil
			;(nil).interval = ">=" .. v.collectInterval[1]
			;(nil).damageFactor = v.damageFactor / 10 .. "%"
			table.insert(self.list, nil)
		end
	end
	self.fields.List:setNumItems(#self.list)
	self.fields.List:setScrollEnable(#self.list > 8)
end
return Activity_9001684_FactorPanel
