local OCX_TYPE_PAGE = 0
local OCX_TYPE_BUTTON = 1
local OCX_TYPE_TEXT = 2
local OCX_TYPE_TIMER = 3
local OCX_TYPE_CLICKIMAGE = 4
local OCX_TYPE_CREATESPRITE = 5
local gametop = gModuleMgr.getObject("gametop")
local rechargeRead = include("rechargeRead")
local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
local RechargeTinyPageNode = class("rechargeTinyPageNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("rechargeTinyPageNode")
	end
	return target
end)
function RechargeTinyPageNode:ctor()
	self.haveEvent = false
	self.timerInterval = 0
	self.refreshHandl = nil
	self.pageView = SoraDGetChildByName(self, "PageView_page")
	self.pageView:setCustomScrollThreshold(50)
	self.imgFrm = SoraDGetChildByName(self, "Image_frm")
	self.nodeTime = SoraDGetChildByName(self, "Node_time")
	if self.nodeTime then
		self.nodeTime:setScale(1)
	end
	local pointNode = cc.Node:create()
	pointNode:setScale(0.8)
	pointNode:setPosition(self.imgFrm:getContentSize().width / 2, 22)
	pointNode:addTo(self.imgFrm)
	local imageItemBg = ccui.ImageView:create("frame_lace_09_02.png", ccui.TextureResType.plistType)
	imageItemBg:setName("Image_bg")
	imageItemBg:setPosition(0, 0)
	imageItemBg:addTo(pointNode)
	local imageLight = ccui.ImageView:create("frame_lace_09_01.png", ccui.TextureResType.plistType)
	imageLight:setName("Image_light")
	imageLight:setPosition(0, 0)
	imageLight:addTo(pointNode)
	self.pagePoint = include("commonScrollIndicatorNumber").new(pointNode)
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_ACTIVETIMEOUT", handler(self, self.initData))
	self.pageView:addEventListener(handler(self, self.onPageViewEvent))
end
function RechargeTinyPageNode:setMyGiftType(mID)
	self.pageGiftType = mID
	return self:initData()
end
function RechargeTinyPageNode:initData(target, redata)
	if self.activeTimer then
		SoraDManagerRemoveTimer(self, self.activeTimer)
		self.activeTimer = nil
	end
	self.tableTimerCounts, _ENV, self.tableTextTimers, _ENV, self.activityData, _ENV = SoraDManagerRemoveTimer, SoraDManagerRemoveTimer, SoraDManagerRemoveTimer, SoraDManagerRemoveTimer, SoraDManagerRemoveTimer, SoraDManagerRemoveTimer
	if G_IS_UNITY then
		self.pageView:removeAllChildren()
	else
		for _, v in pairs(self.pageView:getPages()) do
			v:removeAllChildren()
		end
	end
	local activeDataList = rechargeActivityCtrl:getRecommendActivityList(self.pageGiftType)
	for k, v in pairs(activeDataList) do
		local judgeData = paymentManager.bullets[tonumber(k)]
		if judgeData then
			v.otherData = clone(rechargeRead.getPageViewData(k))
			v.showPrice = paymentManager.judgePrice(k, v.price)
			if paymentManager.judgeGiftExclusive(k) then
				table.insert(self.activityData, self:translateData(v))
			end
		end
	end
	if not next(self.activityData) and not target then
		self.haveEvent = false
	else
		self.haveEvent = true
	end
	if next(self.activityData) == nil then
		table.insert(self.activityData, self:noActiveModel())
	end
	table.sort(self.activityData, function(a, b)
		if a[1] and b[1] then
			return a[1].val > b[1].val
		end
	end)
	for index, value in ipairs(self.activityData) do
		local panel
		for i, v in ipairs(value) do
			if v.type == OCX_TYPE_PAGE then
				panel = self:createPage(v)
				self.pageView:addWidgetToPage(panel, index - 1, true)
				self.pageView:getPage(index - 1):setClippingEnabled(true)
			elseif v.type == OCX_TYPE_BUTTON then
				self:createButton(panel, v)
			elseif v.type == OCX_TYPE_TEXT then
				self:createText(panel, v)
			elseif v.type == OCX_TYPE_TIMER then
				self:createTimer(panel, v)
			elseif v.type == OCX_TYPE_CLICKIMAGE then
				self:createTouchPanel(panel, v)
			elseif v.type == OCX_TYPE_CREATESPRITE then
				self:createSprite(panel, v)
			end
		end
	end
	repeat
		local goon = true
		local arr = self.pageView:getPages()
		for k, v in pairs(arr) do
			if not v:getChildByName("Node_father") then
				self.pageView:removePage(v)
				goon = false
				break
			end
		end
	until goon or false
	self.pageView:forceDoLayout()
	self.pageView:scrollToPage(0)
	_ENV = 0
	;(0).count = #self.activityData
	;(0).intervalWidth = 40
	;(0).begin = 1
	self.pagePoint:initData(0)
	self.activeTimer = SoradCreateTimer(self, handler(self, self.activeTimeUp))
	self:activeTimeUp()
	return self.haveEvent
end
function RechargeTinyPageNode:translateData(ocxData)
	local _UPVALUE0_, tmpTable
	if ocxData.otherData.activeModelType == 4 then
		tmpTable = self:luckyActive(ocxData)
	elseif ocxData.otherData.activeModelType == 1 then
		tmpTable = self:normalActive(ocxData)
	else
		tmpTable = self:noActiveModel()
	end
	return tmpTable
end
function RechargeTinyPageNode:luckyActive(ocxTbl)
	if tonumber(ocxTbl.price) > 0 then
		_ENV = nil
		;(nil).num = math.floor(ocxTbl.originalPrice / ocxTbl.price * 100)
		;(nil).char = "%"
		if i18n("common_text_1470", nil) then
			goto lbl_27
		end
	end
	_ENV = nil
	;(nil).num = 9999
	;(nil).char = "%"
	local percent = i18n("common_text_1470", nil)
	::lbl_27::
	local _ENV, _UPVALUE9_, btnName = math.floor(ocxTbl.originalPrice / ocxTbl.price * 100), "common_text_1261", tonumber(ocxTbl.price) > 0 and ocxTbl.showPrice or i18n("common_text_1261")
	math.floor(ocxTbl.originalPrice / ocxTbl.price * 100).type = "indexWeight"
	_ENV, math.floor(ocxTbl.originalPrice / ocxTbl.price * 100).val = ocxTbl.recommend and 1 or 0, ocxTbl.recommend and 1 or 0
	;(ocxTbl.recommend and 1 or 0).type = OCX_TYPE_PAGE
	;(ocxTbl.recommend and 1 or 0).val = ocxTbl.otherData.tinyBg
	_ENV, (ocxTbl.recommend and 1 or 0).csb = ocxTbl.otherData.tinyBg, "bg_recharge_tiny_normal"
	ocxTbl.otherData.tinyBg.type = OCX_TYPE_TEXT
	ocxTbl.otherData.tinyBg.name = "Text_title"
	_ENV, ocxTbl.otherData.tinyBg.val = i18n(ocxTbl.otherData.activeName), i18n(ocxTbl.otherData.activeName)
	i18n(ocxTbl.otherData.activeName).type = OCX_TYPE_BUTTON
	i18n(ocxTbl.otherData.activeName).name = "Button_buy"
	i18n(ocxTbl.otherData.activeName).val = btnName
	i18n(ocxTbl.otherData.activeName).tag = ocxTbl.luckyGiftID
	_ENV, i18n(ocxTbl.otherData.activeName).info = ocxTbl.luckyGiftID, ocxTbl
	ocxTbl.luckyGiftID.type = OCX_TYPE_TIMER
	ocxTbl.luckyGiftID.name = "Text_time"
	_ENV, ocxTbl.luckyGiftID.val = ocxTbl.lastTime, ocxTbl.lastTime
	ocxTbl.lastTime.type = OCX_TYPE_TEXT
	ocxTbl.lastTime.name = "Text_gold"
	_ENV, ocxTbl.lastTime.val = string.formatnumberthousands(ocxTbl.gold), string.formatnumberthousands(ocxTbl.gold)
	string.formatnumberthousands(ocxTbl.gold).type = OCX_TYPE_CREATESPRITE
	string.formatnumberthousands(ocxTbl.gold).name = "Node_time"
	_ENV, string.formatnumberthousands(ocxTbl.gold).unVisiable = self:judgeHide(ocxTbl.otherData.hideTime), self:judgeHide(ocxTbl.otherData.hideTime)
	self:judgeHide(ocxTbl.otherData.hideTime).type = OCX_TYPE_TEXT
	self:judgeHide(ocxTbl.otherData.hideTime).name = "Text_discount"
	_ENV, self:judgeHide(ocxTbl.otherData.hideTime).val = OCX_TYPE_TEXT, percent
	OCX_TYPE_TEXT.type = OCX_TYPE_CLICKIMAGE
	OCX_TYPE_TEXT.name = "Panel_touch"
	OCX_TYPE_TEXT.info = ocxTbl
	;("common_text_1261")[1] = math.floor(ocxTbl.originalPrice / ocxTbl.price * 100)
	;("common_text_1261")[2] = ocxTbl.recommend and 1 or 0
	;("common_text_1261")[3] = ocxTbl.otherData.tinyBg
	;("common_text_1261")[4] = i18n(ocxTbl.otherData.activeName)
	;("common_text_1261")[5] = ocxTbl.luckyGiftID
	;("common_text_1261")[6] = ocxTbl.lastTime
	;("common_text_1261")[7] = string.formatnumberthousands(ocxTbl.gold)
	;("common_text_1261")[8] = self:judgeHide(ocxTbl.otherData.hideTime)
	local ("common_text_1261")[9], tmpTable = OCX_TYPE_TEXT, "common_text_1261"
	return tmpTable
end
function RechargeTinyPageNode:normalActive(ocxTbl)
	OCX_TYPE_PAGE, _UPVALUE9_ = nil, nil
	;(nil).type = "indexWeight"
	OCX_TYPE_PAGE, (nil).val = ocxTbl.recommend and 1 or 0, ocxTbl.recommend and 1 or 0
	;(ocxTbl.recommend and 1 or 0).type = OCX_TYPE_PAGE
	;(ocxTbl.recommend and 1 or 0).val = ocxTbl.otherData.tinyBg
	OCX_TYPE_PAGE, (ocxTbl.recommend and 1 or 0).csb = ocxTbl.otherData.tinyBg, "bg_recharge_tiny_normal"
	ocxTbl.otherData.tinyBg.type = OCX_TYPE_TEXT
	ocxTbl.otherData.tinyBg.name = "Text_title"
	OCX_TYPE_PAGE, ocxTbl.otherData.tinyBg.val = i18n(ocxTbl.otherData.activeName), i18n(ocxTbl.otherData.activeName)
	i18n(ocxTbl.otherData.activeName).type = OCX_TYPE_BUTTON
	i18n(ocxTbl.otherData.activeName).name = "Button_buy"
	i18n(ocxTbl.otherData.activeName).val = ocxTbl.showPrice
	i18n(ocxTbl.otherData.activeName).tag = ocxTbl.ID
	OCX_TYPE_PAGE, i18n(ocxTbl.otherData.activeName).info = ocxTbl.ID, ocxTbl
	ocxTbl.ID.type = OCX_TYPE_TIMER
	ocxTbl.ID.name = "Text_time"
	OCX_TYPE_PAGE, ocxTbl.ID.val = rechargeActivityCtrl:queryQueue(ocxTbl.ID).timerNode.timer:getRemainTime(), rechargeActivityCtrl:queryQueue(ocxTbl.ID).timerNode.timer:getRemainTime()
	rechargeActivityCtrl:queryQueue(ocxTbl.ID).timerNode.timer:getRemainTime().type = OCX_TYPE_TEXT
	rechargeActivityCtrl:queryQueue(ocxTbl.ID).timerNode.timer:getRemainTime().name = "Text_gold"
	OCX_TYPE_PAGE, rechargeActivityCtrl:queryQueue(ocxTbl.ID).timerNode.timer:getRemainTime().val = string.formatnumberthousands(ocxTbl.gold), string.formatnumberthousands(ocxTbl.gold)
	string.formatnumberthousands(ocxTbl.gold).type = OCX_TYPE_CREATESPRITE
	string.formatnumberthousands(ocxTbl.gold).name = "Node_time"
	OCX_TYPE_PAGE, string.formatnumberthousands(ocxTbl.gold).unVisiable = self:judgeHide(ocxTbl.otherData.hideTime), self:judgeHide(ocxTbl.otherData.hideTime)
	self:judgeHide(ocxTbl.otherData.hideTime).type = OCX_TYPE_TEXT
	self:judgeHide(ocxTbl.otherData.hideTime).name = "Text_discount"
	OCX_TYPE_PAGE = nil
	;(nil).num = math.floor(ocxTbl.originalPrice / ocxTbl.price * 100)
	;(nil).char = "%"
	OCX_TYPE_PAGE, self:judgeHide(ocxTbl.otherData.hideTime).val = i18n("common_text_1470", nil), i18n("common_text_1470", nil)
	i18n("common_text_1470", nil).type = OCX_TYPE_CLICKIMAGE
	i18n("common_text_1470", nil).name = "Panel_touch"
	i18n("common_text_1470", nil).info = ocxTbl
	;(nil)[1] = nil
	;(nil)[2] = ocxTbl.recommend and 1 or 0
	;(nil)[3] = ocxTbl.otherData.tinyBg
	;(nil)[4] = i18n(ocxTbl.otherData.activeName)
	;(nil)[5] = ocxTbl.ID
	;(nil)[6] = rechargeActivityCtrl:queryQueue(ocxTbl.ID).timerNode.timer:getRemainTime()
	;(nil)[7] = string.formatnumberthousands(ocxTbl.gold)
	;(nil)[8] = self:judgeHide(ocxTbl.otherData.hideTime)
	local (nil)[9], tmpTable = i18n("common_text_1470", nil), nil
	return tmpTable
end
function RechargeTinyPageNode:noActiveModel()
	OCX_TYPE_PAGE, _UPVALUE3_ = nil, nil
	;(nil).type = "indexWeight"
	OCX_TYPE_PAGE, (nil).val = nil, 0
	;(nil).type = OCX_TYPE_PAGE
	OCX_TYPE_PAGE, (nil).csb = OCX_TYPE_PAGE, "bg_recharge_tiny_none"
	OCX_TYPE_PAGE.type = OCX_TYPE_TEXT
	OCX_TYPE_PAGE.name = "Text_noTitle"
	OCX_TYPE_PAGE.val = i18n("common_text_1036")
	;(nil)[1] = nil
	;(nil)[2] = nil
	local (nil)[3], tmpTable = OCX_TYPE_PAGE, nil
	return tmpTable
end
function RechargeTinyPageNode:createTouchPanel(parent, panelData)
	local panel = SoraDGetChildByName(parent, panelData.name)
	if not panel then
		return
	end
	panel:setTouchEnabled(true)
	panel:setSwallowTouches(false)
	panel:addTouchEventListener(function(panel, eventType)
		if eventType == ccui.TouchEventType.ended then
			local touchBeganPoint = panel:getTouchBeganPosition()
			local touchmovePoint = panel:getTouchEndPosition()
			local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
			print("distance", distance)
			self.timerInterval = 1
			if distance < 10 then
				SoraDPlaySound()
				self:openItemList(panelData.info)
			end
		end
	end)
	return panel
end
function RechargeTinyPageNode:createButton(parent, btnData)
	local button = SoraDGetChildByName(parent, btnData.name)
	if not button then
		return
	end
	button:setTitleText(btnData.val)
	button:setTag(btnData.tag)
	button:setVisible(not btnData.invisible)
	button:addTouchEventListener(function(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			self.timerInterval = 1
			SoraDPlaySound()
			self:openItemList(btnData.info)
		end
	end)
	return button
end
function RechargeTinyPageNode:createSprite(parent, spData)
	dump(spData, "spData")
	local sprite = SoraDGetChildByName(parent, spData.name)
	if not sprite then
		return
	end
	if spData.unVisiable then
		sprite:setVisible(false)
	end
	return sprite
end
function RechargeTinyPageNode:openItemList(ocxTbl)
	if ocxTbl.ID then
		local listBox = SoraDCreatePanel("rechargePopView")
		listBox:initData(ocxTbl.ID, gRechargeActiveFromEnum.ROAD05)
		listBox:show()
	elseif ocxTbl.luckyGiftID then
		local panel = SoraDCreatePanel("rechargePopView")
		panel:initData(ocxTbl.luckyGiftID, gRechargeActiveFromEnum.ROAD05)
		panel:show()
	end
end
function RechargeTinyPageNode:createText(parent, txtData)
	local text = SoraDGetChildByName(parent, txtData.name)
	if not text then
		return
	end
	text:setString(txtData.val)
	if txtData.underLine then
		SoraDDrawTextUnderLine(text)
	end
	if txtData.color then
		text:setColor(txtData.color)
	end
	return text
end
function RechargeTinyPageNode:createTimer(parent, timeData)
	local txtTime = SoraDGetChildByName(parent, timeData.name)
	table.insert(self.tableTextTimers, txtTime)
	table.insert(self.tableTimerCounts, timeData.val)
	return txtTime
end
function RechargeTinyPageNode:timeUp(dt)
	self.timerInterval = self.timerInterval + 1
	if self.timerInterval > 5 then
		self:pageFoward()
		self.timerInterval = 0
	end
end
function RechargeTinyPageNode:pageFoward()
	local fowardPage = self.pageView:getCurPageIndex() >= #self.activityData - 1 and 0 or self.pageView:getCurPageIndex() + 1
	self.pageView:scrollToPage(fowardPage)
end
function RechargeTinyPageNode:onPageViewEvent(sender, eventType)
	if eventType == 0 then
		local realIndex = self.pageView:getCurPageIndex()
		self.pagePoint:setCurLight(realIndex + 1)
	end
end
function RechargeTinyPageNode:createPage(imgData)
	local panel = SoraDCreateCSBNode(imgData.csb)
	if imgData.val then
		local pngOcx = panel:getChildByName("Image_center")
		pngOcx:loadTexture(SoraDCheckPNG(imgData.val, gDefaultPNG.RECHARGE_TINYPAGE), ccui.TextureResType.plistType)
	end
	local node = ccui.Widget:create()
	node:setName("Node_father")
	node:addChild(panel)
	node:setPosition(0, 100)
	return node
end
function RechargeTinyPageNode:judgeHide(val)
	if val and val == 1 then
		return true
	else
		return false
	end
end
function RechargeTinyPageNode:activeTimeUp(dt)
	self:timeUp()
	if next(self.tableTextTimers) ~= nil then
		for i, v in ipairs(self.tableTextTimers) do
			if self.tableTimerCounts[i] > 0 then
				self.tableTimerCounts[i] = self.tableTimerCounts[i] - 1
				v:setString(SoraDConvertSecondToString(self.tableTimerCounts[i]))
			end
		end
	end
end
function RechargeTinyPageNode:setHandle(handle)
	self.refreshHandl = handle
end
function RechargeTinyPageNode:getMeSize()
	if self.haveEvent then
		return cc.size(640, 120)
	else
		return cc.size(0, 0)
	end
end
return RechargeTinyPageNode
