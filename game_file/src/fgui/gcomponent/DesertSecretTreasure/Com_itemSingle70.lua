local Com_itemSingle = require("fgui.gcomponent.DesertSecretTreasure.Com_itemSingle")
local baseComponent = require("fgui.base.baseComponent")
local Com_itemSingle70 = fgui.extension_class(fgui.GButton, Com_itemSingle)
fgui.register_extension("ui://DesertSecretTreasure/Com_itemSingle70", Com_itemSingle70)
function Com_itemSingle70:onInit()
	local item = self:getChild("Com_itemSingle")
	self.fields = fguiHelper.get_fields(item)
	self.controllers = fguiHelper.get_controllers(item)
	self.transitions = fguiHelper.get_transitions(item)
	self.super.onInit(self)
end
function Com_itemSingle70:onShow()
end
return Com_itemSingle70
