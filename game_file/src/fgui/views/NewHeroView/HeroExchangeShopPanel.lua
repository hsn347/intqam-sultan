local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local activityExchangeMallRead = include("activityExchangeMallRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroExchangeShopPanel = class("HeroExchangeShopPanel", baseFguiPanel)
function HeroExchangeShopPanel:ctor(...)
	HeroExchangeShopPanel.super.ctor(self, ...)
	print("HeroExchangeShopPanel:ctor", self.viewName)
end
function HeroExchangeShopPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "bagView"
	end
	return self._packageList
end
function HeroExchangeShopPanel:onInit()
	print("=======HeroExchangeShopPanel:onInit")
	self.tag = 1
	self.shopList, _ENV, self.activityID = gActivityTimeActivityID.HERO_CHIP_EXCHANGE_STORE, gActivityTimeActivityID.HERO_CHIP_EXCHANGE_STORE, gActivityTimeActivityID.HERO_CHIP_EXCHANGE_STORE
	self.fields.Com_title:initData(i18n("Hero_reshape_6"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Label_time:setTimeLast(function(strTime)
		_ENV = nil
		;(nil).time = fguiHelper.getColorString("#F0E6D2", strTime)
		return i18n("HeroWeapon_40", nil)
	end)
	fguiHelper.SoraDSetComFields(self)
	self.fields.List_shop:setVirtual()
	self.fields.List_shop:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_none:setString(i18n("Hero_reshape_10"))
	self.fields.Text_none:setVisible(false)
	self.fields.Com_batch:setVisible(false)
	self.fields.Button_batch:setString(i18n("Hero_reshape_16"))
	self.fields.Button_batch:addClickListener(handler(self, self.btnBatchClick))
end
function HeroExchangeShopPanel:onItemRenderer(index, obj)
	obj:initData(self.shopList[index + 1])
end
function HeroExchangeShopPanel:onShow()
	print("=======HeroExchangeShopPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("allianceWar_shop_title")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("Hero_reshape_7")
	;(nil).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	;(nil).callback = handler(self, self.onTabClick)
	self.fields.com_Tab:initView(nil)
end
function HeroExchangeShopPanel:onTabClick(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	if self.tag == 1 then
		self:updateShopView()
	elseif self.tag == 2 then
		self:updateExchangeView()
	end
end
function HeroExchangeShopPanel:updateExchangeView()
	local itemsData = backpackCtrl:getItemsByGoodType(gItemType.HERO_CHIP)
	local backpackCtrl, tableItemsData = backpackCtrl, backpackCtrl
	for k, v in ipairs(itemsData) do
		local exchangeInfo = heroltCtrl:getExchangeInfo(v.id)
		if exchangeInfo and exchangeInfo.newTokenID and exchangeInfo.newTokenNum then
			v.rarity = heroltCtrl:getItemRarity(v.id)
			v.isOwnHero = heroCtrl:getHeroInfoByID(heroltCtrl:getHeroIDByItemID(v.id)) and true or false
			table.insert(tableItemsData, v)
		end
	end
	table.sort(tableItemsData, function(a, b)
		if a.isOwnHero == b.isOwnHero then
			if a.rarity == b.rarity then
				return a.count > b.count
			end
			return a.rarity > b.rarity
		end
		return a.isOwnHero
	end)
	self.fields.scroll:initHeroChipData(tableItemsData)
	self.fields.Text_none:setVisible(#tableItemsData == 0)
	self.fields.Button_batch:setEnabled(0 < #tableItemsData)
end
function HeroExchangeShopPanel:updateShopView()
	self.fields.Text_none:setVisible(false)
	self.fields.Com_batch:setVisible(false)
	local remainTime = serviceFunctions.getNextMonthFirstDayTime(1)
	self.fields.Label_time:beginTime(remainTime)
	self.shopList, _ENV = self.fields.Label_time.beginTime, self.fields.Label_time.beginTime
	local cfgList = activityExchangeMallRead.getShopItemListFromOri(self.activityID, 0)
	for k, v in ipairs(cfgList) do
		local leftCount = math.max(0, v.limitnum - activityExchangeMallCtrl:getExchangeNum(self.activityID, v.shopItemID))
		if 0 < leftCount then
			table.insert(self.shopList, v)
		end
	end
	for k, v in ipairs(cfgList) do
		local leftCount = math.max(0, v.limitnum - activityExchangeMallCtrl:getExchangeNum(self.activityID, v.shopItemID))
		if leftCount <= 0 then
			table.insert(self.shopList, v)
		end
	end
	self.fields.List_shop:setNumItems(#self.shopList)
end
function HeroExchangeShopPanel:btnBatchClick()
	SoraDPlaySound()
	self.fields.Com_batch:actShow()
end
function HeroExchangeShopPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Hero_reshape_13")
	uiManager:show("RuleView", nil)
end
return HeroExchangeShopPanel
