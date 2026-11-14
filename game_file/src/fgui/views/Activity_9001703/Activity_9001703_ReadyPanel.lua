local activity_9001703_Read = include("activity_9001703_Read")
local activity_9001703_Ctrl = SoraDGetCtrl("activity_9001703_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001703_ReadyPanel = class("Activity_9001703_ReadyPanel", baseFguiPanel)
function Activity_9001703_ReadyPanel:ctor(...)
	self.isLRU = true
	Activity_9001703_ReadyPanel.super.ctor(self, ...)
	print("Activity_9001703_ReadyPanel:ctor", self.viewName)
end
function Activity_9001703_ReadyPanel:onInit()
	print("=======Activity_9001703_ReadyPanel:onInit")
	self.fields.Panel_bg:setString(i18n("balloon_hunter_047"))
	self.fields.List_skill:setItemRenderer(handler(self, self.onSkillRenderer))
	self.fields.Text_num:fixPos()
	self.fields.icon_coin:fixPos()
end
function Activity_9001703_ReadyPanel:onSkillRenderer(index, obj)
	obj:initData(index + 1)
end
function Activity_9001703_ReadyPanel:endShow()
	print("=======Activity_9001703_ReadyPanel:endShow")
	self:initView()
end
function Activity_9001703_ReadyPanel:initView()
	local coinNum = activity_9001703_Ctrl:getCoinNum()
	activity_9001703_Ctrl = nil
	;(nil).num = coinNum
	self.fields.Text_num:setString(i18n("balloon_hunter_015", nil))
	self.skillData = activity_9001703_Read.getBasicSkillCfg()
	self.fields.List_skill:setNumItems(#self.skillData)
end
return Activity_9001703_ReadyPanel
