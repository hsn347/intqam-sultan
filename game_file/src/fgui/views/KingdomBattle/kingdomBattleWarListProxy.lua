local baseProxy = require("fgui.base.baseProxy")
local kingdomBattleWarListProxy = class("kingdomBattleWarListProxy", baseProxy)
function kingdomBattleWarListProxy:onRegisterEvent()
	print("=======kingdomBattleWarListProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CONQUESTWAR_MATCHLIST", handler(self, self.initView))
end
function kingdomBattleWarListProxy:initView(target, data)
	self.view:initView(target, data)
end
return kingdomBattleWarListProxy
