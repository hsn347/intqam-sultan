local itemDesRead = include("itemDesRead")
local petExchangeCtrl = SoraDGetCtrl("petExchangeCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local PetItemFeedViewPanel = class("PetItemFeedViewPanel", baseFguiPanel)
function PetItemFeedViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("PetItemFeedViewPanel:ctor", self.viewName)
	self.costNum = 0
end
function PetItemFeedViewPanel:onInit()
	print("=======PetItemFeedViewPanel:onInit")
	self.fields.Button_feed:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.Button_tool:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.Com_slider:setSliderCallBack(handler(self, self.sliderCallBack))
	if not SoraDFIsRA() then
		self.fields.Com_item:fixPos()
		self.fields.Text_des:fixPos()
	end
end
function PetItemFeedViewPanel:onShow()
	print("=======PetItemFeedViewPanel:onShow")
	self:initData(self.param)
end
function PetItemFeedViewPanel:sliderCallBack(value)
	if self.sliderBoxType == gSoldierBoxType.PET_RECLAIM then
		local totalPoint = value * self.tableItemData.petPoint
		_ENV = nil
		;(nil).score = totalPoint
		self.fields.Text_notice:setString(i18n("common_text_3820", nil))
	elseif self.sliderBoxType == gSoldierBoxType.PET_EXCHANGE_BY_SCORE_EAGLE then
		self.costNum = petExchangeCtrl:getEagleExchangeCost(gPetExchangeEagleType.POINT, value)
		self.fields.Button_tool:setCostTitle(string.formatnumberthousands(self.costNum))
	elseif self.sliderBoxType == gSoldierBoxType.PET_EXCHANGE_BY_GOLD_EAGLE then
		self.costNum = petExchangeCtrl:getEagleExchangeCost(gPetExchangeEagleType.GOLD, value)
		self.fields.Button_tool:setCostNum(self.costNum, SoraDGetGold())
	elseif self.sliderBoxType == gSoldierBoxType.PET_EXCHANGE_BY_SCORE then
		self.costNum = value * self.tableItemData.Point
		self.fields.Button_tool:setCostTitle(string.formatnumberthousands(self.costNum))
	end
end
function PetItemFeedViewPanel:initData(data)
	self.sliderBoxType = data.sliderBoxType
	self.tableItemData = data.itemData
	self.handle = data.handle
	self.fields.Com_item:initData(self.tableItemData.id)
	local maxValue = 1
	if self.sliderBoxType == gSoldierBoxType.PET_RECLAIM then
		self.controllers.c1:setSelectedIndex(0)
		maxValue = self.tableItemData.count
		self.fields.Button_feed:setString(i18n("common_text_3983"))
	elseif self.sliderBoxType == gSoldierBoxType.PET_EXCHANGE_BY_SCORE_EAGLE then
		self.controllers.c1:setSelectedIndex(1)
		local exchangeType = data.exchangeType
		maxValue = petExchangeCtrl:getEagleMaxExchangeNum(exchangeType)
		self.fields.Button_tool:setString(i18n("common_text_1889"))
		self.fields.Button_tool:setCostIcon("icon_pet_exchange_point.png")
	elseif self.sliderBoxType == gSoldierBoxType.PET_EXCHANGE_BY_GOLD_EAGLE then
		self.controllers.c1:setSelectedIndex(1)
		local exchangeType = data.exchangeType
		maxValue = petExchangeCtrl:getEagleMaxExchangeNum(exchangeType)
		self.fields.Button_tool:setString(i18n("common_text_282"))
		self.fields.Button_tool:setCostIcon("icon_small_gold.png")
	elseif self.sliderBoxType == gSoldierBoxType.PET_EXCHANGE_BY_SCORE then
		self.controllers.c1:setSelectedIndex(1)
		local point = self.tableItemData.Point
		self.fields.Button_tool:setCostTitle(point)
		local index = self.tableItemData.Index
		maxValue = petExchangeCtrl:getNormalMaxExchangeNum(index)
		self.fields.Button_tool:setString(i18n("common_text_1889"))
		self.fields.Button_tool:setCostIcon("icon_pet_exchange_point.png")
	end
	self.fields.Panel_bg:setString(itemDesRead.getName(self.tableItemData.id))
	self.fields.Text_des:setString(itemDesRead.getDes(self.tableItemData.id))
	_ENV = itemDesRead.getDes(self.tableItemData.id)
	itemDesRead.getDes(self.tableItemData.id).maxValue = maxValue
	itemDesRead.getDes(self.tableItemData.id).minValue = 1
	itemDesRead.getDes(self.tableItemData.id).curValue = 1
	self.fields.Com_slider:initData(itemDesRead.getDes(self.tableItemData.id))
end
function PetItemFeedViewPanel:btnClickCallBack()
	SoraDPlaySound()
	if self.sliderBoxType == gSoldierBoxType.PET_EXCHANGE_BY_GOLD_EAGLE and not SoraDEnoughGold(self.costNum) then
		return
	end
	if self.handle then
		_ENV = self.costNum
		self.costNum.id = self.tableItemData.id
		self.costNum.num = self.fields.Com_slider:getSliderCurValue()
		self.costNum.index = self.tableItemData.Index
		self.handle(self.costNum)
	end
	self:removeFromParent()
end
return PetItemFeedViewPanel
