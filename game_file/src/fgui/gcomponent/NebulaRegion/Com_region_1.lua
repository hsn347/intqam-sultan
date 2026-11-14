local nebulaEmperorRead = include("nebulaEmperorRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_region_1 = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://NebulaRegion/Com_region_1", Com_region_1)
fgui.register_extension("ui://NebulaRegion/Com_region_2", Com_region_1)
fgui.register_extension("ui://NebulaRegion/Com_region_3", Com_region_1)
fgui.register_extension("ui://NebulaRegion/Com_region_4", Com_region_1)
fgui.register_extension("ui://NebulaRegion/Com_region_5", Com_region_1)
fgui.register_extension("ui://NebulaRegion/Com_region_6", Com_region_1)
fgui.register_extension("ui://NebulaRegion/Com_region_7", Com_region_1)
fgui.register_extension("ui://NebulaRegion/Com_region_8", Com_region_1)
fgui.register_extension("ui://NebulaRegion/Com_region_9", Com_region_1)
fgui.register_extension("ui://NebulaRegion/Com_region_10", Com_region_1)
function Com_region_1:onInit()
	local _fields = fguiHelper.get_fields(self.fields.title)
	self.Com_regionTitle = _fields.Com_regionTitle
	self.Com_regionTitle:setVisible(false)
end
function Com_region_1:onShow()
end
function Com_region_1:updateRegionTitle(titleID)
	self.Com_regionTitle:setVisible(true)
	local name = nebulaEmperorRead.getOfficerName(titleID)
	local icon = nebulaEmperorRead.getOfficerImg2(titleID)
	self.Com_regionTitle:setString(name)
	self.Com_regionTitle:setIcon(icon)
end
return Com_region_1
