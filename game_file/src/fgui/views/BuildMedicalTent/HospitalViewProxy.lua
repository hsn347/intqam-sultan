local baseProxy = require("fgui.base.baseProxy")
local HospitalViewProxy = class("HospitalViewProxy", baseProxy)
function HospitalViewProxy:onRegisterEvent()
	print("=======HospitalViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ARMY_DISMISSAL", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_TEAM_BUFF_LIST", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_PLAYER_BUFF_LIST", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_BUFF_NOTIFY", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.updateResSingle))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_HOSPITALCDCHANGE", handler(self, self.pyramidCDBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_WAR_END", handler(self, self.legendCDBack))
	SoraDAddMessage(self, "MESSAGE_QUEUE_MERGE_NOTIFY", handler(self, self.onMsgUpdateQueue))
	SoraDAddMessage(self, "MESSAGE_HOSPITALVIEW_WARTYPE_UPDATE", handler(self, self.onMsgUpdateWarType))
end
function HospitalViewProxy:updateData(target, data)
	self.view:updateData(target, data)
end
function HospitalViewProxy:updateResSingle(target, data)
	self.view:updateResSingle(target, data)
end
function HospitalViewProxy:pyramidCDBack(target, data)
	self.view:pyramidCDBack(target, data)
end
function HospitalViewProxy:legendCDBack(target, data)
	self.view:legendCDBack(target, data)
end
function HospitalViewProxy:setLV(...)
	self.view:setLV(...)
end
function HospitalViewProxy:onMsgUpdateQueue(target, event)
	if event.qtype ~= gQueueTypeDef.hostpital_queue then
		return
	end
	local queueCtrl = SoraDGetCtrl("queueCtrl")
	local queue = queueCtrl:queryQueue(gQueueTypeDef.hostpital_queue)
	if queue then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function HospitalViewProxy:onMsgUpdateWarType(target, event)
	if event.warType ~= self.view.warType then
		return
	end
	SoraDRemoveAllAfterPanelFromManager(self.view)
end
return HospitalViewProxy
