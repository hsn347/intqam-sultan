local baseFguiPanel = require("fgui.base.baseFguiPanel")
local EliminateGamePreviewPanel = class("EliminateGamePreviewPanel", baseFguiPanel)
function EliminateGamePreviewPanel:ctor(...)
	EliminateGamePreviewPanel.super.ctor(self, ...)
	self.debug = true
	print("EliminateGamePreviewPanel:ctor", self.viewName)
end
function EliminateGamePreviewPanel:onInit()
	print("=======EliminateGamePreviewPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("devilvalley_text_27"))
	self.fields.list:setVirtual()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
end
function EliminateGamePreviewPanel:onShow()
	print("=======EliminateGamePreviewPanel:onShow")
	self:updateView()
end
function EliminateGamePreviewPanel:updateView()
	self.curLevel = self.param.level
	self.levelCfgs = self.param.levelCfgs
	self.fields.list:setNumItems(#self.levelCfgs)
	local scrollTo = self.curLevel > #self.levelCfgs and #self.levelCfgs - 1 or self.curLevel - 1
	self.fields.list:scrollToView(scrollTo)
end
function EliminateGamePreviewPanel:onItemRenderer(index, object)
	object:initData(self.levelCfgs[index + 1], index, self.curLevel)
end
return EliminateGamePreviewPanel
