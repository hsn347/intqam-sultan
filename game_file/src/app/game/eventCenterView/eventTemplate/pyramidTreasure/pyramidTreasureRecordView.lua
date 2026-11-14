local pyramidRareTreasureCtrl = SoraDGetCtrl("pyramidRareTreasureCtrl")
local pyramidTreasureRecordView = class("pyramidTreasureRecordView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("pyramidTreasureRecordView")
	end
	return target
end)
function pyramidTreasureRecordView:ctor()
	self.nowLogType = 1
	self.tabRankSingle, _ENV, self.allLogTbl, _ENV, self.myLogTbl, _ENV, self.startIndex = nil, nil, nil, nil, nil, nil, 1
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("Pyramid_treasure_text_02"))
	self.Text_none = SoraDGetChildByName(self, "Text_none")
	self.Text_none:setString(i18n("god_beast_text_16"))
	self.Text_none:setVisible(false)
	self.nodeTitle = SoraDGetChildByName(self, "Node_mTitle")
	self.Text_name = SoraDGetChildByName(self.nodeTitle, "Text_name")
	self.Text_name:setString(i18n("history_text_57"))
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Text_time:setString(i18n("petra_title_09"))
	self.Text_treasure = SoraDGetChildByName(self, "Text_treasure")
	self.Text_treasure:setString(i18n("petra_title_08"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_tab")
	self.ccs_tab:setContentSize(cc.size(538, 56))
	self.ccs_tab:setNewStyle()
	_ENV = cc.size(538, 56)
	_ENV, _ENV, cc.size(538, 56).tabNum = cc.size(538, 56)
	cc.size(538, 56).title = i18n("petra_title_06")
	cc.size(538, 56).tag = 1
	_ENV, cc.size(538, 56)[1], cc.size(538, 56).handle = cc.size(538, 56)
	cc.size(538, 56).title = i18n("petra_title_07")
	cc.size(538, 56).tag = 2
	cc.size(538, 56).tabsetArray, cc.size(538, 56)[2], cc.size(538, 56).handle = cc.size(538, 56)
	self.ccs_tab:initView(cc.size(538, 56))
end
function pyramidTreasureRecordView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMID_TREASURE_LOG", self.refreshScroll)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function pyramidTreasureRecordView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.PYRAMID_TREASURE_ACTIVITY) then
		self:removeFromParent()
	end
end
function pyramidTreasureRecordView:refreshScroll(data)
	dump(data, "logdata", 10)
	local index = data.index
	if index then
		self.isCanGetMore = false
		for i, v in ipairs(data.rspData.record) do
			table.insert(self.allLogTbl, v)
			if i == 10 then
				self.isCanGetMore = true
			end
		end
		self.startIndex = table.nums(self.allLogTbl) + 1
	else
		self.myLogTbl = data.rspData and data.rspData.record
	end
	self:updateScoll()
end
function pyramidTreasureRecordView:updateScoll()
	local scrollData = self.nowLogType == 2 and self.myLogTbl or self.allLogTbl
	local endIndex = table.nums(scrollData)
	local scrollH = endIndex * 110
	scrollH = math.max(scrollH, 530)
	local maxIndex = math.max(endIndex, #self.tabRankSingle)
	dump(scrollData, "scrollData", 10)
	self.Text_none:setVisible(#scrollData <= 0)
	for i = 1, maxIndex do
		if endIndex < i then
			self.tabRankSingle[i]:setVisible(false)
		else
			if self.tabRankSingle[i] then
				self.tabRankSingle[i]:setVisible(true)
			else
				local single = include("pyramidTreasureRecordSingle").new()
				self.tabRankSingle[i] = single
				single:addTo(self.scroll)
				single:setVisible(true)
			end
			self.tabRankSingle[i]:initData(scrollData[i], self.scroll, self, self.nowLogType == 1)
			self.tabRankSingle[i]:setPosition(0, scrollH - 110 * i)
		end
	end
	self.scroll:setInnerContainerSize(cc.size(530, scrollH))
	SoraDCloseLoading(self)
end
function pyramidTreasureRecordView:clickTab(tag)
	if tag == 1 then
		SoraDShowLoading(self)
		self.nowLogType = 1
		if next(self.allLogTbl) == nil then
			_ENV = nil
			;(nil).idx = self.startIndex
			;(nil).count = 10
			pyramidRareTreasureCtrl:reqTreasureAllLog(nil)
		else
			self:updateScoll()
		end
		self.scroll:jumpToTop()
		self.Text_name:setVisible(true)
		self.Text_name:setPositionX(SoraDFPosX(-180, 0))
		self.Text_time:setPositionX(SoraDFPosX(50, 0))
		self.Text_treasure:setPositionX(SoraDFPosX(180, 0))
	else
		self.nowLogType = 2
		pyramidRareTreasureCtrl:reqTreasureMyLog()
		self.scroll:jumpToTop()
		self.Text_name:setVisible(false)
		self.Text_time:setPositionX(SoraDFPosX(-180, 0))
		self.Text_treasure:setPositionX(SoraDFPosX(180, 0))
	end
end
function pyramidTreasureRecordView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.bounceBottom and self.nowLogType == 1 and self.isCanGetMore then
		_ENV = nil
		;(nil).idx = self.startIndex
		;(nil).count = 10
		petraRareTreasureCtrl:reqTreasureAllLog(nil)
		SoraDShowLoading(self)
	end
end
return pyramidTreasureRecordView
