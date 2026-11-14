local baseFguiPanel = require("fgui.base.baseFguiPanel")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local NebulaMileStoneUnlockPanel = class("NebulaMileStoneUnlockPanel", baseFguiPanel)
local nebulaMileStoneRead = include("nebulaMileStoneRead")
local heroltCtrl = include("heroltCtrl")
function NebulaMileStoneUnlockPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("NebulaMileStoneUnlockPanel:ctor", self.viewName)
end
function NebulaMileStoneUnlockPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaMileStoneUnlockPanel:onInit()
	print("=======NebulaMileStoneUnlockPanel:onInit")
	local season = nebulaActivityCtrl:getCurSeason()
	_ENV = nil
	;(nil).num = season
	self.fields.Panel_bg:setTitle(i18n("nebula_milestone_function_tips_001", nil))
	self.configs = nebulaMileStoneRead.getFuncDeses()
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	dump(self.configs, "self.configs")
	self.fields.scroll:setNumItems(table.nums(self.configs))
	if table.nums(self.configs) <= 0 then
		self.fields.text_tip:setVisible(true)
		self.fields.text_tip:setString(i18n("nebula_milestone_function_tips_002"))
	else
		self.fields.text_tip:setVisible(false)
	end
end
function NebulaMileStoneUnlockPanel:onShow()
	print("=======NebulaMileStoneUnlockPanel:onShow")
end
function NebulaMileStoneUnlockPanel:onItemRenderer(index, obj)
	if not SoraDFIsRA() then
		obj:fixChildrenPos(false, true)
	end
	local tmpIdx = 0
	for k, v in pairs(self.configs) do
		if tmpIdx == index then
			local config = v
			obj:setTitle(heroltCtrl:getTacticsDesc(config.functionDes))
			obj:setIcon(config.functionIcon)
			return
		end
		tmpIdx = tmpIdx + 1
	end
end
return NebulaMileStoneUnlockPanel
