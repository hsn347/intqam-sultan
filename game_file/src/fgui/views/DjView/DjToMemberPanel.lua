local djCtrl = SoraDGetCtrl("djCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DjToMemberPanel = class("DjToMemberPanel", baseFguiPanel)
function DjToMemberPanel:ctor(...)
	self.isLRU = true
	DjToMemberPanel.super.ctor(self, ...)
	print("DjToMemberPanel:ctor", self.viewName)
end
function DjToMemberPanel:onInit()
	print("=======DjToMemberPanel:onInit")
	self.fields.Button_apply:setTitle(i18n("Anchor_text_145"))
	self.fields.Button_apply:addClickListener(handler(self, self.onClick_Button_apply))
	self.fields.Button_list:setTitle(i18n("Anchor_text_146"))
	self.fields.Button_list:addClickListener(handler(self, self.onClick_Button_list))
	self.fields.Button_remove:setTitle(i18n("Anchor_text_147"))
	self.fields.Button_remove:addClickListener(handler(self, self.onClick_Button_remove))
end
function DjToMemberPanel:endShow()
	print("=======DjToMemberPanel:endShow")
	if not djCtrl:getRoomSetData() then
		local _ENV, roomSetData = djCtrl:getRoomSetData(), djCtrl:getRoomSetData()
	end
	self.data = self.param.data
	self.offset = 0
	local djTitle = roomSetData.title or ""
	local djDes = roomSetData.topic or ""
	if djTitle == "" and djDes == "" then
		self.offset = 95
	end
	self.fields.bg:setPositionY(340 - self.offset)
	self.controllers.c1:setSelectedIndex(self.data and 1 or 0)
end
function DjToMemberPanel:onClick_Button_apply(context)
	SoraDPlaySound()
	uiManager:show("DjSearch")
	self:close()
end
function DjToMemberPanel:onClick_Button_list(context)
	SoraDPlaySound()
	uiManager:show("DjApplyList")
	self:close()
end
function DjToMemberPanel:onClick_Button_remove(context)
	SoraDPlaySound()
	djCtrl:reqKickSpeak(self.data.uid)
	self:close()
end
return DjToMemberPanel
