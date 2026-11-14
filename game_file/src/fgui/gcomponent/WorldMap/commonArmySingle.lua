local armyDesRead = include("armyDesRead")
local baseComponent = require("fgui.base.baseComponent")
local commonArmySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WorldMap/commonArmySingle", commonArmySingle)
function commonArmySingle:onInit()
	self:fixChildrenPos()
	self.fields.n12:fixPos()
end
function commonArmySingle:onShow()
end
function commonArmySingle:initData(armyData)
	if self.fields.Text_armyName then
		self.fields.Text_armyName:setString(armyDesRead.getName(armyData.id))
	end
	if self.fields.Text_armyCount then
		self.fields.Text_armyCount:setString(string.formatnumberthousands(armyData.num))
	end
	if self.fields.Sprite_armyHead then
		self.fields.Sprite_armyHead:setSpriteFrame(armyDesRead.getIcon(armyData.id))
	end
	if self.fields.Sprite_armyLevel then
		self.fields.Sprite_armyLevel:setSpriteFrame(armyDesRead.getLvImg(armyData.id))
	end
	if self.fields.Text_warLv then
		self.fields.Text_warLv:setVisible(armyDesRead.getWarLv(armyData.id) > 0)
		self.fields.Text_warLv:setString(armyDesRead.getWarLv(armyData.id))
	end
	if self.fields.Text_armyCurCount and armyData.snum then
		self.fields.Text_armyCurCount:setVisible(true)
		self.fields.Text_armyCurCount:setString(string.formatnumberthousands(armyData.snum))
		self.fields.Text_armyCount:setString("/" .. string.formatnumberthousands(armyData.num))
		self:setNumColor(cc.c3b(255, 255, 255))
		self.fields.Text_armyCurCount:setColor(armyData.snum == 0 and cc.c3b(190, 40, 40) or cc.c3b(255, 255, 255))
	end
end
function commonArmySingle:setNameColor(color)
	self.fields.Text_armyName:setColor(color)
end
function commonArmySingle:setNumColor(color)
	self.fields.Text_armyCount:setColor(color)
end
function commonArmySingle:setArmyNum(num)
	self.fields.Text_armyCount:setString(num)
end
function commonArmySingle:hideLine()
	self.fields.Image_line:setVisible(false)
end
return commonArmySingle
