local baseComponent = require("fgui.base.baseComponent")
local castleSkinNightBase = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CastleSkin/castleSkinNightBase", castleSkinNightBase)
fgui.register_extension("ui://CastleSkin/castleSkinNight_71", castleSkinNightBase)
fgui.register_extension("ui://CastleSkin/castleSkinNight_72", castleSkinNightBase)
fgui.register_extension("ui://CastleSkin/castleSkinNight_73", castleSkinNightBase)
fgui.register_extension("ui://CastleSkin/castleSkinNight_74", castleSkinNightBase)
fgui.register_extension("ui://CastleSkin/castleSkinNight_75", castleSkinNightBase)
fgui.register_extension("ui://CastleSkin/castleSkinNight_76", castleSkinNightBase)
fgui.register_extension("ui://CastleSkin/castleSkinNight_77", castleSkinNightBase)
fgui.register_extension("ui://CastleSkin/castleSkinNight_78", castleSkinNightBase)
fgui.register_extension("ui://CastleSkin/castleSkinNight_79", castleSkinNightBase)
fgui.register_extension("ui://CastleSkin/castleSkinNight_80", castleSkinNightBase)
fgui.register_extension("ui://CastleSkin/castleSkinNight_81", castleSkinNightBase)
fgui.register_extension("ui://CastleSkin/castleSkinNight_82", castleSkinNightBase)
fgui.register_extension("ui://CastleSkin/castleSkinNight_82_ros", castleSkinNightBase)
function castleSkinNightBase:onInit()
	self:setTouchEnabled(false)
end
function castleSkinNightBase:onShow()
end
function castleSkinNightBase:init(cfg)
end
function castleSkinNightBase:getTintSkin()
	return self.fields.castle_light, self.fields.Node_criSp
end
return castleSkinNightBase
