local baseComponent = require("fgui.base.baseComponent")
local itemSingleRecycle = fgui.extension_class(fgui.GComponent, baseComponent)
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local backpackltCtrl = include("backpackltCtrl")
local publicRead = include("publicRead")
fgui.register_extension("ui://bagView/itemSingleRecycle", itemSingleRecycle)
fgui.register_extension("ui://ManorFarm/itemSingleRecycle_farm", itemSingleRecycle)
function itemSingleRecycle:onInit()
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
function itemSingleRecycle:sliderCallBack(value)
	if 0 < value then
		self.curCount = value
		self.fields.item_1:setNum(value)
		self.fields.item_2:setNum(value * self.exchangeItem.count)
	end
end
function itemSingleRecycle:onShow()
end
function itemSingleRecycle:initData(data, index)
	self.data = data
	self.itemID = self.data.id
	self.fields.Image_arr:setPositionX(SoraDFPosX(620 - 126 * index + 55, 588))
	dump(self.data, "self.data")
	local recycleItemCfg = backpackltCtrl:getRecycleItemConfig(data.id)
	self.exchangeItem = recycleItemCfg.exchangeitem[1]
	dump(self.exchangeItem, "self.exchangeItem")
	self.fields.item_1:initData(self.data.id, 1)
	self.fields.text_name1:setString(publicRead.getName(self.itemID))
	self.fields.item_2:initData(self.exchangeItem.id, self.exchangeItem.count)
	self.fields.text_name2:setString(publicRead.getName(self.exchangeItem.id))
	self.maxNum = self.data.count
	_ENV = publicRead.getName(self.exchangeItem.id)
	publicRead.getName(self.exchangeItem.id).maxValue = self.maxNum
	publicRead.getName(self.exchangeItem.id).minValue = 1
	publicRead.getName(self.exchangeItem.id).curValue = 1
	self.fields.Com_Slider:initData(publicRead.getName(self.exchangeItem.id))
	self.curCount = 1
	self:sliderCallBack(self.curCount)
end
function itemSingleRecycle:onUseClick(sender)
	SoraDPlaySound()
	local dailyRemindManager = include("dailyRemindManager")
	if dailyRemindManager.checkNeedRemind(dailyRemindManager.REMIND_TYPE.itemRecycle) then
		_ENV = nil
		;(nil).num1 = self.curCount
		;(nil).num2 = self.curCount * self.exchangeItem.count
		;(nil).item = publicRead.getName(self.itemID)
		;(nil).coin = publicRead.getName(self.exchangeItem.id)
		local str = i18n("recycling_store_text6", nil)
		_ENV = self.exchangeItem.id
		self.exchangeItem.id.content = str
		function self.exchangeItem.id.confirmFunc()
			if not tolua.isnull(self) then
				backpackCtrl:recycleItem(self.itemID, self.curCount)
			end
		end
		self.exchangeItem.id.remindString = i18n("coffeeCraftsman_text_27")
		function self.exchangeItem.id.remindFunc(value)
			if value then
				dailyRemindManager.addRemindToManager(dailyRemindManager.REMIND_TYPE.itemRecycle)
			end
		end
		uiManager:show("MessageBox", self.exchangeItem.id)
	else
		backpackCtrl:recycleItem(self.itemID, self.curCount)
	end
end
function itemSingleRecycle:onMaxClick()
	SoraDPlaySound()
	self.fields.Com_Slider:setSliderCurValue(self.maxNum)
end
return itemSingleRecycle
