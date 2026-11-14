local baseComponent = require("fgui.base.baseComponent")
local BtnHelp = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://ManorCity/BtnHelp", BtnHelp)
function BtnHelp:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
end
function BtnHelp:onShow()
end
function BtnHelp:setRed(num)
	self.fields.lab_red:setVisible(0 < num)
	self.fields.lab_red:setString(num)
end
function BtnHelp:onBtnClick()
	SoraDPlaySound()
	local allianceHelp = SoraDGetCtrl("allianceHelp")
	allianceHelp:reqHelpAll()
end
return BtnHelp
