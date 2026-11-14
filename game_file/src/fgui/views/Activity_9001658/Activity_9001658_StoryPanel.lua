local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001658_StoryPanel = class("Activity_9001658_StoryPanel", baseFguiPanel)
function Activity_9001658_StoryPanel:ctor(...)
	Activity_9001658_StoryPanel.super.ctor(self, ...)
	print("Activity_9001658_StoryPanel:ctor", self.viewName)
	self.debug = true
end
function Activity_9001658_StoryPanel:onInit()
	print("=======Activity_9001658_StoryPanel:onInit")
	local storyID = self.param and self.param.storyID
	if storyID == 1 then
		self.fields.Text_story1:setString(i18n("BUBBLE_LEGEND_TEXT_134"))
		self.fields.Text_story2:setString(i18n("BUBBLE_LEGEND_TEXT_135"))
		self.transitions.t3_out:play(1, 7.8, function(...)
			self:closePanel()
		end)
	else
		self.fields.Text_story1:setString(i18n("BUBBLE_LEGEND_TEXT_136"))
		self.fields.Text_story2:setString(i18n("BUBBLE_LEGEND_TEXT_137"))
		self.transitions.t2_play:play(1, 4, function(...)
			self:closePanel()
		end)
	end
end
function Activity_9001658_StoryPanel:onShow()
	print("=======Activity_9001658_StoryPanel:onShow")
end
function Activity_9001658_StoryPanel:onHide(...)
	local callback = self.param and self.param.callback
	if callback then
		callback()
	end
end
return Activity_9001658_StoryPanel
