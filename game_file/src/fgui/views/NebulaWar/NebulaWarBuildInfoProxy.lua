local instanceFactory = include("instanceFactory")
local baseProxy = require("fgui.base.baseProxy")
local NebulaWarBuildInfoProxy = class("NebulaWarBuildInfoProxy", baseProxy)
function NebulaWarBuildInfoProxy:onRegisterEvent()
	print("=======NebulaWarBuildInfoProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_PLACEINFOBACK", handler(self, self.updateStateInfo))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_BUILD_UPDATE", handler(self, self.updateBuild))
	SoraDAddMessage(self, "MESSAGE_NEBULAWAR_CAMP_SCORE_UPDATE", handler(self, self.omMsgUpdateCampScore))
end
function NebulaWarBuildInfoProxy:updateStateInfo(target, event)
	SoraDCloseLoading(self.view:displayObject())
	self.view:showOcuppyInfo(event.retdata)
end
function NebulaWarBuildInfoProxy:updateBuild(target, event)
	self.view:updateBuild(target, event)
end
function NebulaWarBuildInfoProxy:omMsgUpdateCampScore(target, event)
	self.view:updateCampScore(event.rspdata)
end
return NebulaWarBuildInfoProxy
