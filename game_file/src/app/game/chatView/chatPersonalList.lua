local chatFunctions = include("chatFunctions")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local mailCtrl = SoraDGetCtrl("mailCtrl")
local lordLocalData = include("lordLocalData")
local chatDataParser = include("chatDataParser")
local chatCoverMgr = gChatMgrs:getMgr("chatCoverMgr")
local chatPersonalList = class("chatPersonalList", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("chatPersonalList")
end)
function chatPersonalList:onEnterPanel()
end
function chatPersonalList:ctor(properties)
	self.itemHeight = 123
	self.coverList, _ENV, self.nodeSingle = SoraDGetChildByName(self, "Node_Single"), SoraDGetChildByName(self, "Node_Single"), SoraDGetChildByName(self, "Node_Single")
	self.panel = SoraDGetChildByName(self, "Size_Panel")
	self.scroll = SoraDGetChildByName(self.panel, "Size_ScrollView")
	self.scroll:setContentSize(cc.size(self.scroll:getContentSize().width, self.scroll:getContentSize().height + self:getPanelOffsetHeight() - 960))
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createScrollSingle))
	self.scroll:setSingleCCS("chatPersonalItem")
	self.scroll:setScrollBottomFun(handler(self, self.scrollBottomBack))
	self.scroll:setScrollMoveFun(handler(self, self.scrollMoveBack))
	self.btnFriend = SoraDGetChildByName(self.panel, "Button_Friend")
	self.btnFriend:setTitleText(i18n("friend_name_01"))
	self.btnFriend:addTouchEventListener(handler(self, self.btnFriendClick))
	self.btnGroup = SoraDGetChildByName(self.panel, "Button_Group")
	self.btnGroup:setTitleText(i18n("common_text_3526"))
	SoraDAutoSizeButtonText(self.btnGroup, cc.size(216, 70))
	self.btnGroup:addTouchEventListener(handler(self, self.btnGroupClick))
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.textTip = SoraDGetChildByName(self, "Text_Tips")
	self.textTip:setString(i18n("chat_text_72"))
	self.textTip:setVisible(false)
	self.curIndex = math.max(1, #self.coverList)
	if #self.coverList > 0 then
		self.textTip:setVisible(false)
	else
		self.textTip:setVisible(true)
	end
end
function chatPersonalList:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAIL_UI_GET_COVER_BACK", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_CHAT_UI_REFRESH_COVER", handler(self, self.msgRefreshList))
	self.hasMore = chatCoverMgr:reqChatCoverList(1, 20)
	if worldMapDefine.isInSimulatedDrill() then
		self.btnGroup:setEnabled(false)
	else
		self.btnGroup:setEnabled(true)
	end
end
function chatPersonalList:scrollBottomBack()
	if self.fromLoadText then
		self.fromLoadText = false
		self:requestMore()
		self:hideLoadingSprite()
	end
end
function chatPersonalList:scrollMoveBack()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	if offsetY < -55 and self.hasMore then
		self.fromLoadText = true
		self.labelNotice:setString(i18n("common_text_084"))
		self:showLoadingSprite()
		self.loadingSprite:setPositionX(self:getLoadingSpriteXPos())
		self.loadingSprite:setPositionY(self.labelNotice:getPositionY() + self.labelNotice:getContentSize().height / 2)
	else
	end
end
function chatPersonalList:requestMore()
	if self.hasMore then
		print("Request data!!!, index = ", self.curIndex)
		self:showLoadingSprite()
		self.hasMore = chatCoverMgr:reqChatCoverList(self.curIndex + 1, 20)
		if self.hasMore then
			self.labelNotice:setString(i18n("common_text_089"))
		else
			self.labelNotice:setString(i18n("common_text_085"))
		end
	end
end
function chatPersonalList:getLoadingSpriteXPos()
	if SoraDFIsRA() then
		return self.labelNotice:getPositionX() + (self.labelNotice:getContentSize().width / 2 + 25)
	else
		return self.labelNotice:getPositionX() - (self.labelNotice:getContentSize().width / 2 + 25)
	end
end
function chatPersonalList:showLoadingSprite()
	if self.loadingSprite then
		self.loadingSprite:setVisible(true)
	else
		self.loadingSprite = display.newSprite("SinglePicture/loading1.png")
		self.loadingSprite:addTo(self.scroll)
		self.loadingSprite:setScale(25 / self.loadingSprite:getContentSize().width)
		self.loadingSprite:setAnchorPoint(cc.p(0.5, 0.5))
		self.loadingSprite:setPositionX(self:getLoadingSpriteXPos())
		self.loadingSprite:setPositionY(self.labelNotice:getPositionY() + self.labelNotice:getContentSize().height / 2)
	end
	self.loadingSprite:stopAllActions()
	local actionRotateBy = cc.RotateBy:create(1.0, 360)
	local repeatForever = cca.repeatForever(actionRotateBy)
	self.loadingSprite:runAction(repeatForever)
end
function chatPersonalList:hideLoadingSprite()
	if self.loadingSprite then
		self.loadingSprite:stopAllActions()
		self.loadingSprite:setVisible(false)
	end
end
function chatPersonalList:createScrollSingle()
	return include("chatPersonalItem").new(self.nodeSingle:clone())
end
function chatPersonalList:btnFriendClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		if SoraDGetCastleLv() >= CASTLE_LV6_LIMITED then
			uiManager:show("friendView")
		else
			_ENV = nil
			;(nil).build = i18n("buildDes_name_101")
			;(nil).lv = CASTLE_LV6_LIMITED
			SoraDShowMsgTip(i18n("overview_text_01", nil))
		end
	end
end
function chatPersonalList:btnGroupClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		if allianceMgr:hasJoinAlliance() then
			local chatRoomSelPlayers = SoraDCreatePanel("chatRoomSelPlayers")
			chatRoomSelPlayers:show()
			local selfId = chatFunctions:getSelfId()
			_ENV = chatFunctions
			allianceMgr, chatFunctions.selPlayerOpType = chatConst.selPlayerOpType.selPlayerCreateChatRoom, chatConst.selPlayerOpType.selPlayerCreateChatRoom
			chatFunctions.members, chatConst.selPlayerOpType.selPlayerCreateChatRoom[1] = chatConst.selPlayerOpType.selPlayerCreateChatRoom, selfId
			local chatFunctions.owner, data = selfId, chatFunctions
			chatRoomSelPlayers:initWithData(data)
		else
			_ENV = chatFunctions:getSelfId()
			chatFunctions:getSelfId().msg = "MESSAGE_CHAT_OPEN_UI_ALLIANCE"
			chatFunctions:getSelfId().info = "From MAIL"
			SoraDSendMessage((chatFunctions:getSelfId()))
		end
	end
end
function chatPersonalList:setChatDelegate(chatDelegate)
	self.chatDelegate = chatDelegate
end
function chatPersonalList:setCurrentOperateData(target)
	self.currenOpItem = target
end
function chatPersonalList:getCurrentOperateData(target)
	return self.currenOpItem
end
function chatPersonalList:msgCallBack(target, data)
	print("self.curIndex", self.curIndex)
	self.coverList = chatCoverMgr:getChatCoverList(1, self.curIndex + 20)
	self.curIndex = math.max(1, #self.coverList)
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	;(nil).chatDelegate = self.chatDelegate
	;(nil).customHeight = #self.coverList * self.itemHeight + 35 + 8
	;(nil).offSetY = -8
	self.scroll:updateScrollView(cc.size(640, self.itemHeight), self.coverList, 1, nil)
	if #self.coverList > 0 then
		self.textTip:setVisible(false)
	else
		self.textTip:setVisible(true)
	end
end
function chatPersonalList:msgRefreshList(target, data)
	self.coverList = chatCoverMgr:getChatCoverList(1, self.curIndex)
	print("self.curIndex", self.curIndex)
	chatCoverMgr = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	;(nil).chatDelegate = self.chatDelegate
	;(nil).customHeight = #self.coverList * self.itemHeight + 35 + 8
	;(nil).offSetY = -8
	self.scroll:updateScrollView(cc.size(640, self.itemHeight), self.coverList, 1, nil)
end
return chatPersonalList
