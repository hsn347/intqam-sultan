local magicHerbCtrl = SoraDGetCtrl("magicHerbCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicHerbIrrigateViewPanel = class("MagicHerbIrrigateViewPanel", baseFguiPanel)
function MagicHerbIrrigateViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicHerbIrrigateViewPanel:ctor", self.viewName)
end
function MagicHerbIrrigateViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "MagicHerb"
		self._packageList, self._packageList[2] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI1"
		self._packageList, self._packageList[4] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function MagicHerbIrrigateViewPanel:onInit()
	print("=======MagicHerbIrrigateViewPanel:onInit")
end
function MagicHerbIrrigateViewPanel:onShow()
	print("=======MagicHerbIrrigateViewPanel:onShow")
	self.fields.bg:setTitle(i18n("magic_herb_text_002"))
	self.fields.Text_tip:setString(i18n("magic_herb_text_011"))
	self.fields.Button_done:setTitleText(i18n("magic_herb_text_010"))
	self.fields.Button_done:addClickListener(handler(self, self.onDoneClick))
	_ENV = handler(self, self.onDoneClick)
	handler(self, self.onDoneClick).maxValue = magicHerbCtrl:getIrrigateCount()
	handler(self, self.onDoneClick).minValue = 1
	handler(self, self.onDoneClick).curValue = magicHerbCtrl:getIrrigateCount()
	self.fields.slider:initData(handler(self, self.onDoneClick))
	self.fields.slider:setSliderCallBack(function(value)
	end)
end
function MagicHerbIrrigateViewPanel:onHide()
	print("=======MagicHerbIrrigateViewPanel:onHide")
end
function MagicHerbIrrigateViewPanel:onDispose()
	print("=======MagicHerbIrrigateViewPanel:onDispose")
end
function MagicHerbIrrigateViewPanel:onDoneClick()
	print("浇灌指令============")
	SoraDPlaySound()
	local isSameA = magicHerbCtrl:isSameAlliance()
	if not isSameA then
		SoraDShowMsgTip(i18n("magic_herb_text_012"))
		return
	end
	magicHerbCtrl:sendIrrigate(self.fields.slider:getSliderCurValue())
	self:close()
end
return MagicHerbIrrigateViewPanel
