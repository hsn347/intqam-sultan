local buildLogic = include("buildLogic")
local cityltCtrl = include("cityltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_castleLv = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://NebulaWarTeam/Com_castleLv", Com_castleLv)
function Com_castleLv:onInit()
end
function Com_castleLv:onShow()
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
	self.fields.icon:setURL(castleImg)
	self.fields.title:setString(tostring(math.min(castleLv, 30)))
end
function Com_castleLv:setBuildStarLv(starLv)
	self.starLv = starLv
	local enable = starLv and 0 < starLv
	self.fields.Group_starLv:setVisible(enable)
	if enable then
		self.fields.Sprite_starLv:setURL(cityltCtrl.getBuildStarImage(starLv))
		self.fields.Text_starLv:setString(tostring(starLv))
	end
end
function Com_castleLv:resetViewWidth(...)
	local enable = self.starLv and self.starLv > 0
	if enable then
		self:setViewWidth(120)
	else
		self:setViewWidth(70)
	end
end
return Com_castleLv
