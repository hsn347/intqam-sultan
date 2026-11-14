local mailFunctions = include("mailFunctions")
local mailRomanSoulSummary = class("mailRomanSoulSummary", function(target)
	return include("ccsView").new(getCCSPath("mailRomanSoulSummary"))
end)
function mailRomanSoulSummary:ctor()
	self:setCascadeOpacityEnabled(true)
	self.layout_content = SoraDGetChildByName(self, "layout_content")
	self.layout_content:setSwallowTouches(false)
	self.img_bg = SoraDGetChildByName(self, "img_bg")
	self.img_icon = SoraDGetChildByName(self, "img_icon")
	self.img_icon:loadTexture("roman_full.png", ccui.TextureResType.plistType)
	self.img_icon:setContentSize(cc.size(81, 81))
	self.text_coordinate = SoraDGetChildByName(self, "text_coordinate")
	self.text_soldier = SoraDGetChildByName(self, "text_soldier")
	self.text_killed = SoraDGetChildByName(self, "text_killed")
	self.text_killed_percent = SoraDGetChildByName(self, "text_killed_percent")
	self.text_soldier_value = SoraDGetChildByName(self, "text_soldier_value")
	self.text_killed_value = SoraDGetChildByName(self, "text_killed_value")
	self.text_killed_percent_value = SoraDGetChildByName(self, "text_killed_percent_value")
	self.text_score = SoraDGetChildByName(self, "text_score")
	self.text_score_value = SoraDGetChildByName(self, "text_score_value")
	self.text_monster = SoraDGetChildByName(self, "text_monster")
	self.text_soldier:setString(i18n("common_text_474"))
	self.text_killed:setString(i18n("common_text_1474"))
	self.text_killed_percent:setString(i18n("common_text_1475"))
	self.text_score:setString(i18n("common_text_1764"))
	self.text_coordinate:addTouchEventListener(handler(self, self.onCoordinate))
	local itemSize = self.layout_content:getContentSize()
	self.itemWidth = itemSize.width
	self.itemHeight = itemSize.height
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
	self.coordinate, _ENV = self.setContentSize, self.setContentSize
end
function mailRomanSoulSummary:initWithData(data)
	self.scroll = gModuleMgr.sharedMgr("mailMgr"):getScrollParent()
	local romanSoulInfo = data.romanSoulInfo
	local scoreInfo = data.scoreInfo
	if scoreInfo then
		self.text_score_value:setString(scoreInfo.score or 0)
	end
	local coordinate = romanSoulInfo.coordinate
	local strCoordinate = mailFunctions:getStrCoordinate(coordinate.x, coordinate.y)
	self.coordinate.x = coordinate.x
	self.coordinate.y = coordinate.y
	self.coordinate.kid = coordinate.kid
	SoraDChangeTextToHtml(self.text_coordinate)
	_ENV = nil
	_ENV, _ENV, (nil).commonStr = nil, nil, strCoordinate
	;(nil).commonStr, (nil).u = nil, true
	self.text_coordinate:setString(i18n_html("common_text_034", nil, nil))
	self.text_soldier_value:setString(romanSoulInfo.num)
	self.text_killed_value:setString(romanSoulInfo.killed)
	local percent = string.format("%.1f%%", romanSoulInfo.killed * 100 / romanSoulInfo.num)
	self.text_killed_percent_value:setString(percent)
	_ENV = i18n_html("common_text_034", nil, nil)
	i18n_html("common_text_034", nil, nil).wave = romanSoulInfo.wave
	self.text_monster:setString(i18n("common_text_1478", i18n_html("common_text_034", nil, nil)))
end
function mailRomanSoulSummary:getItemWidth()
	return self.itemWidth
end
function mailRomanSoulSummary:getItemHeight()
	return self.itemHeight
end
function mailRomanSoulSummary:onCoordinate(target, event)
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local targetPoint = cc.p(self.coordinate.x, self.coordinate.y)
		targetPoint.kid = self.coordinate.kid
		_ENV = self.coordinate.y
		self.coordinate.y.msg = "MESSAGE_MAIL_CLOSE_VIEW"
		SoraDSendMessage(self.coordinate.y)
		SoraDGotoWorldMapPoint(targetPoint, true, targetPoint.kid)
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
return mailRomanSoulSummary
