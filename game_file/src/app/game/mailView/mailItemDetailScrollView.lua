local mailItemDetailScrollView = class("mailItemDetailScrollView", function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new(getCCSPath("mailItemDetailScrollView"))
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	SoraDDeviceFitOffset(target)
	return target
end)
function mailItemDetailScrollView:ctor()
	self:setAnchorPoint(cc.p(0, 0))
	self.scrollView = SoraDGetChildByName(self, "Size_detail_scrollView")
	self.scrollView:setCascadeOpacityEnabled(true)
	self:setContentSize(self.scrollView:getContentSize())
end
function mailItemDetailScrollView:onMessageListener()
	print("mailItemDetailBattle")
	SoraDAddMessage(self, "MESSAGE_MAIL_UI_DETAIL_SCROLL_CONTENT_SIZE_CHANGED", handler(self, self.msgOnSizeChanged))
end
function mailItemDetailScrollView:initWithData(mail, senderId, specialView)
	self.mail = mail
	self.mailType = mail:getProperty("mailType")
	local mailSource = mail:getProperty("source")
	self.mailSetType = self.mail:getProperty("mailSetType")
	local data = self.mail:getProperty("data")
	self.mailContentType = data and data.contentType
	local fguiMailConfig = gMailSetTypeFunc.getFguiMailConfig(self.mailContentType)
	if fguiMailConfig then
		local fguiMail = fguiHelper.createObject(fguiMailConfig.pkgName or "mailView", fguiMailConfig.resName)
		fguiMail.isFguiOnCocos = true
		fguiMail:addTo(self.scrollView:getInnerContainer())
		fguiMail:setName(fguiMailConfig.resName)
		fguiMail:initData(data, mail)
		local height = fguiMail:getItemHeight()
		self.scrollView:setInnerContainerSize(cc.size(self.scrollView:getContentSize().width, height))
		self.scrollView:jumpToTop()
		return
	end
	local totalHeight = 0
	self.mailTitle = self:createMailTitle()
	totalHeight = self.mailTitle:getItemHeight() + totalHeight
	if self:isShowTitleInfo() then
		self.mailTitleInfo = self:createMailTitleInfo()
		totalHeight = self.mailTitleInfo:getItemHeight() + totalHeight
	end
	local mailContenName = gMailSetTypeFunc.getPanleNameByType(false, mailSource)
	mailContenName = mailContenName or gMailSetTypeFunc.getPanleNameByType(true, self.mailType)
	if not mailContenName then
		return
	end
	local mailContentDetailNode = include(mailContenName)
	self.mailContentNode = mailContentDetailNode.new()
	self.mailContentNode:setName(mailContenName)
	if self.mailType == gMailType.RESOURCE_HELP_REPORT then
		self.mailContentNode:initWithData(mail)
	else
		self.mailContentNode:initWithData(mail, senderId, specialView)
	end
	if self.mailContentNode == nil then
		return
	end
	totalHeight = self.mailContentNode:getItemHeight() + totalHeight
	self.mailContentNode:setCascadeOpacityEnabled(true)
	self.mailContentNode:setAnchorPoint(cc.p(0, 0))
	self.scrollView:getInnerContainer():addChild(self.mailContentNode)
	local scrollSize = self.scrollView:getContentSize()
	local scrollInner = self.scrollView:getInnerContainer()
	local newHeight = math.max(scrollSize.height, totalHeight)
	print("totalHeight", totalHeight)
	self.scrollView:setInnerContainerSize(cc.size(scrollSize.width, newHeight))
	local posY = newHeight - self.mailTitle:getItemHeight()
	self.mailTitle:setPosition(cc.p(0, posY))
	if self.mailTitleInfo then
		posY = posY - self.mailTitleInfo:getItemHeight()
		self.mailTitleInfo:setPosition(cc.p(0, posY))
	end
	posY = posY - self.mailContentNode:getItemHeight()
	self.mailContentNode:setPosition(cc.p(0, posY))
	self.scrollView:jumpToTop()
end
function mailItemDetailScrollView:createMailTitle()
	local panel = include("mailItemDetailTitle").new()
	panel:setName("mailItemDetailTitle")
	panel:initWithData(self.mail)
	panel:addTo(self.scrollView:getInnerContainer())
	panel:setCascadeOpacityEnabled(true)
	return panel
end
function mailItemDetailScrollView:createMailTitleInfo()
	local panel = include("mailItemDetailTitleInfo").new()
	panel:setName("mailItemDetailTitleInfo")
	panel:initWithData(self.mail)
	panel:addTo(self.scrollView:getInnerContainer())
	panel:setCascadeOpacityEnabled(true)
	return panel
end
function mailItemDetailScrollView:cleanAll()
	self:cleanInnerContents()
end
function mailItemDetailScrollView:cleanInnerContents()
	local scrollInner = self.scrollView:getInnerContainer()
	scrollInner:removeAllChildren()
	self.mailTitleInfo = nil
	self.mailContentNode = nil
end
function mailItemDetailScrollView:isShowTitleInfo()
	local mailDesInfo = include("mailDesRead").getMailDesInfo(self.mailType, self.mailSource, self.mailContentType)
	if mailDesInfo ~= nil and mailDesInfo.icon and mailDesInfo.icon ~= "" then
		return true
	end
	local bNeedShow = true
	if self.mailSetType == gMailSetType.SCOUT_REPORT and self.mailSource ~= gMailSource.SCOUT_CITY_FAILED and self.mailSource ~= gMailSource.BE_SCOUTED_CITY_FAILED and self.mailSource ~= gMailSource.SCOUT_TROOP_FAILED and self.mailSource ~= gMailSource.BE_SCOUTED_TROOP_FAILED then
		bNeedShow = false
	end
	if self.mailType == gMailType.BATTLE_REPORT or self.mailType == gMailType.SYSTEM_NOTICE or self.mailType == gMailType.OFFICIAL_SYSTEM_NOTICE or self.mailType == gMailType.ACTIVITY_NOTICE or self.mailType == gMailType.OFFICIAL_ACTIVITY_NOTICE or self.mailType == gMailType.EXPLORE or self.mailType == gMailType.ACTIVITY or self.mailType == gMailType.OFFICIAL_ACTIVITY or self.mailType == gMailType.ALLIANCE_REWARD or self.mailType == gMailType.COMMUNITY_CENTER or self.mailType == gMailType.OFFICIAL_COMMUNITY_CENTER or self.mailSource == gMailSource.Treasure_Map_Occupy or self.mailContentType == gMailNPCContentType.Content_alliance_Mark then
		bNeedShow = false
	end
	return bNeedShow
end
function mailItemDetailScrollView:msgOnSizeChanged(target, data)
	local parent = data.node
	local needUpdate = false
	while parent and parent:getName() ~= "GRootDisplayObject" do
		print("mailItemDetailScrollView", self, parent)
		if parent == self then
			needUpdate = true
			break
		end
		parent = parent:getParent()
	end
	print("mailItemDetailScrollView", needUpdate)
	if not needUpdate then
		return
	end
	local deltaY = data.deltaY
	local scrollSize = self.scrollView:getContentSize()
	local oldHeight = self.scrollView:getInnerContainerSize().height
	local newHeight = oldHeight + deltaY
	newHeight = math.max(scrollSize.height, newHeight)
	self.scrollView:setInnerContainerSize(cc.size(scrollSize.width, newHeight))
	local posY = newHeight - self.mailTitle:getItemHeight()
	self.mailTitle:setPosition(cc.p(0, posY))
	if self.mailTitleInfo then
		posY = posY - self.mailTitleInfo:getItemHeight()
		self.mailTitleInfo:setPosition(cc.p(0, posY))
	end
	if self.mailContentNode then
		posY = posY - self.mailContentNode:getItemHeight()
		self.mailContentNode:setPosition(cc.p(0, posY))
	end
end
function mailItemDetailScrollView:resetContentSize(newSize)
	self:setContentSize(newSize)
	self.scrollView:setContentSize(newSize)
end
function mailItemDetailScrollView:setTouchEnabled(isEnable)
	self.scrollView:setTouchEnabled(isEnable)
end
return mailItemDetailScrollView
