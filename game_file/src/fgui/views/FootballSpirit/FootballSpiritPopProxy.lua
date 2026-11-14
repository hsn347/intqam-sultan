local baseProxy = require("fgui.base.baseProxy")
local FootballSpiritPopProxy = class("FootballSpiritPopProxy", baseProxy)
function FootballSpiritPopProxy:onRegisterEvent()
	print("=======FootballSpiritPopProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_FOOTBALL_ELF_UPDATE", handler(self, self.rechargeBack))
end
function FootballSpiritPopProxy:rechargeBack(target, data)
	if data and data.isUnlock then
		self.view:close()
	end
end
return FootballSpiritPopProxy
