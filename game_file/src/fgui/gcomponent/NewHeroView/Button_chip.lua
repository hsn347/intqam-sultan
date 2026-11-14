local baseComponent = require("fgui.base.baseComponent")
local Button_chip = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NewHeroView/Button_chip", Button_chip)
function Button_chip:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Button_chip:onShow()
end
function Button_chip:initData(heroID, icon, member, total)
	self.heroID = heroID
	self.isEnough = total <= member
	self.fields.icon_item:setSpriteFrame(icon)
	_ENV = nil
	;(nil).total = string.formatnumberthousands(total)
	;(nil).member = string.formatnumberthousands(member)
	self.fields.Text_num:setString(i18n("common_text_155", nil))
	self.fields.Text_num:setColor(self.isEnough and cc.c3b(255, 255, 255) or cc.c3b(190, 40, 40))
	self.fields.Text_exchange:setString(i18n("common_text_1889"))
end
function Button_chip:onBtnClick()
	SoraDPlaySound()
	if self.isEnough then
		_ENV = nil
		;(nil).heroID = self.heroID
		;(nil).mode = 2
		uiManager:show("HeroChipExchange", nil)
	else
		SoraDShowMsgTip(i18n("heroskill_text_03"))
	end
end
return Button_chip
