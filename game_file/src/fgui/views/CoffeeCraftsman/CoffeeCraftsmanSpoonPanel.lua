local coffeeCraftsmanCtrl = SoraDGetCtrl("coffeeCraftsmanCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CoffeeCraftsmanSpoonPanel = class("CoffeeCraftsmanSpoonPanel", baseFguiPanel)
function CoffeeCraftsmanSpoonPanel:ctor(...)
	self.super.ctor(self, ...)
	print("CoffeeCraftsmanSpoonPanel:ctor", self.viewName)
end
function CoffeeCraftsmanSpoonPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CoffeeCraftsman"
	end
	return self._packageList
end
function CoffeeCraftsmanSpoonPanel:onInit()
	print("=======CoffeeCraftsmanSpoonPanel:onInit")
	self.payType = 1
	self.fields.Com_title:setString(i18n("coffeeCraftsman_text_03"))
	self.fields.List_item:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Image_banner:setURL("bg_activity_9001352.png")
	local activityTimeRead = include("activityTimeRead")
	self.rechargeIDs = activityTimeRead.getRechargeId(coffeeCraftsmanCtrl.activityID)
	_ENV = handler(self, self.onItemRenderer)
	_ENV, _ENV, handler(self, self.onItemRenderer).defaultClick = handler(self, self.onItemRenderer)
	_ENV, handler(self, self.onItemRenderer)[1], handler(self, self.onItemRenderer).title = handler(self, self.onItemRenderer)
	_ENV = handler(self, self.onItemRenderer)
	handler(self, self.onItemRenderer).item = include("publicRead").getName(TOKEN_ITEM)
	handler(self, self.onItemRenderer).tabsetArray, handler(self, self.onItemRenderer)[2], handler(self, self.onItemRenderer).title = handler(self, self.onItemRenderer)
	handler(self, self.onItemRenderer).callback = handler(self, self.onClickTab)
	self.fields.com_TabW:initView(handler(self, self.onItemRenderer))
	self.controllers.c1:setSelectedIndex(SoraDCheckOAPIsOpen() and 1 or 0)
end
function CoffeeCraftsmanSpoonPanel:onItemRenderer(index, obj)
	obj:initData(self.rechargeIDs[index + 1], self.payType)
end
function CoffeeCraftsmanSpoonPanel:onShow()
	print("=======CoffeeCraftsmanSpoonPanel:onShow")
	self:updateView()
end
function CoffeeCraftsmanSpoonPanel:isOpenRechargeGift()
	local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
	for _, v in ipairs(self.rechargeIDs) do
		local rewardList = rechargeActivityCtrl:getRechargeGift(v)
		if next(rewardList) then
			return true
		end
	end
	return false
end
function CoffeeCraftsmanSpoonPanel:updateView()
	self.fields.List_item:setNumItems(#self.rechargeIDs)
	local _ENV, idList = self.fields.List_item.setNumItems, self.fields.List_item.setNumItems
	for i, v in ipairs(self.rechargeIDs) do
		_ENV = nil
		;(nil).rechargeID = v
		table.insert(idList, nil)
	end
	self.fields.Com_rechargeGiftNode:initData(idList)
end
function CoffeeCraftsmanSpoonPanel:onHide()
	print("=======CoffeeCraftsmanSpoonPanel:onHide")
end
function CoffeeCraftsmanSpoonPanel:onDispose()
	print("=======CoffeeCraftsmanSpoonPanel:onDispose")
end
function CoffeeCraftsmanSpoonPanel:onClickTab(tag)
	self.payType = tag
	self.fields.List_item:setNumItems(#self.rechargeIDs)
end
return CoffeeCraftsmanSpoonPanel
