local allianceDesRead = include("allianceDesRead")
local AllianceBuildConditionSingle = class("allianceBuildConditionSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceBuildConditionSingle")
	end
	return target
end)
function AllianceBuildConditionSingle:ctor()
	self.singleData, _ENV = nil, nil
	self.spriteIcon = SoraDGetChildByName(self, "Sprite_icon")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.nodeAim = SoraDGetExtendChildFromCCSByName(self, "CCS_commonProgressBar_bar")
end
function AllianceBuildConditionSingle:initData(singleData)
	self.singleData = singleData
	self.labelDes:setString(allianceDesRead.getBuildConditionDes(self.singleData.id, self.singleData.aim))
	self.spriteIcon:setSpriteFrame(allianceDesRead.getBuildConditionIcon(self.singleData.id))
	self.spriteIcon:setScale(74 / self.spriteIcon:getContentSize().height)
	allianceDesRead = 74 / self.spriteIcon:getContentSize().height
	;(74 / self.spriteIcon:getContentSize().height).maxValue = self.singleData.aim
	;(74 / self.spriteIcon:getContentSize().height).curValue = self.singleData.cur
	self.nodeAim:setProgressDate(74 / self.spriteIcon:getContentSize().height)
end
return AllianceBuildConditionSingle
