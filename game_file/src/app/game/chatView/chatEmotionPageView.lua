local chatDesRead = include("chatDesRead")
local sizePage = cc.size(640, 300)
_ENV = 640
;(640).bgColorNormal = cc.c3b(190, 191, 192)
;(640).bgColorNight = cc.c3b(190, 191, 192)
;(640).totalH = 355
;(640).listItemSize = cc.size(62, 70)
local (640).listIconSize, _defaultParam = cc.size(50, 50), 640
local chatEmotionPageView = class("chatEmotionPageView", function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new(getCCSPath("chatEmotionPageView"))
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function chatEmotionPageView:ctor()
	self:setContentSize(sizePage)
	self:setAnchorPoint(cc.p(0, 0))
	self.itemsData, sizePage = self.setAnchorPoint, self.setAnchorPoint
	self.numberUnit = 10
	self.pageView = SoraDGetChildByName(self, "PageView_Emotion")
	self.pageView = include("commonAutoScrollList").new(self.pageView)
	self.pageView:setSingleCreate(handler(self, self.createEmotionItem))
	self.pageView:setSingleRefresh(handler(self, self.emotionRefresh))
	self.imgBg = SoraDGetChildByName(self, "ImgBg")
	self.imgBg:setFillType(1)
	self.scrollList = SoraDGetChildByName(self, "scroll_list")
	self.scrollList:setDirection(2)
	self.scrollList:setBounceEnabled(true)
	self.curListItem = nil
end
function chatEmotionPageView:setChatDelegate(chatDelegate)
	self.chatDelegate = chatDelegate
end
function chatEmotionPageView:init(chatDelegate)
	self.chatDelegate = chatDelegate
	self:initEmotionList()
end
function chatEmotionPageView:initEmotionData(packageid)
	self.pagesData, chatDesRead = nil, nil
	local data = chatDesRead.getEmotionData(packageid)
	local totalNumber = #data
	chatDesRead = nil
	;(nil).scroll = self.pageView
	self.pageView:updateScrollView(cc.size(125, 130), data, 5, nil)
	self.pageView:scrollToTop(0, false)
end
function chatEmotionPageView:createEmotionItem()
	local single = display.newNode()
	local emotionItem = include("chatEmotionSingleItem").new()
	single:addChild(emotionItem)
	emotionItem:setPosition(62.5, 65)
	single.emotionItem = emotionItem
	return single
end
function chatEmotionPageView:emotionRefresh(parent, data, otheData)
	_UPVALUE0_ = nil
	;(nil).data = data
	;(nil).chatDelegate = self.chatDelegate
	parent.emotionItem:initWithData(nil, otheData)
end
function chatEmotionPageView:onExit()
	SoraDRemoveMessageByTarget(self)
	SoraDManagerRemoveTimerByTarget(self)
	self:freeImages()
end
function chatEmotionPageView:initEmotionList()
	local _ENV, tbListItems
	for _, v in ipairs(chatDesRead.getEmotionList()) do
		local node = self:createEmotionListItem()
		self:initListItem(node, v)
		print("node = ", tostring(node), ", self.scrollList =", self.scrollList)
		node:addTo(self.scrollList)
		table.insert(tbListItems, node)
	end
	local scrollSize = self.scrollList:getContentSize()
	local innerWidth = math.max(#tbListItems * _defaultParam.listItemSize.width, scrollSize.width)
	self.scrollList:setInnerContainerSize(cc.size(innerWidth, scrollSize.height))
	local y = scrollSize.height / 2
	for i, node in ipairs(tbListItems) do
		if SoraDFIsRA() then
			local x = innerWidth - (i - 0.5) * _defaultParam.listItemSize.width
			node:setPosition(cc.p(x, y))
		else
			local x = (i - 0.5) * _defaultParam.listItemSize.width
			node:setPosition(cc.p(x, y))
		end
	end
	self.tbListItems = tbListItems
	self.curListItem = self.tbListItems[1]
	self:selListItem(self.curListItem)
end
function chatEmotionPageView:createEmotionListItem()
	local itemSize = _defaultParam.listItemSize
	local node = display.newNode()
	node:setContentSize(itemSize)
	local imgSel = ccui.ImageView:create()
	imgSel:loadTexture("frame_ltyh_bq_xz.png", ccui.TextureResType.plistType)
	imgSel:addTo(node)
	imgSel:ignoreContentAdaptWithSize(false)
	imgSel:setContentSize(cc.size(62, 62))
	imgSel:setAnchorPoint(cc.p(0.5, 0.5))
	imgSel:setPosition(cc.p(itemSize.width / 2, itemSize.height / 2))
	imgSel:setVisible(false)
	local button = ccui.Button:create()
	button:loadTextures("bg_transparent.png", "bg_transparent.png", "bg_transparent.png", ccui.TextureResType.plistType)
	button:ignoreContentAdaptWithSize(false)
	button:setContentSize(itemSize)
	button:addTo(node)
	button:setContentSize(itemSize)
	button:setPosition(cc.p(itemSize.width / 2, itemSize.height / 2))
	button:addTouchEventListener(handler(self, self.onBtnEmotionListItem))
	button:setPressedActionEnabled(true)
	button:setSwallowTouches(false)
	button:setTouchEnabled(true)
	local imgItem = ccui.ImageView:create()
	imgItem:loadTexture("chat_icon_face.png", ccui.TextureResType.plistType)
	imgItem:addTo(button)
	imgItem:ignoreContentAdaptWithSize(false)
	imgItem:setContentSize(_defaultParam.listIconSize)
	imgItem:setAnchorPoint(cc.p(0.5, 0.5))
	imgItem:setPosition(cc.p(itemSize.width / 2, itemSize.height / 2))
	node.btn = button
	node.imgItem = imgItem
	node.imgSel = imgSel
	node:setAnchorPoint(cc.p(0.5, 0.5))
	return node
end
function chatEmotionPageView:initListItem(itemNode, itemData)
	itemNode.itemData = itemData
	itemNode.imgItem:loadTexture(itemData.icon, ccui.TextureResType.plistType)
end
function chatEmotionPageView:selListItem(itemNode)
	itemNode.btn:setTouchEnabled(false)
	itemNode.imgSel:setVisible(true)
	self:initEmotionData(itemNode.itemData.packageid)
	_ENV = itemNode.itemData.packageid
	itemNode.itemData.packageid.grupid = itemNode.itemData.packageid
	userSDKManager.logEvent(gSDKDef.TDonEvent.click_emoticon_group, itemNode.itemData.packageid)
end
function chatEmotionPageView:unSelListItem(itemNode)
	itemNode.btn:setTouchEnabled(true)
	itemNode.btn:setSwallowTouches(false)
	itemNode.imgSel:setVisible(false)
end
function chatEmotionPageView:onBtnEmotionListItem(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local node = target:getParent()
		self:selListItem(node)
		self:unSelListItem(self.curListItem)
		self.curListItem = node
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return chatEmotionPageView
