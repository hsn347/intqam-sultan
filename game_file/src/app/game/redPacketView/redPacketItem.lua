local gametop = gModuleMgr.getObject("gametop")
local lordLocalData = include("lordLocalData")
local mailFunctions = include("mailFunctions")
local redPacketItem = class("redPacketItem", function(target)
	if target == nil then
		return display.newNode()
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function redPacketItem:createUI()
	local itemSize = cc.size(600, 110)
	local widthLayout = 600
	self.layout_item = ccui.Layout:create()
	self.layout_item:setAnchorPoint(cc.p(1, 0))
	self.layout_item:setPosition(cc.p(itemSize.width, 0))
	self.layout_item:addTo(self)
	self.layout_item:setTouchEnabled(true)
	self.layout_item:setSwallowTouches(false)
	self.layout_item:setContentSize(itemSize)
	local spriteBg = ccui.ImageView:create()
	spriteBg:loadTexture("frame_mail_sheer_01.png", ccui.TextureResType.plistType)
	spriteBg:setScale9Enabled(true)
	spriteBg:setCapInsets(cc.rect(10, 10, 34, 34))
	spriteBg:setContentSize(itemSize)
	self.spriteBg = spriteBg
	self.spriteBg:setPosition(cc.p(0, itemSize.height / 2))
	self.spriteBg:setAnchorPoint(cc.p(0, 0.5))
	self.spriteBg:addTo(self.layout_item)
	local widthIconBg = 100
	local iconBg = display.newSprite("#frame_mailinfo_18.png", SoraDFPoint(585, itemSize.height / 2, widthLayout))
	iconBg:setAnchorPoint(SoraDFAP(0.5, 0.5))
	iconBg:setPosition(SoraDFPoint(545, itemSize.height / 2, widthLayout))
	iconBg:addTo(self.layout_item)
	iconBg:setLocalZOrder(10)
	self.img_icon = ccui.ImageView:create("head_m_001.png", ccui.TextureResType.plistType)
	self.img_icon:setPosition(cc.p(54.5, 55))
	self.img_icon:ignoreContentAdaptWithSize(false)
	self.img_icon:setContentSize(cc.size(80, 80))
	self.img_icon:addTo(iconBg)
	_ENV = self.img_icon
	self.img_icon.text = ""
	self.img_icon.size = 24
	self.img_icon.color = cc.c3b(41, 21, 6)
	self.img_icon.align = SoraDFLabelR()
	self.img_icon.valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
	self.img_icon.x = 486
	self.img_icon.y = 75
	self.label_name = display.newTTFLabel(self.img_icon)
	self.label_name:setAnchorPoint(SoraDFAP(1, 0.5))
	self.label_name:addTo(self.layout_item)
	self.label_name:setPosition(SoraDFPoint(486, 75, widthLayout))
	_ENV = self.label_name
	self.label_name.text = ""
	self.label_name.size = 20
	self.label_name.color = cc.c3b(41, 21, 6)
	self.label_name.align = SoraDFLabelR()
	self.label_name.valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
	self.label_name.x = 486
	self.label_name.y = 30
	self.label_time = display.newTTFLabel(self.label_name)
	self.label_time:setAnchorPoint(SoraDFAP(1, 0.5))
	self.label_time:setPosition(SoraDFPoint(486, 30, widthLayout))
	self.label_time:addTo(self.layout_item)
	self.spriteGold = display.newSprite("#icon_small_gold.png", SoraDFPoint(43.0, 41.5, widthLayout))
	self.spriteGold:setAnchorPoint(SoraDFAP(0.5, 0.5))
	self.spriteGold:setPosition(SoraDFPoint(105, 30, widthLayout))
	self.spriteGold:addTo(self.layout_item)
	_ENV = self.spriteGold
	self.spriteGold.text = ""
	self.spriteGold.size = 20
	self.spriteGold.color = cc.c3b(41, 21, 6)
	self.spriteGold.align = SoraDFLabelL()
	self.spriteGold.valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
	self.spriteGold.x = 85
	self.spriteGold.y = 28
	self.label_gold = display.newTTFLabel(self.spriteGold)
	self.label_gold:setAnchorPoint(SoraDFAP(1, 0.5))
	self.label_gold:setPosition(SoraDFPoint(70, 28, widthLayout))
	self.label_gold:addTo(self.layout_item)
	_ENV = self.label_gold
	self.label_gold.text = i18n("common_text_1781")
	self.label_gold.size = 20
	self.label_gold.color = cc.c3b(41, 21, 6)
	self.label_gold.align = SoraDFLabelL()
	self.label_gold.valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
	self.label_gold.x = 25
	self.label_gold.y = 75
	self.label_luck = display.newTTFLabel(self.label_gold)
	self.label_luck:setAnchorPoint(SoraDFAP(0, 0.5))
	self.label_luck:setPosition(SoraDFPoint(25, 75, widthLayout))
	self.label_luck:addTo(self.layout_item)
	self.sprite_luck = display.newSprite("#frame_redpacket_fire_01.png", SoraDFPoint(134, 80, widthLayout))
	self.sprite_luck:setAnchorPoint(SoraDFAP(0, 0.5))
	self.sprite_luck:setPosition(SoraDFPoint(25 + self.label_luck:getContentSize().width + 14, 80, widthLayout))
	self.sprite_luck:addTo(self.layout_item)
	self.imgItemBox = self:createItemBox()
	self.imgItemBox:setAnchorPoint(SoraDFAP(0.5, 0.5))
	self.imgItemBox:addTo(self.layout_item)
	self.imgItemBox:setPosition(SoraDFPoint(240, 34, widthLayout))
	self.imgItemBox:setVisible(false)
	local labelItem = ccui.Text:create()
	labelItem:setFontSize(22)
	labelItem:setColor(cc.c3b(41, 21, 6))
	labelItem:setString("1")
	labelItem:addTo(self.layout_item)
	labelItem:setPosition(SoraDFPoint(200, 28, widthLayout))
	self.labelItem = labelItem
	self.labelItem:setVisible(false)
	local lineTop = display.newSprite("#frame_mail_line_02.png", widthLayout / 2, 111)
	lineTop:addTo(self, 1)
	lineTop:setScaleX(widthLayout / lineTop:getContentSize().width)
	local lineBottom = display.newSprite("#frame_mail_line_02.png", widthLayout / 2, -1)
	lineBottom:addTo(self, 1)
	lineBottom:setScaleX(widthLayout / lineTop:getContentSize().width)
	local itemSize = self.layout_item:getContentSize()
	self.itemWidth = itemSize.width
	self.itemHeight = itemSize.height
end
function redPacketItem:ctor()
	self:createUI()
end
function redPacketItem:initWithData(data)
	self.itemData = data
	if data.isLuck then
		print("i am luck", data.gold, data.nickName)
	end
	mailFunctions = "i am luck"
	;("i am luck")[1] = self.label_luck
	;("i am luck")[2] = self.sprite_luck
	for i, v in ipairs("i am luck") do
		if v then
			v:setVisible(data.isLuck and true or false)
		end
	end
	if self.itemData.extraReward and self.itemData.extraReward[1] and self.itemData.extraReward[1].count > 0 then
		_ENV = ipairs("i am luck")
		ipairs("i am luck").id = self.itemData.extraReward[1].id
		ipairs("i am luck").hideColor = true
		ipairs("i am luck").showItemInfo = true
		self.imgItemBox:initWithData(ipairs("i am luck"))
		self.imgItemBox:setVisible(true)
		self.labelItem:setString(self.itemData.extraReward[1].count)
		self.labelItem:setVisible(true)
	else
		self.imgItemBox:setVisible(false)
		self.labelItem:setVisible(false)
	end
	self.label_gold:setString(self.itemData.gold)
	local iconID = self.itemData.iconID
	local avatar = self.itemData.avatar
	local headImg = lordLocalData.getHead(iconID)
	SoraDGetHeadFromManager(self.img_icon, iconID, avatar)
	local name = self.itemData.nickName
	if self.itemData.redPacketType == 2 then
		name = mailFunctions:getWrappedName(self.itemData.allianceAbbr, self.itemData.nickName)
	end
	self.label_name:setString(name)
	local timeStr = os.date("%Y-%m-%d %H:%M:%S ", self.itemData.time)
	self.label_time:setString(timeStr)
end
function redPacketItem:createItemBox(itemId)
	local mailItemBox = include("mailItemBox")
	local boxNode = mailItemBox.new()
	_ENV = nil
	;(nil).id = itemId
	boxNode:initWithData(nil)
	boxNode:setContentSize(cc.size(boxNode:getItemWidth(), boxNode:getItemHeight()))
	boxNode:setScale(45 / boxNode:getItemWidth())
	return boxNode
end
function redPacketItem:setScrollView(scrollView)
	self.scrollView = scrollView
end
function redPacketItem:getItemWidth()
	return self.itemWidth
end
function redPacketItem:getItemHeight()
	return self.itemHeight
end
return redPacketItem
