local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local atlantisActivityRead = include("atlantisActivityRead")
local atlantisTitleRankNode = class("atlantisTitleRankNode", function(target)
	target = include("atlantisKindomRankNode").new(target)
	return target
end)
function atlantisTitleRankNode:ctor(properties)
	self.tabList, _ENV, self.rankType = nil, nil, 1
	self.curTitleType = 1
	self.rankTop = 150
	self.textName:setString(i18n("common_text_264"))
	self.scroll = SoraDGetChildByName(self, "scrollViewEvents")
	self.nodeTabSingle = SoraDGetChildByName(self, "Node_TabSingle")
	self.btnPlayer = SoraDGetChildByName(self, "Button_Jump_Player")
	self.btnPlayer:addTouchEventListener(handler(self, self.btnJumpMyPlayerClick))
	self.btnQuestion = SoraDGetChildByName(self, "Button_Question")
	self.btnQuestion:addTouchEventListener(handler(self, self.btnQuestionClick))
	self:initTabScroll()
end
function atlantisTitleRankNode:initTabScroll()
	local singleWidth = 120
	local maxWidth = math.max(610, #gAtlantisTitleType * singleWidth + (#gAtlantisTitleType - 1) * 43)
	self.scroll:setInnerContainerSize(cc.size(maxWidth, 75))
	for index, data in ipairs(atlantisActivityRead.getTitleConfig()) do
		local single = self.nodeTabSingle:clone()
		single:addTo(self.scroll)
		single:setPosition(SoraDFPosX(maxWidth - (index - 1) * (singleWidth + 43), maxWidth), 0)
		self:nodeTabSingleRefresh(single, data)
		self.tabList[index] = single
		self:setItemSel(single, index == 1)
	end
end
function atlantisTitleRankNode:nodeTabSingleRefresh(parent, data)
	local imgIcon = SoraDGetChildByName(parent, "Image_Icon")
	local btnChoose = SoraDGetChildByName(parent, "Button_Choose")
	btnChoose:setTag(data.index)
	btnChoose:addTouchEventListener(handler(self, self.btnChooseClick))
	local textName = SoraDGetChildByName(parent, "Text_Name")
	textName:setString(i18n(data.name))
	imgIcon:loadTexture(data.icon, ccui.TextureResType.plistType)
end
function atlantisTitleRankNode:requestMore(beginIndex)
	if not beginIndex and self.hasMore == false then
		self.labelNotice:setString(i18n("common_text_085"))
		return
	else
		local index = beginIndex or self.rankIndex + 1
		print("Request data!!!, index = ", index)
		self:showLoadingSprite()
		SoraDShowLoading(self)
		atlantisActivityCtrl:reqTitleRank(index, self.rankType, self.curTitleType)
	end
end
function atlantisTitleRankNode:btnChooseClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:setItemSel(self.tabList[self.curTitleType], false)
		self.curTitleType = tonumber(target:getTag())
		if self.curTitleType == 4 then
			self.textPoint:setString(i18n("common_text_148"))
			self.nodeCommonTopThreeRankNode:setScoreTitle("common_text_148")
		else
			self.textPoint:setString(i18n("common_text_1764"))
			self.nodeCommonTopThreeRankNode:setScoreTitle("common_text_1764")
		end
		self:setItemSel(self.tabList[self.curTitleType], true)
		SoraDShowLoading(self)
		self.rankTop3, _ENV, self.rankInfo, _ENV, self.rankIndex = SoraDShowLoading, SoraDShowLoading, SoraDShowLoading, SoraDShowLoading, 1
		atlantisActivityCtrl:reqTitleRank(1, self.rankType, self.curTitleType)
	end
end
function atlantisTitleRankNode:btnQuestionClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("atlantisTitleRuleView")
		panel:initData(self.curTitleType)
		panel:show()
	end
end
function atlantisTitleRankNode:setItemSel(nodeItem, isSel)
	if isSel then
		SoraDGetChildByName(nodeItem, "Text_Name"):setColor(cc.c3b(255, 245, 126))
		SoraDGetChildByName(nodeItem, "Image_Icon"):setColor(cc.c3b(255, 255, 255))
		SoraDGetChildByName(nodeItem, "frame_yjzz_04_47"):setColor(cc.c3b(255, 255, 255))
	else
		SoraDGetChildByName(nodeItem, "Text_Name"):setColor(cc.c3b(255, 255, 255))
		SoraDGetChildByName(nodeItem, "Image_Icon"):setColor(cc.c3b(120, 120, 120))
		SoraDGetChildByName(nodeItem, "frame_yjzz_04_47"):setColor(cc.c3b(120, 120, 120))
	end
end
return atlantisTitleRankNode
