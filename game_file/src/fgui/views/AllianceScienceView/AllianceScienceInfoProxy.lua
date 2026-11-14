local baseProxy = require("fgui.base.baseProxy")
local AllianceScienceInfoProxy = class("AllianceScienceInfoProxy", baseProxy)
function AllianceScienceInfoProxy:onRegisterEvent()
	print("=======AllianceScienceInfoProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_DONATE_SUCCESS", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_DONATE_CD_CLEAN_SUCCESS", handler(self, self.updateQueue))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_CONTRIBUTE_DOUBLE", handler(self, self.contributeEffect))
end
function AllianceScienceInfoProxy:updateData()
	self.view:updateData()
end
function AllianceScienceInfoProxy:updateQueue()
	self.view:updateQueue()
end
function AllianceScienceInfoProxy:contributeEffect(target, data)
	local effectUI = include("effectUI")
	local bType = data.bType
	effectUI.addAllianceScienceContributeEffect(self.view:displayObject())
	effectUI.addAllianceScienceRunDoubleAnimation(self.view:displayObject(), bType)
end
return AllianceScienceInfoProxy
