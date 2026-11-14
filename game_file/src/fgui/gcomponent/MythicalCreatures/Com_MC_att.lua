local baseComponent = require("fgui.base.baseComponent")
local Com_MC_att = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MythicalCreatures/Com_MC_att", Com_MC_att)
function Com_MC_att:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
end
function Com_MC_att:onShow()
end
function Com_MC_att:initData(attData, index)
	self.fields.bg:setVisible(index % 2 ~= 0)
	self.fields.title:setString(attData.title)
	self.fields.value:setString(attData.value)
end
return Com_MC_att
