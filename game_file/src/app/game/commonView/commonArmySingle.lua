local armyDesRead = include("armyDesRead")
local commonArmySingle = class("commonArmySingle", function(luaFileName)
	if "userdata" == type(luaFileName) then
		return luaFileName
	else
		return SoraDCreateBasePanel("commonArmySingle")
	end
end)
function commonArmySingle:ctor()
	self.labelName = SoraDGetChildByName(self, "Text_armyName")
	self.labelCount = SoraDGetChildByName(self, "Text_armyCount")
	self.labelCurCount = SoraDGetChildByName(self, "Text_armyCurCount")
	if self.labelCurCount then
		self.labelCurCount:setVisible(false)
	end
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
function commonArmySingle:initData(armyData)
	if self.labelName then
		self.labelName:setString(armyDesRead.getName(armyData.id))
	end
	if self.labelCount then
		self.labelCount:setString(string.formatnumberthousands(armyData.num))
	end
	if self.spriteHead then
		self.spriteHead:setSpriteFrame(armyDesRead.getIcon(armyData.id))
	end
	if self.spriteLevel then
		self.spriteLevel:setSpriteFrame(armyDesRead.getLvImg(armyData.id))
	end
	if self.spriteWarLv then
		self.spriteWarLv:setVisible(armyDesRead.getWarLv(armyData.id) > 0)
	end
	if self.labelWarLv then
		self.labelWarLv:setVisible(armyDesRead.getWarLv(armyData.id) > 0)
		self.labelWarLv:setString(armyDesRead.getWarLv(armyData.id))
	end
	if self.labelCurCount and armyData.snum then
		self.labelCurCount:setVisible(true)
		self.labelCurCount:setString(string.formatnumberthousands(armyData.snum))
		self.labelCount:setString("/" .. string.formatnumberthousands(armyData.num))
		self:setNumColor(cc.c3b(255, 255, 255))
		if SoraDFIsRA() then
			self.labelCount:setPositionX(self.labelCurCount:getPositionX() + self.labelCurCount:getContentSize().width)
		else
			self.labelCurCount:setPositionX(self.labelCount:getPositionX() - self.labelCount:getContentSize().width)
		end
		self.labelCurCount:setColor(armyData.snum == 0 and cc.c3b(190, 40, 40) or cc.c3b(255, 255, 255))
	end
end
function commonArmySingle:setStarVisible(ret)
	self.imgUp:setVisible(ret)
end
function commonArmySingle:setNameColor(color)
	self.labelName:setColor(color)
end
function commonArmySingle:setNumColor(color)
	self.labelCount:setColor(color)
end
function commonArmySingle:setArmyNum(num)
	self.labelCount:setString(num)
end
function commonArmySingle:hideLine()
	self.imgLine:setVisible(false)
end
return commonArmySingle
