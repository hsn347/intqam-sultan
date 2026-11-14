local allianceWarltCtrl = include("allianceWarltCtrl")
local AllianceGroupPrizeView = class("allianceGroupPrizeView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceGroupPrizeView")
	end
	return target
end)
function AllianceGroupPrizeView:ctor()
	self.tableSpare, _ENV, self.tableSingle, _ENV = nil, nil, nil, nil
	self.nodeBg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeBg:setTitleName(i18n("common_text_2078"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_scroll")
	self.scroll:setListenAllScrollingEnabled(true)
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.nodeLose = SoraDGetChildByName(self, "Node_lose")
	self.labelLose = SoraDGetChildByName(self, "Text_lose")
	self.nodeWin = SoraDGetChildByName(self, "Node_win")
	self.labelWin = SoraDGetChildByName(self, "Text_win")
	self.labelLose:setString(i18n("pyramid_text_32"))
	self.labelWin:setString(i18n("pyramid_text_31"))
	self.nodeClone = SoraDGetChildByName(self, "Node_clone")
	self:initData()
end
function AllianceGroupPrizeView:initData()
	local win = allianceWarltCtrl.getAlliancewarPersonalReward(1, gSeasonType.REGULAR_SEASON)
	local lose = allianceWarltCtrl.getAlliancewarPersonalReward(2, gSeasonType.REGULAR_SEASON)
	local scrollInner = self.scroll:getInnerContainer()
	local scrollInnerNewH = math.max(93 * (#win + #lose) + 80, self.scroll:getContentSize().height)
	for i, v in ipairs(win) do
		allianceWarltCtrl = nil
		allianceWarltCtrl, (nil).point = nil, nil
		;(nil).min = v.point[1]
		;(nil).max = v.point[2]
		;(nil).data, (nil).itemList = nil, SoraDIntArr2FormatTable(v.reward)
		;(nil).posY = scrollInnerNewH - 40 - 93 * i
		table.insert(self.tableSingle, nil)
	end
	self.nodeWin:setPositionY(scrollInnerNewH - 40)
	local winCount = #win
	for i, v in ipairs(lose) do
		allianceWarltCtrl = scrollInnerNewH - 40 - 93 * i
		allianceWarltCtrl, (scrollInnerNewH - 40 - 93 * i).point = 93 * i, nil
		;(93 * i).min = v.point[1]
		;(93 * i).max = v.point[2]
		;(scrollInnerNewH - 40 - 93 * i).data, (93 * i).itemList = 93 * i, SoraDIntArr2FormatTable(v.reward)
		;(scrollInnerNewH - 40 - 93 * i).posY = scrollInnerNewH - 80 - 93 * (i + winCount)
		table.insert(self.tableSingle, scrollInnerNewH - 40 - 93 * i)
	end
	self.nodeLose:setPositionY(93 * #lose)
	self.scroll:setInnerContainerSize(cc.size(550, scrollInnerNewH))
	self.scroll:jumpToTop()
	self:initRankingsList()
end
function AllianceGroupPrizeView:initRankingsList()
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
			single.initData(v.data)
			single:setPosition(275, v.posY)
			v.point = single
		end
	end
end
function AllianceGroupPrizeView:createSingle()
	local single = self.nodeClone:clone()
	single.labelIndex = SoraDGetChildByName(single, "Text_index")
	single.node_award_1 = SoraDGetExtendChildFromCCSByName(single, "CCS_commonItemAward_1")
	single.node_award_2 = SoraDGetExtendChildFromCCSByName(single, "CCS_commonItemAward_2")
	single.node_award_3 = SoraDGetExtendChildFromCCSByName(single, "CCS_commonItemAward_3")
	single.node_award_4 = SoraDGetExtendChildFromCCSByName(single, "CCS_commonItemAward_4")
	single.node_award_5 = SoraDGetExtendChildFromCCSByName(single, "CCS_commonItemAward_5")
	function single.initData(data)
		if data.max > 90000 then
			single.labelIndex:setString("" .. data.min .. "+")
		else
			single.labelIndex:setString("" .. data.min .. "-" .. data.max)
		end
		for i, v in ipairs(data.itemList) do
			local item = single["node_award_" .. i]
			item:setOwnView(self)
			item:initData(v.id, v.num)
		end
	end
	return single
end
function AllianceGroupPrizeView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:initRankingsList()
	end
end
function AllianceGroupPrizeView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		print("btn click")
	end
end
return AllianceGroupPrizeView
