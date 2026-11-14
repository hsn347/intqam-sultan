local worldMapDefine = include("worldMapDefine")
local mailFunctions = include("mailFunctions")
local itemDesRead = include("itemDesRead")
local publicRead = include("publicRead")
local mailNodeFactory = include("mailNodeFactory")
local mailItemDetailResourceInfo = class("mailItemDetailResourceInfo", function(target)
	return SoraDCreateBasePanel("mailItemDetailResourceInfo")
end)
function mailItemDetailResourceInfo:ctor()
	self:setCascadeOpacityEnabled(true)
	self.layout_content = SoraDGetChildByName(self, "layout_content")
	self.layout_content:setSwallowTouches(false)
	self.layout_top = SoraDGetChildByName(self, "layout_top")
	self.layout_res = SoraDGetChildByName(self, "layout_res")
	self.layout_top.isLayout = true
	self.layout_res.isLayout = true
	self.imageBg = SoraDGetChildByName(self, "Image_Bg")
	self.text_time = SoraDGetChildByName(self, "text_time")
	self.text_name = SoraDGetChildByName(self, "text_name")
	self.img_line = SoraDGetChildByName(self, "img_line")
	self.text_coordinate = SoraDGetChildByName(self, "text_coordinate")
	self.text_coordinate = SoraDChangeTextToHtmlFgui(self.text_coordinate)
	self.text_coordinate:setSwallowTouches(false)
	self.text_coordinate:addTouchEventListener(handler(self, self.onCoordinate))
	_ENV = self.text_coordinate.addTouchEventListener
	self.text_coordinate.addTouchEventListener.x = 0
	self.coordinate, self.text_coordinate.addTouchEventListener.y = self.text_coordinate.addTouchEventListener, 0
	self.singleIsMoved = false
	local itemSize = self.layout_content:getContentSize()
	self.itemWidth = itemSize.width
	self.itemHeight = itemSize.height
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
	self.layout_res:setLayoutType(ccui.LayoutType.VERTICAL)
end
function mailItemDetailResourceInfo:initWithData(mail)
	self.mail = mail
	self.mailType = self.mail:getProperty("mailType")
	self.scroll = gModuleMgr.sharedMgr("mailMgr"):getScrollParent()
	self.layout_res:removeAllChildren()
	if self.rewardHead then
		self.rewardHead:removeFromParent()
		self.rewardHead = nil
	end
	if self.rewardLayout then
		self.rewardLayout:removeFromParent()
		self.rewardLayout = nil
	end
	self:updateTextName()
	self:updateTextCoordinate()
	local strDate = mailFunctions:getMailDetailDate(self.mail)
	self.text_time:setString(strDate)
	if self.mailType == gMailType.RESOURCE_GATHER_REPORT then
		self.itemHeight = self:createRewardResourceGatherReport()
		self.layout_content:setLayoutType(ccui.LayoutType.VERTICAL)
	elseif self.mailType == gMailType.RESOURCE_HELP_REPORT then
		self.itemHeight = self:createRewardResourceHelpReport()
	end
	self.layout_content:setContentSize(cc.size(self.itemWidth, self.itemHeight))
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
	local lpFrame = ccui.LayoutParameter:create()
	self.imageBg:setLayoutParameter(lpFrame)
	self.imageBg:setContentSize(cc.size(612, self.itemHeight - (self.layout_top:isVisible() and 30 or 0)))
end
function mailItemDetailResourceInfo:updateTextName()
	local contentData = self.mail:getProperty("data")
	if self.mailType == gMailType.RESOURCE_GATHER_REPORT then
		local resInfo = contentData.resourceInfo
		local resSetType = resInfo.resSetType
		if resSetType == gCollEmailResType.alliance then
			local resId = resInfo.id
			local resName = worldMapDefine.getAllianceResourceName(resId) or ""
			self.text_name:setString(resName)
		elseif resSetType == gCollEmailResType.warTreasure then
			local resId = resInfo.id
			local resName = worldMapDefine.getWarTreasureBuildingName(resId) or ""
			local resLv = worldMapDefine.getWarTreasureBuildingLv(resId) or 0
			_ENV = nil
			;(nil).lv = resLv
			;(nil).name = resName
			local strName = i18n("common_text_134", nil)
			self.text_name:setString(strName)
		elseif resSetType == gCollEmailResType.flameWar then
			local roaringFlameWarRead = include("roaringFlameWarRead")
			local resId = resInfo.id
			local resName = roaringFlameWarRead.getBuildNameByBuildId(resId)
			local resLv = roaringFlameWarRead.getBuildLevel(resId)
			_ENV = strName
			strName.lv = resLv
			strName.name = resName
			local strName = i18n("common_text_134", strName)
			self.text_name:setString(strName)
		else
			local resId = resInfo.id
			local resName = worldMapDefine.getResourceName(resId) or ""
			local resLv = worldMapDefine.getResourceLevel(resId) or 0
			_ENV = self.text_name.setString
			self.text_name.setString.lv = resLv
			self.text_name.setString.name = resName
			local strName = i18n("common_text_134", self.text_name.setString)
			self.text_name:setString(strName)
		end
	elseif mailType == gMailType.RESOURCE_HELP_REPORT then
		local uinfo = contentData.uinfo
		local allianceInfo = contentData.allianceInfo
		local strName = mailFunctions:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		self.text_name:setString(strName)
	end
	SoraDSetTextWidthHeight(self.text_name, cc.size(215, 23))
end
function mailItemDetailResourceInfo:updateTextCoordinate()
	local coordinate
	local contentData = self.mail:getProperty("data")
	if self.mailType == gMailType.RESOURCE_GATHER_REPORT then
		coordinate = contentData.resourceInfo.coordinate
	elseif self.mailType == gMailType.RESOURCE_HELP_REPORT then
		coordinate = contentData.uinfo.coordinate
	end
	local strCoordinate = mailFunctions:getStrCoordinate(coordinate.x, coordinate.y)
	SoraDChangeTextToHtml(self.text_coordinate)
	_ENV = nil
	_ENV, _ENV, (nil).commonStr = nil, nil, strCoordinate
	;(nil).commonStr, (nil).u = nil, true
	self.text_coordinate:setString(i18n_html("common_text_034", nil, nil))
	self.coordinate.x = coordinate.x
	self.coordinate.y = coordinate.y
	self.coordinate.kid = coordinate.kid or self.mail:getKingdomID()
end
function mailItemDetailResourceInfo:createItemReward(itemData, width)
	local fontColor = cc.c3b(102, 50, 12)
	local item = itemData
	if width == nil then
		width = 580
	end
	local imgIconName, itemName, itemDes
	local hLayout = ccui.HBox:create()
	hLayout:setCascadeOpacityEnabled(true)
	local imgNode, imgIconBg
	if false == SoraDJudgeResOrItem(item.id) then
		imgIconBg = ccui.ImageView:create()
		imgIconBg:loadTexture("frame_mrth_boxbg_01.png", ccui.TextureResType.plistType)
		imgIconBg:ignoreContentAdaptWithSize(false)
		imgIconBg:setContentSize(cc.size(50, 50))
		hLayout:addChild(imgIconBg)
		imgIconName = publicRead.getIcon(item.id)
		itemName = publicRead.getName(item.id)
		if item.taxInfo == nil then
			_ENV = imgIconBg
			imgIconBg.numValue = string.formatnumberthousands(item.num)
			itemDes = i18n("common_text_3057", imgIconBg)
		else
			_ENV = imgIconBg
			imgIconBg.total = string.formatnumberthousands(item.num + item.taxInfo.taxNum)
			imgIconBg.num = string.formatnumberthousands(item.num)
			imgIconBg.abbr = item.taxInfo.leagueAbbrName
			imgIconBg.allianceName = item.taxInfo.leagueName
			imgIconBg.tax = string.formatnumberthousands(item.taxInfo.taxNum)
			itemDes = i18n("common_text_3058", imgIconBg)
		end
		local imgIcon = ccui.ImageView:create()
		imgIcon:loadTexture(imgIconName, ccui.TextureResType.plistType)
		imgIcon:ignoreContentAdaptWithSize(false)
		imgIcon:setContentSize(cc.size(43, 45))
		hLayout:addChild(imgIcon)
		imgNode = imgIcon
	else
		itemName = publicRead.getName(item.id)
		itemDes = itemName .. " +" .. string.formatnumberthousands(item.num)
		local mailItemBox = include("mailItemBox")
		local boxNode = mailItemBox.new()
		_ENV = cc.size(43, 45)
		cc.size(43, 45).id = item.id
		boxNode:initWithData(cc.size(43, 45))
		boxNode:setContentSize(cc.size(boxNode:getItemWidth(), boxNode:getItemHeight()))
		boxNode:setScale(55 / boxNode:getItemWidth())
		hLayout:addChild(boxNode)
		imgNode = boxNode
	end
	local lp1 = ccui.LayoutParameter:create()
	imgNode:setLayoutParameter(lp1)
	imgNode:setAnchorPoint(SoraDFAP(1, 0.5))
	imgNode:setPosition(SoraDFPoint(width - 20, 29, width))
	if imgIconBg then
		imgIconBg:setLayoutParameter(lp1)
		imgIconBg:setAnchorPoint(SoraDFAP(1, 0.5))
		imgIconBg:setPosition(SoraDFPoint(width - 20, 29, width))
	end
	local labelDes = ccui.Text:create()
	labelDes:setFontSize(20)
	labelDes:setColor(fontColor)
	labelDes:setString(itemDes)
	hLayout:addChild(labelDes)
	labelDes:setTextHorizontalAlignment(SoraDFLabelR())
	local lp2 = ccui.LayoutParameter:create()
	labelDes:setLayoutParameter(lp2)
	labelDes:setAnchorPoint(SoraDFAP(1, 0.5))
	labelDes:setPosition(SoraDFPoint(width - 100, 29, width))
	hLayout:setContentSize(cc.size(width, 58))
	return hLayout
end
function mailItemDetailResourceInfo:createRewardResourceGatherReport()
	local totalHeight = self.layout_top:getContentSize().height
	local contentData = self.mail:getProperty("data")
	local reward = contentData.reward.items
	local resTotalHeight = 0
	mailFunctions:sortResItems(reward)
	mailFunctions = mailFunctions.sortResItems
	local mailFunctions, resList, itemList = mailFunctions, mailFunctions.sortResItems, mailFunctions
	for i, item in ipairs(reward) do
		if false == SoraDJudgeResOrItem(item.id) then
			table.insert(resList, item)
		else
			table.insert(itemList, item)
		end
	end
	for i, item in ipairs(resList) do
		local hLayout = self:createItemReward(item)
		local lp3 = ccui.LinearLayoutParameter:create()
		lp3:setGravity(ccui.LinearGravity.centerHorizontal)
		mailFunctions = ccui.LinearGravity.centerHorizontal
		ccui.LinearGravity.centerHorizontal.left = 0
		ccui.LinearGravity.centerHorizontal.top = 10
		ccui.LinearGravity.centerHorizontal.right = 0
		ccui.LinearGravity.centerHorizontal.bottom = 0
		lp3:setMargin(ccui.LinearGravity.centerHorizontal)
		hLayout:setLayoutParameter(lp3)
		resTotalHeight = resTotalHeight + hLayout:getContentSize().height + 10
		self.layout_res:addChild(hLayout)
	end
	if next(itemList) and next(resList) then
		self.img_line:setVisible(true)
		local lp1 = ccui.LinearLayoutParameter:create()
		lp1:setGravity(ccui.LinearGravity.centerHorizontal)
		mailFunctions = ccui.LinearGravity.centerHorizontal
		ccui.LinearGravity.centerHorizontal.left = 0
		ccui.LinearGravity.centerHorizontal.top = 0
		ccui.LinearGravity.centerHorizontal.right = 0
		ccui.LinearGravity.centerHorizontal.bottom = 10
		lp1:setMargin(ccui.LinearGravity.centerHorizontal)
		totalHeight = totalHeight + 10
		self.img_line:setLayoutParameter(lp1)
	else
		self.img_line:setVisible(false)
		self.img_line:setLayoutParameter(ccui.LayoutParameter:create())
	end
	if next(itemList) then
		local lp1 = ccui.LinearLayoutParameter:create()
		lp1:setGravity(ccui.LinearGravity.centerHorizontal)
		mailFunctions = ccui.LinearGravity.centerHorizontal
		ccui.LinearGravity.centerHorizontal.left = 0
		ccui.LinearGravity.centerHorizontal.top = 0
		ccui.LinearGravity.centerHorizontal.right = 0
		ccui.LinearGravity.centerHorizontal.bottom = 20
		lp1:setMargin(ccui.LinearGravity.centerHorizontal)
		self.rewardHead, autoHeight = mailNodeFactory:createLayoutRewardItemHead()
		totalHeight = totalHeight + autoHeight
		self.rewardHead.isLayout = true
		self.rewardHead:addTo(self.layout_content)
		self.rewardLayout, autoHeight = mailNodeFactory:creatRewardCustomNode(itemList, 5, 1)
		totalHeight = totalHeight + autoHeight
		self.rewardLayout:addTo(self.layout_content)
		self.rewardLayout:setLayoutParameter(lp1)
		local lp2 = ccui.LinearLayoutParameter:create()
		lp2:setGravity(ccui.LinearGravity.centerHorizontal)
		mailFunctions = ccui.LinearGravity.centerHorizontal
		ccui.LinearGravity.centerHorizontal.left = 0
		ccui.LinearGravity.centerHorizontal.top = 0
		ccui.LinearGravity.centerHorizontal.right = 0
		ccui.LinearGravity.centerHorizontal.bottom = 0
		lp2:setMargin(ccui.LinearGravity.centerHorizontal)
		totalHeight = totalHeight + 20
		self.rewardHead:setLayoutParameter(lp2)
	end
	local lp4 = ccui.LinearLayoutParameter:create()
	lp4:setGravity(ccui.LinearGravity.centerHorizontal)
	mailFunctions = ccui.LinearGravity.centerHorizontal
	ccui.LinearGravity.centerHorizontal.left = 0
	ccui.LinearGravity.centerHorizontal.top = 0
	ccui.LinearGravity.centerHorizontal.right = 0
	ccui.LinearGravity.centerHorizontal.bottom = 10
	lp4:setMargin(ccui.LinearGravity.centerHorizontal)
	resTotalHeight = resTotalHeight + 10
	self.layout_res:setLayoutParameter(lp4)
	self.layout_res:setContentSize(cc.size(612, resTotalHeight))
	totalHeight = totalHeight + resTotalHeight
	return totalHeight
end
function mailItemDetailResourceInfo:createRewardResourceHelpReport()
	local resTotalHeight = 0
	local playerInfoNode = include("mailItemDetailPlayerInfo").new()
	playerInfoNode:initWithData(self.mail.property.data)
	playerInfoNode:addTo(self.layout_res)
	resTotalHeight = resTotalHeight + playerInfoNode:getItemHeight()
	local line = self.img_line:clone()
	line:addTo(self.layout_res)
	local lp3 = ccui.LinearLayoutParameter:create()
	line:setLayoutParameter(lp3)
	lp3:setGravity(ccui.LinearGravity.centerHorizontal)
	resTotalHeight = resTotalHeight + 6
	local resHead, autoHeight = mailNodeFactory:createLayoutRewardItemHead(i18n("common_text_123"))
	resHead:addTo(self.layout_res)
	resTotalHeight = resTotalHeight + autoHeight
	local contentData = self.mail:getProperty("data")
	local resLayout, autoHeight = mailNodeFactory:createResList(contentData.reward.items)
	self.layout_res:addChild(resLayout)
	resTotalHeight = resTotalHeight + autoHeight
	self.layout_res:setContentSize(cc.size(gMailDetaiViewWidth, resTotalHeight))
	self.layout_res:setPosition(cc.p(0, 10))
	self.layout_top:setVisible(false)
	self.img_line:setVisible(false)
	return resTotalHeight
end
function mailItemDetailResourceInfo:getItemWidth()
	return self.itemWidth
end
function mailItemDetailResourceInfo:getItemHeight()
	return self.itemHeight
end
function mailItemDetailResourceInfo:onCoordinate(target, event)
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
return mailItemDetailResourceInfo
