local baseComponent = require("fgui.base.baseComponent")
local Com_warBarrageSetting = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Com_warBarrageSetting", Com_warBarrageSetting)
function Com_warBarrageSetting:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Com_warBarrageSetting:onShow()
	self.fields.title:setString(i18n("NebulaAllstar_195"))
	fguiHelper.setTextHeight(self.fields.title, 43)
end
function Com_warBarrageSetting:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).mapClassType = SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	uiManager:show("kingdomBattleWarSetting", nil)
end
return Com_warBarrageSetting
