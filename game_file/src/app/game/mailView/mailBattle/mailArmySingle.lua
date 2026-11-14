local armyDesRead = include("armyDesRead")
local mailArmySingle = class("mailArmySingle", function(target)
	return SoraDCreateBasePanel("mailArmySingle")
end)
function mailArmySingle:ctor()
	self:setCascadeOpacityEnabled(true)
	self.labelName = SoraDGetChildByName(self, "Text_armyName")
	self.labelCount = SoraDGetChildByName(self, "Text_armyCount")
	self.spriteLevel = SoraDGetChildByName(self, "Sprite_armyLevel")
	self.spriteHead = SoraDGetChildByName(self, "Sprite_armyHead")
	self.spriteWarLv = SoraDGetChildByName(self, "Sprite_warLv")
	self.labelWarLv = SoraDGetChildByName(self, "Text_warLv")
	self.imgLine = SoraDGetChildByName(self, "Image_line")
	self.imgUp = SoraDGetChildByName(self, "Image_up")
	if self.imgUp then
		self.imgUp:setVisible(false)
	end
end
function mailArmySingle:initData(armyData)
	self.labelName:setString(armyDesRead.getName(armyData.armyId))
	self.spriteHead:setSpriteFrame(armyDesRead.getIcon(armyData.armyId))
	self.spriteLevel:setSpriteFrame(armyDesRead.getLvImg(armyData.armyId))
	self.spriteWarLv:setVisible(armyDesRead.getWarLv(armyData.armyId) > 0)
	self.labelWarLv:setVisible(armyDesRead.getWarLv(armyData.armyId) > 0)
	self.labelWarLv:setString(armyDesRead.getWarLv(armyData.armyId))
	self.labelCount:setString(string.formatnumberthousands(armyData.num))
end
function mailArmySingle:setStarVisible(ret)
	self.imgUp:setVisible(ret)
end
function mailArmySingle:setNameColor(color)
	self.labelName:setColor(color)
end
function mailArmySingle:setNumColor(color)
	self.labelCount:setColor(color)
end
function mailArmySingle:setLineImage(spName)
	self.imgLine:setContentSize(cc.size(563, 6))
	self.imgLine:loadTexture(spName, ccui.TextureResType.plistType)
end
return mailArmySingle
