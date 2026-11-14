local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local shopCtrl = SoraDGetCtrl("shopCtrl")
local publicRead = include("publicRead")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local List_item = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/List_item", List_item)
function List_item:onInit()
	self.fields.Btn_use:setString(i18n("common_text_314"))
	self.fields.Btn_use:addClickListener(handler(self, self.btnUseClick))
	self.fields.Btn_buyAndUse:setString(i18n("common_text_4436"))
	self.fields.Btn_buyAndUse:addClickListener(handler(self, self.btnBuyAndUseClick))
	self.fields.Btn_buyAndUse:setVisible(false)
	self:fixChildrenPos()
end
function List_item:onShow()
end
function List_item:initData(_itemID, enum)
	self.itemID = _itemID
	self.enum = enum
	self.itemNum = backpackCtrl:getItemCount(self.itemID)
	self.gold = nil
	self.fields.Text_num:setString(self.itemNum)
	self.fields.com_item:initData(self.itemID)
	self.fields.com_item:setSpecialNum()
	self.fields.Text_name:setString(publicRead.getName(self.itemID))
	self.fields.Text_des:setString(publicRead.getDes(self.itemID))
	self.fields.Btn_buyAndUse:setVisible(self.itemNum <= 0)
	self.fields.Btn_use:setVisible(self.itemNum > 0)
	if self.itemNum <= 0 then
		local itemInfo = shopltCtrl:getShopItemByItemID(self.itemID)
		local price = self:getShowPrice()
		self.fields.Btn_buyAndUse:setCostTitle(price)
		self.gold = price
		local limitInfo = itemInfo and shopCtrl:getLimitDataByID(itemInfo.shopItemID)
		if limitInfo then
			backpackCtrl = publicRead.getDes(self.itemID)
			publicRead.getDes(self.itemID).member = limitInfo.cur
			publicRead.getDes(self.itemID).total = limitInfo.max
			self.fields.com_item:setNumText(i18n("common_text_155", publicRead.getDes(self.itemID)))
		else
			self.fields.com_item:setNumText()
		end
	end
end
function List_item:getShowPrice()
	local itemInfo = shopltCtrl:getShopItemByItemID(self.itemID)
	if itemInfo.isLadder == 1 and itemInfo.ladderPrice then
		local limitInfo = shopCtrl:getLimitDataByID(itemInfo.shopItemID)
		return shopltCtrl:getLadderPrice(itemInfo.shopItemID, (limitInfo.buyCount or 0) + 1)
	end
	return itemInfo.price
end
function List_item:btnUseClick()
	SoraDPlaySound()
	include("itemLogic").useItemsLine(self.itemID, self.itemNum)
end
function List_item:btnBuyAndUseClick()
	SoraDPlaySound()
	local buyItem = function(itemID)
		local itemInfo = shopltCtrl:getShopItemByItemID(itemID)
		if itemInfo then
			shopltCtrl = nil
			;(nil).itemData = itemInfo
			;(nil).useAndBuy = true
			uiManager:show("newShopSingleBuy", nil)
		else
			SoraDShowMsgTip(i18n("notice_0170"))
		end
	end
	if self.gold and SoraDEnoughGold(self.gold) then
		buyItem(self.itemID)
	end
end
return List_item
