local baseComponent = require("fgui.base.baseComponent")
local com_Meteorite_strategys = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MeteoriteMagicCan/com_Meteorite_strategys", com_Meteorite_strategys)
local meteorMagicRead = include("meteorMagicRead")
function com_Meteorite_strategys:onInit()
end
function com_Meteorite_strategys:onShow()
end
function com_Meteorite_strategys:initData(title, nebulaList)
	self.fields.title:setString(title)
	for i, v in ipairs(nebulaList) do
		local cfg = meteorMagicRead.getMagicTree(v)
		self.fields["strategy" .. i]:setTitle(i18n(cfg.name))
		self.fields["strategy" .. i]:setIcon(cfg.icon)
	end
end
return com_Meteorite_strategys
