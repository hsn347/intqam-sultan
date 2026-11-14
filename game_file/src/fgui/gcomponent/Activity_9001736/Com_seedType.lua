local manorFarmRead = include("manorFarmRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_seedType = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001736/Com_seedType", Com_seedType)
function Com_seedType:onInit()
	self.fields.title:setString(i18n("common_text_635"))
end
function Com_seedType:onShow()
end
function Com_seedType:initData(seedType)
	if seedType == 0 then
		self.controllers.ctrlType:setSelectedIndex(0)
	else
		self.controllers.ctrlType:setSelectedIndex(1)
		local imageName = manorFarmRead.getSeedTypeIcon(seedType)
		self.fields.icon:setURL(imageName)
	end
end
return Com_seedType
