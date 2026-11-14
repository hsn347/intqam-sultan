local heroArtifactItem = class("heroArtifactItem", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroArtifactItem")
	end
	return target
end)
function heroArtifactItem:ctor()
	self.spSkill = SoraDGetChildByName(self, "Sprite_skill")
	self.txtLv = SoraDGetChildByName(self, "Text_lv")
	self.btnSkill = SoraDGetChildByName(self, "Button_skill")
	self.btnSkill:addTouchEventListener(handler(self, self.btnSkillClick))
	self.btnSkill:setSwallowTouches(false)
end
function heroArtifactItem:initData(armsData)
	self.spSkill:setSpriteFrame(include("equipDesRead").getArtifactIcon(armsData[1].armsID))
	self.txtLv:setString(tostring(armsData[1].level))
end
function heroArtifactItem:btnSkillClick(button, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	else
		self.singleIsMoved = false
	end
end
return heroArtifactItem
