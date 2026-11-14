local CommonItemUse = class("commonItemUse", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonItemUse")
	end
	return target
end)
function CommonItemUse:ctor()
	self.nodeGold = SoraDGetChildByName(self, "Node_gold")
	self.spriteIcon = SoraDGetChildByName(self, "Sprite_icon")
	self.labelTitle = SoraDGetChildByName(self, "Text_title")
	self.labelGold = SoraDGetChildByName(self, "Text_gold")
	self.goldCount = nil
	self.itemID = 0
	self.baseScale = self.spriteIcon:getScale()
	SoraDAddMessage(self, "MESSAGE_ITEM_UES_FROM_BAG_BACK", function(...)
		self:initData(self.itemID, self.goldCount, self.isShowTotal)
	end)
end
function CommonItemUse:initData(itemID, gold, isShowTotal)
	local gametop = gModuleMgr.getObject("gametop")
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
	local itemDesRead = include("itemDesRead")
	local itemCount = backpackCtrl:getItemCount(itemID)
	self.goldCount = gold
	self.itemID = itemID
	self.isShowTotal = isShowTotal
	if 0 < itemCount then
		if self.isShowTotal then
			_ENV = nil
			;(nil).total = itemCount
			;(nil).cur = 1
			self.labelGold:setString(i18n("common_text_1641", nil))
		else
			self.labelGold:setString("1")
		end
		self.labelGold:setColor(display.COLOR_WHITE)
		self.spriteIcon:setSpriteFrame(itemDesRead.getIcon(itemID))
		self.spriteIcon:setScale(self.baseScale * 55 / self.spriteIcon:getContentSize().height)
		if self.nodeGold then
			SoraDToCenter(self.nodeGold)
		end
		return true
	else
		local price = shopltCtrl:getShopItemByItemID(itemID) and shopltCtrl:getShopItemByItemID(itemID).price or nil
		if price then
			self.labelGold:setString(string.formatnumberthousands(price))
		else
			self.labelGold:setString(string.formatnumberthousands(self.goldCount))
		end
		self.labelGold:setColor(cc.c3b(255, 255, 0))
		self.spriteIcon:setSpriteFrame("icon_small_gold.png")
		self.spriteIcon:setScale(1 * self.baseScale)
		if self.nodeGold then
			SoraDToCenter(self.nodeGold)
		end
		return false
	end
end
return CommonItemUse
