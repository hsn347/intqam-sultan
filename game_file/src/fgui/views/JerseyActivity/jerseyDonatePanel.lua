local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local jerseyDonatePanel = class("jerseyDonatePanel", baseFguiPanel)
function jerseyDonatePanel:ctor(...)
	self.super.ctor(self, ...)
	print("jerseyDonatePanel:ctor", self.viewName)
end
function jerseyDonatePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function jerseyDonatePanel:onInit(...)
	self.super.onInit(self, ...)
	self.fields.panel_normal:setTitle(i18n("common_text_284"))
	self.fields.Com_item:fixPos()
	self.fields.Text_des:fixPos()
	self.fields.Com_slider:setInpuBoxFixPos()
	self.fields.Button_Buy:addClickListener(handler(self, self.onBtnClick))
end
function jerseyDonatePanel:initData(data)
	dump(data, "jerseyDonatePanel:initData")
	self.fields.Text_des:setString(publicRead.getDes(data.itemID))
	self.fields.Com_item:initData(data.itemID, 1)
	self.fields.Button_Buy:setTitle(data.btnTitle)
	self.btnHandle = data.btnHandle
	self.fields.Com_slider:getController("box"):setSelectedIndex(1)
	self.fields.Com_slider:setSliderCallBack(function(num)
		self.fields.Com_item:initData(data.itemID, num)
	end)
	function _ENV(num)
		self.fields.Com_item:initData(data.itemID, num)
	end
	;(function(num)
		self.fields.Com_item:initData(data.itemID, num)
	end).minValue = data.minValue or 1
	;(function(num)
		self.fields.Com_item:initData(data.itemID, num)
	end).maxValue = data.maxValue or 1
	;(function(num)
		self.fields.Com_item:initData(data.itemID, num)
	end).curValue = data.curValue or 1
	self.fields.Com_slider:initData(function(num)
		self.fields.Com_item:initData(data.itemID, num)
	end)
	self.fields.Com_slider:setMinValue(data.minValue or 1)
end
function jerseyDonatePanel:onBtnClick()
	SoraDPlaySound()
	self.btnHandle(self.fields.Com_slider:getSliderCurValue())
	self:close()
end
function jerseyDonatePanel:onShow()
	print("=======jerseyDonatePanel:onShow")
	self:initData(self.proxy.param)
end
return jerseyDonatePanel
