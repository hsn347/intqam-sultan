local activity_9001703_Read = include("activity_9001703_Read")
local activity_9001703_Ctrl = SoraDGetCtrl("activity_9001703_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001703_SkillPanel = class("Activity_9001703_SkillPanel", baseFguiPanel)
function Activity_9001703_SkillPanel:ctor(...)
	self.isLRU = true
	Activity_9001703_SkillPanel.super.ctor(self, ...)
	print("Activity_9001703_SkillPanel:ctor", self.viewName)
end
function Activity_9001703_SkillPanel:onInit()
	print("=======Activity_9001703_SkillPanel:onInit")
	self.fields.Panel_bg:setString(i18n("balloon_hunter_018"))
	self.fields.Text_none:setString(i18n("balloon_hunter_019"))
	self.fields.Text_none:setVisible(false)
	self.fields.List_skill:setItemRenderer(handler(self, self.onSkillRenderer))
end
function Activity_9001703_SkillPanel:onSkillRenderer(index, obj)
	obj:initData(self.skillShow[index + 1])
end
function Activity_9001703_SkillPanel:endShow()
	print("=======Activity_9001703_SkillPanel:endShow")
	self.skillShow, _ENV, self.callback = self.param.callback, self.param.callback, self.param.callback
	local skillShowCfg = activity_9001703_Read.getSkillShowCfg()
	for _, v in ipairs(skillShowCfg) do
		if activity_9001703_Ctrl:getSkillLv(v.skillId) > 0 then
			table.insert(self.skillShow, v.skillId)
		end
	end
	self.fields.List_skill:setNumItems(#self.skillShow)
	self.fields.Text_none:setVisible(#self.skillShow == 0)
end
function Activity_9001703_SkillPanel:onHide()
	if self.callback then
		self.callback()
	end
end
return Activity_9001703_SkillPanel
