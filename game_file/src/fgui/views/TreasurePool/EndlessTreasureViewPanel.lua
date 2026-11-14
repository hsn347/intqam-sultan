local endlessTreasureCtrl = SoraDGetCtrl("endlessTreasureCtrl")
local gametop = gModuleMgr.getObject("gametop")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local EndlessTreasureViewPanel = class("EndlessTreasureViewPanel", baseFguiPanel)
function EndlessTreasureViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	self.debug = true
	print("EndlessTreasureViewPanel:ctor", self.viewName)
end
function EndlessTreasureViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function EndlessTreasureViewPanel:onInit()
	print("=======EndlessTreasureViewPanel:onInit")
	self.fields.Com_title:initData(i18n("endless_treasures_text_01"), handler(self, self.onClickClose), handler(self, self.btnHelpClick))
	self.fields.scroll:setVirtual()
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self:initData()
end
function EndlessTreasureViewPanel:onShow()
	print("=======EndlessTreasureViewPanel:onShow")
end
function EndlessTreasureViewPanel:onItemRenderer(index, obj)
	local data = self.boxInfo[index + 1]
	obj:initData(index + 1, data)
end
function EndlessTreasureViewPanel:suitView()
end
function EndlessTreasureViewPanel:initData()
	self.boxInfo = endlessTreasureCtrl:getAllTreasureInfo()
	self.fields.scroll:setNumItems(4)
end
function EndlessTreasureViewPanel:btnHelpClick(button, event)
	SoraDPlaySound()
	_ENV = "common_text_001"
	;("common_text_001")[1] = i18n("endless_treasures_text_04")
	;("common_text_001")[2] = i18n("endless_treasures_text_04")
	SoraDShowFixWindow(i18n("common_text_001"), "common_text_001")
end
return EndlessTreasureViewPanel
