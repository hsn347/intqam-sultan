local manorCityRead = include("manorCityRead")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ManorDressExchangePanel = class("ManorDressExchangePanel", baseFguiPanel)
function ManorDressExchangePanel:ctor(...)
	self.isLRU = true
	ManorDressExchangePanel.super.ctor(self, ...)
	print("ManorDressExchangePanel:ctor", self.viewName)
end
function ManorDressExchangePanel:onInit()
	print("=======ManorDressExchangePanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_1889"))
	self.fields.Btn_exchange:setString(i18n("common_text_1889"))
	self.fields.Btn_exchange:addClickListener(handler(self, self.btnClick))
	self.fields.slider:setSliderCallBack(handler(self, self.sliderBack))
	self.fields.Check_tick:addClickListener(handler(self, self.onTickClick))
	if not SoraDFIsRA() then
		self.fields.item_from:fixPos()
		self.fields.item_to:fixPos()
		self.fields.arrow:setScaleX(-1)
	end
end
function ManorDressExchangePanel:endShow()
	print("=======ManorDressExchangePanel:endShow")
	self.exchangeNum = 0
	self.needCount = 0
	self.fields.Check_tick:setSelected(false)
	self.toID = self.param.toID
	self.costCount = self.param.costCount or 0
	self.fullCost = self.param.fullCost or 0
	self:initData()
end
function ManorDressExchangePanel:btnClick()
	SoraDPlaySound()
	manorCityCtrl:reqDressExchange(self.toID, self.exchangeNum)
	self:closePanel()
end
function ManorDressExchangePanel:sliderBack(value)
	print("==ManorDressExchangePanel:sliderBack==", value)
	self.exchangeNum = math.floor(value)
	self.fields.item_from:setNumText(self.exchangeNum .. "/" .. self.fromCount)
	self.fields.item_to:setNumText(self.exchangeNum)
	if self.exchangeNum <= 0 then
		self.fields.Btn_exchange:setEnabled(false)
	else
		self.fields.Btn_exchange:setEnabled(true)
	end
end
function ManorDressExchangePanel:initData()
	self.fromID = manorCityRead.getDressItemPieceID(self.toID)
	self.fields.item_from:initData(self.fromID)
	local toCount = manorCityCtrl:getItemCount(self.toID)
	local fullNeed = math.max(0, self.fullCost - toCount)
	local fromCount = manorCityCtrl:getItemCount(self.fromID)
	self.fromCount = math.min(fromCount, fullNeed)
	self.fields.item_to:initData(self.toID)
	manorCityRead = self.toID
	self.toID.maxValue = self.fromCount
	self.toID.minValue = 0
	self.toID.curValue = 0
	self.toID.allowZero = true
	self.fields.slider:initData(self.toID)
	local needCount = math.max(0, self.costCount - toCount)
	needCount = math.min(needCount, self.fromCount)
	self.needCount = needCount
	manorCityRead = nil
	;(nil).num = needCount
	self.fields.Text_exchange:setString(i18n("garden_text_39", nil))
end
function ManorDressExchangePanel:onTickClick()
	SoraDPlaySound()
	local isSelected = self.fields.Check_tick:isSelected()
	if isSelected then
		self.fields.slider:setSliderCurValue(self.needCount)
	end
end
return ManorDressExchangePanel
