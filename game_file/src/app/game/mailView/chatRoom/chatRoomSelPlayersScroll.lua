local gametop = gModuleMgr.getObject("gametop")
local mailCtrl = gametop.playertop_:getModule("mailCtrl")
local mailMgr = gModuleMgr.sharedMgr("mailMgr")
local mailFunctions = include("mailFunctions")
local chatConst = include("chatConst")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local lordLocalData = include("lordLocalData")
local allianceQuery = gametop.playertop_:getModule("allianceQuery")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local chatRoomSelPlayersScroll = class("chatRoomSelPlayersScroll", function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new(getCCSPath("chatRoomSelPlayersScroll"))
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function chatRoomSelPlayersScroll:ctor()
	self.itemsData, _ENV, self.historyData, _ENV, self.recycledGroupList, _ENV, self.recycledList, _ENV, self.reload = nil, nil, nil, nil, nil, nil, nil, nil, false
	self.scrollView = SoraDGetChildByName(self, "Top_Size_ScrollView")
	self.cellWidth = 640
	self.cellHeight = 110
	self.cellGroupHeight = 50
	self.scrollView:addEventListener(handler(self, self.scrollEventCallBack))
	local offsetY = 60
	local sSize = self.scrollView:getContentSize()
	self.scrollView:setContentSize(cc.size(sSize.width, sSize.height - offsetY))
	self.scrollView:setPositionY(self.scrollView:getPositionY() - offsetY)
	self.layout_mask = ccui.Layout:create()
	self.layout_mask:setAnchorPoint(cc.p(0, 0))
	self.layout_mask:setPosition(cc.p(0, 0))
	self.layout_mask:setContentSize(self.scrollView:getContentSize())
	self.layout_mask:addTo(self)
	self.layout_mask:setLocalZOrder(10)
	self.layout_mask:setClippingEnabled(true)
	self.tipGroupBar = include("chatRoomGroupBar").new()
	self.tipGroupBar:setAnchorPoint(cc.p(0, 1))
	self.tipGroupBar:setLocalZOrder(10000)
	self.tipGroupBar:setPosition(cc.p(0, self.scrollView:getContentSize().height))
	self.tipGroupBar:setVisible(false)
	self.tipGroupBar:addTo(self.layout_mask)
	self.isInDelMode = false
end
function chatRoomSelPlayersScroll:onMessageListener()
	print("function chatRoomSelPlayersScroll:onMessageListener()----------------------------------------------------")
	SoraDAddMessage(self, "MESSAGE_CHAT_ROOM_TOGGLE_GROUP_BAR", handler(self, self.msgToggleGroupBar))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_MEMBER_LIST_SUCCESS", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_TEAM_INFO_POINT_DATA", handler(self, self.updateTeamData))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_TEAM_MEMBER_INFO_BACK", handler(self, self.updateTeamData_legend))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_CAMPPLAYERLIST", handler(self, self.updateTeamData_atlantis))
	SoraDAddMessage(self, "MESSAGE_ITEM_LORD_ACCURATE_SEARCH_BACK", handler(self, self.sMsgLordAccurateSearchBack))
end
function chatRoomSelPlayersScroll:updateData()
	SoraDCloseLoading(self)
	self.itemsData = self:wrapAllData(self.roomData)
	self:delayUpdateScrollView()
end
function chatRoomSelPlayersScroll:updateTeamData(target, data)
	if self.roomData.selPlayerOpType == chatConst.selPlayerOpType.selPlayerOnlineVoice and worldMapDefine.isInRemains() then
		SoraDCloseLoading(self)
		local remainsWarUtil = include("remainsWarUtil")
		local RW_CAMP = _G.RW_CAMP
		if not data or not data.playerPointsList then
			local chatConst, tableSingleData = data.playerPointsList, data.playerPointsList
		end
		if not tableSingleData[RW_CAMP.SOUTH_KEY] then
			local chatConst, southData = tableSingleData[RW_CAMP.SOUTH_KEY], tableSingleData[RW_CAMP.SOUTH_KEY]
		end
		if not tableSingleData[RW_CAMP.NORTH_KEY] then
			local chatConst, northData = tableSingleData[RW_CAMP.NORTH_KEY], tableSingleData[RW_CAMP.NORTH_KEY]
		end
		local isSelfIn = remainsWarUtil.isSelfIn(southData)
		local memberList = isSelfIn and southData or northData
		self.itemsData = self:wrapAllTeamData(memberList)
		self:delayUpdateScrollView()
	end
end
function chatRoomSelPlayersScroll:updateTeamData_legend(target, data)
	if self.roomData.selPlayerOpType == chatConst.selPlayerOpType.selPlayerOnlineVoice and worldMapDefine.isInLegendLord() then
		SoraDCloseLoading(self)
		local teamCtrl = include("legendTeamUtil").getCurTeamCtrl(worldMapDefine.currentMapKindomID)
		local chatConst, memberList = worldMapDefine.currentMapKindomID, worldMapDefine.currentMapKindomID
		if teamCtrl:isHasTeam() then
			memberList = teamCtrl:getTeamMemberList()
		end
		self.itemsData = self:wrapAllTeamData_legend(memberList)
		self:delayUpdateScrollView()
	end
end
function chatRoomSelPlayersScroll:updateTeamData_atlantis(target, data)
	if self.roomData.selPlayerOpType == chatConst.selPlayerOpType.selPlayerOnlineVoice and worldMapDefine.isInAtlantis() then
		SoraDCloseLoading(self)
		local atlantisWarCtrl = gametop.playertop_:getModule("atlantisWarCtrl")
		local memberList = atlantisWarCtrl:getCampPlayerList()
		self.itemsData = self:wrapAllTeamData_atlantis(memberList)
		self:delayUpdateScrollView()
	end
end
function chatRoomSelPlayersScroll:getTestData()
	_ENV = nil
	;(nil).members, _ENV, (nil).isCreator = nil, nil, true
	local testData
	local index = 1
	for i = 5, 1, -1 do
		_ENV = nil
		;(nil).dataType = chatConst.ctSelPlayerDataType.dt_groupBar
		;(nil).rankLv = i
		table.insert(testData.members, #testData.members + 1, nil)
		for j = 1, 15 - i do
			_ENV = nil
			;(nil).dataType = chatConst.ctSelPlayerDataType.dt_player
			;(nil).playerId = nil
			;(nil).imgPlayer = "head_m_001.png"
			;(nil).nickName = "player" .. index
			;(nil).data = nil
			table.insert(testData.members, #testData.members + 1, nil)
			index = index + 1
		end
	end
	return testData
end
function chatRoomSelPlayersScroll:initWithData(data)
	self.roomData = data
	self.isShowOnline = data.isShowOnline
	dump(self.roomData, "chatRoomSelPlayersScroll:initWithData(data)")
	if self.roomData.selPlayerOpType == chatConst.selPlayerOpType.selPlayerOnlineVoice then
		if worldMapDefine.isInRemains() then
			self:initWithData_remains()
		elseif worldMapDefine.isInLegendLord() then
			self:initWithData_legend()
		elseif worldMapDefine.isInAtlantis() then
			self:initWithData_atlantis()
		else
			self:initWithData_normal()
		end
	else
		self:initWithData_normal()
	end
end
function chatRoomSelPlayersScroll:initWithData_legend()
	self:resetInnerSizeAndPos()
	local teamCtrl = include("legendTeamUtil").getCurTeamCtrl(worldMapDefine.currentMapKindomID)
	if teamCtrl:isHasTeam() then
		teamCtrl:reqGetMemberInfo()
		SoraDShowLoading(self)
	end
end
function chatRoomSelPlayersScroll:initWithData_atlantis()
	self:resetInnerSizeAndPos()
	local atlantisWarCtrl = gametop.playertop_:getModule("atlantisWarCtrl")
	atlantisWarCtrl:reqCampPlayerList()
	SoraDShowLoading(self)
end
function chatRoomSelPlayersScroll:initWithData_remains()
	self:resetInnerSizeAndPos()
	local remainsWarCtrl = gametop.playertop_:getModule("remainsWarCtrl")
	local mapId = worldMapDefine.currentMapKindomID or gametop.playertop_:getMapID()
	remainsWarCtrl:reqRemainsWarPlayerPointsList(mapId)
	SoraDShowLoading(self)
end
function chatRoomSelPlayersScroll:initWithData_normal()
	local ownmember = memberMgr:getOwnMember()
	self.aid = ownmember:getProperty("aid")
	if self.isShowOnline == true then
		local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
		if self.aid and self.aid ~= 0 and permissionCtrl:hasPlayerPermission(gAPermission.VIEW_MEMBER_ONLINE_INFO) then
			self.isShowOnline = true
		else
			self.isShowOnline = false
		end
	end
	print("=======----------chatRoomSelPlayersScroll: initWithData(data)")
	self:resetInnerSizeAndPos()
	SoraDShowLoading(self)
	local aid = allianceMgr.ownaid
	allianceQuery:reqMemberList(aid)
end
function chatRoomSelPlayersScroll:getChatRoomMembersData()
	return self:getTestData().members
end
function chatRoomSelPlayersScroll:resetInnerSizeAndPos()
	local scrollInner = self.scrollView:getInnerContainer()
	local innerSize = cc.size(self.scrollView:getContentSize().width, self.scrollView:getContentSize().height)
	self.scrollView:setInnerContainerSize(innerSize)
	scrollInner:setPositionY(0)
end
function chatRoomSelPlayersScroll:msgRefreshView(target, data)
	print("TODO: 刷新scrollView  function chatRoomSelPlayersScroll:msgRefreshView(target, data)")
end
function chatRoomSelPlayersScroll:delayUpdateScrollView()
	local actDelay = cca.delay(0.1)
	local callFunc = cca.callFunc(handler(self, self.updateScrollView))
	_UPVALUE2_ = handler(self, self.updateScrollView)
	handler(self, self.updateScrollView)[1] = actDelay
	handler(self, self.updateScrollView)[2] = callFunc
	local seq = cca.seq(handler(self, self.updateScrollView))
	self:runAction(seq)
end
function chatRoomSelPlayersScroll:getItem(data)
	local cell
	local isFromRecycle = false
	if data.dataType == chatConst.ctSelPlayerDataType.dt_groupBar then
		if self:hasAnyRecycledGroupCell() == true then
			cell = self:pickCellFromRecycledGroupList()
			cell:setScrollView(self)
			cell:initWithData(data)
			isFromRecycle = true
		else
			cell = self:createItem(data)
		end
	elseif self:hasAnyRecycledCell() == true then
		cell = self:pickCellFromRecycledList()
		cell:setScrollView(self)
		cell:initWithData(data)
		isFromRecycle = true
	else
		cell = self:createItem(data)
	end
	return cell, isFromRecycle
end
function chatRoomSelPlayersScroll:createItem(data)
	local itemNode
	if data.dataType == chatConst.ctSelPlayerDataType.dt_player then
		local chatRoomPlayerItem = include("chatRoomPlayerItem")
		itemNode = chatRoomPlayerItem.new()
	elseif data.dataType == chatConst.ctSelPlayerDataType.dt_groupBar then
		local chatRoomGroupBar = include("chatRoomGroupBar")
		itemNode = chatRoomGroupBar.new()
	end
	itemNode:setAnchorPoint(cc.p(0, 0))
	itemNode:setScrollView(self)
	itemNode:initWithData(data)
	return itemNode
end
function chatRoomSelPlayersScroll:updateScrollView()
	print("refresh view: number: " .. #self.itemsData)
	self.isScrollUpdated = true
	for i, v in ipairs(self.itemsData) do
		if v.itemNode and v.itemNode.reset then
			v.itemNode:reset(true)
		end
		if (v.itemWidth == nil or v.itemWidth == 0) and (v.itemHeight == nil or v.itemHeight == 0) then
			v.itemWidth = self.cellWidth
			if v.dataType == chatConst.ctSelPlayerDataType.dt_player then
				v.itemHeight = self.cellHeight
			elseif v.dataType == chatConst.ctSelPlayerDataType.dt_groupBar then
				v.itemHeight = self.cellGroupHeight
			else
				v.itemHeight = self.cellHeight
			end
		else
		end
	end
	if self.reload == true then
		self:doRecycleHistory()
		self.reload = false
	end
	print("总节点个数：", #self.itemsData)
	self:updateScrollSize()
	self:updateScrollCell()
end
function chatRoomSelPlayersScroll:updateScrollCell()
	if not self.isScrollUpdated then
		print("scrol还没初始化，因为做了延迟处理---")
		return
	end
	local scrollInner = self.scrollView:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scrollView:getContentSize().height
	_ENV = self.scrollView
	self.scrollView.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scrollView.endY, tableShowH = offsetY + 1.5 * scrollH, self.scrollView
	local renderCount = 0
	for i, v in ipairs(self.itemsData) do
		if v.itemNode then
			if v.itemPosY < tableShowH.beginY or v.itemPosY > tableShowH.endY then
				if v.dataType == chatConst.ctSelPlayerDataType.dt_player then
					self:addToRecycledList(v.itemNode)
				elseif v.dataType == chatConst.ctSelPlayerDataType.dt_groupBar then
					self:addToRecycledGroupList(v.itemNode)
				end
				v.itemNode = nil
			else
			end
		elseif v.itemPosY and tableShowH.beginY <= v.itemPosY and tableShowH.endY >= v.itemPosY then
			local itemNode, isFromRecycle = self:getItem(v)
			v.itemNode = itemNode
			v.itemNode:setPosition(v.itemPosX, v.itemPosY)
			if isFromRecycle == false then
				v.itemNode:addTo(self.scrollView)
			end
		end
	end
	self:updateGroupBarTip()
end
function chatRoomSelPlayersScroll:updateScrollSize()
	if not self.itemsData or #self.itemsData == 0 then
		return
	end
	local totalNumber = #self.itemsData
	local scrollInner = self.scrollView:getInnerContainer()
	local minOffsetY = -(scrollInner:getContentSize().height - self.scrollView:getContentSize().height)
	local offsetY = scrollInner:getPositionY()
	local totalHeight = 0
	for i, v in ipairs(self.itemsData) do
		totalHeight = totalHeight + v.itemHeight
	end
	print("totalHeight = ", totalHeight)
	local scrollInnerHeight = math.max(totalHeight, self.scrollView:getContentSize().height)
	local scrollInnerWidth = scrollInner:getContentSize().width
	local accumulateHeight = 0
	local accumulateWidth = 0
	local accumulateHeight = 0
	for i, v in ipairs(self.itemsData) do
		v.itemPosX = 0
		accumulateHeight = accumulateHeight + v.itemHeight
		v.itemPosY = scrollInnerHeight - accumulateHeight
		if v.itemNode then
			v.itemNode:setPositionY(v.itemPosY)
			v.itemNode:setPositionX(v.itemPosX)
		end
	end
	local totalCellHeight = scrollInnerHeight
	local scrollContentSize = self.scrollView:getContentSize()
	if totalCellHeight < scrollContentSize.height then
	end
	local scrollInnerNewH = totalCellHeight
	scrollInnerNewH = scrollInnerNewH + 10
	offsetY = offsetY - (scrollInnerNewH - scrollInner:getContentSize().height)
	self.scrollView:setInnerContainerSize(cc.size(scrollInner:getContentSize().width, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
	print("size : " .. scrollInner:getContentSize().width .. " height: " .. scrollInner:getContentSize().height)
end
function chatRoomSelPlayersScroll:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:updateScrollCell()
	elseif event == ccui.ScrollviewEventType.bounceBottom then
		self:updateGroupBarTip()
	elseif event == ccui.ScrollviewEventType.bounceTop then
		self:updateGroupBarTip()
	end
end
function chatRoomSelPlayersScroll:isCellInRecycledList(cell)
	local result = false
	for i, v in ipairs(self.recycledList) do
		if v == cell then
			result = true
			break
		end
	end
	return result
end
function chatRoomSelPlayersScroll:addToRecycledList(cell)
	cell:setVisible(false)
	table.insert(self.recycledList, cell)
end
function chatRoomSelPlayersScroll:addToRecycledGroupList(cell)
	cell:setVisible(false)
	table.insert(self.recycledGroupList, cell)
end
function chatRoomSelPlayersScroll:hasAnyRecycledCell()
	local result = false
	if #self.recycledList > 0 then
		result = true
		return result
	end
	return result
end
function chatRoomSelPlayersScroll:hasAnyRecycledGroupCell()
	local result = false
	if #self.recycledGroupList > 0 then
		result = true
		return result
	end
	return result
end
function chatRoomSelPlayersScroll:pickCellFromRecycledList()
	local cell
	if #self.recycledList > 0 then
		cell = table.remove(self.recycledList)
		cell:setVisible(true)
	end
	return cell
end
function chatRoomSelPlayersScroll:pickCellFromRecycledGroupList()
	local cell
	if #self.recycledGroupList > 0 then
		cell = table.remove(self.recycledGroupList)
		cell:setVisible(true)
	end
	return cell
end
function chatRoomSelPlayersScroll:recycleAll()
	for i = 1, #self.itemsData do
		local dataItem = self.itemsData[i]
		if dataItem.itemNode then
			if dataItem.dataType == chatConst.ctSelPlayerDataType.dt_groupBar then
				self:addToRecycledGroupList(dataItem.itemNode)
				dataItem.itemNode = nil
			else
				self:addToRecycledList(dataItem.itemNode)
				dataItem.itemNode = nil
			end
		end
	end
end
function chatRoomSelPlayersScroll:cleanAll()
	local removeCount = 0
	for i, v in ipairs(self.itemsData) do
		if v.itemNode then
			if v.dataType == chatConst.ctSelPlayerDataType.dt_groupBar then
				self:addToRecycledList(v.itemNode)
				v.itemNode = nil
			else
				self:addToRecycledList(v.itemNode)
				v.itemNode = nil
			end
			removeCount = removeCount + 1
		end
	end
	self.itemsData, _ENV = ipairs(self.itemsData)
	self:cleanMidList()
	self:stopAllActions()
end
function chatRoomSelPlayersScroll:saveHistory()
	self.historyData = self.itemsData
end
function chatRoomSelPlayersScroll:doRecycleHistory()
	for i, v in ipairs(self.historyData) do
		local dataItem = v
		if dataItem.itemNode then
			if dataItem.dataType == chatConst.ctSelPlayerDataType.dt_groupBar then
				self:addToRecycledGroupList(dataItem.itemNode)
				dataItem.itemNode = nil
			else
				self:addToRecycledList(dataItem.itemNode)
				dataItem.itemNode = nil
			end
		end
	end
	self.historyData, _ENV = ipairs(self.historyData)
end
function chatRoomSelPlayersScroll:reSizeScrollContent(width, height)
	print("function chatRoomSelPlayersScroll:reSizeScrollContent(width, height)------------------")
	self.scrollView:setContentSize(width, height)
	local scrollInner = self.scrollView:getInnerContainer()
	self.scrollView:setInnerContainerSize(width, height)
end
function chatRoomSelPlayersScroll:reSizeScrollContentHeight(height)
	print("function chatRoomSelPlayersScroll:reSizeScrollContentHeight(height)------------------")
	local width = self.scrollView:getContentSize().width
	self:reSizeScrollContent(width, height)
end
function chatRoomSelPlayersScroll:updateGroupBarTip()
	if #self.itemsData == 0 then
		return
	end
	local foundRet
	for i, v in ipairs(self.itemsData) do
		if v.dataType == chatConst.ctSelPlayerDataType.dt_groupBar and self:isGroupOutSideVisible(v) then
			foundRet = v
		end
	end
	local nextGroup
	if foundRet then
		local isNextGroup = false
		for i, v in ipairs(self.itemsData) do
			if isNextGroup == true and v.dataType == chatConst.ctSelPlayerDataType.dt_groupBar then
				nextGroup = v
				break
			end
			if v.dataType == chatConst.ctSelPlayerDataType.dt_groupBar and v == foundRet then
				isNextGroup = true
			end
		end
	end
	if foundRet then
		self.tipGroupBar:setVisible(true)
		self.tipGroupBar:initWithData(foundRet)
		local scrollInner = self.scrollView:getInnerContainer()
		local offsetY = -scrollInner:getPositionY()
		self.tipGroupBar:setPosition(cc.p(0, self.scrollView:getContentSize().height))
		if nextGroup then
			self:resetGroupTipPos(nextGroup)
		end
	else
		self.tipGroupBar:setVisible(false)
	end
end
function chatRoomSelPlayersScroll:isGroupOutSideVisible(data)
	local ret = false
	local scrollInner = self.scrollView:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scrollView:getContentSize().height
	_ENV = self.scrollView
	self.scrollView.beginY = math.max(0, offsetY - 0.0 * scrollH)
	local self.scrollView.endY, tableShowH = offsetY + 1.0 * scrollH, self.scrollView
	if data.itemPosY and data.itemPosY > tableShowH.endY - self.cellGroupHeight then
		ret = true
	end
	return ret
end
function chatRoomSelPlayersScroll:resetGroupTipPos(nextGroup)
	local scrollInner = self.scrollView:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scrollView:getContentSize().height
	_ENV = self.scrollView
	self.scrollView.beginY = math.max(0, offsetY - 0.0 * scrollH)
	local self.scrollView.endY, tableShowH = offsetY + 1.0 * scrollH, self.scrollView
	if nextGroup.itemPosY >= tableShowH.endY - 2 * self.cellGroupHeight and nextGroup.itemPosY <= tableShowH.endY - self.cellGroupHeight then
		local delta = nextGroup.itemPosY - (tableShowH.endY - 2 * self.cellGroupHeight)
		local tipPosY = self.tipGroupBar:getPositionY()
		self.tipGroupBar:setPositionY(tipPosY + delta)
	end
end
function chatRoomSelPlayersScroll:wrapAllData(data)
	local allianceMgr, itemsData
	local memberList = allianceMgr:getMemberList()
	local keytb = table.values(gAllianceRank)
	table.sort(keytb)
	local allianceMgr, tempKeytb = table.sort, table.sort
	for k, v in ipairs(keytb) do
		if v == gAllianceRank.R5 then
			table.insert(tempKeytb, #tempKeytb, v)
		else
			table.insert(tempKeytb, v)
		end
	end
	self.keytbCollapse, allianceMgr, self.keytb = ipairs(keytb)
	local allianceMgr, filterMap = ipairs(keytb)
	for i = #self.keytb, 1, -1 do
		local rank = self.keytb[i]
		local key = tostring(rank)
		self.keytbCollapse[key] = false
		if rank ~= 0 and memberList[key] and 0 < #memberList[key] then
			allianceMgr = nil
			;(nil).rankLv = rank
			local singleGroup = self:wrapSingleGroup(nil)
			table.insert(itemsData, #itemsData + 1, singleGroup)
			local members = memberList[key]
			for j, v in ipairs(members) do
				local singleData = self:wrapSingleData(v)
				singleData.rankLv = rank
				table.insert(itemsData, #itemsData + 1, singleData)
				filterMap[singleData.playerId] = true
			end
		end
	end
	if self.roomData then
		if not self.roomData.members then
			local allianceMgr, members = self.roomData.members, self.roomData.members
		end
		if not self.roomData.memberMap then
			local allianceMgr, memberMap = self.roomData.memberMap, self.roomData.memberMap
		end
		for i, v in ipairs(members) do
			if not filterMap[v] then
				filterMap[v] = true
				local player = memberMap[v]
				if player then
					self:addKingdomSingle(itemsData, player)
				end
			end
		end
	end
	self.allItemsData = itemsData
	return itemsData
end
function chatRoomSelPlayersScroll:wrapAllTeamData(members)
	dump(members, "members", 10)
	local _ENV, itemsData = dump, dump
	for _, v in ipairs(members) do
		if v.isIn then
			local singleData = self:wrapSingleTeamData(v)
			table.insert(itemsData, #itemsData + 1, singleData)
		end
	end
	self.allItemsData = itemsData
	return itemsData
end
function chatRoomSelPlayersScroll:wrapSingleTeamData(v)
	local name = v.nickName
	local allianceAbbr = v.allianceAbb
	if allianceAbbr ~= nil and string.len(allianceAbbr) > 0 then
		_ENV = nil
		;(nil).abbr = allianceAbbr
		;(nil).name = v.nickName
		name = i18n("common_text_186", nil)
	end
	if v.fromKid then
		name = name .. "#" .. tostring(v.fromKid)
	end
	_ENV = name
	name.dataType = chatConst.ctSelPlayerDataType.dt_player
	name.playerId = v.uid
	name.nickName = name
	name.isChecked = false
	name.isInRoom = false
	name.isOwner = false
	name.iconID = v.headid
	name.avatar = v.avatar
	local name.selPlayerOpType, data = self.roomData.selPlayerOpType, name
	if self.roomData and self.roomData.members and 0 < #self.roomData.members then
		for _, m in ipairs(self.roomData.members) do
			if tonumber(m) == tonumber(data.playerId) then
				data.isInRoom = true
			end
		end
	end
	if self.roomData and self.roomData.owner and data.playerId == self.roomData.owner then
		data.isOwner = true
	end
	return data
end
function chatRoomSelPlayersScroll:wrapAllTeamData_legend(members)
	dump(members, "members", 10)
	local _ENV, itemsData = dump, dump
	for _, v in ipairs(members) do
		if v.inBattleField then
			local singleData = self:wrapSingleTeamData(v)
			table.insert(itemsData, #itemsData + 1, singleData)
		end
	end
	self.allItemsData = itemsData
	return itemsData
end
function chatRoomSelPlayersScroll:wrapAllTeamData_atlantis(members)
	dump(members, "members", 10)
	local _ENV, itemsData = dump, dump
	for _, v in ipairs(members) do
		local singleData = self:wrapSingleTeamData(v)
		table.insert(itemsData, #itemsData + 1, singleData)
	end
	self.allItemsData = itemsData
	return itemsData
end
function chatRoomSelPlayersScroll:wrapFilterData()
	local _ENV, itemsData
	for i, v in ipairs(self.allItemsData) do
		if v.dataType == chatConst.ctSelPlayerDataType.dt_groupBar then
			table.insert(itemsData, #itemsData + 1, v)
		elseif v.dataType == chatConst.ctSelPlayerDataType.dt_player then
			local groupKey = tostring(v.rankLv)
			if v.isKingdom then
				groupKey = "kingdom"
			end
			if not self.keytbCollapse[groupKey] then
				table.insert(itemsData, #itemsData + 1, v)
			end
		end
	end
	dump(itemsData, "折叠后的数据=")
	return itemsData
end
function chatRoomSelPlayersScroll:wrapSingleData(v)
	chatConst = nil
	;(nil).dataType = chatConst.ctSelPlayerDataType.dt_player
	;(nil).playerId = v:getProperty("uid")
	;(nil).nickName = v:getProperty("nickName")
	;(nil).isChecked = false
	;(nil).isInRoom = false
	;(nil).isOwner = false
	;(nil).iconID = v:getProperty("iconID")
	;(nil).avatar = v:getProperty("avatar")
	;(nil).alv = v:getProperty("rank")
	;(nil).selPlayerOpType = self.roomData.selPlayerOpType
	;(nil).abbr = allianceMgr:getAllianceProperty("abbr")
	local (nil).sourceKid, data = v:getProperty("sourceKid"), nil
	if self.roomData and self.roomData.members and #self.roomData.members > 0 then
		for i, v in ipairs(self.roomData.members) do
			if tonumber(v) == tonumber(data.playerId) then
				data.isInRoom = true
			end
		end
	end
	if self.roomData and self.roomData.owner and data.playerId == self.roomData.owner then
		data.isOwner = true
	end
	if self.isShowOnline then
		data.isOnline = v:getProperty("online") == 0
	end
	if self:isPlayerCheck(data.playerId) and data.sourceKid == 0 then
		data.isChecked = true
	end
	return data
end
function chatRoomSelPlayersScroll:wrapSingleGroup(v)
	chatConst = nil
	;(nil).dataType = chatConst.ctSelPlayerDataType.dt_groupBar
	;(nil).rankLv = v.rankLv
	;(nil).isCollapse = false
	local (nil).isKingdom, data = v.isKingdom, nil
	return data
end
function chatRoomSelPlayersScroll:msgToggleGroupBar(target, data)
	print("function chatRoomSelPlayersScroll:msgToggleGroupBar(target, data)----------------")
	local rankLv = data.rankLv
	local isKingdom = data.isKingdom
	if not rankLv and not isKingdom then
		return
	end
	local groupKey = tostring(rankLv)
	if isKingdom then
		groupKey = "kingdom"
	end
	if not self.keytbCollapse[groupKey] then
		self.keytbCollapse[groupKey] = true
	else
		self.keytbCollapse[groupKey] = false
	end
	self:reloadScrollView()
end
function chatRoomSelPlayersScroll:reloadScrollView(...)
	self.reload = true
	self:saveHistory()
	self.itemsData = self:wrapFilterData()
	self:updateScrollView()
end
function chatRoomSelPlayersScroll:getSelPlayerList()
	local _ENV, itemsData
	local _ENV, playerIdList
	local _ENV, playerNameList
	for i, v in ipairs(self.allItemsData) do
		if v.dataType == chatConst.ctSelPlayerDataType.dt_player and v.isChecked then
			table.insert(itemsData, #itemsData + 1, v)
			table.insert(playerIdList, #playerIdList + 1, v.playerId)
			table.insert(playerNameList, #playerNameList + 1, v.nickName)
		end
	end
	if #itemsData == 0 then
		return nil
	end
	return itemsData, playerIdList, playerNameList
end
function chatRoomSelPlayersScroll:isPlayerCheck(playerId)
	if self.allItemsData then
		for i, v in ipairs(self.allItemsData) do
			if v.playerId == playerId and v.dataType == chatConst.ctSelPlayerDataType.dt_player and v.isChecked then
				return true
			end
		end
	end
	return false
end
function chatRoomSelPlayersScroll:getSingleItemGroupBar(rankLv)
	if self.allItemsData then
		for i, v in ipairs(self.allItemsData) do
			if v.rankLv == rankLv and v.dataType == chatConst.ctSelPlayerDataType.dt_groupBar then
				return v.itemNode
			end
		end
	end
end
function chatRoomSelPlayersScroll:sMsgLordAccurateSearchBack(target, event)
	dump(event, "==chatRoomSelPlayersScroll:sMsgLordAccurateSearchBack==")
	local player = event.data
	if not player then
		SoraDShowMsgTip(i18n("chat_text_79"))
		return
	end
	if player.sourceKid ~= 0 then
		SoraDShowMsgTip(i18n("chat_text_79"))
		return
	end
	if not self.allItemsData then
		local _ENV, itemsData = self.allItemsData, self.allItemsData
	end
	for i, v in ipairs(itemsData) do
		if v.playerId == player.uid and v.dataType == chatConst.ctSelPlayerDataType.dt_player then
			if v.isInRoom or v.isChecked then
				SoraDShowMsgTip(i18n("chat_text_83"))
				return
			end
			if v.sourceKid ~= 0 then
				SoraDShowMsgTip(i18n("chat_text_79"))
				return
			end
			if v.itemNode then
				v.itemNode:setSelected(true)
				_ENV = v.itemNode
				v.itemNode.msg = "MESSAGE_CHAT_ROOM_UPDATE_SELMEMBERS"
				v.itemNode.curItem = v.itemNode
				SoraDSendMessage(v.itemNode)
			else
				v.isChecked = true
				local groupKey = tostring(v.rankLv)
				if v.isKingdom then
					groupKey = "kingdom"
				end
				if self.keytbCollapse[groupKey] then
					self.keytbCollapse[groupKey] = false
					local itemNode = self:getSingleItemGroupBar(v.rankLv)
					if itemNode then
						itemNode:setIsCollapse(false)
					end
					self:reloadScrollView()
				end
				_ENV = self.reloadScrollView
				self.reloadScrollView.msg = "MESSAGE_CHAT_ROOM_UPDATE_SELMEMBERS"
				SoraDSendMessage(self.reloadScrollView)
			end
			SoraDShowMsgTip(i18n("chat_text_82"))
			if self.searchWidget then
				self.searchWidget:resetInput()
			end
			return
		end
	end
	local constantRead = include("constantRead")
	local value = constantRead.getConstValue("MULTICHAT_SWITCH", 0)
	if value == 0 then
		SoraDShowMsgTip(i18n("chat_text_79"))
		return
	end
	self:addKingdomSingle(itemsData, player)
	self.allItemsData = itemsData
	self:reloadScrollView()
	_ENV = self
	self.msg = "MESSAGE_CHAT_ROOM_UPDATE_SELMEMBERS"
	SoraDSendMessage(self)
	SoraDShowMsgTip(i18n("chat_text_82"))
	if self.searchWidget then
		self.searchWidget:resetInput()
	end
end
function chatRoomSelPlayersScroll:addKingdomSingle(itemsData, player)
	local groupKey = "kingdom"
	if self.keytbCollapse[groupKey] == nil then
		_ENV = nil
		;(nil).isKingdom = true
		local singleGroup = self:wrapSingleGroup(nil)
		table.insert(itemsData, singleGroup)
	end
	self.keytbCollapse[groupKey] = false
	local singleData = self:wrapSingleKingdomData(player)
	singleData.isKingdom = true
	if player.sourceKid == 0 then
		singleData.isChecked = true
	end
	table.insert(itemsData, singleData)
end
function chatRoomSelPlayersScroll:wrapSingleKingdomData(v)
	chatConst = nil
	;(nil).dataType = chatConst.ctSelPlayerDataType.dt_player
	;(nil).playerId = v.uid
	;(nil).nickName = v.nickName
	;(nil).isChecked = false
	;(nil).isInRoom = false
	;(nil).isOwner = false
	;(nil).iconID = v.iconID or v.imageId
	;(nil).avatar = v.avatar
	;(nil).selPlayerOpType = self.roomData.selPlayerOpType
	;(nil).abbr = v.allianceAbbr
	;(nil).sourceKid = v.sourceKid
	local (nil).isKingdom, data = true, nil
	if self.roomData and self.roomData.members and #self.roomData.members > 0 then
		for i, v in ipairs(self.roomData.members) do
			if tonumber(v) == tonumber(data.playerId) then
				data.isInRoom = true
			end
		end
	end
	if self.roomData and self.roomData.owner and data.playerId == self.roomData.owner then
		data.isOwner = true
	end
	if self.isShowOnline then
		data.isOnline = v:getProperty("online") == 0
	end
	if self:isPlayerCheck(data.playerId) and data.sourceKid == 0 then
		data.isChecked = true
	end
	return data
end
function chatRoomSelPlayersScroll:setSearchWidget(searchWidget)
	self.searchWidget = searchWidget
end
return chatRoomSelPlayersScroll
