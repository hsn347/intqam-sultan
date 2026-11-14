local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local storesCtrl = SoraDGetCtrl("storesCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local merchanteItemBuyPopBoxPanel = class("merchanteItemBuyPopBoxPanel", baseFguiPanel)
function merchanteItemBuyPopBoxPanel:ctor(...)
	self.super.ctor(self, ...)
	print("merchanteItemBuyPopBoxPanel:ctor", self.viewName)
end
function merchanteItemBuyPopBoxPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function merchanteItemBuyPopBoxPanel:onInit()
	print("=======merchanteItemBuyPopBoxPanel:onInit")
	self.fields.Text_buyTip:setString(i18n("common_text_313"))
	self.fields.Button_buy:addClickListener(handler(self, self.btnBuyClick))
	self.fields.Text_iconDes:fixPos()
	self.fields.com_item:fixPos()
end
function merchanteItemBuyPopBoxPanel:onShow()
	print("=======merchanteItemBuyPopBoxPanel:onShow")
	self.itemData = self.param.itemData
	self:initData()
end
function merchanteItemBuyPopBoxPanel:initData()
	_ENV = nil
	;(nil).name = publicRead.getName(self.itemData.itemId)
	;(nil).count = string.formatnumberthousands(self.itemData.itemNum)
	self.fields.Text_title:setString(i18n("common_text_1460", nil))
	self.fields.Text_iconDes:setString(publicRead.getDes(self.itemData.itemId))
	self.fields.com_item:initData(self.itemData.itemId)
	self.fields.Button_buy:initData(gIDDef.GOLD, self.itemData.price)
	self.isEnoughGold = SoraDEnoughGold(self.itemData.price, true)
	self.fields.Button_buy:setTitleColor(self.isEnoughGold and cc.c3b(255, 251, 213) or cc.c3b(190, 40, 40))
end
function merchanteItemBuyPopBoxPanel:playUseAction(target, data)
	SoraDCloseLoading(self)
	SoraDPopGainItem(self.itemData.itemId, self.itemData.itemNum)
	self:close()
end
function merchanteItemBuyPopBoxPanel:btnBuyClick()
	SoraDPlaySound()
	if SoraDJudgeResOrItem(self.itemData.itemId) then
		local backpack = backpackCtrl:getBackpack(gBackpackDef.PROPS)
		if backpack:full() then
			SoraDShowMsgTip(i18n("notice_0119"))
			return
		end
	end
	if SoraDEnoughGold(self.itemData.price) then
		storesCtrl:purchase(self.itemData.shopItemID)
		SoraDShowLoading(self)
	end
end
return merchanteItemBuyPopBoxPanel
