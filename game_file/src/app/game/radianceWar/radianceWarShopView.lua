local activityExchangeMallRead = include("activityExchangeMallRead")
local radianceActivityCtrl = SoraDGetCtrl("radianceActivityCtrl")
local lightShiningCtrl = SoraDGetCtrl("lightShiningCtrl")
local publicRead = include("publicRead")
local radianceWarShopView = class("radianceWarShopView", function(target)
	return target or SoraDCreateBasePanel("radianceWarShopView")
end)
_ENV = "radianceWarShopView"
;("radianceWarShopView").MartialArts = 2
local _UPVALUE1_, ("radianceWarShopView").StartLight, VIEW_TYPE = function(target)
	return target or SoraDCreateBasePanel("radianceWarShopView")
end, 1, "radianceWarShopView"
local (function(target)
	return target or SoraDCreateBasePanel("radianceWarShopView")
end)[1], buffArray = 5449, function(target)
	return target or SoraDCreateBasePanel("radianceWarShopView")
end
function radianceWarShopView:ctor(properties)
	self.isHideCurrentSceneView = true
	self.itemID = 1608
	self.activityID = gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.nodeCommonFramTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle")
	self.nodeCommonFramTitle:setTitle(i18n("brightWar_title_09"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_Size")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("radianceWarShopSingle")
	self.imgIcon = SoraDGetChildByName(self, "Image_icon")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	self.textToken = SoraDGetChildByName(self, "Text_token")
	self.textActiviey = SoraDGetChildByName(self, "Text_activiey_time")
	self.textActiviey:setString(i18n("brightWar_text_119"))
	SoraDGetAutoHeightLabel(self.textActiviey, 480)
	self.ccs_buff = SoraDGetExtendChildFromCCSByName(self, "CCS_radianceWarBuffNode_node")
	self.ccs_buff:setTimeEndHandle(function()
		local isActive = lightShiningCtrl:isBuffActive()
		self.ccs_buff:setVisible(isActive)
		self.ccs_buff:setVisible(false)
	end)
	self.ccs_buff:initData(buffArray)
	self.ccs_buff:setVisible(false)
	_ENV, self.nodeCommonTabBtn = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn"), SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn").tabNum = 2
	_ENV, _ENV, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn").defaultClick = "Top_CCS_commonTabBtn", self, 1
	;("Top_CCS_commonTabBtn").title = i18n("brightWar_title_10")
	;("Top_CCS_commonTabBtn").handle = handler(self, self.btnTabClick)
	;("Top_CCS_commonTabBtn").fontSize = 22
	_ENV, self[1], ("Top_CCS_commonTabBtn").tag = "Top_CCS_commonTabBtn", "Top_CCS_commonTabBtn", VIEW_TYPE.MartialArts
	;("Top_CCS_commonTabBtn").title = i18n("brightWar_text_23")
	;("Top_CCS_commonTabBtn").handle = handler(self, self.btnTabClick)
	;("Top_CCS_commonTabBtn").fontSize = 22
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn").tabsetArray, self[2], ("Top_CCS_commonTabBtn").tag = self, "Top_CCS_commonTabBtn", VIEW_TYPE.StartLight
	local tableData = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")
	self.nodeCommonTabBtn:initView(tableData)
	self:initData()
end
function radianceWarShopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateTokenInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.updataRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", handler(self, self.updataScroll))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", handler(self, self.updataScroll))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.refreshEventModule))
end
function radianceWarShopView:refreshEventModule(target, redata)
	self:updataScroll()
	self:updataRedPoint()
end
function radianceWarShopView:initData(target, data)
	self:updataRedPoint()
end
function radianceWarShopView:updateTokenInfo()
	self.itemHaveNum = radianceActivityCtrl:getExchangeNum(self.itemID)
	self.imgIcon:loadTexture(publicRead.getIcon(self.itemID), ccui.TextureResType.plistType)
	radianceActivityCtrl = nil
	;(nil).name = publicRead.getName(self.itemID)
	;(nil).num = string.formatnumberthousands(math.floor(self.itemHaveNum))
	self.textToken:setString(i18n("common_text_036", nil))
	_UPVALUE3_ = 320
	;(320)[1] = self.imgIcon
	;(320)[2] = self.textToken
	;(320)[3] = self.btnHelp
	_ENV = self.textToken
	self.textToken[1] = 5
	self.textToken[2] = 10
	_G.SoraDAlignNodeArrayOnCenterX(SoraDFPosX(320, 0), 320, SoraDFIsRA(), self.textToken)
end
function radianceWarShopView:updataScroll()
	SoraDCloseLoading(self)
	if not activityExchangeMallRead:getShopItemList(self.activityID, self.shopViewType) then
		local _ENV, showShopItemList = activityExchangeMallRead:getShopItemList(self.activityID, self.shopViewType), activityExchangeMallRead:getShopItemList(self.activityID, self.shopViewType)
	end
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	;(nil).activityID = self.activityID
	;(nil).tag = self.shopViewType
	self.scroll:updateScrollView(cc.size(624, 170), showShopItemList, 1, nil)
end
function radianceWarShopView:updataRedPoint()
	local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
	local retTask_1 = activityExchangeMallCtrl:getReceiveStatusAndNum(self.activityID, VIEW_TYPE.MartialArts)
	local retTask_2 = activityExchangeMallCtrl:getReceiveStatusAndNum(self.activityID, VIEW_TYPE.StartLight)
	self.nodeCommonTabBtn:setRedPointState(VIEW_TYPE.MartialArts, retTask_1)
	self.nodeCommonTabBtn:setRedPointState(VIEW_TYPE.StartLight, retTask_2)
end
function radianceWarShopView:btnTabClick(tag, name)
	self.shopViewType = tag
	self.itemID = VIEW_TYPE.MartialArts == self.shopViewType and 1608 or 1609
	self:updataScroll()
	self:updateTokenInfo()
	local isActive = lightShiningCtrl:isBuffActive()
	local isInBuff = lightShiningCtrl:isInBuffList(buffArray)
	self.ccs_buff:setVisible(self.shopViewType == VIEW_TYPE.StartLight and isInBuff and isActive)
end
function radianceWarShopView:btnHelpClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local tag = target:getTag()
		if VIEW_TYPE.MartialArts == self.shopViewType then
			SoraDCreatePanel("radianceWarRulePopView"):show()
		else
			_ENV = "brightWar_text_28"
			;("brightWar_text_28").title = i18n("common_text_1173")
			;("brightWar_text_28").addLine = true
			SoraDShowHelpMsgTip(i18n("brightWar_text_28"), "brightWar_text_28")
		end
	elseif eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif eventType == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return radianceWarShopView
