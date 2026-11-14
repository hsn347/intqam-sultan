local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local allianceWarData = include("allianceWarData")
local gAllianceQueueClassType = _G.gAllianceQueueClassType
local allianceWarBase = class("allianceWarBase", function(target)
	return target
end)
function allianceWarBase:ctor()
	self.queueDatas, _UPVALUE0_ = nil, nil
end
function allianceWarBase:addWarBaseMsg()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_MAIN_ADD_NEW", handler(self, self.dataLinkAdd))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_MAIN_DELETE_NEW", handler(self, self.dataLinkDelete))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_UPDATE_STATUS_NEW", handler(self, self.dataLinkUpdate))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_MAIN_FILER_STATUS", handler(self, self.dataLinkUpdate))
end
function allianceWarBase:initQueue(scrollH, isWar)
	for _, v in pairs(gAllianceQueueClassType) do
		self.queueDatas[v] = allianceWarData.new(self, v, scrollH)
	end
	self.queueRoot = kingdomMapCtrl:getQueueRootByWar(isWar)
end
function allianceWarBase:updateQueueScrollH(scrollH)
	for __, warQueueData in pairs(self.queueDatas) do
		warQueueData:updateQueueScrollH(scrollH)
	end
end
function allianceWarBase:initQueueData()
	local allianceWarListData = self.queueRoot:getAllWarHallQueue()
	if allianceWarListData and next(allianceWarListData) ~= nil then
		for key, v in pairs(allianceWarListData) do
			local newClassType = v.newClassType or gAllianceQueueClassType.pvp
			local warQueueData = self.queueDatas[newClassType]
			if warQueueData then
				warQueueData:dataLinkAdd(key, v, true)
			end
		end
	end
end
function allianceWarBase:getQueue(classType)
	return self.queueDatas[classType]
end
function allianceWarBase:getQueueData(data)
	local indexID = data.indexID
	local msgdata = data.data
	local newClassType = msgdata.newClassType or gAllianceQueueClassType.pvp
	local warQueueData = self.queueDatas[newClassType]
	return indexID, msgdata, warQueueData
end
function allianceWarBase:dataLinkAdd(target, data)
	if data.queueRoot and data.queueRoot ~= self.queueRoot then
		return
	end
	local indexID, msgdata, warQueueData = self:getQueueData(data)
	if warQueueData then
		warQueueData:dataLinkAdd(indexID, msgdata)
	end
end
function allianceWarBase:dataLinkDelete(target, data)
	if data.queueRoot and data.queueRoot ~= self.queueRoot then
		return
	end
	if not data.data then
		local indexID = data.indexID
		local newClassType = data.newClassType or gAllianceQueueClassType.pvp
		local warQueueData = self.queueDatas[newClassType]
		if warQueueData then
			warQueueData:dataLinkDelete(indexID)
		end
	else
		local indexID, msgdata, warQueueData = self:getQueueData(data)
		if warQueueData then
			warQueueData:dataLinkUpdate(indexID, msgdata)
		end
	end
end
function allianceWarBase:dataLinkUpdate(target, data)
	if data.queueRoot and data.queueRoot ~= self.queueRoot then
		return
	end
	local indexID = data.indexID
	local msgdata = data.data
	for __, warQueueData in pairs(self.queueDatas) do
		warQueueData:dataLinkUpdate(indexID, msgdata)
	end
end
function allianceWarBase:refreshByData(classType, queue, isDelete)
end
function allianceWarBase:refreshSinggleByData(classType, queue)
end
return allianceWarBase
