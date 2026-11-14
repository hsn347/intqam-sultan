local baseComponent = require("fgui.base.baseComponent")
local Button_SignIn = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity2112/Button_SignIn", Button_SignIn)
function Button_SignIn:onInit()
	self:fixChildrenPos()
end
function Button_SignIn:onShow()
end
function Button_SignIn:initData(gold)
	self.controllers.c1:setSelectedIndex(1)
	self.fields.titleGold:setString(i18n("common_text_2875") .. string.formatnumberthousands(gold))
	if not SoraDEnoughGold(gold, true) then
		self.fields.titleGold:setColor(cc.c3b(224, 43, 43))
	end
end
return Button_SignIn
