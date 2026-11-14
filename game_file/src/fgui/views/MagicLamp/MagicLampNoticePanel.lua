local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local magicLampHatchCtrl = SoraDGetCtrl("magicLampHatchCtrl")
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local MagicLampNoticePanel = class("MagicLampNoticePanel", baseFguiPanel)
function MagicLampNoticePanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampNoticePanel:ctor", self.viewName)
end
function MagicLampNoticePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MagicLampNoticePanel:onInit()
	print("=======MagicLampNoticePanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("magic_lamp_text_137"))
	self.fields.label_des:setString(i18n("magic_lamp_text_146"))
	self.fields.title1:setTitle(i18n("common_text_2931"))
	self.fields.title2:setTitle(i18n("magic_lamp_text_143"))
	self.fields.text_1:setString(i18n("magic_lamp_text_141"))
	self.fields.text_2:setString(i18n("magic_lamp_text_142"))
	self.fields.label_timer:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("magic_lamp_text_144", nil)
	end)
	self.fields.label_timer:setTimeEndListener(function()
		self:updateView()
	end)
	self.fields.list1:setItemRenderer(handler(self, self.onItem1Renderer))
	self.fields.list2:setItemRenderer(handler(self, self.onItem2Renderer))
	magicLampCtrl:reqUnlockInfoFireJinn()
end
function MagicLampNoticePanel:onShow()
	print("=======MagicLampNoticePanel:onShow")
	self:initData()
end
function MagicLampNoticePanel:initData()
	local needHatchLv = math.floor(constantRead.getConstValue("ALPHALITE_UNLOCK_HATCH_DEMAND", 0))
	local needJinnLv = math.floor(constantRead.getConstValue("ALPHALITE_UNLOCK_MARID_DEMAND", 0))
	local needServerNum1 = math.floor(constantRead.getConstValue("ALPHALITE_UNLOCK_SERVE_MARID_DEMAND1", 0))
	local needServerNum2 = math.floor(constantRead.getConstValue("ALPHALITE_UNLOCK_SERVE_MARID_DEMAND2", 0))
	local hatchData = magicLampHatchCtrl:getHatchData(gJinnType.JINN_ONE)
	local hatchLv = hatchData and hatchData.lv or 0
	local jinnLv = magicLampCtrl:getJinnLv(gJinnType.JINN_ONE)
	local unlockFireJinnData = magicLampCtrl:getUnlockFireJinnData()
	local _ENV, magicLampHatchCtrl, unlockLastTime = constantRead.getConstValue("ALPHALITE_UNLOCK_SERVE_MARID_DEMAND2", 0)
	_ENV = constantRead.getConstValue("ALPHALITE_UNLOCK_SERVE_MARID_DEMAND2", 0)
	constantRead.getConstValue("ALPHALITE_UNLOCK_SERVE_MARID_DEMAND2", 0).num = needHatchLv
	constantRead.getConstValue("ALPHALITE_UNLOCK_SERVE_MARID_DEMAND2", 0).title = i18n("magic_lamp_text_138", constantRead.getConstValue("ALPHALITE_UNLOCK_SERVE_MARID_DEMAND2", 0))
	_ENV, constantRead.getConstValue("ALPHALITE_UNLOCK_SERVE_MARID_DEMAND2", 0).isEnough = needHatchLv <= hatchLv, needHatchLv <= hatchLv
	_ENV = constantRead.getConstValue("ALPHALITE_UNLOCK_SERVE_MARID_DEMAND2", 0)
	constantRead.getConstValue("ALPHALITE_UNLOCK_SERVE_MARID_DEMAND2", 0).num = needJinnLv
	;(needHatchLv <= hatchLv).title = i18n("magic_lamp_text_147", constantRead.getConstValue("ALPHALITE_UNLOCK_SERVE_MARID_DEMAND2", 0))
	;(needHatchLv <= hatchLv).isEnough = needJinnLv <= jinnLv
	_ENV, magicLampHatchCtrl, self.datas1, serviceFunctions.systemTime()[1] = constantRead.getConstValue("ALPHALITE_UNLOCK_SERVE_MARID_DEMAND2", 0)
	_ENV, magicLampHatchCtrl, self.datas1, serviceFunctions.systemTime()[2] = constantRead.getConstValue("ALPHALITE_UNLOCK_SERVE_MARID_DEMAND2", 0)
	_ENV = "magic_lamp_text_147"
	;("magic_lamp_text_147").num = needServerNum2
	constantRead.getConstValue("ALPHALITE_UNLOCK_SERVE_MARID_DEMAND2", 0).title = i18n("magic_lamp_text_140", "magic_lamp_text_147")
	_ENV, constantRead.getConstValue("ALPHALITE_UNLOCK_SERVE_MARID_DEMAND2", 0).isEnough = needServerNum2 <= (unlockFireJinnData and tonumber(unlockFireJinnData.lv300Count) or 0), needServerNum2 <= (unlockFireJinnData and tonumber(unlockFireJinnData.lv300Count) or 0)
	_ENV = constantRead.getConstValue("ALPHALITE_UNLOCK_SERVE_MARID_DEMAND2", 0)
	constantRead.getConstValue("ALPHALITE_UNLOCK_SERVE_MARID_DEMAND2", 0).num = needServerNum1
	;(needServerNum2 <= (unlockFireJinnData and tonumber(unlockFireJinnData.lv300Count) or 0)).title = i18n("magic_lamp_text_139", constantRead.getConstValue("ALPHALITE_UNLOCK_SERVE_MARID_DEMAND2", 0))
	;(needServerNum2 <= (unlockFireJinnData and tonumber(unlockFireJinnData.lv300Count) or 0)).isEnough = needServerNum1 <= (unlockFireJinnData and tonumber(unlockFireJinnData.lv350Count) or 0)
	self.datas2, serviceFunctions.systemTime()[1] = serviceFunctions.systemTime(), constantRead.getConstValue("ALPHALITE_UNLOCK_SERVE_MARID_DEMAND2", 0)
	self.datas2, serviceFunctions.systemTime()[2] = serviceFunctions.systemTime(), needServerNum2 <= (unlockFireJinnData and tonumber(unlockFireJinnData.lv300Count) or 0)
	self.controllers.c1:setSelectedIndex(0 < unlockLastTime and 0 or 1)
	if 0 < unlockLastTime then
		self.fields.label_timer:beginTime(unlockLastTime)
	end
	self.fields.list1:setNumItems(#self.datas1)
	self.fields.list2:setNumItems(#self.datas2)
end
function MagicLampNoticePanel:onItem1Renderer(index, obj)
	local data = self.datas1[index + 1]
	obj:initData(data.title, data.isEnough)
end
function MagicLampNoticePanel:onItem2Renderer(index, obj)
	local data = self.datas2[index + 1]
	obj:initData(data.title, data.isEnough)
end
return MagicLampNoticePanel
