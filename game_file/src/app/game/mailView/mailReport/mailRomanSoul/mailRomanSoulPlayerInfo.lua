local mailFunctions = include("mailFunctions")
local lordLocalData = include("lordLocalData")
local mailRomanSoulPlayerInfo = class("mailRomanSoulPlayerInfo", function(target)
	return include("ccsView").new(getCCSPath("mailRomanSoulPlayerInfo"))
end)
function mailRomanSoulPlayerInfo:ctor()
	self:setAnchorPoint(cc.p(0, 0))
	self:setCascadeOpacityEnabled(true)
	self.layout_content = SoraDGetChildByName(self, "layout_content")
	self.layout_content:setSwallowTouches(false)
	self.text_coordinate = SoraDGetChildByName(self, "text_coordinate")
	self.text_coordinate:addTouchEventListener(handler(self, self.onCoordinate))
	self.text_name = SoraDGetChildByName(self, "text_name")
	self.playerAvatarBox = SoraDCreatePanel("playerAvatarBox")
	self.playerAvatarBox:setContentSize(cc.size(self.playerAvatarBox:getItemWidth(), self.playerAvatarBox:getItemHeight()))
	self.playerAvatarBox:setAnchorPoint(SoraDFAP(0.5, 0.5))
	self.playerAvatarBox:setPosition(SoraDFPoint(450, 60, self.layout_content:getContentSize().width))
	self.playerAvatarBox:addTo(self.layout_content)
	self.playerAvatarBox:setScroll(gModuleMgr.sharedMgr("mailMgr"):getScrollParent())
	self.playerAvatarBox:setCascadeOpacityEnabled(true)
	local itemSize = self.layout_content:getContentSize()
	self.itemWidth = itemSize.width
	self.itemHeight = itemSize.height
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
	self.coordinate, _ENV = self.setContentSize, self.setContentSize
end
function mailRomanSoulPlayerInfo:initWithData(data)
	local uinfo = data.uinfo
	local coordinate = uinfo.coordinate
	self.scroll = gModuleMgr.sharedMgr("mailMgr"):getScrollParent()
	local strCoordinate = mailFunctions:getStrCoordinate(coordinate.x, coordinate.y)
	self.coordinate.x = coordinate.x
	self.coordinate.y = coordinate.y
	self.coordinate.kid = coordinate.kid
	SoraDChangeTextToHtml(self.text_coordinate)
	_ENV = nil
	_ENV, _ENV, (nil).commonStr = nil, nil, strCoordinate
	;(nil).commonStr, (nil).u = nil, true
	self.text_coordinate:setString(i18n_html("common_text_034", nil, nil))
	local allianceInfo = data.allianceInfo
	if not allianceInfo then
		allianceInfo, _ENV = self.text_coordinate, self.text_coordinate
	end
	local strName = mailFunctions:getWrappedName(allianceInfo.abbr, uinfo.nickName)
	self.text_name:setString(strName)
	local playerId = uinfo.id
	local iconName = lordLocalData.getHead(uinfo.iconID)
	_ENV = i18n_html("common_text_034", nil, nil)
	i18n_html("common_text_034", nil, nil).playerId = playerId
	i18n_html("common_text_034", nil, nil).imageId = uinfo.iconID
	i18n_html("common_text_034", nil, nil).avatar = uinfo.avatar
	i18n_html("common_text_034", nil, nil).imgPlayer = iconName
	self.playerAvatarBox:initWithData(i18n_html("common_text_034", nil, nil))
end
function mailRomanSoulPlayerInfo:getItemWidth()
	return self.itemWidth
end
function mailRomanSoulPlayerInfo:getItemHeight()
	return self.itemHeight
end
function mailRomanSoulPlayerInfo:onCoordinate(target, event)
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
return mailRomanSoulPlayerInfo
