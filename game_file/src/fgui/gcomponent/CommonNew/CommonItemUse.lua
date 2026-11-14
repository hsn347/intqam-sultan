local Button_cost = require("fgui.gcomponent.CommonNew.Button_cost")
local CommonItemUse = fgui.extension_class(fgui.GButton, Button_cost)
fgui.register_extension("ui://CommonNew/CommonItemUse", CommonItemUse)
function CommonItemUse:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ITEM_UES_FROM_BAG_BACK", function()
		self:initData(self.itemID, self.goldCount, self.isShowTotal)
	end)
end
function CommonItemUse:initData(itemID, gold, isShowTotal)
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
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
			self.fields.Text_gold:setString(i18n("common_text_1641", nil))
		else
			self.fields.Text_gold:setString("1")
		end
		self.fields.Text_gold:setColor(display.COLOR_WHITE)
		self.fields.Icon_gold:setURL(itemDesRead.getIcon(itemID))
		return true
	else
		local price = shopltCtrl:getShopItemByItemID(itemID) and shopltCtrl:getShopItemByItemID(itemID).price or nil
		if price then
			self.fields.Text_gold:setString(string.formatnumberthousands(price))
		else
			self.fields.Text_gold:setString(string.formatnumberthousands(self.goldCount))
		end
		self.fields.Text_gold:setColor(cc.c3b(255, 255, 0))
		self.fields.Icon_gold:setURL("icon_small_gold.png")
		return false
	end
end
return CommonItemUse
