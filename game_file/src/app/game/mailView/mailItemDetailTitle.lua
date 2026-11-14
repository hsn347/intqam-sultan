local mailFunctions = include("mailFunctions")
local mailCtrl = SoraDGetCtrl("mailCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local mailDesRead = include("mailDesRead")
local mailDesParser = include("mailDesParser")
local mailItemDetailTitle = class("mailItemDetailTitle", function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new(getCCSPath("mailItemDetailTitle"))
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function mailItemDetailTitle:ctor()
	self:setAnchorPoint(cc.p(0, 0))
	self:setCascadeOpacityEnabled(true)
	self.contentPanel = SoraDGetChildByName(self, "ContentPanel")
	self.contentPanel:setSwallowTouches(false)
	_ENV = self.contentPanel.setSwallowTouches
	self.contentPanel.setSwallowTouches.x = 0
	self.coordinate, self.contentPanel.setSwallowTouches.y = self.contentPanel.setSwallowTouches, 0
	self.text_mail_time = SoraDGetChildByName(self, "text_mail_time")
	self.text_mail_title_bottom = SoraDGetChildByName(self, "text_mail_title_bottom")
	self.text_mail_title_coordinate = SoraDGetChildByName(self, "text_mail_title_coordinate")
	self.text_mail_title_coordinate:setSwallowTouches(false)
	self.text_mail_title_coordinate:addTouchEventListener(handler(self, self.onCoordinate))
	self.text_mail_title_coordinate:setTouchScaleChangeEnabled(true)
	self.text_mail_summer = SoraDGetChildByName(self, "text_mail_summer")
	self.text_mail_summer = SoraDChangeTextToHtml(self.text_mail_summer)
	local itemSize = self.contentPanel:getContentSize()
	self.itemWidth = itemSize.width
	self.itemHeight = itemSize.height
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
end
function mailItemDetailTitle:initWithData(mail)
	self:resetTitle()
	self.mail = mail
	self.mailType = self.mail:getProperty("mailType")
	self.mailSource = self.mail:getProperty("source")
	self.mailSetType = self.mail:getProperty("mailSetType")
	if gMailSetTypeFunc.isReportSetBySetType(self.mailSetType) then
		return
	end
	self:updateMailTitle()
	local date = mailFunctions:getMailDetailDate(self.mail)
	self.text_mail_time:setString(date)
	self.text_mail_time:setPositionY(24)
	self.text_mail_summer:setFontSize(22)
	self.text_mail_summer:setVisible(true)
	self:updateCoordinateText()
end
function mailItemDetailTitle:updateMailTitle()
	local mailSummerTitle = mailDesParser.getDetailMailTitle(self.mail)
	local fontSize = gMailSetTypeFunc.getMailSourceSmallFontSize(self.mailSource)
	self.text_mail_summer:setString(mailSummerTitle)
	if self.mail:getProperty("data").titlecolor then
		self.text_mail_summer:setColor(include("mailUIConstDef").colorType[self.mail:getProperty("data").titlecolor])
	else
		self.text_mail_summer:setColor(cc.c3b(68, 35, 17))
	end
end
function mailItemDetailTitle:updateCoordinateText()
	if gMailSetTypeFunc.checkNeedCoordinateBtn(self.mailType) and (gMailSetTypeFunc.checkIsBattleMailSource(self.mailSource) or gMailSetTypeFunc.checkIsScoutMailSource(self.mailSource)) then
		self.text_mail_title_coordinate:setTouchEnabled(true)
		self.text_mail_summer:setVisible(false)
		self.text_mail_time:setPositionY(55)
		self.coordinate = mailFunctions:getMailCoordinate(self.mail)
		self.coordinate.kid = self.coordinate.kid or self.mail:getKingdomID()
		local mailContentType = self.mail.property.data.contentType
		local showCoordinate = true
		if self.coordinate.x == 0 and self.coordinate.y == 0 then
			self.text_mail_title_bottom:setVisible(false)
			self.text_mail_title_coordinate:setVisible(false)
			return
		end
		local title = ""
		if gMailSetTypeFunc.checkIsScoutMailSource(self.mailSource) then
			title = ""
			self.text_mail_title_bottom:setString(i18n("common_text_3157"))
		elseif gMailSetTypeFunc.checkIsBattleMailSource(self.mailSource) then
			title = i18n("common_text_3158")
			self.text_mail_title_bottom:setString(mailDesParser.getDetailMailTitle(self.mail))
		elseif mailContentType ~= nil and mailContentType == gMailNPCContentType.Content_Alliance_Flag_Build then
			title = i18n("common_text_2588")
			self.text_mail_title_bottom:setString(mailDesParser.getDetailMailTitle(self.mail))
		else
			showCoordinate = false
		end
		if showCoordinate then
			self.text_mail_title_bottom:setVisible(true)
			self.text_mail_title_coordinate:setVisible(true)
			local strCoordinate = mailFunctions:getStrCoordinate(self.coordinate.x, self.coordinate.y)
			SoraDChangeTextToHtml(self.text_mail_title_coordinate)
			_ENV = mailDesParser.getDetailMailTitle(self.mail)
			mailDesParser.getDetailMailTitle(self.mail).num = title
			_ENV, _ENV, mailDesParser.getDetailMailTitle(self.mail).char = mailDesParser.getDetailMailTitle(self.mail)
			mailDesParser.getDetailMailTitle(self.mail).char, mailDesParser.getDetailMailTitle(self.mail).u = mailDesParser.getDetailMailTitle(self.mail)
			self.text_mail_title_coordinate:setString(i18n_html("common_text_1470", mailDesParser.getDetailMailTitle(self.mail)))
			local coordMeasureWidth = SoraDGetTextLenEx(self.text_mail_title_coordinate)
			local bottomMeasureWidth = SoraDGetTextLenEx(self.text_mail_title_bottom)
			if 600 < coordMeasureWidth + bottomMeasureWidth then
				local offsetX = coordMeasureWidth + bottomMeasureWidth - 600
				SoraDSetTextWidthHeight(self.text_mail_title_coordinate, cc.size(coordMeasureWidth - offsetX / 2, 40))
				SoraDSetTextWidthHeight(self.text_mail_title_bottom, cc.size(bottomMeasureWidth - offsetX / 2, 40))
			end
		else
			self.text_mail_title_bottom:setVisible(false)
			self.text_mail_title_coordinate:setVisible(false)
		end
	else
		self.text_mail_title_bottom:setVisible(false)
		self.text_mail_title_coordinate:setVisible(false)
	end
end
function mailItemDetailTitle:onCoordinate(target, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if not self.coordinate then
			return
		end
		SoraDPlaySound()
		local targetPoint = cc.p(self.coordinate.x, self.coordinate.y)
		targetPoint.kid = self.coordinate.kid
		if SoraDGotoWorldMapPoint(targetPoint, true, targetPoint.kid) then
			_ENV = targetPoint
			targetPoint.msg = "MESSAGE_MAIL_CLOSE_VIEW"
			SoraDSendMessage(targetPoint)
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
function mailItemDetailTitle:getItemWidth()
	return self.itemWidth
end
function mailItemDetailTitle:getItemHeight()
	return self.itemHeight
end
function mailItemDetailTitle:resetTitle()
	self.coordinate = nil
	_UPVALUE3_ = nil
	;(nil)[1] = self.text_mail_title_center
	;(nil)[2] = self.text_mail_title_bottom
	;(nil)[3] = self.text_mail_title_coordinate
	for i, v in ipairs(nil) do
		v:setVisible(false)
	end
	_UPVALUE1_ = ipairs(nil)
	ipairs(nil)[1] = self.text_mail_time
	for i, v in ipairs(ipairs(nil)) do
		v:setVisible(true)
	end
end
return mailItemDetailTitle
