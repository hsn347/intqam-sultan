local baseComponent = require("fgui.base.baseComponent")
local itemSingleRecycle_farm = fgui.extension_class(fgui.GComponent, baseComponent)
local manorFarmRead = include("manorFarmRead")
local publicRead = include("publicRead")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
fgui.register_extension("ui://ManorFarm/itemSingleRecycle_farm", itemSingleRecycle_farm)
function itemSingleRecycle_farm:onInit()
	self.fields.Text_title:setString(i18n("recycling_store_text3"))
	self.fields.Com_Slider:setInpuBoxFixPos(85, 85, 45)
	self.fields.Com_Slider:setSliderCallBack(handler(self, self.sliderCallBack))
	self.fields.Button_use:setTitle(i18n("recycling_store_text5"))
	self.fields.Button_use:addClickEventListener(handler(self, self.onUseClick))
	self.fields.Button_max:addClickEventListener(handler(self, self.onMaxClick))
	self.fields.arror:fix()
	for i = 1, self:getChildrenCount() do
		local child = self:getChildAt(i - 1)
		if child ~= self.fields.Com_Slider and child ~= self.fields.Button_max then
			child:fixPos()
		end
	end
end
function itemSingleRecycle_farm:sliderCallBack(value)
	if 0 < value then
		self.curCount = value
		self.fields.item_1:setNum(value)
		self.fields.item_2:setNum(value * self.exchangeItem.count)
	end
end
function itemSingleRecycle_farm:onShow()
end
function itemSingleRecycle_farm:initData(data)
	self.data = data
	self.itemID = self.data.id
	self.fields.Image_arr:setPositionX(self.data.curPosX)
	dump(self.data, "self.data")
	local recycleItemCfg = manorFarmRead.getRecycle(data.id)
	self.exchangeItem = recycleItemCfg.exchangeItem
	dump(self.exchangeItem, "self.exchangeItem")
	self.fields.item_1:initData(self.data.id, 1)
	self.fields.text_name1:setString(publicRead.getName(self.itemID))
	self.fields.item_2:initData(self.exchangeItem.id, self.exchangeItem.count)
	self.fields.text_name2:setString(publicRead.getName(self.exchangeItem.id))
	self.maxNum = manorCityCtrl:getSeedNum(self.itemID)
	_ENV = self.itemID
	self.itemID.maxValue = self.maxNum
	self.itemID.minValue = 1
	self.itemID.curValue = 1
	self.fields.Com_Slider:initData(self.itemID)
	self.curCount = 1
	self:sliderCallBack(self.curCount)
end
function itemSingleRecycle_farm:onUseClick(sender)
	SoraDPlaySound()
	_ENV, manorCityCtrl = nil, nil
	;(nil).id = self.itemID
	;(nil).count = self.curCount
	;(nil)[1] = nil
	manorCityCtrl:reqFarmlandRecycle(nil)
	if not uiManager:getProxy("FarmShop") then
		_ENV = uiManager:getProxy("FarmShop")
	end
	SoraDShowLoading(uiManager:getProxy("FarmShop").view, nil, gCmd.REQ_GARDEN_FARMLAND_RECYCLE)
end
function itemSingleRecycle_farm:onMaxClick()
	SoraDPlaySound()
	self.fields.Com_Slider:setSliderCurValue(self.maxNum)
end
return itemSingleRecycle_farm
