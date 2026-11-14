cityBuildData, _ENV = nil, nil
cityBuildData.allianceWarQueue, _ENV = nil, nil
function cityBuildData:removeAll()
	self:removeMessageListener()
	self.allianceWarQueue, _UPVALUE0_ = self.removeMessageListener, self.removeMessageListener
end
function cityBuildData:registerMessageListener()
	self:removeAll()
	self:initAllianceWarQueue()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_MAIN_ADD_NEW", handler(self, self.sMsgWarMainAdd))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_MAIN_DELETE_NEW", handler(self, self.sMsgWarMainDelete))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_MAIN_REFRESH", handler(self, self.cleanFighting))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_QUIT_SUCCESS", handler(self, self.cleanFighting))
end
function cityBuildData:removeMessageListener()
	SoraDRemoveMessageByTarget(self)
end
function cityBuildData:sMsgWarMainAdd(target, data)
	local queueID = data.queueID
	if queueID then
		self.allianceWarQueue[tostring(queueID)] = true
		local isShowFighting = self:getIsFighting()
		if isShowFighting ~= self.isShowFighting then
			self.isShowFighting = isShowFighting
			_ENV = queueID
			queueID.msg = "MESSAGE_MAINCITYVIEW_UPDATE_HALLOFWAR_VIEW"
			SoraDSendMessage(queueID)
		end
	end
end
function cityBuildData:sMsgWarMainDelete(target, data)
	local queueID = data.queueID
	if queueID then
		self.allianceWarQueue[tostring(queueID)] = nil
		local isShowFighting = self:getIsFighting()
		if isShowFighting ~= self.isShowFighting then
			self.isShowFighting = isShowFighting
			_ENV = queueID
			queueID.msg = "MESSAGE_MAINCITYVIEW_UPDATE_HALLOFWAR_VIEW"
			SoraDSendMessage(queueID)
		end
	end
end
function cityBuildData:getIsFighting()
	if next(self.allianceWarQueue) == nil then
		return false
	else
		return true
	end
end
function cityBuildData:cleanFighting()
	self.allianceWarQueue, _ENV = nil, nil
	self.isShowFighting = false
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_UPDATE_HALLOFWAR_VIEW"
	SoraDSendMessage(nil)
end
function cityBuildData:initAllianceWarQueue()
	local gametop = gModuleMgr.getObject("gametop")
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local allianceWarListData = kingdomMapCtrl.kingdomMapCell:getAllWarHallQueue()
	if allianceWarListData and next(allianceWarListData) ~= nil then
		for _, data in pairs(allianceWarListData) do
			if data.queues then
				for _, v in pairs(data.queues) do
					self.allianceWarQueue[tostring(v.data.id)] = true
				end
			end
		end
	end
end
return cityBuildData
