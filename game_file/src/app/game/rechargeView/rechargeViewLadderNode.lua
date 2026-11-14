local rechargeRead = include("rechargeRead")
local RechargeViewLadderNode = class("rechargeViewLadderNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("rechargeViewLadderNode")
	end
	return target
end)
function RechargeViewLadderNode:ctor()
	self.curGiftIndex = 1
	self.ladderBar, _ENV, self.canClick = nil, nil, true
	self.scrollOutSide = SoraDGetChildByName(self, "ScrollView_ladderGift_outSide")
	self.scrollInSide = SoraDGetChildByName(self, "ScrollView_ladderGift_inSide")
	self.nodeLadderGiftContent = SoraDGetChildByName(self, "Node_ladderGiftContent")
	self.btnLadder = SoraDGetChildByName(self, "Image_nextGiftBar")
	self.panelGiftTouch = SoraDGetChildByName(self, "Panel_normalGiftTouch")
	self.btnLadder:setVisible(false)
	self:setScrollTouch()
	self:initOcxs()
end
function RechargeViewLadderNode:setScrollTouch(...)
	local turnNextStop = function(img, eventType)
		if eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.began then
			_ENV = nil
			;(nil).msg = "MESSAGE_CLIENT_RECHARGECENTER_TIMEOVER"
			SoraDSendMessage(nil)
		end
	end
	self.scrollOutSide:addTouchEventListener(turnNextStop)
	self.scrollInSide:addTouchEventListener(turnNextStop)
end
function RechargeViewLadderNode:initData(giftInfo, giftIndex, parent)
	self.curGiftIndex = giftIndex or 1
	self.ladderGiftData = giftInfo
	self.parent = parent
	self:initView()
end
function RechargeViewLadderNode:initView()
	if #self.ladderGiftData > 1 then
		self:setBtnVisiable(true)
	else
		self:setBtnVisiable(false)
	end
	self:loadPage(self.scrollInSide, self.curGiftIndex)
	if not next(self.ladderGiftData) and self.handleRefreshHead then
		self.handleRefreshHead()
	end
end
function RechargeViewLadderNode:loadPage(curScroll, index)
	dump(self.ladderGiftData, "self.ladderGiftData", 10)
	if self.ladderGiftData then
		local curLadderInfo = self.ladderGiftData
		local curLadderNextList = self.ladderGiftData.nextLadderList
		local barH = 50
		local pageHeigh = 0
		local needHeight = 0
		local pageBottomY = 0
		local ladderNodeHeigh = display.height - 100
		if curLadderNextList == nil or #curLadderNextList < 1 then
			pageBottomY = 0
			pageHeigh = ladderNodeHeigh
			needHeight = pageHeigh
		elseif 2 <= #curLadderNextList then
			pageBottomY = 1.5 * barH
			pageHeigh = ladderNodeHeigh - pageBottomY
			needHeight = pageHeigh + #curLadderNextList * barH
		elseif #curLadderNextList == 1 then
			pageBottomY = barH
			pageHeigh = ladderNodeHeigh - pageBottomY
			needHeight = pageHeigh + barH
		end
		local sSize = curScroll:getContentSize()
		curScroll:setContentSize(cc.size(sSize.width, ladderNodeHeigh))
		curScroll:setInnerContainerSize(cc.size(sSize.width, needHeight))
		local giftModelType = rechargeRead.getPageViewData(curLadderInfo.ID).activeModelType
		_ENV = curLadderInfo.ID
		curLadderInfo.ID.rid = curLadderInfo.ID
		curLadderInfo.ID.rType = giftModelType
		curLadderInfo.ID.data = curLadderInfo
		local curLadderInfo.ID.isLadderLocked, barData = false, curLadderInfo.ID
		local page = self:createGiftNode(barData, pageHeigh, curScroll)
		page:setFatherPanel(curScroll)
		page:popDesView()
		page:setPosition(sSize.width / 2, needHeight)
		if curScroll.ladderBar == nil then
			curScroll.ladderBar, _ENV = curScroll.ladderBar, curScroll.ladderBar
		end
		for i, v in ipairs(curScroll.ladderBar) do
			v:setVisible(false)
		end
		self.ladderBar, _ENV = ipairs(curScroll.ladderBar)
		if curLadderNextList then
			for i, v in ipairs(curLadderNextList) do
				local showBar
				if curScroll.ladderBar[i] then
					showBar = curScroll.ladderBar[i]
				else
					showBar = self:createLadderBtn(curScroll)
					curScroll.ladderBar[i] = showBar
				end
				if showBar then
					_ENV = curScroll.ladderBar
					curScroll.ladderBar.rid = v.ID
					curScroll.ladderBar.rType = giftModelType
					curScroll.ladderBar.data = v
					showBar.giftData, curScroll.ladderBar.isLadderLocked = curScroll.ladderBar, true
					showBar:setPosition(sSize.width / 2, (#curLadderNextList - i + 1) * barH + 190)
					showBar:getChildByName("Text_giftName"):setString(i18n(rechargeRead.getPageViewData(v.ID).activeName))
					showBar:setVisible(true)
				end
			end
		end
		self:createPagePoint(curScroll, index, pageHeigh)
	end
end
function RechargeViewLadderNode:setFatherHeadRefresh(handl)
	self.handleRefreshHead = handl
end
function RechargeViewLadderNode:reNewNum(isLeft)
	local _max = #self.ladderGiftData
	local _cur = self.curGiftIndex
	local _min = 1
	if isLeft then
		_cur = _cur - 1
		if _cur < 1 then
			_cur = _max
		end
	else
		_cur = _cur + 1
		if _max < _cur then
			_cur = _min
		end
	end
	self.curGiftIndex = _cur
end
function RechargeViewLadderNode:createGiftNode(_info, pageHeigh, _parent)
	if _parent.pageNode == nil then
		_parent.pageNode = SoraDCreatePanel("rechargeViewPageNode")
		_parent.pageNode:addTo(_parent)
	end
	_parent.pageNode:setVisible(true)
	_parent.pageNode:setContentHeight(pageHeigh - 50, true)
	_parent.pageNode:initData(_info, gRechargeActiveFromEnum.ROAD20)
	return _parent.pageNode
end
function RechargeViewLadderNode:ladderBtnClick(bar, eventType)
	if eventType == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(bar, self.ladderScroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if bar.giftData then
			dump(bar.giftData, "bar.giftData======", 10)
			if bar.giftData.isLadderLocked then
				local listBox = SoraDCreatePanel("rechargePopView")
				listBox:initLadderGiftData(bar.giftData.data, gRechargeActiveFromEnum.ROAD03, false)
				listBox:show()
			else
				local listBox = SoraDCreatePanel("rechargePopView")
				listBox:initData(bar.giftData.data, gRechargeActiveFromEnum.ROAD03, false)
				listBox:show()
			end
		end
	elseif eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = bar:getTouchBeganPosition()
		local touchmovePoint = bar:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif eventType == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function RechargeViewLadderNode:turnPage(isLeft, notSound)
	self.parent:turnPage(isLeft, notSound)
end
function RechargeViewLadderNode:createPagePoint(curScroll, curIndex, pageHeigh)
	if #self.ladderGiftData <= 0 then
		return
	end
	local curScrollSize = curScroll:getInnerContainer():getContentSize()
	local pagePoint = curScroll.dicatorNumber
	if pagePoint == nil then
		local pointNode = cc.Node:create()
		pointNode:addTo(curScroll, 99)
		local imageItemBg = ccui.ImageView:create("frame_lace_09_02.png", ccui.TextureResType.plistType)
		imageItemBg:setName("Image_bg")
		imageItemBg:setPosition(0, 45)
		imageItemBg:addTo(pointNode)
		local imageLight = ccui.ImageView:create("frame_lace_09_01.png", ccui.TextureResType.plistType)
		imageLight:setName("Image_light")
		imageLight:setPosition(0, 45)
		imageLight:addTo(pointNode)
		pagePoint = include("commonScrollIndicatorNumber").new(pointNode)
		curScroll.dicatorNumber = pagePoint
	end
	_ENV = ccui.ImageView:create("frame_lace_09_01.png", ccui.TextureResType.plistType)
	ccui.ImageView:create("frame_lace_09_01.png", ccui.TextureResType.plistType).count = #self.ladderGiftData
	ccui.ImageView:create("frame_lace_09_01.png", ccui.TextureResType.plistType).intervalWidth = 40
	ccui.ImageView:create("frame_lace_09_01.png", ccui.TextureResType.plistType).begin = curIndex
	pagePoint:initData((ccui.ImageView:create("frame_lace_09_01.png", ccui.TextureResType.plistType)))
	local rechargeViewPageNode = include("rechargeViewPageNode")
	local padSuitHeigh = rechargeViewPageNode.getPadSuitHeigh(pageHeigh)
	pagePoint:setPosition(curScrollSize.width / 2, curScrollSize.height - 337 + padSuitHeigh)
end
function RechargeViewLadderNode:createLadderBtn(_parent)
	local copyItem = self.btnLadder:clone()
	copyItem:addTo(_parent)
	copyItem:setSwallowTouches(false)
	copyItem:addTouchEventListener(handler(self, self.ladderBtnClick))
	copyItem:setVisible(true)
	return copyItem
end
function RechargeViewLadderNode:initOcxs()
	self.btnLeft = SoraDGetChildByName(self, "Button_left")
	self.btnRight = SoraDGetChildByName(self, "Button_right")
	local judge2move = function(_sprite, _forward)
		_UPVALUE1_ = nil
		;(nil)[1] = cca.moveBy(1, _forward * 15, 0)
		;(nil)[2] = cca.moveBy(1, -_forward * 15, 0)
		;(nil)[3] = cca.moveBy(1, -_forward * 15, 0)
		;(nil)[4] = cca.moveBy(1, -_forward * 15, 0)
		;(nil)[5] = cca.moveBy(1, -_forward * 15, 0)
		local seqList = cca.seq(nil)
		local acList = cc.RepeatForever:create(seqList)
		_sprite:runAction(acList)
	end
	judge2move(self.btnRight:getChildByName("Sprite_arrow"), -1)
	judge2move(self.btnLeft:getChildByName("Sprite_arrow"), -1)
	self.btnRight:addTouchEventListener(function(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			_ENV = nil
			;(nil).msg = "MESSAGE_CLIENT_RECHARGECENTER_TIMEOVER"
			SoraDSendMessage(nil)
			self:turnPage(false)
		end
	end)
	self.btnLeft:addTouchEventListener(function(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			_ENV = nil
			;(nil).msg = "MESSAGE_CLIENT_RECHARGECENTER_TIMEOVER"
			SoraDSendMessage(nil)
			self:turnPage(true)
		end
	end)
	self.panelGiftTouch:setTouchEnabled(true)
	self.panelGiftTouch:setSwallowTouches(false)
	self.panelGiftTouch:addTouchEventListener(function(panel, eventType)
		if eventType == ccui.TouchEventType.ended then
			_ENV = nil
			;(nil).msg = "MESSAGE_CLIENT_RECHARGECENTER_TIMEOVER"
			SoraDSendMessage(nil)
			if self.canClick then
				local touchBeganPoint = panel:getTouchBeganPosition()
				local touchmovePoint = panel:getTouchEndPosition()
				local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
				print("distance = ", distance)
				if distance < 10 then
					local curPage = self:getChildByName("cur_rechargeViewPageNode")
					if curPage then
						curPage:popDesRechargeView()
					end
				elseif touchBeganPoint.x - touchmovePoint.x < -30 and math.abs(touchBeganPoint.y - touchmovePoint.y) < 150 then
					print("右移")
					self:turnPage(true)
				elseif touchBeganPoint.x - touchmovePoint.x > 30 and math.abs(touchBeganPoint.y - touchmovePoint.y) < 150 then
					print("左移")
					self:turnPage(false)
				end
			end
		end
	end)
end
function RechargeViewLadderNode:setBtnVisiable(bool)
	self.btnLeft:setVisible(bool)
	self.btnRight:setVisible(bool)
	self.canTurnPage = bool
end
function RechargeViewLadderNode:jump2gift(giftIndex)
	self.curGiftIndex = giftIndex
	self:initView()
end
return RechargeViewLadderNode
