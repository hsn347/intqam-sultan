local manorFarmRead = include("manorFarmRead")
local baseComponent = require("fgui.base.baseComponent")
local btnFarmFilter = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://ManorFarm/btnFarmFilter", btnFarmFilter)
function btnFarmFilter:onInit()
end
function btnFarmFilter:onShow()
end
function btnFarmFilter:initType(type)
	self.type = type
	self.controllers.ctrlType:setSelectedIndex(0)
	self:setIcon(manorFarmRead.getSeedTypeIcon(type))
end
function btnFarmFilter:initQuality(quality)
	self.quality = quality
	self.controllers.ctrlType:setSelectedIndex(1)
	self.fields.title:setString(manorFarmRead.getQualityName(quality))
end
return btnFarmFilter
