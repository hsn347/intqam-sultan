local artifactRuneRead = include("artifactRuneRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RuneChooseItemPanel = class("RuneChooseItemPanel", baseFguiPanel)
function RuneChooseItemPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RuneChooseItemPanel:ctor", self.viewName)
end
function RuneChooseItemPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RuneChooseItemPanel:onInit()
	print("=======RuneChooseItemPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("quick_use_01"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function RuneChooseItemPanel:onShow()
	print("=======RuneChooseItemPanel:onShow")
	if not artifactRuneRead.getRuneSkip(self.param.holeType) then
		local _ENV, cfg = artifactRuneRead.getRuneSkip(self.param.holeType), artifactRuneRead.getRuneSkip(self.param.holeType)
	end
	self.itemsChoose, _ENV = self.param.holeType, self.param.holeType
	for k, v in ipairs(cfg) do
		_ENV = nil
		;(nil).id = v
		;(nil).count = backpackCtrl:getItemCount(v)
		table.insert(self.itemsChoose, nil)
	end
	self.fields.List:setNumItems(#self.itemsChoose)
end
function RuneChooseItemPanel:onItemRenderer(index, obj)
	obj:initData(self.itemsChoose[index + 1], self)
end
return RuneChooseItemPanel
