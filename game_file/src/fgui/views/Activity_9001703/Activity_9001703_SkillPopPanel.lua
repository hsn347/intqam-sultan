local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001703_SkillPopPanel = class("Activity_9001703_SkillPopPanel", baseFguiPanel)
function Activity_9001703_SkillPopPanel:ctor(...)
	self.isLRU = true
	Activity_9001703_SkillPopPanel.super.ctor(self, ...)
	print("Activity_9001703_SkillPopPanel:ctor", self.viewName)
	self.isCantCloseByReturn = true
end
function Activity_9001703_SkillPopPanel:onInit()
	print("=======Activity_9001703_SkillPopPanel:onInit")
	self.fields.Label_title:setString(i18n("balloon_hunter_020"))
	self.fields.Text_tip:setString(i18n("balloon_hunter_021"))
	self.fields.List_skill:setItemRenderer(handler(self, self.onSkillRenderer))
end
function Activity_9001703_SkillPopPanel:onSkillRenderer(index, obj)
	obj:initData(self.skillData[index + 1], self)
end
function Activity_9001703_SkillPopPanel:endShow()
	print("=======Activity_9001703_SkillPopPanel:endShow")
	self.callback = self.param and self.param.callback
	self.skillData = self.param.randomSkill
	self.fields.List_skill:setNumItems(#self.skillData)
end
function Activity_9001703_SkillPopPanel:onHide()
	if self.callback then
		self.callback()
	end
end
return Activity_9001703_SkillPopPanel
