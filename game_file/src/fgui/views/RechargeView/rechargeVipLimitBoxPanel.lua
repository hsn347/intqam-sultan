local premiumStoreCtrl = SoraDGetCtrl("premiumStoreCtrl")
local publicRead = include("publicRead")
local vipLocalData = include("vipLocalData")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local rechargeVipLimitBoxPanel = class("rechargeVipLimitBoxPanel", baseFguiPanel)
function rechargeVipLimitBoxPanel:ctor(...)
	self.super.ctor(self, ...)
	print("rechargeVipLimitBoxPanel:ctor", self.viewName)
end
function rechargeVipLimitBoxPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function rechargeVipLimitBoxPanel:onInit()
	print("=======rechargeVipLimitBoxPanel:onInit")
	self.list, _ENV = print, print
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
	self.fields.item:fixPos()
	self.fields.Text_des:fixPos()
end
function rechargeVipLimitBoxPanel:onListRenderer(index, obj)
	obj:initData(self.list[index + 1], index + 1)
end
function rechargeVipLimitBoxPanel:onShow()
	print("=======rechargeVipLimitBoxPanel:onShow")
	self.itemData = self.param.itemData
	self:initData()
end
function rechargeVipLimitBoxPanel:initData()
	self.list, publicRead = nil, nil
	self.fields.Panel_bg:setString(publicRead.getName(self.itemData.commodityID))
	self.fields.item:initData(self.itemData.commodityID)
	self.fields.Text_des:setString(publicRead.getDes(self.itemData.commodityID))
	publicRead = publicRead.getDes(self.itemData.commodityID)
	publicRead.getDes(self.itemData.commodityID).itemData = self.itemData
	publicRead.getDes(self.itemData.commodityID).isGold = true
	table.insert(self.list, publicRead.getDes(self.itemData.commodityID))
	if gPremiumUnlockType.meetVip == self.itemData.unlocktype or gPremiumUnlockType.meetGoldOrVip == self.itemData.unlocktype or gPremiumUnlockType.both == self.itemData.unlocktype then
		publicRead = publicRead.getDes(self.itemData.commodityID)
		publicRead.getDes(self.itemData.commodityID).itemData = self.itemData
		table.insert(self.list, publicRead.getDes(self.itemData.commodityID))
	end
	self.fields.List:setNumItems(#self.list)
end
return rechargeVipLimitBoxPanel
