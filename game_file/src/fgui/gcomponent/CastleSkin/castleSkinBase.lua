_ENV = nil
;(nil)[BUILD_CASTLE_MODEL.BALLOON] = true
;(nil)[BUILD_CASTLE_MODEL.TENYEAR] = true
;(nil)[BUILD_CASTLE_MODEL.TENYEAR_ROS] = true
;(nil)[BUILD_CASTLE_MODEL.RADAR] = true
;(nil)[BUILD_CASTLE_MODEL.SNOW_CASTLE] = true
;(nil)[BUILD_CASTLE_MODEL.KOH2026RAMADAN] = true
;(nil)[BUILD_CASTLE_MODEL.WORLD_CUP_2026] = true
local (nil)[BUILD_CASTLE_MODEL.ELEVEN_YEAR], spModel = true, nil
local baseComponent = require("fgui.base.baseComponent")
local castleSkinBase = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CastleSkin/castleSkinBase", castleSkinBase)
fgui.register_extension("ui://CastleSkin/castleSkin_71", castleSkinBase)
fgui.register_extension("ui://CastleSkin/castleSkin_72", castleSkinBase)
fgui.register_extension("ui://CastleSkin/castleSkin_73", castleSkinBase)
fgui.register_extension("ui://CastleSkin/castleSkin_74", castleSkinBase)
fgui.register_extension("ui://CastleSkin/castleSkin_75", castleSkinBase)
fgui.register_extension("ui://CastleSkin/castleSkin_76", castleSkinBase)
fgui.register_extension("ui://CastleSkin/castleSkin_77", castleSkinBase)
fgui.register_extension("ui://CastleSkin/castleSkin_78", castleSkinBase)
fgui.register_extension("ui://CastleSkin/castleSkin_79", castleSkinBase)
fgui.register_extension("ui://CastleSkin/castleSkin_80", castleSkinBase)
fgui.register_extension("ui://CastleSkin/castleSkin_81", castleSkinBase)
fgui.register_extension("ui://CastleSkin/castleSkin_82", castleSkinBase)
fgui.register_extension("ui://CastleSkin/castleSkin_82_ros", castleSkinBase)
function castleSkinBase:onInit()
	self:setTouchEnabled(false)
end
function castleSkinBase:onShow()
end
function castleSkinBase:getTintSkin()
	return self.fields.Image_castle, self.fields.Node_spine, self.fields.Node_criSp
end
function castleSkinBase:init(castleModel)
	self.castleModel = castleModel
end
function castleSkinBase:setDayStyle()
	if spModel[self.castleModel] then
		self.fields.Node_criSp:setVisible(true)
	end
end
function castleSkinBase:setNightStyle()
	print("setNightStyle", self.castleModel, spModel[self.castleModel])
	if spModel[self.castleModel] then
		self.fields.Node_criSp:setVisible(false)
	end
end
function castleSkinBase:removeRelation()
end
return castleSkinBase
