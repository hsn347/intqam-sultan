local baseComponent = require("fgui.base.baseComponent")
local Btn_allianceHelp = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_allianceHelp", Btn_allianceHelp)
function Btn_allianceHelp:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_allianceHelp:onShow()
end
function Btn_allianceHelp:setRed(num)
	self.fields.lab_red:setVisible(0 < num)
	self.fields.lab_red:setString(num)
end
function Btn_allianceHelp:onBtnClick()
	SoraDPlaySound()
	local allianceHelp = SoraDGetCtrl("allianceHelp")
	allianceHelp:reqHelpAll()
end
return Btn_allianceHelp
