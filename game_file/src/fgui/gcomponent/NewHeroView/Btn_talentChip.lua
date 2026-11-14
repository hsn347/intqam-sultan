local baseComponent = require("fgui.base.baseComponent")
local Btn_talentChip = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NewHeroView/Btn_talentChip", Btn_talentChip)
function Btn_talentChip:onInit()
end
function Btn_talentChip:onShow()
end
function Btn_talentChip:getBtnChip()
	return self.fields.Btn_chip
end
return Btn_talentChip
