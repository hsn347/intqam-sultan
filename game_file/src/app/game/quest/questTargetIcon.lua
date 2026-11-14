local QuestTargetIcon = class("questTargetIcon", function(target)
	if target == nil then
		return SoraDCreateBasePanel("questTargetIcon")
	end
	return target
end)
function QuestTargetIcon:ctor()
	self:hiddleTargetIcon()
end
function QuestTargetIcon:hiddleTargetIcon()
	SoraDGetChildByName(self, "icon_bg"):setVisible(false)
	SoraDGetChildByName(self, "icon_target"):setVisible(false)
	SoraDGetChildByName(self, "icon_state"):setVisible(false)
end
function QuestTargetIcon:setTargetIconDate(questStyle)
	self:hiddleTargetIcon()
	if questStyle.IconTarget then
		self.icon_target = SoraDGetChildByName(self, "icon_target")
		self.icon_target:setVisible(true)
		self.targetFarme = cc.SpriteFrameCache:getInstance():getSpriteFrame(questStyle.IconTarget)
		self.icon_target:setSpriteFrame(self.targetFarme)
	end
	if questStyle.IconState then
		self.icon_state = SoraDGetChildByName(self, "icon_state")
		self.icon_state:setVisible(true)
		self.stateFarme = cc.SpriteFrameCache:getInstance():getSpriteFrame(questStyle.IconState)
		self.icon_state:setSpriteFrame(self.stateFarme)
	end
end
return QuestTargetIcon
