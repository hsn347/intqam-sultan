local baseComponent = require("fgui.base.baseComponent")
local ComSeedType = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://ManorFarm/ComSeedType", ComSeedType)
function ComSeedType:onInit()
	self.fields.title:setString(i18n("common_text_635"))
end
function ComSeedType:onShow()
end
function ComSeedType:initData(index, icon, num)
	self.controllers.ctrlType:setSelectedIndex(index == 0 and 0 or 1)
	self.fields.icon:setURL(icon)
	self.type = index
	if num then
		self.fields.txtNum:setString(num)
		self.controllers.ctrlNum:setSelectedIndex(1)
	else
		self.controllers.ctrlNum:setSelectedIndex(0)
	end
end
return ComSeedType
