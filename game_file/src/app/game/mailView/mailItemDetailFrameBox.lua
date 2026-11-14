local mailUIConstDef = include("mailUIConstDef")
local mailItemDetailFrameBox = class("mailItemDetailFrameBox", function(target)
	if target then
		return target
	else
		return ccui.Layout:create()
	end
end)
function mailItemDetailFrameBox:createUI()
	self:setSwallowTouches(false)
	self:setClippingEnabled(true)
	self:setContentSize(cc.size(gMailDetaiViewWidth, 200))
	self:setLayoutType(ccui.LayoutType.VERTICAL)
	self:setCascadeOpacityEnabled(true)
	self.content_frame = ccui.ImageView:create()
	self.content_frame:setName("content_frame")
	self.content_frame:setAnchorPoint(cc.p(0.5, 0.5))
	self.content_frame:setPosition(cc.p(gMailDetaiViewWidth / 2, 0))
	self.content_frame:loadTexture("frame_yjyh_dk_01.png", ccui.TextureResType.plistType)
	self.content_frame:setScale9Enabled(true)
	self.content_frame:setCapInsets(cc.rect(27, 27, 20, 28))
	self:addChild(self.content_frame)
	self.content_frame:setLayoutParameter(ccui.LayoutParameter:create())
	local fightColorBlue = ccui.Layout:create()
	fightColorBlue:setContentSize((gMailDetaiViewWidth - 28) / 2, 10)
	fightColorBlue:setBackGroundColorType(1)
	fightColorBlue:setBackGroundColor(cc.c3b(102, 140, 190))
	fightColorBlue:setBackGroundColorOpacity(51.0)
	fightColorBlue:setAnchorPoint(SoraDFAP(1, 0.5))
	fightColorBlue:setTouchEnabled(false)
	fightColorBlue:addTo(self.content_frame)
	fightColorBlue:setCascadeOpacityEnabled(true)
	local fightColorRed = fightColorBlue:clone()
	fightColorRed:setAnchorPoint(cc.p(SoraDFAP(0, 0.5)))
	fightColorRed:setBackGroundColor(cc.c3b(110, 86, 80))
	fightColorRed:addTo(self.content_frame)
	fightColorRed:setCascadeOpacityEnabled(true)
	_UPVALUE2_ = fightColorRed.setCascadeOpacityEnabled
	self.fightColor, fightColorRed.setCascadeOpacityEnabled[1] = fightColorRed.setCascadeOpacityEnabled, fightColorBlue
	self.fightColor, fightColorRed.setCascadeOpacityEnabled[2] = fightColorRed.setCascadeOpacityEnabled, fightColorRed
	local widthTopBar = gMailDetaiViewWidth
	self.topBar = ccui.Layout:create()
	self.topBar:setCascadeOpacityEnabled(true)
	self.topBar:setName("btn_top")
	self.topBar:setAnchorPoint(cc.p(0, 0))
	self.topBar:setPosition(cc.p(0, 0))
	self.topBar:setContentSize(cc.size(widthTopBar, 50))
	self.topBar:setTouchEnabled(true)
	self.topBar:setSwallowTouches(false)
	self.topBar:addTouchEventListener(handler(self, self.onBtnTop))
	self:addChild(self.topBar)
	local fightBg = ccui.ImageView:create()
	fightBg:setAnchorPoint(cc.p(1, 0.5))
	fightBg:setPosition(cc.p(gMailDetaiViewWidth / 2, 25))
	fightBg:loadTexture("frame_yjyh_zdtc_dj.png", ccui.TextureResType.plistType)
	fightBg:setScale9Enabled(true)
	fightBg:setContentSize(cc.size((gMailDetaiViewWidth - 28) / 2, 50))
	fightBg:addTo(self.topBar)
	local anotherFightBg = fightBg:clone()
	anotherFightBg:setFlippedX(true)
	anotherFightBg:setPosition(cc.p(gMailDetaiViewWidth / 2, 25))
	anotherFightBg:addTo(self.topBar)
	_UPVALUE2_ = anotherFightBg.addTo
	self.fightTopBg, anotherFightBg.addTo[1] = anotherFightBg.addTo, fightBg
	self.fightTopBg, anotherFightBg.addTo[2] = anotherFightBg.addTo, anotherFightBg
	self.colorTopBg = ccui.ImageView:create()
	self.colorTopBg:setName("colorTopBg")
	self.colorTopBg:setAnchorPoint(cc.p(0.5, 0.5))
	self.colorTopBg:loadTexture("frame_yjyh_bt_hong.png", ccui.TextureResType.plistType)
	self.colorTopBg:setScale9Enabled(true)
	self.colorTopBg:setContentSize(gMailDetaiViewWidth - 28, 50)
	self.colorTopBg:setScale9Enabled(true)
	self.colorTopBg:setPosition(gMailDetaiViewWidth / 2, 25)
	self.colorTopBg:setCapInsets(cc.rect(126, 11, 0, 14))
	self.topBar:addChild(self.colorTopBg)
	self.colorTopBg2 = cc.LayerColor:create(cc.c4b(112, 92, 75, 110))
	self.colorTopBg2:setContentSize(cc.size(gMailDetaiViewWidth - 38, 40))
	self.colorTopBg2:setName("colorTopBg2")
	self.colorTopBg2:setAnchorPoint(cc.p(0.5, 0.5))
	self.colorTopBg2:setPosition(gMailDetaiViewWidth / 2, 25)
	self.topBar:addChild(self.colorTopBg2)
	self.iconArrow = display.newSprite("#frame_main_integration_arrow.png")
	self.iconArrow:setFlippedY(true)
	self.iconArrow:setPosition(SoraDFPoint(580, 25, widthTopBar))
	self.iconArrow:addTo(self.topBar)
	self.text_title = ccui.Text:create()
	self.text_title:setFontSize(22)
	self.text_title = SoraDChangeTextToHtml(self.text_title)
	self.text_title:setColor(cc.c3b(68, 35, 17))
	self.text_title:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	self.text_title:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	self.text_title:setAnchorPoint(SoraDFAP(0.5, 0.5))
	self.text_title:setPosition(SoraDFPoint(gMailDetaiViewWidth / 2, 25, widthTopBar))
	self.topBar:addChild(self.text_title)
	self.textTip = self.text_title:clone()
	self.textTip:setFontSize(18)
	self.textTip:setColor(cc.c3b(100, 80, 60))
	self.textTip:setAnchorPoint(SoraDFAP(0.5, 0))
	self.textTip:setPosition(SoraDFPoint(gMailDetaiViewWidth / 2, 0, widthTopBar))
	self.textTip:setVisible(false)
	self.topBar:addChild(self.textTip)
	self.text_result = ccui.Text:create()
	self.text_result:setFontSize(22)
	self.text_result:setColor(cc.c3b(68, 35, 17))
	self.text_result:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	self.text_result:setTextHorizontalAlignment(SoraDFLabelR())
	self.text_result:setAnchorPoint(SoraDFAP(1.0, 0.5))
	self.text_result = SoraDChangeTextToHtml(self.text_result)
	self.text_result:setPosition(SoraDFPoint(self.topBar:getContentSize().width - 20, 25, widthTopBar))
	self.topBar:addChild(self.text_result)
	self.text_time = ccui.Text:create()
	self.text_time:setFontSize(22)
	self.text_time:setColor(cc.c3b(187, 168, 147))
	self.text_time:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	self.text_time:setTextHorizontalAlignment(SoraDFLabelL())
	self.text_time:setAnchorPoint(SoraDFAP(0.0, 0.5))
	self.text_time:setPosition(SoraDFPoint(20, 25, widthTopBar))
	self.topBar:addChild(self.text_time)
	self.spResult = display.newSprite("#title_yjyh_lose.png")
	self.spResult:setScale(0.8)
	self.spResult:setPosition(SoraDFPoint(570, 25, widthTopBar))
	self.spResult:addTo(self.topBar)
	self.spResult:setVisible(false)
	self.btnAttrAnalysis = ccui.Button:create("bg_transparent.png", "bg_transparent.png", "bg_transparent.png", ccui.TextureResType.plistType)
	self.btnAttrAnalysis:ignoreContentAdaptWithSize(false)
	self.btnAttrAnalysis:setContentSize(cc.size(40, 40))
	local btnAttrIcon = display.newSprite("#icon_set_search.png")
	btnAttrIcon:setScale(0.4)
	btnAttrIcon:setPosition(cc.p(20, 20))
	btnAttrIcon:addTo(self.btnAttrAnalysis)
	self.btnAttrAnalysis:addTo(self.topBar)
	self.btnAttrAnalysis:addTouchEventListener(handler(self, self.btnClickAttrAnalysis))
	self.btnAttrAnalysis:setSwallowTouches(true)
	self.btnAttrAnalysis:setVisible(false)
	self.btnTips = ccui.Button:create("btn_question.png", "btn_question.png", "btn_question.png", ccui.TextureResType.plistType)
	self.btnTips:setPosition(cc.p(SoraDFIsRA() and 542 or 100, 7))
	self.btnTips:addTo(self.topBar)
	self.btnTips:setAnchorPoint(cc.p(0.5, 0))
	self.btnTips:addTouchEventListener(handler(self, self.btnClickHelp))
	self.btnTips:setSwallowTouches(true)
	self.btnTips:setVisible(false)
	self.btnCollapse = ccui.Button:create("frame_xljc_xxjt.png", "frame_xljc_xxjt.png", "frame_xljc_xxjt.png", ccui.TextureResType.plistType)
	self.btnCollapse:addTo(self)
	self.btnCollapse:setAnchorPoint(cc.p(0.5, 0))
	self.btnCollapse:addTouchEventListener(handler(self, self.btnClickCollapse))
	self.btnCollapse:setSwallowTouches(true)
	self.btnCollapse:setLayoutParameter(ccui.LayoutParameter:create())
end
function mailItemDetailFrameBox:ctor()
	self:createUI()
	self.numberOfItems = 0
	self.topHeight = 50
	self.bottomOffsetY = 5
	self.singleIsMoved = false
	self.isEnableCollapse = false
	self.isContentShow = true
	self.customNode = nil
	self.tblRewardItems, _ENV, self.customNodeSize = self.createUI, self.createUI, nil
	local itemSize = self:getContentSize()
	self.itemWidth = itemSize.width
	self.itemHeight = itemSize.height
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
end
function mailItemDetailFrameBox:initWithData(data)
	self.scroll = SoraDGetChildByName(gModuleMgr.sharedMgr("mailMgr"):getDetaiView(), "Size_scrollView")
	local dataType = data.dataType
	local dataContent = data.dataContent
	self.itemWidth = dataContent.itemWidth or self.itemWidth
	self:updateBaseUI(dataContent)
	if dataType == mailUIConstDef.MAIL_UI_TYPE_REWARD then
		self:initWithReward(dataContent)
	elseif dataType == mailUIConstDef.MAIL_UI_TYPE_CUSTOM then
		self:initWithCustomData(dataContent)
	end
	self:reSize(cc.size(self.itemWidth, self.itemHeight))
	if self.collageLocalKey then
		_ENV = cc.size(self.itemWidth, self.itemHeight)
		cc.size(self.itemWidth, self.itemHeight).byUID = true
		if not SoraDConfigGet(self.collageLocalKey, cc.size(self.itemWidth, self.itemHeight)) then
			self.iconArrow:setFlippedY(false)
			self.btnCollapse:getVirtualRenderer():setFlippedY(true)
			self:hideContent(true)
		end
	end
end
function mailItemDetailFrameBox:updateBaseUI(data)
	local isShowResult = data.textShowResult and true or false
	local isShowTitle = data.textShowTitle and true or false
	local isShowTime = data.textShowTime and true or false
	local isShowFrame = data.isShowFrame == nil and true or data.isShowFrame
	if data.isShowBlueTop == nil then
	end
	local isShowBlueTop = data.isShowBlueTop
	if data.isEnableCollapse == nil then
	end
	local isEnableCollapse = data.isEnableCollapse
	local isHideTop = data.isHideTop
	if data.isShowFightTop == nil then
	end
	local isShowFightTop = data.isShowFightTop
	if data.isShowColorTopBg2 == nil then
	end
	local isShowColorTopBg2 = data.isShowColorTopBg2
	local isShowResultImg = data.fightResult ~= nil
	if data.isShowFightColor == nil then
	end
	local isShowFightColor = data.isShowFightColor
	self.topHeight = data.topHeight or self.topHeight
	self.showBtnAttrAnalysis = data.showBtnAttrAnalysis
	self.helpTips = data.helpTips
	self.collageLocalKey = data.collageLocalKey
	self.isShowFrame = isShowFrame
	self.isEnableCollapse = isEnableCollapse
	self.collapseOffsetY = data.collapseOffsetY or 0
	self.btnCollapse:setVisible(self.collapseOffsetY > 0)
	self.text_result:setVisible(isShowResult)
	self.text_title:setVisible(isShowTitle)
	self.text_time:setVisible(isShowTime)
	self.iconArrow:setVisible(self.isEnableCollapse)
	for i, v in ipairs(self.fightTopBg) do
		v:setVisible(isShowFightTop)
	end
	for i, v in ipairs(self.fightColor) do
		v:setVisible(isShowFightColor)
	end
	self.colorTopBg:setVisible(not isShowFightTop and not isShowColorTopBg2)
	self.colorTopBg2:setVisible(isShowColorTopBg2)
	self.content_frame:setVisible(isShowFrame)
	if isShowResult then
		self.text_result:setString(data.textShowResult)
	end
	if isShowResultImg then
		local pngName
		if data.fightResult then
			pngName = string.format("title_yjyh_win%s.png", SoraDFIsRA() and "" or "_en")
		else
			pngName = string.format("title_yjyh_lose%s.png", SoraDFIsRA() and "" or "_en")
		end
		self.spResult:setVisible(true)
		self.spResult:setSpriteFrame(pngName)
	end
	if data.fightIcon then
		self.spResult:setVisible(true)
		self.spResult:setSpriteFrame(data.fightIcon)
		self.spResult:setScale(1)
		self.spResult:setPosition(SoraDFPoint(55, 25, gMailDetaiViewWidth))
	end
	if data.titleColor then
		self.text_title:setIsHtml(true)
		self.text_title:setColor(data.titleColor)
	else
		self.text_title:setIsHtml(false)
	end
	if isShowTitle then
		self.text_title:setString(data.textShowTitle)
	end
	if isShowTime then
		self.text_time:setString(data.textShowTime)
	end
	if isShowBlueTop then
		self.colorTopBg:loadTexture("frame_yjyh_bt_lan.png", ccui.TextureResType.plistType)
		self.colorTopBg:setCapInsets(cc.rect(125, 11, 0, 14))
	else
		self.colorTopBg:loadTexture("frame_yjyh_bt_hong.png", ccui.TextureResType.plistType)
		self.colorTopBg:setCapInsets(cc.rect(126, 11, 0, 14))
	end
	if isHideTop then
		self.topBar:setVisible(false)
		self.topBar:setLayoutParameter(ccui.LayoutParameter:create())
	else
		self.topBar:setVisible(true)
		local lpFrame0 = ccui.LinearLayoutParameter:create()
		self.topBar:setLayoutParameter(lpFrame0)
		lpFrame0:setGravity(ccui.LinearGravity.centerHorizontal)
		_ENV = ccui.LinearGravity.centerHorizontal
		ccui.LinearGravity.centerHorizontal.left = 0
		ccui.LinearGravity.centerHorizontal.top = 0
		ccui.LinearGravity.centerHorizontal.right = 0
		ccui.LinearGravity.centerHorizontal.bottom = 0
		lpFrame0:setMargin(ccui.LinearGravity.centerHorizontal)
	end
	if data.tipStr then
		self.textTip:setVisible(true)
		self.textTip:setString(data.tipStr)
	end
end
function mailItemDetailFrameBox:initWithCustomData(data)
	local customNode = data.customNode
	if customNode == nil then
		customNode = ccui.Layout:create()
		customNode:setBackGroundColorType(ccui.LayoutBackGroundColorType.none)
		customNode:setContentSize(cc.size(0, 0))
	end
	self:addChild(customNode)
	local nodeWidth, nodeHeight
	if customNode.getItemWidth then
		nodeWidth = customNode:getItemWidth()
	else
		nodeWidth = customNode:getContentSize().width
	end
	if customNode.getItemHeight then
		nodeHeight = customNode:getItemHeight()
	else
		nodeHeight = customNode:getContentSize().height
	end
	local lp1 = ccui.LinearLayoutParameter:create()
	lp1:setGravity(ccui.LinearGravity.centerHorizontal)
	if not data.ignoreLayoutParam then
		_ENV = ccui.LinearGravity.centerHorizontal
		ccui.LinearGravity.centerHorizontal.left = 0
		ccui.LinearGravity.centerHorizontal.top = 10
		ccui.LinearGravity.centerHorizontal.right = 0
		ccui.LinearGravity.centerHorizontal.bottom = 10
		lp1:setMargin(ccui.LinearGravity.centerHorizontal)
		nodeHeight = nodeHeight + 20
		customNode:setLayoutParameter(lp1)
	end
	local totalHeight = nodeHeight
	if self.topBar:isVisible() then
		totalHeight = self.topHeight + nodeHeight
	else
		self.topHeight = 0
	end
	if customNode:getContentSize().height == 0 then
		self.content_frame:setVisible(false)
		self.isEnableCollapse = false
	end
	print("nodeHeight", nodeHeight)
	self.customNode = customNode
	self.customNodeSize = cc.size(nodeWidth, nodeHeight)
	self.itemHeight = totalHeight
end
function mailItemDetailFrameBox:initWithReward(dataContent)
	if not dataContent.itemList then
		local _ENV, itemList = dataContent.itemList, dataContent.itemList
	end
	local totalHeight = 0
	if next(itemList) then
		totalHeight = 110 * math.ceil(#itemList / 5)
		local customNode = ccui.Layout:create()
		customNode:setCascadeOpacityEnabled(true)
		customNode:setContentSize(cc.size(480, totalHeight))
		local lp = ccui.LinearLayoutParameter:create()
		customNode:setLayoutParameter(lp)
		customNode:setAnchorPoint(cc.p(0, 0))
		lp:setGravity(ccui.LinearGravity.centerHorizontal)
		self:addChild(customNode, 1)
		local rewardNode = display.newNode()
		rewardNode:addTo(customNode)
		rewardNode:setCascadeOpacityEnabled(true)
		rewardNode:setPosition(240, customNode:getContentSize().height / 2)
		for i, itemInfo in ipairs(itemList) do
			local itemNode = self:createRewardItem(itemInfo)
			itemNode:addTo(rewardNode)
			table.insert(self.tblRewardItems, itemNode)
		end
		self.customNode = customNode
		SoraDautoSortPos(rewardNode, 5, 1, cc.size(100, 100), not SoraDFIsRA())
	else
		self.content_frame:setVisible(false)
	end
	self.customNodeSize = cc.size(480, totalHeight)
	self.itemHeight = totalHeight
end
function mailItemDetailFrameBox:reInitTop(data)
	self:updateBaseUI(data)
end
function mailItemDetailFrameBox:createRewardItem(rewardItemData)
	local mailRewardItem = include("mailRewardItem")
	local itemBoxNode = mailRewardItem.new()
	itemBoxNode:initWithData(rewardItemData)
	return itemBoxNode
end
function mailItemDetailFrameBox:getItemWidth()
	return self.itemWidth
end
function mailItemDetailFrameBox:getItemHeight()
	return self.itemHeight
end
function mailItemDetailFrameBox:btnClickAttrAnalysis(target, event)
	print("btnClickAttrAnalysis")
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDCreatePanel("mailItemDetailAttrAnalysis"):show()
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	else
		self.singleIsMoved = false
	end
end
function mailItemDetailFrameBox:btnClickHelp(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		uiManager:show("RuleView", self.helpTips)
	end
end
function mailItemDetailFrameBox:onBtnTop(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.isEnableCollapse then
			if self.isContentShow then
				self.iconArrow:setFlippedY(false)
				self:hideContent()
				if self.collageLocalKey then
					_ENV = nil
					;(nil).byUID = true
					SoraDConfigSet(self.collageLocalKey, false, nil)
				end
			else
				self.iconArrow:setFlippedY(true)
				self:showContent()
				if self.collageLocalKey then
					_ENV = nil
					;(nil).byUID = true
					SoraDConfigSet(self.collageLocalKey, true, nil)
				end
			end
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	else
		self.singleIsMoved = false
	end
end
function mailItemDetailFrameBox:showContent()
	self.isContentShow = true
	if self.collapseOffsetY == 0 then
		if self.isShowFrame == true then
			self.content_frame:setVisible(true)
		end
		self.customNode:setVisible(true)
	else
		self.customNode:setContentSize(cc.size(self.customNodeSize.width, self.customNodeSize.height))
	end
	local oldHeight = self:getContentSize().height
	local totalHeight = self.topHeight
	totalHeight = totalHeight + self.customNodeSize.height
	self.itemHeight = totalHeight
	self:reSize(cc.size(self.itemWidth, self.itemHeight))
	local deltaY = self.itemHeight - oldHeight
	_ENV = cc.size(self.itemWidth, self.itemHeight)
	cc.size(self.itemWidth, self.itemHeight).msg = "MESSAGE_MAIL_UI_ITEM_DETAIL_SIZE_CHANGE"
	cc.size(self.itemWidth, self.itemHeight).deltaY = deltaY
	cc.size(self.itemWidth, self.itemHeight).node = self:getParent()
	SoraDSendMessage(cc.size(self.itemWidth, self.itemHeight))
end
function mailItemDetailFrameBox:hideContent(noSendMessage)
	self.isContentShow = false
	if self.collapseOffsetY == 0 then
		if self.isShowFrame == true then
			self.content_frame:setVisible(false)
		end
		self.customNode:setVisible(false)
		self.itemHeight = 0
	else
		self.customNode:setClippingEnabled(true)
		self.customNode:setContentSize(cc.size(self.customNodeSize.width, self.collapseOffsetY))
		self.itemHeight = 80
	end
	local oldHeight = self:getContentSize().height
	self.itemHeight = self.itemHeight + self.topHeight + self.collapseOffsetY
	self:reSize(cc.size(self.itemWidth, self.itemHeight))
	local deltaY = self.itemHeight - oldHeight
	if not noSendMessage then
		_ENV = cc.size(self.itemWidth, self.itemHeight)
		cc.size(self.itemWidth, self.itemHeight).msg = "MESSAGE_MAIL_UI_ITEM_DETAIL_SIZE_CHANGE"
		cc.size(self.itemWidth, self.itemHeight).deltaY = deltaY
		cc.size(self.itemWidth, self.itemHeight).node = self:getParent()
		SoraDSendMessage(cc.size(self.itemWidth, self.itemHeight))
	end
end
function mailItemDetailFrameBox:btnClickCollapse(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.isEnableCollapse then
			if self.isContentShow then
				self.btnCollapse:getVirtualRenderer():setFlippedY(true)
				self:hideContent()
				if self.collageLocalKey then
					_ENV = nil
					;(nil).byUID = true
					SoraDConfigSet(self.collageLocalKey, false, nil)
				end
			else
				self.btnCollapse:getVirtualRenderer():setFlippedY(false)
				self:showContent()
				if self.collageLocalKey then
					_ENV = nil
					;(nil).byUID = true
					SoraDConfigSet(self.collageLocalKey, true, nil)
				end
			end
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	else
		self.singleIsMoved = false
	end
end
function mailItemDetailFrameBox:reSize(newSize)
	self.itemWidth = newSize.width
	self.itemHeight = newSize.height + self.bottomOffsetY
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
	if self.textTip:isVisible() then
		self.text_title:setPosition(cc.p(self.topBar:getContentSize().width / 2, 35))
	else
		self.text_title:setPosition(cc.p(self.topBar:getContentSize().width / 2, 25))
	end
	if self.showBtnAttrAnalysis then
		self.btnAttrAnalysis:setVisible(true)
		self.btnAttrAnalysis:setPosition(SoraDFPoint(gMailDetaiViewWidth / 2 - self.text_title:getContentSize().width / 2 - 20, 25, gMailDetaiViewWidth))
	end
	if self.helpTips then
		self.btnTips:setVisible(true)
	end
	print(" newSize.width", newSize.width)
	if self.text_title:getContentSize().width > newSize.width - 140 then
		self.text_title:ignoreContentAdaptWithSize(false)
		self.text_title:setContentSize(cc.size(newSize.width - 140, 50))
	end
	local frameHeight = newSize.height - (self.topBar:isVisible() and self.topHeight or 0)
	frameHeight = math.max(frameHeight, 54)
	if self.customNode then
		self.content_frame:setContentSize(cc.size(self.itemWidth - 28, frameHeight))
		for i, v in ipairs(self.fightColor) do
			v:setContentSize(cc.size((self.itemWidth - 36) / 2, frameHeight - 10))
		end
	end
	self.content_frame:setPosition(cc.p(self.itemWidth / 2, frameHeight / 2 + self.bottomOffsetY))
	for i, v in ipairs(self.fightColor) do
		v:setPosition(cc.p((self.itemWidth - 28) / 2, frameHeight / 2))
	end
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
	if self.btnCollapse:isVisible() then
		self.btnCollapse:setPosition(self.itemWidth / 2, 0)
	end
	ccui.Helper:doLayout(self)
end
function mailItemDetailFrameBox:updateCustomNodeSize()
	if self.customNode then
		local nodeWidth = 0
		if self.customNode.getItemWidth then
			nodeWidth = self.customNode:getItemWidth()
		else
			nodeWidth = self.customNode:getContentSize().width
		end
		if self.customNode.getItemHeight then
			nodeHeight = self.customNode:getItemHeight()
		else
			nodeHeight = self.customNode:getContentSize().height
		end
		local totalHeight = nodeHeight
		if self.topBar:isVisible() then
			totalHeight = self.topHeight + nodeHeight
		else
			self.topHeight = 0
		end
		self.customNodeSize = cc.size(nodeWidth, nodeHeight)
		self.itemHeight = totalHeight
		self:reSize(cc.size(self.itemWidth, self.itemHeight))
	end
end
function mailItemDetailFrameBox:getNewHeight(customHeight)
	local totalHeight = self.topHeight + 20
	totalHeight = totalHeight + customHeight
	return totalHeight
end
function mailItemDetailFrameBox:setRewardGray(isGray)
	for i, v in ipairs(self.tblRewardItems) do
		v:setGray(isGray)
	end
end
return mailItemDetailFrameBox
