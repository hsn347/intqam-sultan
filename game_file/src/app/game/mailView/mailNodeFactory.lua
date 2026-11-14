local _ENV, mailNodeFactory
local defaultWidth = 612
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
function mailNodeFactory:createTextLayout(param)
	if not param.margin then
		defaultWidth = param.margin
		param.margin.left = 0
		param.margin.top = 0
		param.margin.right = 0
		local param.margin.bottom, newMargin = 0, param.margin
	end
	local totalWidth = param.textWidth or defaultWidth - 60
	local parentWidth = param.parentWidth or gMailDetaiViewWidth
	local totalHeight = 0
	local isHtml = false
	if param.isHtml then
		isHtml = param.isHtml
	end
	local label = ccui.Text:create()
	label.isLayout = true
	label:setFontSize(param.fontSize or 20)
	label:setColor(param.color or cc.c3b(102, 50, 12))
	if param.name then
		label:setName(param.name)
	end
	if param.AlignV then
		label:setTextVerticalAlignment(param.AlignV)
	end
	if param.AlignH then
		label:setTextHorizontalAlignment(param.AlignH)
	end
	if param.linearLayoutType then
		local lp1 = ccui.LinearLayoutParameter:create()
		label:setLayoutParameter(lp1)
		lp1:setGravity(param.linearLayoutType)
		lp1:setMargin(newMargin)
	else
		local lp1 = ccui.LayoutParameter:create()
		label:setLayoutParameter(lp1)
		label:setAnchorPoint(param.point or cc.p(0.5, 0))
		label:setPosition(param.pos or cc.p(parentWidth / 2, 0))
	end
	label:setIsHtml(isHtml)
	label:setString(param.str)
	if param.autoHeight then
		label:setTextAreaSize(cc.size(totalWidth, 0))
	end
	totalHeight = label:getContentSize().height + newMargin.top + newMargin.bottom
	return label, totalHeight
end
function mailNodeFactory:createImgViewLayout(param)
	if not param.margin then
		defaultWidth = param.margin
		param.margin.left = 0
		param.margin.top = 0
		param.margin.right = 0
		local param.margin.bottom, newMargin = 0, param.margin
	end
	local totalWidth = param.imagWidth or defaultWidth
	local parentWidth = param.parentWidth or gMailDetaiViewWidth
	local totalHeight = 0
	local imageView = ccui.ImageView:create()
	imageView.isLayout = true
	imageView:loadTexture(param.imgName, ccui.TextureResType.plistType)
	imageView:ignoreContentAdaptWithSize(false)
	imageView:setContentSize(cc.size(totalWidth, param.imagHeight or 210))
	if param.scale9 then
		imageView:setScale9Enabled(param.scale9)
	end
	if param.scale then
		imageView:setScale(param.scale)
	end
	if param.name then
		imageView:setName(param.name)
	end
	if param.linearLayoutType then
		local lp1 = ccui.LinearLayoutParameter:create()
		imageView:setLayoutParameter(lp1)
		lp1:setGravity(param.linearLayoutType)
		lp1:setMargin(newMargin)
	else
		local lp1 = ccui.LayoutParameter:create()
		imageView:setLayoutParameter(lp1)
		imageView:setAnchorPoint(param.point or cc.p(0.5, 0))
		imageView:setPosition(param.pos or cc.p(parentWidth / 2, 0))
	end
	totalHeight = imageView:getContentSize().height + newMargin.top + newMargin.bottom
	return imageView, totalHeight
end
function mailNodeFactory:createButtonLayout(param)
	if not param.margin then
		_ENV = param.margin
		param.margin.left = 0
		param.margin.top = 0
		param.margin.right = 0
		local param.margin.bottom, newMargin = 0, param.margin
	end
	local totalHeight = 0
	local button = ccui.Button:create()
	button.isLayout = true
	button:setName(param.name or "Button")
	button:setTouchEnabled(true)
	button:loadTextures(param.normalImgName or "btn_BXanniu_yellow.png", param.selectImgName or "", param.selectImgName or "", ccui.TextureResType.plistType)
	button:setScale9Enabled(true)
	button:setContentSize(param.buttonSize or cc.size(169, 57))
	button:setPressedActionEnabled(true)
	button:setSwallowTouches(false)
	button:setTitleText(param.titleText or "")
	button:setTitleColor(param.color or cc.c3b(255, 251, 213))
	button:setTitleFontSize(param.fontSize or 22)
	button:addTouchEventListener(param.handler)
	SoraDAutoSizeButtonText(button, param.buttonSize or cc.size(169, 57))
	if param.imageIcon then
		local sprite = display.newSprite("#" .. param.imageIcon)
		button:addChild(sprite, 1)
		sprite:setScale(0.6)
		sprite:setPosition(cc.p(25, button:getContentSize().height / 2))
	end
	local lp3 = ccui.LinearLayoutParameter:create()
	button:setLayoutParameter(lp3)
	lp3:setGravity(ccui.LinearGravity.centerHorizontal)
	lp3:setMargin(newMargin)
	totalHeight = button:getContentSize().height + newMargin.top + newMargin.bottom
	return button, totalHeight
end
function mailNodeFactory:createLayoutRewardItemHead(titleStr)
	local layout_head = ccui.Layout:create()
	layout_head:setCascadeOpacityEnabled(true)
	layout_head:setContentSize(cc.size(gMailDetaiViewWidth, 60))
	local height = 0
	_ENV = cc.size(gMailDetaiViewWidth, 60)
	cc.size(gMailDetaiViewWidth, 60).fontSize = 22
	cc.size(gMailDetaiViewWidth, 60).color = cc.c3b(68, 35, 17)
	cc.size(gMailDetaiViewWidth, 60).AlignH = cc.TEXT_ALIGNMENT_CENTER
	cc.size(gMailDetaiViewWidth, 60).point = cc.p(0.5, 0.5)
	cc.size(gMailDetaiViewWidth, 60).pos = cc.p(gMailDetaiViewWidth / 2, 30)
	cc.size(gMailDetaiViewWidth, 60).str = i18n(titleStr or "common_text_094")
	cc.size(gMailDetaiViewWidth, 60).textWidth = 200
	local text_title, autoHeight = self:createTextLayout(cc.size(gMailDetaiViewWidth, 60))
	layout_head:addChild(text_title)
	height = height + autoHeight
	local text_line = ccui.ImageView:create()
	text_line:setAnchorPoint(cc.p(0.5, 0.5))
	text_line:setPosition(cc.p(gMailDetaiViewWidth / 2 - 150, 30))
	text_line:loadTexture("frame_kfqc_line_01.png", ccui.TextureResType.plistType)
	local other_text_line = text_line:clone()
	other_text_line:setPosition(cc.p(gMailDetaiViewWidth / 2 + 150, 30))
	other_text_line:setFlippedX(true)
	layout_head:addChild(other_text_line)
	layout_head:addChild(text_line)
	return layout_head, 60
end
function mailNodeFactory:creatRewardCustomNode(itemList, lineNum, align)
	if not itemList or not next(itemList) then
		return
	end
	local totalHeight = 100 * math.ceil(#itemList / lineNum)
	local customNode = ccui.Layout:create()
	customNode:setCascadeOpacityEnabled(true)
	customNode:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight))
	local rewardNode = display.newNode()
	rewardNode:setCascadeOpacityEnabled(true)
	rewardNode:addTo(customNode)
	rewardNode:setPosition(gMailDetaiViewWidth / 2, customNode:getContentSize().height / 2)
	for i, itemInfo in ipairs(itemList) do
		local itemNode = include("mailRewardItem"):new()
		itemNode:initWithData(itemInfo)
		itemNode:addTo(rewardNode)
	end
	SoraDautoSortPos(rewardNode, lineNum, align or 1, cc.size(100, 100), SoraDFIsRA())
	return customNode, totalHeight
end
function mailNodeFactory:createRewardList(itemList)
	local layout = ccui.VBox:create()
	layout:setCascadeOpacityEnabled(true)
	local height = #itemList * 100
	layout:setContentSize(gMailDetaiViewWidth, height)
	for i, v in ipairs(itemList) do
		local item = include("mailRewardItemWithNameNum").new()
		item:addTo(layout)
		v.hideLine = i == #itemList
		item:initWithData(v)
	end
	return layout, height
end
function mailNodeFactory:createResList(itemList, isDefense)
	if itemList == nil or #itemList == 0 then
		return false
	end
	local vLayout = ccui.VBox:create()
	vLayout:setCascadeOpacityEnabled(true)
	local totalWidth = gMailDetaiViewWidth
	local totalHeight = 0
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	include("mailFunctions"):sortResItems(itemList)
	for i = 1, #itemList do
		local item = itemList[i]
		if isDefense and item.num and 0 < item.num and item.id ~= gIDDef.MILITARY_POINT and item.id ~= gIDDef.MILITARY_EXPLOIT then
			item.num = -1 * item.num
		end
		if item.id ~= gIDDef.METEOR_CRYSTAL or SoraDIsBrave8Level() then
			local resRewardItem = include("mailResRewardItem").new()
			resRewardItem:initData(item)
			totalHeight = totalHeight + resRewardItem:getContentSize().height
			vLayout:addChild(resRewardItem)
		end
	end
	vLayout:setContentSize(cc.size(totalWidth, totalHeight))
	return vLayout, totalHeight
end
function mailNodeFactory:createNameWithNum(item)
	local textColorName = item.textColorName or cc.c3b(96, 73, 44)
	local textColorNum = item.textColorNum or cc.c3b(115, 41, 41)
	local strName = item.strName
	local strNum = item.strNum
	local width = item.width or gMailDetaiViewWidth / 2
	local height = item.height or 35
	local hLayout = ccui.HBox:create()
	hLayout:setCascadeOpacityEnabled(true)
	local labelName = ccui.Text:create()
	labelName:setFontSize(18)
	labelName:setColor(textColorName)
	labelName:setString(strName)
	labelName:setTextHorizontalAlignment(SoraDFLabelR())
	labelName:setAnchorPoint(SoraDFAP(1, 0.5))
	local autoHeight = SoraDGetAutoHeightLabel(labelName, width / 2)
	if height < autoHeight then
		height = autoHeight + 10
	end
	hLayout:addChild(labelName)
	local lp1 = ccui.LayoutParameter:create()
	labelName:setLayoutParameter(lp1)
	labelName:setPosition(SoraDFPoint(width - 40, height / 2, width))
	local labelNum = ccui.Text:create()
	labelNum:setFontSize(18)
	labelNum:setColor(textColorNum)
	labelNum:setString(strNum)
	labelNum:setTextHorizontalAlignment(item.strNumAlign or SoraDFLabelL())
	labelNum:setAnchorPoint(SoraDFAP(0, 0.5))
	local autoHeight = SoraDGetAutoHeightLabel(labelNum, width / 2)
	if height < autoHeight then
		height = autoHeight + 10
	end
	hLayout:addChild(labelNum)
	local lp2 = ccui.LayoutParameter:create()
	labelNum:setLayoutParameter(lp2)
	labelNum:setPosition(SoraDFPoint(40, height / 2, width))
	hLayout:setContentSize(cc.size(width, height))
	return hLayout
end
function mailNodeFactory:createTextWithBg(param)
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	local textDes, height = self:createTextLayout(param)
	vLayout:addChild(textDes)
	local totalHeight = math.max(52, height + 30)
	_ENV = nil
	;(nil).imgName = "frame_yjyh_dk_01.png"
	;(nil).imagWidth = gMailDetaiViewWidth - 28
	;(nil).scale9 = true
	;(nil).imagHeight = totalHeight
	local imgBG, _ = mailNodeFactory:createImgViewLayout(nil)
	imgBG:setCapInsets(cc.rect(27, 27, 20, 28))
	textDes:setPositionY((totalHeight - height) / 2)
	vLayout:setContentSize(gMailDetaiViewWidth, totalHeight)
	vLayout:addChild(imgBG)
	local lp1 = ccui.LinearLayoutParameter:create()
	vLayout:setLayoutParameter(lp1)
	lp1:setGravity(ccui.LinearGravity.centerHorizontal)
	return vLayout, totalHeight
end
function mailNodeFactory:createPlayerInfo(uinfo, isCommonData)
	local playerInfoNode = include("mailItemDetailPlayerInfo").new()
	if not isCommonData then
		playerInfoNode:initWithData(uinfo)
	else
		playerInfoNode:initWithCommonData(uinfo)
	end
	local frameBoxResInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = nil
	_ENV, (nil).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isHideTop = true
	;(nil).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, playerInfoNode
	frameBoxResInfoNode:initWithData(nil)
	return frameBoxResInfoNode, frameBoxResInfoNode:getItemHeight()
end
function mailNodeFactory:getArmyItem(item, spName)
	dump(item, "getArmyItem")
	local widthLayout = gMailDetaiViewWidth
	local hLayout = ccui.Layout:create()
	hLayout:setCascadeOpacityEnabled(true)
	local armyInfoBox = include("mailArmySingle").new()
	armyInfoBox:initData(item)
	armyInfoBox:addTo(hLayout)
	armyInfoBox:setPosition(0, 0)
	if spName then
		armyInfoBox:setLineImage(spName)
	end
	hLayout:setContentSize(cc.size(widthLayout, 95))
	return hLayout
end
function mailNodeFactory:createTroopHead(titleStr)
	local layout_head = ccui.Layout:create()
	local width = gMailDetaiViewWidth
	layout_head:setContentSize(cc.size(width, 55))
	local height = 0
	local text_line = ccui.ImageView:create()
	text_line:setAnchorPoint(cc.p(1, 0.5))
	text_line:setPosition(cc.p(width / 2, 30))
	text_line:loadTexture("frame_yjyh_zdtc_dj.png", ccui.TextureResType.plistType)
	text_line:ignoreContentAdaptWithSize(false)
	text_line:setContentSize(cc.size((gMailDetaiViewWidth - 28) / 2, 50))
	local other_text_line = text_line:clone()
	other_text_line:setPosition(cc.p(width / 2, 30))
	other_text_line:setFlippedX(true)
	layout_head:addChild(other_text_line)
	layout_head:addChild(text_line)
	_ENV = text_line
	text_line.fontSize = 22
	text_line.color = cc.c3b(68, 35, 17)
	text_line.AlignH = cc.TEXT_ALIGNMENT_CENTER
	text_line.point = cc.p(0.5, 0.5)
	text_line.pos = cc.p(width / 2, 30)
	text_line.str = i18n(titleStr or "common_text_120")
	text_line.textWidth = 200
	local text_title, autoHeight = self:createTextLayout(text_line)
	layout_head:addChild(text_title)
	height = height + autoHeight
	return layout_head, 55
end
function mailNodeFactory:createResTitleHead(str1, str2, str3)
	local layout_head = ccui.Layout:create()
	layout_head:setCascadeOpacityEnabled(true)
	layout_head:setContentSize(gMailDetaiViewWidth, 40)
	local line = display.newScale9Sprite("#frame_yjyh_line_02.png", gMailDetaiViewWidth / 2, 0, cc.size(563, 6), cc.rect(146, 0, 159, 6))
	line:addTo(layout_head)
	line:setPosition(gMailDetaiViewWidth / 2, 0)
	local label1 = ccui.Text:create()
	label1:setFontSize(20)
	label1:setColor(cc.c3b(105, 56, 21))
	label1:setString(str1)
	label1:setTextHorizontalAlignment(SoraDFLabelR())
	label1:setAnchorPoint(SoraDFAP(1, 0.5))
	label1:setPosition(SoraDFPosX(120, gMailDetaiViewWidth), 15)
	label1:addTo(layout_head)
	local label2 = ccui.Text:create()
	label2:setFontSize(20)
	label2:setColor(cc.c3b(105, 56, 21))
	label2:setString(str2)
	label2:setAnchorPoint(SoraDFAP(0.5, 0.5))
	label2:setPosition(SoraDFPosX(gMailDetaiViewWidth / 2, gMailDetaiViewWidth), 15)
	label2:addTo(layout_head)
	local label3 = ccui.Text:create()
	label3:setFontSize(20)
	label3:setColor(cc.c3b(105, 56, 21))
	label3:setString(str3)
	label3:setTextHorizontalAlignment(SoraDFLabelL())
	label3:setAnchorPoint(SoraDFAP(0, 0.5))
	label3:setPosition(SoraDFPosX(gMailDetaiViewWidth - 120, gMailDetaiViewWidth), 15)
	label3:addTo(layout_head)
	return layout_head, 40
end
function mailNodeFactory:createResLayout(items)
	local vLayout = ccui.VBox:create()
	vLayout:setCascadeOpacityEnabled(true)
	local headLayout, autoHeight = mailNodeFactory:createResTitleHead(i18n("common_text_103"), i18n("common_text_102"), i18n("common_text_123"))
	headLayout:addTo(vLayout)
	local totalWidth = gMailDetaiViewWidth
	local totalHeight = autoHeight
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	include("mailFunctions"):sortResItems(items)
	for i = 1, #items do
		local item = items[i]
		if item.id ~= gIDDef.METEOR_CRYSTAL or SoraDIsBrave8Level() then
			local resRewardItem = include("mailResRewardItem").new()
			resRewardItem:initData(item)
			totalHeight = totalHeight + resRewardItem:getContentSize().height
			vLayout:addChild(resRewardItem)
		end
	end
	vLayout:setContentSize(cc.size(totalWidth, totalHeight))
	local frameBoxResInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = cc.size(totalWidth, totalHeight)
	_ENV, cc.size(totalWidth, totalHeight).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isHideTop = true
	cc.size(totalWidth, totalHeight).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, vLayout
	frameBoxResInfoNode:initWithData(cc.size(totalWidth, totalHeight))
	return frameBoxResInfoNode, frameBoxResInfoNode:getItemHeight()
end
function mailNodeFactory:createCityDefence(item)
	item.width = gMailDetaiViewWidth
	item.height = 52
	local hBox, autoHeight = self:createNameWithNum(item)
	local frameBoxResInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = nil
	_ENV, (nil).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isHideTop = true
	;(nil).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, hBox
	frameBoxResInfoNode:initWithData(nil)
	return frameBoxResInfoNode, frameBoxResInfoNode:getItemHeight()
end
function mailNodeFactory:createHeroInfoLayout(info, bgType)
	local bgType = bgType or 1
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	local heroBanner = include("mailItemDetailHeroBanner").new()
	heroBanner:initData(info)
	heroBanner:addTo(vLayout)
	heroBanner:setPosition(0, 0)
	vLayout:setContentSize(heroBanner:getItemWidth(), heroBanner:getItemHeight())
	if bgType == 1 then
		local frameBoxResInfoNode = include("mailItemDetailFrameBox").new()
		_ENV = heroBanner:getItemHeight()
		_ENV, heroBanner:getItemHeight().dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
		include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isHideTop = true
		heroBanner:getItemHeight().dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, vLayout
		frameBoxResInfoNode:initWithData(heroBanner:getItemHeight())
		return frameBoxResInfoNode, frameBoxResInfoNode:getItemHeight()
	else
		return vLayout, vLayout:getContentSize().height
	end
end
function mailNodeFactory:createDefenceArmyLayout(armyInfo, needCollapse)
	local vLayout = ccui.VBox:create()
	vLayout:setCascadeOpacityEnabled(true)
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	local totalHeight = 0
	for index, item in ipairs(armyInfo) do
		local hLayout = self:getArmyItem(item, "frame_yjyh_line_02.png")
		if index == #armyInfo then
			SoraDGetChildByName(hLayout, "Image_line"):setVisible(false)
		end
		totalHeight = totalHeight + hLayout:getContentSize().height
		vLayout:addChild(hLayout)
	end
	_ENV = (for generator)
	ipairs(armyInfo).isHideTop = true
	local ipairs(armyInfo).customNode, dataContent = vLayout, ipairs(armyInfo)
	if needCollapse and 380 <= totalHeight then
		dataContent.collapseOffsetY = 285
		dataContent.isEnableCollapse = true
		dataContent.collageLocalKey = "Game:GameSettingView:mailScoutArmyCollapse~bool"
	end
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight))
	local frameBoxResInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = cc.size(gMailDetaiViewWidth, totalHeight)
	cc.size(gMailDetaiViewWidth, totalHeight).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	cc.size(gMailDetaiViewWidth, totalHeight).dataContent = dataContent
	frameBoxResInfoNode:initWithData(cc.size(gMailDetaiViewWidth, totalHeight))
	return frameBoxResInfoNode, frameBoxResInfoNode:getItemHeight()
end
function mailNodeFactory:createTrapLayout(trapsInfo)
	local vLayout = ccui.VBox:create()
	vLayout:setCascadeOpacityEnabled(true)
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	local totalHeight = 0
	for index, item in ipairs(trapsInfo) do
		_ENV = nil
		;(nil).strName = include("armyDesRead").getName(item.id)
		;(nil).strNum = string.formatnumberthousands(item.num)
		;(nil).width = gMailDetaiViewWidth
		local hLayout = self:createNameWithNum(nil)
		totalHeight = totalHeight + hLayout:getContentSize().height
		vLayout:addChild(hLayout)
	end
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight))
	local frameBoxResInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = cc.size(gMailDetaiViewWidth, totalHeight)
	_ENV, cc.size(gMailDetaiViewWidth, totalHeight).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isHideTop = true
	cc.size(gMailDetaiViewWidth, totalHeight).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, vLayout
	frameBoxResInfoNode:initWithData(cc.size(gMailDetaiViewWidth, totalHeight))
	return frameBoxResInfoNode, frameBoxResInfoNode:getItemHeight()
end
function mailNodeFactory:createTowerLayout(towersInfo)
	local towerInfoNode = include("mailItemDetailTowerInfo").new()
	towerInfoNode:setSwallowTouches(false)
	towerInfoNode:initWithData(towersInfo)
	local frameBoxResInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = nil
	_ENV, (nil).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isHideTop = true
	;(nil).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, towerInfoNode
	frameBoxResInfoNode:initWithData(nil)
	return frameBoxResInfoNode, frameBoxResInfoNode:getItemHeight()
end
function mailNodeFactory:createAcademySkillLayout(items)
	local vLayout = ccui.VBox:create()
	vLayout:setCascadeOpacityEnabled(true)
	local totalWidth = gMailDetaiViewWidth
	local totalHeight = 0
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	for i = 1, #items, 2 do
		local hLayoutContent = ccui.HBox:create()
		hLayoutContent:setCascadeOpacityEnabled(true)
		_UPVALUE2_ = hLayoutContent
		hLayoutContent[1] = items[i]
		hLayoutContent[2] = items[i + 1]
		for j, v in ipairs(hLayoutContent) do
			if v ~= nil then
				_ENV = nil
				;(nil).strName = include("collegeDesRead").getName(v.id)
				_ENV = nil
				;(nil).lv = v.lv
				local (nil).strNum, strInfo = i18n("common_text_101", nil), nil
				local hLayout1 = self:createNameWithNum(strInfo)
				hLayout1:setContentSize(cc.size(gMailDetaiViewWidth / 2, 35))
				hLayoutContent:addChild(hLayout1)
			end
			hLayoutContent:setContentSize(cc.size(gMailDetaiViewWidth, 35))
		end
		totalHeight = totalHeight + hLayoutContent:getContentSize().height
		vLayout:addChild(hLayoutContent)
	end
	vLayout:setContentSize(cc.size(totalWidth, totalHeight))
	local frameBoxResInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = cc.size(totalWidth, totalHeight)
	_ENV, cc.size(totalWidth, totalHeight).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isHideTop = true
	cc.size(totalWidth, totalHeight).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, vLayout
	frameBoxResInfoNode:initWithData(cc.size(totalWidth, totalHeight))
	return frameBoxResInfoNode, frameBoxResInfoNode:getItemHeight()
end
function mailNodeFactory:createLordSkillLayout(items)
	local vLayout = ccui.VBox:create()
	vLayout:setCascadeOpacityEnabled(true)
	local totalWidth = gMailDetaiViewWidth
	local totalHeight = 0
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	for i = 1, #items, 2 do
		local hLayoutContent = ccui.HBox:create()
		hLayoutContent:setCascadeOpacityEnabled(true)
		_UPVALUE2_ = hLayoutContent
		hLayoutContent[1] = items[i]
		hLayoutContent[2] = items[i + 1]
		for j, v in ipairs(hLayoutContent) do
			if v ~= nil then
				_ENV = nil
				;(nil).strName = include("lordSkillDesRead").getName(v.id)
				_ENV = nil
				;(nil).lv = v.lv
				local (nil).strNum, strInfo = i18n("common_text_101", nil), nil
				local hLayout1 = self:createNameWithNum(strInfo)
				hLayout1:setContentSize(cc.size(gMailDetaiViewWidth / 2, 35))
				hLayoutContent:addChild(hLayout1)
			end
			hLayoutContent:setContentSize(cc.size(gMailDetaiViewWidth, 35))
		end
		totalHeight = totalHeight + hLayoutContent:getContentSize().height
		vLayout:addChild(hLayoutContent)
	end
	vLayout:setContentSize(cc.size(totalWidth, totalHeight))
	local frameBoxResInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = cc.size(totalWidth, totalHeight)
	_ENV, cc.size(totalWidth, totalHeight).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isHideTop = true
	cc.size(totalWidth, totalHeight).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, vLayout
	frameBoxResInfoNode:initWithData(cc.size(totalWidth, totalHeight))
	return frameBoxResInfoNode, frameBoxResInfoNode:getItemHeight()
end
function mailNodeFactory:createFightBriefLayout(itemList)
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	local totalHeight = 0
	for i, v in ipairs(itemList) do
		local hLayout = self:createFightBriefItem(v, i)
		totalHeight = totalHeight + hLayout:getContentSize().height
		vLayout:addChild(hLayout)
	end
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight))
	local frameBoxResInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = cc.size(gMailDetaiViewWidth, totalHeight)
	_ENV, cc.size(gMailDetaiViewWidth, totalHeight).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.textShowTitle = i18n("mail_2_text_19")
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isShowFightColor = true
	cc.size(gMailDetaiViewWidth, totalHeight).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, vLayout
	frameBoxResInfoNode:initWithData(cc.size(gMailDetaiViewWidth, totalHeight))
	return frameBoxResInfoNode, frameBoxResInfoNode:getItemHeight()
end
function mailNodeFactory:createFightBriefItem(item, index)
	local textColorName = item.textColorName or cc.c3b(102, 50, 12)
	local defenceColor = item.defenceColor or item.color or cc.c3b(102, 50, 12)
	local attackColor = item.attackColor or item.color or cc.c3b(102, 50, 12)
	local strName = item.strName
	local attackNum = item.attackNum
	local defenceNum = item.defenceNum
	local defaultStr = item.defaultStr or "--"
	local attackCompareResult = item.attackCompareResult
	local defenceCompareResult = item.defenceCompareResult
	local width = gMailDetaiViewWidth
	local height = 35
	local fontSize = 20
	local hLayout = ccui.HBox:create()
	hLayout:setCascadeOpacityEnabled(true)
	local labelName = ccui.Text:create()
	labelName:setFontSize(fontSize)
	labelName:setColor(textColorName)
	labelName:setTextHorizontalAlignment(SoraDFLabelR())
	labelName:setTextVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	local labelName2 = labelName:clone()
	labelName:setString(strName)
	labelName:setAnchorPoint(SoraDFAP(1, 0.5))
	local autoHeight = SoraDGetAutoHeightLabel(labelName, 190)
	if height < autoHeight then
		height = autoHeight + 10
	end
	hLayout:addChild(labelName)
	local lp1 = ccui.LayoutParameter:create()
	labelName:setLayoutParameter(lp1)
	labelName2:setString(strName)
	labelName2:setAnchorPoint(SoraDFAP(1, 0.5))
	local autoHeight = SoraDGetAutoHeightLabel(labelName2, 190)
	if height < autoHeight then
		height = autoHeight + 10
	end
	hLayout:addChild(labelName2)
	local lp1 = ccui.LayoutParameter:create()
	labelName2:setLayoutParameter(lp1)
	if defenceCompareResult then
		local arrow = display.newSprite(defenceCompareResult == 1 and "#frame_YX_juejiup.png" or "#frame_YX_juejidown.png")
		if defenceCompareResult == 0 then
			arrow:setGrayed(true)
			arrow:setRotation(-90)
		end
		arrow:setContentSize(cc.size(13, 14))
		arrow:setPositionY(15)
		hLayout:addChild(arrow)
		arrow:setPosition(SoraDFPoint(width / 2 - 210, height / 2, width))
	end
	local defenceLabel = ccui.Text:create()
	defenceLabel:setFontSize(fontSize)
	defenceLabel:setColor(defenceColor)
	defenceLabel:setString(defenceNum or defaultStr)
	defenceLabel:setTextHorizontalAlignment(SoraDFLabelR())
	defenceLabel:setTextVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	defenceLabel:setAnchorPoint(SoraDFAP(1, 0.5))
	hLayout:addChild(defenceLabel)
	local lp2 = ccui.LayoutParameter:create()
	defenceLabel:setLayoutParameter(lp2)
	local autoHeight = SoraDSetTextWidthHeight(defenceLabel, cc.size(75, 35))
	if attackCompareResult then
		local arrow = display.newSprite(attackCompareResult == 1 and "#frame_YX_juejiup.png" or "#frame_YX_juejidown.png")
		if attackCompareResult == 0 then
			arrow:setGrayed(true)
			arrow:setRotation(-90)
		end
		arrow:setContentSize(cc.size(13, 14))
		arrow:setPositionY(15)
		hLayout:addChild(arrow)
		arrow:setPosition(SoraDFPoint(width - 230, height / 2, width))
	end
	local attackLabel = defenceLabel:clone()
	attackLabel:addTo(hLayout)
	attackLabel:setTextHorizontalAlignment(SoraDFLabelR())
	attackLabel:setAnchorPoint(SoraDFAP(1, 0.5))
	local lp2 = ccui.LayoutParameter:create()
	attackLabel:setLayoutParameter(lp2)
	attackLabel:setString(attackNum or defaultStr)
	local autoHeight = SoraDSetTextWidthHeight(attackLabel, cc.size(75, 35))
	attackLabel:setColor(attackColor)
	labelName:setPosition(SoraDFPoint(width / 2 - 5, height / 2, width / 2 + 30))
	labelName2:setPosition(SoraDFPoint(width - 35, height / 2, width + width / 2 - 30))
	defenceLabel:setPosition(SoraDFPoint(width / 2 - 220, height / 2, width))
	attackLabel:setPosition(SoraDFPoint(width - 245, height / 2, width))
	local img_Sheer
	if index and index % 2 == 0 then
		img_Sheer = ccui.ImageView:create()
		img_Sheer:loadTexture("frame_sheer_black_01.png", ccui.TextureResType.plistType)
		img_Sheer:setContentSize(cc.size(617, height))
		img_Sheer:setOpacity(25.5)
		img_Sheer:setAnchorPoint(cc.p(0.5, 0.5))
		img_Sheer:ignoreContentAdaptWithSize(false)
		img_Sheer:addTo(hLayout)
		local lp2 = ccui.LayoutParameter:create()
		img_Sheer:setLayoutParameter(lp2)
		img_Sheer:setPosition(cc.p(width / 2, height / 2))
	end
	hLayout:setContentSize(cc.size(width, height))
	return hLayout
end
function mailNodeFactory:createFightTextSingle(str)
	local vLayout = ccui.HBox:create()
	vLayout:setCascadeOpacityEnabled(true)
	local totalHeight = 0
	local textPointImg = ccui.ImageView:create()
	textPointImg:setAnchorPoint(cc.p(0.5, 1))
	textPointImg:loadTexture("frame_cz_sign_02.png", ccui.TextureResType.plistType)
	textPointImg:addTo(vLayout)
	textPointImg:setOpacity(153.0)
	textPointImg:setColor(cc.c3b(112, 98, 77))
	local lp1 = ccui.LayoutParameter:create()
	textPointImg:setLayoutParameter(lp1)
	_ENV = lp1
	lp1.color = cc.c3b(255, 255, 255)
	lp1.str = str
	lp1.fontSize = 20
	lp1.AlignH = SoraDFLabelR()
	lp1.autoHeight = true
	lp1.isHtml = true
	lp1.pos = SoraDFPoint(580, 0)
	lp1.point = SoraDFPoint(1, 1, 1)
	local label, autoHeight = include("mailNodeFactory"):createTextLayout(lp1)
	label:addTo(vLayout)
	label:setLayoutParameter(lp1)
	totalHeight = totalHeight + autoHeight
	label:setPositionY(autoHeight)
	textPointImg:setPosition(SoraDFPoint(600, autoHeight - 10))
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight))
	return vLayout, totalHeight
end
_UPVALUE9_, mailNodeFactory.createFightEndTextList = function(self, strList, strTtle, height)
	local scroll = ccui.ScrollView:create()
	scroll:setBounceEnabled(true)
	scroll:setDirection(1)
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	local totalHeight = 0
	for _, str in ipairs(strList) do
		local single, autoHeight = self:createFightTextSingle(str)
		single:addTo(vLayout)
		totalHeight = totalHeight + autoHeight
	end
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	scroll:setInnerContainerSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	scroll:addChild(vLayout)
	vLayout:setPosition(cc.p(0, 0))
	scroll:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = cc.size(gMailDetaiViewWidth, totalHeight + 10)
	_ENV, cc.size(gMailDetaiViewWidth, totalHeight + 10).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.textShowTitle = strTtle
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
	cc.size(gMailDetaiViewWidth, totalHeight + 10).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, scroll
	frameBoxInfoNode:initWithData(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	return frameBoxInfoNode
end, function(self, strList, strTtle, height)
	local scroll = ccui.ScrollView:create()
	scroll:setBounceEnabled(true)
	scroll:setDirection(1)
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	local totalHeight = 0
	for _, str in ipairs(strList) do
		local single, autoHeight = self:createFightTextSingle(str)
		single:addTo(vLayout)
		totalHeight = totalHeight + autoHeight
	end
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	scroll:setInnerContainerSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	scroll:addChild(vLayout)
	vLayout:setPosition(cc.p(0, 0))
	scroll:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = cc.size(gMailDetaiViewWidth, totalHeight + 10)
	_ENV, cc.size(gMailDetaiViewWidth, totalHeight + 10).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.textShowTitle = strTtle
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
	cc.size(gMailDetaiViewWidth, totalHeight + 10).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, scroll
	frameBoxInfoNode:initWithData(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	return frameBoxInfoNode
end
_UPVALUE5_, (function(self, strList, strTtle, height)
	local scroll = ccui.ScrollView:create()
	scroll:setBounceEnabled(true)
	scroll:setDirection(1)
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	local totalHeight = 0
	for _, str in ipairs(strList) do
		local single, autoHeight = self:createFightTextSingle(str)
		single:addTo(vLayout)
		totalHeight = totalHeight + autoHeight
	end
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	scroll:setInnerContainerSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	scroll:addChild(vLayout)
	vLayout:setPosition(cc.p(0, 0))
	scroll:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = cc.size(gMailDetaiViewWidth, totalHeight + 10)
	_ENV, cc.size(gMailDetaiViewWidth, totalHeight + 10).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.textShowTitle = strTtle
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
	cc.size(gMailDetaiViewWidth, totalHeight + 10).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, scroll
	frameBoxInfoNode:initWithData(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	return frameBoxInfoNode
end)[1] = 101, 101
_UPVALUE5_, (function(self, strList, strTtle, height)
	local scroll = ccui.ScrollView:create()
	scroll:setBounceEnabled(true)
	scroll:setDirection(1)
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	local totalHeight = 0
	for _, str in ipairs(strList) do
		local single, autoHeight = self:createFightTextSingle(str)
		single:addTo(vLayout)
		totalHeight = totalHeight + autoHeight
	end
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	scroll:setInnerContainerSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	scroll:addChild(vLayout)
	vLayout:setPosition(cc.p(0, 0))
	scroll:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = cc.size(gMailDetaiViewWidth, totalHeight + 10)
	_ENV, cc.size(gMailDetaiViewWidth, totalHeight + 10).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.textShowTitle = strTtle
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
	cc.size(gMailDetaiViewWidth, totalHeight + 10).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, scroll
	frameBoxInfoNode:initWithData(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	return frameBoxInfoNode
end)[2] = 101, 102
_UPVALUE5_, (function(self, strList, strTtle, height)
	local scroll = ccui.ScrollView:create()
	scroll:setBounceEnabled(true)
	scroll:setDirection(1)
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	local totalHeight = 0
	for _, str in ipairs(strList) do
		local single, autoHeight = self:createFightTextSingle(str)
		single:addTo(vLayout)
		totalHeight = totalHeight + autoHeight
	end
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	scroll:setInnerContainerSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	scroll:addChild(vLayout)
	vLayout:setPosition(cc.p(0, 0))
	scroll:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = cc.size(gMailDetaiViewWidth, totalHeight + 10)
	_ENV, cc.size(gMailDetaiViewWidth, totalHeight + 10).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.textShowTitle = strTtle
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
	cc.size(gMailDetaiViewWidth, totalHeight + 10).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, scroll
	frameBoxInfoNode:initWithData(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	return frameBoxInfoNode
end)[3] = 101, 103
_UPVALUE5_, (function(self, strList, strTtle, height)
	local scroll = ccui.ScrollView:create()
	scroll:setBounceEnabled(true)
	scroll:setDirection(1)
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	local totalHeight = 0
	for _, str in ipairs(strList) do
		local single, autoHeight = self:createFightTextSingle(str)
		single:addTo(vLayout)
		totalHeight = totalHeight + autoHeight
	end
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	scroll:setInnerContainerSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	scroll:addChild(vLayout)
	vLayout:setPosition(cc.p(0, 0))
	scroll:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = cc.size(gMailDetaiViewWidth, totalHeight + 10)
	_ENV, cc.size(gMailDetaiViewWidth, totalHeight + 10).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.textShowTitle = strTtle
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
	cc.size(gMailDetaiViewWidth, totalHeight + 10).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, scroll
	frameBoxInfoNode:initWithData(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	return frameBoxInfoNode
end)[4] = 101, 301
_UPVALUE5_, (function(self, strList, strTtle, height)
	local scroll = ccui.ScrollView:create()
	scroll:setBounceEnabled(true)
	scroll:setDirection(1)
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	local totalHeight = 0
	for _, str in ipairs(strList) do
		local single, autoHeight = self:createFightTextSingle(str)
		single:addTo(vLayout)
		totalHeight = totalHeight + autoHeight
	end
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	scroll:setInnerContainerSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	scroll:addChild(vLayout)
	vLayout:setPosition(cc.p(0, 0))
	scroll:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = cc.size(gMailDetaiViewWidth, totalHeight + 10)
	_ENV, cc.size(gMailDetaiViewWidth, totalHeight + 10).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.textShowTitle = strTtle
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
	cc.size(gMailDetaiViewWidth, totalHeight + 10).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, scroll
	frameBoxInfoNode:initWithData(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	return frameBoxInfoNode
end)[5] = 101, 302
_UPVALUE5_, (function(self, strList, strTtle, height)
	local scroll = ccui.ScrollView:create()
	scroll:setBounceEnabled(true)
	scroll:setDirection(1)
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	local totalHeight = 0
	for _, str in ipairs(strList) do
		local single, autoHeight = self:createFightTextSingle(str)
		single:addTo(vLayout)
		totalHeight = totalHeight + autoHeight
	end
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	scroll:setInnerContainerSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	scroll:addChild(vLayout)
	vLayout:setPosition(cc.p(0, 0))
	scroll:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = cc.size(gMailDetaiViewWidth, totalHeight + 10)
	_ENV, cc.size(gMailDetaiViewWidth, totalHeight + 10).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.textShowTitle = strTtle
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
	cc.size(gMailDetaiViewWidth, totalHeight + 10).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, scroll
	frameBoxInfoNode:initWithData(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	return frameBoxInfoNode
end)[6] = 101, 303
_UPVALUE5_, (function(self, strList, strTtle, height)
	local scroll = ccui.ScrollView:create()
	scroll:setBounceEnabled(true)
	scroll:setDirection(1)
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	local totalHeight = 0
	for _, str in ipairs(strList) do
		local single, autoHeight = self:createFightTextSingle(str)
		single:addTo(vLayout)
		totalHeight = totalHeight + autoHeight
	end
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	scroll:setInnerContainerSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	scroll:addChild(vLayout)
	vLayout:setPosition(cc.p(0, 0))
	scroll:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = cc.size(gMailDetaiViewWidth, totalHeight + 10)
	_ENV, cc.size(gMailDetaiViewWidth, totalHeight + 10).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.textShowTitle = strTtle
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
	cc.size(gMailDetaiViewWidth, totalHeight + 10).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, scroll
	frameBoxInfoNode:initWithData(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	return frameBoxInfoNode
end)[7] = 101, 201
_UPVALUE5_, (function(self, strList, strTtle, height)
	local scroll = ccui.ScrollView:create()
	scroll:setBounceEnabled(true)
	scroll:setDirection(1)
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	local totalHeight = 0
	for _, str in ipairs(strList) do
		local single, autoHeight = self:createFightTextSingle(str)
		single:addTo(vLayout)
		totalHeight = totalHeight + autoHeight
	end
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	scroll:setInnerContainerSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	scroll:addChild(vLayout)
	vLayout:setPosition(cc.p(0, 0))
	scroll:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = cc.size(gMailDetaiViewWidth, totalHeight + 10)
	_ENV, cc.size(gMailDetaiViewWidth, totalHeight + 10).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.textShowTitle = strTtle
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
	cc.size(gMailDetaiViewWidth, totalHeight + 10).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, scroll
	frameBoxInfoNode:initWithData(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	return frameBoxInfoNode
end)[8] = 101, 202
local _UPVALUE5_, (function(self, strList, strTtle, height)
	local scroll = ccui.ScrollView:create()
	scroll:setBounceEnabled(true)
	scroll:setDirection(1)
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	local totalHeight = 0
	for _, str in ipairs(strList) do
		local single, autoHeight = self:createFightTextSingle(str)
		single:addTo(vLayout)
		totalHeight = totalHeight + autoHeight
	end
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	scroll:setInnerContainerSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	scroll:addChild(vLayout)
	vLayout:setPosition(cc.p(0, 0))
	scroll:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = cc.size(gMailDetaiViewWidth, totalHeight + 10)
	_ENV, cc.size(gMailDetaiViewWidth, totalHeight + 10).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.textShowTitle = strTtle
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
	cc.size(gMailDetaiViewWidth, totalHeight + 10).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, scroll
	frameBoxInfoNode:initWithData(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	return frameBoxInfoNode
end)[9], markDesAttrs = 101, 203, function(self, strList, strTtle, height)
	local scroll = ccui.ScrollView:create()
	scroll:setBounceEnabled(true)
	scroll:setDirection(1)
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	local totalHeight = 0
	for _, str in ipairs(strList) do
		local single, autoHeight = self:createFightTextSingle(str)
		single:addTo(vLayout)
		totalHeight = totalHeight + autoHeight
	end
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	scroll:setInnerContainerSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	scroll:addChild(vLayout)
	vLayout:setPosition(cc.p(0, 0))
	scroll:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = cc.size(gMailDetaiViewWidth, totalHeight + 10)
	_ENV, cc.size(gMailDetaiViewWidth, totalHeight + 10).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.textShowTitle = strTtle
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
	cc.size(gMailDetaiViewWidth, totalHeight + 10).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, scroll
	frameBoxInfoNode:initWithData(cc.size(gMailDetaiViewWidth, totalHeight + 10))
	return frameBoxInfoNode
end
;(101)[1] = "common_text_143"
;(101)[2] = "common_text_144"
;(101)[3] = "common_text_145"
;(101)[4] = "common_text_146"
local (101)[5], armyClassName = "common_text_3772", 101
function mailNodeFactory:createFightPrepareTextList(strTtle, isActtack, isSelf, heros, arms, divineBeasts, dbMarks, shield, strTitle2, retreat, armyAttrInfo, pierceRatePlus, akdfhpDmgPlus, defPalacePierceRatePlus, intimidateInfo, akdfhpDmgReduce, buffDetail)
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	local heroWeaponCtrl = SoraDGetCtrl("heroWeaponCtrl")
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	local totalHeight = 0
	local belongDes = isSelf and i18n("battlelog_text_41") or i18n("battlelog_text_40")
	belongDes = belongDes .. (isActtack and i18n("battlelog_text_42") or i18n("battlelog_text_43"))
	_ENV = "battlelog_text_43"
	;("battlelog_text_43").color = isSelf and cc.c3b(0, 110, 0) or cc.c3b(210, 75, 1)
	;("battlelog_text_43").str = belongDes
	;("battlelog_text_43").fontSize = 20
	;("battlelog_text_43").AlignH = SoraDFLabelR()
	;("battlelog_text_43").autoHeight = true
	;("battlelog_text_43").point = SoraDFPoint(1, 1, 1)
	;("battlelog_text_43").linearLayoutType = ccui.LinearGravity.centerHorizontal
	;("battlelog_text_43").textWidth = 560
	local text_title, autoHeight = self:createTextLayout("battlelog_text_43")
	text_title:addTo(vLayout)
	totalHeight = totalHeight + autoHeight
	local isSelfColor = isSelf and "#006E00" or "#D24B01"
	local _ENV, strList = text_title, text_title
	local str = "battlelog_text_31"
	local heroNames = ""
	local _ENV, heroNameList = 1, 1
	local _ENV, heroSlaveList
	for _, v in ipairs(heros) do
		table.insert(heroNameList, i18n(heroltCtrl.getHeroName(v.heroID)))
		if v.slaveInfo and v.slaveInfo.heroID then
			table.insert(heroSlaveList, i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID)))
		end
	end
	if next(heroNameList) then
		heroNames = table.concat(heroNameList, ", ")
	else
		str = "battlelog_text_33"
	end
	_ENV = ", "
	;(", ").offsetX = 30
	_ENV = table.insert
	table.insert.var = strTtle
	_ENV, _ENV, table.insert.name = i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID))
	_ENV, heroSlaveList.var, i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID)).color = i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID))
	_ENV, heroSlaveList.name, i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID)).color = i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID))
	heroSlaveList.__default, i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID)).color = i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID))
	;(", ").str = i18n_html(str, table.insert, heroSlaveList)
	table.insert(strList, ", ")
	if defPalacePierceRatePlus then
		_ENV = ", "
		;(", ").offsetX = 30
		_ENV = table.insert
		_ENV, _ENV, table.insert.var = defPalacePierceRatePlus / 10, string.formatnumberthousands(defPalacePierceRatePlus / 10), string.formatnumberthousands(defPalacePierceRatePlus / 10)
		_ENV, string.formatnumberthousands(defPalacePierceRatePlus / 10).var, (defPalacePierceRatePlus / 10).color = defPalacePierceRatePlus / 10, defPalacePierceRatePlus / 10, "#006E00"
		string.formatnumberthousands(defPalacePierceRatePlus / 10).__default, (defPalacePierceRatePlus / 10).color = defPalacePierceRatePlus / 10, "#55230F"
		;(", ").str = i18n_html("mail_2_text_103", table.insert, string.formatnumberthousands(defPalacePierceRatePlus / 10), true)
		table.insert(strList, ", ")
	end
	if next(heroSlaveList) then
		local heroSlaveNames = table.concat(heroSlaveList, ", ")
		str = "battlelog_text_32"
		_ENV = i18n_html("mail_2_text_103", table.insert, string.formatnumberthousands(defPalacePierceRatePlus / 10), true)
		i18n_html("mail_2_text_103", table.insert, string.formatnumberthousands(defPalacePierceRatePlus / 10), true).offsetX = 30
		_ENV = string.formatnumberthousands(defPalacePierceRatePlus / 10)
		string.formatnumberthousands(defPalacePierceRatePlus / 10).var = strTtle
		_ENV, _ENV, string.formatnumberthousands(defPalacePierceRatePlus / 10).name = i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID))
		_ENV, (true).var, i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID)).color = i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID))
		_ENV, (true).name, i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID)).color = i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID))
		;(true).__default, i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID)).color = i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID))
		i18n_html("mail_2_text_103", table.insert, string.formatnumberthousands(defPalacePierceRatePlus / 10), true).str = i18n_html(str, string.formatnumberthousands(defPalacePierceRatePlus / 10), true)
		table.insert(strList, (i18n_html("mail_2_text_103", table.insert, string.formatnumberthousands(defPalacePierceRatePlus / 10), true)))
	end
	totalHeight = totalHeight + self:createNewFightReportDetail(i18n("common_name_01"), strList, true, vLayout)
	if next(arms) and arms[1] then
		strList, _ENV = arms[1], arms[1]
		local armsID = arms[1].armsID
		local level = arms[1].level
		local awakeStatus = arms[1].awakeStatus
		local armsName = include("equipDesRead").getArtifactName(arms[1].armsID)
		_ENV = string.formatnumberthousands(defPalacePierceRatePlus / 10)
		string.formatnumberthousands(defPalacePierceRatePlus / 10).offsetX = 30
		_ENV = i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID))
		i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID)).var = strTtle
		_ENV, _ENV, i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID)).name = i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID))
		_ENV, i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID)).var, i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID)).color = i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID))
		_ENV, i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID)).name, i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID)).color = i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID))
		i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID)).__default, i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID)).color = i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID))
		string.formatnumberthousands(defPalacePierceRatePlus / 10).str = i18n_html("battlelog_text_34", i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID)))
		table.insert(strList, (string.formatnumberthousands(defPalacePierceRatePlus / 10)))
		totalHeight = totalHeight + self:createNewFightReportDetail(i18n("artifact_title_01"), strList, true, vLayout)
	end
	if divineBeasts and next(divineBeasts) then
		strList, _ENV = next(divineBeasts), next(divineBeasts)
		local _ENV, divineName = next(divineBeasts), next(divineBeasts)
		for _, v in ipairs(divineBeasts) do
			local divineID = v.beastId
			local divineCfg = include("divineBeastRead").getDbCfg(divineID)
			table.insert(divineName, i18n(divineCfg.divineName))
		end
		_ENV = ipairs(divineBeasts)
		ipairs(divineBeasts).offsetX = 30
		_ENV = v.beastId
		v.beastId.var = strTtle
		_ENV, _ENV, v.beastId.name = divineName, table.concat(divineName, ", "), table.concat(divineName, ", ")
		_ENV, table.concat(divineName, ", ").var, divineName.color = divineName, divineName, isSelfColor
		_ENV, table.concat(divineName, ", ").name, divineName.color = divineName, divineName, "#006E00"
		table.concat(divineName, ", ").__default, divineName.color = divineName, "#55230F"
		ipairs(divineBeasts).str = i18n_html("battlelog_text_35", v.beastId, table.concat(divineName, ", "), true)
		table.insert(strList, ipairs(divineBeasts))
		if retreat and 0 < retreat then
			_ENV = ipairs(divineBeasts)
			ipairs(divineBeasts).offsetX = 30
			_ENV = v.beastId
			v.beastId.name = strTitle2
			_ENV, _ENV, v.beastId.num = retreat, string.formatnumberthousands(retreat), string.formatnumberthousands(retreat)
			_ENV, string.formatnumberthousands(retreat).name, retreat.color = retreat, retreat, isActtack and "#13508F" or "#A02828"
			_ENV, string.formatnumberthousands(retreat).num, retreat.color = retreat, retreat, "#006E00"
			string.formatnumberthousands(retreat).__default, retreat.color = retreat, "#55230F"
			ipairs(divineBeasts).str = i18n_html("battlelog_text_36", v.beastId, string.formatnumberthousands(retreat), true)
			table.insert(strList, ipairs(divineBeasts))
		end
		if pierceRatePlus then
			_ENV = ipairs(divineBeasts)
			ipairs(divineBeasts).offsetX = 30
			_ENV = v.beastId
			_ENV, _ENV, v.beastId.num = pierceRatePlus / 10, string.formatnumberthousands(pierceRatePlus / 10), string.formatnumberthousands(pierceRatePlus / 10)
			_ENV, string.formatnumberthousands(pierceRatePlus / 10).num, (pierceRatePlus / 10).color = pierceRatePlus / 10, pierceRatePlus / 10, "#006E00"
			string.formatnumberthousands(pierceRatePlus / 10).__default, (pierceRatePlus / 10).color = pierceRatePlus / 10, "#55230F"
			ipairs(divineBeasts).str = i18n_html("battlelog_text_56", v.beastId, string.formatnumberthousands(pierceRatePlus / 10), true)
			table.insert(strList, ipairs(divineBeasts))
		end
		local divineBeastMarkRead = include("divineBeastMarkRead")
		if dbMarks and next(dbMarks) then
			local markValue = 0
			for _, v in pairs(dbMarks) do
				for _, markStr in pairs(v) do
					local mark = divineBeastMarkRead.sSplitKey(markStr)
					if mark and mark.markCfg and mark.markCfg.type == 5023 then
						dump(mark.lvCfg, "mark.lvCfg")
						for _, v2 in pairs(mark.lvCfg.buff) do
							if v2.buffType == 857 then
								markValue = markValue + v2.value / 10000
							end
						end
					end
				end
			end
			print(markValue, "mark.lvCfg.buff.value")
			if 0 < markValue then
				local _ENV, buffList = print, print
				for _, v in ipairs(markDesAttrs) do
					buffList[v] = 0
				end
				for _, v in ipairs(armyAttrInfo) do
					if v.targetId and v.attrType then
						local key = v.targetId * 100 + v.attrType
						if buffList[key] ~= nil then
							buffList[key] = v.num
						end
						_UPVALUE3_ = i18n(divineCfg.divineName)
						i18n(divineCfg.divineName)[1] = buffList[key]
						i18n(divineCfg.divineName)[2] = key
						i18n(divineCfg.divineName)[3] = v.num
						dump(i18n(divineCfg.divineName))
					end
				end
				local _ENV, valueStr = (for generator), ipairs(armyAttrInfo)
				local _ENV, colorStr = ipairs(armyAttrInfo)
				for i = 1, #markDesAttrs do
					valueStr["num" .. i] = math.floor(buffList[markDesAttrs[i]] * markValue)
					_ENV = i
					colorStr["num" .. i], i.color = i, "#006E00"
				end
				dump(valueStr, "valueStr")
				_ENV = dump
				colorStr.__default, dump.color = dump, "#55230F"
				_ENV = "valueStr"
				;("valueStr").offsetX = 30
				;("valueStr").str = i18n_html("Divine_beast_mark_text_108", valueStr, colorStr, true)
				table.insert(strList, "valueStr")
			end
		end
		if akdfhpDmgPlus and next(akdfhpDmgPlus) then
			_ENV, _ENV = akdfhpDmgPlus, next(akdfhpDmgPlus)
			_ENV, next(akdfhpDmgPlus).num, akdfhpDmgPlus.color = akdfhpDmgPlus, akdfhpDmgPlus, "#006E00"
			next(akdfhpDmgPlus).__default, akdfhpDmgPlus.color = akdfhpDmgPlus, "#55230F"
			local colorStr = next(akdfhpDmgPlus)
			for i = 1, #armyClassName do
				local armyType = i
				local value = akdfhpDmgPlus[tostring(armyType)]
				if value and 0 < value then
					local armyName = i18n(armyClassName[i])
					_ENV = armyClassName[i]
					armyClassName[i].armyType = armyName
					local armyClassName[i].num, valueStr = string.format("%.2f", value), armyClassName[i]
					_ENV = value
					value.offsetX = 30
					value.str = i18n_html("mail_2_text_93", valueStr, colorStr, true)
					table.insert(strList, value)
				end
			end
		end
		if akdfhpDmgReduce and next(akdfhpDmgReduce) then
			_ENV, _ENV = akdfhpDmgReduce, next(akdfhpDmgReduce)
			_ENV, next(akdfhpDmgReduce).num, akdfhpDmgReduce.color = akdfhpDmgReduce, akdfhpDmgReduce, "#006E00"
			next(akdfhpDmgReduce).__default, akdfhpDmgReduce.color = akdfhpDmgReduce, "#55230F"
			local colorStr = next(akdfhpDmgReduce)
			for i = 1, #armyClassName do
				local armyType = i
				local value = akdfhpDmgReduce[tostring(armyType)]
				if value and 0 < value then
					local armyName = i18n(armyClassName[i])
					_ENV = armyClassName[i]
					armyClassName[i].armyType = armyName
					local armyClassName[i].num, valueStr = string.format("%.2f", value), armyClassName[i]
					_ENV = value
					value.offsetX = 30
					value.str = i18n_html("mail_2_text_104", valueStr, colorStr, true)
					table.insert(strList, value)
				end
			end
		end
		totalHeight = totalHeight + self:createNewFightReportDetail(i18n("Divine_beast_text_02"), strList, true, vLayout)
	end
	if buffDetail and next(buffDetail) then
		strList, _ENV = next(buffDetail), next(buffDetail)
		local _ENV, _ENV, nameStr = self:createNewFightReportDetail(i18n("Divine_beast_text_02"), strList, true, vLayout), "battlelog_text_40", isSelf and i18n("battlelog_text_41") or i18n("battlelog_text_40")
		_ENV, ("battlelog_text_40").name, self:createNewFightReportDetail(i18n("Divine_beast_text_02"), strList, true, vLayout).color = self:createNewFightReportDetail(i18n("Divine_beast_text_02"), strList, true, vLayout), self:createNewFightReportDetail(i18n("Divine_beast_text_02"), strList, true, vLayout), isSelfColor
		_ENV, ("battlelog_text_40").armyType, self:createNewFightReportDetail(i18n("Divine_beast_text_02"), strList, true, vLayout).color = self:createNewFightReportDetail(i18n("Divine_beast_text_02"), strList, true, vLayout), self:createNewFightReportDetail(i18n("Divine_beast_text_02"), strList, true, vLayout), "#006E00"
		_ENV, ("battlelog_text_40").num, self:createNewFightReportDetail(i18n("Divine_beast_text_02"), strList, true, vLayout).color = self:createNewFightReportDetail(i18n("Divine_beast_text_02"), strList, true, vLayout), self:createNewFightReportDetail(i18n("Divine_beast_text_02"), strList, true, vLayout), "#006E00"
		_ENV, _UPVALUE3_, ("battlelog_text_40").__default, self:createNewFightReportDetail(i18n("Divine_beast_text_02"), strList, true, vLayout).color = self, self:createNewFightReportDetail(i18n("Divine_beast_text_02"), strList, true, vLayout), self:createNewFightReportDetail(i18n("Divine_beast_text_02"), strList, true, vLayout), "#55230F"
		local colorStr = "battlelog_text_40"
		self.buffId = gBuffEffect.BASE_ATTACK_PLUS_PER_HUNDRED_AK
		_ENV, self.textKey = gBuffEffect.BASE_ATTACK_PLUS_PER_HUNDRED_AK, "mail_2_text_107"
		gBuffEffect.BASE_ATTACK_PLUS_PER_HUNDRED_AK.buffId = gBuffEffect.BASE_DEFENSE_PLUS_PER_HUNDRED_DF
		_ENV, gBuffEffect.BASE_ATTACK_PLUS_PER_HUNDRED_AK.textKey = gBuffEffect.BASE_DEFENSE_PLUS_PER_HUNDRED_DF, "mail_2_text_108"
		gBuffEffect.BASE_DEFENSE_PLUS_PER_HUNDRED_DF.buffId = gBuffEffect.BASE_HP_PLUS_PER_HUNDRED_HP
		gBuffEffect.BASE_DEFENSE_PLUS_PER_HUNDRED_DF.textKey = "mail_2_text_109"
		self:createNewFightReportDetail(i18n("Divine_beast_text_02"), strList, true, vLayout)[1] = self
		self:createNewFightReportDetail(i18n("Divine_beast_text_02"), strList, true, vLayout)[2] = gBuffEffect.BASE_ATTACK_PLUS_PER_HUNDRED_AK
		local self:createNewFightReportDetail(i18n("Divine_beast_text_02"), strList, true, vLayout)[3], collectionBuffList = gBuffEffect.BASE_DEFENSE_PLUS_PER_HUNDRED_DF, self:createNewFightReportDetail(i18n("Divine_beast_text_02"), strList, true, vLayout)
		for _, buffCfg in ipairs(collectionBuffList) do
			local buffArmyData = buffDetail[buffCfg.buffId] or buffDetail[tostring(buffCfg.buffId)]
			if buffArmyData and next(buffArmyData) then
				for i = 1, #armyClassName do
					local value = buffArmyData[i] or buffArmyData[tostring(i)]
					if value then
						_ENV = i
						i.name = nameStr
						i.armyType = i18n(armyClassName[i])
						local i.num, valueStr = value / 1000, i
						_ENV = colorStr
						colorStr.offsetX = 30
						colorStr.str = i18n_html(buffCfg.textKey, valueStr, colorStr, true)
						table.insert(strList, colorStr)
					end
				end
			end
		end
		if next(strList) then
			totalHeight = totalHeight + self:createNewFightReportDetail(i18n("mail_2_text_101"), strList, true, vLayout)
		end
	end
	strList, _ENV = i18n("battlelog_text_40"), nameStr
	local intimidateEffectText = self:getIntimidateEffectText(intimidateInfo, isSelf)
	if intimidateEffectText then
		_ENV = isSelf
		isSelf.offsetX = 30
		isSelf.str = intimidateEffectText
		table.insert(strList, isSelf)
	end
	if shield then
		_ENV = isSelf
		isSelf.offsetX = 30
		_ENV = strList
		strList.name = strTtle
		_ENV, _ENV, strList.num = math.floor(shield)
		_ENV, string.formatnumberthousands(math.floor(shield)).num, math.floor(shield).color = math.floor(shield)
		_ENV, string.formatnumberthousands(math.floor(shield)).name, math.floor(shield).color = math.floor(shield)
		string.formatnumberthousands(math.floor(shield)).__default, math.floor(shield).color = math.floor(shield)
		isSelf.str = i18n_html("battlelog_text_37", strList, string.formatnumberthousands(math.floor(shield)), true)
		table.insert(strList, isSelf)
	end
	if next(strList) then
		totalHeight = totalHeight + self:createNewFightReportDetail(i18n("battlelog_text_9"), strList, true, vLayout)
	end
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight))
	return vLayout, totalHeight
end
function mailNodeFactory:createNewFightReportDetail(title, strList, showLine, vLayout)
	local totalHeight = 0
	_ENV = nil
	;(nil).color = cc.c3b(85, 35, 15)
	;(nil).str = "[" .. title .. "]"
	;(nil).fontSize = 20
	;(nil).AlignH = SoraDFLabelR()
	;(nil).autoHeight = true
	;(nil).point = SoraDFPoint(1, 1, 1)
	;(nil).linearLayoutType = ccui.LinearGravity.centerHorizontal
	;(nil).textWidth = 560
	local label, autoHeight = include("mailNodeFactory"):createTextLayout(nil)
	label:addTo(vLayout)
	totalHeight = totalHeight + autoHeight
	for i, v in ipairs(strList) do
		_ENV = nil
		;(nil).color = cc.c3b(255, 255, 255)
		;(nil).str = v.str
		;(nil).fontSize = 20
		;(nil).isHtml = true
		;(nil).AlignH = SoraDFLabelR()
		;(nil).autoHeight = true
		;(nil).textWidth = 560 - v.offsetX
		;(nil).linearLayoutType = ccui.LinearGravity.centerHorizontal
		_ENV, (nil).point = SoraDFPoint(1, 1, 1), SoraDFPoint(1, 1, 1)
		SoraDFPoint(1, 1, 1).left = SoraDFIsRA() and -v.offsetX or v.offsetX
		SoraDFPoint(1, 1, 1).top = 0
		SoraDFPoint(1, 1, 1).right = 0
		;(nil).margin, SoraDFPoint(1, 1, 1).bottom = SoraDFPoint(1, 1, 1), 0
		local label, autoHeight = include("mailNodeFactory"):createTextLayout(nil)
		label:addTo(vLayout)
		totalHeight = totalHeight + autoHeight
	end
	if showLine then
		_ENV = ipairs(strList)
		ipairs(strList).imgName = "frame_yjyh_line_02.png"
		ipairs(strList).imagWidth = 563
		ipairs(strList).imagHeight = 6
		_ENV, ipairs(strList).linearLayoutType = ccui.LinearGravity.centerHorizontal, ccui.LinearGravity.centerHorizontal
		ccui.LinearGravity.centerHorizontal.left = 0
		ccui.LinearGravity.centerHorizontal.top = 5
		ccui.LinearGravity.centerHorizontal.right = 0
		ipairs(strList).margin, ccui.LinearGravity.centerHorizontal.bottom = ccui.LinearGravity.centerHorizontal, 5
		local line, autoHeight = mailNodeFactory:createImgViewLayout(ipairs(strList))
		line:addTo(vLayout)
		totalHeight = totalHeight + 16
	end
	return totalHeight
end
function mailNodeFactory:createLongTextLayout(strList, width)
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	local totalHeight = 0
	for i, v in ipairs(strList) do
		_ENV = nil
		;(nil).color = cc.c3b(102, 50, 12)
		;(nil).str = v
		;(nil).fontSize = 20
		;(nil).isHtml = true
		;(nil).AlignH = SoraDFLabelR()
		;(nil).autoHeight = true
		;(nil).textWidth = 560
		;(nil).linearLayoutType = ccui.LinearGravity.centerHorizontal
		;(nil).point = SoraDFPoint(1, 1, 1)
		local label, autoHeight = include("mailNodeFactory"):createTextLayout(nil)
		label:addTo(vLayout)
		totalHeight = totalHeight + autoHeight
	end
	vLayout:setContentSize(width, totalHeight)
	return vLayout, totalHeight
end
function mailNodeFactory:createHonorBackNode(viewType)
	local node_honorBack = display.newNode()
	local nodeSize = cc.size(552, 38)
	if viewType == "memberSingle" then
		nodeSize = cc.size(146, 30)
	end
	local Sprite_bg = display.newSprite("#frame_zqlz_rankbg_01.png")
	Sprite_bg:addTo(node_honorBack)
	Sprite_bg:setContentSize(cc.size(nodeSize.width / 2, nodeSize.height))
	Sprite_bg:setAnchorPoint(cc.p(1, 0.5))
	local Sprite_bg = display.newSprite("#frame_zqlz_rankbg_01.png")
	Sprite_bg:addTo(node_honorBack)
	Sprite_bg:setContentSize(cc.size(nodeSize.width / 2, nodeSize.height))
	Sprite_bg:setFlippedX(true)
	Sprite_bg:setAnchorPoint(cc.p(0, 0.5))
	local Text_name = ccui.Text:create(i18n("recommended_alliance_text6"), "", 22)
	Text_name:addTo(node_honorBack)
	SoraDSetTextWidthHeight(Text_name, nodeSize)
	Text_name:setColor(cc.c3b(255, 212, 62))
	Text_name:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	Text_name:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	if viewType == "memberSetting" or viewType == "mail" then
		local Text_des = ccui.Text:create(i18n("recommended_alliance_text7"), "", 20)
		Text_des:addTo(node_honorBack)
		SoraDSetTextWidthHeight(Text_des, cc.size(nodeSize.width, 100))
		Text_des:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		Text_des:setAnchorPoint(cc.p(0.5, 1))
		Text_des:setPositionY(-30)
		if viewType == "memberSetting" then
			Text_des:setColor(cc.c3b(215, 195, 155))
		elseif viewType == "mail" then
			Text_des:setColor(cc.c3b(68, 35, 17))
		end
	end
	return node_honorBack
end
function mailNodeFactory:getWidgetItemHeight(target)
	local newMargin = target:getLayoutParameter():getMargin()
	return target.getItemHeight and target:getItemHeight() or target:getContentSize().height + newMargin.top + newMargin.bottom
end
function mailNodeFactory:getIntimidateEffectText(intimidateInfo, isSelf)
	if not intimidateInfo then
		return nil
	end
	local selfArmyNum = intimidateInfo.selfArmyNum or 0
	local enemyArmyNum = intimidateInfo.enemyArmyNum or 0
	local intimidateDmgReduce = intimidateInfo.intimidateDmgReduce or 0
	_ENV = nil
	local intimidateLimit = include("constantRead").getConstValueArray("TECHNOLOGY_ID243_LIMIT", nil)
	local nameKey = isSelf and "battlelog_text_41" or "battlelog_text_40"
	local targetKey = isSelf and "battlelog_text_40" or "battlelog_text_41"
	local nameColor = isSelf and "#006E00" or "#D24B01"
	local targetColor = isSelf and "#D24B01" or "#006E00"
	_ENV = nil
	;(nil).name = i18n(nameKey)
	;(nil).target = i18n(targetKey)
	;(nil).num1 = string.format("%.2f%%", (selfArmyNum - enemyArmyNum) / enemyArmyNum * 100)
	;(nil).num2 = string.format("%.2f%%", intimidateDmgReduce / 10)
	_ENV, _ENV, (nil).num3 = "%.2f%%", string.format("%.2f%%", (tonumber(intimidateLimit[2]) or 0) / 10), string.format("%.2f%%", (tonumber(intimidateLimit[2]) or 0) / 10)
	_ENV, string.format("%.2f%%", (tonumber(intimidateLimit[2]) or 0) / 10).name, ("%.2f%%").color = "%.2f%%", "%.2f%%", nameColor
	_ENV, string.format("%.2f%%", (tonumber(intimidateLimit[2]) or 0) / 10).target, ("%.2f%%").color = "%.2f%%", "%.2f%%", targetColor
	_ENV, string.format("%.2f%%", (tonumber(intimidateLimit[2]) or 0) / 10).num1, ("%.2f%%").color = "%.2f%%", "%.2f%%", nameColor
	_ENV, string.format("%.2f%%", (tonumber(intimidateLimit[2]) or 0) / 10).num2, ("%.2f%%").color = "%.2f%%", "%.2f%%", nameColor
	_ENV, string.format("%.2f%%", (tonumber(intimidateLimit[2]) or 0) / 10).num3, ("%.2f%%").color = "%.2f%%", "%.2f%%", "#006E00"
	string.format("%.2f%%", (tonumber(intimidateLimit[2]) or 0) / 10).__default, ("%.2f%%").color = "%.2f%%", "#55230F"
	return i18n_html("battlelog_text_68", nil, string.format("%.2f%%", (tonumber(intimidateLimit[2]) or 0) / 10), true)
end
return mailNodeFactory
