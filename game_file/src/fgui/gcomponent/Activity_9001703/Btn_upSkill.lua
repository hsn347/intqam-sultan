local baseComponent = require("fgui.base.baseComponent")
local Btn_upSkill = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001703/Btn_upSkill", Btn_upSkill)
function Btn_upSkill:onInit()
	self.fields.Text_up:setString(i18n("Jinn_hatch_text_18"))
	self.fields.Text_max:setString(i18n("common_text_283"))
	self.fields.title:fixPos()
	self.fields.icon:fixPos()
end
function Btn_upSkill:onShow()
end
function Btn_upSkill:initData(coin, balloonCoin, isMax)
	self.controllers.c1:setSelectedIndex(isMax and 1 or 0)
	if not isMax then
		self.fields.title:setString(coin)
		self.fields.title:setColor(balloonCoin < coin and cc.c3b(190, 40, 40) or cc.c3b(239, 245, 242))
	end
end
return Btn_upSkill
