local gametop = gModuleMgr.getObject("gametop")
local redEnvelopeCtrl = gametop.playertop_:getModule("redEnvelopeCtrl")
local redEnvelopeLogView = class("redEnvelopeLogView", function(target)
	if type(target) == "userData" then
		return target
	end
	return SoraDCreateTouchPanel("redEnvelopeLogView")
end)
function redEnvelopeLogView:ctor()
	self:setBackGround(204.0)
	self.tabRankSingle, _ENV = self.setBackGround, self.setBackGround
	self.ccs_Title = SoraDGetChildByName(self, "Text_name")
	self.ccs_Title:setString(i18n("rebag_title_01"))
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.scroll = SoraDGetChildByName(self, "Top_ScrollView")
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.curStatu = 1
	self.startIndex = 1
	self.textReward = SoraDGetChildByName(self, "text_reward")
	self.textTime = SoraDGetChildByName(self, "text_time")
	self.textName = SoraDGetChildByName(self, "text_name")
	self.textReward:setString(i18n("drop_text_02"))
	self.textTime:setString(i18n("common_text_289"))
	self.textName:setString(i18n("common_text_264"))
	self.textTime:setVisible(false)
	self.tabLeft = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_Tab")
	self.tabLeft:setUnChooseColor(cc.c3b(140, 130, 120))
	self.tabLeft:setChooseColor(cc.c3b(255, 200, 100))
	self.tabLeft:setContentSize(cc.size(510, 48))
	self.tabLeft:setFontSize(20)
	_ENV = self.tabLeft.setFontSize
	self.tabLeft.setFontSize.tabNum = 2
	_ENV, _ENV, self.tabLeft.setFontSize.defaultClick = 20, self.tabLeft, 1
	;(20).title = i18n("common_text_851")
	;(20).handle = handler(self, self.refreshScroll)
	;(20).fontSize = 22
	;(20).tag = 1
	_ENV, self.tabLeft[1], (20).name = 20, 20, tabLeft
	;(20).title = i18n("rebag_title_02")
	;(20).handle = handler(self, self.refreshScroll)
	;(20).fontSize = 22
	;(20).tag = 2
	self.tabLeft.setFontSize.tabsetArray, self.tabLeft[2], (20).name = self.tabLeft, 20, tebRight
	local data = self.tabLeft.setFontSize
	self.tabLeft:initView(data)
	SoraDAddMessage(self, "MESSAGE_SERVER_REDENVELOPE_GETINFO", self.initScroll)
end
function redEnvelopeLogView:scrollEventCallBack(target, type)
	if type == ccui.ScrollviewEventType.bounceBottom then
		print("lth:", type)
		if self.bCanContinueGet then
			if self.curStatu == 1 then
				_ENV = type
				type.startIndex = self.startIndex
				redEnvelopeCtrl:sendReqInfoRank(type)
			else
				_ENV = type
				type.startIndex = self.startIndex
				redEnvelopeCtrl:sendReqInfoHistory(type)
			end
			SoraDShowLoading(self)
		end
	end
end
function redEnvelopeLogView:initScroll(content)
	local data = content.data
	self.bCanContinueGet = content.bCanContinueGet
	local endIndex = table.nums(data) + self.startIndex - 1
	local scrollH = endIndex * 110
	scrollH = math.max(scrollH, 525)
	local maxIndex = math.max(endIndex, #self.tabRankSingle)
	for i = 1, maxIndex do
		if i >= self.startIndex then
			if i > endIndex then
				self.tabRankSingle[i]:setVisible(false)
			elseif self.tabRankSingle[i] then
				self.tabRankSingle[i]:initData(data[i - self.startIndex + 1], i, self.scroll)
				self.tabRankSingle[i]:setVisible(true)
				self.tabRankSingle[i]:setPosition(262.5, scrollH - 110 * (i - 1))
			else
				local single = SoraDCreatePanel("redEnvelopeRankSingle")
				self.tabRankSingle[i] = single
				single:addTo(self.scroll)
				single:setPosition(262.5, scrollH - 110 * (i - 1))
				single:initData(data[i - self.startIndex + 1], i, self.scroll)
			end
		else
			self.tabRankSingle[i]:setPositionY(scrollH - 110 * (i - 1))
		end
	end
	self.startIndex = 1 + endIndex
	self.scroll:setInnerContainerSize(cc.size(525, scrollH))
	SoraDCloseLoading(self)
end
function redEnvelopeLogView:refreshScroll(tag, name)
	if tag == 1 then
		self.startIndex = 1
		redEnvelopeCtrl = nil
		;(nil).startIndex = self.startIndex
		redEnvelopeCtrl:sendReqInfoRank(nil)
		self.textTime:setVisible(false)
		self.textName:setPositionX(55)
		if SoraDFIsRA() then
			self.textName:setPositionX(55)
		else
			self.textName:setPositionX(-55)
		end
		self.curStatu = 1
		self.scroll:jumpToTop()
		SoraDShowLoading(self)
	else
		self.startIndex = 1
		redEnvelopeCtrl = -55
		;(-55).startIndex = self.startIndex
		redEnvelopeCtrl:sendReqInfoHistory(-55)
		self.textTime:setVisible(true)
		if SoraDFIsRA() then
			self.textName:setPositionX(140)
		else
			self.textName:setPositionX(-140)
		end
		self.curStatu = 2
		self.scroll:jumpToTop()
		SoraDShowLoading(self)
	end
end
return redEnvelopeLogView
