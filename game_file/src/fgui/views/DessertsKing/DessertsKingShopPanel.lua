local dailyRemindManager = include("dailyRemindManager")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local lordOfDessertCtrl = SoraDGetCtrl("lordOfDessertCtrl")
local lordOfDessertRead = include("lordOfDessertRead")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DessertsKingShopPanel = class("DessertsKingShopPanel", baseFguiPanel)
function DessertsKingShopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("DessertsKingShopPanel:ctor", self.viewName)
end
function DessertsKingShopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function DessertsKingShopPanel:onInit()
	print("=======DessertsKingShopPanel:onInit")
	self.fields.Label_Point:fixChildrenPos()
	self.fields.Label_Item:fixChildrenPos()
	self.multiple = 1
	self.fields.Panel_bg:setString(i18n("common_text_284"))
	self.fields.Button_price:addClickListener(handler(self, self.onClickHandle))
	self.fields.Com_Slider:setSliderCallBack(handler(self, self.updatePriceBtn))
	self.index = self.proxy.param.index
	self.handle = self.proxy.param.handle
	local item = lordOfDessertRead.getNeedItemByIndex(self.index)
	self.normalNeedId = item[1]
	self.normalNeedCount = item[2]
	local getItem = lordOfDessertRead.getGetItemByIndex(self.index)
	self.normalCount = getItem[2]
	self.normalGetId = getItem[1]
	self.minMultiple = lordOfDessertRead.getNeedMinMultipleByIndex(self.index)
	self.maxMultiple = lordOfDessertRead.getNeedMaxMultipleByIndex(self.index)
	self.normalPoint = lordOfDessertRead.getGetIntegralByIndex(self.index)
	self.maxValue = self:retrunMaxCost()
	self.fields.Text_ask:setString(i18n(self.index == 1 and "EidalAdha_King_text_13" or "EidalAdha_King_text_12"))
	self.fields.Com_Slider:setText("/" .. self.maxValue)
end
function DessertsKingShopPanel:onShow()
	print("=======DessertsKingShopPanel:onShow")
	self:initData()
end
function DessertsKingShopPanel:initData()
	self.name = publicRead.getName(self.normalGetId)
	self.controllers.c1:setSelectedIndex(self.normalCount == nil and 1 or 0)
	print("publicRead.getIcon(self.normalGetId)", publicRead.getIcon(self.normalGetId))
	self.fields.Label_Item:setIcon(publicRead.getIcon(self.normalGetId))
	self.fields.Label_Item:getChild("Text_Name"):setString(self.name)
	self.fields.Label_Point:getChild("Text_Name"):setString(i18n("common_text_1764"))
	self.fields.Label_Point:setText(_q(self.normalPoint * self.minMultiple .. "~" .. tostring(self.normalPoint * self.maxMultiple)))
	if self.normalCount then
		self.fields.Label_Item:setText(tostring(self.normalCount))
	end
	self.fields.Button_price:initData(self.normalNeedId, self.normalNeedCount)
	publicRead = self.fields.Button_price.initData
	self.fields.Button_price.initData.maxValue = self.maxValue
	self.fields.Button_price.initData.minValue = 1
	local self.fields.Button_price.initData.curValue, sliderData = 1, self.fields.Button_price.initData
	self.fields.Com_Slider:initData(sliderData)
end
function DessertsKingShopPanel:retrunMaxCost()
	local haveGold = lordInfoCtrl:getBaseInfo().gold
	if self.index == 1 then
		haveGold = backpackCtrl:getItemCount(self.normalNeedId)
	end
	local maxValue = math.floor(haveGold / self.normalNeedCount)
	local singleLimit = lordOfDessertRead.getSingleMaxByIndex(self.index)
	return maxValue <= singleLimit and maxValue or singleLimit
end
function DessertsKingShopPanel:updatePriceBtn(multiple)
	multiple = multiple or 1
	self.multiple = multiple
	self.fields.Label_Point:setText(_q(self.normalPoint * self.minMultiple .. "~" .. tostring(self.normalPoint * self.maxMultiple)))
	if self.normalCount then
		self.fields.Label_Item:setText(tostring(self.normalCount))
	end
	local haveGold = lordInfoCtrl:getBaseInfo().gold
	if self.index == 1 then
		haveGold = backpackCtrl:getItemCount(self.normalNeedId)
	end
	self.needNum = self.normalNeedCount * multiple
	self.fields.Button_price:initData(self.normalNeedId, self.needNum)
	self.fields.Button_price:setStatus(haveGold, self.needNum, true)
	self.fields.Label_Point:setText(_q(self.normalPoint * self.minMultiple * self.multiple .. "~" .. tostring(self.normalPoint * self.maxMultiple * self.multiple)))
	if self.normalCount then
		self.fields.Label_Item:setText(tostring(self.normalCount * self.multiple))
	end
end
function DessertsKingShopPanel:onClickHandle()
	SoraDPlaySound()
	if self.fields.Button_price:getController("Ctrl_status"):getSelectedIndex() == 1 then
		if self.index == 1 then
			_ENV = nil
			;(nil).item = publicRead.getName(self.normalNeedId)
			SoraDShowMsgTip(i18n("Glory_text_19", nil))
		else
			SoraDShowMsgTip(i18n("alliance_landSet_006"))
			if GLOBAL_GAME_RECHARGE_MODE then
				_ENV = i18n("alliance_landSet_006")
				i18n("alliance_landSet_006").toCategory = gRechargeCenterCategory.GOLD
				uiManager:show("rechargeView", i18n("alliance_landSet_006"))
			else
				local panel = SoraDCreatePanel("rechargeView")
				panel:show()
				panel:expect2SelectTabEx(gRechargeCenterCategory.GOLD)
			end
			paymentManager.openRechargeView(gRechargeActiveFromEnum.ROAD09)
			self:removeFromParent()
		end
		return
	elseif self.index == 2 then
		local key = dailyRemindManager.REMIND_TYPE.dessertsKingShop
		if dailyRemindManager.checkNeedRemind(key) then
			_ENV = gRechargeCenterCategory.GOLD
			_ENV = i18n("alliance_landSet_006")
			i18n("alliance_landSet_006").num = self.needNum
			gRechargeCenterCategory.GOLD.content = i18n("EidalAdha_King_text_10", i18n("alliance_landSet_006"))
			function gRechargeCenterCategory.GOLD.confirmFunc()
				dailyRemindManager.addRemindToManager(key)
				lordOfDessertCtrl:reqLordOfDessertDonate(self.index, self.multiple)
				self:removeFromParent()
			end
			uiManager:show("MessageBox", gRechargeCenterCategory.GOLD):setOwnerKey(self)
			return
		end
	end
	lordOfDessertCtrl:reqLordOfDessertDonate(self.index, self.multiple)
	self:removeFromParent()
end
return DessertsKingShopPanel
