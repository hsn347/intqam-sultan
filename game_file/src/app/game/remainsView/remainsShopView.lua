local remainsWarRead = include("remainsWarRead")
local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local remainsWarCtrl = gametop.playertop_:getModule("remainsWarCtrl")
local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
local RemainsShopView = class("remainsShopView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("remainsShopView")
	end
	return target
end)
function RemainsShopView:ctor()
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_remainsShop")
	self.nodeTitle:setTitle(i18n("remains_btn_03"))
	self.imgHeadLine = SoraDGetChildByName(self, "Image_seperateLine_top")
	self.imgMiddleLine = SoraDGetChildByName(self, "Image_seperateLine_bottom")
	self.imgBottomLine = SoraDGetChildByName(self, "Image_mid_bottom")
	self.imgHeadLine:setFillType(1)
	self.imgMiddleLine:setFillType(1)
	self.imgBottomLine:setFillType(1)
	self.segmentScroll = SoraDGetChildByName(self, "ScrollView_segment")
	self.mainScroll = SoraDGetChildByName(self, "Top_Size_ScrollView_main")
	self.mainScroll:addEventListener(handler(self, self.mainScrollEventCallBack))
	self.labelReset = SoraDGetChildByName(self, "Text_alterReset")
	self.labelScoreKey = SoraDGetChildByName(self, "Text_scoreKey")
	self.labelScore = SoraDGetChildByName(self, "Text_score")
	self.labelSegmentKey = SoraDGetChildByName(self, "Text_segmentKey")
	self.labelSegment = SoraDGetChildByName(self, "Text_segment")
	self.labelTime = SoraDGetChildByName(self, "Text_leftTime")
	self:beginTime()
	self.imgScore = SoraDGetChildByName(self, "Image_score_decorate")
	self.imgSegment = SoraDGetChildByName(self, "Image_segment_decorate")
	self.nodeBg = SoraDGetChildByName(self, "shopItem_bg")
	self.nodeBg:setVisible(false)
	self.labelScoreKey:setString(i18n("shop_text_02"))
	self.labelSegmentKey:setString(i18n("shop_text_03"))
	self.labelReset:setString(i18n("shop_text_04"))
	self.imgL = SoraDGetChildByName(self, "Image_left")
	self.tableBgSpare, _ENV, self.tableItemsSpare, _ENV, self.tableItemsSel, _ENV, self.tableCurItems, _ENV, self.tableSegmentSel, _ENV, self.tableSegment, _ENV, self.imgR = SoraDGetChildByName(self, "Image_right"), SoraDGetChildByName(self, "Image_right"), SoraDGetChildByName(self, "Image_right"), SoraDGetChildByName(self, "Image_right"), SoraDGetChildByName(self, "Image_right"), SoraDGetChildByName(self, "Image_right"), SoraDGetChildByName(self, "Image_right"), SoraDGetChildByName(self, "Image_right"), SoraDGetChildByName(self, "Image_right"), SoraDGetChildByName(self, "Image_right"), SoraDGetChildByName(self, "Image_right"), SoraDGetChildByName(self, "Image_right"), SoraDGetChildByName(self, "Image_right")
	self.beforeSegmentId = nil
	self.itemSize = cc.size(310, 160)
	self:initData()
end
function RemainsShopView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_BUY_LIST", function(target, data)
		if data.buyList then
			self.buyList = data.buyList
			self:initView()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_SCORE_STATUS", function(target, data)
		self.buyList = data.buyList or remainsTeamCtrl.buyList
		self:initView()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_BUY_SUCCESS", function(target, data)
		if not data.score then
			self.buyList = data.buyList
			self:clearOld()
			self:updateMainScrollData()
		else
			self.buyList = data.buyList
			self:clearOld()
			self:updateMainScrollData()
			self.labelScore:setString(string.formatnumberthousands(data.score))
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", function(target, data)
		if not _G.clientEventMgr.judgeIsOpen(gActivityTimeActivityID.RUINS_WAR) then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end)
end
function RemainsShopView:clearOld()
	for i, v in ipairs(self.tableItemsSel) do
		if v.point then
			v.point:setVisible(false)
			table.insert(self.tableItemsSpare, v.point)
			v.point = nil
		end
	end
	self.tableItemsSel, _ENV = ipairs(self.tableItemsSel)
end
function RemainsShopView:initData()
	remainsTeamCtrl:reqGetPlayerBuyList()
	_UPVALUE8_, self.tableSegment = clone(remainsWarRead.tableSegmentDescribe), clone(remainsWarRead.tableSegmentDescribe)
	clone(remainsWarRead.tableSegmentDescribe)[1] = 1
	clone(remainsWarRead.tableSegmentDescribe)[2] = 2
	clone(remainsWarRead.tableSegmentDescribe)[3] = 3
	clone(remainsWarRead.tableSegmentDescribe)[4] = 4
	clone(remainsWarRead.tableSegmentDescribe)[5] = 5
	clone(remainsWarRead.tableSegmentDescribe)[6] = 6
	clone(remainsWarRead.tableSegmentDescribe)[7] = 8
	local clone(remainsWarRead.tableSegmentDescribe)[8], segmentList = 7, clone(remainsWarRead.tableSegmentDescribe)
	table.sort(self.tableSegment, function(a, b)
		return segmentList[a.dan] < segmentList[b.dan]
	end)
	self.labelScore:setString(string.formatnumberthousands(remainsTeamCtrl:getPlayerShopScore()))
	self.beforeSegmentId = remainsTeamCtrl:getPlayerSegment()
	self.labelSegment:setString(remainsWarRead.getDanName(self.beforeSegmentId))
	self.imgSegment:loadTexture(remainsWarRead.getDanIcon(self.beforeSegmentId), ccui.TextureResType.plistType)
end
function RemainsShopView:initView()
	self:fitDevice()
	self:initSegmentScrollData()
	self:jumpToSegment(self.beforeSegmentId)
	self:updateCurSegment(self.beforeSegmentId)
end
function RemainsShopView:fitDevice()
	local dis = display.height - 960
	if 80 < dis then
		local iSize = self.imgL:getContentSize()
		self.imgL:setContentSize(cc.size(iSize.width + dis, iSize.height))
		self.imgR:setContentSize(cc.size(iSize.width + dis, iSize.height))
	end
end
function RemainsShopView:updateCurSegment(curSegment, curSegEntity)
	if curSegEntity and self.beforeSegmentId ~= curSegment then
		self.segmentEntity:setDark()
		self.segmentEntity = curSegEntity
	end
	self.beforeSegmentId = curSegment
	self:clearOld()
	self:updateMainScrollData(true)
end
function RemainsShopView:updateMainScrollData(jumpToTop)
	self.tableCurItems = remainsWarRead.getShopItemList(self.beforeSegmentId)
	for k, v in ipairs(self.tableCurItems) do
		remainsWarRead = nil
		;(nil).data = v
		remainsWarRead, (nil).point = nil, nil
		;(nil).x = 0
		;(nil).pos, (nil).y = nil, 0
		table.insert(self.tableItemsSel, nil)
	end
	self:initMainScroll()
	self:initShopItems()
	if jumpToTop then
		self.mainScroll:jumpToTop()
	end
end
function RemainsShopView:initSegmentScrollData()
	local createSegment = function()
		local remainsSegmentSingle = include("remainsSegmentSingle")
		if self.remainsSegmentSingle == nil then
			self.remainsSegmentSingleNode = cc.uiloader:load(getCCSPath("remainsSegmentSingle"))
			return remainsSegmentSingle.new(self.remainsSegmentSingleNode)
		else
			return remainsSegmentSingle.new(self.remainsSegmentSingleNode:clone())
		end
	end
	local sSize = self.segmentScroll:getContentSize()
	local sW = math.max(sSize.width, #self.tableSegment * 40)
	local scrollInner = self.segmentScroll:getInnerContainer()
	self.segmentScroll:setInnerContainerSize(cc.size(sW, scrollInner.height))
	for i, v in ipairs(self.tableSegment) do
		local single = createSegment()
		single:initData(v)
		if SoraDFIsRA() then
			single:setPositionX(sW - (i - 1) * 40 - 20)
		else
			single:setPositionX((i - 1) * 40 + 20)
		end
		single:setPositionY(sSize.height / 2 - 5)
		single:addTo(self.segmentScroll)
		single:setHandle(handler(self, self.updateCurSegment))
		single:setDark()
		_ENV = handler(self, self.updateCurSegment)
		handler(self, self.updateCurSegment).point = single
		_ENV, handler(self, self.updateCurSegment).id = v.dan, v.dan
		v.dan.x = single:getPositionX()
		handler(self, self.updateCurSegment).pos, v.dan.y = v.dan, single:getPositionY()
		table.insert(self.tableSegmentSel, handler(self, self.updateCurSegment))
	end
end
function RemainsShopView:initMainScroll()
	local scrollInner = self.mainScroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollH = self.mainScroll:getContentSize().height
	local scrollW = self.mainScroll:getContentSize().width
	local numColumn = 2
	local numRows = math.floor((#self.tableItemsSel + numColumn - 1) / numColumn)
	local accumulateHeight = self.itemSize.height * numRows + 30
	for i, v in ipairs(self.tableItemsSel) do
		v.pos.y = accumulateHeight - math.floor((i + numColumn - 1) / numColumn) * self.itemSize.height - 20
		if SoraDFIsRA() then
			v.pos.x = scrollW - (i - 1) % 2 * self.itemSize.width - self.itemSize.width / 2 + 5
		else
			v.pos.x = (i - 1) % 2 * self.itemSize.width + self.itemSize.width / 2
		end
		if v.point then
			v.point:setPositionY(v.pos.y)
			v.point:setPositionX(v.pos.x)
		end
	end
	local totalCellHeight = accumulateHeight
	if scrollH > totalCellHeight then
		local deltaY = scrollH - totalCellHeight
		totalCellHeight = scrollH
		for i, v in ipairs(self.tableItemsSel) do
			v.pos.y = v.pos.y + deltaY
			if v.point then
				v.point:setPositionY(v.pos.y)
			end
		end
	end
	local scrollInnerNewH = totalCellHeight
	offsetY = offsetY - (scrollInnerNewH - scrollInner:getContentSize().height)
	self.mainScroll:setInnerContainerSize(cc.size(scrollW, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
end
function RemainsShopView:initShopItems()
	local scrollInner = self.mainScroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.mainScroll:getContentSize().height
	_ENV = self.mainScroll
	self.mainScroll.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.mainScroll.endY, tableShowH = offsetY + 1.5 * scrollH, self.mainScroll
	for i, v in ipairs(self.tableItemsSel) do
		if v.point then
			if v.pos.y < tableShowH.beginY or v.pos.y > tableShowH.endY then
				v.point:setVisible(false)
				table.insert(self.tableItemsSpare, v.point)
				v.point = nil
			end
		elseif tableShowH.beginY <= v.pos.y and tableShowH.endY >= v.pos.y then
			local single
			if 0 < #self.tableItemsSpare then
				single = table.remove(self.tableItemsSpare)
				single:setVisible(true)
			else
				single = SoraDCreatePanel("remainsShopSingle")
				single:setScroll(self.mainScroll)
				single:setFather(self)
				single:addTo(self.mainScroll)
			end
			if self.buyList then
				v.data.buyNum = self.buyList[tostring(v.data.shopItemID)]
			end
			single:initData(v.data)
			single:setPosition(v.pos)
			v.point = single
		end
	end
	self:updateRowBg()
end
function RemainsShopView:updateRowBg()
	local singleBg
	local rowNum = math.ceil(#self.tableItemsSel / 2)
	local singleBgClone = function()
		local singlebg = self.nodeBg:clone()
		singlebg:setVisible(true)
		return singlebg
	end
	if rowNum < #self.tableBgSpare then
		for i = rowNum + 1, #self.tableBgSpare do
			self.tableBgSpare[i]:setVisible(false)
		end
	end
	for i = 1, rowNum do
		if self.tableBgSpare[i] then
			singleBg = self.tableBgSpare[i]
			singleBg:setVisible(true)
		else
			singleBg = singleBgClone()
			singleBg:addTo(self.mainScroll)
			table.insert(self.tableBgSpare, singleBg)
		end
		singleBg:setPosition(0, self.tableItemsSel[i * 2 - 1].pos.y + 25)
	end
end
function RemainsShopView:jumpToSegment(curSegment)
	for i, v in ipairs(self.tableSegmentSel) do
		if tonumber(v.id) == tonumber(curSegment) then
			local scrollInner = self.segmentScroll:getInnerContainer()
			local scrollW = self.segmentScroll:getContentSize().width
			local posX = v.pos.x
			v.point:setHighLight()
			self.segmentEntity = v.point
			local offsetX = math.max(math.min(0, 0.6 * scrollW - posX), scrollW - scrollInner:getContentSize().width)
			scrollInner:setPositionX(offsetX)
		end
	end
end
function RemainsShopView:mainScrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:initShopItems()
	end
end
function RemainsShopView:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function RemainsShopView:updateTime()
	local day = 7 - os.date("!%w", serviceFunctions.systemTime())
	local leftTime = serviceFunctions.getTodayRemainTime() + day * 3600 * 24
	self.labelTime:setString(SoraDConvertSecondToString(leftTime))
end
function RemainsShopView:endTime()
	SoraDManagerRemoveTimer(self, self.timeHandler)
end
return RemainsShopView
