local baseComponent = require("fgui.base.baseComponent")
local Com_MC_illusionSingle2 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MythicalCreatures/Com_MC_illusionSingle2", Com_MC_illusionSingle2)
function Com_MC_illusionSingle2:onInit()
	self:fixChildrenPos()
	for i = 1, 4 do
		self.fields["item" .. i]:addClickEventListener(handler(self, self.onClickEvent), i)
	end
end
function Com_MC_illusionSingle2:onShow()
end
function Com_MC_illusionSingle2:initData(markCfgs, index)
	self.markCfgs = markCfgs
	self.index = index
	for i = 1, 4 do
		local mark = markCfgs[index * 4 + i]
		self.fields["item" .. i]:setVisible(mark ~= nil)
		if mark ~= nil then
			self.fields["item" .. i]:setTitle(i18n(mark.name))
			self.fields["item" .. i]:setIcon(mark.icon)
		end
	end
end
function Com_MC_illusionSingle2:onClickEvent(sender, index)
	SoraDPlaySound()
	if self.markCfgs[self.index * 4 + index] ~= nil then
		_ENV = nil
		;(nil).markCfg = self.markCfgs[self.index * 4 + index]
		uiManager:show("DivineBeastMarkIllusionDetail", nil)
	end
end
return Com_MC_illusionSingle2
