local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local artifactRuneRead = include("artifactRuneRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RuneQuickSetPanel = class("RuneQuickSetPanel", baseFguiPanel)
function RuneQuickSetPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RuneQuickSetPanel:ctor", self.viewName)
end
function RuneQuickSetPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RuneQuickSetPanel:onInit()
	print("=======RuneQuickSetPanel:onInit")
	_ENV = nil
	;(nil).name = godArmsRuneCtrl:getArmGroupName(self.param.data.weaponID, self.param.group)
	self.fields.Panel_bg:setString(i18n("Weapon_Rune_tips_082", nil))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function RuneQuickSetPanel:onShow()
	print("=======RuneQuickSetPanel:onShow")
	local cfgList = godArmsRuneCtrl:getArmGroupList(self.param.data.weaponID)
	self.setList, _ENV = godArmsRuneCtrl, godArmsRuneCtrl
	for k, v in ipairs(cfgList) do
		if 1 < k and self.param.group ~= k then
			table.insert(self.setList, k)
		end
	end
	self.fields.List:setNumItems(#self.setList)
end
function RuneQuickSetPanel:onItemRenderer(index, obj)
	obj:initData(self.setList[index + 1], self.param.data.weaponID, self.param.group, self)
end
return RuneQuickSetPanel
