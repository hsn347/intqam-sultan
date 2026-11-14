local itemLogic = include("itemLogic")
local itemDesRead = include("itemDesRead")
local timeLimitedItemCtrl = SoraDGetCtrl("timeLimitedItemCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local ItemSingleView = class("itemSingleView", function(target)
	if target == nil then
		return display.newNode()
	end
	return target
end)
function ItemSingleView:ctor()
	self.singleIsMoved = false
	self.isRechargeUse = false
	self.tableItem, _ENV, self.target = nil, nil, nil
	self.btnItem = ccui.Button:create("frame_square_36.png", "frame_square_36.png", "frame_square_36.png", ccui.TextureResType.plistType)
	self.btnItem:setPosition(cc.p(76.5, -76.5))
	self.btnItem:setPressedActionEnabled(false)
	self.btnItem:addTo(self, 1)
	local imgFrame = display.newSprite("#frame_square_15.png")
	imgFrame:setPosition(cc.p(self.btnItem:getContentSize().height / 2, self.btnItem:getContentSize().height / 2))
	imgFrame:addTo(self.btnItem, 1)
	self.imgFrame = imgFrame
	local img = "#frame_red_items_new.png"
	self.spriteNew = display.newSprite(img)
	self.spriteNew:setVisible(false)
	if not SoraDFIsRA() then
		self.spriteNew:setPosition(cc.p(30, 128))
	else
		self.spriteNew:setPosition(cc.p(118, 128))
	end
	self.spriteNew:addTo(self.btnItem, 1)
	self.spriteNumBg = display.newSprite("#frame_sheer_black_01.png")
	self.spriteNumBg:setPosition(cc.p(76.5, -90))
	self.spriteNumBg:addTo(self, 2)
	self.spriteNumBg:setScaleX(0.2)
	self.spriteNumBg:setScaleY(0.6)
	self.spriteNumBg:setOpacity(204.0)
	self.spriteNumBg:setVisible(false)
	self.labNum = ccui.Text:create()
	self.labNum:setColor(cc.c3b(255, 228, 0))
	self.labNum:setFontSize(20)
	self.labNum:setPosition(cc.p(76.5, -90))
	self.labNum:addTo(self, 3)
	self.labNum:setVisible(false)
	self.item = nil
	self.itemsManagerHandle = nil
	self.btnItem:setSwallowTouches(false)
	if self.btnItem then
		self.btnItem:addTouchEventListener(handler(self, self.OnBtnItemClick))
	end
	self.itemClickCallback = nil
	_ENV = self.btnItem
	self.btnItem.text = ""
	self.btnItem.font = "res/Default/defaultBMFont.fnt"
	self.btnItem.align = cc.TEXT_ALIGNMENT_CENTER
	local labelTime = display.newBMFontLabel(self.btnItem)
	labelTime:setVisible(false)
	labelTime:setScale(0.8)
	labelTime:setPosition(cc.p(76.5, -90))
	labelTime:addTo(self, 3)
	labelTime:setName("Text_Time")
	labelTime:setColor(cc.c3b(255, 255, 255))
	labelTime = SoraDCreateTimerLabel(self, labelTime)
	labelTime:setTimeUpdateListener(function(leftTime)
		if leftTime < 1800 then
			labelTime:setColor(cc.c3b(200, 0, 0))
		else
			labelTime:setColor(cc.c3b(255, 255, 255))
		end
	end)
end
function ItemSingleView:setNewVisible(isVisible)
	self.spriteNew:setVisible(isVisible)
end
function ItemSingleView:setLimitedVisible(isVisible)
	self.spriteNumBg:setVisible(isVisible)
	SoraDGetChildByName(self, "Text_Time"):setVisible(isVisible)
end
function ItemSingleView:setRechargeUse(isRecharge)
	self.isRechargeUse = isRecharge
end
function ItemSingleView:setButtonTag(itemID)
	self.btnItem:setTag(itemID)
end
function ItemSingleView:sendParentToButton(parent)
	self.target = parent
end
function ItemSingleView:initData(itemData)
	self.tableItem = itemData
	if self.tableItem and self.tableItem.itemData then
		if self.item == nil then
			self.item = display.newNode()
			self.item:setPosition(cc.p(self.btnItem:getContentSize().height / 2 - 2, self.btnItem:getContentSize().height / 2 + 4))
			self.item:addTo(self.btnItem)
			local imgBg = display.newSprite("#frame_item_base_01.png")
			imgBg:setName("Image_bg")
			imgBg:setPosition(cc.p(0, 0))
			imgBg:addTo(self.item)
			local imgView = display.newSprite()
			imgView:setName("Image_item")
			imgView:setPosition(cc.p(imgBg:getContentSize().height / 2, imgBg:getContentSize().height / 2))
			imgView:addTo(imgBg)
			imgView = ccui.ImageView:create("frame_djzs_di.png", ccui.TextureResType.plistType)
			imgView:setName("Image_num")
			imgView:setAnchorPoint(cc.p(0, 0))
			imgView:setPosition(cc.p(0, 2))
			imgView:addTo(imgBg)
			local labelNum = ccui.Text:create()
			labelNum:setFontSize(24)
			labelNum:setName("Text_num")
			labelNum:setAnchorPoint(cc.p(0, 0.5))
			labelNum:setPosition(cc.p(6, 13))
			labelNum:addTo(imgBg)
			SoraDFTarget(labelNum)
			SoraDFTarget(imgView, nil, true)
			SoraDFTarget(imgBg)
			SoraDFTarget(self.item)
			self.item = include("commonItems").new(self.item)
		end
		_ENV = ccui.Text:create()
		ccui.Text:create().itemID = self.tableItem.itemData.id
		ccui.Text:create().itemCount = self.tableItem.itemData.count
		self.item:initData((ccui.Text:create()))
		self.item:setVisible(true)
		local num = itemDesRead.getNumByID(self.tableItem.itemData.id)
		if num then
			self.spriteNumBg:setVisible(true)
			self.labNum:setVisible(true)
			self.labNum:setString(num)
		else
			self.spriteNumBg:setVisible(false)
			self.labNum:setVisible(false)
		end
		self:limitedTimeItemShow()
		if itemData.isWarframe then
			self:updateWearIcon()
		end
	else
		if self.singleTag then
			self.singleTag:setVisible(false)
		end
		if self.item then
			self.item:setVisible(false)
		end
		self.spriteNumBg:setVisible(false)
		self.labNum:setVisible(false)
		SoraDGetChildByName(self, "Text_Time"):setVisible(false)
	end
	self.spriteNew:setVisible(false)
end
_ENV, ItemSingleView.initRechargeForRewardData = function(self, rewardID, rewardCount)
	if 0 < rewardID and 0 < rewardCount then
		if self.item == nil then
			self.item = display.newNode()
			self.item:setPosition(cc.p(self.btnItem:getContentSize().height / 2 - 2, self.btnItem:getContentSize().height / 2 + 4))
			self.item:addTo(self.btnItem)
			local imgBg = display.newSprite("#frame_item_base_01.png")
			imgBg:setName("Image_bg")
			imgBg:setPosition(cc.p(0, 0))
			imgBg:addTo(self.item)
			local imgView = display.newSprite()
			imgView:setName("Image_item")
			imgView:setPosition(cc.p(imgBg:getContentSize().height / 2, imgBg:getContentSize().height / 2))
			imgView:addTo(imgBg)
			imgView = ccui.ImageView:create("frame_djzs_di.png", ccui.TextureResType.plistType)
			imgView:setName("Image_num")
			imgView:setAnchorPoint(cc.p(0, 0))
			imgView:setPosition(cc.p(0, 2))
			imgView:addTo(imgBg)
			local labelNum = ccui.Text:create()
			labelNum:setFontSize(24)
			labelNum:setName("Text_num")
			labelNum:setAnchorPoint(cc.p(0, 0.5))
			labelNum:setPosition(cc.p(6, 13))
			labelNum:addTo(imgBg)
			SoraDFTarget(labelNum)
			SoraDFTarget(imgView, nil, true)
			SoraDFTarget(imgBg)
			SoraDFTarget(self.item)
			self.item = include("commonItems").new(self.item)
		end
		_ENV = ccui.Text:create()
		ccui.Text:create().itemID = rewardID
		ccui.Text:create().itemCount = rewardCount
		ccui.Text:create().isBig = true
		self.item:initData((ccui.Text:create()))
		self.item:setVisible(true)
		local num = rewardCount
		if num then
			self.spriteNumBg:setVisible(false)
			self.labNum:setVisible(false)
			self.labNum:setString(num)
		else
			self.spriteNumBg:setVisible(false)
			self.labNum:setVisible(false)
		end
	else
		if self.item then
			self.item:setVisible(false)
		end
		self.spriteNumBg:setVisible(false)
		self.labNum:setVisible(false)
	end
	self.spriteNew:setVisible(false)
end, function(self, rewardID, rewardCount)
	if 0 < rewardID and 0 < rewardCount then
		if self.item == nil then
			self.item = display.newNode()
			self.item:setPosition(cc.p(self.btnItem:getContentSize().height / 2 - 2, self.btnItem:getContentSize().height / 2 + 4))
			self.item:addTo(self.btnItem)
			local imgBg = display.newSprite("#frame_item_base_01.png")
			imgBg:setName("Image_bg")
			imgBg:setPosition(cc.p(0, 0))
			imgBg:addTo(self.item)
			local imgView = display.newSprite()
			imgView:setName("Image_item")
			imgView:setPosition(cc.p(imgBg:getContentSize().height / 2, imgBg:getContentSize().height / 2))
			imgView:addTo(imgBg)
			imgView = ccui.ImageView:create("frame_djzs_di.png", ccui.TextureResType.plistType)
			imgView:setName("Image_num")
			imgView:setAnchorPoint(cc.p(0, 0))
			imgView:setPosition(cc.p(0, 2))
			imgView:addTo(imgBg)
			local labelNum = ccui.Text:create()
			labelNum:setFontSize(24)
			labelNum:setName("Text_num")
			labelNum:setAnchorPoint(cc.p(0, 0.5))
			labelNum:setPosition(cc.p(6, 13))
			labelNum:addTo(imgBg)
			SoraDFTarget(labelNum)
			SoraDFTarget(imgView, nil, true)
			SoraDFTarget(imgBg)
			SoraDFTarget(self.item)
			self.item = include("commonItems").new(self.item)
		end
		_ENV = ccui.Text:create()
		ccui.Text:create().itemID = rewardID
		ccui.Text:create().itemCount = rewardCount
		ccui.Text:create().isBig = true
		self.item:initData((ccui.Text:create()))
		self.item:setVisible(true)
		local num = rewardCount
		if num then
			self.spriteNumBg:setVisible(false)
			self.labNum:setVisible(false)
			self.labNum:setString(num)
		else
			self.spriteNumBg:setVisible(false)
			self.labNum:setVisible(false)
		end
	else
		if self.item then
			self.item:setVisible(false)
		end
		self.spriteNumBg:setVisible(false)
		self.labNum:setVisible(false)
	end
	self.spriteNew:setVisible(false)
end
;(function(self, rewardID, rewardCount)
	if 0 < rewardID and 0 < rewardCount then
		if self.item == nil then
			self.item = display.newNode()
			self.item:setPosition(cc.p(self.btnItem:getContentSize().height / 2 - 2, self.btnItem:getContentSize().height / 2 + 4))
			self.item:addTo(self.btnItem)
			local imgBg = display.newSprite("#frame_item_base_01.png")
			imgBg:setName("Image_bg")
			imgBg:setPosition(cc.p(0, 0))
			imgBg:addTo(self.item)
			local imgView = display.newSprite()
			imgView:setName("Image_item")
			imgView:setPosition(cc.p(imgBg:getContentSize().height / 2, imgBg:getContentSize().height / 2))
			imgView:addTo(imgBg)
			imgView = ccui.ImageView:create("frame_djzs_di.png", ccui.TextureResType.plistType)
			imgView:setName("Image_num")
			imgView:setAnchorPoint(cc.p(0, 0))
			imgView:setPosition(cc.p(0, 2))
			imgView:addTo(imgBg)
			local labelNum = ccui.Text:create()
			labelNum:setFontSize(24)
			labelNum:setName("Text_num")
			labelNum:setAnchorPoint(cc.p(0, 0.5))
			labelNum:setPosition(cc.p(6, 13))
			labelNum:addTo(imgBg)
			SoraDFTarget(labelNum)
			SoraDFTarget(imgView, nil, true)
			SoraDFTarget(imgBg)
			SoraDFTarget(self.item)
			self.item = include("commonItems").new(self.item)
		end
		_ENV = ccui.Text:create()
		ccui.Text:create().itemID = rewardID
		ccui.Text:create().itemCount = rewardCount
		ccui.Text:create().isBig = true
		self.item:initData((ccui.Text:create()))
		self.item:setVisible(true)
		local num = rewardCount
		if num then
			self.spriteNumBg:setVisible(false)
			self.labNum:setVisible(false)
			self.labNum:setString(num)
		else
			self.spriteNumBg:setVisible(false)
			self.labNum:setVisible(false)
		end
	else
		if self.item then
			self.item:setVisible(false)
		end
		self.spriteNumBg:setVisible(false)
		self.labNum:setVisible(false)
	end
	self.spriteNew:setVisible(false)
end)[gItemType.TREASURE_CRYSTAL] = true
;(function(self, rewardID, rewardCount)
	if 0 < rewardID and 0 < rewardCount then
		if self.item == nil then
			self.item = display.newNode()
			self.item:setPosition(cc.p(self.btnItem:getContentSize().height / 2 - 2, self.btnItem:getContentSize().height / 2 + 4))
			self.item:addTo(self.btnItem)
			local imgBg = display.newSprite("#frame_item_base_01.png")
			imgBg:setName("Image_bg")
			imgBg:setPosition(cc.p(0, 0))
			imgBg:addTo(self.item)
			local imgView = display.newSprite()
			imgView:setName("Image_item")
			imgView:setPosition(cc.p(imgBg:getContentSize().height / 2, imgBg:getContentSize().height / 2))
			imgView:addTo(imgBg)
			imgView = ccui.ImageView:create("frame_djzs_di.png", ccui.TextureResType.plistType)
			imgView:setName("Image_num")
			imgView:setAnchorPoint(cc.p(0, 0))
			imgView:setPosition(cc.p(0, 2))
			imgView:addTo(imgBg)
			local labelNum = ccui.Text:create()
			labelNum:setFontSize(24)
			labelNum:setName("Text_num")
			labelNum:setAnchorPoint(cc.p(0, 0.5))
			labelNum:setPosition(cc.p(6, 13))
			labelNum:addTo(imgBg)
			SoraDFTarget(labelNum)
			SoraDFTarget(imgView, nil, true)
			SoraDFTarget(imgBg)
			SoraDFTarget(self.item)
			self.item = include("commonItems").new(self.item)
		end
		_ENV = ccui.Text:create()
		ccui.Text:create().itemID = rewardID
		ccui.Text:create().itemCount = rewardCount
		ccui.Text:create().isBig = true
		self.item:initData((ccui.Text:create()))
		self.item:setVisible(true)
		local num = rewardCount
		if num then
			self.spriteNumBg:setVisible(false)
			self.labNum:setVisible(false)
			self.labNum:setString(num)
		else
			self.spriteNumBg:setVisible(false)
			self.labNum:setVisible(false)
		end
	else
		if self.item then
			self.item:setVisible(false)
		end
		self.spriteNumBg:setVisible(false)
		self.labNum:setVisible(false)
	end
	self.spriteNew:setVisible(false)
end)[gItemType.PANDORABOX] = true
;(function(self, rewardID, rewardCount)
	if 0 < rewardID and 0 < rewardCount then
		if self.item == nil then
			self.item = display.newNode()
			self.item:setPosition(cc.p(self.btnItem:getContentSize().height / 2 - 2, self.btnItem:getContentSize().height / 2 + 4))
			self.item:addTo(self.btnItem)
			local imgBg = display.newSprite("#frame_item_base_01.png")
			imgBg:setName("Image_bg")
			imgBg:setPosition(cc.p(0, 0))
			imgBg:addTo(self.item)
			local imgView = display.newSprite()
			imgView:setName("Image_item")
			imgView:setPosition(cc.p(imgBg:getContentSize().height / 2, imgBg:getContentSize().height / 2))
			imgView:addTo(imgBg)
			imgView = ccui.ImageView:create("frame_djzs_di.png", ccui.TextureResType.plistType)
			imgView:setName("Image_num")
			imgView:setAnchorPoint(cc.p(0, 0))
			imgView:setPosition(cc.p(0, 2))
			imgView:addTo(imgBg)
			local labelNum = ccui.Text:create()
			labelNum:setFontSize(24)
			labelNum:setName("Text_num")
			labelNum:setAnchorPoint(cc.p(0, 0.5))
			labelNum:setPosition(cc.p(6, 13))
			labelNum:addTo(imgBg)
			SoraDFTarget(labelNum)
			SoraDFTarget(imgView, nil, true)
			SoraDFTarget(imgBg)
			SoraDFTarget(self.item)
			self.item = include("commonItems").new(self.item)
		end
		_ENV = ccui.Text:create()
		ccui.Text:create().itemID = rewardID
		ccui.Text:create().itemCount = rewardCount
		ccui.Text:create().isBig = true
		self.item:initData((ccui.Text:create()))
		self.item:setVisible(true)
		local num = rewardCount
		if num then
			self.spriteNumBg:setVisible(false)
			self.labNum:setVisible(false)
			self.labNum:setString(num)
		else
			self.spriteNumBg:setVisible(false)
			self.labNum:setVisible(false)
		end
	else
		if self.item then
			self.item:setVisible(false)
		end
		self.spriteNumBg:setVisible(false)
		self.labNum:setVisible(false)
	end
	self.spriteNew:setVisible(false)
end)[gItemType.TREASURE_MAP] = true
;(function(self, rewardID, rewardCount)
	if 0 < rewardID and 0 < rewardCount then
		if self.item == nil then
			self.item = display.newNode()
			self.item:setPosition(cc.p(self.btnItem:getContentSize().height / 2 - 2, self.btnItem:getContentSize().height / 2 + 4))
			self.item:addTo(self.btnItem)
			local imgBg = display.newSprite("#frame_item_base_01.png")
			imgBg:setName("Image_bg")
			imgBg:setPosition(cc.p(0, 0))
			imgBg:addTo(self.item)
			local imgView = display.newSprite()
			imgView:setName("Image_item")
			imgView:setPosition(cc.p(imgBg:getContentSize().height / 2, imgBg:getContentSize().height / 2))
			imgView:addTo(imgBg)
			imgView = ccui.ImageView:create("frame_djzs_di.png", ccui.TextureResType.plistType)
			imgView:setName("Image_num")
			imgView:setAnchorPoint(cc.p(0, 0))
			imgView:setPosition(cc.p(0, 2))
			imgView:addTo(imgBg)
			local labelNum = ccui.Text:create()
			labelNum:setFontSize(24)
			labelNum:setName("Text_num")
			labelNum:setAnchorPoint(cc.p(0, 0.5))
			labelNum:setPosition(cc.p(6, 13))
			labelNum:addTo(imgBg)
			SoraDFTarget(labelNum)
			SoraDFTarget(imgView, nil, true)
			SoraDFTarget(imgBg)
			SoraDFTarget(self.item)
			self.item = include("commonItems").new(self.item)
		end
		_ENV = ccui.Text:create()
		ccui.Text:create().itemID = rewardID
		ccui.Text:create().itemCount = rewardCount
		ccui.Text:create().isBig = true
		self.item:initData((ccui.Text:create()))
		self.item:setVisible(true)
		local num = rewardCount
		if num then
			self.spriteNumBg:setVisible(false)
			self.labNum:setVisible(false)
			self.labNum:setString(num)
		else
			self.spriteNumBg:setVisible(false)
			self.labNum:setVisible(false)
		end
	else
		if self.item then
			self.item:setVisible(false)
		end
		self.spriteNumBg:setVisible(false)
		self.labNum:setVisible(false)
	end
	self.spriteNew:setVisible(false)
end)[gItemType.ICON_CAST_POWER] = true
local (function(self, rewardID, rewardCount)
	if 0 < rewardID and 0 < rewardCount then
		if self.item == nil then
			self.item = display.newNode()
			self.item:setPosition(cc.p(self.btnItem:getContentSize().height / 2 - 2, self.btnItem:getContentSize().height / 2 + 4))
			self.item:addTo(self.btnItem)
			local imgBg = display.newSprite("#frame_item_base_01.png")
			imgBg:setName("Image_bg")
			imgBg:setPosition(cc.p(0, 0))
			imgBg:addTo(self.item)
			local imgView = display.newSprite()
			imgView:setName("Image_item")
			imgView:setPosition(cc.p(imgBg:getContentSize().height / 2, imgBg:getContentSize().height / 2))
			imgView:addTo(imgBg)
			imgView = ccui.ImageView:create("frame_djzs_di.png", ccui.TextureResType.plistType)
			imgView:setName("Image_num")
			imgView:setAnchorPoint(cc.p(0, 0))
			imgView:setPosition(cc.p(0, 2))
			imgView:addTo(imgBg)
			local labelNum = ccui.Text:create()
			labelNum:setFontSize(24)
			labelNum:setName("Text_num")
			labelNum:setAnchorPoint(cc.p(0, 0.5))
			labelNum:setPosition(cc.p(6, 13))
			labelNum:addTo(imgBg)
			SoraDFTarget(labelNum)
			SoraDFTarget(imgView, nil, true)
			SoraDFTarget(imgBg)
			SoraDFTarget(self.item)
			self.item = include("commonItems").new(self.item)
		end
		_ENV = ccui.Text:create()
		ccui.Text:create().itemID = rewardID
		ccui.Text:create().itemCount = rewardCount
		ccui.Text:create().isBig = true
		self.item:initData((ccui.Text:create()))
		self.item:setVisible(true)
		local num = rewardCount
		if num then
			self.spriteNumBg:setVisible(false)
			self.labNum:setVisible(false)
			self.labNum:setString(num)
		else
			self.spriteNumBg:setVisible(false)
			self.labNum:setVisible(false)
		end
	else
		if self.item then
			self.item:setVisible(false)
		end
		self.spriteNumBg:setVisible(false)
		self.labNum:setVisible(false)
	end
	self.spriteNew:setVisible(false)
end)[gItemType.ICON_LEGENDMON_POWER], timeLimitItem = true, function(self, rewardID, rewardCount)
	if 0 < rewardID and 0 < rewardCount then
		if self.item == nil then
			self.item = display.newNode()
			self.item:setPosition(cc.p(self.btnItem:getContentSize().height / 2 - 2, self.btnItem:getContentSize().height / 2 + 4))
			self.item:addTo(self.btnItem)
			local imgBg = display.newSprite("#frame_item_base_01.png")
			imgBg:setName("Image_bg")
			imgBg:setPosition(cc.p(0, 0))
			imgBg:addTo(self.item)
			local imgView = display.newSprite()
			imgView:setName("Image_item")
			imgView:setPosition(cc.p(imgBg:getContentSize().height / 2, imgBg:getContentSize().height / 2))
			imgView:addTo(imgBg)
			imgView = ccui.ImageView:create("frame_djzs_di.png", ccui.TextureResType.plistType)
			imgView:setName("Image_num")
			imgView:setAnchorPoint(cc.p(0, 0))
			imgView:setPosition(cc.p(0, 2))
			imgView:addTo(imgBg)
			local labelNum = ccui.Text:create()
			labelNum:setFontSize(24)
			labelNum:setName("Text_num")
			labelNum:setAnchorPoint(cc.p(0, 0.5))
			labelNum:setPosition(cc.p(6, 13))
			labelNum:addTo(imgBg)
			SoraDFTarget(labelNum)
			SoraDFTarget(imgView, nil, true)
			SoraDFTarget(imgBg)
			SoraDFTarget(self.item)
			self.item = include("commonItems").new(self.item)
		end
		_ENV = ccui.Text:create()
		ccui.Text:create().itemID = rewardID
		ccui.Text:create().itemCount = rewardCount
		ccui.Text:create().isBig = true
		self.item:initData((ccui.Text:create()))
		self.item:setVisible(true)
		local num = rewardCount
		if num then
			self.spriteNumBg:setVisible(false)
			self.labNum:setVisible(false)
			self.labNum:setString(num)
		else
			self.spriteNumBg:setVisible(false)
			self.labNum:setVisible(false)
		end
	else
		if self.item then
			self.item:setVisible(false)
		end
		self.spriteNumBg:setVisible(false)
		self.labNum:setVisible(false)
	end
	self.spriteNew:setVisible(false)
end
function ItemSingleView:limitedTimeItemShow()
	local itemType = backpackltCtrl:getItemType(self.tableItem.itemData.id)
	local labelTime = SoraDGetChildByName(self, "Text_Time")
	if not timeLimitItem[itemType] then
		labelTime:setVisible(false)
		self:ancientItemTimeLimit()
		return
	end
	local isLimitedItem = timeLimitedItemCtrl:getLimitedItem(self.tableItem.itemData.id)
	if itemType == gItemType.ICON_CAST_POWER then
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		for mapid, activityID in pairs(worldMapDefine.LLW_MAPID_ACTID) do
			local param = activityShowCtrl:getParamByID(activityID)
			isLimitedItem = param.timeConfig and param.timeConfig.finishTime
			if isLimitedItem then
				break
			end
		end
	end
	if itemType == gItemType.ICON_LEGENDMON_POWER then
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.LEGEND_HEGEMON_1)
		isLimitedItem = param.timeConfig and param.timeConfig.finishTime
	end
	if isLimitedItem then
		self.spriteNumBg:setVisible(true)
		self.tableItem.itemData.isLimitedItem = isLimitedItem
		self.tableItem.itemData.isInUseLimitedItem = nil
		if itemType == gItemType.PANDORABOX then
			local index = timeLimitedItemCtrl:getPandoraBoxIndex(self.tableItem.itemData.id, isLimitedItem)
			self.tableItem.itemData.pandoraIndex = index
		end
		local beginTimeNum = isLimitedItem - serviceFunctions.systemTime()
		labelTime:beginTime(beginTimeNum)
		labelTime:setVisible(true)
	else
		local isInUseLimitedItem = timeLimitedItemCtrl:getInUseLimitedItem(self.tableItem.itemData.id)
		if isInUseLimitedItem then
			self.spriteNumBg:setVisible(true)
			self.tableItem.itemData.isLimitedItem = nil
			self.tableItem.itemData.isInUseLimitedItem = isInUseLimitedItem
			local beginTimeNum = isInUseLimitedItem - serviceFunctions.systemTime()
			labelTime:beginTime(beginTimeNum)
			labelTime:setVisible(true)
		else
			return
		end
	end
end
function ItemSingleView:ancientItemTimeLimit()
	local spInvalidTime = itemLogic.getSpecailItemInvalidTime(self.tableItem.itemData.id)
	if spInvalidTime ~= false then
		local invalidtime = spInvalidTime or 0
		self.spriteNumBg:setVisible(true)
		local labelTime = SoraDGetChildByName(self, "Text_Time")
		labelTime:beginTime(invalidtime - serviceFunctions.systemTime())
		labelTime:setVisible(true)
	end
end
function ItemSingleView:setScroll(pScroll)
	self.scroll = pScroll
end
function ItemSingleView:setItemClickCallback(callback)
	self.itemClickCallback = callback
end
function ItemSingleView:OnBtnItemClick(button, type)
	if self.itemClickCallback then
		self.itemClickCallback(button, type)
		return
	end
	if not self.isRechargeUse then
		if type == ccui.TouchEventType.ended then
			if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
				print("node is not on view")
				return
			end
			if self.singleIsMoved then
				self.singleIsMoved = false
				return
			end
			SoraDPlaySound()
			self.spriteNew:setVisible(false)
			if self.itemsManagerHandle then
				self.itemsManagerHandle(self)
			end
		elseif type == ccui.TouchEventType.moved then
			local touchBeganPoint = self.btnItem:getTouchBeganPosition()
			local touchmovePoint = self.btnItem:getTouchMovePosition()
			local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
			if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
				self.singleIsMoved = true
			end
		elseif type == ccui.TouchEventType.canceled then
			self.singleIsMoved = false
		end
	elseif type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		if self.pFloor then
			self.pFloor:removeFromParent()
			self.pFloor = nil
		end
	elseif type == ccui.TouchEventType.began and not self.pFloor then
		local pos = self.target:convertToNodeSpace(button:getTouchBeganPosition())
		self:openItem(button, pos)
	end
end
function ItemSingleView:hidenNumLabel()
	self.item:hiddleNum()
	SoraDGetChildByName(self.item, "Image_num"):setVisible(false)
end
function ItemSingleView:openItem(item, pos)
	self.pFloor = SoraDCreatePanel("commonItemTips")
	self.pFloor:initData(item:getTag())
	if SoraDFIsRA() then
		if pos.x < 280 then
			self.pFloor:setPosition(pos.x + 280, pos.y + 40)
		else
			self.pFloor:setPosition(pos.x, pos.y + 40)
		end
	elseif pos.x > 360 then
		self.pFloor:setPosition(pos.x - 280, pos.y + 40)
	else
		self.pFloor:setPosition(pos.x, pos.y + 40)
	end
	if self.target then
		self.pFloor:addTo(self.target, 100)
	end
end
function ItemSingleView:setItemDelegate(handle)
	self.itemsManagerHandle = handle
end
function ItemSingleView:addItemUseEffect(isStop)
	if not isStop then
		if self.effecUse then
			SoraDResetEffectNode(self.effecUse)
			self.effecUse.action:gotoFrameAndPlay(0, 40, false)
		else
			self.effecUse = SoraDCreatAnimationEx("use_item_effect", nil, false)
			local img1 = SoraDGetChildByName(self.effecUse, "dh_Texture_zbdz_004_1")
			local img2 = SoraDGetChildByName(self.effecUse, "dh_Texture_zbdz_004_2")
			local img3 = SoraDGetChildByName(self.effecUse, "dh_Texture_bbsyzy_001_3")
			SoraDMixtureGLONE(img1)
			SoraDMixtureGLONE(img2)
			SoraDMixtureGLONE(img3)
			self.effecUse:setPosition(cc.p(76.5, 76.5))
			self.effecUse:addTo(self.btnItem, 99)
		end
	elseif self.effecUse then
		self.effecUse:removeFromParent()
		self.effecUse = nil
	end
end
function ItemSingleView:updateWearIcon()
	if not self.singleTag then
		self.singleTag = display.newSprite("#icon_jh.png")
		self.singleTag:setAnchorPoint(cc.p(0.5, 0.5))
		self.singleTag:setRotation(90)
		self.singleTag:setScale(0.5)
		self.singleTag:setPosition(cc.p(SoraDFPosX(125, 150), -30))
		self.singleTag:addTo(self, 99)
	end
	local armorSystemCtrl = SoraDGetCtrl("armorSystemCtrl")
	local armyNum = armorSystemCtrl:getArmyNumByArmorId(self.tableItem.itemData.id)
	_ENV = cc.p(SoraDFPosX(125, 150), -30)
	cc.p(SoraDFPosX(125, 150), -30).isArmorID = true
	cc.p(SoraDFPosX(125, 150), -30).armorID = self.tableItem.itemData.id
	self.singleTag:setVisible(SoraDIsBrave8Level(cc.p(SoraDFPosX(125, 150), -30)) and commonCheck.WARFRAME_WEAR and 0 < armyNum)
end
return ItemSingleView
