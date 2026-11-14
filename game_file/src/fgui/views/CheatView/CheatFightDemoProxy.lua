local baseProxy = require("fgui.base.baseProxy")
local CheatFightDemoProxy = class("CheatFightDemoProxy", baseProxy)
function CheatFightDemoProxy:onRegisterEvent()
	print("=======CheatFightDemoProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CHEAT_UI_FIGHTDEMO_SWITCH", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_CHEAT_UI_FIGHTDEMO_CHOOSE", handler(self, self.chooseBack))
	SoraDAddMessage(self, "MESSAGE_CHEAT_UI_FIGHTDEMO_BIOGRAPHY", handler(self, self.biographyBack))
	SoraDAddMessage(self, "MESSAGE_CHEAT_UI_FIGHTDEMO_ARMY", handler(self, self.addArmyBack))
	SoraDAddMessage(self, "MESSAGE_CHEAT_UI_FIGHTDEMO_EQUIP", handler(self, self.equipBack))
	SoraDAddMessage(self, "MESSAGE_CHEAT_UI_FIGHTDEMO_BUFF", handler(self, self.buffBack))
	SoraDAddMessage(self, "MESSAGE_CHEAT_UI_FIGHTDEMO_JINN", handler(self, self.jinnBack))
	SoraDAddMessage(self, "MESSAGE_CHEAT_UI_FIGHTDEMO_DIVINE", handler(self, self.divineBack))
	SoraDAddMessage(self, "MESSAGE_CHEAT_UI_FIGHTDEMO_MARK", handler(self, self.markBack))
	SoraDAddMessage(self, "MESSAGE_CHEAT_UI_FIGHTDEMO_ARMS", handler(self, self.armsBack))
	SoraDAddMessage(self, "MESSAGE_CHEAT_UI_FIGHTDEMO_RUNE", handler(self, self.runeBack))
	SoraDAddMessage(self, "MESSAGE_CHEAT_UI_FIGHTDEMO_MAIL", handler(self, self.mailBack))
end
function CheatFightDemoProxy:initView(target, data)
	self.view:initView(target, data)
end
function CheatFightDemoProxy:chooseBack(target, data)
	self.view:chooseBack(target, data)
end
function CheatFightDemoProxy:biographyBack(target, data)
	self.view:biographyBack(target, data)
end
function CheatFightDemoProxy:addArmyBack(target, data)
	self.view:addArmyBack(target, data)
end
function CheatFightDemoProxy:equipBack(target, data)
	self.view:equipBack(target, data)
end
function CheatFightDemoProxy:buffBack(target, data)
	self.view:buffBack(target, data)
end
function CheatFightDemoProxy:jinnBack(target, data)
	self.view:jinnBack(target, data)
end
function CheatFightDemoProxy:divineBack(target, data)
	self.view:divineBack(target, data)
end
function CheatFightDemoProxy:markBack(target, data)
	self.view:markBack(target, data)
end
function CheatFightDemoProxy:armsBack(target, data)
	self.view:armsBack(target, data)
end
function CheatFightDemoProxy:runeBack(target, data)
	self.view:runeBack(target, data)
end
function CheatFightDemoProxy:mailBack(target, data)
	self.view:mailBack(target, data)
end
return CheatFightDemoProxy
