local snowmanCelebrationltCtrl = include("snowmanCelebrationltCtrl")
local snowmanCelebrationCtrl = SoraDGetCtrl("snowmanCelebrationCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SnowmanCelebrationShopPanel = class("SnowmanCelebrationShopPanel", baseFguiPanel)
function SnowmanCelebrationShopPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("SnowmanCelebrationShopPanel:ctor", self.viewName)
end
function SnowmanCelebrationShopPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
		self._packageList, self._packageList[2] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function SnowmanCelebrationShopPanel:onInit()
	self:fixChildrenPos()
	self.fields.n1:fix(false)
	self.fields.n2:fix(false)
	self.fields.Text_point:fixPos()
	self.fields.Text_pointNum:fixPos()
	self.fields.Text_count:fixPos()
	self.fields.Text_countNum:fixPos()
	self.fields.Icon_point:fixPos()
	self.fields.Icon_get:fixPos()
	print("=======SnowmanCelebrationShopPanel:onInit")
	self.multiple = 1
	self.fields.Button_price:addClickListener(handler(self, self.onClickHandle))
	self.functionCol = self:initFunc()
end
function SnowmanCelebrationShopPanel:initData(index, handle, maxValue)
	local skin = snowmanCelebrationCtrl:getSkin()
	self.index = index
	self.handle = handle
	self.name = publicRead.getName(snowmanCelebrationltCtrl.getGetIDByIndex(index))
	local scoreId = snowmanCelebrationltCtrl.getScoreId()
	self.scoreName = publicRead.getName(scoreId)
	self.fields.Icon_point:setURL(publicRead.getIcon(scoreId))
	self.fields.Icon_get:setURL(publicRead.getIcon(snowmanCelebrationltCtrl.getGetIDByIndex(index)))
	if index == 1 then
		local tipText = skin == 1 and "Snowman_Activity_12" or "ramadan_starlight_03"
		local itemName = skin == 1 and "item_name_843501" or "item_name_845301"
		snowmanCelebrationCtrl = publicRead.getIcon(snowmanCelebrationltCtrl.getGetIDByIndex(index))
		publicRead.getIcon(snowmanCelebrationltCtrl.getGetIDByIndex(index)).item = i18n(itemName)
		self.fields.Text_ask:setString(i18n(tipText, publicRead.getIcon(snowmanCelebrationltCtrl.getGetIDByIndex(index))))
	else
		local tipText = skin == 1 and "Snowman_Activity_11" or "ramadan_starlight_02"
		snowmanCelebrationCtrl = i18n(tipText, publicRead.getIcon(snowmanCelebrationltCtrl.getGetIDByIndex(index)))
		i18n(tipText, publicRead.getIcon(snowmanCelebrationltCtrl.getGetIDByIndex(index))).item = i18n("common_text_020")
		self.fields.Text_ask:setString(i18n(tipText, i18n(tipText, publicRead.getIcon(snowmanCelebrationltCtrl.getGetIDByIndex(index)))))
	end
	self.normalPoint = snowmanCelebrationltCtrl.getGetIntegralByIndex(index)
	self.normalCount = snowmanCelebrationltCtrl.getGetItemCountByIndex(index)
	self.normalNeedId = snowmanCelebrationltCtrl.getNeedIDByIndex(index)
	self.normalNeedCount = snowmanCelebrationltCtrl.getNeedCountByIndex(index)
	self.minMultiple = snowmanCelebrationltCtrl.getNeedMinMultipleByIndex(index)
	self.maxMultiple = snowmanCelebrationltCtrl.getNeedMaxMultipleByIndex(index)
	self.controllers.c1:setSelectedIndex(self.normalCount == nil and 1 or 0)
	self.fields.Text_point:setString(self.scoreName)
	self.lang = SoraDGetDefaultLanguage()
	if lang == "ar" then
		self.fields.Text_pointNum:setString(tostring(self.normalPoint * self.maxMultiple) .. "~" .. tostring(self.normalPoint * self.minMultiple))
	else
		self.fields.Text_pointNum:setString(tostring(self.normalPoint * self.minMultiple) .. "~" .. tostring(self.normalPoint * self.maxMultiple))
	end
	self.fields.Text_count:setString(self.name)
	if self.normalCount then
		self.fields.Text_countNum:setString(tostring(self.normalCount))
	end
	self.fields.Button_price:initData(self.normalNeedId, self.normalNeedCount)
	snowmanCelebrationCtrl = self.fields.Button_price.initData
	self.fields.Button_price.initData.maxValue = maxValue
	self.fields.Button_price.initData.minValue = 1
	local self.fields.Button_price.initData.curValue, sliderData = 1, self.fields.Button_price.initData
	self.fields.Com_Slider:initData(sliderData)
	self.fields.Com_Slider:setText("/" .. maxValue)
	local handle = function(value)
		self:updatePriceBtn(value)
	end
	self.fields.Com_Slider:setSliderCallBack(handle)
	self:updatePriceBtn()
end
function SnowmanCelebrationShopPanel:updatePriceBtn(multiple)
	multiple = multiple or 1
	self.multiple = multiple
	if self.lang == "ar" then
		self.fields.Text_pointNum:setString(tostring(self.normalPoint * multiple * self.maxMultiple) .. "~" .. tostring(self.normalPoint * multiple * self.minMultiple))
	else
		self.fields.Text_pointNum:setString(tostring(self.normalPoint * multiple * self.minMultiple) .. "~" .. tostring(self.normalPoint * multiple * self.maxMultiple))
	end
	if self.normalCount then
		self.fields.Text_countNum:setString(tostring(self.normalCount * multiple))
	end
	local haveGold = lordInfoCtrl:getBaseInfo().gold
	if self.index == 1 then
		haveGold = backpackCtrl:getItemCount(snowmanCelebrationltCtrl.getNeedIDByIndex(self.index))
	end
	self.fields.Button_price:initData(self.normalNeedId, self.normalNeedCount * multiple)
	self.fields.Button_price:setStatus(haveGold, self.normalNeedCount * multiple)
end
function SnowmanCelebrationShopPanel:initFunc()
	_ENV = nil
	;(nil).notOpen = function()
		SoraDShowMsgTip(i18n("devilvalley_text_08"))
	end
	;(nil).donate = function()
		self:close()
	end
	;(nil).notInAlliance = function()
		SoraDShowMsgTip(i18n("Snowman_Activity_02"))
	end
	local (nil).notEnoughMoney, functionCol = function()
		_ENV = nil
		;(nil).item = i18n("common_text_020")
		SoraDShowMsgTip(i18n("Glory_text_19", nil))
	end, nil
	return functionCol
end
function SnowmanCelebrationShopPanel:refreshView(data)
	if not data then
		return
	end
	dump(data, "SnowmanCelebrationShopPanel:refreshView")
	local fun = self.functionCol[data.subMsg]
	if fun then
		fun()
	end
end
function SnowmanCelebrationShopPanel:onClickHandle()
	self.handle(self.multiple)
end
function SnowmanCelebrationShopPanel:onShow()
	print("=======SnowmanCelebrationShopPanel:onShow")
	self:initData(self.proxy.param.index, self.proxy.param.handle, self.proxy.param.maxValue)
end
function SnowmanCelebrationShopPanel:onHide()
	print("=======SnowmanCelebrationShopPanel:onHide")
end
function SnowmanCelebrationShopPanel:onDispose()
	print("=======SnowmanCelebrationShopPanel:onDispose")
end
return SnowmanCelebrationShopPanel
