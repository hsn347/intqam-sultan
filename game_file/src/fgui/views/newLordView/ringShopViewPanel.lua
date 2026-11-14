local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local equipmentltCtrl = include("equipmentltCtrl")
local treasureCourtCtrl = SoraDGetCtrl("treasureCourtCtrl")
local itemDesRead = include("itemDesRead")
local equipDesRead = include("equipDesRead")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ringShopViewPanel = class("ringShopViewPanel", baseFguiPanel)
function ringShopViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ringShopViewPanel:ctor", self.viewName)
end
function ringShopViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ringShopViewPanel:onInit()
	print("=======ringShopViewPanel:onInit")
	self.shopData, _ENV, self.limitData, _ENV = print, print, print, print
	self.fields.Com_title:initData(i18n("equip_text_11"), handler(self, self.onClickClose))
	self.fields.Text_LimitTitle:setString(i18n("equip_text_08"))
	self.fields.List_limit:setItemRenderer(handler(self, self.onLimitRenderer))
	self.fields.List_shop:setItemRenderer(handler(self, self.onShopRenderer))
end
function ringShopViewPanel:onShow()
	print("=======ringShopViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self:refreshDiscountItem()
	self.shopData, _ENV = self.refreshDiscountItem, self.refreshDiscountItem
	local shopList = equipmentltCtrl:getRingShopList()
	local lineNum = math.ceil(self.fields.List_shop:getHeight() / 174)
	for i = 1, #shopList, 2 do
		_ENV = nil
		;(nil).left = shopList[i]
		;(nil).right = shopList[i + 1]
		table.insert(self.shopData, nil)
	end
	local dataLineNum = #self.shopData
	if lineNum > dataLineNum then
		for i = 1, lineNum - dataLineNum do
			_ENV = shopList[i + 1]
			shopList[i + 1].left = nil
			shopList[i + 1].right = nil
			table.insert(self.shopData, shopList[i + 1])
		end
	end
	self.fields.List_shop:setNumItems(#self.shopData)
end
function ringShopViewPanel:onLimitRenderer(index, obj)
	obj:initData(self.limitData[index + 1])
end
function ringShopViewPanel:onShopRenderer(index, obj)
	obj:initData(self.shopData[index + 1])
end
function ringShopViewPanel:refreshDiscountItem()
	self.limitData, equipmentCtrl = nil, nil
	if not equipmentCtrl:getLimitRingShop() then
		local equipmentCtrl, limitInfo = equipmentCtrl:getLimitRingShop(), equipmentCtrl:getLimitRingShop()
	end
	for i = 1, 3 do
		if limitInfo[tostring(i)] then
			local tmp = equipmentltCtrl.getRingShopByID(limitInfo[tostring(i)].shopItemId)
			local itemInfo = serviceFunctions.table_copy_table(tmp)
			itemInfo.buyNum = itemInfo.number - limitInfo[tostring(i)].buyNum
			itemInfo.endTime = limitInfo[tostring(i)].endTime
			table.insert(self.limitData, itemInfo)
		end
	end
	self.fields.List_limit:setNumItems(#self.limitData)
end
function ringShopViewPanel:msgCallBack(target, data)
	if data.subMsg == "shopSuccess" then
		local tmp = equipmentltCtrl.getRingShopByID(data.shopItemID)
		equipmentltCtrl, _ENV = nil, nil
		;(nil).id = tmp.ringId
		;(nil).count = 1
		;(nil)[1] = nil
		SoraDMailGainItems(nil, true)
		self:refreshDiscountItem()
	elseif data.subMsg == "refreshShop" then
		self:refreshDiscountItem()
	end
end
return ringShopViewPanel
