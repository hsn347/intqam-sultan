local baseProxy = require("fgui.base.baseProxy")
local CheatHeroBiographyProxy = class("CheatHeroBiographyProxy", baseProxy)
function CheatHeroBiographyProxy:onRegisterEvent()
	print("=======CheatHeroBiographyProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CHEAT_UI_FIGHTDEMO_BIOGRAPHY", handler(self, self.initView))
end
function CheatHeroBiographyProxy:initView(target, data)
	self.view:initView(target, data)
end
return CheatHeroBiographyProxy
