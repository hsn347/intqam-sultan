local divineProtectionRead = include("divineProtectionRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_cards = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SanctuaryDivine/Com_cards", Com_cards)
function Com_cards:onInit()
end
function Com_cards:initParent(parent)
	self.parent = parent
end
function Com_cards:onShow()
	for i = 1, 5 do
		self.fields["card_" .. i]:setTag(i)
		self.fields["card_" .. i]:addClickListener(handler(self, self.onCardClick))
	end
end
function Com_cards:onCardClick(context)
	SoraDPlaySound()
	local tag = context:getSender():getTag()
	_ENV = nil
	;(nil).skillType = divineProtectionRead.getShowType(tag)
	uiManager:show("MagicLampSkillDetailsLook", nil):setOwnerKey(self.parent)
end
return Com_cards
