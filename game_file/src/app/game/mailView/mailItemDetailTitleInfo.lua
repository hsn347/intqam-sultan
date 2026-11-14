local mailFunctions = include("mailFunctions")
local mailItemDetailTitleInfo = class("mailItemDetailTitleInfo", function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new(getCCSPath("mailItemDetailTitleInfo"))
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
local bgImgWidth = 612
local bgImgHeight = 210
function mailItemDetailTitleInfo:ctor()
	self:setAnchorPoint(cc.p(0, 0))
	self:setCascadeOpacityEnabled(true)
	self.contentPanel = SoraDGetChildByName(self, "ContentPanel")
	if self.contentPanel then
		self.contentPanel:setSwallowTouches(false)
		self.contentPanel:setCascadeOpacityEnabled(true)
	end
	self.img_title = SoraDGetChildByName(self, "img_title")
	self.img_line = SoraDGetChildByName(self, "img_line")
	self.text_name = SoraDGetChildByName(self, "text_name")
	self.playerAvatarBox = SoraDCreatePanel("playerAvatarBox")
	self.playerAvatarBox:setContentSize(cc.size(self.playerAvatarBox:getItemWidth(), self.playerAvatarBox:getItemHeight()))
	self.playerAvatarBox:setAnchorPoint(SoraDFAP(0, 0))
	self.playerAvatarBox:addTo(self.contentPanel)
	self.playerAvatarBox:setPosition(SoraDFPoint(259, 80, 625))
	self.playerAvatarBox:setCascadeOpacityEnabled(true)
	self.playerAvatarBox:setScale(1.2)
end
function mailItemDetailTitleInfo:initWithData(mail)
	self.mail = mail
	self.itemWidth = gMailDetaiViewWidth
	self.itemHeight = 190
	bgImgHeight = nil
	;(nil)[1] = self.playerAvatarBox
	;(nil)[2] = self.img_line
	;(nil)[3] = self.text_name
	for i, v in ipairs(nil) do
		v:setVisible(true)
	end
	mailFunctions = ipairs(nil)
	ipairs(nil)[1] = self.img_title
	for i, v in ipairs(ipairs(nil)) do
		v:setVisible(false)
	end
	local mailType = self.mail:getProperty("mailType")
	local mailSource = self.mail:getProperty("source")
	local contentData = self.mail:getProperty("data")
	if mailType == gMailType.RESOURCE_HELP_REPORT or gMailSetTypeFunc.isReportSetBySetType(self.mail:getProperty("mailSetType")) then
		bgImgHeight = self.mail:getProperty("mailSetType")
		self.mail:getProperty("mailSetType")[1] = self.playerAvatarBox
		self.mail:getProperty("mailSetType")[2] = self.img_line
		self.mail:getProperty("mailSetType")[3] = self.text_name
		for i, v in ipairs(self.mail:getProperty("mailSetType")) do
			v:setVisible(false)
		end
		mailFunctions = ipairs(self.mail:getProperty("mailSetType"))
		ipairs(self.mail:getProperty("mailSetType"))[1] = self.img_title
		for i, v in ipairs(ipairs(self.mail:getProperty("mailSetType"))) do
			v:setVisible(true)
		end
		local imgName = mailFunctions:getSceneImgByMailType(mailType)
		self.img_title:loadTexture(imgName, ccui.TextureResType.plistType)
		self.img_title:ignoreContentAdaptWithSize(false)
		self.img_title:setContentSize(cc.size(bgImgWidth, bgImgHeight))
		self.itemHeight = self.img_title:getContentSize().height + 15
		self.img_title:setPositionY(5)
	elseif gMailSetTypeFunc.isUseImgPlayer(mailType) then
		local allianceInfo = contentData.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = mailType, mailType
		end
		local abbr = allianceInfo.abbr
		if not abbr and allianceInfo.property and allianceInfo.property.abbr then
			abbr = allianceInfo.property.abbr
		end
		if not abbr and not contentData.uinfo and contentData.playerInfo then
			abbr = contentData.playerInfo.allianceAbbr
		end
		local uInfo = contentData.uinfo or contentData.playerInfo
		local name = mailFunctions:getWrappedName(abbr, uInfo.nickName)
		self.text_name:setString(name)
		local imageId = uInfo.iconID
		local avatar = uInfo.avatar
		local alv = uInfo.rank
		dump(contentData.uinfo, "self.mail")
		_ENV = "self.mail"
		;("self.mail").playerId = uInfo.uid or uInfo.id
		;("self.mail").imageId = imageId
		;("self.mail").avatar = avatar
		self.playerAvatarBox:initWithData("self.mail")
		if alv then
			self.playerAvatarBox:setMailR(alv)
		end
		self.playerAvatarBox:setBtnTouchEnabled(true)
	else
		local textName = i18n("mail_text_26")
		if mailSource == gMailSource.SCOUT_CITY_FAILED or mailSource == gMailSource.SCOUT_TROOP_FAILED then
			textName = i18n("mail_text_18")
		elseif mailSource == gMailSource.BE_SCOUTED_CITY_FAILED or mailSource == gMailSource.BE_SCOUTED_TROOP_FAILED then
			textName = i18n("mail_text_31")
		end
		self.text_name:setString(textName)
		local mailIconName = "icon_mail_guidenpc.png"
		self.playerAvatarBox:setBtnTouchEnabled(false)
		_ENV = false
		;(false).playerId = contentData.content and contentData.content.npcId or 1000
		;(false).imgPlayer = mailIconName
		self.playerAvatarBox:initWithData(false)
	end
	self.contentPanel:setContentSize(cc.size(self.itemWidth, self.itemHeight))
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
end
function mailItemDetailTitleInfo:getItemWidth()
	return self.itemWidth
end
function mailItemDetailTitleInfo:getItemHeight()
	return self.itemHeight
end
return mailItemDetailTitleInfo
