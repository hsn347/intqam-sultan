local baseComponent = require("fgui.base.baseComponent")
local NebulaKingKingdomItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaCompetition/NebulaKingKingdomItem", NebulaKingKingdomItem)
function NebulaKingKingdomItem:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
end
function NebulaKingKingdomItem:onShow()
end
function NebulaKingKingdomItem:initData(index, kid)
	self.controllers.c1:setSelectedIndex(index % 2)
	self.fields.Text_desc:setString(SoraDGetKingdomName(kid))
end
return NebulaKingKingdomItem
