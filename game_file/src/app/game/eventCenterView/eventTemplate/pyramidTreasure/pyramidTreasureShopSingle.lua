local pyramidRareTreasureCtrl = SoraDGetCtrl("pyramidRareTreasureCtrl")
local gametop = gModuleMgr.getObject("gametop")
local activityExchangeMallCtrl = gametop.playertop_:getModule("activityExchangeMallCtrl")
local publicRead = include("publicRead")
local pyramidTreasureShopSingle = class("pyramidTreasureShopSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("pyramidTreasureShopSingle")
	end
	return target
end)
function pyramidTreasureShopSingle:ctor()
	self.isEnough, _ENV, self.isLimit, _ENV = nil, nil, nil, nil
	self.Node_1 = SoraDGetChildByName(self, "Node_1")
	self.Node_1:setVisible(false)
	self.Node_2 = SoraDGetChildByName(self, "Node_2")
	self.Node_2:setVisible(false)
	self.Node_et1 = SoraDGetChildByName(self, "Node_et1")
	self.Node_et2 = SoraDGetChildByName(self, "Node_et2")
end
function pyramidTreasureShopSingle:initData(data, otherData)
	self.item1 = data.item1
	self.item2 = data.item2
	self.scroll = otherData.scroll
	self.view = otherData.view
	if self.item1 then
		self:setItemInfo(self.Node_1, self.item1, 1)
		self.Node_1:setVisible(true)
	else
		self.Node_1:setVisible(false)
	end
	if self.item2 then
		self:setItemInfo(self.Node_2, self.item2, 2)
		self.Node_2:setVisible(true)
	else
		self.Node_2:setVisible(false)
	end
	local isJS = data.sort % 2 == 1
	self.Node_et1:setVisible(isJS)
	self.Node_et2:setVisible(not isJS)
end
function pyramidTreasureShopSingle:setItemInfo(target, itemInfo, tag)
	local ccs_item = SoraDGetExtendChildFromCCSByName(target, "CCS_commonItemAward_item")
	local Text_name = SoraDGetChildByName(target, "Text_name")
	local Text_limit = SoraDGetChildByName(target, "Text_limit")
	local Button_buy = SoraDGetChildByName(target, "Button_buy")
	local Node_gold = SoraDGetChildByName(target, "Node_gold")
	local Text_gold = SoraDGetChildByName(target, "Text_gold")
	local icon = SoraDGetChildByName(target, "icon")
	ccs_item:setOwnView(self.view)
	ccs_item:setOwnScroll(self.scroll)
	ccs_item:initData(itemInfo.shopitem, itemInfo.shopitemnum)
	ccs_item:setScale(1.2)
	ccs_item:setBaseScale(1.0)
	Button_buy:setTag(tag)
	Button_buy:addTouchEventListener(handler(self, self.onBuyClick))
	Text_name:setString(publicRead.getName(itemInfo.shopitem))
	local buyNum = activityExchangeMallCtrl:getExchangeNum(gActivityTimeActivityID.PYRAMID_TREASURE_ACTIVITY, itemInfo.shopItemID)
	self.isLimit[tag] = buyNum >= itemInfo.limitnum
	_ENV = publicRead.getName(itemInfo.shopitem)
	publicRead.getName(itemInfo.shopitem).cur = buyNum
	publicRead.getName(itemInfo.shopitem).total = itemInfo.limitnum
	Text_limit:setString(i18n("common_text_4417", publicRead.getName(itemInfo.shopitem)))
	Text_limit:setColor(self.isLimit[tag] and cc.c3b(190, 40, 40) or cc.c3b(150, 135, 115))
	Text_gold:setString(itemInfo.exchangenum)
	icon:loadTexture(publicRead.getIcon(itemInfo.exchangeitem), ccui.TextureResType.plistType)
	SoraDToCenter(Node_gold)
	Button_buy:setBright(not self.isLimit[tag])
	local coin = pyramidRareTreasureCtrl:getUnLockLuckyCoin()
	self.isEnough[tag] = coin >= itemInfo.exchangenum
	Text_gold:setColor(self.isEnough[tag] and cc.c3b(255, 255, 255) or cc.c3b(190, 40, 40))
end
function pyramidTreasureShopSingle:onBuyClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.tag = button:getTag()
		if self.isLimit[self.tag] then
			SoraDShowMsgTip(i18n("common_text_4445"))
			return
		end
		if not self.isEnough[self.tag] then
			SoraDShowMsgTip(i18n("common_text_2512"))
			return
		end
		self:showBuyView()
	end
end
function pyramidTreasureShopSingle:onBuyItem(data, num)
	print("选择了数量:", num)
	activityExchangeMallCtrl:reqActivityExchange(data.shopItemID, num)
	SoraDShowLoading(self.view)
end
function pyramidTreasureShopSingle:showBuyView()
	local itemData = self.tag == 1 and self.item1 or self.item2
	dump(itemData, "itemData===")
	local needNum = itemData.exchangenum
	local total = itemData.limitnum
	local cur = activityExchangeMallCtrl:getExchangeNum(gActivityTimeActivityID.PYRAMID_TREASURE_ACTIVITY, itemData.shopItemID)
	local maxCount = total - cur
	local coin = pyramidRareTreasureCtrl:getUnLockLuckyCoin()
	local canBuyCount = math.floor(coin / needNum)
	maxCount = math.min(maxCount, canBuyCount)
	_ENV, _ENV, _ENV = nil, nil, nil
	;(nil).targetID = itemData.shopitem
	;(nil).exchangeID = itemData.exchangeitem
	;(nil).singCount = itemData.exchangenum
	;(nil).curNum = maxCount
	;(nil).exchangeData, (nil).singleGet = nil, itemData.shopitemnum
	;(nil).exchangeCfg, (nil).exchangeHandler = nil, function(num)
		self:onBuyItem(itemData, num)
	end
	uiManager:show("newShopSingleBuy", nil)
end
return pyramidTreasureShopSingle
