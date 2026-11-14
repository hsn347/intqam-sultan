local buildLogic = include("buildLogic")
local cityltCtrl = include("cityltCtrl")
local commonCastleLvStarLv = class("commonCastleLvStarLv", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonCastleLvStarLv")
	end
	return target
end)
function commonCastleLvStarLv:ctor()
	self:initWidget()
end
function commonCastleLvStarLv:initWidget()
	self.Image_castle = SoraDGetChildByName(self, "Image_castle")
	self.Text_lv = SoraDGetChildByName(self, "Text_lv")
	self.Node_starLv = SoraDGetChildByName(self, "Node_starLv")
	self.Sprite_starLv = SoraDGetChildByName(self.Node_starLv, "Sprite_starLv")
	self.Text_starLv = SoraDGetChildByName(self.Node_starLv, "Text_starLv")
end
function commonCastleLvStarLv:initData(castleLv, starLv)
	self:setCastleLv(castleLv)
	self:setBuildStarLv(starLv)
end
function commonCastleLvStarLv:setCastleLv(castleLv)
	local warLv = buildLogic.transformBuildLvToWarLv(castleLv)
	local castleImg = "icon_castle.png"
	if 1 <= warLv then
		castleLv = warLv
		castleImg = "icon_warlevel.png"
	end
	SoraChangeSpriteImage(self.Image_castle, castleImg)
	self.Text_lv:setString(tostring(math.min(castleLv, 30)))
end
function commonCastleLvStarLv:setBuildStarLv(starLv)
	local enable = starLv and 0 < starLv
	self.Node_starLv:setVisible(enable)
	if enable then
		self.Sprite_starLv:setSpriteFrame(cityltCtrl.getBuildStarImage(starLv))
		self.Text_starLv:setString(tostring(starLv))
	end
end
function commonCastleLvStarLv:setTextLvColor(color)
	self.Text_lv:setColor(color)
	self.Text_starLv:setColor(color)
end
return commonCastleLvStarLv
