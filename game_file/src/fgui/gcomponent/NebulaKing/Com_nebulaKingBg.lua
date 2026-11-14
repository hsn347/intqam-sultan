local baseComponent = require("fgui.base.baseComponent")
local Com_nebulaKingBg = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaKing/Com_nebulaKingBg", Com_nebulaKingBg)
function Com_nebulaKingBg:onInit()
end
function Com_nebulaKingBg:onShow()
	self.fields.Usm_bg:updateUsmColor(self.fields.Image_bg:getColor())
end
return Com_nebulaKingBg
