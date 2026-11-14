local baseComponent = require("fgui.base.baseComponent")
local Com_title = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://WeaponEnhance/Com_title", Com_title)
function Com_title:onInit()
	_ENV = nil
	_ENV = nil
	;(nil).title = i18n("equipment_training_text_07")
	;(nil)[gQualityDef.LEGEND], (nil).index = nil, 0
	_ENV = nil
	;(nil).title = i18n("common_text_4621")
	;(nil)[gQualityDef.NEBULA], (nil).index = nil, 0
	_ENV = nil
	;(nil).title = i18n("equipment_training_text_06")
	self.titleCfg, (nil)[gQualityDef.ORANGE], (nil).index = nil, nil, 1
end
function Com_title:onShow()
end
function Com_title:initData(quality)
	self.fields.title:setString(self.titleCfg[quality].title)
	self.controllers.c1:setSelectedIndex(self.titleCfg[quality].index)
end
return Com_title
