local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local activityExchangeMallRead = include("activityExchangeMallRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroWeaponShopPanel = class("HeroWeaponShopPanel", baseFguiPanel)
function HeroWeaponShopPanel:ctor(...)
	HeroWeaponShopPanel.super.ctor(self, ...)
	print("HeroWeaponShopPanel:ctor", self.viewName)
end
function HeroWeaponShopPanel:onInit()
	print("=======HeroWeaponShopPanel:onInit")
	self.activityID = gActivityTimeActivityID.HERO_WEAPON_EXCHANGE_STORE
	self.listData, _ENV, self.coinID = gActivityTimeActivityID.HERO_WEAPON_EXCHANGE_STORE, gActivityTimeActivityID.HERO_WEAPON_EXCHANGE_STORE, 225201
	self.fields.Com_title:initData(i18n("HeroWeapon_31"), handler(self, self.onClickClose))
	self.timer = SoraDCreateTimerLabel(self, self.fields.timer)
	self.timer:setTimeLast(function(strTime)
		_ENV = nil
		;(nil).time = fguiHelper.getColorString("#FFFFFF", strTime)
		return i18n("HeroWeapon_40", nil)
	end)
	self.fields.Com_coin:setIcon(publicRead.getIcon(self.coinID))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function HeroWeaponShopPanel:onShow()
	print("=======HeroWeaponShopPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	local remainTime = serviceFunctions.getNextWeekDayUTC(1) - serviceFunctions.systemTime()
	self.timer:beginTime(remainTime)
	self:initData()
end
function HeroWeaponShopPanel:onItemRenderer(index, obj)
	obj:initData(self.listData[index + 1])
end
function HeroWeaponShopPanel:newDayUpdate(target, data)
	self:initData()
	local remainTime = serviceFunctions.getNextWeekDayUTC(1) - serviceFunctions.systemTime()
	self.timer:beginTime(remainTime)
end
function HeroWeaponShopPanel:initData()
	self.fields.Com_coin:setTitle(backpackCtrl:getItemCount(self.coinID))
	self.listData = activityExchangeMallRead:getShopItemList(self.activityID)
	table.sort(self.listData, function(a, b)
		local leftA = a.limitnum - activityExchangeMallCtrl:getExchangeNum(self.activityID, a.shopItemID)
		local leftB = b.limitnum - activityExchangeMallCtrl:getExchangeNum(self.activityID, b.shopItemID)
		if 0 < leftA and 0 < leftB or leftA <= 0 and leftB <= 0 then
			return a.shopItemID < b.shopItemID
		else
			return 0 < leftA
		end
	end)
	self.fields.List:setNumItems(#self.listData)
end
return HeroWeaponShopPanel
