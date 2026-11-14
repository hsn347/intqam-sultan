local systemNoticeBoxType2 = class("systemNoticeBoxType2", function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new(getCCSPath("systemNoticeBoxType2"))
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function systemNoticeBoxType2:ctor()
	self.text_speed = 120
	self.layout_content = SoraDGetChildByName(self, "layout_content")
	self.layout_msg = SoraDGetChildByName(self, "layout_msg")
	self.img_npc = SoraDGetChildByName(self, "img_npc")
	self.layout_msg_content = SoraDGetChildByName(self, "layout_msg_content")
	self.text_content = SoraDGetChildByName(self, "text_content")
	self.text_content = SoraDChangeTextToHtml(self.text_content)
	self:setContentSize(cc.size(self.layout_content:getContentSize()))
	self:setSwallowTouches(false)
end
function systemNoticeBoxType2:initWithData(data)
	dump(data, "systemNoticeBoxType2:initWithData", 10)
	self.data = data
	local isShowClose = data.closeable or false
	print("systemNoticeBoxType2: data.isShowClose = ", isShowClose)
	local data = data.content
	local content = data.content
	self.text_content:setString(content)
	local npcImgId = data.npcImgId
	local avatar = data.avatar
	if npcImgId ~= nil then
		SoraDGetHeadFromManager(self.img_npc, npcImgId, avatar)
	end
	if isShowClose == true then
		self:showClose()
	end
	local contentSize = self.text_content:getContentSize()
	local totalWidth = contentSize.width
	local sizeLayoutMsg = self.layout_msg:getContentSize()
	self.layout_msg_content:setAnchorPoint(SoraDFAP(1, 0))
	self.layout_msg_content:setContentSize(cc.size(totalWidth, sizeLayoutMsg.height))
	self.text_content:setAnchorPoint(SoraDFAP(1, 0.5))
	self.text_content:setPositionX(SoraDFPosX(totalWidth, totalWidth))
	local offsetX = totalWidth + sizeLayoutMsg.width
	local circle1 = offsetX / self.text_speed
	local n = 2
	print("n = ", n)
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
	self.layout_msg_content:runAction(seq2)
end
function systemNoticeBoxType2:resetTextContentPos()
	local sizeLayoutMsg = self.layout_msg:getContentSize()
	self.layout_msg_content:setAnchorPoint(SoraDFAP(1, 0))
	self.layout_msg_content:setPositionX(SoraDFPosX(0, sizeLayoutMsg.width))
end
function systemNoticeBoxType2:endShow()
	_ENV = nil
	;(nil).msg = "MESSAGE_SYSTEM_NOTICE_UI_REMOVE_NOTICE"
	;(nil).data = self.data
	SoraDSendMessage(nil)
	self:removeFromParent()
end
function systemNoticeBoxType2:showClose()
	if self.btn_close == nil then
		local button = ccui.Button:create()
		button:setTouchEnabled(true)
		button:loadTextures("icon_czhl_x.png", "icon_czhl_x.png", "", ccui.TextureResType.plistType)
		button:setScale(0.4)
		button:setPosition(SoraDFPoint(40, self.layout_content:getContentSize().height / 2 - 5, 640))
		self.layout_content:addChild(button)
		self.btn_close = button
	end
	if self.btn_close then
		self.btn_close:setSwallowTouches(true)
		self.btn_close:addTouchEventListener(handler(self, self.closeEvent))
	end
end
function systemNoticeBoxType2:closeEvent(sender, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		self.layout_msg_content:stopAllActions()
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
return systemNoticeBoxType2
