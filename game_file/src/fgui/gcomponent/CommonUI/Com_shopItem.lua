local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local newExchangeMallCtrl = SoraDGetCtrl("newExchangeMallCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_shopItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonUI/Com_shopItem", Com_shopItem)
function Com_shopItem:onInit()
	self.fields.Button_buy:addClickListener(handler(self, self.btnClickBuy))
	self:fixChildrenPos()
end
function Com_shopItem:onShow()
end
function Com_shopItem:initData(data, otherData)
	self.data = data
	self.shopItemID = self.data.shopitem[1]
	self.shopItemCount = self.data.shopitem[2]
	self.exchangeItemID = self.data.exchangeitem[1]
	self.exchangeItemCount = self.data.exchangeitem[2]
	if not otherData then
		otherData, publicRead = self.data.exchangeitem[2], self.data.exchangeitem[2]
	end
	if otherData.addCallback then
		self:setAddCallBack(otherData.addCallback)
	end
	self.fields.com_item:initData(self.shopItemID, self.shopItemCount)
	self.fields.Text_Name:setString(publicRead.getName(self.shopItemID))
	local curExchangeNum = self.data.curExchangeNum or 0
	self.leftTimes = math.max(0, self.data.limitnum - curExchangeNum)
	publicRead = publicRead.getName(self.shopItemID)
	publicRead.getName(self.shopItemID).var1 = fguiHelper.getColorString(0 < self.leftTimes and "#D7C39B" or "#FF0000", self.leftTimes)
	publicRead.getName(self.shopItemID).var2 = self.data.limitnum
	self.fields.Text_Limit:setString(i18n("%{var1}/%{var2}", publicRead.getName(self.shopItemID)))
	self.fields.Button_buy:initData(self.exchangeItemID, self.exchangeItemCount)
	self.fields.Button_buy:setEnabled(0 < self.leftTimes)
end
function Com_shopItem:btnClickBuy()
	SoraDPlaySound()
	if self.leftTimes <= 0 then
		return
	end
	local itemCount = backpackCtrl:getItemCount(self.exchangeItemID)
	if itemCount < self.exchangeItemCount then
		SoraDShowMsgTip(i18n("migrant_move_text76"))
		if self.addCallback then
			self.addCallback(self.exchangeItemID)
		else
			_ENV = i18n("migrant_move_text76")
			i18n("migrant_move_text76").itemID = self.exchangeItemID
			uiManager:show("CommonSourceGuide", i18n("migrant_move_text76"))
		end
		return
	end
	local maxNum = math.floor(itemCount / self.exchangeItemCount)
	maxNum = math.min(maxNum, self.leftTimes)
	_ENV, _ENV, _ENV = i18n("migrant_move_text76")
	i18n("migrant_move_text76").targetID = self.shopItemID
	i18n("migrant_move_text76").singleGet = self.shopItemCount
	i18n("migrant_move_text76").exchangeID = self.exchangeItemID
	i18n("migrant_move_text76").singCount = self.exchangeItemCount
	i18n("migrant_move_text76").exchangeData, i18n("migrant_move_text76").curNum = i18n("migrant_move_text76")
	self.exchangeItemID.exchangeCfg, i18n("migrant_move_text76").exchangeHandler = i18n("migrant_move_text76")
	uiManager:show("newShopSingleBuy", self.exchangeItemID)
end
function Com_shopItem:setAddCallBack(addCallback)
	self.addCallback = addCallback
end
return Com_shopItem
