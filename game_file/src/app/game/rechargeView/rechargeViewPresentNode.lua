local gametop = gModuleMgr.getObject("gametop")
local rechargeRead = include("rechargeRead")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local rechargeViewPresentNode = class("rechargeViewPresentNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("rechargeViewLimitGiftNode")
	end
	return target
end)
function rechargeViewPresentNode:ctor()
	self.curGiftIndex = 1
	self.canClick = true
	self.tblRecycleBtns, _ENV, self.tblBtns, _ENV, self.curGiftData, _ENV, self.curTabTag = nil, nil, nil, nil, nil, nil, nil
	self.scroll = SoraDGetChildByName(self, "ScrollView_category")
	self.nodeInSide = SoraDGetChildByName(self, "Node_inSide")
	self.nodeOutSide = SoraDGetChildByName(self, "Node_outSide")
	self.panelGiftTouch = SoraDGetChildByName(self, "Panel_normalGiftTouch")
	self.btnItem = SoraDGetChildByName(self, "Button_item")
	self.btnItem:setVisible(false)
	self.Text_giftName = SoraDGetChildByName(self, "Text_giftName")
	self.Button_menu = SoraDGetChildByName(self, "Button_menu")
	self.Button_menu:addTouchEventListener(handler(self, self.menuBtnClick))
	self.btnLeft = SoraDGetChildByName(self, "Button_left")
	self.btnRight = SoraDGetChildByName(self, "Button_right")
	self.btnLeft:setVisible(false)
	self.btnRight:setVisible(false)
	self.nodeLadderGift = SoraDGetChildByName(self, "Node_ladderGift")
	self.nodeLadderGift:setVisible(false)
	self.Panel_menuTouch = SoraDGetChildByName(self, "Panel_menuTouch")
	self.Panel_menuTouch:setContentSize(cc.size(640, display.height - 75))
	self.Panel_menuTouch:setVisible(false)
	self.Panel_menuTouch:setTouchEnabled(true)
	self.Panel_menuTouch:addTouchEventListener(handler(self, self.menuMeshClick))
	self.Node_menu = SoraDGetChildByName(self, "Node_menu")
	self.Node_menu:setVisible(false)
	self.Node_menuSingle = SoraDGetChildByName(self.Node_menu, "Node_menuSingle")
	self.Node_menuSingle:setVisible(false)
	self.ScrollView_menu = SoraDGetChildByName(self.Node_menu, "ScrollView_menu")
	SoraDGetChildByName(self, "Image_1"):setFillType(1)
	self.ccs_first = SoraDGetExtendChildFromCCSByName(self, "CCS_rechargeFirstAward_node")
	self.ccs_first:setVisible(false)
	self:bindMsg()
end
function rechargeViewPresentNode:initData()
	self.categoryData, _ENV, self.limitGiftData = self:getLimitData(), self:getLimitData(), self:getLimitData()
	for _, v in ipairs(self.limitGiftData) do
		if v.data.category then
			if not self.categoryData[v.data.category] then
				self.categoryData[v.data.category], _ENV = nil, nil
			end
			table.insert(self.categoryData[v.data.category], v)
			if type(v.data.extraCategory) == "string" and string.len(v.data.extraCategory) > 0 then
				local tmpList = SoraDStringSplit(v.data.extraCategory, ",")
				for _, category in ipairs(tmpList) do
					if not self.categoryData[tonumber(category)] then
						self.categoryData[tonumber(category)], _ENV = category, category
					end
					table.insert(self.categoryData[tonumber(category)], v)
				end
			end
		else
			if not self.categoryData[0] then
				self.categoryData[0], _ENV = ipairs(tmpList)
			end
			table.insert(self.categoryData[0], v)
		end
	end
	if next(self.limitGiftData) then
		self:initBtnScroll()
		self:initView(self.curGiftIndex)
	elseif self.handleRefreshHead then
		self.handleRefreshHead()
	end
	self:setPackageTabNums()
	self:updateMenu()
	if self.tabType == gRechargeCenterCategory.RECHARGE_PRESENT then
		_ENV = self.curGiftIndex
		self.curGiftIndex.byUID = true
		local isFirst = SoraDConfigGet("Game:rechargePresentActivity:first~bool", self.curGiftIndex)
		if isFirst then
			local gameGuideView = include("gameGuideView").new()
			gameGuideView:startGuideWithStep(71001)
			gameGuideView:show()
			_ENV = table.insert
			table.insert.byUID = true
			SoraDConfigSet("Game:rechargePresentActivity:first~bool", false, table.insert)
		end
	end
end
function rechargeViewPresentNode:btnSelectClickCallBack(target, event)
	self:turnPageToIndex(target:getTag(), true)
end
function rechargeViewPresentNode:updateMenu()
	local diffData = self:makeDiffData()
	self.ScrollView_menu:removeAllChildren()
	local scrollH = math.max(self.ScrollView_menu:getContentSize().height, #diffData * 48)
	self.ScrollView_menu:setInnerContainerSize(cc.size(self.ScrollView_menu:getContentSize().width, scrollH))
	self.menuArry, _ENV = self.ScrollView_menu.setInnerContainerSize, self.ScrollView_menu.setInnerContainerSize
	for k, v in ipairs(diffData) do
		local panel = self.Node_menuSingle:clone()
		panel:setVisible(true)
		panel:setPosition(0, scrollH - 48 * k)
		panel:addTo(self.ScrollView_menu)
		local info = rechargeRead.getRechargePresentPageViewData(v.data.rechargeID)
		dump(info, "info", 10)
		local giftName = i18n(info.activeName)
		panel.touch = SoraDGetChildByName(panel, "Panel_menuSingle")
		panel.touch:setSwallowTouches(false)
		panel.touch = include("commonBtnInstance").new(panel.touch)
		panel.touch:setScroll(self.ScrollView_menu)
		panel.touch:setTag(k)
		panel.touch:setHandle(handler(self, self.btnSelectClickCallBack))
		panel.Image_select = SoraDGetChildByName(panel, "Image_select")
		panel.Image_select:setVisible(self.curGiftIndex == k)
		panel.Text_menu = SoraDGetChildByName(panel, "Text_menu")
		panel.Text_menu:setString(giftName)
		self.menuArry[k] = panel
	end
	self:updateMenuSelect()
end
function rechargeViewPresentNode:setTabType(tabType)
	self.tabType = tabType
end
function rechargeViewPresentNode:updateMenuSelect(isNoMove)
	for k, v in ipairs(self.menuArry) do
		v.Image_select:setVisible(self.curGiftIndex == k)
		v.Text_menu:setColor(self.curGiftIndex == k and cc.c3b(255, 255, 200) or cc.c3b(150, 150, 135))
	end
	if not isNoMove then
		local inner = self.ScrollView_menu:getInnerContainer()
		local posY = self.ScrollView_menu:getContentSize().height - self.ScrollView_menu:getInnerContainerSize().height + 48 * (self.curGiftIndex - 1)
		inner:setPositionY(math.min(0, posY))
	end
end
function rechargeViewPresentNode:getLimitData()
	local rechargePresentUtil = include("rechargePresentUtil")
	local _ENV, activeDataList = "rechargePresentUtil", "rechargePresentUtil"
	local rType = gRechargeActiveModelType.RECHARGE_PRESENT
	local activityID = rechargePresentUtil.getActivityIDByCategory(self.tabType)
	local group = rechargePresentUtil.getActivityClassType(activityID)
	activeDataList = rechargeRead.getRechargePresentCfgByGroup(group)
	rType = gRechargeActiveModelType.RECHARGE_PRESENT
	local _ENV, normalSortList = gRechargeActiveModelType, gRechargeActiveModelType
	for i, v in ipairs(activeDataList) do
		local extraData = rechargePresentUtil.getRechargePresentExchangeNum(v, activityID)
		v.payType = v.limitType
		v.extraData = extraData
		_ENV = nil
		;(nil).rid = v.rechargeID
		;(nil).rType = rType
		;(nil).data = v
		table.insert(normalSortList, nil)
	end
	if next(normalSortList) then
		table.sort(normalSortList, function(l, r)
			local lWeight = l.data.weight or 0
			local rWeight = r.data.weight or 0
			if lWeight ~= rWeight then
				return lWeight > rWeight
			else
				return l.rid < r.rid
			end
		end)
	end
	return normalSortList
end
function rechargeViewPresentNode:initBtnScroll()
	for _, v in ipairs(self.tblBtns) do
		v:setVisible(false)
		table.insert(self.tblRecycleBtns, v)
	end
	self.tblBtns, _ENV = ipairs(self.tblBtns)
	local getBtn = function(...)
		local reBtn = table.remove(self.tblRecycleBtns)
		if reBtn == nil then
			reBtn = self.btnItem:clone()
			reBtn:addTo(self.scroll)
		end
		reBtn:setVisible(true)
		return reBtn
	end
	local sortTbl = activityShowCtrl:getLabelSort()
	local keys = table.keys(self.categoryData)
	table.sort(keys, function(l, r)
		local ls = sortTbl[l] or 999
		local rs = sortTbl[r] or 999
		return ls < rs
	end)
	dump(keys, "rechargekeys")
	local itemSize = cc.size(140, 140)
	local sSize = self.scroll:getContentSize()
	local sW = math.max(sSize.width, #keys * 140)
	self.scroll:setInnerContainerSize(cc.size(sW, sSize.height))
	sSize = self.scroll:getContentSize()
	sW = math.max(sSize.width, #keys * 140)
	local oldTag = keys[1]
	for idx, val in ipairs(keys) do
		local info = rechargeRead.getCategoryConfig(val)
		local categoryItem = getBtn()
		categoryItem:setTag(val)
		categoryItem:setPosition(SoraDFPosX(sW - idx * itemSize.width + itemSize.width / 2, sW), 65)
		categoryItem:addTouchEventListener(handler(self, self.categoryBtnClick))
		categoryItem:getChildByName("Sprite_item"):setSpriteFrame(info.icon)
		categoryItem:getChildByName("Text_item"):setString(info.name and i18n(info.name))
		categoryItem:getChildByName("Text_item"):setColor(cc.c3b(151, 146, 134))
		categoryItem:getChildByName("frame_select"):setVisible(false)
		categoryItem:getChildByName("Node_effect"):setVisible(false)
		if not categoryItem.etNode then
			categoryItem.etNode = SoraDCreatAnimation("animationCZLBS")
			categoryItem.etNode:addTo(categoryItem:getChildByName("Node_effect"))
		end
		table.insert(self.tblBtns, categoryItem)
		if self.curTabTag and val == self.curTabTag then
			oldTag = self.curTabTag
		end
	end
	self.scroll:setInnerContainerSize(cc.size(sW, sSize.height))
	if SoraDFIsRA() then
		self.scroll:jumpToRight()
	else
		self.scroll:jumpToLeft()
	end
	self.curTabTag = oldTag
	self.curGiftData = self.categoryData[self.curTabTag]
	self:setCurBtn()
end
function rechargeViewPresentNode:makeDiffData()
	local packageDiffData = self.curGiftData
	return packageDiffData
end
function rechargeViewPresentNode:setPackageTabNums()
	self.packageBtns, _ENV, self.packageTxts, _ENV = nil, nil, nil, nil
	if next(self.packageBtns) then
		if not self.packageBtns[self.curGiftIndex] then
			self.curGiftIndex = 1
		end
		self:packageBtnClick(self.packageBtns[self.curGiftIndex], ccui.TouchEventType.ended, true)
	end
end
function rechargeViewPresentNode:packageBtnClick(button, eventType, noSound)
	if eventType == ccui.TouchEventType.ended then
		if not noSound then
			SoraDPlaySound()
		end
		for i, v in ipairs(self.packageTxts) do
			v:setColor(i == button:getTag() and cc.c3b(255, 200, 134) or cc.c3b(141, 130, 120))
		end
		for i, v in ipairs(self.packageBtns) do
			if i == button:getTag() then
				v:loadTextureNormal("btn_shop_current_02.png", ccui.TextureResType.plistType)
				v:loadTexturePressed("btn_shop_current_02.png", ccui.TextureResType.plistType)
			else
				v:loadTextureNormal("bg_transparent.png", ccui.TextureResType.plistType)
				v:loadTexturePressed("bg_transparent.png", ccui.TextureResType.plistType)
			end
			v:setTouchEnabled(i ~= button:getTag())
		end
		if button:getTag() == self.curGiftIndex then
			return
		end
		local offsetX = button:getTag() < self.curGiftIndex and -display.width or display.width
		self.curGiftIndex = button:getTag()
		self.nodeOutSide:setPositionX(offsetX)
		self.nodeInSide:setPositionX(0)
		local diffData = self:makeDiffData()
		self:createGiftNode(diffData[self.curGiftIndex], self.nodeOutSide, true)
		self.pagePoint:setCurLight(self.curGiftIndex)
		transition.execute(self.nodeOutSide, cca.moveTo(0.2, 0, self.nodeOutSide:getPositionY()))
		_ENV = 0.2
		;(0.2).onComplete = function()
			self.nodeOutSide, self.nodeInSide = self.nodeInSide, self.nodeOutSide
			local curPage = self.nodeOutSide:getChildByName("rechargePresentPageNode")
			if curPage then
				curPage:setVisible(false)
			end
		end
		transition.execute(self.nodeInSide, cca.moveTo(0.2, -offsetX, self.nodeInSide:getPositionY()), 0.2)
	end
end
function rechargeViewPresentNode:cutNode(isLadder)
	self.pagePoint:setVisible(not isLadder)
	self.nodeOutSide:setVisible(not isLadder)
	self.nodeInSide:setVisible(not isLadder)
	self.nodeLadderGift:setVisible(isLadder)
end
function rechargeViewPresentNode:createGiftNode(_info, _parent, _turnPage)
	self.nodeLadderGift:setVisible(false)
	self.nodeInSide:setVisible(true)
	local panel = _parent:getChildByName("rechargePresentPageNode")
	if panel == nil then
		panel = SoraDCreatePanel("rechargePresentPageNode")
		panel:addTo(_parent)
		panel:setName("rechargePresentPageNode")
		panel:setContentHeight(display.height - 200)
		panel:setVisible(false)
	end
	panel:initData(_info, gRechargeActiveFromEnum.ROAD18 .. string.format("%0.2d", self.curTabTag), _turnPage)
	panel:setPosition(0, 0)
	panel:setVisible(true)
	self:cutNode(false)
end
function rechargeViewPresentNode:reNewNum(isLeft)
	local diffData = self:makeDiffData()
	local _max = #diffData
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
function rechargeViewPresentNode:createIndicatorNumber()
	self.pagePoint = include("commonIndexNumber").new()
	self.pagePoint:setPosition(0, -display.height + 168)
	self.pagePoint:addTo(self, 99)
end
function rechargeViewPresentNode:refreshPagePoint()
	local diffData = self:makeDiffData()
	_UPVALUE0_ = nil
	;(nil).count = #diffData
	;(nil).intervalWidth = 8
	;(nil).begin = self.curGiftIndex
	self.pagePoint:initData(nil)
end
function rechargeViewPresentNode:bindMsg()
	self:createIndicatorNumber()
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
	self.btnRight:addTouchEventListener(function(button, eventType, notSound)
		if eventType == ccui.TouchEventType.ended then
			_ENV = nil
			;(nil).msg = "MESSAGE_CLIENT_RECHARGECENTER_TIMEOVER"
			SoraDSendMessage(nil)
			self:turnPage(false, notSound)
		end
	end)
	self.btnLeft:addTouchEventListener(function(button, eventType, notSound)
		if eventType == ccui.TouchEventType.ended then
			_ENV = nil
			;(nil).msg = "MESSAGE_CLIENT_RECHARGECENTER_TIMEOVER"
			SoraDSendMessage(nil)
			self:turnPage(true, notSound)
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIEWREFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_ACTIVETIMEOUT", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_LUCKYGIFTREFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_MAIN_BREAKICE_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_RECHARGE_PRESENT_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_CLOSE_GIFT_MENU", function()
		self.Node_menu:setVisible(false)
		self.Panel_menuTouch:setVisible(false)
	end)
	self.panelGiftTouch:setTouchEnabled(true)
	self.panelGiftTouch:setSwallowTouches(false)
	self.panelGiftTouch:addTouchEventListener(handler(self, self.giftTouchCallBack))
end
function rechargeViewPresentNode:giftTouchCallBack(panel, eventType)
	if eventType == ccui.TouchEventType.ended then
		_ENV = nil
		;(nil).msg = "MESSAGE_CLIENT_RECHARGECENTER_TIMEOVER"
		SoraDSendMessage(nil)
		if self.canClick and self.nodeInSide:isVisible() then
			local touchBeganPoint = panel:getTouchBeganPosition()
			local touchmovePoint = panel:getTouchEndPosition()
			local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
			if distance < 10 then
			elseif touchBeganPoint.x - touchmovePoint.x < -30 and math.abs(touchBeganPoint.y - touchmovePoint.y) < 150 then
				print("右移")
				self:turnPage(true)
			elseif touchBeganPoint.x - touchmovePoint.x > 30 and math.abs(touchBeganPoint.y - touchmovePoint.y) < 150 then
				print("左移")
				self:turnPage(false)
			end
		end
	end
end
function rechargeViewPresentNode:turnPageToIndex(index, isNoMove)
	if self.canClick and self.canTurnPage then
		self.canClick = false
		local offsetX = 0
		if index > self.curGiftIndex then
			offsetX = -display.width
		elseif index < self.curGiftIndex then
			offsetX = display.width
		end
		self.curGiftIndex = index
		self.nodeOutSide:setPositionX(offsetX)
		self.nodeInSide:setPositionX(0)
		local diffData = self:makeDiffData()
		self:createGiftNode(diffData[self.curGiftIndex], self.nodeOutSide, true)
		self.pagePoint:setCurLight(self.curGiftIndex)
		local giftName
		if diffData[self.curGiftIndex].data then
			giftName = i18n(diffData[self.curGiftIndex].data.giftStyle.activeName)
		else
			giftName = i18n(diffData[self.curGiftIndex].giftStyle.activeName)
		end
		self.Text_giftName:setString(giftName)
		transition.execute(self.nodeOutSide, cca.moveTo(0.2, 0, self.nodeOutSide:getPositionY()))
		_ENV = 0.2
		;(0.2).onComplete = function()
			self.nodeOutSide, self.nodeInSide = self.nodeInSide, self.nodeOutSide
			local curPage = self.nodeOutSide:getChildByName("rechargePresentPageNode")
			if curPage then
				curPage:setVisible(false)
			end
		end
		transition.execute(self.nodeInSide, cca.moveTo(0.2, -offsetX, self.nodeInSide:getPositionY()), 0.2)
		_ENV = 0.2
		;(0.2).delay = 0.2
		;(0.2).onComplete = function()
			self.canClick = true
		end
		transition.execute(self, nil, 0.2)
		self:updateMenuSelect(isNoMove)
	end
end
function rechargeViewPresentNode:turnPage(isLeft, notSound)
	if self.canClick and self.canTurnPage then
		if not notSound then
			SoraDPlaySound()
		end
		advertiseCollect.TriggerEvent(gSDKDef.TDonEvent.advertise_switch_gift)
		self.canClick = false
		local offsetX = isLeft and -display.width or display.width
		self:reNewNum(isLeft)
		self.nodeOutSide:setPositionX(offsetX)
		self.nodeInSide:setPositionX(0)
		for i, v in ipairs(self.packageTxts) do
			v:setColor(i == self.curGiftIndex and cc.c3b(255, 200, 134) or cc.c3b(141, 130, 120))
		end
		for i, v in ipairs(self.packageBtns) do
			if i == self.curGiftIndex then
				v:loadTextureNormal("btn_shop_current_02.png", ccui.TextureResType.plistType)
				v:loadTexturePressed("btn_shop_current_02.png", ccui.TextureResType.plistType)
			else
				v:loadTextureNormal("bg_transparent.png", ccui.TextureResType.plistType)
				v:loadTexturePressed("bg_transparent.png", ccui.TextureResType.plistType)
			end
			v:setTouchEnabled(i ~= self.curGiftIndex)
		end
		local diffData = self:makeDiffData()
		self:createGiftNode(diffData[self.curGiftIndex], self.nodeOutSide, true)
		self.pagePoint:setCurLight(self.curGiftIndex)
		local giftName
		if diffData[self.curGiftIndex].data then
			giftName = i18n(diffData[self.curGiftIndex].data.giftStyle.activeName)
		else
			giftName = i18n(diffData[self.curGiftIndex].giftStyle.activeName)
		end
		self.Text_giftName:setString(giftName)
		transition.execute(self.nodeOutSide, cca.moveTo(0.2, 0, self.nodeOutSide:getPositionY()))
		_ENV = 0.2
		;(0.2).onComplete = function()
			self.nodeOutSide, self.nodeInSide = self.nodeInSide, self.nodeOutSide
			local curPage = self.nodeOutSide:getChildByName("rechargePresentPageNode")
			if curPage then
				curPage:setVisible(false)
			end
		end
		transition.execute(self.nodeInSide, cca.moveTo(0.2, -offsetX, self.nodeInSide:getPositionY()), 0.2)
		_ENV = 0.2
		;(0.2).delay = 0.2
		;(0.2).onComplete = function()
			self.canClick = true
		end
		transition.execute(self, nil, 0.2)
		self:updateMenuSelect()
	end
end
function rechargeViewPresentNode:setBtnVisiable(bool)
	self.btnLeft:setVisible(bool)
	self.btnRight:setVisible(bool)
	self.canTurnPage = bool
end
function rechargeViewPresentNode:initView(giftIndex)
	if self.curGiftData and #self.curGiftData >= 1 then
		self.curGiftIndex = math.min(giftIndex or 1, #self.curGiftData)
		local diffData = self:makeDiffData()
		self:createGiftNode(diffData[self.curGiftIndex], self.nodeInSide, false)
		self:refreshPagePoint()
		self:setBtnVisiable(1 < #diffData)
		local giftName
		if diffData[self.curGiftIndex].data then
			giftName = i18n(diffData[self.curGiftIndex].data.giftStyle.activeName)
		else
			giftName = i18n(diffData[self.curGiftIndex].giftStyle.activeName)
		end
		self.Text_giftName:setString(giftName)
	else
		self:setBtnVisiable(false)
	end
end
function rechargeViewPresentNode:setCurBtn(...)
	if self.curTabBtn then
		self.curTabBtn:getChildByName("Sprite_down"):setSpriteFrame("frame_cz_labelbg_03.png")
		self.curTabBtn:getChildByName("Text_item"):setColor(cc.c3b(151, 146, 134))
		self.curTabBtn:getChildByName("frame_select"):setVisible(false)
		self.curTabBtn:getChildByName("Node_effect"):setVisible(false)
	end
	for _, v in pairs(self.tblBtns) do
		if v:getTag() == self.curTabTag then
			v:getChildByName("Sprite_down"):setSpriteFrame("frame_cz_labelbg_02.png")
			v:getChildByName("Text_item"):setColor(cc.c3b(255, 249, 214))
			v:getChildByName("frame_select"):setVisible(true)
			v:getChildByName("Node_effect"):setVisible(true)
			local ownPosX = v:getPositionX()
			local scrollW = self.scroll:getInnerContainer():getContentSize().width
			self.scroll:scrollToPercentHorizontal(math.min(math.max(0, 100 * (ownPosX - 320) / (scrollW - 640)), 100), 0.5, true)
			self.curTabBtn = v
			return
		end
	end
end
function rechargeViewPresentNode:categoryBtnClick(button, eventType, notSound)
	if eventType == ccui.TouchEventType.ended then
		local idx = button:getTag()
		_ENV = nil
		;(nil).tab = "limitGift"
		;(nil).class = idx
		userSDKManager.logEvent(gSDKDef.TDonEvent.click_rechargeview_switchtab, nil)
		advertiseCollect.TriggerEvent(gSDKDef.TDonEvent.advertise_recharge_btn)
		self.curTabTag = idx
		self.curGiftData = self.categoryData[self.curTabTag]
		self:initView()
		self:setCurBtn()
		self:setPackageTabNums()
		self:updateMenu()
	end
end
function rechargeViewPresentNode:menuBtnClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.Panel_menuTouch:setVisible(not self.Node_menu:isVisible())
		self.Node_menu:setVisible(not self.Node_menu:isVisible())
	end
end
function rechargeViewPresentNode:menuMeshClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		self.Panel_menuTouch:setVisible(false)
		self.Node_menu:setVisible(false)
	end
end
function rechargeViewPresentNode:jump2rechargeID(rechargeID)
	rechargeID = tonumber(rechargeID)
	for k, v in pairs(self.categoryData) do
		for m, n in ipairs(v) do
			if n.data.ID and n.data.ID == rechargeID or n.data.rid == rechargeID then
				self:jump2gift(k, rechargeID)
				return
			end
		end
	end
end
function rechargeViewPresentNode:jump2Holiday(tabIndex, targetID)
	if self.categoryData and self.categoryData[tabIndex] then
		self.curTabTag = tabIndex
		self.curGiftData = self.categoryData[self.curTabTag]
	end
	self:initView()
	self:setCurBtn()
	self:updateMenu()
	if targetID then
		for k, v in ipairs(self.curGiftData) do
			if targetID == v.rid then
				self:turnPageToIndex(k, true)
				break
			end
		end
	end
end
function rechargeViewPresentNode:jump2gift(category, giftid)
	local findladdergift = function(giftinfo, id)
		if not giftinfo.data then
			local _ENV, loopData = giftinfo.data, giftinfo.data
		end
		for i, v in ipairs(loopData) do
			if v.ID == id then
				return i
			end
			if v.nextLadderList then
				for key, val in pairs(v.nextLadderList) do
					if val.ID == id then
						return i
					end
				end
			end
		end
	end
	local findgift = function(giftinfo, id)
		for i, v in ipairs(giftinfo) do
			if v.rid == id then
				return i
			end
		end
	end
	if self.categoryData and self.categoryData[category] then
		if 20 == category then
			local findIndex = findladdergift(self.categoryData[20][1], giftid)
			print("findIndex=", findIndex)
			self.curTabTag = 20
			self.curGiftData = self.categoryData[20]
			if findIndex then
				self.ladderJumpIndex = findIndex
			end
			self:initView()
			self:setCurBtn()
		else
			local findIndex = findgift(self.categoryData[category], giftid)
			print("findIndex=", findIndex)
			if findIndex then
				self.curTabTag = category
				self.curGiftData = self.categoryData[category]
				self:initView(findIndex)
				self:setCurBtn()
				self:setPackageTabNums()
				self:updateMenu()
			end
		end
	end
end
function rechargeViewPresentNode:jump2giftByList(category, giftList)
	local findgift = function(giftinfo)
		dump(giftinfo, "giftinfo", 10)
		local price = 0
		local index
		for i, v in ipairs(giftinfo) do
			local giftStyle = rechargeRead.getPageViewData(v.rid)
			if giftStyle and SoraDisInList(v.rid, giftList) and price < v.data.price then
				index = i
				print(index, "index")
				price = v.data.price
				print(price, "price")
			end
		end
		return index
	end
	if self.categoryData and self.categoryData[category] then
		local findIndex = findgift(self.categoryData[category]) or 1
		print("findIndex=", findIndex)
		self.curTabTag = category
		self.curGiftData = self.categoryData[category]
		self:initView(findIndex)
		self:setCurBtn()
		self:setPackageTabNums()
		self:updateMenu()
	end
end
function rechargeViewPresentNode:jump2giftByType(category, activeModelType)
	local findgift = function(giftinfo, modelType)
		dump(giftinfo, "giftinfo", 10)
		local price = 0
		local index
		for i, v in ipairs(giftinfo) do
			local giftStyle = rechargeRead.getPageViewData(v.rid)
			if giftStyle and giftStyle.activeModelType == modelType and price < v.data.price then
				index = i
				print(index, "index")
				price = v.data.price
				print(price, "price")
			end
		end
		return index
	end
	if self.categoryData and self.categoryData[category] then
		local findIndex = findgift(self.categoryData[category], activeModelType) or 1
		print("findIndex=", findIndex)
		self.curTabTag = category
		self.curGiftData = self.categoryData[category]
		self:initView(findIndex)
		self:setCurBtn()
		self:setPackageTabNums()
		self:updateMenu()
	end
end
function rechargeViewPresentNode:setFatherHeadRefresh(handl)
	self.handleRefreshHead = handl
end
return rechargeViewPresentNode
