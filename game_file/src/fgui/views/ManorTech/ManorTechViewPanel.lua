local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ManorTechViewPanel = class("ManorTechViewPanel", baseFguiPanel)
function ManorTechViewPanel:ctor(...)
	self.isLRU = true
	ManorTechViewPanel.super.ctor(self, ...)
	print("ManorTechViewPanel:ctor", self.viewName)
end
function ManorTechViewPanel:onInit()
	print("=======ManorTechViewPanel:onInit")
	self.fields.Com_title:initData(i18n("GardenBuild_Name_03"), handler(self, self.onClickClose))
	self.fields.Button_attr:setTitle(i18n("gemEnchant_text_01"))
	self.fields.Button_attr:addClickListener(handler(self, self.onClick_Button_attr))
end
function ManorTechViewPanel:endShow()
	print("=======ManorTechViewPanel:endShow")
	self.fields.techMap:init()
	self:initView()
end
function ManorTechViewPanel:initView()
	self.fields.techMap:initData()
	self:updateStudy()
end
function ManorTechViewPanel:updateStudy(target, data)
	self.queue = technologyCtrl:studyingTechnology(gQueueTypeDef.garden_technology)
	self.controllers.c1:setSelectedIndex(self.queue and 1 or 0)
	if self.queue then
		self.fields.Com_studying:initData(self.queue)
	end
end
function ManorTechViewPanel:onClick_Button_attr(context)
	SoraDPlaySound()
	uiManager:show("ManorTechPandect")
end
return ManorTechViewPanel
