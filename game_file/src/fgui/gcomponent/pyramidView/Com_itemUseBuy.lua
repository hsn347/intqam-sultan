local publicRead = include("publicRead")
local itemLogic = include("itemLogic")
local shopCtrl = SoraDGetCtrl("shopCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_itemUseBuy = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://pyramidView/Com_itemUseBuy", Com_itemUseBuy)
function Com_itemUseBuy:onInit()
	self.fields.Button_use:setString(i18n("common_text_314"))
	self.fields.Button_use:addClickListener(handler(self, self.btnUseClick))
	self.fields.Btn_buyUse:setString(i18n("common_text_4436"))
	self.fields.Btn_buyUse:addClickListener(handler(self, self.btnBuyUseClick))
	self.fields.item:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_des:fixPos()
	self.fields.Button_use:fixPos()
	self.fields.Btn_buyUse:fixPos()
end
function Com_itemUseBuy:onShow()
end
function Com_itemUseBuy:initData(data)
	self.itemID = data.iid
	self.count = data.count or 0
	self.gold = data.gold or 0
	self.shopID = data.shopID
	self.fields.item:initData(self.itemID)
	self.fields.item:setNumText(self.count)
	self.fields.Text_name:setString(publicRead.getName(self.itemID))
	self.fields.Text_des:setString(publicRead.getDes(self.itemID))
	if self.count > 0 then
		self.fields.Button_use:setVisible(true)
		self.fields.Btn_buyUse:setVisible(false)
	else
		self.fields.Button_use:setVisible(false)
		self.fields.Btn_buyUse:setVisible(true)
		self.fields.Btn_buyUse:setCostTitle(self.gold)
	end
end
function Com_itemUseBuy:btnUseClick()
	SoraDPlaySound()
	itemLogic.useItemsLine(self.itemID, self.count)
end
function Com_itemUseBuy:btnBuyUseClick()
	SoraDPlaySound()
	if SoraDEnoughGold(self.gold) then
		local itemInfo = gModuleMgr.sharedMgr("shopltCtrl"):getShopItemByShopItem(self.shopID)
		if itemInfo then
			_ENV = nil
			;(nil).itemData = itemInfo
			;(nil).useAndBuy = true
			uiManager:show("newShopSingleBuy", nil)
		else
			SoraDShowMsgTip(i18n("notice_0170"))
		end
	end
end
return Com_itemUseBuy
