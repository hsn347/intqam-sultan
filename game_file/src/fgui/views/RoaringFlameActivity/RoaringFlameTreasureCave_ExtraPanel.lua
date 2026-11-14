local roaringFlameWarRead = include("roaringFlameWarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameTreasureCave_ExtraPanel = class("RoaringFlameTreasureCave_ExtraPanel", baseFguiPanel)
function RoaringFlameTreasureCave_ExtraPanel:ctor(...)
	self.isLRU = true
	RoaringFlameTreasureCave_ExtraPanel.super.ctor(self, ...)
	print("RoaringFlameTreasureCave_ExtraPanel:ctor", self.viewName)
end
function RoaringFlameTreasureCave_ExtraPanel:onInit()
	print("=======RoaringFlameTreasureCave_ExtraPanel:onInit")
	self.cfgList = roaringFlameWarRead.getCaveRewardCfg(2)
	self.fields.Panel_bg:setString(i18n("flames_dunes_text139"))
	_ENV = i18n("flames_dunes_text139")
	i18n("flames_dunes_text139").num = #self.cfgList
	self.fields.Text_tip:setString(i18n("flames_dunes_text140", i18n("flames_dunes_text139")))
	self.fields.Label_title:setString(i18n("flames_dunes_text141"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Com_item:fixPos()
	self.fields.Text_tip:fixPos()
end
function RoaringFlameTreasureCave_ExtraPanel:onItemRenderer(index, obj)
	obj:initData(self.cfgList[index + 1], index + 1)
end
function RoaringFlameTreasureCave_ExtraPanel:endShow()
	print("=======RoaringFlameTreasureCave_ExtraPanel:endShow")
	self.fields.List:setNumItems(#self.cfgList)
end
return RoaringFlameTreasureCave_ExtraPanel
