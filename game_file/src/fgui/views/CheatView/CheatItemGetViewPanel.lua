local publicRead = include("publicRead")
local cheatCtrl = SoraDGetCtrl("cheatCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CheatItemGetViewPanel = class("CheatItemGetViewPanel", baseFguiPanel)
function CheatItemGetViewPanel:ctor(...)
	CheatItemGetViewPanel.super.ctor(self, ...)
	print("CheatItemGetViewPanel:ctor", self.viewName)
end
function CheatItemGetViewPanel:onInit()
	print("=======CheatItemGetViewPanel:onInit")
	self.fields.Button_get:setString("来一波")
	self.fields.Button_get:addClickListener(handler(self, self.btnClick))
end
function CheatItemGetViewPanel:onShow()
	print("=======CheatItemGetViewPanel:onShow")
	self.itemId = self.param.itemId
	self.style = self.param.style
	self.handle = self.param.handle
	self:initData()
end
function CheatItemGetViewPanel:initData()
	self.fields.Com_item:initData(self.itemId)
	self.fields.Panel_bg:setString(publicRead.getName(self.itemId))
	publicRead = publicRead.getName(self.itemId)
	publicRead.getName(self.itemId).maxValue = 9999999
	publicRead.getName(self.itemId).minValue = 1
	publicRead.getName(self.itemId).curValue = 1
	self.fields.Com_slider:initData(publicRead.getName(self.itemId))
end
function CheatItemGetViewPanel:btnClick()
	SoraDPlaySound()
	local value = self.fields.Com_slider:getSliderCurValue()
	if self.handle then
		self.handle(self.itemId, value)
	else
		_ENV, cheatCtrl = nil, value
		;(nil).id = self.itemId
		;(nil).count = value
		value[1] = nil
		cheatCtrl:reqAddGameItem(value)
		SoraDPopGainItem(self.itemId, value)
	end
	self:close()
end
return CheatItemGetViewPanel
