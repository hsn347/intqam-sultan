local itemDesRead = include("itemDesRead")
local worldMapDefine = include("worldMapDefine")
local mailUIConstDef = include("mailUIConstDef")
local mailFunctions = include("mailFunctions")
local armyDesRead = include("armyDesRead")
local publicRead = include("publicRead")
local mailNodeFactory = include("mailNodeFactory")
local mailDesRead = include("mailDesRead")
local bgImgWidth = 515
local bgImgHeight = 210
local mailItemDetailExplore = class("mailItemDetailExplore", function(target)
	return ccui.Layout:create()
end)
function mailItemDetailExplore:ctor()
	self:setSwallowTouches(false)
	self:setCascadeOpacityEnabled(true)
	self.itemWidth = gMailDetaiViewWidth
	self.itemHeight = 0
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
end
function mailItemDetailExplore:initWithData(mail)
	if nil == mail then
		return
	end
	self.mail = mail
	self.contentData = self.mail:getProperty("data")
	self:setLayoutType(ccui.LayoutType.VERTICAL)
	local totalHeight = 0
	_ENV = nil
	;(nil).imgName = self:getBannerName()
	;(nil).linearLayoutType = ccui.LinearGravity.centerHorizontal
	local img, autoHeight = mailNodeFactory:createImgViewLayout(nil)
	img:addTo(self)
	totalHeight = totalHeight + autoHeight
	local contentType = self.contentData.contentType
	if not contentType then
		local durationTime = SoraDConvertSecondToString(self.contentData.duration)
		_ENV = nil
		;(nil).time = durationTime
		;(nil).x = self.contentData.coordinate.x
		;(nil).y = self.contentData.coordinate.y
		local strInfo = i18n("common_text_130", nil)
		_ENV = self.contentData.coordinate.y
		self.contentData.coordinate.y.str = strInfo
		self.contentData.coordinate.y.AlignH = SoraDFLabelR()
		self.contentData.coordinate.y.fontSize = 22
		self.contentData.coordinate.y.autoHeight = true
		self.contentData.coordinate.y.color = cc.c3b(116, 91, 59)
		self.contentData.coordinate.y.linearLayoutType = ccui.LinearGravity.centerHorizontal
		local text, autoHeight = mailNodeFactory:createTextLayout(self.contentData.coordinate.y)
		text:addTo(self)
		totalHeight = totalHeight + autoHeight
	end
	if self:hasReward() then
		local rewardHead, autoHeight = mailNodeFactory:createLayoutRewardItemHead("common_text_094")
		rewardHead:addTo(self)
		totalHeight = totalHeight + autoHeight
		local extraLayout = SoraDCreatePanel("mailItemDetailFrameBox")
		_ENV = text
		_ENV, text.dataType = mailUIConstDef.MAIL_UI_TYPE_REWARD, mailUIConstDef.MAIL_UI_TYPE_REWARD
		mailUIConstDef.MAIL_UI_TYPE_REWARD.itemList = self.contentData.reward.items
		text.dataContent, mailUIConstDef.MAIL_UI_TYPE_REWARD.isHideTop = mailUIConstDef.MAIL_UI_TYPE_REWARD, true
		extraLayout:initWithData(text)
		extraLayout:addTo(self)
		totalHeight = totalHeight + extraLayout:getItemHeight()
	end
	if self:hasLostArmy() then
		local armyHead, autoHeight = mailNodeFactory:createLayoutRewardItemHead("common_text_116")
		armyHead:addTo(self)
		totalHeight = totalHeight + autoHeight
		local armyLayout, autoHeight = self:createArmyInfoLayout()
		armyLayout:addTo(self)
		totalHeight = totalHeight + autoHeight
	end
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
end
function mailItemDetailExplore:getBannerName()
	if contentType == gMailNPCContentType.Content_Explore_Desert_Meteorite then
		return "bg_mailinfo_relic.png"
	end
	return "bg_mailinfo_relic.png"
end
function mailItemDetailExplore:createItemSoldier(itemData)
	local item = itemData
	local itemDes
	local hLayout = ccui.HBox:create()
	hLayout:setCascadeOpacityEnabled(true)
	local itemId = item.id
	itemDes = armyDesRead.getName(itemId)
	local labelDes = ccui.Text:create()
	labelDes:setFontSize(20)
	labelDes:setColor(cc.c3b(96, 73, 44))
	labelDes:setString(itemDes)
	hLayout:addChild(labelDes)
	local lp2 = ccui.LinearLayoutParameter:create()
	labelDes:setLayoutParameter(lp2)
	lp2:setGravity(ccui.LinearGravity.centerVertical)
	_ENV = ccui.LinearGravity.centerVertical
	ccui.LinearGravity.centerVertical.left = 25
	ccui.LinearGravity.centerVertical.top = 0
	ccui.LinearGravity.centerVertical.right = 0
	ccui.LinearGravity.centerVertical.bottom = 0
	lp2:setMargin(ccui.LinearGravity.centerVertical)
	local labelNum = ccui.Text:create()
	labelNum:setFontSize(20)
	labelNum:setColor(cc.c3b(115, 41, 41))
	labelNum:setString(tostring(item.num))
	hLayout:addChild(labelNum)
	local lpFrame = ccui.LayoutParameter:create()
	labelNum:setLayoutParameter(lpFrame)
	labelNum:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
	labelNum:setAnchorPoint(cc.p(1, 0.5))
	labelNum:setPosition(cc.p(580, 29))
	hLayout:setContentSize(cc.size(gMailDetaiViewWidth, 58))
	return hLayout
end
function mailItemDetailExplore:createArmyInfoLayout()
	local vLayout = ccui.VBox:create()
	vLayout:setCascadeOpacityEnabled(true)
	local totalWidth = gMailDetaiViewWidth
	local items = self.contentData.lostArmy
	local totalHeight = 0
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	for i = 1, #items do
		local item = items[i]
		local hLayout = self:createItemSoldier(item)
		local lp3 = ccui.LinearLayoutParameter:create()
		hLayout:setLayoutParameter(lp3)
		lp3:setGravity(ccui.LinearGravity.centerHorizontal)
		_ENV = ccui.LinearGravity.centerHorizontal
		ccui.LinearGravity.centerHorizontal.left = 0
		ccui.LinearGravity.centerHorizontal.top = 0
		ccui.LinearGravity.centerHorizontal.right = 0
		ccui.LinearGravity.centerHorizontal.bottom = 0
		lp3:setMargin(ccui.LinearGravity.centerHorizontal)
		totalHeight = totalHeight + hLayout:getContentSize().height
		vLayout:addChild(hLayout)
	end
	vLayout:setContentSize(cc.size(totalWidth, totalHeight))
	return vLayout, totalHeight
end
function mailItemDetailExplore:getItemWidth()
	return self.itemWidth
end
function mailItemDetailExplore:getItemHeight()
	return self.itemHeight
end
function mailItemDetailExplore:hasReward()
	if self.contentData.reward.exp > 0 or self.contentData.reward.items ~= nil and next(self.contentData.reward.items) then
		return true
	else
		return false
	end
end
function mailItemDetailExplore:hasLostArmy()
	if #self.contentData.lostArmy ~= 0 then
		return true
	else
		return false
	end
end
return mailItemDetailExplore
