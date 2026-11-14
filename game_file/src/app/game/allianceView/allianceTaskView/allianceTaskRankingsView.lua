local gametop = gModuleMgr.getObject("gametop")
local playerMobilizationCtrl = gametop.playertop_:getModule("playerMobilizationCtrl")
local mobilizationltCtrl = gModuleMgr.sharedMgr("mobilizationltCtrl")
local allianceTaskRankingsView = class("allianceTaskRankingsView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceTaskRankingsView")
	end
	if type(target) == "string" then
		return SoraDCreateBasePanel(target)
	end
	return target
end)
function allianceTaskRankingsView:ctor()
	self.Top_Size_Tile_Image_bg = SoraDGetChildByName(self, "Top_Size_Tile_Image_bg")
	self.Top_Size_Image_2 = SoraDGetChildByName(self, "Top_Size_Image_2")
	self.commonFramTitle_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle")
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.btn_alliance = SoraDGetChildByName(self, "btn_alliance")
	self.btn_player = SoraDGetChildByName(self, "btn_player")
	self.frame_line_l = SoraDGetChildByName(self, "frame_line_l")
	self.frame_line_r = SoraDGetChildByName(self, "frame_line_r")
	self.Image_info = SoraDGetChildByName(self, "Image_info")
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_donation = SoraDGetChildByName(self, "Text_donation")
	self.Text_score = SoraDGetChildByName(self, "Text_score")
	self.Text_rank_user = SoraDGetChildByName(self, "Text_rank_user")
	self.Text_name_alliance = SoraDGetChildByName(self, "Text_name_alliance")
	self.Text_rank_alliance = SoraDGetChildByName(self, "Text_rank_alliance")
	self.Text_score_alliance = SoraDGetChildByName(self, "Text_score_alliance")
	self.Button_award = SoraDGetChildByName(self, "Button_award")
	self.Button_award:setSwallowTouches(true)
	self.Top_Size_ScrollView_rank = SoraDGetChildByName(self, "Top_Size_ScrollView_rank")
	self.Top_Size_ScrollView_alliance = SoraDGetChildByName(self, "Top_Size_ScrollView_alliance")
	self.node_title_alliance = SoraDGetChildByName(self, "node_title_alliance")
	self.node_title_user = SoraDGetChildByName(self, "node_title_user")
	self.node_bottom = SoraDGetChildByName(self, "Bottom_Node")
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.btn_alliance:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btn_player:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.Button_award:addTouchEventListener(handler(self, self.onClick_Button_award))
	self.commonFramTitle_title:setTitle(i18n("common_text_3571"))
	self.commonFramTitle_title:setTitleSize()
	self.tabBtn, _ENV, self.tableSpare, _ENV, self.tableRankData, _ENV = self.commonFramTitle_title.setTitleSize, self.commonFramTitle_title.setTitleSize, self.commonFramTitle_title.setTitleSize, self.commonFramTitle_title.setTitleSize, self.commonFramTitle_title.setTitleSize, self.commonFramTitle_title.setTitleSize
	self.timer = nil
	self.ownRank = 0
	self.ownPosY = 0
	self.curType = gMobilizationRankType.ALLIANCE
	self.tabBtn[gMobilizationRankType.ALLIANCE] = self.btn_alliance
	self.tabBtn[gMobilizationRankType.PLAYER] = self.btn_player
	self.tabBtn[gMobilizationRankType.ALLIANCE]:setTitleText(i18n("common_text_1153"))
	self.tabBtn[gMobilizationRankType.PLAYER]:setTitleText(i18n("common_text_3572"))
	self.scroll = self.Top_Size_ScrollView_rank
	self.curBtn = self.tabBtn[gMobilizationRankType.ALLIANCE]
	self.curBtn:setTitleColor(cc.c3b(255, 200, 100))
	self.curBtn:setBright(true)
	self.curBtn:setTouchEnabled(false)
	self.tabBtn[gMobilizationRankType.PLAYER]:setBright(false)
	self.tabBtn[gMobilizationRankType.PLAYER]:setTitleColor(cc.c3b(100, 80, 40))
	self.tabBtn[gMobilizationRankType.PLAYER]:setTouchEnabled(true)
	_ENV = self.tabBtn[gMobilizationRankType.PLAYER].setTouchEnabled
	self.tabBtn[gMobilizationRankType.PLAYER].setTouchEnabled[gMobilizationRankType.ALLIANCE] = false
	self.requestFlag, self.tabBtn[gMobilizationRankType.PLAYER].setTouchEnabled[gMobilizationRankType.PLAYER] = self.tabBtn[gMobilizationRankType.PLAYER].setTouchEnabled, false
	self:init()
	self.Text_name_alliance:setString(i18n("common_text_3155"))
	self.Text_score_alliance:setString(i18n("common_text_3156"))
	self.Text_rank_alliance:setString(i18n("common_text_3154"))
	self.Text_name:setString(i18n("common_text_3155"))
	self.Text_score:setString(i18n("common_text_3156"))
	self.Text_rank_user:setString(i18n("common_text_3154"))
	self.Text_donation:setString(i18n("common_text_3693"))
	SoraDGetAutoHeightLabel(self.Text_donation, 150)
	self.node_title_alliance:setVisible(true)
	self.node_title_user:setVisible(false)
	self.itemsData, _ENV, self.scrollView = self.Top_Size_ScrollView_alliance, self.Top_Size_ScrollView_alliance, self.Top_Size_ScrollView_alliance
	self.heightNotice = 52
	self.heightEnableNotice = 55
	self.fromLoadText = false
	self.recycledList, _ENV, self.heightTopAutoScroll = self.Top_Size_ScrollView_alliance, self.Top_Size_ScrollView_alliance, 100
	self.loadingSprite = display.newSprite("SinglePicture/loading1.png")
	self.labelNotice:getParent():addChild(self.loadingSprite, 1, "loadingSprite")
	self.paddingXLoadingSprite = 25
	self.loadingSprite:setScale(25 / self.loadingSprite:getContentSize().width)
	self.loadingSprite:setAnchorPoint(cc.p(0.5, 0.5))
	self.loadingSprite:setPositionX(self:getLoadingSpriteXPos())
	self.loadingSprite:setPositionY(self.labelNotice:getPositionY() + self.labelNotice:getContentSize().height / 2)
	self.labelNotice:setVisible(true)
	self.labelNotice:setString(i18n("common_text_089"))
	self.loadingSprite:setVisible(false)
	self.scrollView:addEventListener(handler(self, self.scrollEventCallBack))
	self.Top_Size_ScrollView_rank:setVisible(false)
	self.ownRankAlliance = 0
	self.ownRank = 0
	self.textNoRankTip = SoraDGetChildByName(self, "text_no_rank_tip")
	SoraDAutoSizeButtonText(self.tabBtn[gMobilizationRankType.ALLIANCE], cc.size(234, 41))
	SoraDAutoSizeButtonText(self.tabBtn[gMobilizationRankType.PLAYER], cc.size(234, 41))
end
function allianceTaskRankingsView:init(data)
	self:requestData()
end
function allianceTaskRankingsView:requestData()
	if self.curType == gMobilizationRankType.ALLIANCE then
		print("请求联盟排行榜------")
		playerMobilizationCtrl:reqGroupRankInfo(1)
		self.requestFlag[gMobilizationRankType.ALLIANCE] = true
	else
		print("请求玩家贡献榜------")
		playerMobilizationCtrl:reqRankInfo()
		self.requestFlag[gMobilizationRankType.PLAYER] = true
	end
end
function allianceTaskRankingsView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TASK_RANK_INFO_BACK", handler(self, self.sMsgTaskRankInfoBack))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TASK_USER_INFO_BACK", handler(self, self.sMsgTaskUsereInfoBack))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
end
function allianceTaskRankingsView:sMsgReqInfoBack(target, data)
	print("请求查看联盟信息回来了")
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "allianceTaskRankingsView" then
			local kid = alliance:getProperty("sourceKid")
			SoraDOpenAllianceInfoView(alliance, kid)
		end
	end
end
function allianceTaskRankingsView:updateRank()
	self.node_bottom:setPositionY(0)
	if not self.node_bottom:getChildByName("ownRankSingle") then
		local itemNode = SoraDCreatePanel("allianceTaskRankOwn")
		itemNode:setName("ownRankSingle")
		itemNode:addTo(self.node_bottom)
	end
	if self.curType == gMobilizationRankType.ALLIANCE then
		if self.tableRankDataAlliance and self.ownRankAlliance and self.tableRankDataAlliance[self.ownRankAlliance] then
			local itemNode = self.node_bottom:getChildByName("ownRankSingle")
			itemNode:init(self.tableRankDataAlliance[self.ownRankAlliance], -1, gMobilizationRankType.ALLIANCE)
			itemNode:setPosition(cc.p(0, 0))
			self.textNoRankTip:setVisible(false)
		else
			if SoraDGetChildByName(self.node_bottom, "ownRankSingle") then
				self.node_bottom:removeChildByName("ownRankSingle", true)
			end
			self.textNoRankTip:setVisible(true)
			_ENV = cc.p(0, 0)
			cc.p(0, 0).rank = i18n("common_text_827")
			self.textNoRankTip:setString(i18n("common_text_3574", cc.p(0, 0)))
		end
	elseif self.tableRankData and self.ownRank and self.tableRankData[self.ownRank] ~= nil then
		local itemNode = self.node_bottom:getChildByName("ownRankSingle")
		itemNode:init(self.tableRankData[self.ownRank], -1, gMobilizationRankType.PLAYER)
		itemNode:setPosition(cc.p(0, 0))
		self.textNoRankTip:setVisible(false)
	else
		if SoraDGetChildByName(self.node_bottom, "ownRankSingle") then
			self.node_bottom:removeChildByName("ownRankSingle", true)
		end
		self.textNoRankTip:setVisible(true)
		_ENV = cc.p(0, 0)
		cc.p(0, 0).rank = i18n("common_text_827")
		self.textNoRankTip:setString(i18n("common_text_825", cc.p(0, 0)))
	end
end
function allianceTaskRankingsView:reloadScrollViewAlliance()
	if not playerMobilizationCtrl:getGroupRankInfo().rankdata then
		playerMobilizationCtrl = playerMobilizationCtrl:getGroupRankInfo().rankdata
	end
	self.tableRankDataAlliance = playerMobilizationCtrl:getGroupRankInfo().rankdata
	self.ownRankAlliance = playerMobilizationCtrl:getGroupRankInfo().currank
	print("联盟自己的排名, ", self.ownRankAlliance)
	if not self.ownRankAlliance then
		self.ownRankAlliance = 0
	end
	self:updateRank()
	self:recycleAllNodes()
	print("#self.tableRankDataAlliance = ", self.tableRankDataAlliance)
	if self.tableRankDataAlliance then
		for i, v in ipairs(self.tableRankDataAlliance) do
			if not self.itemsData[i] then
				playerMobilizationCtrl = nil
				self.itemsData[i], (nil).rankData = nil, v
				self.itemsData[i].itemWidth = 640
				self.itemsData[i].itemHeight = 120
			end
		end
	end
	self:updateScrollSize()
	self:updateScrollCell()
end
function allianceTaskRankingsView:updateScrollSize()
	local scrollInner = self.scrollView:getInnerContainer()
	local minOffsetY = -(scrollInner:getContentSize().height - self.scrollView:getContentSize().height)
	local offsetY = scrollInner:getPositionY()
	local totalHeight = 0
	for i, v in ipairs(self.itemsData) do
		totalHeight = totalHeight + v.itemHeight
	end
	print("#self.itemsData = ", #self.itemsData, ", totalHeight = ", totalHeight)
	local scrollInnerHeight = math.max(self.heightNotice + totalHeight, self.scrollView:getContentSize().height)
	print("scrollInnerHeight = ", scrollInnerHeight)
	local accumulateHeight = 0
	for i, v in ipairs(self.itemsData) do
		v.itemPosX = 320
		v.itemPosY = scrollInnerHeight - accumulateHeight
		accumulateHeight = accumulateHeight + v.itemHeight
		if v.itemNode then
			v.itemNode:setPositionY(v.itemPosY)
			v.itemNode:setPositionX(v.itemPosX)
		end
	end
	self.labelNotice:setPosition(self.labelNotice:getPositionX(), 13)
	self.loadingSprite:setPositionX(self:getLoadingSpriteXPos())
	self.loadingSprite:setPositionY(self.labelNotice:getPositionY() + self.labelNotice:getContentSize().height / 2)
	local totalCellHeight = scrollInnerHeight
	local scrollContentSize = self.scrollView:getContentSize()
	if totalCellHeight < scrollContentSize.height then
	end
	local scrollInnerNewH = totalCellHeight
	scrollInnerNewH = scrollInnerNewH + 10
	local bNeedAutoScrollTop = false
	if minOffsetY <= offsetY and offsetY <= minOffsetY + self.heightTopAutoScroll then
		bNeedAutoScrollTop = true
	end
	offsetY = offsetY - (scrollInnerNewH - scrollInner:getContentSize().height)
	self.scrollView:setInnerContainerSize(cc.size(scrollInner:getContentSize().width, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
	if bNeedAutoScrollTop then
	end
end
function allianceTaskRankingsView:updateScrollCell()
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
				self:addToRecycledList(v.itemNode)
				v.itemNode = nil
			else
			end
		elseif tableShowH.beginY <= v.itemPosY and tableShowH.endY >= v.itemPosY then
			local itemNode, isFromRecycle = self:getItem(v)
			v.itemNode = itemNode
			v.itemNode:setPosition(v.itemPosX, v.itemPosY)
			if isFromRecycle == false then
				v.itemNode:addTo(self.scrollView)
			end
		end
	end
	if offsetY < -self.heightEnableNotice then
		self.fromLoadText = true
		self.labelNotice:setString(i18n("common_text_084"))
		self.loadingSprite:setPositionX(self:getLoadingSpriteXPos())
		self.loadingSprite:setPositionY(self.labelNotice:getPositionY() + self.labelNotice:getContentSize().height / 2)
	end
end
function allianceTaskRankingsView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:updateScrollCell()
	elseif event == ccui.ScrollviewEventType.bounceBottom then
		if self.fromLoadText then
			self.fromLoadText = false
			self:requestMore()
			if self.hasMore then
				self.labelNotice:setString(i18n("common_text_089"))
				self.loadingSprite:setPositionX(self:getLoadingSpriteXPos())
				self.loadingSprite:setPositionY(self.labelNotice:getPositionY() + self.labelNotice:getContentSize().height / 2)
			else
				self.labelNotice:setString(i18n("common_text_085"))
				self.loadingSprite:setPositionX(self:getLoadingSpriteXPos())
				self.loadingSprite:setPositionY(self.labelNotice:getPositionY() + self.labelNotice:getContentSize().height / 2)
			end
		end
	elseif event == ccui.ScrollviewEventType.bounceTop then
	end
end
function allianceTaskRankingsView:addToRecycledList(cell)
	cell:setVisible(false)
	table.insert(self.recycledList, cell)
end
function allianceTaskRankingsView:hasAnyRecycledCell()
	local result = false
	if #self.recycledList > 0 then
		result = true
		return result
	end
	return result
end
function allianceTaskRankingsView:pickCellFromRecycledList()
	local cell
	if #self.recycledList > 0 then
		cell = table.remove(self.recycledList)
		cell:setVisible(true)
	end
	return cell
end
function allianceTaskRankingsView:createItem(data)
	local itemNode = SoraDCreatePanel("allianceTaskRankingsSingle")
	itemNode:init(data.rankData, -1, gMobilizationRankType.ALLIANCE)
	itemNode:setScroll(self.scrollView)
	return itemNode
end
function allianceTaskRankingsView:getItem(data)
	local cell
	local isFromRecycle = false
	if self:hasAnyRecycledCell() == true then
		cell = self:pickCellFromRecycledList()
		cell:init(data.rankData, -1, gMobilizationRankType.ALLIANCE)
		isFromRecycle = true
	else
		cell = self:createItem(data)
	end
	return cell, isFromRecycle
end
function allianceTaskRankingsView:reloadScrollView()
	print("allianceTaskRankingsView:reloadScrollView()-----")
	self.ownRank = 0
	if self.curType == gMobilizationRankType.ALLIANCE then
	elseif self.curType == gMobilizationRankType.PLAYER then
		self.tableRankData = playerMobilizationCtrl:getAllianceRankInfo().rankdata
		self.ownRank = playerMobilizationCtrl:getAllianceRankInfo().currank
		dump(self.tableRankData, "盟友贡献数据排行榜", 10)
	end
	if self.ownRank == nil then
		self.ownRank = 0
	end
	if self.tableRankData == nil then
		self.tableRankData, _ENV = self.tableRankData, self.tableRankData
	end
	local scrollH = math.max(self.scroll:getContentSize().height, 122 * #self.tableRankData)
	self:updateRank()
	for i, v in ipairs(self.tableRankData) do
		local single = self.tableSpare[i]
		if single == nil then
			single = SoraDCreatePanel("allianceTaskRankingsSingle")
			single:addTo(self.scroll)
			self.tableSpare[i] = single
		end
		single:init(v, i, self.curType)
		single:setPosition(cc.p(320, scrollH - (i - 1) * 122 - 5))
		single:setVisible(true)
	end
	if #self.tableRankData < #self.tableSpare then
		for i = #self.tableRankData + 1, #self.tableSpare do
			if self.tableSpare[i] then
				self.tableSpare[i]:setVisible(false)
			end
		end
	end
	self.scroll:setInnerContainerSize(cc.size(640, scrollH))
	self.ownPosY = scrollH - 122 * self.ownRank - 0.5 * self.scroll:getContentSize().height
	self.scroll:jumpToTop()
end
function allianceTaskRankingsView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:updateTabBtn(true)
		self.curBtn = button
		self:updateTabBtn(false)
	end
end
function allianceTaskRankingsView:updateTabBtn(tabOpen)
	self.curBtn:setTouchEnabled(tabOpen)
	self.curBtn:setBright(not tabOpen)
	self.curBtn:setTitleColor(tabOpen and cc.c3b(100, 80, 40) or cc.c3b(255, 200, 100))
	if not tabOpen then
		for i, v in ipairs(self.tabBtn) do
			if v == self.curBtn then
				self.curType = i
				print("self.curType = ", self.curType)
				dump(self.requestFlag, "requestFlag")
				if not self.requestFlag[self.curType] then
					self:requestData()
				else
				end
				if self.curType == gMobilizationRankType.ALLIANCE then
					self.node_title_alliance:setVisible(true)
					self.node_title_user:setVisible(false)
					self.scrollView:setVisible(true)
					SoraDGetChildByName(self, "Image_1"):setVisible(true)
					self:updateRank()
				else
					self.node_title_alliance:setVisible(false)
					self.node_title_user:setVisible(true)
					self.Top_Size_ScrollView_rank:setVisible(true)
					self.scrollView:setVisible(false)
					SoraDGetChildByName(self, "Image_1"):setVisible(false)
					self:reloadScrollView()
					print("显示玩家排行--------")
					self:updateRank()
				end
			else
				v:setTouchEnabled(not tabOpen)
				v:setBright(tabOpen)
				v:setTitleColor(not tabOpen and cc.c3b(100, 80, 40) or cc.c3b(255, 200, 100))
			end
		end
	else
		for i, v in ipairs(self.tableSpare) do
			if v then
				v:setVisible(false)
			end
		end
	end
end
function allianceTaskRankingsView:sMsgTaskRankInfoBack(target, data)
	if self.curType == gMobilizationRankType.ALLIANCE then
		print("联盟排行榜数据返回-----------")
		dump(data)
		self:hideLoadingSprite()
		local hasMore = data.hasMore
		self.hasMore = hasMore
		if hasMore then
			self:reloadScrollViewAlliance()
		else
			self.labelNotice:setString(i18n("common_text_085"))
		end
	end
end
function allianceTaskRankingsView:sMsgTaskUsereInfoBack(target, data)
	if self.curType == gMobilizationRankType.PLAYER then
		print("盟友数据排行返回了--------------")
		self:reloadScrollView()
	end
end
function allianceTaskRankingsView:btnJumpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		do return end
		self.labelRank:setScale(1.0)
		SoraDPlaySound()
		self:stopAllActions()
		local scrollPercent = 100 * (1 - self.ownPosY / (self.scroll:getInnerContainerSize().height - self.scroll:getContentSize().height))
		scrollPercent = math.min(100, math.max(0, scrollPercent))
		local scrollH = self.scroll:getContentSize().height
		if math.abs(self.ownPosY + self.scroll:getInnerContainer():getPositionY()) < 0.5 * scrollH then
			self.scroll:scrollToPercentVertical(scrollPercent, 0.2, true)
		else
			_UPVALUE2_ = 0.2
			;(0.2)[1] = cca.callFunc(function(...)
				self.scroll:scrollToPercentVertical(scrollPercent + 0.5, 0.2, false)
			end)
			;(0.2)[2] = cca.delay(0.3)
			;(0.2)[3] = cca.callFunc(function(...)
				self.scroll:scrollToPercentVertical(scrollPercent, 0.1, true)
			end)
			;(0.2)[4] = cca.callFunc(function(...)
				self.scroll:scrollToPercentVertical(scrollPercent, 0.1, true)
			end)
			self:runAction(cca.seq(0.2))
		end
	elseif type == ccui.TouchEventType.began then
		self.labelRank:setScale(1.1)
	elseif type == ccui.TouchEventType.canceled then
		self.labelRank:setScale(1.0)
	end
end
function allianceTaskRankingsView:onClick_btn_alliance(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
	end
end
function allianceTaskRankingsView:onClick_btn_player(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
	end
end
function allianceTaskRankingsView:onClick_Button_jump(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		self:btnJumpClickCallBack(sender, event)
	end
end
function allianceTaskRankingsView:onClick_Button_award(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("allianceTaskGroupRankView"):show()
	end
end
function allianceTaskRankingsView:requestMore()
	if self.hasMore == false then
		print("没有更多消息了，不再请求-------------")
		self.labelNotice:setString(i18n("common_text_085"))
		return
	else
		print("TODO:请求联盟排行榜数据-------")
		local nextIndex = #self.itemsData + 1
		self:showLoadingSprite()
		print("请求排行榜数据:nextIndex", nextIndex)
		playerMobilizationCtrl:reqGroupRankInfo(nextIndex)
	end
end
function allianceTaskRankingsView:showLoadingSprite()
	if self.loadingSprite then
		self.loadingSprite:setVisible(true)
		self.loadingSprite:stopAllActions()
		local actionRotateBy = cc.RotateBy:create(1.0, 360)
		local repeatForever = cca.repeatForever(actionRotateBy)
		self.loadingSprite:runAction(repeatForever)
	end
end
function allianceTaskRankingsView:hideLoadingSprite()
	self.loadingSprite:stopAllActions()
	self.loadingSprite:setVisible(false)
end
function allianceTaskRankingsView:recycleAllNodes()
	for i, v in ipairs(self.itemsData) do
		if v.itemNode then
			self:addToRecycledList(v.itemNode)
			v.itemNode = nil
		end
	end
end
function allianceTaskRankingsView:getLoadingSpriteXPos()
	if SoraDFIsRA() then
		return self.labelNotice:getPositionX() + (self.labelNotice:getContentSize().width / 2 + self.paddingXLoadingSprite)
	else
		return self.labelNotice:getPositionX() - (self.labelNotice:getContentSize().width / 2 + self.paddingXLoadingSprite)
	end
end
return allianceTaskRankingsView
