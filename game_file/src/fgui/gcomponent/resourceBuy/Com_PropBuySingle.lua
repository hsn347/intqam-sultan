local publicRead = include("publicRead")
local itemLogic = include("itemLogic")
local baseComponent = require("fgui.base.baseComponent")
local Com_PropBuySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://resourceBuy/Com_PropBuySingle", Com_PropBuySingle)
function Com_PropBuySingle:onInit()
	self.fields.Button_use:setString(i18n("common_text_314"))
	self.fields.Button_use:addClickListener(handler(self, self.btnUseClick))
	self.fields.Btn_buyUse:addClickListener(handler(self, self.btnBuyUseClick))
	self.fields.item:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_des:fixPos()
	self.fields.Button_use:fixPos()
	self.fields.Btn_buyUse:fixPos()
end
function Com_PropBuySingle:onShow()
end
function Com_PropBuySingle:initData(data, itemType)
	self.data = data
	self.itemType = itemType
	if self.data.limitData then
		self.fields.item:initData(self.data.iid)
		_ENV = nil
		;(nil).member = self.data.limitData.cur
		;(nil).total = self.data.limitData.max
		self.fields.item:setNumText(i18n("common_text_155", nil))
	else
		self.fields.item:initData(self.data.iid, self.data.count or 0)
	end
	self.fields.Text_name:setString(publicRead.getName(self.data.iid))
	self.fields.Text_des:setString(publicRead.getDes(self.data.iid))
	if self.data.count and self.data.count > 0 then
		self.fields.Button_use:setVisible(true)
		self.fields.Btn_buyUse:setVisible(false)
	else
		self.fields.Button_use:setVisible(false)
		self.fields.Btn_buyUse:setVisible(true)
		self.fields.Btn_buyUse:setCostTitle(self.data.gold or 0)
	end
	if self.data.isBuyOnly then
		self.fields.Btn_buyUse:setString(i18n("common_text_282"))
		self.fields.Btn_buyUse:setVisible(true)
		self.fields.Button_use:setVisible(false)
		if self.data.buyCount then
			self.fields.Text_name:setString(self.data.buyCount .. "x " .. publicRead.getName(self.data.iid))
		end
	end
	if self.data.isbattleExclusive then
		self.fields.Btn_buyUse:setCostTitle(0)
		self.fields.Btn_buyUse:setString(i18n("common_text_4347"))
	end
end
function Com_PropBuySingle:btnUseClick()
	SoraDPlaySound()
	itemLogic.useItemsLine(self.data.iid, self.data.count or 0)
end
function Com_PropBuySingle:btnBuyUseClick()
	SoraDPlaySound()
	if SoraDEnoughGold(self.data.gold or 0) then
		local itemInfo = gModuleMgr.sharedMgr("shopltCtrl"):getShopItemByShopItem(self.data.shopID)
		print("self.data.shopID", self.data.shopID)
		if itemInfo then
			_ENV = nil
			;(nil).quickBuyData = itemInfo
			;(nil).useAndBuy = self.itemType == gItemType.ORANGE_EQUIP_MATERIAL_BOX
			uiManager:show("newShopSingleBuy", nil)
		else
			SoraDShowMsgTip(i18n("notice_0170"))
		end
	end
end
return Com_PropBuySingle
