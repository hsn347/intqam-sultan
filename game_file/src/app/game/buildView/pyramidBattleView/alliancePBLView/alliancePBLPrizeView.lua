local allianceWarltCtrl = include("allianceWarltCtrl")
local alliancePBLPrizeView = class("alliancePBLPrizeView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("alliancePBLPrizeView")
	end
	return target
end)
function alliancePBLPrizeView:ctor()
	self.tableSpare, _ENV, self.tableSingle, _ENV = nil, nil, nil, nil
	self.nodeBg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeTab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_tab")
	self.scroll = SoraDGetChildByName(self, "ScrollView_scroll")
	self.scroll:setListenAllScrollingEnabled(true)
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.nodeLose = SoraDGetChildByName(self, "Node_lose")
	self.labelLose = SoraDGetChildByName(self, "Text_lose")
	self.nodeWin = SoraDGetChildByName(self, "Node_win")
	self.labelWin = SoraDGetChildByName(self, "Text_win")
	self.nodeOwn = SoraDGetChildByName(self, "Node_own")
	self.labelPrize = SoraDGetChildByName(self, "Text_prize")
	self.labelOwn = SoraDGetChildByName(self, "Text_own")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.nodeClone = SoraDGetChildByName(self, "Node_clone")
	self.labelPrize:setString(i18n("common_text_2078"))
	self.labelOwn:setString(i18n("pyramid_text_115"))
	self.nodeBg:setTitleName(i18n("common_text_2078"))
	self.labelLose:setString(i18n("pyramid_text_32"))
	self.labelWin:setString(i18n("pyramid_text_31"))
	self:initTab()
end
function alliancePBLPrizeView:initTab()
	self.nodeTab:setContentSize(cc.size(546, 56))
	self.nodeTab:setNewStyle(true)
	_ENV, _ENV = self.nodeTab, self.nodeTab.setNewStyle
	self.nodeTab.title = i18n("pyramid_btn_23")
	_ENV, self.nodeTab.setNewStyle[1], self.nodeTab.handle = self.nodeTab, self.nodeTab, handler(self, self.OnBtnChangeClick)
	self.nodeTab.title = i18n("pyramid_btn_24")
	_ENV, self.nodeTab.setNewStyle[2], self.nodeTab.handle = self.nodeTab, self.nodeTab, handler(self, self.OnBtnChangeClick)
	self.nodeTab.title = i18n("pyramid_btn_25")
	self.nodeTab.setNewStyle[3], self.nodeTab.handle = self.nodeTab, handler(self, self.OnBtnChangeClick)
	local arry = self.nodeTab.setNewStyle
	_ENV = self
	self.tabNum = 3
	self.defaultClick = 1
	self.tabsetArray = arry
	self.nodeTab:initView(self)
end
function alliancePBLPrizeView:OnBtnChangeClick(tag)
	self.curTab = tag
	for i, v in ipairs(self.tableSingle) do
		if v.point then
			table.insert(self.tableSpare, v.point)
			v.point:setVisible(false)
			v.point = nil
		end
	end
	if self.curTab == 1 then
		self.labelDes:setString(i18n("common_text_2211"))
	elseif self.curTab == 2 then
		self.labelDes:setString(i18n("pyramid_text_34"))
	elseif self.curTab == 3 then
		self.labelDes:setString(i18n("pyramid_text_35"))
	end
	self.tableSingle, _ENV = self.labelDes.setString, self.labelDes.setString
	self:initData()
end
function alliancePBLPrizeView:initData()
	self.nodeWin:setVisible(self.curTab ~= 1)
	self.nodeLose:setVisible(self.curTab ~= 1)
	self.nodeOwn:setVisible(self.curTab == 1)
	self.scroll:setContentSize(cc.size(550, self.curTab == 1 and 555 or 600))
	if self.curTab == 1 then
		local rewards = allianceWarltCtrl.getAlliancewarPBLPointsRewards()
		local scrollInner = self.scroll:getInnerContainer()
		local scrollInnerNewH = math.max(93 * #rewards + 40, self.scroll:getContentSize().height)
		for i, v in ipairs(rewards) do
			_ENV = cc.size(550, self.curTab == 1 and 555 or 600)
			_ENV, cc.size(550, self.curTab == 1 and 555 or 600).point = cc.size(550, self.curTab == 1 and 555 or 600)
			cc.size(550, self.curTab == 1 and 555 or 600).min = v.point[1]
			cc.size(550, self.curTab == 1 and 555 or 600).max = v.point[2]
			cc.size(550, self.curTab == 1 and 555 or 600).data, cc.size(550, self.curTab == 1 and 555 or 600).itemList = cc.size(550, self.curTab == 1 and 555 or 600)
			cc.size(550, self.curTab == 1 and 555 or 600).posY = scrollInnerNewH - 93 * i
			table.insert(self.tableSingle, cc.size(550, self.curTab == 1 and 555 or 600))
		end
		self.scroll:setInnerContainerSize(cc.size(550, scrollInnerNewH))
	else
		local win = allianceWarltCtrl.getAlliancewarPersonalReward(1, self.curTab == 2 and gSeasonType.REGULAR_SEASON or gSeasonType.PINNACLE_SEASON)
		local lose = allianceWarltCtrl.getAlliancewarPersonalReward(2, self.curTab == 2 and gSeasonType.REGULAR_SEASON or gSeasonType.PINNACLE_SEASON)
		local scrollInner = self.scroll:getInnerContainer()
		local scrollInnerNewH = math.max(93 * (#win + #lose) + 120, self.scroll:getContentSize().height)
		for i, v in ipairs(win) do
			_ENV = cc.size(550, scrollInnerNewH)
			_ENV, cc.size(550, scrollInnerNewH).point = cc.size(550, scrollInnerNewH)
			cc.size(550, scrollInnerNewH).min = v.point[1]
			cc.size(550, scrollInnerNewH).max = v.point[2]
			cc.size(550, scrollInnerNewH).data, cc.size(550, scrollInnerNewH).itemList = cc.size(550, scrollInnerNewH)
			cc.size(550, scrollInnerNewH).posY = scrollInnerNewH - 40 - 93 * i
			table.insert(self.tableSingle, cc.size(550, scrollInnerNewH))
		end
		self.nodeWin:setPositionY(scrollInnerNewH - 40)
		local winCount = #win
		for i, v in ipairs(lose) do
			_ENV = scrollInnerNewH - 40 - 93 * i
			_ENV, (scrollInnerNewH - 40 - 93 * i).point = 93 * i, nil
			;(93 * i).min = v.point[1]
			;(93 * i).max = v.point[2]
			;(scrollInnerNewH - 40 - 93 * i).data, (93 * i).itemList = 93 * i, SoraDIntArr2FormatTable(v.reward)
			;(scrollInnerNewH - 40 - 93 * i).posY = scrollInnerNewH - 80 - 93 * (i + winCount)
			table.insert(self.tableSingle, scrollInnerNewH - 40 - 93 * i)
		end
		self.nodeLose:setPositionY(93 * #lose + 40)
		self.scroll:setInnerContainerSize(cc.size(550, scrollInnerNewH))
	end
	self.scroll:jumpToTop()
	self:initRankingsList()
end
function alliancePBLPrizeView:initRankingsList()
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
				single:addTo(self.scroll)
			end
			single.initData(v.data, self.curTab)
			single:setPosition(275, v.posY)
			v.point = single
		end
	end
end
function alliancePBLPrizeView:createSingle()
	local single = self.nodeClone:clone()
	single.labelIndex = SoraDGetChildByName(single, "Text_index")
	single.node_award_1 = SoraDGetExtendChildFromCCSByName(single, "CCS_commonItemAward_1")
	single.node_award_2 = SoraDGetExtendChildFromCCSByName(single, "CCS_commonItemAward_2")
	single.node_award_3 = SoraDGetExtendChildFromCCSByName(single, "CCS_commonItemAward_3")
	single.node_award_4 = SoraDGetExtendChildFromCCSByName(single, "CCS_commonItemAward_4")
	single.node_award_5 = SoraDGetExtendChildFromCCSByName(single, "CCS_commonItemAward_5")
	single.nodeTop = SoraDGetChildByName(single, "Node_top")
	single.spriteTop = SoraDGetChildByName(single, "Sprite_top")
	single.bflIndex = SoraDGetChildByName(single, "BitmapFontLabel_index")
	function single.initData(data, tab)
		single.nodeTop:setVisible(tab == 1 and data.min >= 33)
		if tab == 1 and data.min >= 33 then
			if data.min >= 36 then
				single.spriteTop:setSpriteFrame("frame_JZT_pm1.png")
				single.bflIndex:setPositionY(15)
				single.nodeTop:setPositionY(46)
			elseif data.min >= 34 then
				single.spriteTop:setSpriteFrame("frame_JZT_pm2.png")
				single.bflIndex:setPositionY(16)
				single.nodeTop:setPositionY(43)
			else
				single.spriteTop:setSpriteFrame("frame_JZT_pm3.png")
				single.bflIndex:setPositionY(18)
				single.nodeTop:setPositionY(38)
			end
			single.bflIndex:setString(data.min)
			single.bflIndex:setScale(0.4)
		elseif data.max > 90000 then
			single.labelIndex:setString("" .. data.min .. "+")
		else
			single.labelIndex:setString("" .. data.min .. "-" .. data.max)
		end
		for i, v in ipairs(data.itemList) do
			local item = single["node_award_" .. i]
			item:setOwnView(self)
			item:setOwnScroll(self.scroll)
			item:initData(v.id, v.num)
		end
	end
	return single
end
function alliancePBLPrizeView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:initRankingsList()
	end
end
return alliancePBLPrizeView
