local baseProxy = require("fgui.base.baseProxy")
local waxLetterViewProxy = class("waxLetterViewProxy", baseProxy)
function waxLetterViewProxy:onRegisterEvent()
	print("=======waxLetterViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_ITEM_CHOOSE", handler(self, self.itemChoose))
end
function waxLetterViewProxy:itemChoose(target, data)
	self.view:itemChoose(target, data)
end
return waxLetterViewProxy
