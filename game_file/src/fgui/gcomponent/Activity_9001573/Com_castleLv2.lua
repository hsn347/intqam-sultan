local buildLogic = include("buildLogic")
local cityltCtrl = include("cityltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_castleLv2 = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Activity_9001573/Com_castleLv2", Com_castleLv2)
function Com_castleLv2:onInit()
end
function Com_castleLv2:onShow()
	self.fields.Text_starLv:setColor(self.fields.title:getColor())
end
function Com_castleLv2:initData(castleLv, starLv)
	self:setCastleLv(castleLv)
	self:setBuildStarLv(starLv)
end
function Com_castleLv2:setCastleLv(castleLv)
	local warLv = buildLogic.transformBuildLvToWarLv(castleLv)
	local castleImg = "icon_castle.png"
	if 1 <= warLv then
		castleLv = warLv
		castleImg = "icon_warlevel.png"
	end
	self.fields.icon:setURL(castleImg)
	self.fields.title:setString(tostring(math.min(castleLv, 30)))
end
function Com_castleLv2:setBuildStarLv(starLv)
	self.starLv = starLv
	local enable = starLv and 0 < starLv
	self.fields.Group_starLv:setVisible(enable)
	if enable then
		self.fields.Sprite_starLv:setURL(cityltCtrl.getBuildStarImage(starLv))
		self.fields.Text_starLv:setString(tostring(starLv))
	end
end
function Com_castleLv2:resetViewWidth(...)
	local enable = self.starLv and self.starLv > 0
	if enable then
		self:setViewWidth(120)
	else
		self:setViewWidth(70)
	end
end
return Com_castleLv
