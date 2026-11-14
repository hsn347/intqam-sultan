local attributeSystem = include("attributeSystem")
local technologyCtrl = _G.SoraDGetCtrl("technologyCtrl")
local royalSummonsShopSingleCommon = class("royalSummonsShopSingleCommon", function(target)
	if target == nil then
		return SoraDCreateBasePanel("royalSummonsShopSingleCommon")
	end
	return target
end)
local publicRead = include("publicRead")
local colorRed = cc.c3b(255, 0, 0)
local colorYellow = cc.c3b(254, 255, 1)
local colorBlue = cc.c3b(200, 221, 255)
function royalSummonsShopSingleCommon:ctor()
	self.text_num = SoraDGetChildByName(self, "text_num")
	self.text_name = SoraDGetChildByName(self, "text_name")
	self.icon_buy = SoraDGetChildByName(self, "icon_buy")
	self.text_buy = SoraDGetChildByName(self, "text_buy")
	self.item = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItemAward")
	self.btn_operate = SoraDGetChildByName(self, "btn_operate")
	self.btn_operate:addTouchEventListener(handler(self, self.onClick_btn_operate))
	self.btn_operate:setSwallowTouches(false)
end
function royalSummonsShopSingleCommon:initData_imp(data, otherData)
	self.itemData = data
	if otherData then
		self.parentPannel = otherData.view
		self.ownScroll = otherData.scroll
		self.scroll = otherData.scroll
	end
	self.addNum = 0
	self.isLimitBuy = self.itemData.limitType ~= 0
	self.amberNum = self.itemData.limitnum
	if self.itemData.exchangeitem == 1609 then
		local gametop = gModuleMgr.getObject("gametop")
		local buffCtrl = gametop.playertop_:getModule("buffCtrl")
		local buffPlus = buffCtrl:getBuffEffect(gBuffEffect.RADIANCE_STAR_SHINE_EXCHANGE_LIMIT) or 0
		self.addNum = math.floor(self.amberNum * (buffPlus / 1000))
		self.amberNum = self.amberNum + self.addNum
	end
	if self.itemData.itemId == gBadgeItemID.AMBER_ID then
		self.addNum = technologyCtrl:getTechnologyPower(gTechnologyType.RADIANCE_WAR_SHOP_BUY_STONE_NUM_ADD) or 0
		self.amberNum = self.amberNum + self.addNum
	end
	_ENV = self.amberNum + self.addNum
	local (self.amberNum + self.addNum).shopItemID, attrFilter = self.itemData.shopItemID, self.amberNum + self.addNum
	local attrValue = attributeSystem.query(gAttributeEnum.ACTIVITY_EXCHANGE_LIMIT_UP, attrFilter, gAttributeSourceEnum.EQUIPMENT)
	self.amberNum = self.amberNum + attrValue
	self.canBuyNum = self.amberNum - (self.itemData.buyNum or 0)
	self:initView()
end
function royalSummonsShopSingleCommon:initView()
	local itemId = self.itemData.itemId
	self.text_name:setString(publicRead.getName(itemId))
	self.item:initData(itemId)
	self.item:setBaseScale(1.0)
	self.item:setOwnScroll(self.scroll)
	publicRead = publicRead.getName(itemId)
	publicRead.getName(itemId).cur = string.formatnumberthousands(self.itemData.buyNum or 0)
	publicRead.getName(itemId).total = string.formatnumberthousands(self.amberNum)
	self.text_num:setString(i18n("common_text_4417", publicRead.getName(itemId)))
	self.text_buy:setString(string.formatnumberthousands(self.itemData.exchangenum))
	self.text_buy:setColor(colorYellow)
	self.text_num:setColor(colorBlue)
	if self.itemData.hasExchangeNum < self.itemData.exchangenum then
		self.text_buy:setColor(colorRed)
	end
	if 0 >= self.canBuyNum then
		self.text_num:setColor(colorRed)
	end
	self.text_num:setVisible(self.isLimitBuy)
	self.icon_buy:loadTexture(publicRead.getIcon(self.itemData.exchangeType), ccui.TextureResType.plistType)
end
function royalSummonsShopSingleCommon:setMode(canBuy)
	self.btn_operate:setBright(canBuy)
	self.btn_operate:setTouchEnabled(canBuy)
end
function royalSummonsShopSingleCommon:onClick_btn_operate(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("点击到了")
		if self.scroll and not SoraDIsNodeVisibleOnScroll(sender, self.scroll) then
			print("不在范围内")
			return
		end
		self:onClickOperate()
	end
end
function royalSummonsShopSingleCommon:showBuyView()
	local needNum = self.itemData.exchangenum
	local total = self.amberNum
	local cur = self.itemData.buyNum
	local maxCount = total - cur
	local canBuyCount = math.floor(self.itemData.hasExchangeNum / needNum)
	maxCount = math.min(maxCount, canBuyCount)
	_ENV, _ENV, _ENV = nil, nil, nil
	;(nil).targetID = self.itemData.itemId
	;(nil).exchangeID = self.itemData.exchangeType
	;(nil).singCount = needNum
	;(nil).curNum = maxCount
	;(nil).exchangeData, (nil).huntCount = nil, self.shopitemnum
	;(nil).exchangeCfg, (nil).exchangeHandler = nil, function(num)
		if not tolua.isnull(self) then
			self:onBuyItem(self.itemData, num)
		end
	end
	uiManager:show("newShopSingleBuy", nil)
end
function royalSummonsShopSingleCommon:changeBtnIcon(img)
	self.icon_buy:loadTexture(img, ccui.TextureResType.plistType)
end
function royalSummonsShopSingleCommon:setFather(_father)
	self.parentPannel = _father
end
return royalSummonsShopSingleCommon
