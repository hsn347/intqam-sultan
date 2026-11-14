local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAllStarReadyPanel = class("NebulaAllStarReadyPanel", baseFguiPanel)
function NebulaAllStarReadyPanel:ctor(...)
	NebulaAllStarReadyPanel.super.ctor(self, ...)
	print("NebulaAllStarReadyPanel:ctor", self.viewName)
	self.isCantCloseByReturn = true
end
function NebulaAllStarReadyPanel:onInit()
	print("=======NebulaAllStarReadyPanel:onInit")
end
function NebulaAllStarReadyPanel:onShow()
	print("=======NebulaAllStarReadyPanel:onShow")
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(3)
	;(nil)[2] = ffa.callFunc(function()
		self:close()
	end)
	;(nil)[3] = ffa.callFunc(function()
		self:close()
	end)
	self.view:runAction(ffa.seq(nil))
end
return NebulaAllStarReadyPanel
