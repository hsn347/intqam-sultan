local systemNoticeBoxType1 = class("systemNoticeBoxType1", function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new(getCCSPath("systemNoticeBoxType1"))
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function systemNoticeBoxType1:ctor()
	self.minShowTime = 8
	self.layout_content = SoraDGetChildByName(self, "layout_content")
	self.layout_nameAndMsg = SoraDGetChildByName(self, "layout_nameAndMsg")
	self.text_name = SoraDGetChildByName(self, "text_name")
	self.layout_msg = SoraDGetChildByName(self, "layout_msg")
	self.text_content = SoraDGetChildByName(self, "text_content")
	self.text_content = SoraDChangeTextToHtml(self.text_content)
	self.img_horn = SoraDGetChildByName(self, "img_horn")
	self.btn_close = SoraDGetChildByName(self, "btn_close")
	self.text_speed = 120
	self.btn_close = SoraDGetChildByName(self, "btn_close")
	if self.btn_close then
		self.btn_close:setSwallowTouches(true)
		self.btn_close:addTouchEventListener(handler(self, self.closeEvent))
	end
	self.singleIsMoved = false
	self:setContentSize(cc.size(self.layout_content:getContentSize()))
	self:setSwallowTouches(false)
end
function systemNoticeBoxType1:initWithData(data)
	self.data = data
	local chatCamp = data.chatCamp
	local data = data.content
	local content = data.content
	local name = data.name
	if name == nil then
		name = ""
	end
	if content == nil then
		content = ""
	end
	name = name .. ":"
	content = string.gsub(content, "\n", ",")
	self.text_name:setString(name)
	self.text_content:setString(content)
	if chatCamp then
		local nebulaWarRead = include("nebulaWarRead")
		local campIcon = nebulaWarRead.getWarCampIcon(chatCamp)
		self.img_horn:loadTexture(campIcon, ccui.TextureResType.plistType)
	end
	local sizeLayoutNameAndMsg = self.layout_nameAndMsg:getContentSize()
	local nameSize = self.text_name:getContentSize()
	nameSize.width = nameSize.width + 15
	local contentSize = self.text_content:getContentSize()
	local totalWidth = nameSize.width + contentSize.width
	if totalWidth < sizeLayoutNameAndMsg.width then
		totalWidth = sizeLayoutNameAndMsg.width
	end
	self.layout_msg:setContentSize(cc.size(totalWidth, sizeLayoutNameAndMsg.height))
	self.layout_msg:setAnchorPoint(SoraDFAP(1, 0))
	self.layout_msg:setPosition(SoraDFPoint(0, 0, sizeLayoutNameAndMsg.width))
	self.text_name:setAnchorPoint(SoraDFAP(1, 0.5))
	self.text_name:setPositionX(SoraDFPosX(totalWidth, totalWidth))
	self.text_content:setAnchorPoint(SoraDFAP(1, 0.5))
	self.text_content:setPositionX(SoraDFPosX(totalWidth - nameSize.width, totalWidth))
	if totalWidth <= sizeLayoutNameAndMsg.width then
		self.layout_msg:setPosition(SoraDFPoint(sizeLayoutNameAndMsg.width, 0, sizeLayoutNameAndMsg.width))
		local actDelay = cca.delay(self.minShowTime)
		local callFunc = cca.callFunc(handler(self, self.endShow))
		_UPVALUE2_ = handler(self, self.endShow)
		handler(self, self.endShow)[1] = actDelay
		handler(self, self.endShow)[2] = callFunc
		local seq = cca.seq(handler(self, self.endShow))
		self.layout_msg:runAction(seq)
	else
		local offsetX = totalWidth + sizeLayoutNameAndMsg.width
		local circle1 = offsetX / self.text_speed
		local n = math.ceil(self.minShowTime / circle1)
		if n < 1 then
			n = 1
		end
		local actResetPos = cca.callFunc(handler(self, self.resetTextContentPos))
		if not SoraDFIsRA() then
			offsetX = -offsetX
		end
		local actionMoveBy = cca.moveBy(circle1, offsetX, 0)
		_UPVALUE2_ = offsetX
		offsetX[1] = actResetPos
		offsetX[2] = actionMoveBy
		local seq = cca.seq(offsetX)
		local repeatAct = cca.rep(seq, n)
		local callFunc = cca.callFunc(handler(self, self.endShow))
		_UPVALUE2_ = handler(self, self.endShow)
		handler(self, self.endShow)[1] = repeatAct
		handler(self, self.endShow)[2] = callFunc
		local seq2 = cca.seq(handler(self, self.endShow))
		self.layout_msg:runAction(seq2)
	end
end
function systemNoticeBoxType1:resetTextContentPos()
	local sizeLayoutNameAndMsg = self.layout_nameAndMsg:getContentSize()
	self.layout_msg:setAnchorPoint(SoraDFAP(1, 0))
	self.layout_msg:setPosition(SoraDFPoint(0, 0, sizeLayoutNameAndMsg.width))
end
function systemNoticeBoxType1:endShow()
	_ENV = nil
	;(nil).msg = "MESSAGE_SYSTEM_NOTICE_UI_REMOVE_NOTICE"
	;(nil).data = self.data
	SoraDSendMessage(nil)
	self:removeFromParent()
end
function systemNoticeBoxType1:closeEvent(sender, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		self.layout_msg:stopAllActions()
		self:endShow()
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = sender:getTouchBeganPosition()
		local touchmovePoint = sender:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return systemNoticeBoxType1
