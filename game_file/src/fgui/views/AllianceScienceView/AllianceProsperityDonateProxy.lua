local baseProxy = require("fgui.base.baseProxy")
local AllianceProsperityDonateProxy = class("AllianceProsperityDonateProxy", baseProxy)
function AllianceProsperityDonateProxy:onRegisterEvent()
	print("=======AllianceProsperityDonateProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_PROSPERITY_REFRESH", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_PROSPERITY_CLEAN_CD", handler(self, self.cleanCDCallback))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_CONTRIBUTE_DOUBLE", handler(self, self.contributeEffect))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_PROSPERITY_CHANGE", handler(self, self.refreshProsperity))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_POPULARITY_CHANGE", handler(self, self.refreshPopularity))
end
function AllianceProsperityDonateProxy:contributeEffect(target, data)
	local effectUI = include("effectUI")
	local bType = data.bType
	effectUI.addAllianceScienceContributeEffect(self.view:displayObject())
	effectUI.addAllianceScienceRunDoubleAnimation(self.view:displayObject(), bType)
end
function AllianceProsperityDonateProxy:refreshView(target, data)
	SoraDCloseLoading(self.view)
	self.view:initData()
end
function AllianceProsperityDonateProxy:cleanCDCallback(target, data)
	SoraDCloseLoading(self.view)
	self.view:refreshTime()
end
function AllianceProsperityDonateProxy:refreshProsperity()
	self.view:refreshProsperity()
end
function AllianceProsperityDonateProxy:refreshPopularity()
	self.view:refreshPopularity()
end
return AllianceProsperityDonateProxy
