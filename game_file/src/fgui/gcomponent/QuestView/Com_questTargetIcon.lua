local baseComponent = require("fgui.base.baseComponent")
local Com_questTargetIcon = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://QuestView/Com_questTargetIcon", Com_questTargetIcon)
function Com_questTargetIcon:onInit()
	self:hiddleTargetIcon()
	self.fields.icon_state:fixPos()
end
function Com_questTargetIcon:onShow()
end
function Com_questTargetIcon:hiddleTargetIcon()
	self.fields.icon_target:setVisible(false)
	self.fields.icon_state:setVisible(false)
end
function Com_questTargetIcon:setTargetIconDate(questStyle)
	self:hiddleTargetIcon()
	if questStyle.IconTarget then
		self.fields.icon_target:setVisible(true)
		self.fields.icon_target:setSpriteFrame(questStyle.IconTarget)
	end
	if questStyle.IconState then
		self.fields.icon_state:setVisible(true)
		self.fields.icon_state:setSpriteFrame(questStyle.IconState)
	end
end
return Com_questTargetIcon
