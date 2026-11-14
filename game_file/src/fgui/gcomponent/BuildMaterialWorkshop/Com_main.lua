local equipDesRead = include("equipDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_main = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildMaterialWorkshop/Com_main", Com_main)
function Com_main:onInit()
end
function Com_main:onShow()
end
function Com_main:initData(setQuality)
	for i, v in ipairs(equipDesRead.getFactoryList(setQuality)) do
		local target = self.fields["Com_single" .. i]
		target:initData(v)
	end
end
return Com_main
