local baseComponent = require("fgui.base.baseComponent")
local Com_detail = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WorldMap/Com_detail", Com_detail)
function Com_detail:onInit()
	self.fields.title_yj:setTitle(i18n("res_name_yiji"))
	self.fields.title_boss:setTitle(i18n("remains_optimize_text3"))
	self.fields.title_shz:setTitle(i18n("remains_optimize_text1"))
end
function Com_detail:onShow()
	self.fields.Com_yj:initYJData()
	for i = 1, 4 do
		self.fields["Com_boss" .. i]:initBossData(i)
	end
	self.fields.Com_shz:initSHZData()
end
return Com_detail
