local gametop = gModuleMgr.getObject("gametop")
local petraRareTreasureCtrl = gametop.playertop_:getModule("petraRareTreasureCtrl")
local petraRareTreasureLog = class("petraRareTreasureLog", function(target)
	return type(target) == "userData" and target or SoraDCreateTouchPanel("petraRareTreasureLog")
end)
function petraRareTreasureLog:ctor()
	self.nowLogType = 1
	self.tabRankSingle, _ENV, self.allLogTbl, _ENV, self.myLogTbl, _ENV, self.startIndex = nil, nil, nil, nil, nil, nil, 1
	self.popBg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.popBg:setTitleName(i18n("petra_title_05"))
	self.btnTab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_Node")
	self.scroll = SoraDGetChildByName(self, "ScrollView_content")
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.singleItem = SoraDGetChildByName(self, "Node_single")
	self.logName = SoraDGetChildByName(self, "Text_name")
	self.logTime = SoraDGetChildByName(self, "Text_des")
	self.logItem = SoraDGetChildByName(self, "Text_rank")
	self.logName:setString(i18n("rides_title_03"))
	self.logItem:setString(i18n("petra_title_08"))
	self.logTime:setString(i18n("petra_title_09"))
	self.logTime:setPositionX(self.logTime:getPositionX() + (SoraDFIsRA() and 15 or -15))
	self.logItem:setPositionX(self.logItem:getPositionX() + (SoraDFIsRA() and 15 or -15))
	_ENV = self.logItem.setPositionX
	self.logItem.setPositionX.tabNum = 2
	_ENV, _ENV, self.logItem.setPositionX.defaultClick = self.logItem:getPositionX() + (SoraDFIsRA() and 15 or -15), self.logItem, 1
	;(self.logItem:getPositionX() + (SoraDFIsRA() and 15 or -15)).title = i18n("petra_title_06")
	;(self.logItem:getPositionX() + (SoraDFIsRA() and 15 or -15)).handle = handler(self, self.btnClickTab)
	_ENV, self.logItem[1], (self.logItem:getPositionX() + (SoraDFIsRA() and 15 or -15)).tag = self.logItem:getPositionX() + (SoraDFIsRA() and 15 or -15), self.logItem:getPositionX() + (SoraDFIsRA() and 15 or -15), 1
	;(self.logItem:getPositionX() + (SoraDFIsRA() and 15 or -15)).title = i18n("petra_title_07")
	;(self.logItem:getPositionX() + (SoraDFIsRA() and 15 or -15)).handle = handler(self, self.btnClickTab)
	self.logItem.setPositionX.tabsetArray, self.logItem[2], (self.logItem:getPositionX() + (SoraDFIsRA() and 15 or -15)).tag = self.logItem, self.logItem:getPositionX() + (SoraDFIsRA() and 15 or -15), 2
	local param = self.logItem.setPositionX
	self.btnTab:setContentSize(cc.size(570, 48))
	self.btnTab:initView(param)
	SoraDAddMessage(self, "MESSAGE_SERVER_PETRA_RARE_TREASURE_LOG", self.refreshScroll)
end
function petraRareTreasureLog:refreshScroll(data)
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
function petraRareTreasureLog:updateScoll()
	local scrollData = self.nowLogType == 2 and self.myLogTbl or self.allLogTbl
	local endIndex = table.nums(scrollData)
	local scrollH = endIndex * 110
	scrollH = math.max(scrollH, 530)
	local maxIndex = math.max(endIndex, #self.tabRankSingle)
	dump(scrollData, "scrollData", 10)
	for i = 1, maxIndex do
		if endIndex < i then
			self.tabRankSingle[i]:setVisible(false)
		else
			if self.tabRankSingle[i] then
				self.tabRankSingle[i]:setVisible(true)
			else
				local single = self.singleItem:clone()
				single = include("petraRareTreasureLogSingle").new(single)
				self.tabRankSingle[i] = single
				single:addTo(self.scroll)
				single:setVisible(true)
			end
			self.tabRankSingle[i]:initData(scrollData[i], self.scroll, self.nowLogType == 1)
			self.tabRankSingle[i]:setPosition(290, scrollH - 110 * (i - 1))
		end
	end
	self.scroll:setInnerContainerSize(cc.size(530, scrollH))
	SoraDCloseLoading(self)
end
function petraRareTreasureLog:btnClickTab(tag, name)
	if tag == 1 then
		SoraDShowLoading(self)
		self.nowLogType = 1
		if next(self.allLogTbl) == nil then
			_ENV = nil
			;(nil).idx = self.startIndex
			;(nil).count = 10
			petraRareTreasureCtrl:reqTreasureAllLog(nil)
		else
			self:updateScoll()
		end
		self.logName:setString(i18n("rides_title_03"))
		self.logTime:setVisible(true)
		self.scroll:jumpToTop()
	else
		SoraDShowLoading(self)
		self.nowLogType = 2
		petraRareTreasureCtrl:reqTreasureMyLog()
		self.logName:setString(i18n("petra_title_09"))
		self.logTime:setVisible(false)
		self.scroll:jumpToTop()
	end
end
function petraRareTreasureLog:scrollEventCallBack(target, type)
	if type == ccui.ScrollviewEventType.bounceBottom and self.nowLogType == 1 and self.isCanGetMore then
		_ENV = nil
		;(nil).idx = self.startIndex
		;(nil).count = 10
		petraRareTreasureCtrl:reqTreasureAllLog(nil)
		SoraDShowLoading(self)
	end
end
return petraRareTreasureLog
