local coffeeCraftsmanCtrl = SoraDGetCtrl("coffeeCraftsmanCtrl")
local coffeeCraftsmanRead = include("coffeeCraftsmanRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DessertMasterSpoonPanel = class("DessertMasterSpoonPanel", baseFguiPanel)
function DessertMasterSpoonPanel:ctor(...)
	self.super.ctor(self, ...)
	print("DessertMasterSpoonPanel:ctor", self.viewName)
end
function DessertMasterSpoonPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CoffeeCraftsman"
	end
	return self._packageList
end
function DessertMasterSpoonPanel:onInit()
	print("=======DessertMasterSpoonPanel:onInit")
	self.payType = 1
	self.fields.Com_title:setString(i18n("Dessertmaster_03"))
	self.fields.List_item:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Image_banner:setURL("bg_activity_9001352_2.png")
	local activityTimeRead = include("activityTimeRead")
	self.rechargeIDs = activityTimeRead.getRechargeId(coffeeCraftsmanCtrl.activityID, coffeeCraftsmanRead.getGroup())
	dump(self.rechargeIDs, "self.rechargeIDs")
	_ENV = "self.rechargeIDs"
	_ENV, _ENV, ("self.rechargeIDs").defaultClick = coffeeCraftsmanRead.getGroup()
	_ENV, coffeeCraftsmanRead.getGroup()[1], coffeeCraftsmanRead.getGroup().title = coffeeCraftsmanRead.getGroup()
	_ENV = coffeeCraftsmanRead.getGroup()
	coffeeCraftsmanRead.getGroup().item = include("publicRead").getName(TOKEN_ITEM)
	;("self.rechargeIDs").tabsetArray, coffeeCraftsmanRead.getGroup()[2], coffeeCraftsmanRead.getGroup().title = coffeeCraftsmanRead.getGroup()
	;("self.rechargeIDs").callback = handler(self, self.onClickTab)
	self.fields.com_TabW:initView("self.rechargeIDs")
	self.controllers.c1:setSelectedIndex(SoraDCheckOAPIsOpen() and 1 or 0)
end
function DessertMasterSpoonPanel:onItemRenderer(index, obj)
	obj:initData(self.rechargeIDs[index + 1], self.payType)
end
function DessertMasterSpoonPanel:onShow()
	print("=======DessertMasterSpoonPanel:onShow")
	self:updateView()
end
function DessertMasterSpoonPanel:isOpenRechargeGift()
	local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
	for _, v in ipairs(self.rechargeIDs) do
		local rewardList = rechargeActivityCtrl:getRechargeGift(v)
		if next(rewardList) then
			return true
		end
	end
	return false
end
function DessertMasterSpoonPanel:updateView()
	self.fields.List_item:setNumItems(#self.rechargeIDs)
	local _ENV, idList = self.fields.List_item.setNumItems, self.fields.List_item.setNumItems
	for i, v in ipairs(self.rechargeIDs) do
		_ENV = nil
		;(nil).rechargeID = v
		table.insert(idList, nil)
	end
	self.fields.Com_rechargeGiftNode:initData(idList)
end
function DessertMasterSpoonPanel:onHide()
	print("=======DessertMasterSpoonPanel:onHide")
end
function DessertMasterSpoonPanel:onDispose()
	print("=======DessertMasterSpoonPanel:onDispose")
end
function DessertMasterSpoonPanel:onClickTab(tag)
	self.payType = tag
	self.fields.List_item:setNumItems(#self.rechargeIDs)
end
return DessertMasterSpoonPanel
