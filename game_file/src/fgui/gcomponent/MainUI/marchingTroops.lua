local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local AutoKillQueueID = "AutoKillQueueID"
local DEFAULT_SHOW_COUNT = 2
local baseComponent = require("fgui.base.baseComponent")
local marchingTroops = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/marchingTroops", marchingTroops)
function marchingTroops:onInit()
	self.tableHeroTroops, _ENV, self.troopList, _ENV, self.tableNumList, _ENV, self.tableAllTroops, _ENV, self.isOpen = nil, nil, nil, nil, nil, nil, nil, nil, false
	self.baseVisible = true
	self.warVisible = true
	self.fields.btnHeros:addClickListener(handler(self, self.OnBtnHerosClick))
	self.fields.btnMore:addClickListener(handler(self, self.OnBtnMoreTroopsClick))
	self:fixChildrenPos()
	self.fields.bg:fix()
end
function marchingTroops:onShow()
end
function marchingTroops:addMessage()
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_EVENT_LSIT_INFO_NEW", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_AUTO_KILL_QUEUEID", handler(self, self.updateAutoData))
end
function marchingTroops:removeMessage()
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_SERVER_WORLD_MAP_EVENT_LSIT_INFO_NEW")
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_MAIN_TROOPS_TOUCH")
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_SERVER_AUTO_KILL_QUEUEID")
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_MAIN_TROOPS_NUM")
end
function marchingTroops:updateTroopList()
	local _ENV, troops
	local showCount = 0
	local _ENV, removeTb
	for key, single in pairs(self.troopList) do
		if not self.tableAllTroops[key] then
			single:removeFromParent()
			self.troopList[key] = nil
		end
	end
	for k, v in pairs(self.tableAllTroops) do
		_ENV = nil
		;(nil).key = k
		;(nil).val = v
		table.insert(troops, nil)
	end
	table.sort(troops, function(a, b)
		return a.val.index < b.val.index
	end)
	for k, v in ipairs(troops) do
		if not self.troopList[v.key] then
			self.troopList[v.key] = fgui.UIPackage:createObjectFromURL("ui://MainUI/marchingTroopsSingle")
			self:addChild(self.troopList[v.key], 5)
		end
		self.troopList[v.key]:setVisible(self.isOpen or k <= DEFAULT_SHOW_COUNT)
		if self.troopList[v.key]:isVisible() then
			showCount = showCount + 1
			if v.val and v.val.data then
				self.troopList[v.key]:initData(v.val.data)
			else
				self.troopList[v.key]:initAutoKill()
			end
			self.troopList[v.key]:setPosition(SoraDFPosX(-88, -88), 20 + 50 * (k - 1))
		end
	end
	self.fields.bg:setSize(cc.size(250, showCount * 50 + 30))
	self.fields.bg:setVisible(0 < showCount)
end
function marchingTroops:hideAllTroopList()
	for k, v in pairs(self.troopList) do
		v:setVisible(false)
	end
end
function marchingTroops:resetData(clean)
	if clean then
		self:hideAllTroopList()
	end
	self.tableHeroTroops, _UPVALUE0_, self.tableNumList, _UPVALUE0_, self.tableAllTroops, _UPVALUE0_ = self.hideAllTroopList, self.hideAllTroopList, self.hideAllTroopList, self.hideAllTroopList, self.hideAllTroopList, self.hideAllTroopList
end
function marchingTroops:updateData(target, data)
	if data.removeAll then
		self:resetData(true)
	else
		local queue = data.data
		if self:checkIsHeroLine(queue) then
			if data.eventState == gMapEventStateDef.mapEventStateAdd then
				self.tableHeroTroops[queue:getId()] = true
			elseif data.eventState == gMapEventStateDef.mapEventStateDelete then
				self.tableHeroTroops[queue:getId()] = nil
			end
		elseif data.eventState == gMapEventStateDef.mapEventStateAdd then
			self:updateQueueAdd(self:fixMass(queue))
		elseif data.eventState == gMapEventStateDef.mapEventStateModify then
			self:updateQueue(self:fixMass(queue))
		elseif data.eventState == gMapEventStateDef.mapEventStateDelete then
			self:updateQueueDelete(queue)
		end
	end
	self:regetIndex()
	self:updateTroops()
	self:checkHeroQueue()
	self:updateAutoKillQueue()
end
function marchingTroops:regetIndex()
	for i, v in ipairs(self.tableNumList) do
		if self.tableAllTroops[v] then
			self.tableAllTroops[v].index = i
		end
	end
end
function marchingTroops:updateQueueAdd(queueData)
	local queueID = queueData:getId()
	if self.tableAllTroops[queueID] then
		for j, eventID in ipairs(self.tableNumList) do
			if eventID == queueID then
				table.remove(self.tableNumList, j)
				break
			end
		end
	end
	local orgQueueId = queueData:getOrgId()
	if orgQueueId and self.tableAllTroops[orgQueueId] then
		for i, eventID in ipairs(self.tableNumList) do
			if eventID == orgQueueId then
				table.remove(self.tableNumList, i)
				break
			end
		end
		self.tableAllTroops[orgQueueId] = nil
	end
	_ENV = ipairs(self.tableNumList)
	self.tableAllTroops[queueID], ipairs(self.tableNumList).data = ipairs(self.tableNumList)
	table.insert(self.tableNumList, 1, queueID)
end
function marchingTroops:updateQueue(queueData)
	local queueID = queueData:getId()
	if self.tableAllTroops[queueID] then
		self.tableAllTroops[queueID].data = queueData
	end
end
function marchingTroops:updateQueueDelete(queueData)
	local queueID = queueData:getId()
	self:updateQueueDelete_imp(queueID)
end
function marchingTroops:updateQueueDelete_imp(queueID)
	if self.tableAllTroops[queueID] then
		for i, eventID in ipairs(self.tableNumList) do
			if eventID == queueID then
				table.remove(self.tableNumList, i)
				break
			end
		end
		self.tableAllTroops[queueID] = nil
	end
end
function marchingTroops:initData(isOnWorld)
	if isOnWorld then
		self:addMessage()
		local queues = kingdomMapCtrl:getMapEventList()
		for _, v in ipairs(queues) do
			if self:checkIsHeroLine(v) then
				self.tableHeroTroops[v:getId()] = true
			else
				self:updateQueueAdd(self:fixMass(v))
			end
		end
		self:regetIndex()
		self:updateTroops()
		self:checkHeroQueue()
		self:updateAutoData()
	else
		self:setVisible(false)
		self:removeMessage()
		self:resetData(true)
	end
end
function marchingTroops:OnBtnMoreTroopsClick(button, type)
	SoraDPlaySound()
	self.isOpen = not self.isOpen
	self:updateTroops()
	self:checkHeroQueue()
end
function marchingTroops:OnBtnHerosClick()
	SoraDPlaySound()
	local panel = SoraDCreatePanel("heroEscapeQueueView")
	panel:show()
	panel:initData()
end
function marchingTroops:updateTroops()
	self.troopNum = table.nums(self.tableAllTroops)
	local heroQueueNum = table.nums(self.tableHeroTroops)
	local troopCloseNum = math.min(DEFAULT_SHOW_COUNT, self.troopNum)
	self.baseVisible = self.troopNum >= 1 or 0 < heroQueueNum
	self:setVisible(self.baseVisible and self.warVisible)
	if self.isOpen then
		self.fields.btnMore:setString(i18n("common_text_1042"))
		self.fields.btnMore:setShowModel(false)
	else
		self.fields.btnMore:setString(self.troopNum - DEFAULT_SHOW_COUNT .. i18n("common_text_486"))
		self.fields.btnMore:setShowModel(true)
	end
	self:updateTroopList()
	self.fields.btnMore:setVisible(self.troopNum > DEFAULT_SHOW_COUNT)
end
function marchingTroops:checkIsHeroLine(queue)
	return queue:isHeroReturnFun()
end
function marchingTroops:checkHeroQueue(...)
	local heroQueueNum = table.nums(self.tableHeroTroops)
	self.fields.btnHeros:setVisible(0 < heroQueueNum)
	if 0 < heroQueueNum then
		self.fields.btnHeros:setRed(heroQueueNum)
	end
end
function marchingTroops:fixMass(queue)
	if not queue:isMainQueueFun() and queue:getStatus() == gMapMoveLineStatusType.moveLineStatusTypeWorking then
		return kingdomMapCtrl.kingdomMapCell:optMapEvent4Mass(queue)
	end
	return queue
end
function marchingTroops:delAutoKillQueue()
	if self.tableAllTroops[AutoKillQueueID] then
		self:updateQueueDelete_imp(AutoKillQueueID)
		self:regetIndex()
		self:updateTroops()
	end
end
function marchingTroops:updateAutoKillQueue()
	if self.tableAllTroops[AutoKillQueueID] then
		local buildLogic = include("buildLogic")
		local maxTroops = buildLogic.getExpQueueCount()
		local isFull = false
		if kingdomMapCtrl:isHasQueue() > 0 and maxTroops.total <= kingdomMapCtrl:isHasQueue() then
			isFull = true
		end
		self:updateTroopList()
	end
end
function marchingTroops:addAutoKillQueue()
	local queueID = AutoKillQueueID
	if not self.tableAllTroops[queueID] then
		self.tableAllTroops[queueID], AutoKillQueueID = nil, nil
		table.insert(self.tableNumList, 1, queueID)
		self:regetIndex()
		self:updateTroops()
	end
end
function marchingTroops:updateAutoData(target, data)
	if worldMapDefine.isInRoaringFlame() then
		return
	end
	local autokillCtrl = gametop.playertop_:getModule("autokillCtrl")
	local queueList = autokillCtrl:getAutoKillQueueList()
	if queueList and next(queueList) then
		self:delAutoKillQueue()
		return
	end
	if autokillCtrl:isAutoKillStart() then
		self:addAutoKillQueue()
		self:updateAutoKillQueue()
	else
		self:delAutoKillQueue()
	end
end
function marchingTroops:updateWarVisible(visible)
	self.warVisible = visible
	self:setVisible(self.baseVisible and self.warVisible)
end
function marchingTroops:getBaseVisible(...)
	return self.baseVisible
end
return marchingTroops
