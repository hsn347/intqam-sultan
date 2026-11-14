local baseProxy = require("fgui.base.baseProxy")
local kingdomBattleWarStatusProxy = class("kingdomBattleWarStatusProxy", baseProxy)
function kingdomBattleWarStatusProxy:onRegisterEvent()
	print("=======kingdomBattleWarStatusProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CONQUESTWAR_BATTLEINFO", handler(self, self.initView))
end
function kingdomBattleWarStatusProxy:initView(target, data)
	self.view:initView(target, data)
end
return kingdomBattleWarStatusProxy
