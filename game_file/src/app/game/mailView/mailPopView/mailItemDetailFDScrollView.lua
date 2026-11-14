local mailFunctions = include("mailFunctions")
local mailItemDetailFDScrollView = class("mailItemDetailFDScrollView", function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new(getCCSPath("mailItemDetailFDScrollView"))
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function mailItemDetailFDScrollView:ctor()
	self:setAnchorPoint(cc.p(0, 0))
	self.scrollView = SoraDGetChildByName(self, "Size_ScrollView")
	self:setContentSize(self.scrollView:getContentSize())
	self.lineCount, _ENV, self.frameBoxNodes, _ENV, self.armyLayouts, _ENV, self.armyNodes, _ENV = self.setContentSize, self.setContentSize, self.setContentSize, self.setContentSize, self.setContentSize, self.setContentSize, self.setContentSize, self.setContentSize
end
function mailItemDetailFDScrollView:initWithFightDetail(data)
	local scrollInner = self.scrollView:getInnerContainer()
	local mailContentNode
	self.itemData = data
	mailContentNode = self:createFightDetailLayout(data)
	if mailContentNode == nil then
		return
	end
	local itemWidth = mailContentNode:getContentSize().width
	local itemHeight = mailContentNode:getContentSize().height
	local scrollSize = self.scrollView:getContentSize()
	scrollInner:addChild(mailContentNode)
	self.scrollView:setInnerContainerSize(cc.size(math.max(scrollSize.width, itemWidth), math.max(scrollSize.height, itemHeight)))
	self.scrollView:setDirection(ccui.ScrollViewDir.both)
	mailContentNode:ignoreAnchorPointForPosition(false)
	mailContentNode:setAnchorPoint(cc.p(0, 1))
	mailContentNode:setPosition(cc.p(0, scrollInner:getContentSize().height))
	self.mailContentNode = mailContentNode
end
function mailItemDetailFDScrollView:createFightDetailLayout(data)
	local fightDetail = data.fightDetail
	local vLayout = ccui.VBox:create()
	local totalWidth = gMailDetaiViewWidth
	local totalHeight = 0
	if not data.otherMsg then
		local _ENV, otherMsg = data.otherMsg, data.otherMsg
	end
	local _ENV, strMsg
	local maxLen = string.len(fightDetail)
	local index = 1
	while maxLen > index do
		table.insert(strMsg, SubStringUTF8(fightDetail, index, math.min(maxLen, index + 2000)))
		index = math.min(maxLen, index + 2000)
	end
	for i, v in ipairs(otherMsg) do
		table.insert(strMsg, v)
	end
	if strMsg and next(strMsg) then
		local _ENV, tableLabel = next(strMsg), next(strMsg)
		for i, v in ipairs(strMsg) do
			local label2 = ccui.Text:create()
			label2:setColor(display.COLOR_BLACK)
			label2:setString(v)
			label2:setFontSize(20)
			label2:setIsHtml(true)
			vLayout:addChild(label2)
			label2:setAnchorPoint(cc.p(0, 1))
			local height = SoraDGetAutoHeightLabelNew(label2, gMailDetaiViewWidth, true)
			totalHeight = height + totalHeight
			table.insert(tableLabel, label2)
		end
		vLayout:setContentSize(cc.size(totalWidth, totalHeight))
		for i, v in ipairs(tableLabel) do
			v:setPosition(cc.p(0, totalHeight))
			totalHeight = totalHeight - v:getContentSize().height
		end
	end
	return vLayout
end
function mailItemDetailFDScrollView:initWithData(data, strTime)
	local scrollInner = self.scrollView:getInnerContainer()
	local mailContentNode
	self.itemData = data
	mailContentNode = self:createFDLayout(data, strTime)
	if mailContentNode == nil then
		return
	end
	local itemWidth = mailContentNode:getContentSize().width
	local itemHeight = mailContentNode:getContentSize().height
	local scrollSize = self.scrollView:getContentSize()
	scrollInner:addChild(mailContentNode)
	self.scrollView:setInnerContainerSize(cc.size(math.max(scrollSize.width, itemWidth), math.max(scrollSize.height, itemHeight)))
	mailContentNode:ignoreAnchorPointForPosition(false)
	mailContentNode:setAnchorPoint(cc.p(0, 1))
	mailContentNode:setPosition(cc.p(0, scrollInner:getContentSize().height))
	self.mailContentNode = mailContentNode
end
function mailItemDetailFDScrollView:createFDLayout(data, strTime)
	local vLayout = ccui.VBox:create()
	local totalWidth = gMailDetaiViewWidth
	local totalHeight = 0
	_ENV = nil
	;(nil).str = strTime
	;(nil).linearLayoutType = ccui.LinearGravity.centerHorizontal
	;(nil).textWidth = 532
	;(nil).AlignH = cc.TEXT_ALIGNMENT_CENTER
	local labelTime, autoHeight = include("mailNodeFactory"):createTextLayout(nil)
	vLayout:addChild(labelTime)
	totalHeight = totalHeight + autoHeight
	local mailItemDetailFDFlag = include("mailItemDetailFDFlag")
	local atkFlagNode = mailItemDetailFDFlag.new()
	atkFlagNode:setSwallowTouches(false)
	_ENV = atkFlagNode.setSwallowTouches
	atkFlagNode.setSwallowTouches.flagType = 0
	local atkFlagNode.setSwallowTouches.strType, atkFlagData = i18n("common_text_125"), atkFlagNode.setSwallowTouches
	atkFlagNode:initWithData(atkFlagData)
	vLayout:addChild(atkFlagNode)
	totalHeight = totalHeight + atkFlagNode:getItemHeight()
	if not data.divineBeastList then
		_ENV = data.divineBeastList
	end
	local atkArmyLayout = self:createOneSideArmy(true, data.battleInfo.attackArmyInfo, data.heroList, data.armsList, data.divineBeastList)
	local frameBoxAtkArmyNode = include("mailItemDetailFrameBox").new()
	_ENV = data.heroList
	_ENV, data.heroList.dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isHideTop = true
	data.heroList.dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, atkArmyLayout
	frameBoxAtkArmyNode:initWithData(data.heroList)
	self.armyLayouts.attack = atkArmyLayout
	self.frameBoxNodes.attack = frameBoxAtkArmyNode
	self.lineCount.attack = #data.battleInfo.attackArmyInfo
	vLayout:addChild(frameBoxAtkArmyNode)
	totalHeight = totalHeight + frameBoxAtkArmyNode:getItemHeight()
	local defFlagNode = mailItemDetailFDFlag.new()
	defFlagNode:setSwallowTouches(false)
	_ENV = defFlagNode.setSwallowTouches
	defFlagNode.setSwallowTouches.flagType = 1
	local defFlagNode.setSwallowTouches.strType, defFlagData = i18n("common_text_126"), defFlagNode.setSwallowTouches
	defFlagNode:initWithData(defFlagData)
	vLayout:addChild(defFlagNode)
	totalHeight = totalHeight + defFlagNode:getItemHeight()
	if not data.divineBeastList then
		_ENV = data.divineBeastList
	end
	local atkDefLayout = self:createOneSideArmy(false, data.battleInfo.defenceArmyInfo, data.heroList, data.armsList, data.divineBeastList)
	local frameBoxDefArmyNode = include("mailItemDetailFrameBox").new()
	_ENV = data.heroList
	_ENV, data.heroList.dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isHideTop = true
	data.heroList.dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, atkDefLayout
	frameBoxDefArmyNode:initWithData(data.heroList)
	self.armyLayouts.defense = atkDefLayout
	self.frameBoxNodes.defense = frameBoxDefArmyNode
	self.lineCount.defense = #data.battleInfo.defenceArmyInfo
	vLayout:addChild(frameBoxDefArmyNode)
	totalHeight = totalHeight + frameBoxDefArmyNode:getItemHeight()
	vLayout:setContentSize(cc.size(totalWidth, totalHeight))
	return vLayout
end
function mailItemDetailFDScrollView:createOneSideArmy(isAttack, armyInfo, heroList, armsList, divineBeastList)
	local vLayout = ccui.VBox:create()
	local totalWidth = gMailDetaiViewWidth
	local totalHeight = 0
	if not heroList then
		heroList, _ENV = nil, nil
	end
	if not armsList then
		armsList, _ENV = nil, nil
	end
	for i, v in ipairs(armyInfo) do
		local playerInfo = v
		local uid = playerInfo.uinfo.id
		local armyNode = self:createOnePlayerArmy(isAttack, playerInfo, heroList[tostring(uid)], armsList[tostring(uid)], divineBeastList[tostring(uid)])
		vLayout:addChild(armyNode)
		table.insert(self.armyNodes, armyNode)
		if i ~= #armyInfo then
			local imgLine = ccui.ImageView:create()
			imgLine:loadTexture("frame_yjyh_line_02.png", ccui.TextureResType.plistType)
			vLayout:addChild(imgLine)
			totalHeight = totalHeight + 20
			local lp2 = ccui.LinearLayoutParameter:create()
			imgLine:setLayoutParameter(lp2)
			lp2:setGravity(ccui.LinearGravity.centerHorizontal)
			_ENV = ccui.LinearGravity.centerHorizontal
			ccui.LinearGravity.centerHorizontal.left = 0
			ccui.LinearGravity.centerHorizontal.top = 4
			ccui.LinearGravity.centerHorizontal.right = 0
			ccui.LinearGravity.centerHorizontal.bottom = 10
			lp2:setMargin(ccui.LinearGravity.centerHorizontal)
		end
		totalHeight = totalHeight + armyNode:getItemHeight()
	end
	if totalHeight == 0 then
		_ENV = ipairs(armyInfo)
		ipairs(armyInfo).str = i18n("common_text_480")
		ipairs(armyInfo).color = cc.c3b(102, 50, 12)
		ipairs(armyInfo).AlignH = cc.TEXT_ALIGNMENT_CENTER
		ipairs(armyInfo).AlignV = cc.TEXT_ALIGNMENT_CENTER
		ipairs(armyInfo).linearLayoutType = ccui.LinearGravity.centerHorizontal
		_ENV, ipairs(armyInfo).point = cc.p(0.5, 0.5), cc.p(0.5, 0.5)
		cc.p(0.5, 0.5).left = 0
		cc.p(0.5, 0.5).top = 15
		cc.p(0.5, 0.5).right = 0
		ipairs(armyInfo).margin, cc.p(0.5, 0.5).bottom = cc.p(0.5, 0.5), 0
		ipairs(armyInfo).pos = cc.p(266, 26)
		local textTips, autoHeight = include("mailNodeFactory"):createTextLayout(ipairs(armyInfo))
		textTips:addTo(vLayout)
		totalHeight = totalHeight + 52
	end
	vLayout:setContentSize(cc.size(totalWidth, totalHeight))
	return vLayout
end
function mailItemDetailFDScrollView:createOnePlayerArmy(isAttack, playerInfo, heroInfo, armsInfo, divineBeastInfo)
	local mailItemDetailFDArmy = include("mailItemDetailFDArmy")
	local armyNode = mailItemDetailFDArmy.new()
	armyNode:setSwallowTouches(false)
	local armyLayout = self:createOnePlayerArmyLayout(isAttack, playerInfo, heroInfo, armsInfo, divineBeastInfo)
	local allianceInfo = playerInfo.allianceInfo
	local uinfo = playerInfo.uinfo
	if allianceInfo == nil then
		allianceInfo, _ENV = playerInfo, playerInfo
	end
	local strTitle = include("mailDesParser").getPlayerFightTitle(self.itemData, playerInfo, 1)
	_ENV = 1
	;(1).isShowMineIcon = SoraDGetCtrl("lordInfoCtrl"):getLordInfo().base.uid == uinfo.id
	;(1).strTitle = strTitle
	;(1).isAttack = isAttack
	;(1).customNode = armyLayout
	;(1).isEnableCollapse = true
	;(1).onSizeChanged = handler(self, self.onArmyNodeSizeChanged)
	armyNode:initWithData(1)
	return armyNode
end
function mailItemDetailFDScrollView:createOnePlayerArmyLayout(isAttack, playerInfo, heroInfo, armsInfo, divineBeastInfo)
	local vLayout = ccui.VBox:create()
	local totalWidth = gMailDetaiViewWidth
	local totalHeight = 0
	local _ENV, info
	if heroInfo and next(heroInfo) ~= nil then
		info.heroInfo = heroInfo
	end
	if armsInfo and armsInfo[1] and armsInfo[1].armsID then
		info.armsInfo = armsInfo
	end
	if divineBeastInfo and divineBeastInfo[1] then
		info.divineBeastInfo = divineBeastInfo
	end
	local headLayout = ccui.Layout:create()
	local headNode = include("mailItemDetailFightInfo").new()
	headNode:setPosition(0, 0)
	headNode:addTo(headLayout)
	headLayout:addTo(vLayout)
	headLayout:setContentSize(cc.size(headNode:getItemWidth(), headNode:getItemHeight()))
	totalHeight = totalHeight + headNode:getItemHeight()
	local armyLogic = include("armyLogic")
	table.sort(playerInfo.detailInfo, function(l, r)
		if l.battleItemType == r.battleItemType then
			local lSoldierType = armyLogic.getArmyTypeByID(tonumber(l.battleItemId) % 1000)
			local rSoldierType = armyLogic.getArmyTypeByID(tonumber(r.battleItemId) % 1000)
			if lSoldierType == rSoldierType then
				return l.battleItemId > r.battleItemId
			else
				return lSoldierType < rSoldierType
			end
		else
			return l.battleItemType < r.battleItemType
		end
	end)
	for i, v in ipairs(playerInfo.detailInfo) do
		local hLayout = ccui.Layout:create()
		local fdInfoNode = include("mailItemDetailFightSingle").new()
		fdInfoNode:initData(v, i)
		fdInfoNode:setPosition(0, 0)
		fdInfoNode:addTo(hLayout)
		hLayout:setContentSize(cc.size(fdInfoNode:getItemWidth(), fdInfoNode:getItemHeight()))
		hLayout:addTo(vLayout)
		totalHeight = totalHeight + fdInfoNode:getItemHeight()
	end
	vLayout:setContentSize(cc.size(totalWidth, totalHeight))
	ccui.Helper:doLayout(vLayout)
	return vLayout
end
function mailItemDetailFDScrollView:getDetailStr(data)
	local battleItemType = data.battleItemType
	if battleItemType == gBattleItemType.SOLDIER then
		return tostring(data.survive), tostring(data.lost), tostring(data.kill), tostring(data.wounded)
	elseif battleItemType == gBattleItemType.TRAP then
		return tostring(data.survive), tostring(data.lost), tostring(data.kill), "~"
	elseif battleItemType == gBattleItemType.TOWER then
		return "~", "~", tostring(data.kill), "~"
	end
end
function mailItemDetailFDScrollView:cleanInnerContents()
	local scrollInner = self.scrollView:getInnerContainer()
	scrollInner:removeAllChildren()
	self.frameBoxNodes, _UPVALUE0_, self.armyLayouts, _UPVALUE0_, self.armyNodes, _UPVALUE0_ = scrollInner.removeAllChildren, scrollInner.removeAllChildren, scrollInner.removeAllChildren, scrollInner.removeAllChildren, scrollInner.removeAllChildren, scrollInner.removeAllChildren
	self.mailContentNode = nil
end
function mailItemDetailFDScrollView:getItemWidth()
	return self.itemWidth
end
function mailItemDetailFDScrollView:getItemHeight()
	return self.itemHeight
end
function mailItemDetailFDScrollView:resetContentSize(newSize)
	self:setContentSize(newSize)
	self.scrollView:setContentSize(newSize)
end
function mailItemDetailFDScrollView:onArmyNodeSizeChanged(armyNode, newHeight)
	self:updateScrollViewLayout()
end
function mailItemDetailFDScrollView:updateScrollViewLayout()
	if not self.mailContentNode then
		return
	end
	self:updateArmyLayoutSizes()
	self:updateFrameBoxSizes()
	local totalHeight = 0
	local children = self.mailContentNode:getChildren()
	for i, child in ipairs(children) do
		if child.getItemHeight then
			totalHeight = totalHeight + child:getItemHeight()
		else
			totalHeight = totalHeight + child:getContentSize().height
		end
	end
	self.mailContentNode:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight))
	ccui.Helper:doLayout(self.mailContentNode)
	local scrollSize = self.scrollView:getContentSize()
	local scrollInner = self.scrollView:getInnerContainer()
	self.scrollView:setInnerContainerSize(cc.size(math.max(scrollSize.width, gMailDetaiViewWidth), math.max(scrollSize.height, totalHeight)))
	self.mailContentNode:setPosition(cc.p(0, scrollInner:getContentSize().height))
end
function mailItemDetailFDScrollView:updateArmyLayoutSizes()
	for side, armyLayout in pairs(self.armyLayouts) do
		if armyLayout then
			local totalHeight = 0
			local children = armyLayout:getChildren()
			for i, child in ipairs(children) do
				if child.getItemHeight then
					totalHeight = totalHeight + child:getItemHeight()
				else
					totalHeight = totalHeight + child:getContentSize().height
				end
			end
			armyLayout:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight))
			print("updateArmyLayoutSizes", side, "totalHeight:", totalHeight, "children count:", #children)
			ccui.Helper:doLayout(armyLayout)
		end
	end
end
function mailItemDetailFDScrollView:updateFrameBoxSizes()
	for side, frameBox in pairs(self.frameBoxNodes) do
		if frameBox and self.armyLayouts[side] then
			local armyLayout = self.armyLayouts[side]
			local newHeight = armyLayout:getContentSize().height + 20 * self.lineCount[side]
			frameBox:reSize(cc.size(gMailDetaiViewWidth, newHeight))
		end
	end
end
return mailItemDetailFDScrollView
