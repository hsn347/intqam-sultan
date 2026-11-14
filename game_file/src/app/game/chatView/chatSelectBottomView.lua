local DMD = _G.require_data("devilvalley_message")
local chatSelectBottomView = class("chatSelectBottomView", function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatSelectBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function chatSelectBottomView:ctor()
	self.scrollBg = SoraDGetChildByName(self, "scrollBg")
	self.scroll = SoraDGetChildByName(self.scrollBg, "scroll")
	self.defaultItem = SoraDGetChildByName(self, "singleItem")
	self.oriScrollViewPos = cc.p(self.scrollBg:getPosition())
	self.isInit = false
	self.maskArea = SoraDGetChildByName(self, "Size_Select_Bottom_View")
	if self.maskArea then
		self.maskArea:setSwallowTouches(false)
		self.maskArea:addTouchEventListener(handler(self, self.OnMaskArea))
	end
end
function chatSelectBottomView:init(chatDelegate)
	self.chatDelegate = chatDelegate
end
function chatSelectBottomView:initData()
	if self.isInit then
		self.scroll:jumpToTop()
		return
	end
	self:initScroll()
	self.isInit = true
end
function chatSelectBottomView:initScroll()
	local scrollInner = self.scroll:getInnerContainer()
	local scrollMinH = self.scroll:getContentSize().height
	local scrollW = scrollInner:getContentSize().width
	local scrollSize = self:getCellMaxNum()
	local scrollH = math.max(scrollMinH, scrollSize * 50)
	print("initScroll", scrollSize, scrollH)
	local defaultItem = self.defaultItem
	self.tableItemList, _ENV = "initScroll", "initScroll"
	for k = 1, scrollSize do
		local singleItem = self.tableItemList[k]
		if not singleItem then
			singleItem = defaultItem:clone()
			singleItem:addTo(self.scroll)
			singleItem:setTag(k)
			local btn = singleItem:getChildByName("eventBtn")
			btn:addTouchEventListener(handler(self, self.clickCell))
			btn:setTag(k)
			btn:setSwallowTouches(false)
			self.tableItemList[k] = singleItem
		end
		singleItem:setPosition(250, scrollH - k * 50)
		self:updateCell(singleItem, k)
	end
	self.scroll:setInnerContainerSize(cc.size(scrollW, scrollH))
end
function chatSelectBottomView:updateCell(node, index)
	SoraDGetChildByName(node, "text_label"):setString(self:getCellSelectInfo(index))
	SoraDGetChildByName(node, "line"):setVisible(index ~= self:getCellMaxNum())
end
function chatSelectBottomView:getCellMaxNum()
	return #DMD.data
end
function chatSelectBottomView:getCellSelectInfo(index)
	return i18n(DMD.data[index].message)
end
function chatSelectBottomView:OnBtnSendEvent(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		print("发送按钮: Send Click")
		SoraDPlaySound()
		_ENV = "发送按钮: Send Click"
		;("发送按钮: Send Click").msg = "MESSAGE_CHAT_SERVER_SEND_ONE_MESSAGE"
		;("发送按钮: Send Click").message = self.selectIndex
		;("发送按钮: Send Click").messageType = gChatTypeDef.chat_content_text
		SoraDSendMessage("发送按钮: Send Click")
	end
end
function chatSelectBottomView:clickCell(target, eventType)
	if eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif eventType == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.chatDelegate then
			local selectIndex = target:getTag()
			_ENV = target
			target.message = selectIndex
			local target.messageType, param = gChatTypeDef.chat_content_devil_valley_battle, target
			dump(param, "我要发送喊话---!!!!!")
			self.chatDelegate:chatSendOneMessage(self, param)
			self.chatDelegate:toogleSelectBottomUI(false)
		end
	elseif eventType == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function chatSelectBottomView:OnMaskArea(target, eventType)
	if eventType == ccui.TouchEventType.began and self.chatDelegate then
		self.chatDelegate:toogleSelectBottomUI(false)
	end
end
function chatSelectBottomView:onOffsetUI(data)
	local duration = data.duration or 0.25
	local offsetY = data.offsetY
	local actMoveTo = cca.moveTo(duration, self.oriScrollViewPos.x, self.oriScrollViewPos.y + offsetY)
	self.scrollBg:stopAllActions()
	self.scrollBg:runAction(actMoveTo)
end
return chatSelectBottomView
