local cityltCtrl = include("cityltCtrl")
local buildLogic = include("buildLogic")
local baseComponent = require("fgui.base.baseComponent")
local Com_castleLv = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonNew/Com_castleLv", Com_castleLv)
function Com_castleLv:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.fields.Image_castle:setPositionX(0)
	end
end
function Com_castleLv:onShow()
	self.fields.Text_starLv:setFontSize(self.fields.title:getFontSize())
	self.fields.Text_starLv:setColor(self.fields.title:getColor())
end
function Com_castleLv:initData(castleLv, starLv)
	self:setCastleLv(castleLv)
	self:setBuildStarLv(starLv)
end
function Com_castleLv:setCastleLv(castleLv)
	local warLv = buildLogic.transformBuildLvToWarLv(castleLv)
	local castleImg = "icon_castle.png"
	if 1 <= warLv then
		castleLv = warLv
		castleImg = "icon_warlevel.png"
	end
	self.fields.Image_castle:setURL(castleImg)
	self.fields.title:setString(tostring(math.min(castleLv, 30)))
end
function Com_castleLv:setBuildStarLv(starLv)
	local enable = starLv and 0 < starLv
	self.fields.Sprite_starLv:setVisible(enable)
	self.fields.Text_starLv:setVisible(enable)
	if enable then
		self.fields.Sprite_starLv:setSpriteFrame(cityltCtrl.getBuildStarImage(starLv))
		self.fields.Text_starLv:setString(tostring(starLv))
	end
end
function Com_castleLv:setTextLvColor(color)
	self.fields.title:setColor(color)
	self.fields.Text_starLv:setColor(color)
end
return Com_castleLv
