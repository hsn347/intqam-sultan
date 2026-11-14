local systemNoticeBox = class("systemNoticeBox", function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new(getCCSPath("systemNoticeBox"))
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function systemNoticeBox:ctor()
	self.layout_content = SoraDGetChildByName(self, "layout_content")
	self.text_notice = SoraDGetChildByName(self, "text_notice")
	self.itemWidth = self.layout_content:getContentSize().width
	self.itemHeight = self.layout_content:getContentSize().height
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
	self:setSwallowTouches(false)
end
function systemNoticeBox:initWithData(data)
	local data = data.data
	self.data = data
	local text = data.nickName .. ":" .. data.content
	self.text_notice:setString(text)
	local offsetX = 200
	local actionMoveBy = cca.moveBy(2, offsetX, 0)
	local actDelay = cca.delay(3)
	local callFunc = cca.callFunc(handler(self, self.endShow))
	_UPVALUE2_ = handler(self, self.endShow)
	handler(self, self.endShow)[1] = actionMoveBy
	handler(self, self.endShow)[2] = actDelay
	local spawn = cca.spawn(handler(self, self.endShow))
	_UPVALUE2_ = actionMoveBy
	actionMoveBy[1] = spawn
	actionMoveBy[2] = callFunc
	local seq = cca.seq(actionMoveBy)
	self.text_notice:runAction(seq)
end
function systemNoticeBox:endShow()
	print("ended !")
	self.text_notice:setPosition(cc.p(self.text_notice:getPositionX() - 200, self.text_notice:getPositionY()))
	self.text_notice:setString("")
	self:removeFromParent()
	_ENV = self
	self.msg = "MESSAGE_SYSTEM_NOTICE_UI_REMOVE_NOTICE"
	self.data = self.data
	SoraDSendMessage(self)
end
function systemNoticeBox:getItemWidth()
	return self.itemWidth
end
function systemNoticeBox:getItemHeight()
	return self.itemHeight
end
return systemNoticeBox
