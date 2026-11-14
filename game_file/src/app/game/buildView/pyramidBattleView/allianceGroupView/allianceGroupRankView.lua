local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local pyramidClientModule = include("pyramidClientModule")
local rankingsCtrl = gametop.playertop_:getModule("rankingsCtrl")
local pyramidWarltCtrl = include("pyramidWarltCtrl")
local allianceDesRead = include("allianceDesRead")
local AllianceGroupRankView = class("allianceGroupRankView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceGroupRankView")
	end
	return target
end)
function AllianceGroupRankView:ctor()
	self.tableSpare, _ENV, self.tableSingle, _ENV, self.tableData, (nil)[2], _ENV, (nil)[1], _ENV, _ENV = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	self.ownPosY = 0
	self.curTab = 1
	self.beginIndex = 1
	self.hasMore = true
	self.imgBg = SoraDGetChildByName(self, "Image_bg")
	self.centerTextNoRecord = SoraDGetChildByName(self, "Center_Text_noRecord")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_myRank")
	self.scroll:setListenAllScrollingEnabled(true)
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.labelTip = SoraDGetChildByName(self, "Text_tip")
	self.imgCenterBar = SoraDGetChildByName(self, "Image_centerBar")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelVictory = SoraDGetChildByName(self, "Text_victory")
	self.spriteBottomLine = SoraDGetChildByName(self, "Sprite_bottom_line")
	self.imgLBottomBg = SoraDGetChildByName(self, "Image_lBottomBg")
	self.imgRBottomBg = SoraDGetChildByName(self, "Image_rBottomBg")
	self.spriteLDog = SoraDGetChildByName(self, "Sprite_lDog")
	self.spriteRDog = SoraDGetChildByName(self, "Sprite_rDog")
	self.labelNoInfo = SoraDGetChildByName(self, "Text_noInfo")
	self.nodeMyInfo = SoraDGetChildByName(self, "Node_myInfo")
	self.btnJump = SoraDGetChildByName(self, "Button_jump")
	self.imgMyNum = SoraDGetChildByName(self, "Image_myNum")
	self.nodeMyAlliance = SoraDGetChildByName(self, "Node_myFlag")
	self.labelMyNum = SoraDGetChildByName(self, "Text_myNum")
	self.labelMyItemName = SoraDGetChildByName(self, "Text_myItemName")
	self.labelMyItemVictory = SoraDGetChildByName(self, "Text_myItemVictory")
	self.layerItem = SoraDGetChildByName(self, "Panel_item")
	self.btnJump:addTouchEventListener(handler(self, self.btnJumpClickCallBack))
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_myRank")
	self.nodeTab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtn_tab")
	self.labelTip:setString(i18n("common_text_828"))
	self.nodeTitle:setTitle(i18n("pyramid_title_04"))
	self.labelName:setString(i18n("pyramid_btn_34"))
	self.labelVictory:setString(i18n("common_text_090"))
	self:initTab()
	SoraDAddMessage(self, "MESSAGE_RANKINGS_SUCCESS", handler(self, self.updateRank))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_TOTTAL_RANK_BACK", handler(self, self.updateWorldRank))
	rankingsCtrl:getRankings(lordRankingsDef.allianceLegionPower)
	SoraDShowLoading(self)
end
function AllianceGroupRankView:updateWorldRank(target, data)
	local data = data.data
	if self.tableData[2].data == nil then
		self.tableData[2] = data.retdata
	else
		for i, v in ipairs(data.retdata.data) do
			self.tableData[2].data[v.rank] = v
		end
	end
	self.hasMore = data.retdata.hasMore
	self.beginIndex = #self.tableData[2].data + 1
	for i, v in ipairs(self.tableSingle) do
		if v.point then
			v.point:setVisible(false)
			table.insert(self.tableSpare, v.point)
			v.point = nil
		end
	end
	self.tableSingle, _ENV = ipairs(self.tableSingle)
	self:updateScroll()
	SoraDCloseLoading(self)
end
function AllianceGroupRankView:updateRank(target, data)
	SoraDCloseLoading(self)
	self.tableData[1] = data.rank
	self.ownLegion = data.rank and data.rank.userInfoData
	self:updateScroll()
end
function AllianceGroupRankView:updateScroll()
	if self.tableData[self.curTab].data == nil or self.tableData[self.curTab].data and table.nums(self.tableData[self.curTab].data) <= 0 then
		self.centerTextNoRecord:setString(i18n("common_text_927"))
		self.centerTextNoRecord:setVisible(true)
	else
		self.centerTextNoRecord:setVisible(false)
	end
	self:addScrollView()
end
function AllianceGroupRankView:initTab(...)
	_ENV, _ENV = nil, nil
	;(nil).title = i18n("pyramid_btn_21")
	;(nil).tag = 1
	_ENV, (nil)[1], (nil).handle = nil, nil, handler(self, self.OnBtnChangeClick)
	;(nil).title = i18n("pyramid_btn_22")
	;(nil).tag = 2
	;(nil)[2], (nil).handle = nil, handler(self, self.OnBtnChangeClick)
	local rankTab
	_ENV = self
	self.tabNum = 2
	self.defaultClick = self.curTab
	self.tabsetArray = rankTab
	self.nodeTab:initView(self)
end
function AllianceGroupRankView:addScrollView()
	local msg = ""
	if self.tableData[self.curTab].league == nil or self.tableData[self.curTab].league <= 0 then
		msg = i18n("common_text_827")
		if pyramidWarCtrl:getOwnLegion() == nil then
			msg = i18n("pyramid_text_12")
		end
		self.labelNoInfo:setString(msg)
		self.nodeMyInfo:setVisible(false)
	else
		self.labelNoInfo:setString("")
		self.nodeMyInfo:setVisible(true)
		self:initMyData()
	end
	if self.tableData[self.curTab].data then
		local scrollInner = self.scroll:getInnerContainer()
		local scrollInnerNewH = math.max(125 * #self.tableData[self.curTab].data, self.scroll:getContentSize().height)
		self.ownPosY = scrollInnerNewH - 125 * self.tableData[self.curTab].league - 0.5 * self.scroll:getContentSize().height
		for i, v in ipairs(self.tableData[self.curTab].data) do
			_ENV = nil
			_ENV, (nil).point = nil, nil
			;(nil).data = v
			;(nil).rank = i
			;(nil).data, (nil).isOwn = nil, i == self.tableData[self.curTab].league
			;(nil).posY = scrollInnerNewH - 125 * (i - 1) - 0
			table.insert(self.tableSingle, nil)
		end
		self.scroll:setInnerContainerSize(cc.size(640, scrollInnerNewH))
		self:initRankingsList()
	end
end
function AllianceGroupRankView:initMyData(type)
	local ownData = pyramidWarCtrl:getOwnLegion()
	dump(self.ownLegion, "AllianceGroupRankView-self.ownLegion", 10)
	local pyramidWarCtrl, ownAlliance = dump, dump
	local legionName, flag, abbr
	if ownData then
		ownAlliance = allianceMgr:getAlliance(ownData.aid)
		abbr = ownAlliance:getProperty("abbr")
		legionName = ownData.legionName
		flag = ownData.flag
	elseif self.ownLegion then
		abbr = self.ownLegion.allianceAbbr
		legionName = self.ownLegion.legionName
		flag = self.ownLegion.flag
	end
	self.labelMyNum:setVisible(self.tableData[self.curTab].league > RANK_TOP_SPECIAL)
	self.imgMyNum:setVisible(self.tableData[self.curTab].league <= RANK_TOP_SPECIAL)
	self.labelMyNum:setString(tostring(self.tableData[self.curTab].league))
	if self.tableData[self.curTab].league <= RANK_TOP_SPECIAL then
		self.imgMyNum:loadTexture("icon_ranking_" .. self.tableData[self.curTab].league .. ".png", ccui.TextureResType.plistType)
	end
	pyramidWarCtrl = "icon_ranking_" .. self.tableData[self.curTab].league .. ".png"
	;("icon_ranking_" .. self.tableData[self.curTab].league .. ".png").abbr = abbr or i18n("common_text_480")
	;("icon_ranking_" .. self.tableData[self.curTab].league .. ".png").name = legionName or i18n("common_text_480")
	local name = i18n("common_text_186", "icon_ranking_" .. self.tableData[self.curTab].league .. ".png")
	if self.curTab == 2 then
		name = name .. " #" .. gametop.playertop_:getKingdomID()
	end
	self.labelMyItemName:setString(name)
	self.labelMyItemVictory:setString(string.formatnumberthousands(self.tableData[self.curTab].ranking))
	self.nodeMyAlliance:removeAllChildren()
	allianceDesRead.getFlagWithParticle(flag, self.nodeMyAlliance)
end
function AllianceGroupRankView:initRankingsList()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scroll.endY, tableShowH = offsetY + 1.5 * scrollH, self.scroll
	for i, v in ipairs(self.tableSingle) do
		if v.point then
			if v.posY < tableShowH.beginY or v.posY > tableShowH.endY then
				v.point:setVisible(false)
				table.insert(self.tableSpare, v.point)
				v.point = nil
			end
		elseif tableShowH.beginY <= v.posY and tableShowH.endY >= v.posY then
			local single
			if 0 < #self.tableSpare then
				single = table.remove(self.tableSpare)
				single:setVisible(true)
			else
				single = self:createSingle()
				single.setScroll(self.scroll)
				single:addTo(self.scroll)
			end
			single.initData(v.data)
			single:setPosition(cc.p(320, v.posY))
			v.point = single
		end
	end
end
function AllianceGroupRankView:createSingle()
	local single = self.layerItem:clone()
	single.imgItemFrm = SoraDGetChildByName(single, "Image_itemFrm")
	single.imgItemBg = SoraDGetChildByName(single, "Image_itemBg")
	single.imgNum = SoraDGetChildByName(single, "Image_num")
	single.nodeFlag = SoraDGetChildByName(single, "Node_flag")
	single.labelNum = SoraDGetChildByName(single, "Text_num")
	single.labelItemName = SoraDGetChildByName(single, "Text_itemName")
	single.labelItemVictory = SoraDGetChildByName(single, "Text_itemVictory")
	function single.setScroll(scroll)
		single.scroll = scroll
	end
	function single.initData(data)
		local rank = data.rank
		single.labelNum:setVisible(data.rank > RANK_TOP_SPECIAL)
		single.imgNum:setVisible(data.rank <= RANK_TOP_SPECIAL)
		single.imgItemBg:setVisible(data.rank <= RANK_TOP_SPECIAL or data.isOwn)
		single.labelNum:setString(tostring(data.rank))
		if data.rank <= RANK_TOP_SPECIAL then
			single.imgNum:loadTexture("icon_ranking_" .. data.rank .. ".png", ccui.TextureResType.plistType)
			single.imgItemBg:loadTexture("frame_alliance_pank_0" .. data.rank .. ".png", ccui.TextureResType.plistType)
		end
		if data.isOwn and data.rank > RANK_TOP_SPECIAL then
			single.imgItemBg:loadTexture("frame_alliance_pank_05.png", ccui.TextureResType.plistType)
		end
		single.nodeFlag:removeAllChildren()
		allianceDesRead.getFlagWithParticle(data.data.flag, single.nodeFlag)
		single = single.nodeFlag
		single.nodeFlag.abbr = data.data.allianceAbbr or i18n("common_text_480")
		single.nodeFlag.name = data.data.legionName or i18n("common_text_480")
		local name = i18n("common_text_186", single.nodeFlag)
		if self.curTab == 2 and data.data.kid then
			name = name .. " #" .. data.data.kid
		end
		single.labelItemName:setString(name)
		single.labelItemVictory:setString(string.formatnumberthousands(data.data.ranking))
	end
	function single.setHandle(handle)
		single.handle = handle
	end
	return single
end
function AllianceGroupRankView:OnBtnChangeClick(tag, name)
	self.curTab = tag
	self.scroll:jumpToTop()
	for i, v in ipairs(self.tableSingle) do
		if v.point then
			v.point:setVisible(false)
			table.insert(self.tableSpare, v.point)
			v.point = nil
		end
	end
	self.tableSingle, _ENV = ipairs(self.tableSingle)
	if self.tableData[self.curTab].league == nil and self.curTab == 2 then
		pyramidWarCtrl:newQueryLegionTotalRankReq(self.beginIndex, 100)
		SoraDShowLoading(self)
	else
		self:updateScroll()
	end
end
function AllianceGroupRankView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:initRankingsList()
	elseif event == ccui.ScrollviewEventType.bounceBottom and self.curTab == 2 and self.hasMore then
		self.hasMore = false
		pyramidWarCtrl:newQueryLegionTotalRankReq(self.beginIndex, 100)
		SoraDShowLoading(self)
		self.scroll:jumpToBottom()
	end
end
function AllianceGroupRankView:btnJumpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		self:stopAllActions()
		SoraDPlaySound()
		local scrollPercent = 100 * (1 - self.ownPosY / (self.scroll:getInnerContainerSize().height - self.scroll:getContentSize().height))
		scrollPercent = math.min(100, math.max(0, scrollPercent))
		local scrollH = self.scroll:getContentSize().height
		if math.abs(self.ownPosY + self.scroll:getInnerContainer():getPositionY()) < 0.5 * scrollH then
			self.scroll:scrollToPercentVertical(scrollPercent, 0.2, true)
		elseif self.tableData[self.curTab].league then
			_UPVALUE2_ = 0.2
			;(0.2)[1] = cca.callFunc(function(...)
				if self.tableData[self.curTab].league <= 150 and self.tableData[self.curTab].league > 0 then
					self.scroll:scrollToPercentVertical(scrollPercent + 0.5, 0.2, false)
				end
			end)
			;(0.2)[2] = cca.delay(0.3)
			;(0.2)[3] = cca.callFunc(function(...)
				if self.tableData[self.curTab].league <= 150 and self.tableData[self.curTab].league > 0 then
					self.scroll:scrollToPercentVertical(scrollPercent, 0.1, true)
				end
			end)
			;(0.2)[4] = cca.callFunc(function(...)
				if self.tableData[self.curTab].league <= 150 and self.tableData[self.curTab].league > 0 then
					self.scroll:scrollToPercentVertical(scrollPercent, 0.1, true)
				end
			end)
			self:runAction(cca.seq(0.2))
		end
	end
end
return AllianceGroupRankView
