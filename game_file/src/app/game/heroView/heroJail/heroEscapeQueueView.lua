local HeroEscapeQueueView = class("heroEscapeQueueView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("heroEscapeQueueView")
	end
	return target
end)
function HeroEscapeQueueView:ctor()
	self.tableAllTroops, _ENV, self.scaleActTarget = SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node")
	self.mainNode = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("hero_text_69"))
	self.nodeCopy = SoraDGetChildByName(self, "Node_copy")
	self.tableNumList, _ENV, self.tableAllTroops, _ENV, self.scroll = SoraDGetChildByName(self, "ScrollView_list"), SoraDGetChildByName(self, "ScrollView_list"), SoraDGetChildByName(self, "ScrollView_list"), SoraDGetChildByName(self, "ScrollView_list"), SoraDGetChildByName(self, "ScrollView_list")
	self.mainNodeOriPosY = self.mainNode:getPositionY()
end
function HeroEscapeQueueView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_EVENT_LSIT_INFO_NEW", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_HEROQUEUE_SPEED_OUT", handler(self, self.speedout))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_HEROQUEUE_SPEED_IN", handler(self, self.speedin))
end
function HeroEscapeQueueView:speedout(target, redata)
	transition.execute(self.mainNode, cca.moveTo(0.1, cc.p(self.mainNode:getPositionX(), self.mainNodeOriPosY + 100)))
end
function HeroEscapeQueueView:speedin(target, redata)
	transition.execute(self.mainNode, cca.moveTo(0.1, cc.p(self.mainNode:getPositionX(), self.mainNodeOriPosY)))
end
function HeroEscapeQueueView:initData()
	local gametop = gModuleMgr.getObject("gametop")
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local queues = kingdomMapCtrl:getMapEventList()
	for _, v in ipairs(queues) do
		if self:checkIsHeroLine(v) then
			self:updateQueueAdd(v)
		end
	end
	self:initTroopsSingle()
end
function HeroEscapeQueueView:updateData(target, data)
	if data.removeAll then
		self:resetData()
		self:regetIndex()
		self:initTroopsSingle()
	elseif self:checkIsHeroLine(data.data) then
		if data.eventState == gMapEventStateDef.mapEventStateAdd then
			self:updateQueueAdd(data.data)
		elseif data.eventState == gMapEventStateDef.mapEventStateModify then
			self:updateQueue(data.data)
		elseif data.eventState == gMapEventStateDef.mapEventStateDelete then
			self:updateQueueDelete(data.data)
		end
		self:regetIndex()
		self:initTroopsSingle()
	end
end
function HeroEscapeQueueView:resetData(...)
	if clean then
		for _, v in pairs(self.tableAllTroops) do
			if v.point then
				v.point:removeFromParent()
				v.point = nil
			end
		end
	end
	self.tableNumList, _ENV, self.tableAllTroops, _ENV = pairs(self.tableAllTroops)
end
function HeroEscapeQueueView:regetIndex()
	for i, v in ipairs(self.tableNumList) do
		if self.tableAllTroops[v] then
			self.tableAllTroops[v].index = i
		end
	end
end
function HeroEscapeQueueView:checkIsHeroLine(queue)
	if queue:getMoveLineType() == gMapMoveLineType.moveLineTypeReturn and queue.isHeroReturn then
		return true
	end
end
function HeroEscapeQueueView:updateQueueAdd(queueData)
	local queueID = queueData:getId()
	if self.tableAllTroops[queueID] then
		if self.tableAllTroops[queueID].point then
			self.tableAllTroops[queueID].point:removeFromParent()
			self.tableAllTroops[queueID].point = nil
		end
		for j, eventID in ipairs(self.tableNumList) do
			if eventID == queueID then
				table.remove(self.tableNumList, j)
				break
			end
		end
	end
	local orgQueueId = queueData:getOrgId()
	if orgQueueId and self.tableAllTroops[orgQueueId] then
		if self.tableAllTroops[orgQueueId].point then
			self.tableAllTroops[orgQueueId].point:removeFromParent()
			self.tableAllTroops[orgQueueId].point = nil
		end
		for i, eventID in ipairs(self.tableNumList) do
			if eventID == orgQueueId then
				table.remove(self.tableNumList, i)
				break
			end
		end
		self.tableAllTroops[orgQueueId] = nil
	end
	_ENV = ipairs(self.tableNumList)
	ipairs(self.tableNumList).data = queueData
	self.tableAllTroops[queueID], ipairs(self.tableNumList).point = ipairs(self.tableNumList)
	table.insert(self.tableNumList, 1, queueID)
end
function HeroEscapeQueueView:updateQueue(queueData)
	local queueID = queueData:getId()
	if self.tableAllTroops[queueID] then
		self.tableAllTroops[queueID].data = queueData
		if self.tableAllTroops[queueID].point then
			self.tableAllTroops[queueID].point:initData(queueData)
		end
	end
end
function HeroEscapeQueueView:updateQueueDelete(queueData)
	local queueID = queueData:getId()
	if self.tableAllTroops[queueID] then
		if self.tableAllTroops[queueID].point then
			self.tableAllTroops[queueID].point:removeFromParent()
			self.tableAllTroops[queueID].point = nil
		end
		for i, eventID in ipairs(self.tableNumList) do
			if eventID == queueID then
				table.remove(self.tableNumList, i)
				break
			end
		end
		self.tableAllTroops[queueID] = nil
	end
end
function HeroEscapeQueueView:singleJumpBack()
	self:removeFromParent()
end
function HeroEscapeQueueView:initTroopsSingle()
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, #self.tableNumList * 140)
	local index = 1
	for _, v in pairs(self.tableAllTroops) do
		local troopsSingle = v.point
		if troopsSingle == nil then
			troopsSingle = include("heroEscapeQueueSingle").new(self.nodeCopy:clone())
			troopsSingle:initData(v.data)
			troopsSingle:setScroll(self.scroll)
			troopsSingle:addTo(self.scroll)
			troopsSingle:setHandle(handler(self, self.singleJumpBack))
			v.point = troopsSingle
		end
		troopsSingle:setPosition(267.5, sH - (index - 1) * 140)
		troopsSingle:setVisible(true)
		index = index + 1
	end
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	if not next(self.tableAllTroops) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return HeroEscapeQueueView
