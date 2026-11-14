local chatFunctions = include("chatFunctions")
local mailFunctions = include("mailFunctions")
local lordLocalData = include("lordLocalData")
local mailDesRead = include("mailDesRead")
local mailDesParser = include("mailDesParser")
local mailMgr = gModuleMgr.sharedMgr("mailMgr")
local mailCtrl = SoraDGetCtrl("mailCtrl")
local mailItem = class("mailItem", function(target)
	return include("ccsView").new(getCCSPath("mailItem"))
end)
function mailItem:ctor()
	self.judgeMove = 2 * TOUCH_MOVED_ERROR_VALUE
	self.itemWidth = 640
	self.deltaX = 0
	self.isMoveH = false
	self.btnIsMoved = false
	self.layout_item = SoraDGetChildByName(self, "layout_item")
	self.layout_item:setSwallowTouches(false)
	self.layout_item:addTouchEventListener(handler(self, self.onLayoutItem))
	self.spriteBg = SoraDGetChildByName(self.layout_item, "spriteBg")
	self.iconBgColor = SoraDGetChildByName(self.layout_item, "iconBgColor")
	self.img_icon = SoraDGetChildByName(self.layout_item, "img_icon")
	self.img_icon:ignoreContentAdaptWithSize(false)
	self.imgNumberBg = SoraDGetChildByName(self.layout_item, "img_number")
	self.labelNumber = SoraDGetChildByName(self.imgNumberBg, "label_number")
	self.btnNumberBg = SoraDGetChildByName(self.layout_item, "btnNumberBg")
	self.btnNumberBg:addTouchEventListener(handler(self, self.onBtnNumberBg))
	self.btnNumberBg:setSwallowTouches(true)
	self.btnNumberBg:setVisible(false)
	self.label_title = SoraDGetChildByName(self.layout_item, "label_title")
	self.label_summary = SoraDGetChildByName(self.layout_item, "label_summary")
	self.label_summary = SoraDChangeTextToHtml(self.label_summary)
	self.label_summary_title = SoraDGetChildByName(self.layout_item, "label_summary_title")
	self.label_time = SoraDGetChildByName(self.layout_item, "label_time")
	self.spriteAttachment = SoraDGetChildByName(self.layout_item, "spriteAttachment")
	self.nodeAlv = SoraDGetChildByName(self, "Node_ALV")
	self.iconAlv = SoraDGetChildByName(self.nodeAlv, "icon_allianceR")
	self.imgArrow = SoraDGetChildByName(self, "img_arrow")
end
function mailItem:setScrollView(scrollView)
	self.mailScrollView = scrollView
end
function mailItem:initWithData(mid, mailSetKey)
	self.mailSetKey = mailSetKey
	self.mail = mailMgr:queryMail(mid)
	if not self.mail then
		return
	end
	mailFunctions:resetMailSource(self.mail)
	self.mailType = self.mail:getProperty("mailType")
	self.mailSetType = self.mail:getProperty("mailSetType")
	self.imgArrow:setVisible(gMailSetTypeFunc.isReportSetBySetType(self.mailSetType))
	self:updateMailRedNum()
	self:updateMailIcon()
	self:updateMailTitle()
	self:updateMailSummary()
	self:updateMailMidSummary()
	self:updateTime()
	self:updateAttach()
	self:updateAlvNode()
end
function mailItem:updateMailRedNum()
	if gMailSetTypeFunc.isReportSetBySetType(self.mailSetType) then
		local numberOfUnRead = mailCtrl:getNewNumOfSet(self.mailSetType)
		if 0 < numberOfUnRead then
			self.imgNumberBg:setScale(0.8)
			self.imgNumberBg:setVisible(true)
			if 99 < numberOfUnRead then
				self.labelNumber:setString("99+")
			else
				self.labelNumber:setString(tostring(numberOfUnRead))
			end
		else
			self.imgNumberBg:setVisible(false)
			self.btnNumberBg:setVisible(false)
		end
	elseif not self.mail:isView() then
		self.imgNumberBg:setScale(0.5)
		self.imgNumberBg:setVisible(true)
		self.labelNumber:setString("")
		self.btnNumberBg:setVisible(true)
	else
		self.imgNumberBg:setVisible(false)
		self.btnNumberBg:setVisible(false)
	end
end
function mailItem:updateMailIcon()
	self.img_icon.curlKey = nil
	local property = self.mail.property
	local mailSource = property.source
	local contentType = property.data.contentType
	local imageId = property.data.uinfo and property.data.uinfo.iconID
	local avatar = property.data.uinfo and property.data.uinfo.avatar
	local mailIconName
	local mailDesInfo = mailDesRead.getMailDesInfo(self.mailType, mailSource, contentType)
	if mailDesInfo ~= nil and mailDesInfo.icon and mailDesInfo.icon ~= "" then
		mailIconName = mailDesInfo.icon
	end
	local mailIconBg = mailDesRead.getMailSetColor(self.mailSetType)
	if mailIconBg and mailIconBg ~= "" then
		self.iconBgColor:setSpriteFrame(mailIconBg)
	end
	if not mailIconName then
		if self.mailType == gMailType.BATTLE_REPORT then
			local contentData = mailDesParser.getMailContentData(self.mail)
			local mapType = contentData.mapType
			if mapType then
				if mapType == gMapObjTypeDef.mapObjNewTrialCity then
					mailIconName = "icon_mail_devilvalley.png"
				elseif mapType == gMapObjTypeDef.mapTypeRadianceWarBeacon or mapType == gMapObjTypeDef.mapTypeRadianceWarGate or mapType == gMapObjTypeDef.mapTypeRadianceWarPalace or mapType == gMapObjTypeDef.mapTypeRadianceWarResource then
					local radianceWarRead = include("radianceWarRead")
					mailIconName = radianceWarRead.getMailIcon(mapType, contentData.objId)
				end
			end
		elseif (self.mailType == gMailType.SYSTEM_NOTICE or self.mailType == gMailType.OFFICIAL_SYSTEM_NOTICE) and contentType == gMailSystemNoticeType.Content_Version_Update then
			mailIconName = "icon_mail_ver_update.png"
		elseif self.mailType == gMailType.GUIDE or self.mailType == gMailType.OFFICIAL_GUIDE then
			mailIconName = chatFunctions:getNpcHead()
		elseif self.mailType == gMailType.ALLIANCE_GROUP_MAIL then
			imageId = property.data.playerInfo and property.data.playerInfo.iconID
			avatar = property.data.playerInfo and property.data.playerInfo.avatar
			if imageId == nil then
				mailIconName = lordLocalData.getHead(imageId)
			else
				SoraDGetHeadFromManager(self.img_icon, imageId, avatar)
				return
			end
		elseif self.mailType == gMailType.ALLIANCE_INVITATION or self.mailType == gMailType.QUIT_ALLIANCE or self.mailType == gMailType.INVITE_MOVE_CITY then
			if imageId == nil then
				mailIconName = lordLocalData.getHead(imageId)
			else
				SoraDGetHeadFromManager(self.img_icon, imageId, avatar)
				return
			end
		elseif self.mailType == gMailType.ALLIANCE and contentType == gMailNPCContentType.Content_Recharge_Reward_Alliance then
			mailIconName = chatFunctions:getNpcHead()
		elseif gMailSetTypeFunc.isReportSetBySetType(self.mailSetType) then
			mailIconName = mailDesRead.getMailSetIcon(self.mailSetType)
		end
	end
	if not mailIconName then
		local mailInfo = mailDesRead.getMailTypeInfo(false, self.mailType, mailSource)
		if mailInfo ~= nil and mailInfo.icon ~= "" then
			mailIconName = mailInfo.icon
		else
			mailIconName = "icon_mail_system.png"
		end
	end
	self.img_icon:loadTexture(mailIconName, ccui.TextureResType.plistType)
end
function mailItem:updateMailTitle()
	dump(self.mail.property, "self.mail.property.data")
	local mailTitle = mailDesParser.getMailTitle(self.mail)
	if gMailSetTypeFunc.isReportSetBySetType(self.mailSetType) then
		mailTitle = mailDesRead.getMailSetTitle(self.mailSetType)
		mailTitle = i18n(mailTitle)
		self.mailBigTitle = mailTitle
	end
	self.label_title:setString(mailTitle)
	local maxWidth = 315
	if maxWidth < self.label_title:getContentSize().width then
		local retString, label = SoraDConvertOmissionText(maxWidth, mailTitle, 24)
		self.label_title:setString(retString)
	end
	self.mailTitle = mailTitle
end
function mailItem:updateMailSummary()
	local mailSummaryStr = mailDesParser.getMailSummary(self.mail)
	local maxWidth = 430
	if gMailSetTypeFunc.isReportSetBySetType(self.mailSetType) then
		local cur, total = mailCtrl:getMailCountPer(self.mailSetType)
		mailDesParser = nil
		;(nil).member = cur
		;(nil).total = total
		self.label_summary:setString("(" .. i18n("common_text_155", nil) .. ")")
	else
		self.label_summary:setString(mailSummaryStr)
	end
	self.label_summary:setPositionY(55)
	if maxWidth < self.label_summary:getContentSize().width then
		local retString, label = SoraDConvertOmissionText(maxWidth, mailSummaryStr, 21, nil, true)
		self.label_summary:setString(retString)
	end
	self.mailSummary = mailSummaryStr
	if self.mail:getProperty("data").titlecolor then
		self.label_summary:setColor(include("mailUIConstDef").colorType[self.mail:getProperty("data").titlecolor])
	else
		self.label_summary:setColor(cc.c3b(50, 30, 0))
	end
end
function mailItem:updateMailMidSummary()
	self.label_summary_title:setVisible(false)
	local strMidSummary = mailDesParser.getMailMidSummary(self.mail)
	if strMidSummary then
		self.label_summary_title:setString(strMidSummary)
		self.label_summary_title:setVisible(true)
		self.label_summary_title:setPositionY(70)
		self.label_summary:setPositionY(45)
	end
end
function mailItem:updateTime()
	local date = mailFunctions:getMailDate(self.mail)
	self.label_time:setString(date)
end
function mailItem:updateAttach()
	if self.mail:isGetExtra() or not self.mail:hasExtra() then
		self.spriteAttachment:setVisible(false)
	else
		self.spriteAttachment:setVisible(true)
	end
end
function mailItem:updateAlvNode()
	self.nodeAlv:setVisible(false)
	if self.mailType == gMailType.ALLIANCE_GROUP_MAIL then
		local alv = self.mail:getProperty("data").playerInfo.rank
		if alv then
			self.nodeAlv:setVisible(true)
			local strIconName = string.format("icon_alliance_R%d.png", alv)
			if alv == gAllianceRank.OFFICIAL then
				strIconName = "icon_alliance_office.png"
				self.iconAlv:setPositionX(SoraDFPosX(-27, 3))
			end
			print(alv, strIconName)
			self.iconAlv:setSpriteFrame(strIconName)
			self.iconAlv:setScale(43 / self.iconAlv:getContentSize().width)
		end
	end
end
function mailItem:onLayoutItem(target, event)
	if event == ccui.TouchEventType.ended then
		if self.mailScrollView.scrollView and not SoraDIsNodeVisibleOnScroll(target, self.mailScrollView.scrollView) then
			return
		end
		if self.btnIsMoved then
			self.btnIsMoved = false
			return
		end
		SoraDPlaySound()
		if gMailSetTypeFunc.isReportSetBySetType(self.mailSetType) then
			mailCtrl = self.mailScrollView.scrollView
			self.mailScrollView.scrollView[1] = self.mailSetType
			mailCtrl:viewMailSet(self.mailScrollView.scrollView)
		else
			mailCtrl:viewMail(self.mail:getProperty("mid"))
		end
		local panel = SoraDCreatePanel("mailItemDetailView")
		panel:show()
		panel:initWithData(self.mail, self.mailSetKey)
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.btnIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.btnIsMoved = false
	elseif event == ccui.TouchEventType.began then
		if self.mailScrollView.scrollView and not SoraDIsNodeVisibleOnScroll(target, self.mailScrollView.scrollView, event) then
			return
		end
		self.btnIsMoved = false
	end
end
function mailItem:onBtnNumberBg(sender, event)
	if event == ccui.TouchEventType.began then
		if self.mailScrollView.scrollView and not SoraDIsNodeVisibleOnScroll(sender, self.mailScrollView.scrollView, event) then
			self.isNumVisible = false
			return
		end
		self.isNumVisible = true
		local labelNumber = self.labelNumber
		local sourcePoint = sender:convertToWorldSpace(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2))
		_ENV = cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2)
		cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2).msg = "MESSAGE_MAIL_UI_RED_POINT_EVENT"
		cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2).sender = sender
		cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2).event = event
		cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2).number = labelNumber:getString()
		cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2).sourcePoint = sourcePoint
		cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2).imgNumberBg = self.imgNumberBg
		cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2).otherData = self.mail
		SoraDSendMessage(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2))
	elseif event == ccui.TouchEventType.moved and self.isNumVisible then
		_ENV = sender:convertToWorldSpace(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2))
		sender:convertToWorldSpace(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2)).msg = "MESSAGE_MAIL_UI_RED_POINT_EVENT"
		sender:convertToWorldSpace(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2)).sender = sender
		sender:convertToWorldSpace(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2)).event = event
		SoraDSendMessage((sender:convertToWorldSpace(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2))))
	elseif event == ccui.TouchEventType.canceled and self.isNumVisible then
		_ENV = sender:convertToWorldSpace(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2))
		sender:convertToWorldSpace(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2)).msg = "MESSAGE_MAIL_UI_RED_POINT_EVENT"
		sender:convertToWorldSpace(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2)).sender = sender
		sender:convertToWorldSpace(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2)).event = event
		SoraDSendMessage((sender:convertToWorldSpace(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2))))
	elseif event == ccui.TouchEventType.ended and self.isNumVisible then
		_ENV = sender:convertToWorldSpace(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2))
		sender:convertToWorldSpace(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2)).msg = "MESSAGE_MAIL_UI_RED_POINT_EVENT"
		sender:convertToWorldSpace(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2)).sender = sender
		sender:convertToWorldSpace(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2)).event = event
		SoraDSendMessage((sender:convertToWorldSpace(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2))))
	end
end
return mailItem
