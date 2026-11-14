local baseComponent = require("fgui.base.baseComponent")
local Com_wallEffect = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TowerDefend/Com_wallEffect", Com_wallEffect)
function Com_wallEffect:onInit()
	self.fields.Ani_wall_damage:setAllFrameName("dh_Tex_XL_yan01_%03d.png", 0)
	self.fields.Ani_wall_damage:setPlaySettings(1, -1, -1, -1)
end
function Com_wallEffect:setPlay(flag)
	self.fields.Ani_wall_damage:setPlaying(flag)
end
function Com_wallEffect:onShow()
end
return Com_wallEffect
