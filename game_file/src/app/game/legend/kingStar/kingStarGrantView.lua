local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local kingStarCtrl = gametop.playertop_:getModule("kingStarCtrl")
local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
local nationalFlagRead = include("nationalFlagRead")
local legendKingRead = include("legendKingRead")
_ENV = "legendKingRead"
;("legendKingRead").kingdom = 1
local ("legendKingRead").lord, LEGENDLORD_GRANT_TYPE = 2, "legendKingRead"
local kingStarGrantView = class("kingStarGrantView", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("kingStarGrantView")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function kingStarGrantView:ctor()
	self.isHideCurrentSceneView = true
	self:createUI()
	self.Top_Node_Info = SoraDGetChildByName(self, "Top_Node_Info")
	self.bg_activity_king = SoraDGetChildByName(self, "bg_activity_king")
	self.Sprite_sheer_L = SoraDGetChildByName(self, "Sprite_sheer_L")
	self.Sprite_sheer_R = SoraDGetChildByName(self, "Sprite_sheer_R")
	self.node_touxian = SoraDGetChildByName(self, "node_touxian")
	self.node_headBig = SoraDGetChildByName(self, "node_headBig")
	self.Icon_king_head = SoraDGetChildByName(self, "Icon_king_head")
	self.node_worldKing = SoraDGetChildByName(self, "node_worldKing")
	self.node_headbig_king = SoraDGetChildByName(self, "node_headbig_king")
	self.Icon_king = SoraDGetChildByName(self, "Icon_king")
	self.Top_Node_Decorator = SoraDGetChildByName(self, "Top_Node_Decorator")
	self.Text_Status_Title = SoraDGetChildByName(self, "Text_Status_Title")
	self.commonFramTitle_node = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_node")
	self.sprite_sheer_top = SoraDGetChildByName(self, "sprite_sheer_top")
	self.Size_bg_Image_pp = SoraDGetChildByName(self, "Size_bg_Image_pp")
	self.Size_ScrollView_pm = SoraDGetChildByName(self, "Size_ScrollView_pm")
	self.nodeGrantKingdom_node = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeGrantKingdom_node")
	self.nodeGrantPlayer_node = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeGrantPlayer_node")
	self.Image_L = SoraDGetChildByName(self, "Image_L")
	self.Image_R = SoraDGetChildByName(self, "Image_R")
	self.Top_sprite_L = SoraDGetChildByName(self, "Top_sprite_L")
	self.Top_sprite_R = SoraDGetChildByName(self, "Top_sprite_R")
	self.Top_sprite_sheer_bottom = SoraDGetChildByName(self, "Top_sprite_sheer_bottom")
	self.node_headBig = include("headBig").new(self.node_headBig)
	self.node_headbig_king = include("headBig").new(self.node_headbig_king)
	self.node_buff_1 = SoraDGetChildByName(self, "node_buff_1")
	self.img_bg_text_1 = SoraDGetChildByName(self, "img_bg_text_1")
	self.text_des_1 = SoraDGetChildByName(self, "text_des_1")
	self.node_buff_2 = SoraDGetChildByName(self, "node_buff_2")
	self.img_bg_text_2 = SoraDGetChildByName(self, "img_bg_text_2")
	self.text_des_2 = SoraDGetChildByName(self, "text_des_2")
	self.node_buff_3 = SoraDGetChildByName(self, "node_buff_3")
	self.img_bg_text_3 = SoraDGetChildByName(self, "img_bg_text_3")
	_UPVALUE3_, self.text_des_3 = SoraDGetChildByName(self, "text_des_3"), SoraDGetChildByName(self, "text_des_3")
	_UPVALUE3_, self.buffNodes, SoraDGetChildByName(self, "text_des_3")[1] = SoraDGetChildByName(self, "text_des_3"), SoraDGetChildByName(self, "text_des_3"), self.node_buff_1
	_UPVALUE3_, self.buffNodes, SoraDGetChildByName(self, "text_des_3")[2] = SoraDGetChildByName(self, "text_des_3"), SoraDGetChildByName(self, "text_des_3"), self.node_buff_2
	_UPVALUE3_, self.buffNodes, SoraDGetChildByName(self, "text_des_3")[3] = SoraDGetChildByName(self, "text_des_3"), SoraDGetChildByName(self, "text_des_3"), self.node_buff_3
	_UPVALUE3_, self.buffBgNodes, SoraDGetChildByName(self, "text_des_3")[1] = SoraDGetChildByName(self, "text_des_3"), SoraDGetChildByName(self, "text_des_3"), self.img_bg_text_1
	_UPVALUE3_, self.buffBgNodes, SoraDGetChildByName(self, "text_des_3")[2] = SoraDGetChildByName(self, "text_des_3"), SoraDGetChildByName(self, "text_des_3"), self.img_bg_text_2
	_UPVALUE3_, self.buffBgNodes, SoraDGetChildByName(self, "text_des_3")[3] = SoraDGetChildByName(self, "text_des_3"), SoraDGetChildByName(self, "text_des_3"), self.img_bg_text_3
	self.textBuffNodes, SoraDGetChildByName(self, "text_des_3")[1] = SoraDGetChildByName(self, "text_des_3"), self.text_des_1
	self.textBuffNodes, SoraDGetChildByName(self, "text_des_3")[2] = SoraDGetChildByName(self, "text_des_3"), self.text_des_2
	self.textBuffNodes, SoraDGetChildByName(self, "text_des_3")[3] = SoraDGetChildByName(self, "text_des_3"), self.text_des_3
	dump(self.textBuffNodes, "文字列表")
	self.itemsData, _ENV = dump, dump
	self.scrollView = self.Size_ScrollView_pm
	self.recycledList, _ENV, self.heightTopAutoScroll = self.Size_ScrollView_pm, self.Size_ScrollView_pm, 100
	self.scrollView:addEventListener(handler(self, self.scrollEventCallBack))
	self.templateNodeGrantKingdom = self.nodeGrantKingdom_node
	self.templateNodeGrantPlayer = self.nodeGrantPlayer_node
	self.Button_help = SoraDGetChildByName(self, "Button_help")
	self.Button_help:addTouchEventListener(handler(self, self.onClick_Button_help))
	self.Size_bg_Image_pp:setFillType(1)
	self.btn_node_headbig_king = SoraDGetChildByName(self, "btn_node_headbig_king")
	self.btn_node_headBig = SoraDGetChildByName(self, "btn_node_headBig")
	self.btn_node_headbig_king:addTouchEventListener(handler(self, self.onClickHeadBigKing))
	self.btn_node_headBig:addTouchEventListener(handler(self, self.onClickHeadBig))
end
function kingStarGrantView:createUI()
end
function kingStarGrantView:init(data, otherData, activityID)
	self.grantType = data.grantType
	self.otherData = otherData
	self.activityID = activityID
	self.mapID = worldMapDefine.getKingStarMapid(self.activityID)
	if not self.grantType then
		self.grantType = LEGENDLORD_GRANT_TYPE.kingdom
	end
	if self.grantType == LEGENDLORD_GRANT_TYPE.kingdom then
		_ENV = self.grantType
		self.grantType[gActivityTimeActivityID.KING_STAR_BATTLE] = i18n("common_text_4216")
		_ENV = nil
		;(nil).ranklist = i18n("remains_name_01")
		self.grantType[gActivityTimeActivityID.LEGEND_LORD_9001646] = i18n("king_star_rank_text7", nil)
		_ENV = nil
		;(nil).ranklist = i18n("king_star_rank_text3")
		local self.grantType[gActivityTimeActivityID.LEGEND_LORD_9001647], titleCfg = i18n("king_star_rank_text7", nil), self.grantType
		self.commonFramTitle_node:setTitle(self.activityID and titleCfg[self.activityID] or i18n("common_text_4216"))
	elseif self.grantType == LEGENDLORD_GRANT_TYPE.lord then
		_ENV = self.grantType
		self.grantType[gActivityTimeActivityID.KING_STAR_BATTLE] = i18n("common_text_4217")
		_ENV = "common_text_4216"
		;("common_text_4216").ranklist = i18n("remains_name_01")
		self.grantType[gActivityTimeActivityID.LEGEND_LORD_9001646] = i18n("king_star_rank_text8", "common_text_4216")
		_ENV = "common_text_4216"
		;("common_text_4216").ranklist = i18n("king_star_rank_text3")
		local self.grantType[gActivityTimeActivityID.LEGEND_LORD_9001647], titleCfg = i18n("king_star_rank_text8", "common_text_4216"), self.grantType
		self.commonFramTitle_node:setTitle(self.activityID and titleCfg[self.activityID] or i18n("common_text_4217"))
	end
	self:fitPos()
	self.node_worldKing:setVisible(false)
	self.node_touxian:setVisible(false)
	self:requestKingInfo()
	self:requestData()
end
function kingStarGrantView:fitPos()
	if self.grantType == LEGENDLORD_GRANT_TYPE.kingdom then
		self.Size_ScrollView_pm:setContentSize(cc.size(640, self.Size_ScrollView_pm:getContentSize().height + 100))
		self.sizeBgL = SoraDGetChildByName(self, "Top_Size_bg_l")
		self.sizeBgR = SoraDGetChildByName(self, "Top_Size_bg_r")
		self.sizeBgL:setPositionY(self.sizeBgL:getPositionY() + 100)
		self.sizeBgR:setPositionY(self.sizeBgR:getPositionY() + 100)
		self.Top_sprite_R:setPositionY(self.Top_sprite_R:getPositionY() + 100)
		self.Top_sprite_L:setPositionY(self.Top_sprite_L:getPositionY() + 100)
		self.Size_bg_Image_pp:setContentSize(cc.size(640, self.Size_bg_Image_pp:getContentSize().height + 100))
	end
end
function kingStarGrantView:requestKingInfo()
	kingStarCtrl:reqLegendKingInfo(self.activityID)
end
function kingStarGrantView:sMsgGetKingInfo(target, data)
	self.legendKingInfo = kingStarCtrl:getLegendKingInfo(self.activityID)
	self:updateLegendKingInfo()
end
function kingStarGrantView:requestData()
	SoraDShowLoading(self)
	if self.grantType == LEGENDLORD_GRANT_TYPE.kingdom then
		kingStarCtrl:reqKingdomTitleList(self.activityID)
	elseif self.grantType == LEGENDLORD_GRANT_TYPE.lord then
		kingStarCtrl:reqLordTitleList(self.activityID)
	end
end
function kingStarGrantView:updateLegendKingInfo()
	local kingName = self:getLegendKingName()
	self.Text_Status_Title:setString(kingName)
	local playerInfo = self.legendKingInfo.playerInfo
	if self.grantType == LEGENDLORD_GRANT_TYPE.kingdom then
		self.node_worldKing:setVisible(true)
		self.node_touxian:setVisible(false)
		if playerInfo then
			LEGENDLORD_GRANT_TYPE = false
			;(false).imageId = playerInfo.imageId
			;(false).avatar = playerInfo.avatar
			self.node_headbig_king:init(false)
			self.node_headbig_king:setViewType(3)
		else
			self.node_headbig_king:init()
		end
	elseif self.grantType == LEGENDLORD_GRANT_TYPE.lord then
		self.node_worldKing:setVisible(false)
		self.node_touxian:setVisible(true)
		if playerInfo then
			LEGENDLORD_GRANT_TYPE = true
			;(true).imageId = playerInfo.imageId
			;(true).avatar = playerInfo.avatar
			self.node_headBig:init(true)
			self.node_headBig:setViewType(3)
		else
			self.node_headBig:init()
		end
		self:showLegendKingBuffs()
	end
end
function kingStarGrantView:getLegendKingName()
	if not self.legendKingInfo or next(self.legendKingInfo) == nil or next(self.legendKingInfo) and not self.legendKingInfo.playerInfo then
		return i18n("common_text_480")
	end
	local playerInfo = self.legendKingInfo.playerInfo
	local allianceInfo = self.legendKingInfo.allianceInfo
	local kingdomInfo = self.legendKingInfo.kingdomInfo
	local strInfo = ""
	if allianceInfo.abbr then
		_ENV = nil
		;(nil).abbr = allianceInfo.abbr
		;(nil).name = playerInfo.nickName
		strInfo = i18n("common_text_186", nil)
	else
		strInfo = playerInfo.nickName
	end
	strInfo = strInfo .. "#" .. kingdomInfo.kid
	_ENV = kingdomInfo.kid
	kingdomInfo.kid.name = strInfo
	strInfo = i18n("kingstarbattle_text_79", kingdomInfo.kid)
	return strInfo
end
function kingStarGrantView:showLegendKingBuffs()
	for i = 1, #self.buffNodes do
		self.buffNodes[i]:setVisible(false)
	end
	local buffType = gLegendBuffType.PLAYER
	local buffId = gLegendOfficialId.KING
	local buffDesTb = legendKingRead.getBuffDesTbById(buffType, buffId, self.mapID)
	local limitTextWidth = 325
	for i = 1, #self.buffNodes do
		self.buffNodes[i]:setVisible(false)
		self.textBuffNodes[i]:setString("")
		self.textBuffNodes[i]:ignoreContentAdaptWithSize(true)
		self.textBuffNodes[i]:setTextAreaSize(cc.size(0, 0))
	end
	local _ENV, showNodes = (for index), 1
	local _ENV, deltaH = #self.buffNodes, #self.buffNodes
	for i, v in ipairs(buffDesTb) do
		deltaH[i] = 0
		if self.buffNodes[i] then
			self.buffNodes[i]:setVisible(true)
		end
		if self.textBuffNodes[i] then
			self.textBuffNodes[i]:setString(v)
			self.textBuffNodes[i]:setVisible(true)
		end
		if limitTextWidth < self.textBuffNodes[i]:getContentSize().width and self.buffBgNodes[i] then
			local height = SoraDGetAutoHeightLabel(self.textBuffNodes[i], limitTextWidth)
			self.buffBgNodes[i]:setContentSize(cc.size(limitTextWidth, height + 13))
			deltaH[i] = height + 13 - 36
			print("deltaH[i] = ", deltaH[i])
		end
		showNodes[i] = self.buffNodes[i]
	end
	local Y = 630
	for i = #showNodes, 1, -1 do
		showNodes[i]:setPositionY(Y)
		if 1 < i then
			Y = Y + deltaH[i] / 2 + deltaH[i - 1] / 2 + 30
		end
	end
end
function kingStarGrantView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_KINGDOM_TITLE_LIST_BACK", handler(self, self.sMsgKingdomTitleBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_LORD_TITLE_LIST_BACK", handler(self, self.sMsgPlayerTitleBack))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_KINGDOM_CHANGE", handler(self, self.changeToKingdom))
	SoraDAddMessage(self, "MESSAGE_UI_LEGENDKING_SHOW_WORLDMAP_KINGDOM", handler(self, self.msgOpenWorldMapKingdom))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_LORD_APPOINT_KT_BACK", handler(self, self.sMsgAppointKTBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_LORD_APPOINT_LT_BACK", handler(self, self.sMsgAppointLTBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_LORD_CANCEL_LT_BACK", handler(self, self.sMsgCancelLTBack))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.msgGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_KING_DATA_BACK", handler(self, self.sMsgGetKingInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.sMsgCommonRefresh))
end
function kingStarGrantView:sMsgKingdomTitleBack(target, data)
	SoraDCloseLoading(self)
	self.kingdomTitleLimitList, _ENV, self.tableData = kingStarCtrl:getKingdomTitleList(), kingStarCtrl:getKingdomTitleList(), kingStarCtrl:getKingdomTitleList()
	for k, v in pairs(self.tableData) do
		table.insert(self.kingdomTitleLimitList, v.kid)
	end
	self:reloadScrollView()
end
function kingStarGrantView:sMsgPlayerTitleBack(target, data)
	SoraDCloseLoading(self)
	self.lordTitleLimitList, _ENV, self.tableData = kingStarCtrl:getLordTitleList(), kingStarCtrl:getLordTitleList(), kingStarCtrl:getLordTitleList()
	for k, v in pairs(self.tableData) do
		table.insert(self.lordTitleLimitList, v)
	end
	dump(self.lordTitleLimitList, "lordTitleLimitList -----")
	self:reloadScrollView()
end
function kingStarGrantView:reloadScrollView()
	self:recycleAllNodes()
	if not self.tableData then
		self.tableData, _ENV = self.tableData, self.tableData
	end
	print("#self.tableData = ", self.tableData)
	self.itemsData, _ENV = print, print
	local targetTb, limitList
	if self.grantType == LEGENDLORD_GRANT_TYPE.kingdom then
		targetTb = legendKingRead.getAllWorldOfficial(self.mapID)
		limitList = self.kingdomTitleLimitList
	elseif self.grantType == LEGENDLORD_GRANT_TYPE.lord then
		targetTb = legendKingRead.getAllPersonalOfficial(self.mapID)
		limitList = self.lordTitleLimitList
	end
	local itemNode
	if self.grantType == LEGENDLORD_GRANT_TYPE.kingdom then
		local cloneNode = self.templateNodeGrantKingdom:clone()
		cloneNode = include("nodeGrantKingdom").new(cloneNode)
		itemNode = cloneNode
	elseif self.grantType == LEGENDLORD_GRANT_TYPE.lord then
		local cloneNode = self.templateNodeGrantPlayer:clone()
		cloneNode = include("nodeGrantPlayer").new(cloneNode)
		itemNode = cloneNode
	end
	itemNode:retain()
	for i, v in ipairs(targetTb) do
		_ENV = nil
		;(nil).titleBuff = v
		self.itemsData[i], (nil).limitList = nil, limitList
		if self.tableData[v.type] then
			self.itemsData[i].titleInfo = self.tableData[v.type]
		end
		if (self.itemsData[i].itemWidth == 0 or self.itemsData[i].itemWidth == nil) and (self.itemsData[i].itemHeight == 0 or self.itemsData[i].itemHeight == nil) then
			itemNode:init(self.itemsData[i], self.mapID)
			self.itemsData[i].itemWidth = itemNode:getItemWidth()
			self.itemsData[i].itemHeight = itemNode:getItemHeight()
		end
	end
	itemNode:release()
	self:updateScrollSize()
	self:updateScrollCell()
end
function kingStarGrantView:updateScrollSize()
	local scrollInner = self.scrollView:getInnerContainer()
	local minOffsetY = -(scrollInner:getContentSize().height - self.scrollView:getContentSize().height)
	local offsetY = scrollInner:getPositionY()
	local totalHeight = 0
	for i, v in ipairs(self.itemsData) do
		totalHeight = totalHeight + v.itemHeight
	end
	print("#self.itemsData = ", #self.itemsData, ", totalHeight = ", totalHeight)
	local scrollInnerHeight = math.max(totalHeight, self.scrollView:getContentSize().height)
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
function kingStarGrantView:updateScrollCell()
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
end
function kingStarGrantView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:updateScrollCell()
	end
end
function kingStarGrantView:addToRecycledList(cell)
	cell:setVisible(false)
	table.insert(self.recycledList, cell)
end
function kingStarGrantView:hasAnyRecycledCell()
	local result = false
	if #self.recycledList > 0 then
		result = true
		return result
	end
	return result
end
function kingStarGrantView:pickCellFromRecycledList()
	local cell
	if #self.recycledList > 0 then
		cell = table.remove(self.recycledList)
		cell:setVisible(true)
	end
	return cell
end
function kingStarGrantView:createItem(data)
	local itemNode
	if self.grantType == LEGENDLORD_GRANT_TYPE.kingdom then
		local cloneNode = self.templateNodeGrantKingdom:clone()
		cloneNode = include("nodeGrantKingdom").new(cloneNode)
		itemNode = cloneNode
	elseif self.grantType == LEGENDLORD_GRANT_TYPE.lord then
		local cloneNode = self.templateNodeGrantPlayer:clone()
		cloneNode = include("nodeGrantPlayer").new(cloneNode)
		itemNode = cloneNode
	end
	itemNode:init(data, self.mapID)
	itemNode:setHandle(handler(self, self.onClickPlayerAppoint))
	itemNode:setScroll(self.scrollView)
	return itemNode
end
function kingStarGrantView:getItem(data)
	local cell
	local isFromRecycle = false
	if self:hasAnyRecycledCell() == true then
		cell = self:pickCellFromRecycledList()
		cell:init(data, self.mapID)
		isFromRecycle = true
	else
		cell = self:createItem(data)
	end
	return cell, isFromRecycle
end
function kingStarGrantView:recycleAllNodes()
	for i, v in ipairs(self.itemsData) do
		if v.itemNode then
			self:addToRecycledList(v.itemNode)
			v.itemNode = nil
		end
	end
end
function kingStarGrantView:msgOpenWorldMapKingdom(target, data)
	self.legendKingdomTitleID = data.legendKingdomTitleID
	_ENV = nil
	;(nil).kingdomTitleLimitList = self.kingdomTitleLimitList
	;(nil).name = legendKingRead.getOfficialName(gLegendBuffType.KINGDOM, self.legendKingdomTitleID, self.mapID)
	;(nil).mapid = self.mapID
	uiManager:show("legendaryKingGrantChooseKingdom", nil)
end
function kingStarGrantView:changeToKingdom(target, data)
	local kid = data.kid
	if kid and 0 < kid and kid <= GAME_KINGDOM_ID_ASSIGN.LEGEND.END then
		print("点击了kid= ", kid)
		for i, v in ipairs(self.kingdomTitleLimitList) do
			if tonumber(v) == tonumber(kid) then
				SoraDShowMsgTip(i18n("common_text_4221"))
				return
			end
		end
		local ret, kInfo = kingdomCtrl:isFoundKingdomID(kid)
		if not kInfo then
			return
		end
		if kInfo and tonumber(kInfo.kid) >= GAME_KINGDOM_ID_ASSIGN.LEGEND.START and tonumber(kInfo.kid) <= GAME_KINGDOM_ID_ASSIGN.LEGEND.END then
			SoraDShowMsgTip(i18n("legendaryking_text_06"))
			return
		end
		if kInfo and kInfo.titleID and 0 < tonumber(kInfo.titleID) then
			SoraDShowMsgTip(i18n("common_text_4221"))
			return
		end
		local officialName = legendKingRead.getOfficialName(gLegendBuffType.KINGDOM, self.legendKingdomTitleID, self.mapID)
		if self.msgBox then
			if self.msgBox.closePanel then
				self.msgBox:closePanel()
			end
			self.msgBox = nil
		end
		_ENV = i18n("common_text_4221")
		i18n("common_text_4221").king = kInfo.kname
		i18n("common_text_4221").official = officialName
		self.msgBox = SoraDShowMsgBox(i18n("kingstarbattle_text_61", i18n("common_text_4221")), i18n("common_text_204"), i18n("common_text_185"), function(type)
			self.msgBox = nil
			if type == MSGBOX_CALLBACK_YES then
				print(data.kid, " ---> ", self.legendKingdomTitleID)
				local gametop = gModuleMgr.getObject("gametop")
				local kingStarCtrl = gametop.playertop_:getModule("kingStarCtrl")
				kingStarCtrl:reqAppointKingdomTitle(data.kid, self.legendKingdomTitleID, self.activityID)
				if self.bigWorldView then
					self.bigWorldView:removeFromParent()
					self.bigWorldView = nil
				end
			elseif type == MSGBOX_CALLBACK_NO then
			end
		end)
	end
end
function kingStarGrantView:sMsgAppointKTBack(target, data)
	self:sMsgKingdomTitleBack()
end
function kingStarGrantView:sMsgAppointLTBack(target, data)
	self:sMsgPlayerTitleBack()
end
function kingStarGrantView:sMsgCancelLTBack(target, data)
	self:sMsgPlayerTitleBack()
end
function kingStarGrantView:onClick_Button_help(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local lkTipNode = SoraDCreatePanel("nodeLKTip")
		if self.grantType == LEGENDLORD_GRANT_TYPE.kingdom then
			_ENV = nil
			;(nil).title = i18n("common_text_4216")
			;(nil).content = i18n("kingstarbattle_text_60")
			lkTipNode:init(nil)
		elseif self.grantType == LEGENDLORD_GRANT_TYPE.lord then
			_ENV = nil
			;(nil).title = i18n("common_text_4217")
			;(nil).content = i18n("kingstarbattle_text_62") .. "\n" .. i18n("common_text_4224") .. "\n" .. i18n("common_text_4225")
			lkTipNode:init(nil)
		end
		lkTipNode:show()
	end
end
function kingStarGrantView:onClickHeadBigKing(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		if not self.legendKingInfo then
			return
		end
		local kingdomInfo = self.legendKingInfo.kingdomInfo
		if kingdomInfo == nil or next(kingdomInfo) == nil then
			return
		end
		SoraDPlaySound()
		SoraDShowLoading(self)
		local playerInfo = self.legendKingInfo.playerInfo
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		local kid = kingdomInfo.kid
		local uid = playerInfo.uid
		_ENV = nil
		;(nil).kingStarGrantView = true
		;(nil).targetName = self.__cname
		lordInfoCtrl:getLordInfoByUid(uid, kid, nil)
		SoraDShowLoading(self)
	end
end
function kingStarGrantView:onClickHeadBig(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		if not self.legendKingInfo then
			return
		end
		local kingdomInfo = self.legendKingInfo.kingdomInfo
		if kingdomInfo == nil or next(kingdomInfo) == nil then
			return
		end
		SoraDPlaySound()
		SoraDShowLoading(self)
		local playerInfo = self.legendKingInfo.playerInfo
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		local kid = kingdomInfo.kid
		local uid = playerInfo.uid
		_ENV = nil
		;(nil).kingStarGrantView = true
		;(nil).targetName = self.__cname
		lordInfoCtrl:getLordInfoByUid(uid, kid, nil)
		SoraDShowLoading(self)
	end
end
function kingStarGrantView:msgGetLordInfo(target, data)
	if data.clientData and data.lord then
		local kingStarGrantView = data.clientData.kingStarGrantView
		if kingStarGrantView == true then
			SoraDCloseLoading(self)
			SoraDOpenLordView(data.lord)
		end
	end
end
function kingStarGrantView:onClickPlayerAppoint(itemNode)
	local itemData = itemNode.itemData
	if self.otherData then
		local officialid = itemData.titleBuff.type
		local officialName = legendKingRead.getOfficialName(gLegendBuffType.PLAYER, officialid, self.mapID)
		legendKingRead = nil
		;(nil).king = self.otherData.name
		;(nil).official = officialName
		SoraDShowMsgBox(i18n("legendaryking_text_31", nil), i18n("common_text_204"), i18n("common_text_185"), function(type)
			if type == MSGBOX_CALLBACK_YES then
				local uid = self.otherData.uid
				print(uid .. " ---> " .. officialid)
				local gametop = gModuleMgr.getObject("gametop")
				local kingStarCtrl = gametop.playertop_:getModule("kingStarCtrl")
				kingStarCtrl:reqAppointLordTitle(uid, officialid, nil, self.activityID)
				self:close(nil, ccui.TouchEventType.ended)
			elseif type == MSGBOX_CALLBACK_NO then
			end
		end)
	else
		local panel = SoraDCreatePanel("worldMapKingdomCityAppointSelect")
		panel:setLegendOfficialID(itemData.titleBuff.type, itemData.limitList, self.mapID)
		panel:show()
	end
end
function kingStarGrantView:sMsgCommonRefresh(target, data)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	if data.activityID then
		if type(data.activityID) ~= "table" or not data.activityID then
			_UPVALUE1_ = data.activityID
			local data.activityID[1], activityID = data.activityID, data.activityID
		end
		for i, v in ipairs(activityID) do
			if tonumber(v) == gActivityTimeActivityID.KING_STAR_BATTLE then
				local activityState = activityShowCtrl:getStateByID(gActivityTimeActivityID.KING_STAR_BATTLE)
				print("activityState = ", activityState)
				print("self.viewType = ", self.viewType)
				if activityState == gActivityState.CLOSE then
					self:closePanel()
					break
				end
				if activityState == gActivityState.OPEN then
					local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.KING_STAR_BATTLE)
					local legendState = param.curState
					if legendState == ACTIVITY_STATE.PREPARE then
						self:closePanel()
						break
					end
					if legendState == ACTIVITY_STATE.ACTIVE then
						self:closePanel()
						break
					end
					if legendState == ACTIVITY_STATE.SETTLE then
						self:closePanel()
					end
				end
				break
			end
		end
	end
end
return kingStarGrantView
