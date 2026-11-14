local baseProxy = require("fgui.base.baseProxy")
local AllianceProsperityBonusPopProxy = class("AllianceProsperityBonusPopProxy", baseProxy)
function AllianceProsperityBonusPopProxy:onRegisterEvent()
	print("=======AllianceProsperityBonusPopProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_PROSPERITY_CHANGE", handler(self, self.refreshProsperity))
end
function AllianceProsperityBonusPopProxy:refreshProsperity(target, data)
	self.view:refreshProsperity()
end
return AllianceProsperityBonusPopProxy
