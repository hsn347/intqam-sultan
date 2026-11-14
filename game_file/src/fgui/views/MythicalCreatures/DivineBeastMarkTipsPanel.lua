local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DivineBeastMarkTipsPanel = class("DivineBeastMarkTipsPanel", baseFguiPanel)
function DivineBeastMarkTipsPanel:ctor(...)
	DivineBeastMarkTipsPanel.super.ctor(self, ...)
	print("DivineBeastMarkTipsPanel:ctor", self.viewName)
end
function DivineBeastMarkTipsPanel:onInit()
	print("=======DivineBeastMarkTipsPanel:onInit")
	self.markId = self.param.id
	self.posY = self.param.y
	self.mark = self.param.mark
end
function DivineBeastMarkTipsPanel:onShow()
	print("=======DivineBeastMarkTipsPanel:onShow")
	self:updateView()
end
function DivineBeastMarkTipsPanel:updateView()
	if self.mark then
		self.fields.Com_MC_MarkDetail:initData(self.mark)
	else
		self.fields.Com_MC_MarkDetail:initDataByMarkId(self.markId)
	end
	dump(self.posY, "self.posY")
	if self.posY <= display.height / 2 then
		self.fields.Com_MC_MarkDetail:setY(display.height / 2 - self.posY - 120)
	else
		self.fields.Com_MC_MarkDetail:setY(display.height / 2 - self.posY + 150)
	end
end
return DivineBeastMarkTipsPanel
