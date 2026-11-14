local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local AllianceBuildMainArmyView = class("allianceBuildMainArmyView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceBuildMainArmyView")
	end
	return target
end)
function AllianceBuildMainArmyView:ctor()
	self.tableDataState, _ENV, self.tableSpare, _ENV, self.instanceData, _ENV, self.tableSingle, _ENV, self.tableRallyData, _ENV = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.nodeTitle:setTitle(i18n("common_text_3023"))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_army")
	self.labelCount = SoraDGetChildByName(self, "Text_count")
	self.labelNotice = SoraDGetChildByName(self, "Center_Text_notice")
	self.labelNotice:setString(i18n("common_text_3025"))
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
end
function AllianceBuildMainArmyView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_BUILDING_DESTROY", handler(self, self.judgeCloseView))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_MOVELINE_ADD", handler(self, self.OnMapMoveLineChange))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_MOVELINE_REMOVE", handler(self, self.OnMapMoveLineChange))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_REQUEST_OBJECT_INFO", handler(self, self.serverMessage_RequestMapInstaceInfo))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_MEMBER_UPDATE", handler(self, self.judgeBeQuit))
end
function AllianceBuildMainArmyView:judgeBeQuit(target, data)
	if not allianceMgr:hasJoinAlliance() then
		self:removeFromParent()
	end
end
function AllianceBuildMainArmyView:judgeCloseView(target, data)
	if data.id == self.tableRallyData.id then
		self:removeFromParent()
	end
end
function AllianceBuildMainArmyView:serverMessage_RequestMapInstaceInfo(target, data)
	if not (data and data.data and next(data.data)) or not data.data.build then
		return
	end
	if data.data.build.id == self.tableRallyData.id then
		self.tableRallyData = data.data.build
		for i, v in ipairs(self.tableSingle) do
			if v.point then
				table.insert(self.tableSpare, v.point)
				v.point:setVisible(false)
				v.point = nil
			end
		end
		self.tableSingle, _ENV = ipairs(self.tableSingle)
		self:initScrollData()
		self:updateScrollView()
		self:scrollOnScrollView()
	end
end
function AllianceBuildMainArmyView:OnMapMoveLineChange(target, data)
	local isChange = false
	if data.msg == "MESSAGE_SERVER_WORLD_MAP_MOVELINE_ADD" then
		for i, v in ipairs(data.data) do
			for _, value in ipairs(self.tableRallyData.guards) do
				if v.orgQueueId == value.queueId then
					isChange = true
					break
				end
			end
			if isChange then
				break
			end
		end
	elseif data.msg == "MESSAGE_SERVER_WORLD_MAP_MOVELINE_REMOVE" then
		for i, v in ipairs(data.data) do
			if v.to and v.to.id == self.instanceData.id then
				isChange = true
				break
			end
		end
	end
	if isChange and self.instanceData.x then
		kingdomMapCtrl:reqMapObjInfo(self.instanceData.x, self.instanceData.y, self.instanceData.id, self.instanceData.kingdomId)
	end
end
function AllianceBuildMainArmyView:initData(data, instanceData)
	dump(data, "AllianceBuildMainArmyView:initData")
	self.tableRallyData = data
	self.instanceData = instanceData
	self:initScrollData()
	self:updateScrollView()
	self.scroll:jumpToTop()
	self:scrollOnScrollView()
end
function AllianceBuildMainArmyView:initScrollData()
	for i, v in ipairs(self.tableRallyData.guards) do
		local isLaunched = false
		if self.tableDataState[v.queueId] then
			isLaunched = true
		end
		_ENV = nil
		;(nil).point = nil
		;(nil).data = v
		;(nil).isLaunched = isLaunched
		;(nil).singleH = 120
		;(nil).posY = 0
		table.insert(self.tableSingle, 1, nil)
	end
	self.labelNotice:setVisible(#self.tableRallyData.guards <= 0)
	_ENV = nil
	;(nil).name = i18n("common_text_598")
	_ENV = self.tableSingle
	self.tableSingle.total = string.formatnumberthousands(self.tableRallyData.guardArmyCapacity)
	self.tableSingle.member = string.formatnumberthousands(self.tableRallyData.guardArmyTotalNum)
	;(nil).msg = i18n("common_text_155", self.tableSingle)
	self.labelCount:setString(i18n("common_text_1000", nil))
end
function AllianceBuildMainArmyView:scrollOnScrollView()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 3 * scrollH)
	local self.scroll.endY, tableShowH = offsetY + 3 * scrollH, self.scroll
	for i, v in ipairs(self.tableSingle) do
		if v.point then
			if v.posY < tableShowH.beginY or v.posY > tableShowH.endY then
				table.insert(self.tableSpare, v.point)
				v.point:setVisible(false)
				v.point = nil
			end
		elseif tableShowH.beginY <= v.posY and tableShowH.endY >= v.posY then
			if 0 < #self.tableSpare then
				v.point = table.remove(self.tableSpare)
				v.point:setVisible(true)
			else
				local single = SoraDCreatePanel("allianceBuildMainArmySingle")
				single:setScroll(self.scroll)
				single:addTo(self.scroll)
				single:setClickCallBack(handler(self, self.updateScrollView))
				v.point = single
			end
			v.point:initData(v.data)
			v.point:setState(v.isLaunched)
			v.point:setPosition(cc.p(320, v.posY))
		end
	end
end
function AllianceBuildMainArmyView:updateScrollView(isLaunched, queueId)
	if queueId then
		self.tableDataState[queueId] = isLaunched
	end
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollInnerNewH = 0
	for i, v in ipairs(self.tableSingle) do
		v.posY = scrollInnerNewH + v.singleH
		if v.point then
			v.point:initData(v.data, v.type)
			v.isLaunched = v.point:getState()
			v.singleH = v.point:getSingleH()
			v.posY = scrollInnerNewH + v.singleH
			v.point:setPositionY(v.posY)
		end
		scrollInnerNewH = v.posY
	end
	if scrollInnerNewH < self.scroll:getContentSize().height then
		local upto = self.scroll:getContentSize().height - scrollInnerNewH
		for i, v in ipairs(self.tableSingle) do
			v.posY = v.posY + upto
			if v.point then
				v.point:setPositionY(v.posY)
			end
		end
		scrollInnerNewH = self.scroll:getContentSize().height
	end
	offsetY = math.min(0, offsetY - (scrollInnerNewH - scrollInner:getContentSize().height))
	self.scroll:setInnerContainerSize(cc.size(640, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
end
function AllianceBuildMainArmyView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:scrollOnScrollView()
	end
end
return AllianceBuildMainArmyView
