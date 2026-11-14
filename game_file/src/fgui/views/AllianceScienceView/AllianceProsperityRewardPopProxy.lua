local baseProxy = require("fgui.base.baseProxy")
local AllianceProsperityRewardPopProxy = class("AllianceProsperityRewardPopProxy", baseProxy)
function AllianceProsperityRewardPopProxy:onRegisterEvent()
	print("=======AllianceProsperityRewardPopProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_PROSPERITY_CHANGE", handler(self, self.refreshProsperity))
end
function AllianceProsperityRewardPopProxy:refreshProsperity(target, data)
	self.view:initData()
end
return AllianceProsperityRewardPopProxy
