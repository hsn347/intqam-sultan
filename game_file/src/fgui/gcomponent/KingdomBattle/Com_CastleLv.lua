local cityltCtrl = include("cityltCtrl")
local buildLogic = include("buildLogic")
local baseComponent = require("fgui.base.baseComponent")
local Com_CastleLv = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://KingdomBattle/Com_CastleLv", Com_CastleLv)
function Com_CastleLv:onInit()
end
function Com_CastleLv:onShow()
end
function Com_CastleLv:initData(castleLv, starLv)
	self:setCastleLv(castleLv)
	self:setBuildStarLv(starLv)
end
function Com_CastleLv:setCastleLv(castleLv)
	local warLv = buildLogic.transformBuildLvToWarLv(castleLv)
	local castleImg = "icon_castle.png"
	if 1 <= warLv then
		castleLv = warLv
		castleImg = "icon_warlevel.png"
	end
	self.fields.Image_castle:setURL(castleImg)
	self.fields.Text_Lv:setString(tostring(math.min(castleLv, 30)))
end
function Com_CastleLv:setBuildStarLv(starLv)
	local enable = starLv and 0 < starLv
	self.fields.Node_starLv:setVisible(enable)
	if enable then
		self.fields.Sprite_starLv:setSpriteFrame(cityltCtrl.getBuildStarImage(starLv))
		self.fields.Text_StarLv:setString(tostring(starLv))
	end
end
return Com_CastleLv
