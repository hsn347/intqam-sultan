local baseProxy = require("fgui.base.baseProxy")
local MeteoriteTalentsProxy = class("MeteoriteTalentsProxy", baseProxy)
function MeteoriteTalentsProxy:onRegisterEvent()
	print("=======MeteoriteTalentsProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_METEOR_MAGIC", handler(self, self.updateMsg))
	SoraDAddMessage(self, "MESSAGE_UPDATE_METEOR_MAGIC_TALENTS", handler(self, self.updateTalentTree))
	SoraDAddMessage(self, "MESSAGE_UPDATE_METEOR_MAGIC_TALENTS_GO", handler(self, self.scrollToCenter))
	SoraDAddMessage(self, "MESSAGE_UPDATE_METEOR_MAGIC_TALENTS_PREVIEW", handler(self, self.previewGroups))
end
function MeteoriteTalentsProxy:updateTalentTree(target, data)
	self.view:updateTalentTree()
end
function MeteoriteTalentsProxy:updateMsg(target, data)
	self.view:updateMsg()
end
function MeteoriteTalentsProxy:scrollToCenter(target, data)
	local obj = self.view.talentTree:getObjByIdGroup(data.idGroup)
	if obj then
		self.view:scrollToCenter(obj, true)
	end
end
function MeteoriteTalentsProxy:previewGroups(target, data)
	dump(data, "MeteoriteTalentsProxy:previewGroups")
	if data.isShow then
		self.view.talentTree:showPreviews(data.idGroups)
	else
		self.view.talentTree:hidePreview(data.idGroups)
	end
end
return MeteoriteTalentsProxy
