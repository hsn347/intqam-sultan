local publicRead = include("publicRead")
local starlightPavilionCtrl = SoraDGetCtrl("starlightPavilionCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local StarsTowerExchangePropPanel = class("StarsTowerExchangePropPanel", baseFguiPanel)
function StarsTowerExchangePropPanel:ctor(...)
	self.super.ctor(self, ...)
	print("StarsTowerExchangePropPanel:ctor", self.viewName)
end
function StarsTowerExchangePropPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function StarsTowerExchangePropPanel:onInit()
	print("=======StarsTowerExchangePropPanel:onInit")
	self.count = 1
	self.fields.bg:setString(i18n("common_text_282"))
	self.fields.slider:setSliderCallBack(handler(self, self.onSliderChange))
	self.fields.btn_buy:setString(i18n("common_text_282"))
	self.fields.btn_buy:addClickListener(handler(self, self.onBtnBuy))
	self.fields.item:fixPos()
	self.fields.text_des:fixPos()
	self.fields.slider:setInpuBoxFixPos()
end
function StarsTowerExchangePropPanel:onShow()
	print("=======StarsTowerExchangePropPanel:onShow")
	self.fields.item:initData(self.param.data.itemID, self.param.data.num)
	self.fields.text_des:setString(publicRead.getDes(self.param.data.itemID))
	local boughtNum = starlightPavilionCtrl:getExchangeCount(self.param.data.index)
	self.max = math.min(math.floor(SoraDGetGold() / self.param.data.price), self.param.data.limitNum - boughtNum)
	_ENV = self.param.data.limitNum - boughtNum
	;(self.param.data.limitNum - boughtNum).maxValue = self.max
	;(self.param.data.limitNum - boughtNum).minValue = 1
	;(self.param.data.limitNum - boughtNum).curValue = self.count
	self.fields.slider:initData(self.param.data.limitNum - boughtNum)
end
function StarsTowerExchangePropPanel:onSliderChange(val)
	self.count = val
	self.fields.btn_buy:setCostNum(self.count * self.param.data.price, SoraDGetGold())
end
function StarsTowerExchangePropPanel:onBtnBuy()
	SoraDPlaySound()
	if SoraDEnoughGold(self.count * self.param.data.price) then
		starlightPavilionCtrl:sendExchange(self.param.data.index, self.count)
		self:close()
	end
end
return StarsTowerExchangePropPanel
