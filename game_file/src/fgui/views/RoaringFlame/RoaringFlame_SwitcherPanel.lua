local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_SwitcherPanel = class("RoaringFlame_SwitcherPanel", baseFguiPanel)
function RoaringFlame_SwitcherPanel:ctor(...)
	RoaringFlame_SwitcherPanel.super.ctor(self, ...)
	self.debug = true
	print("RoaringFlame_SwitcherPanel:ctor", self.viewName)
end
function RoaringFlame_SwitcherPanel:onInit()
	print("=======RoaringFlame_SwitcherPanel:onInit")
end
function RoaringFlame_SwitcherPanel:endShow()
	print("=======RoaringFlame_SwitcherPanel:endShow")
	self.handler = self.param and self.param.handler
	self.shadow = self.param and self.param.shadow
	if self.shadow then
		self:inShow()
	else
		self.fields.Usm:setCompleteCallback(function()
			if self.handler then
				self.handler()
			end
		end)
		self.fields.Usm:setEffectPath("9001674_Loading_in.usm,9001674_Loading_loop.usm", false, true)
	end
end
function RoaringFlame_SwitcherPanel:inShow()
	self.fields.Usm:clearEffect()
	self.fields.Usm:setEffectPath("9001674_Loading_loop.usm", true, true)
end
function RoaringFlame_SwitcherPanel:outClose()
	self:close()
end
return RoaringFlame_SwitcherPanel
