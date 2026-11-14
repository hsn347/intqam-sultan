local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DivineBeastMarkSuitPanel = class("DivineBeastMarkSuitPanel", baseFguiPanel)
function DivineBeastMarkSuitPanel:ctor(...)
	self.isLRU = true
	DivineBeastMarkSuitPanel.super.ctor(self, ...)
	print("DivineBeastMarkSuitPanel:ctor", self.viewName)
end
function DivineBeastMarkSuitPanel:onInit()
	print("=======DivineBeastMarkSuitPanel:onInit")
	self.fields.Com_title:initData(i18n("divine_beast_mark_suit_02"), handler(self, self.onClickClose))
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
end
function DivineBeastMarkSuitPanel:endShow()
	print("=======DivineBeastMarkSuitPanel:endShow")
	self.beastId = self.param.beastId
	self:updateView()
end
function DivineBeastMarkSuitPanel:updateView()
	self.fields.list:setNumItems(2)
end
function DivineBeastMarkSuitPanel:onItemRenderer(index, obj)
	obj:initData(self.beastId, 4 - index)
end
return DivineBeastMarkSuitPanel
