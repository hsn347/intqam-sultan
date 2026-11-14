local warShelterCtrl = SoraDGetCtrl("warShelterCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ShelterApplyPanel = class("ShelterApplyPanel", baseFguiPanel)
function ShelterApplyPanel:ctor(...)
	self.isLRU = true
	ShelterApplyPanel.super.ctor(self, ...)
	print("ShelterApplyPanel:ctor", self.viewName)
end
function ShelterApplyPanel:onInit()
	print("=======ShelterApplyPanel:onInit")
	self.fields.Panel_bg:setString(i18n("friend_btn_03"))
	self.fields.Label_title:setString(i18n("war_shelter_019"))
	self.fields.Text_open:setString(i18n("common_text_246"))
	self.fields.Text_close:setString(i18n("common_text_247"))
	self.fields.Text_tip:setString(i18n("war_shelter_020"))
	self.fields.Text_none:setString(i18n("war_shelter_030"))
	self.fields.Text_none:setVisible(false)
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Check_tick_open:addClickListener(handler(self, self.btnOpenClick))
	self.fields.Check_tick_close:addClickListener(handler(self, self.btnCloseClick))
	self.view:fixChildrenPos()
end
function ShelterApplyPanel:onItemRenderer(index, obj)
	obj:initData(self.applyList[index + 1], self)
end
function ShelterApplyPanel:btnOpenClick()
	SoraDPlaySound()
	self.controllers.c1:setSelectedIndex(0)
	if not self.isOpen then
		self.isOpen = not self.isOpen
		warShelterCtrl:reqRecvInviteEnable(true)
	end
end
function ShelterApplyPanel:btnCloseClick()
	SoraDPlaySound()
	self.controllers.c1:setSelectedIndex(1)
	if self.isOpen then
		self.isOpen = not self.isOpen
		warShelterCtrl:reqRecvInviteEnable(false)
	end
end
function ShelterApplyPanel:updateUI(target, data)
	SoraDCloseLoading(self)
	self.applyList = warShelterCtrl:getRecvInviteList()
	self.fields.List:setNumItems(#self.applyList)
	self.fields.Text_none:setVisible(#self.applyList == 0)
end
function ShelterApplyPanel:endShow()
	print("=======ShelterApplyPanel:endShow")
	self.isOpen = warShelterCtrl:getRecvInviteEnable()
	self.controllers.c1:setSelectedIndex(self.isOpen and 0 or 1)
	warShelterCtrl:reqRecvInviteMap()
	SoraDShowLoading(self)
end
return ShelterApplyPanel
