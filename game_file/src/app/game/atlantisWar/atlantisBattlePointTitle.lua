local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local atlantisActivityRead = include("atlantisActivityRead")
local atlantisBattlePointTitle = class("atlantisBattlePointTitle", function(target)
	return include("atlantisBattlePointPersonal").new(target)
end)
function atlantisBattlePointTitle:ctor(properties)
	self.tabList, _ENV = nil, nil
	self.curTitleType = 1
	self.scroll = SoraDGetChildByName(self, "scrollViewEvents")
	SoraDGetChildByName(self, "Text_Name"):setString(i18n("common_text_264"))
	SoraDGetChildByName(self, "Text_Point"):setString(i18n("common_text_1764"))
	self.nodeTabSingle = SoraDGetChildByName(self, "Node_TabSingle")
	self:initTabScroll()
end
function atlantisBattlePointTitle:initWithKid(kid)
	self.kid = kid
end
function atlantisBattlePointTitle:initTabScroll()
	local singleWidth = 150
	local maxWidth = math.max(600, #gAtlantisTitleType * singleWidth)
	self.scroll:setInnerContainerSize(cc.size(maxWidth, 132))
	for index, data in ipairs(atlantisActivityRead.getTitleConfig()) do
		local single = self.nodeTabSingle:clone()
		single:addTo(self.scroll)
		single:setPosition(SoraDFPosX(maxWidth - (index - 1) * singleWidth, maxWidth), 0)
		self:nodeTabSingleRefresh(single, data)
		self.tabList[index] = single
		self:setItemSel(single, index == 1)
	end
end
function atlantisBattlePointTitle:setItemSel(nodeItem, isSel)
	if isSel then
		SoraDGetChildByName(nodeItem, "Text_Name"):setColor(cc.c3b(230, 220, 188))
		SoraDGetChildByName(nodeItem, "Button_Choose"):setBright(false)
	else
		SoraDGetChildByName(nodeItem, "Text_Name"):setColor(cc.c3b(136, 123, 112))
		SoraDGetChildByName(nodeItem, "Button_Choose"):setBright(true)
	end
end
function atlantisBattlePointTitle:nodeTabSingleRefresh(parent, data)
	local btnChoose = SoraDGetChildByName(parent, "Button_Choose")
	btnChoose:setTag(data.index)
	btnChoose:addTouchEventListener(handler(self, self.btnChooseClick))
	local textName = SoraDGetChildByName(parent, "Text_Name")
	textName:setString(i18n(data.name))
	local imgIcon = SoraDGetChildByName(parent, "Image_Icon")
	imgIcon:loadTexture(data.icon, ccui.TextureResType.plistType)
end
function atlantisBattlePointTitle:initMyRank()
	local allianceInfo = allianceMgr:getAllianceInfo()
	local lordInfo = lordInfoCtrl:getLordInfo()
	self.selfRankInfo.selfRank = self.rank
	self.selfRankInfo.rank = self.rank
	self.selfRankInfo.headid = lordInfo.base.imageId
	self.selfRankInfo.avatar = lordInfo.base.avatar
	self.selfRankInfo.abbr = allianceInfo and allianceInfo.property.abbr or ""
	self.selfRankInfo.nickName = lordInfo.base.nickName
	self.selfRankInfo.kid = gametop.playertop_:getKingdomID()
	self.selfRankInfo.score = self.myScore
	allianceMgr = nil
	;(nil).view = self
	self.nodeAtlantisBattlePointRankSingle:initData(self.selfRankInfo, nil)
end
function atlantisBattlePointTitle:requestMore(isRequest)
	if isRequest then
		SoraDShowLoading(self)
		self.rankInfo, _ENV, self.rankIndex = SoraDShowLoading, SoraDShowLoading, 0
		atlantisWarCtrl:reqTitleRankData(self.curTitleType, 1, self.kid)
		return
	end
	if self.hasMore == false then
		self.labelNotice:setString(i18n("common_text_085"))
		return
	else
		local index = self.rankIndex + 1
		print("Request data!!!, index = ", index)
		self:showLoadingSprite()
		SoraDShowLoading(self)
		atlantisWarCtrl:reqTitleRankData(self.curTitleType, index, self.kid)
	end
end
function atlantisBattlePointTitle:btnChooseClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:setItemSel(self.tabList[self.curTitleType], false)
		self.curTitleType = tonumber(target:getTag())
		if self.curTitleType == 4 then
			SoraDGetChildByName(self, "Text_Point"):setString(i18n("common_text_148"))
		else
			SoraDGetChildByName(self, "Text_Point"):setString(i18n("common_text_1764"))
		end
		self:setItemSel(self.tabList[self.curTitleType], true)
		self:requestMore(true)
	end
end
function atlantisBattlePointTitle:getCurTitleType()
	return self.curTitleType
end
return atlantisBattlePointTitle
