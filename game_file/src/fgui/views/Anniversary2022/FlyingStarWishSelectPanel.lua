local baseFguiPanel = require("fgui.base.baseFguiPanel")
local FlyingStarWishSelectPanel = class("FlyingStarWishSelectPanel", baseFguiPanel)
function FlyingStarWishSelectPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("FlyingStarWishSelectPanel:ctor", self.viewName)
end
function FlyingStarWishSelectPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function FlyingStarWishSelectPanel:onInit()
	print("=======FlyingStarWishSelectPanel:onInit")
	self.fields.Com_item:fixPos()
	self.fields.Text_des:fixPos()
	self.fields.Com_slider:setInpuBoxFixPos()
	self.fields.Button_Buy:addClickListener(handler(self, self.onBtnClick))
	self.fields.Button_cost:addClickListener(handler(self, self.onBtnClick))
	print("=======NebulaWonderlandDonatePanel:onInit")
end
function FlyingStarWishSelectPanel:initData(data)
	dump(data, "NebulaWonderlandDonatePanel:initData")
	self.fields.Panel_bg:setString(data.title)
	self.fields.Text_des:setString(data.itemDes)
	self.fields.Com_item:initData(data.itemID, data.singleCount)
	self.fields.Button_Buy:setTitle(data.btnTitle)
	self.btnHandle = data.btnHandle
	self.fields.Com_slider:getController("box"):setSelectedIndex(1)
	self.fields.Com_slider:setSliderCallBack(function(num)
		self.fields.Com_item:initData(data.itemID, num * data.singleCount)
	end)
	function _ENV(num)
		self.fields.Com_item:initData(data.itemID, num * data.singleCount)
	end
	;(function(num)
		self.fields.Com_item:initData(data.itemID, num * data.singleCount)
	end).minValue = data.minValue or 1
	;(function(num)
		self.fields.Com_item:initData(data.itemID, num * data.singleCount)
	end).maxValue = data.maxValue or 1
	;(function(num)
		self.fields.Com_item:initData(data.itemID, num * data.singleCount)
	end).curValue = data.curValue or 1
	self.fields.Com_slider:initData(function(num)
		self.fields.Com_item:initData(data.itemID, num * data.singleCount)
	end)
	self.fields.Com_slider:setMinValue(data.minValue or 1)
	if data.cost then
		self:initCostBtn(data)
	end
end
function FlyingStarWishSelectPanel:initCostBtn(data)
	self.controllers.btn:setSelectedIndex(1)
	self.fields.Button_cost:setTitleText(data.btnTitle)
	self.fields.Button_cost:setCostNum(data.cost * data.curValue, data.haveNum, true)
	self.fields.Com_slider:setSliderCallBack(function(buyCount)
		self.fields.Com_item:initData(data.itemID, buyCount * data.singleCount)
		self.fields.Button_cost:setCostNum(data.cost * buyCount, data.haveNum, true)
	end)
end
function FlyingStarWishSelectPanel:onBtnClick()
	SoraDPlaySound()
	self.btnHandle(self.fields.Com_slider:getSliderCurValue())
	self:close()
end
function FlyingStarWishSelectPanel:onShow()
	print("=======FlyingStarWishSelectPanel:onShow")
	self:initData(self.proxy.param)
end
return FlyingStarWishSelectPanel
