local necklaceTecCtrl = SoraDGetCtrl("necklaceTecCtrl")
local necklaceTechRead = include("necklaceTechRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local neckTechViewPanel = class("neckTechViewPanel", baseFguiPanel)
function neckTechViewPanel:ctor(...)
	self.isLRU = true
	neckTechViewPanel.super.ctor(self, ...)
	print("neckTechViewPanel:ctor", self.viewName)
end
function neckTechViewPanel:onInit()
	print("=======neckTechViewPanel:onInit")
	self.itemID = necklaceTechRead.getItemID()
	self.fields.Com_title:initData(i18n("common_text_4949"), handler(self, self.onClickClose))
	self.fields.Button_attr:setTitle(i18n("gemEnchant_text_01"))
	self.fields.Button_attr:addClickListener(handler(self, self.onClick_Button_attr))
end
function neckTechViewPanel:endShow()
	print("=======neckTechViewPanel:endShow")
	self.fields.Button_item:initData(self.itemID, handler(self, self.onClick_Button_item))
	self.fields.Button_item:setIcon(publicRead.getIcon(self.itemID))
	self.fields.techMap:init()
	self:initView()
end
function neckTechViewPanel:initView()
	self.fields.techMap:initData()
	local itemCount = backpackCtrl:getItemCount(self.itemID)
	self.fields.Button_item:setTitle(string.formatnumberthousands(itemCount))
end
function neckTechViewPanel:onClick_Button_attr(context)
	SoraDPlaySound()
	uiManager:show("neckTechAttrPandectView")
end
function neckTechViewPanel:onClick_Button_item(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.itemID
	uiManager:show("CommonSourceGuide", nil)
end
return neckTechViewPanel
